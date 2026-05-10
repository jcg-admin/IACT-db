# Análisis del reporte c_menu

**Reporte:** `c_menu`
**Archivo de datos:** `docs/referencias/datos-reales/c_menu_Q1Q2Q3_2025.csv`
**Periodo:** Q01_25, Q02_25, Q03_25 — Nacional y Puebla

---

## Descripción

Mapeo de `cMenu` al `cDID_Centro_Transferencia` dominante por quarter y segmento.
Probablemente el SP agrupa por `(trimestre, cDID_800Transfer, cMenu)` y toma el
VDN más frecuente — equivalente a `MODE()` o `MAX BY COUNT`.

Columnas: `trimestre | cDID_800Transfer | cMenu | cDID_Centro_Transferencia`

---

## Hallazgos

### H-1 — cMenu en mixed case — este SP no aplica UPPER(TRIM())

A diferencia de `prom_llamadas` y `llamadas_cmenu` que presentan los menús en
UPPERCASE, este reporte muestra los valores en mixed case tal como están en
`tbl_historico_*`:

```
RES-FallaInternet           (no RES-FALLAINTERNET)
NOTMX-SeguimientoInstalacion (no NOTMX-SEGUIMIENTOINSTALACION)
SinOpcion_Cabecera          (no SINOPCION_CABECERA)
```

Este SP es el único de los analizados que no normaliza `cMenu` a mayúsculas.
Implica que los valores de `cMenu` en la tabla fuente están en mixed case y
que cada SP decide si normalizar o no.

### H-2 — Excel corrompe valores NK90 con notación científica

El reporte fue exportado a Excel, que convierte cadenas numéricas largas a
notación científica irreversiblemente. Los valores afectados:

| Valor en reporte | Tipo | VDN real probable | Afecta a menus |
|---|---|---|---|
| `1.309E+16` | NK90 len_17 | `1309XXX` + tel 10 dig | RES-SaldooPagos, RES-Saldos-WT, RES-SaldosPagos_FM |
| `1.30901E+16` | NK90 len_17 | `1309010` + tel 10 dig | RES-TAE |
| `3.09004E+15` | NK90 len_16 | `309004` + tel 10 dig | RES-SaldosPagos_2024, RES-SaldosPagos_FM (Puebla) |
| `1.30806E+24` | DESCONOCIDO | Valor anómalo — E+24 implica 25 dígitos | RES-Falla-Dish (todos los quarters) |

Los primeros tres son VDNs NK90 confirmados del catálogo de producción.
`1.30806E+24` es anómalo — E+24 implica 25 dígitos, lo que excede cualquier
formato VDN conocido. Podría ser un número con punto decimal interpretado
como separador en la tabla fuente, o una corrupción específica de Excel.

**Implicación:** al procesar este reporte fuera de Excel usar el archivo CSV
original, no la exportación Excel. Los valores NK90 deben manejarse con la
regla `LEFT(val, LENGTH(val)-10)` estándar.

### H-3 — VDN = `'0'` para menús sin transferencia real

Seis menús muestran `cDID_Centro_Transferencia = '0'`:

| Menu | Quarter | Segmento | Interpretación |
|---|---|---|---|
| `ANI` | Q02, Q03 | Puebla | Identificación por ANI — no llega a menú real |
| `Numero Telmex` | Q02 | Puebla | Entrada por número Telmex — no transfiere |
| `default` | Q02 | Puebla | Anomalía de 5 registros |
| `MenuSaldosCabecera` | Q03 | Puebla | Sin transferencia |
| `SaldoCabecera` | Q03 | Puebla | Sin transferencia |
| `Saldos3_Otra` | Q03 | Puebla | Sin transferencia (Nacional usa 14928994) |

Estos registros no tienen un centro de transferencia asignado. El ETL debe
tratarlos como `CASO_ERROR_CEROS` en `cDID_Centro_Transferencia` o
como un sentinel específico dependiendo de la definición del equipo.

Nota: `ANI` en Nacional Q03 mapea a `19020086`, no a `0` — hay diferencia
de comportamiento entre Nacional y Puebla para el mismo menú.

### H-4 — Cambios de VDN entre quarters (evolución del enrutamiento)

Cambios confirmados en el VDN destino de un mismo menú:

| Menú | Segmento | Q01 | Q02 | Q03 |
|---|---|---|---|---|
| `NOTMX-SeguimientoInstalacion` | Nacional+Puebla | `10728487` | `10728487` | **`19020088`** |
| `Desborde_Cabecera` | Nacional | `cliente_colgo` | `10928253` | `cliente_colgo` |
| `Desborde_Cabecera` | Puebla | `10928253` | `10428174` | `15070013` |
| `RES-ContratacionInfinitum` | Nacional | `15070013` | `15070012` | `15070006` |
| `RES-FallaEntretiene` | Nacional | `19020033` | `19020033` | **`10728381`** |
| `RES_Otros` | Nacional | `15070002` | `15070002` | `15070012` |
| `RES-Aparatos` | Nacional | `15070007` | `15070013` | `15070007` |
| `NOTMX-CONT-Portabilidad` | Nacional | `10728485` | `14929014` | `14929014` |

**Crítico — NOTMX-SeguimientoInstalacion Q03:** cambia de `10728487` a `19020088`.
Este es el menú de mayor volumen después de los de abandono. El cambio de VDN
en Q03 puede estar relacionado con el evento operativo de Nacional B.

**Desborde_Cabecera Nacional:** en Q01 enruta a `cliente_colgo` (abandono),
en Q02 a `10928253` (centro real), en Q03 vuelve a `cliente_colgo`. Este
comportamiento inconsistente es relevante para `sp_rpt_llamadas_abandonadas`.

### H-5 — Menús que siempre enrutan a `cliente_colgo`

| Menú | Segmento | Todos los quarters |
|---|---|---|
| `''` (vacío/NULL) | Nacional y Puebla (excepto Puebla Q03 → `0`) | `cliente_colgo` |
| `RES_OcultaVta` | Nacional | `cliente_colgo` |
| `MASI_RepiteBoleta` | Nacional+Puebla | `cliente_colgo` |

`MASI_RepiteBoleta` es un menú que aparece desde Q02 y siempre va a abandono.
El nombre sugiere que el cliente solicitó repetir la boleta pero el sistema no
completa la transferencia.

`Puebla Q03 cMenu vacío` → `0` en lugar de `cliente_colgo` — posiblemente
relacionado con el comportamiento de Pueblo Q03 donde varios menús muestran `0`.

### H-6 — `telefono_cMenu` — 100+ teléfonos como cMenu en Q03, todos a `19020086`

En Q03, el reporte muestra filas individuales por cada número de teléfono
encontrado en `cMenu`. Todos enrutan al mismo VDN: `19020086`.

```
Q03 Nacional: ~100 números de teléfono únicos como cMenu → 19020086
Q03 Puebla:   ~300+ números de teléfono únicos como cMenu → 19020086
```

**Confirmaciones:**
- `19020086` es el bucket de abandono del sistema (usado por `cliente_colgo`,
  `SinOpcion_Cabecera`, `Marque3`, `Desborde_Promocional`).
- Cuando `cMenu` contiene un número de teléfono por error del IVR, la llamada
  es enrutada al bucket de abandono `19020086`.
- El sentinel `'telefono_cMenu'` en los SPs de reporte agrupa todos estos
  números individuales en una sola categoría.

El CSV agrega todas estas filas en una sola fila `telefono_cMenu_AGREGADO`.

### H-7 — VDNs nuevos confirmados por menú y quarter

| Menú | Desde | VDN | Confirmado |
|---|---|---|---|
| `RES_FALLA_STOP` | Q02 | `19010000` | Nacional+Puebla |
| `MASI_RepiteBoleta` | Q02 | `cliente_colgo` | Nacional+Puebla |
| `NoTMX_SinOp` | Q02 | `15070013` | Nacional+Puebla |
| `RES-ContratacionInfinitum_FM` | Q02 | `15070006` | Nacional |
| `Tmx_SOMO` | Q02 | `14929961` | Puebla |
| `KIPSOLCOM` | Q03 | `10928357` | Nacional+Puebla |
| `Saldos1_Pagar` | Q03 | `14928994` | Nacional+Puebla |
| `ANI` | Q02 | `0` (Puebla) / `19020086` (Nacional Q03) | Segmento-dependiente |

---

## Impacto en el seed (`poblar_historico.py`)

### VDN_POR_MENU actualizable con estos datos

Los datos del reporte permiten actualizar el mapeo `VDN_POR_MENU` con VDNs
confirmados de producción:

```python
# Correcciones y adiciones basadas en c_menu Q1-Q3 2025
'MASI_RepiteBoleta':           [('cliente_colgo', 1.0)],     # siempre abandono
'RES_OcultaVta':               [('cliente_colgo', 1.0)],     # siempre abandono
'NoTMX_SinOp':                 [('15070013', 1.0)],
'RES_FALLA_STOP':              [('19010000', 1.0)],
'KIPSOLCOM':                   [('10928357', 1.0)],
'Tmx_SOMO':                    [('14929961', 1.0)],
'Saldos1_Pagar':               [('14928994', 1.0)],
'RES-ContratacionInfinitum_FM':[('15070006', 1.0)],
'ANI':                         [('19020086', 1.0)],          # Nacional
# NOTMX-SeguimientoInstalacion: Q01-Q02 usa 10728487, Q03 usa 19020088
# El seed usa una distribución combinada — actualizar si se necesita por quarter
```

---

## Pendientes abiertos

| ID | Pregunta | Prioridad |
|---|---|---|
| P-NEW-09 | ¿`1.30806E+24` para RES-Falla-Dish es un bug del SP o dato real? | Media |
| P-NEW-10 | ¿El cambio de VDN en NOTMX-SeguimientoInstalacion Q03 está relacionado con el evento operativo de Nacional B? | Alta |
| P-NEW-11 | ¿`VDN=0` para ANI/Numero Telmex/SaldoCabecera debe tratarse como CASO_ERROR_CEROS o como un sentinel propio? | Media |
| P-NEW-12 | ¿Desborde_Cabecera Nacional en Q01/Q03 va a `cliente_colgo` intencionalmente? | Media |

---

## Ver también

- `MAPEO-DID-SEGMENTOS.md` — tabla canónica de DIDs
- `TBL-HISTORICO-ANOMALIAS.md` — anomalías cDID_Centro_Transferencia (NK90, CASO_NULL, etc.)
- `REPORTE-PROM-LLAMADAS.md` — UPPERCASE vs este reporte en mixed case
- `datos-reales/c_menu_Q1Q2Q3_2025.csv`
- `provisioners/mariadb/poblar_historico.py` — VDN_POR_MENU a actualizar

