# Validación del seed contra reportes reales de producción

**Fecha:** 2026-05-06
**Propósito:** Documentar los hallazgos obtenidos al comparar `poblar_historico.py`
contra reportes reales del sistema IVR, las correcciones aplicadas al seed y
las implicaciones para los SPs de reporte.

---

## Reportes analizados

| Reporte | Archivo fuente | Quarter | Total llamadas |
|---|---|---|---|
| `prom_llamadas` | `prom_llamadas_Q1Q2Q3_2025.csv` | Q01, Q02, Q03 | 34,101,981 |

---

## 1. prom_llamadas — Promedio de llamadas por cliente por menú

### Estructura del reporte

```
trimestre | segmento | menu | promedio_llamadas | min | max | total_llamadas
```

`promedio_llamadas` = `total_llamadas` / `COUNT(DISTINCT cTelefono_Origen)` por menú.
El mínimo siempre es 1. Los máximos extremos representan casos reales de
clientes que llamaron cientos de veces en un trimestre.

### Hallazgo 1 — El SP normaliza cMenu a UPPERCASE

Todos los valores de menú en el reporte están en mayúsculas. El SP aplica
`UPPER(TRIM(cMenu))` antes de agrupar.

**Implicación para los SPs de reporte:** cualquier SP que filtre o agrupe por
`menu` debe aplicar `UPPER(TRIM())`. Los datos en `base_ivr_detalle` se
almacenan en mixed-case (`RES-FallaInternet`), pero los reportes presentan
`RES-FALLAINTERNET`. El SP debe manejar esta conversión.

**Alias clave confirmados:**

| En tbl_historico_* (raw) | En el reporte (UPPER) |
|---|---|
| `RES-FallaInternet` | `RES-FALLAINTERNET` |
| `NoTMX_SinOp` | `NOTMX_SINOP` |
| `Tmx_SOMO` | `TMX_SOMO` |
| `SinOpcion_Cabecera` | `SINOPCION_CABECERA` |
| `Numero Telmex` | `NUMERO TELMEX` |
| `MASI_RepiteBoleta` | `MASI_REPITEBOLETA` |
| `SaldoCabecera` | `SALDOCABECERA` |
| `MenuSaldosCabecera` | `MENUSALDOSCABECERA` |

### Hallazgo 2 — Sentinel `telefono_cMenu` (no `MENU_10_NUMEROS`)

El reporte usa `'telefono_cMenu'` como categoría para registros donde `cMenu`
contiene un número de teléfono. Los scripts corregidos usaban `'MENU_10_NUMEROS'`
y `'MENU_11_NUMEROS'`.

**Corrección para `sp_rpt_cMENU_ERROR`:** el SP debe producir `'telefono_cMenu'`
como valor de categoría, consolidando todos los patrones numéricos en un solo
sentinel. El reporte de producción no distingue entre 10 y 11 dígitos.

```sql
-- Producción espera:
CASE
    WHEN (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)
      OR cMenu REGEXP '^[0-9]+'   THEN 'telefono_cMenu'
    ...
END AS tipo_anomalia
```

Volúmenes reales:

| Quarter | Segmento | telefono_cMenu |
|---|---|---|
| Q03_25 | Nacional | 111 |
| Q03_25 | Puebla | 297 |

Ausente en Q01 y Q02 del reporte — o el volumen fue demasiado bajo para
aparecer, o solo se registró a partir de Q03.

### Hallazgo 3 — Total Q3 del reporte ≠ total Q3 del Excel

| Fuente | Q3 total |
|---|---|
| prom_llamadas (reporte) | 8,845,927 |
| Excel DID_Centro_Transferencia | 11,482,117 |
| Diferencia | **2,636,190** |

Q1 y Q2 coinciden exactamente con el Excel. Solo Q3 difiere. La explicación
más probable es el evento operativo de Nacional B documentado en BR-MENU-002:
Nacional B tuvo un volumen dramáticamente reducido en Q3 2025. Los 2.6M
registros de diferencia son de Nacional B que existen en `tbl_historico_t3_2025`
pero que el script que generó el reporte pudo haber excluido con un filtro
diferente al del Excel.

**Implicación para el ETL:** `sp_etl_base_detalle` no debe filtrar Nacional B
(`cDID_800Transfer = 19020001`). Los registros existen y deben procesarse.

### Hallazgo 4 — Segmento `Nacional` = nacional_A + nacional_B (D-23 confirmado)

El reporte presenta `'Nacional'` como un único segmento, combinando los DIDs
`19028031` (Nacional A) y `19020001` (Nacional B). Nunca aparecen separados.

**D-23 confirmado:** los reportes presentados al usuario muestran Nacional
unificado. La separación A/B es interna al ETL y a `base_ivr_detalle`.

### Hallazgo 5 — `DEFAULT` como valor de cMenu (Puebla Q02, 5 registros)

```
Q02_25 | Puebla | DEFAULT | promedio=1.0 | total=5
```

`'DEFAULT'` es una etiqueta de `cOpcion`, no de `cMenu`. Estos 5 registros
probablemente tienen `cOpcion` almacenada en `cMenu` por un error del IVR.
Volumen insignificante — no requiere acción en el ETL.

### Hallazgo 6 — Aparición de menús nuevos por quarter

El catálogo de menús no es estático — crece entre quarters:

| Menú | Primer quarter | Segmento | Volumen aproximado |
|---|---|---|---|
| `RES_FALLA_STOP` | Q02_25 | Nacional+Puebla | 802K Nacional, 61K Puebla |
| `NOTMX_SINOP` | Q02_25 | Nacional+Puebla | 186K Nacional, 4.6K Puebla |
| `MASI_REPITEBOLETA` | Q02_25 | Nacional+Puebla | 106K Nacional |
| `NUMERO TELMEX` | Q02_25 | Puebla (Q03 Nacional) | 55K Puebla Q02 |
| `TMX_SOMO` | Q02_25 | Solo Puebla | 23K Puebla Q02 |
| `ANI` | Q02_25 | Puebla (Q03 Nacional) | 7.4K Puebla Q02 |
| `KIPSOLCOM` | Q03_25 | Nacional+Puebla | 28K Nacional |
| `SALDOCABECERA` | Q03_25 | Solo Puebla | 3.5K Puebla |
| `SALDOS3_OTRA` | Q03_25 | Nacional+Puebla | 272 Nacional |
| `SALDOS1_PAGAR` | Q03_25 | Nacional+Puebla | 21 Nacional |
| `MENUSALDOSCABECERA` | Q03_25 | Solo Puebla | 2 |
| `telefono_cMenu` | Q03_25 | Nacional+Puebla | 408 total |

**Implicación para base_ivr_detalle:** el ETL no necesita un catálogo fijo de
menús — el diseño actual con `ELSE cMenu` en el CASE absorbe cualquier menú
nuevo automáticamente. Confirmado por D-ETL y por la aparición de nuevos
valores en Q02 y Q03.

### Hallazgo 7 — Promedio de llamadas por menú (patrones de comportamiento)

El promedio de llamadas por cliente varía significativamente por menú:

| Rango prom. | Menús representativos | Interpretación |
|---|---|---|
| 1.0–1.3 | `SINOPCION_CABECERA`, `VACIO`, `RES-SALDOS-WT` | Mayoría llama una vez |
| 1.3–1.7 | `CLIENTE_COLGO`, `RES-FALLAINTERNET`, `RES-MADT-DETALLE` | Clientes regulares |
| 1.7–2.0 | `NOTMX-SEGUIMIENTOINSTALACION`, `RES-SALDOOPAGOS` | Siguen su caso |
| 2.0–2.6 | `DESBORDE_CABECERA` (el máximo) | Clientes persistentes |

`DESBORDE_CABECERA` tiene el mayor promedio de todos (2.27 Q01, 2.26 Q02,
2.54 Q03 — crece en Q03). Refleja que los clientes enrutados por desborde
llaman repetidamente.

**Máximos extremos confirmados en producción:**

| Menú | Max Q01 | Interpretación |
|---|---|---|
| `NOTMX-SEGUIMIENTOINSTALACION` | 15,869 | Un cliente llamó ~87 veces/día |
| `CLIENTE_COLGO` | 7,320 | Posible marcación automática |
| `RES-ASISTENCIATELMEXCOM` | 6,789 | Cliente con problema persistente |

Estos valores extremos son reales. `sp_rpt_clientes` debe poder manejarlos.

---

## 2. Correcciones aplicadas al seed (`poblar_historico.py`)

### 2.1 Recalibración de proporciones de menús

Diferencias > 1pp entre seed anterior y producción real:

| Menú | Seed anterior | Producción Q1 | Corrección | Delta |
|---|---|---|---|---|
| `RES-FallaInternet` | 8.0% | **14.2%** | **14.2%** | +6.2pp |
| `NOTMX-SeguimientoInstalacion` | 7.0% | **9.9%** | **9.9%** | +2.9pp |
| `RES-FallasLinea` | **4.9%** | 2.9% | 2.9% | -2.0pp |
| `RES-SaldooPagos` | 3.2% | 4.1% | 4.1% | +0.9pp |
| `VACIO` | 7.0% | 8.0% | 8.0% | +1.0pp |

`RES-FallaInternet` era el error más grande: el seed lo tenía como el 7° menú
(8%) cuando en realidad es el **2° menú más grande de Nacional** con 14.2%.

### 2.2 Proporciones confirmadas (dentro del margen ±0.5pp)

| Menú | Seed | Producción Q1 |
|---|---|---|
| `CLIENTE_COLGO` | 22.0% | 22.5% |
| `DESBORDE_CABECERA` | 13.1% | 13.3% |
| `MARQUE3` | 2.0% | 2.1% |
| `NOTMX-CONT-CONTRATACION` | 2.7% | 2.7% |
| `SINOPCION_CABECERA` | 3.0% | 3.3% |
| `DESBORDE_PROMOCIONAL` | 3.1% | 2.9% |

### 2.3 Validación post-corrección (20K registros)

```
Menú                              %real_Q1  %generado  delta
CLIENTE_COLGO                       22.5%     22.6%   +0.1pp  ✓
RES-FALLAINTERNET                   14.2%     14.4%   +0.2pp  ✓
DESBORDE_CABECERA                   13.3%     13.4%   +0.1pp  ✓
NOTMX-SEGUIMIENTOINSTALACION         9.9%      9.8%   -0.1pp  ✓
VACIO                                8.0%      8.0%   -0.0pp  ✓
RES-MADT-DETALLE                     4.6%      4.7%   +0.1pp  ✓
RES-SALDOOPAGOS                      4.1%      4.0%   -0.1pp  ✓
SINOPCION_CABECERA                   3.3%      3.4%   +0.1pp  ✓
DESBORDE_PROMOCIONAL                 2.9%      2.9%   -0.0pp  ✓
RES-FALLASLINEA                      2.9%      2.9%   -0.0pp  ✓
NOTMX-CONT-CONTRATACION              2.7%      2.5%   -0.2pp  ✓
MARQUE3                              2.1%      2.1%   -0.0pp  ✓
NOTMX-CONT-PORTABILIDAD              1.4%      1.5%   +0.1pp  ✓
```

Todos los menús principales dentro de ±0.2pp tras la corrección.

---

## 3. Impacto en los SPs pendientes de implementar

| SP | Impacto identificado |
|---|---|
| `sp_rpt_clientes` | Debe manejar valores extremos de max_llamadas (15K+) |
| `sp_rpt_cMENU_ERROR` | Usar `'telefono_cMenu'` como sentinel, no `'MENU_10_NUMEROS'` |
| `sp_rpt_menu_centro` | Aplicar `UPPER(TRIM(cMenu))` al agrupar |
| `sp_rpt_llamadas_abandonadas` | `VACIO` = 8% real (no 7%) — umbral de alerta ajustar |
| Todos los SPs de reporte | Presentar `'Nacional'` unificado (D-23), no separar A/B |

---

## 4. Pendientes derivados de este análisis

| ID | Pendiente | Prioridad |
|---|---|---|
| P-NEW-01 | Confirmar con el equipo: ¿Q3 Nacional B fue excluido del reporte intencionalmente? | Alta |
| P-NEW-02 | Confirmar sentinel final: ¿`telefono_cMenu` o separar por longitud? | Media |
| P-NEW-03 | ¿`DEFAULT` como cMenu en Puebla Q02 es un bug del IVR o un menú válido? | Baja |

---

## 5. Ver también

- `TBL-HISTORICO-ANOMALIAS.md` — anomalías de calidad de datos en las tablas fuente
- `ETL-ANALISIS.md` — diseño completo del pipeline ETL
- `datos-reales/prom_llamadas_Q1Q2Q3_2025.csv` — datos fuente de este análisis
- `datos-reales/prom_llamadas_README.md` — análisis técnico del CSV
- `provisioners/mariadb/poblar_historico.py` — seed calibrado con estos hallazgos


---

## 6. clientes_unicos — Clientes únicos por segmento y quarter

**Archivo:** `clientes_unicos_Q1Q2Q3_2025.csv`
**Total declarado:** 9,617,998

### Datos

| Quarter | Segmento | Clientes únicos |
|---|---|---|
| Q01_25 | nacional_B | 3,056,531 |
| Q01_25 | puebla | 155,507 |
| Q02_25 | nacional_A | 2,440,333 |
| Q02_25 | nacional_B | 1,234,307 |
| Q02_25 | puebla | 266,185 |
| Q03_25 | nacional_A | 2,296,002 |
| Q03_25 | nacional_B | 36,756 |
| Q03_25 | puebla | 132,377 |

### Hallazgo 1 — nacional_A AUSENTE en Q01_25

El reporte solo muestra `nacional_B` y `puebla` para Q01. `nacional_A` (DID 19028031)
no aparece. Q02 y Q03 sí tienen los tres segmentos.

### Hallazgo 2 — Q01 `nacional_B` es probablemente `nacional_A` (mislabel)

El valor de Q01 `nacional_B` (3,056,531) es 2.5× mayor que Q02 `nacional_B`
(1,234,307) y no es consistente con la tendencia de `nacional_B` que cae
dramáticamente en Q03 (36,756).

Verificación con ratios llamadas/cliente:

| Quarter | Llamadas Nacional | Clientes Nacional | Ratio |
|---|---|---|---|
| Q01_25 | 11,126,838 | 3,056,531 (solo "B") | **3.64** |
| Q02_25 | 12,783,030 | 3,674,640 (A+B) | **3.48** |
| Q03_25 | 8,422,917 | 2,332,758 (A+B) | **3.61** |

El ratio de Q01 (3.64) es perfectamente consistente con Q02 (3.48) y Q03 (3.61)
**si se asume que el `nacional_B` de Q01 es en realidad `nacional_A`**.

**Causa probable:** El script que generó Q01 tenía el bug `@ONacionalB = 19028031`
(igual que `@ONacionalA`). Esto hizo que la columna `segmento` mostrara `nacional_B`
para registros con DID 19028031 (que es Nacional A), y el real Nacional B
(DID 19020001) quedó excluido del reporte Q01.

**Implicación para sp_rpt_clientes:** el SP debe garantizar que los tres DIDs
estén incluidos y que la etiqueta de segmento sea correcta:

```sql
CASE cDID_800Transfer
    WHEN 19028031 THEN 'nacional_A'   -- no 'nacional_B'
    WHEN 19020001 THEN 'nacional_B'
    WHEN 19020084 THEN 'puebla'
END AS segmento
```

### Hallazgo 3 — Caída dramática de nacional_B en Q03

```
Q02_25 nacional_B: 1,234,307 clientes únicos
Q03_25 nacional_B:    36,756 clientes únicos  (-97%)
```

Confirma el evento operativo de Nacional B documentado en BR-MENU-002: en Q03
el DID 19020001 prácticamente dejó de recibir llamadas. Los 36,756 clientes
únicos de Q03 son residuales — no representa un comportamiento normal.

**Implicación para el ETL:** los SPs no deben filtrar Nacional B. Los datos
existen y son válidos. La reducción es un evento real del negocio, no un
error de datos.

### Hallazgo 4 — Segmentación en lowercase

Este reporte usa `nacional_a`, `nacional_b`, `puebla` (minúsculas).
El reporte `prom_llamadas` usa `Nacional`, `Puebla` (capitalizado, A+B combinados).

Los SPs deben decidir una convención interna consistente. La recomendación
del ETL-ANALISIS.md es `'nacional_A'`, `'nacional_B'`, `'Puebla'`
(mayúscula inicial en el nombre de segmento geográfico, distinguiendo A/B).

### Hallazgo 5 — Definición de clientes únicos: cTelefono_Origen probable

Total llamadas Q1-Q3 (prom_llamadas): 34,101,981
Total clientes únicos (este reporte): 9,617,998
Ratio: ~3.55 llamadas por cliente único por quarter

BR-CLIENT-001 documenta que `sp_rpt_clientes` usa `COUNT(DISTINCT cTelefono_Digitado)`
(número que el cliente ingresó en el IVR). Sin embargo, con 21% de registros
con `cTelefono_Digitado IS NULL`, ese conteo excluiría muchos clientes.

Los ratios calculados (3.5-3.6) son más consistentes con
`COUNT(DISTINCT cTelefono_Origen)` (ANI, siempre presente).

**Pendiente de confirmar (P-NEW-04):** ¿el reporte usa `cTelefono_Origen` o
`cTelefono_Digitado`? La respuesta define qué columna almacena `base_ivr_clientes`.

### Pendientes derivados

| ID | Pregunta | Prioridad |
|---|---|---|
| P-NEW-04 | ¿`clientes_unicos` = COUNT(DISTINCT cTelefono_Origen) o cTelefono_Digitado? | Alta |
| P-NEW-05 | Confirmar con equipo: ¿Q01 `nacional_B` es realmente `nacional_A` (mislabel)? | Alta |
| P-NEW-06 | ¿Existe el dato real de Q01 `nacional_B` (DID 19020001) en algún reporte? | Media |

