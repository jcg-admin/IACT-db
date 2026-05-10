# Reporte_cMenu_Agosto_2025.xlsx — Distribución de menús en Agosto 2025

**Origen:** Reporte mensual de distribución de cMenu por segmento
**Cobertura:** Agosto 2025 — segmentos Puebla y Nacional por separado
**Archivo CSV:** `Reporte_cMenu_Agosto_2025.csv`
**Filas:** 70 (25 Puebla + 45 Nacional)

---

## Totales por segmento

| Segmento | Llamadas totales | Menús distintos |
|---|---|---|
| Puebla | 132,473 | 25 |
| Nacional | 2,567,201 | 45 |

La proporción Puebla/Nacional (132K vs 2.56M) confirma la distribución de
DIDs del sistema: Nacional A+B concentra el ~95% del volumen.

---

## Hallazgos críticos

### 1. "Numero Telmex" es el menú más frecuente en Puebla (12.8%)

```
Puebla — Agosto 2025:
  Numero Telmex:    16,909 (12.8%)  ← anomalía crítica
  cliente_colgo:    12,075 (9.1%)
  RES-ContratacionInfinitum_2024: 11,691 (8.8%)
```

"Numero Telmex" es exactamente el tipo de anomalía que `sp_rpt_cMENU_ERROR`
debe detectar: `cMenu` contiene un número de teléfono o identificador
en lugar de un nombre de menú. En Puebla representa el **primer lugar**
por volumen en ese mes.

### 2. RES_FALLA_STOP — menú de alto volumen no documentado anteriormente

```
Nacional:  214,894 llamadas (8.4%) — tercer lugar en Nacional
Puebla:      9,738 llamadas (7.4%)
```

`RES_FALLA_STOP` no aparecía en los scripts de referencia revisados.
Con 214K llamadas en un solo mes de Nacional, es uno de los menús más
relevantes del sistema. Confirmar con el equipo su significado operativo.

### 3. Menús nuevos no vistos anteriormente

Aparecen en este reporte por primera vez:
- `Tmx_SOMO` — Puebla: 5,302 llamadas (4.0%)
- `MASI_RepiteBoleta` — Nacional: 31,792 llamadas (1.2%)
- `NoTMX_SinOp` — Puebla: 1,016 / Nacional: 40,388 llamadas
- `RES-ContratacionInfinitum_FM` — Puebla: 2,786 / Nacional: 24,424
- `RES-SaldosPagos_FM` — Puebla: 350 / Nacional: 3,521
- `MenuSaldosCabecera` — Puebla: 2
- `Saldos3_Otra`, `Saldos1_Pagar` — variantes de saldos

El sufijo `_FM` aparece en dos menús — probablemente indica una variante
de flujo o campaña específica.

### 4. Definición real de abandono en Agosto 2025

Sumando las tres categorías canónicas (D-ETL-006):

**Puebla:**
```
cliente_colgo:       12,075  (9.1%)
NULL/VACIO:          11,592  (8.8%)
SinOpcion_Cabecera:   9,346  (7.1%)
SUBTOTAL:            33,013 (24.9%)
```

**Nacional:**
```
cliente_colgo:      444,438 (17.3%)
NULL/VACIO:         238,049  (9.3%)
SinOpcion_Cabecera:  97,513  (3.8%)
SUBTOTAL:           779,000 (30.3%)
```

Ambos segmentos en el rango "aceptable" (20-30%) con los umbrales
recalibrados de D-ETL-007. Nacional está en el límite superior.

Si se incluye `Marque3` (confirmado como abandono en dataset anterior):
- Puebla: 33,013 + 3,506 = 36,519 (27.6%)
- Nacional: 779,000 + 52,788 = 831,788 (32.4%) → nivel crítico

### 5. ANI y KIPSOLCOM — anomalías de identificación automática

`ANI` (Automatic Number Identification) y `KIPSOLCOM` aparecen en ambos
segmentos con volumen bajo pero consistente. Son casos donde el IVR
registró el tipo de llamada en lugar del menú navegado.

