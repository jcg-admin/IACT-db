# Análisis del reporte prom_llamadas

**Reporte:** `prom_llamadas`
**Archivo de datos:** `docs/referencias/datos-reales/prom_llamadas_Q1Q2Q3_2025.csv`
**Total declarado:** 34,101,981
**Periodo:** Q01_25, Q02_25, Q03_25 — segmentos Nacional y Puebla

---

## Descripción

Promedio de llamadas por cliente único (`cTelefono_Origen`) por menú, quarter
y segmento. Incluye el valor mínimo (siempre 1), el máximo y el total de llamadas.

---

## Hallazgos

### H-1 — El SP normaliza cMenu a UPPERCASE

Todos los valores de menú están en mayúsculas en el reporte. El SP aplica
`UPPER(TRIM(cMenu))` antes de agrupar. Los datos en `tbl_historico_*` están
en mixed-case.

**Alias principales confirmados:**

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

**Implicación:** todos los SPs de reporte que filtren o muestren `menu`
deben aplicar `UPPER(TRIM())`.

### H-2 — Sentinel `telefono_cMenu` (no `MENU_10_NUMEROS`)

El reporte usa `'telefono_cMenu'` para registros donde `cMenu` contiene
un número de teléfono. No distingue 10 de 11 dígitos.

```
Q03_25 Nacional: 111 registros
Q03_25 Puebla:   297 registros
```

**Implicación para `sp_rpt_cMENU_ERROR`:** producir `'telefono_cMenu'`
como sentinel único, no `'MENU_10_NUMEROS'`/`'MENU_11_NUMEROS'`.

### H-3 — Q3 reporte muestra 2.6M registros menos que el Excel

| Fuente | Q3 total |
|---|---|
| prom_llamadas | 8,845,927 |
| Excel DID_Centro_Transferencia | 11,482,117 |
| Diferencia | 2,636,190 |

Q1 y Q2 coinciden exactamente. La diferencia Q3 corresponde al evento
operativo de Nacional B (DID 19020001) documentado en BR-MENU-002.

**Implicación:** `sp_etl_base_detalle` no debe filtrar Nacional B.

### H-4 — `Nacional` = nacional_A + nacional_B combinados (D-23)

El reporte usa `'Nacional'` unificado. Los SPs de reporte deben presentar
Nacional unificado al usuario. La separación A/B es interna al ETL.

### H-5 — `DEFAULT` como cMenu en Puebla Q02 (5 registros)

Anomalía de datos: 5 registros donde `cMenu = 'DEFAULT'` (un valor de
cOpcion, no de cMenu). No requiere acción en el ETL.

### H-6 — Menús nuevos por quarter

| Menú | Primer quarter | Segmento |
|---|---|---|
| `RES_FALLA_STOP` | Q02_25 | Nacional+Puebla (802K Nacional) |
| `NOTMX_SINOP` | Q02_25 | Nacional+Puebla |
| `MASI_REPITEBOLETA` | Q02_25 | Nacional+Puebla |
| `NUMERO TELMEX` | Q02_25 | Puebla (Q03 → Nacional) |
| `TMX_SOMO` | Q02_25 | Solo Puebla |
| `ANI` | Q02_25 | Puebla (Q03 → Nacional) |
| `KIPSOLCOM` | Q03_25 | Nacional+Puebla |
| `SALDOCABECERA` | Q03_25 | Solo Puebla |
| `SALDOS3_OTRA` / `SALDOS1_PAGAR` | Q03_25 | Nacional+Puebla |
| `telefono_cMenu` | Q03_25 | Nacional+Puebla |

El catálogo de menús crece cada quarter. El diseño `ELSE cMenu` en el ETL
absorbe nuevos valores automáticamente.

### H-7 — DESBORDE_CABECERA tiene el mayor promedio de llamadas

| Menú | Prom Q01 | Prom Q02 | Prom Q03 |
|---|---|---|---|
| DESBORDE_CABECERA | 2.27 | 2.26 | **2.54** |
| NOTMX-SEGUIMIENTOINSTALACION | 2.03 | 1.97 | 1.99 |
| CLIENTE_COLGO | 1.82 | 1.75 | 1.67 |

Clientes enrutados por desborde llaman más frecuentemente. El promedio
crece en Q03 (2.54), indicando mayor persistencia.

**Máximos extremos en producción:**

| Menú | Max llamadas por cliente | Quarter |
|---|---|---|
| NOTMX-SEGUIMIENTOINSTALACION | 15,869 | Q01 |
| CLIENTE_COLGO | 7,320 | Q01 |
| RES-ASISTENCIATELMEXCOM | 8,015 | Q02 |

`sp_rpt_clientes` debe manejar estos valores extremos sin error.

---

## Correcciones al seed aplicadas

Diferencias > 1pp corregidas en `poblar_historico.py`:

| Menú | Antes | Después | Fuente |
|---|---|---|---|
| `RES-FallaInternet` | 8.0% | **14.2%** | Q01_25 Nacional 14.17% |
| `NOTMX-SeguimientoInstalacion` | 7.0% | **9.9%** | Q01_25 Nacional 9.86% |
| `RES-FallasLinea` | 4.9% | **2.9%** | Q01_25 Nacional 2.86% |
| `RES-SaldooPagos` | 3.2% | **4.1%** | Q01_25 Nacional 4.13% |
| `VACIO` | 7.0% | **8.0%** | Q01_25 Nacional 8.01% |

---

## Pendientes abiertos

| ID | Pregunta | Prioridad |
|---|---|---|
| P-NEW-01 | ¿Q3 Nacional B fue excluido del reporte intencionalmente? | Alta |
| P-NEW-02 | ¿Sentinel final: `telefono_cMenu` o separar por longitud? | Media |
| P-NEW-03 | ¿`DEFAULT` como cMenu en Puebla Q02 es bug del IVR? | Baja |

---

## Ver también

- `TBL-HISTORICO-ANOMALIAS.md`
- `ETL-ANALISIS.md`
- `REPORTE-CLIENTES-UNICOS.md`
- `datos-reales/prom_llamadas_Q1Q2Q3_2025.csv`
- `provisioners/mariadb/poblar_historico.py`

