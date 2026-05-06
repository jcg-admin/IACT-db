# Anomalías y condiciones de calidad de datos en tbl_historico_t*

**Fecha:** 2026-05-06
**Fuentes:** WPs `2026-05-02-07-12-32-pipeline-uc-deepening`, `2026-05-02-09-54-55-source-corrections-pipeline`, datos reales Q1-Q3 2025, seed `poblar_historico.py`

---

## Propósito de este documento

Las tablas `tbl_historico_tN_YYYY` son propiedad del cliente. IACT solo tiene
acceso de lectura (CNST_007). Los errores y anomalías documentados aquí:

1. **No pueden corregirse** en origen — son datos del sistema IVR del cliente.
2. **Deben replicarse** en el seed de desarrollo para que los SPs, triggers y
   jobs que se diseñen se prueben contra condiciones reales.
3. **Deben manejarse** en los SPs del ETL mediante reglas de normalización
   y workarounds documentados.

El seed `poblar_historico.py` replica las condiciones documentadas en este archivo.

---

## Inventario de anomalías — datos reales Q1 2025 (50K registros seed)

| Anomalía | Registros | % | Replicada en seed |
|---|---|---|---|
| `dHoraInicio > dHoraFin` (invertidas) | 19,256 | 38.5% | Sí (38.8% objetivo) |
| `cMenu IS NULL` / vacío / `sin cMenu` | 3,485 | 6.97% | Sí (incluido en VACIO/abandono) |
| `cMenu` contiene número de teléfono | 607 | 1.21% | Sí (anomalía `__CMENU_ERROR__`) |
| `cDID_Centro_Transferencia` NULL/vacío | 628 | 1.26% | Sí (CASO_NULL) |
| `cDID_Centro_Transferencia = 'cliente_colgo'` | 13,686 | 27.37% | Sí (CLIENTE_COLGO) |
| `cDID_Centro_Transferencia` NK90 len>10 | 1,825 | 3.65% | Sí (len_16, len_18) |
| `cTelefono_Digitado IS NULL` | 10,679 | 21.36% | Sí (21.2% objetivo) |
| `cTelefono_Digitado = cTelefono_Origen` | 13,897 | 27.79% | Sí (28.2% objetivo) |
| `cMenu = 'cliente_colgo'` (abandono) | 10,937 | 21.87% | Sí |
| `cMenu = 'SinOpcion_Cabecera'` | 1,568 | 3.14% | Sí |
| `cDID_Centro_Transferencia` solo ceros | 0 | 0.00% | NO (ver sección 2.4) |
| `cDID_Centro_Transferencia` char no numérico | 0 | 0.00% | NO (ver sección 2.5) |

---

## 1. dHoraInicio > dHoraFin (Bug G-29)

**Identificador:** G-29 (cerrado — causa confirmada)
**Impacto:** 38.8% de los ~34.1M registros (~13.2M afectados en Q1-Q3 2025)
**Estado en seed:** Replicado — `poblar_historico.py` invierte con `P_HORAS_INVERTIDAS = 0.388`

### Descripción

El sistema IVR del cliente registra algunos eventos con `dHoraInicio` posterior
a `dHoraFin`. Esto es imposible en una llamada válida. La causa exacta es
desconocida (posiblemente campos swappeados durante la ingesta en el sistema
NK90 del cliente).

```
Ejemplo de registro con bug:
  dFecha      = 2025-03-15
  dHoraInicio = 2025-03-15 14:35:22   ← POSTERIOR al fin
  dHoraFin    = 2025-03-15 13:58:41   ← ANTERIOR al inicio
```

### Workaround en scripts de producción

Todos los scripts de referencia aplican este CASE para calcular duración:

```sql
CASE
    WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin))
        THEN TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio))
    ELSE
        TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin))
END AS duracion_seg
```

### Limitación del workaround

El ELSE produce resultados incorrectos para llamadas que cruzan medianoche.
Ejemplo: `dHoraInicio = 23:50:00`, `dHoraFin = 00:05:00` debería ser 15 min
pero el workaround da 23h45m. Impacto estimado: < 0.1% de los registros.

### Implicación para los SPs

`sp_rpt_centros_xsegmento` y cualquier SP que calcule duración promedio debe
incluir este CASE. Sin él, el 38.8% de registros producirá valores negativos
al calcular `dHoraFin - dHoraInicio`.

### Replicación en seed

```python
# En poblar_historico.py
if random.random() < P_HORAS_INVERTIDAS:  # 0.388
    ts_fin = base + timedelta(seconds=h - random.randint(5, 890))
# Resultado: dHoraFin < dHoraInicio — replica el bug G-29
```

---

## 2. Anomalías en cDID_Centro_Transferencia (BR-ROUTING-001)

El campo `cDID_Centro_Transferencia` tiene cuatro tipos de valores anómalos
además de los VDNs válidos. Todos requieren normalización en el ETL.

### 2.1 CASO_NULL — campo NULL o vacío (1.26%)

**Causa:** El IVR no registró ningún centro de transferencia. La llamada
terminó antes de que el sistema asignara un destino.

```sql
WHEN TRIM(cDID_Centro_Transferencia) IS NULL
  OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
```

**En datos reales:** 1,514 registros en Q1 (0.01%). El seed tiene un porcentaje
mayor (~1.26%) porque genera NULLs de forma uniforme.

### 2.2 CLIENTE_COLGO — valor literal 'cliente_colgo' (27.37%)

**Causa:** El campo `cDID_Centro_Transferencia` contiene el string literal
`'cliente_colgo'` en lugar de un VDN numérico. Indica que el cliente colgó
antes de que el IVR completara la transferencia.

```sql
WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
```

**Nota importante:** Este case debe evaluarse ANTES de la regla NK90, porque
`LENGTH('cliente_colgo') = 13 > 10` haría que NK90 intentara
`LEFT('cliente_colgo', 3) = 'cli'` — un VDN inválido.

**En seed:** 27.37% (calibrado — en producción real Q1 2025: 12.10% del total
de registros, que es el 82.18% de VDNs + el 12.10% de CLIENTE_COLGO).

### 2.3 Formato NK90 — VDN + teléfono concatenados (3.65%)

**Causa:** La infraestructura de enrutamiento NK90 (en proceso de migración
a IPVR) concatena el VDN real con `cTelefono_Digitado`:

```
cDID_Centro_Transferencia = [VDN][cTelefono_Digitado]

Ejemplo:
  VDN real:         19010000 (8 dígitos)
  cTelefono_Dig:    8190983030 (10 dígitos)
  Campo raw:        190100008190983030 (18 dígitos)
  Post-normaliz.:   19010000 (LEFT(..., 18-10) = LEFT(..., 8))
```

Regla de normalización:

```sql
WHEN LENGTH(cDID_Centro_Transferencia) > 10
    THEN LEFT(cDID_Centro_Transferencia,
              LENGTH(cDID_Centro_Transferencia) - 10)
```

**Longitudes observadas en producción real Q1 2025:**

| Longitud | Registros Q1 | % | Composición |
|---|---|---|---|
| 8 dígitos | 9,568,639 | 82.18% | VDN directo (dominante) |
| 13 chars | 1,408,555 | 12.10% | `'cliente_colgo'` (13 chars) |
| 17 dígitos | 620,730 | 5.33% | VDN 7 dig + tel 10 dig (NK90 principal) |
| 16 dígitos | 39,951 | 0.34% | VDN 6 dig + tel 10 dig |
| 6 dígitos | 6 | 0.00% | VDN de 6 dígitos (raro) |
| 0 (NULL) | 1,514 | 0.01% | CASO_NULL |

**En seed:** El script genera NK90 de len_18 (VDN 8 dig + tel 10 dig) en ~6.5%
de los registros con `cTelefono_Digitado` no NULL. La producción real tiene
principalmente len_17 (VDN 7 dig + tel 10 dig). La regla `LENGTH - 10`
cubre ambos casos correctamente.

**Implicación post-migración IPVR:** Una vez completada la migración,
`cDID_Centro_Transferencia` no concatenará el teléfono. La regla NK90
seguirá siendo necesaria para los datos históricos en `tbl_historico_*`.

### 2.4 CASO_ERROR_CEROS — VDN = solo ceros (NO replicado en seed)

**Descripción:** `cDID_Centro_Transferencia` contiene `'0000000'` o similar
(solo dígitos cero). Observado en Puebla Q02-Q03 2025.

```sql
WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
```

**Volumen real:** ~20K-30K registros/mes en Puebla Q02-Q03 (3-4% del total Puebla).
No aparece en Q01. Causa raíz desconocida (P-22 abierto).

**Estado en seed:** NO replicado. El seed actual tiene 0 registros con este caso.
Para replicarlo, agregar en `poblar_historico.py`:

```python
# En gen_registro(), con probabilidad ~0.01 en Puebla
if did == '19020084' and random.random() < 0.01:
    centro_raw = '0000000'  # replica CASO_ERROR_CEROS
```

### 2.5 ERROR_CARACTER_INICIAL — VDN empieza con char no numérico (NO replicado)

**Descripción:** `cDID_Centro_Transferencia` empieza con un carácter no numérico
distinto de `'cliente_colgo'`.

```sql
WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
-- Solo si ya se descartó el case de 'cliente_colgo' antes
```

**Volumen real:** < 20,000 registros en Q1-Q3 2025 (0.05% del total).
Casos poco frecuentes — posiblemente errores de codificación en el IVR.

**Estado en seed:** NO replicado. Volumen tan bajo que no afecta
el comportamiento estadístico del ETL.

---

## 3. Anomalías en cMenu

### 3.1 VACIO — cMenu NULL, vacío o 'sin cMenu' (6.97%)

**Descripción:** El IVR no registró qué menú navegó el cliente. La llamada
terminó sin que se completara la selección del menú.

```sql
WHEN cMenu IS NULL         THEN 'VACIO'
WHEN TRIM(cMenu) = ''      THEN 'VACIO'
WHEN cMenu = 'sin cMenu'   THEN 'VACIO'
```

**Convención (D-24):** El sentinel es `'VACIO'` en mayúsculas. Los scripts
anteriores usaban `'vacio'` (minúsculas) — bug documentado y corregido en
los scripts de referencia corregidos.

**Implicación para el ETL:** `VACIO` es una de las tres categorías de abandono
(D-ETL-006). `base_ivr_detalle` almacena `'VACIO'` como valor de `menu`.

### 3.2 Número de teléfono como cMenu (1.21%) — BR-DATA-001 Forma B

**Descripción:** El IVR almacena directamente el número de teléfono del cliente
en el campo `cMenu`. Es una anomalía del sistema IVR.

```sql
-- Detección en sp_rpt_cMENU_ERROR:
WHERE cMenu REGEXP '^[0-9]+'
  AND cMenu IS NOT NULL
  AND TRIM(cMenu) != ''
```

**Distinción crítica:** `'Numero Telmex'` NO es este caso — es un menú IVR
válido específico de Puebla donde el cliente ingresa su número Telmex como
método de identificación (BR-DATA-001 Forma A). No requiere normalización.

**Volumen en producción real:**

| Trimestre | Segmento | Registros aprox | Impacto |
|---|---|---|---|
| Q03_25 | Nacional | < 500/mes | Mínimo |
| Q02_25 + | Puebla | 16,909/mes (Agosto 2025) | Alto — primer lugar en Puebla |

**En seed:** Replicado en ~1.2% de los registros con el marcador
`'__CMENU_ERROR__'` en `MENUS`, que genera un número telefónico de 10 dígitos
como valor de `cMenu`.

**Implicación:** `sp_rpt_cMENU_ERROR` es crítico para Puebla donde este
tipo de anomalía puede representar hasta el 12.8% del volumen mensual.

### 3.3 cliente_colgo como cMenu (21.87%)

**Descripción:** `cMenu = 'cliente_colgo'` indica que el cliente colgó
durante la navegación del menú IVR. Es la categoría de abandono más grande.

**En datos reales Q1 2025:** 22% del total (Nacional A+B combinado).
Es el primer tipo de abandono por volumen — mayor que VACIO y SinOpcion_Cabecera.

**Implicación:** La definición incorrecta de abandono en los scripts originales
que solo incluía VACIO capturaba ~8-9% del total. Con `cliente_colgo` incluido,
la cobertura sube al ~27-28% real (D-ETL-006, D-ETL-007).

### 3.4 SinOpcion_Cabecera (3.14%)

**Descripción:** El cliente llegó a la cabecera del menú IVR pero no seleccionó
ninguna opción. Es abandono implícito.

**No confundir con:**
- `Desborde_Cabecera` — la llamada SÍ fue enrutada (no es abandono)
- `VACIO` — el cliente nunca llegó a ningún menú

---

## 4. Anomalías en cTelefono

### 4.1 cTelefono_Digitado IS NULL (21.2%)

**Descripción:** El cliente no digitó ningún número cuando el IVR lo solicitó.
Representa llamadas donde el usuario no participó activamente en la identificación
por teléfono.

**Regla de negocio (BR-CLIENT-001):** `no_digito_telefono` en `base_ivr_detalle`.

**Nota sobre el 75.3% del WP:** El AS-IS documenta 75.3% NULL como baseline.
Los datos reales del Excel Q1-Q3 2025 (36.7M llamadas) muestran 21.2% NULL.
La discrepancia se debe a que el AS-IS analizó un segmento específico (probablemente
solo Nacional B en un periodo acotado), no el total consolidado.

### 4.2 cTelefono_Digitado = cTelefono_Origen (misma_linea) (28.2%)

**Descripción:** El número que digitó el cliente en el IVR es el mismo número
desde el que está llamando (número A). Indica que el cliente confirmó su propio
número de teléfono en el sistema IVR.

**Regla de negocio (BR-CLIENT-001):** `misma_linea` en `base_ivr_detalle`.

**Relación con el número A:**
- `cTelefono_Origen` = número A (ANI — siempre capturado automáticamente)
- Cuando `Digitado = Origen`, el cliente confirmó explícitamente su número A

### 4.3 Las tres métricas son mutuamente excluyentes y exhaustivas

```
misma_linea + linea_diferente + no_digito_telefono = COUNT(*)

Para cualquier registro, exactamente UNA de estas condiciones es verdadera:
  - cTelefono_Digitado IS NULL          → no_digito_telefono = 1
  - Digitado IS NOT NULL AND D = O      → misma_linea = 1
  - Digitado IS NOT NULL AND D ≠ O      → linea_diferente = 1
```

---

## 5. Anomalías NO replicadas en el seed actual

Las siguientes condiciones existen en producción pero no están en el seed.
Aplica si se necesitan SPs específicos que las manejen:

| Anomalía | Volumen real | Impacto | Cómo agregar al seed |
|---|---|---|---|
| `CASO_ERROR_CEROS` (cDID solo ceros) | ~20-30K/mes Puebla Q02+ | Bajo-Medio | Agregar en `gen_registro()`: `if did=='19020084' and rand()<0.01: centro='0000000'` |
| `ERROR_CARACTER_INICIAL` | < 20K total Q1-Q3 | Bajo | Agregar en `gen_registro()`: `if rand()<0.0005: centro='@ERROR'` |
| NK90 len_17 como dominante | 5.33% en Q1 | Bajo | El seed genera len_18 (8+10); en prod domina len_17 (7+10). La regla `LENGTH-10` cubre ambos |
| Llamadas que cruzan medianoche | < 0.1% | Bajo | El seed no genera timestamps cerca de medianoche |
| Variantes VDN `2309004` | Pequeño | Bajo | No documentado suficientemente — pendiente P-23 |

---

## 6. Comportamiento del seed actual

El seed `poblar_historico.py` replica fielmente:

```
Condición                              Producción    Seed (50K Q1)   Estado
dHoraInicio > dHoraFin                 38.8%         38.5%           OK ±0.3pp
cTelefono_Digitado IS NULL             21.2%         21.4%           OK ±0.2pp
cTelefono_Digitado = cTelefono_Origen  28.2%         27.8%           OK ±0.4pp
cMenu IS NULL/vacío/sin cMenu          6.97%*        6.97%           OK
cMenu = cliente_colgo                  21.87%*       21.87%          OK
cDID_Centro_Transferencia NULL         1.26%*        1.26%           OK
cDID_Centro_Transferencia NK90         3.65%*        3.65%           OK
cMenu con número de teléfono           1.21%*        1.21%           OK
```

(*) Valores del seed de 50K registros; pueden variar en corridas futuras por aleatoriedad.

Las condiciones marcadas `NO replicado` en la sección 5 no están presentes.
Para aumentar la fidelidad, correr el script con `--rows 100000` reduce el
error estadístico a ±0.15pp en todas las proporciones.

---

## 7. Implicaciones para los SPs

Cada SP debe manejar estas condiciones o puede producir resultados incorrectos:

| SP | Condición crítica | Tratamiento requerido |
|---|---|---|
| `sp_etl_base_detalle` | G-29 horas invertidas | No extrae duración — no afecta |
| `sp_etl_base_detalle` | NK90 en cDID_Centro | CASE de normalización (6 ramas) |
| `sp_etl_base_detalle` | cMenu NULL/vacío | → `'VACIO'` |
| `sp_etl_base_detalle` | cTelefono NULL | → `no_digito_telefono += 1` |
| `sp_rpt_llamadas_abandonadas` | Definición de abandono | `VACIO` + `cliente_colgo` + `SinOpcion_Cabecera` |
| `sp_rpt_centros_xsegmento` | G-29 horas invertidas | CASE ABS para duración |
| `sp_rpt_cMENU_ERROR` | `cMenu REGEXP '^[0-9]+'` | Solo numéricos — excluir NULL/vacío |
| `sp_rpt_menu_centro` | NK90 en cDID_Centro | Usar `centro_transferencia` normalizado de `base_ivr_detalle` |

---

## 8. Referencias

| Identificador | Documento | Descripción |
|---|---|---|
| G-29 | `pipeline-uc-deepening-changelog.md` | Bug de horas invertidas — 38.8% de registros |
| G-30 | `real-db-schema-analysis.md` | `@ONacionalB` mal asignado en scripts de análisis |
| BR-CLIENT-001 | `business-rules-ivr.md` | Identificación del cliente por teléfono |
| BR-ROUTING-001 | `business-rules-ivr.md` | NK90: concatenación de centro y teléfono |
| BR-DATA-001 | `business-rules-ivr.md` | Anomalía telefono_cMenu |
| D-ETL-006 | `decisions.md` | Definición de abandono: VACIO + cliente_colgo + SinOpcion_Cabecera |
| D-ETL-007 | `decisions.md` | Umbrales recalibrados de tasa de abandono |
| D-24 | `business-rules-ivr.md` | Convención VACIO en mayúsculas |
| CNST-ETL-005 | `pipeline-uc-deepening-changelog.md` | Sin índices en tbl_historico — full table scan |
| CNST-ETL-007 | `pipeline-uc-deepening-changelog.md` | MariaDB 10.1.48 — sin window functions |
| P-22 | `business-rules-ivr.md` | CASO_ERROR_CEROS en Puebla Q02+ — causa raíz desconocida |
| P-23 | `business-rules-ivr.md` | VDNs con prefijo 23... — confirmar si son DIDs nuevos |

