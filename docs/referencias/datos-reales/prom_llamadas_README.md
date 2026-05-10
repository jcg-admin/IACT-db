# prom_llamadas — Reporte de promedio de llamadas por cliente

**Archivo:** `prom_llamadas_Q1Q2Q3_2025.csv`
**Origen:** Reporte del sistema de producción — ejecutado sobre tbl_historico_t1/t2/t3_2025
**Total declarado:** 34,101,981 llamadas
**Periodo:** Q01_25, Q02_25, Q03_25 — segmentos Nacional y Puebla

---

## Estructura de columnas

| Columna | Descripción |
|---|---|
| `trimestre` | Quarter: Q01_25, Q02_25, Q03_25 |
| `segmento` | `Nacional` o `Puebla` — Nacional incluye A+B combinados (D-23) |
| `menu` | Valor de cMenu normalizado a UPPERCASE |
| `promedio_llamadas` | Promedio de llamadas por cliente único (cTelefono_Origen) |
| `min_llamadas_x_cliente` | Siempre 1 — mínimo es siempre 1 llamada |
| `max_llamadas_x_cliente` | Máximo de llamadas de un solo cliente en ese menú |
| `total_llamadas` | COUNT(*) por quarter × segmento × menú |

---

## Hallazgos críticos

### 1. El SP normaliza cMenu a UPPERCASE

Todos los valores de menú en el reporte están en mayúsculas:
`CLIENTE_COLGO`, `VACIO`, `RES-FALLAINTERNET`, `DESBORDE_CABECERA`, `NOTMX_SINOP`.

El SP que genera este reporte aplica `UPPER(TRIM(cMenu))`. Los valores en
`tbl_historico_*` están en mixed-case (`RES-FallaInternet`, `NoTMX_SinOp`).
Esto es relevante para los SPs de reporte — deben normalizar antes de
agrupar o comparar.

**Mapeado de alias principales:**

| En tbl_historico_* | En el reporte | Impacto |
|---|---|---|
| `RES-FallaInternet` | `RES-FALLAINTERNET` | UPPER |
| `NoTMX_SinOp` | `NOTMX_SINOP` | UPPER + guion bajo |
| `Tmx_SOMO` | `TMX_SOMO` | UPPER |
| `SinOpcion_Cabecera` | `SINOPCION_CABECERA` | UPPER |
| `Numero Telmex` | `NUMERO TELMEX` | UPPER |
| `MASI_RepiteBoleta` | `MASI_REPITEBOLETA` | UPPER |
| `SaldoCabecera` | `SALDOCABECERA` | UPPER |
| `MenuSaldosCabecera` | `MENUSALDOSCABECERA` | UPPER |

### 2. telefono_cMenu — sentinel real del reporte (no MENU_10_NUMEROS)

El reporte usa `'telefono_cMenu'` (no `'MENU_10_NUMEROS'`/`'MENU_11_NUMEROS'`)
para los registros donde `cMenu` contiene un número de teléfono:

```
Q03_25 Nacional: 111 registros con telefono_cMenu
Q03_25 Puebla:   297 registros con telefono_cMenu
```

**Implicación para sp_rpt_cMENU_ERROR:** el SP debe producir `'telefono_cMenu'`
como valor de la columna de tipo de anomalía, no `'MENU_10_NUMEROS'`.

El seed `poblar_historico.py` usa `__CMENU_ERROR__` internamente y genera
números de teléfono como cMenu. La distinción entre 10 y 11 dígitos existe
en los datos, pero el reporte los agrupa todos como `'telefono_cMenu'`.

### 3. DEFAULT en Puebla Q02_25 — 5 registros (anomalía menor)

```
Q02_25 Puebla DEFAULT: 5 registros, promedio=1.0, max=1
```

`'DEFAULT'` es una etiqueta de cOpcion, no de cMenu. Estos 5 registros
probablemente tienen `cOpcion` almacenada en `cMenu` por un error del IVR.
Volumen insignificante.

### 4. Q3 muestra 2.6M registros menos que el Excel

```
Q3 en reporte:  8,845,927
Q3 en Excel:   11,482,117
Diferencia:     2,636,190
```

Q1 y Q2 coinciden exactamente con el Excel (11.6M y 13.6M). Solo Q3 tiene
diferencia. La causa probable es el evento operativo de Nacional B en Q3 2025
documentado en BR-MENU-002: Nacional B tuvo volumen dramáticamente reducido
(~95K en Sep vs ~4.7M en Q02). Los 2.6M restantes son registros de Nacional B
que existen en `tbl_historico_t3_2025` pero que el script que generó el reporte
puede haber excluido con un filtro diferente.

**Para el ETL:** `sp_etl_base_detalle` debe incluir Nacional B (`19020001`)
en todos los quarters. No filtrar Nacional B.

### 5. Nacional = nacional_A + nacional_B combinados (D-23 confirmado)

El reporte presenta `'Nacional'` como un único segmento, combinando
`19028031` (Nacional A) y `19020001` (Nacional B). Los SPs de reporte
deben ofrecer esta vista combinada. La separación A/B solo es relevante
internamente en el ETL y en tablas base, no en los reportes presentados
al usuario.

---

## Proporciones reales Q1_2025 vs seed (principales menus)

Diferencias > 1pp que requieren ajuste en `poblar_historico.py`:

| Menu | % Real Q1 | % Seed actual | Delta | Acción |
|---|---|---|---|---|
| RES-FallaInternet | **14.17%** | 8.0% | **+6.2pp** | AUMENTAR |
| NOTMX-SeguimientoInstalacion | **9.86%** | 7.0% | **+2.9pp** | AUMENTAR |
| RES-FallasLinea | 2.86% | **4.9%** | **-2.0pp** | REDUCIR |
| RES-SaldooPagos | 4.13% | 3.2% | +0.9pp | aumentar leve |
| VACIO | 8.01% | 7.0% | +1.0pp | aumentar leve |

Diferencias < 0.5pp (dentro del margen estadístico con 50K registros):
`CLIENTE_COLGO`, `DESBORDE_CABECERA`, `MARQUE3`, `NOTMX-CONT-CONTRATACION`,
`SINOPCION_CABECERA`, `DESBORDE_PROMOCIONAL`.

---

## Promedio de llamadas por cliente — rangos reales

Los valores de `promedio_llamadas` son útiles para validar `sp_rpt_clientes`:

| Rango | Ejemplos de menú | Interpretación |
|---|---|---|
| 1.0 – 1.3 | SINOPCION_CABECERA, VACIO, RES-SALDOS-WT | Mayoría llama una sola vez |
| 1.3 – 1.7 | CLIENTE_COLGO, RES-FALLAINTERNET, RES-MADT | Clientes regulares |
| 1.7 – 2.0 | NOTMX-SEGUIMIENTOINSTALACION, RES-SALDOOPAGOS | Clientes que siguen su caso |
| 2.0 – 2.6 | DESBORDE_CABECERA | El mayor promedio — clientes persistentes |

**DESBORDE_CABECERA tiene el mayor promedio** (2.27 Q01, 2.26 Q02, 2.54 Q03).
Esto confirma que los clientes enrutados por desborde llaman más de una vez.

**max_llamadas_x_cliente** extremos:
- `NOTMX-SEGUIMIENTOINSTALACION`: max 15,869 (Q01) — un cliente llamó ~87 veces/día durante el quarter
- `CLIENTE_COLGO`: max 7,320 (Q01) — posible bot o auto-marcado
- Estos valores extremos son reales y el seed debería poder generarlos para pruebas de estrés

---

## Nuevos menús identificados (por quarter de aparición)

| Menu | Primer quarter | Segmento | Nota |
|---|---|---|---|
| `RES_FALLA_STOP` | Q02_25 | Nacional+Puebla | No estaba en Q01 |
| `NOTMX_SINOP` | Q02_25 | Nacional+Puebla | `NoTMX_SinOp` uppercase |
| `MASI_REPITEBOLETA` | Q02_25 | Nacional+Puebla | `MASI_RepiteBoleta` uppercase |
| `NUMERO TELMEX` | Q02_25 | Puebla (Q03 Nacional) | `Numero Telmex` uppercase |
| `TMX_SOMO` | Q02_25 | Puebla | Solo Puebla |
| `ANI` | Q02_25 | Puebla (Q03 Nacional) | |
| `RES-CONTRATACIONINFINITUM_FM` | Q02_25 | Nacional+Puebla | Variante FM |
| `RES-SALDOSPAGOS_FM` | Q02_25 | Nacional+Puebla | Variante FM |
| `KIPSOLCOM` | Q03_25 | Nacional+Puebla | |
| `SALDOCABECERA` | Q03_25 | Puebla | |
| `SALDOS3_OTRA` | Q03_25 | Nacional+Puebla | |
| `SALDOS1_PAGAR` | Q03_25 | Nacional+Puebla | |
| `MENUSALDOSCABECERA` | Q03_25 | Puebla | Solo 2 registros |
| `telefono_cMenu` | Q03_25 | Nacional+Puebla | Sentinel de anomalía |

