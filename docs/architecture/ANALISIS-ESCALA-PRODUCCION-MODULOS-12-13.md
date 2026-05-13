# Análisis de escala — Módulos 12 y 13 con datos reales de producción

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Contexto:** Los análisis originales de los Módulos 12 y 13 se ejecutaron sobre un
entorno de ejemplo con datos de seed. Este documento re-evalúa cada decisión con
los volúmenes reales documentados del sistema IVR en producción.

---

## Volúmenes del entorno de ejemplo vs producción

| Capa | Ejemplo (seed) | Producción (real documentado) | Factor |
|---|---|---|---|
| `tbl_historico` por quarter | 131,247 filas | 11,643,679 – 13,612,375 filas | ×88–×104 |
| Backfill 6 quarters | — | 65,198,171 filas totales | — |
| `base_ivr_detalle` por quarter | ~2,700 filas | 10,000 – 60,000 filas (estimado) | ×4–×22 |
| `base_ivr_clientes` por quarter | 3 filas | 3 filas | ×1 (fijo) |
| Centros distintos por segmento | 28–38 | 50–200+ (estimado) | ×2–×7 |

El dato más importante: **la tabla fuente crece ×88, pero `base_ivr_detalle`
solo crece en proporción al número de VDN únicos y combinaciones `menu × opción`**,
que la documentación cifra en ~126 combinaciones reales. El ETL agrega, no copia.
Los SPs de reporte operan sobre `base_ivr_detalle`, no sobre `tbl_historico`.

---

## Por qué este análisis es distinto al del ejemplo

En el entorno de ejemplo el costo de cualquier operación parece trivial porque
todo el sistema tiene 131,247 filas fuente. La pregunta relevante es: a escala
real, ¿los diseños de los Módulos 12 y 13 introducen algún cuello de botella, o
los supuestos de bajo impacto siguen siendo válidos?

---

## Módulo 12 — EXCEPT e INTERSECT en `sp_etl_validar`

### Dónde se ejecuta en el flujo

`sp_etl_validar` es el PASO 5 de `sp_etl_maestro`. Se invoca después de que
`sp_etl_base_detalle` ha cargado todos los datos del quarter en `base_ivr_detalle`.
A escala de producción, ese paso anterior tarda ~4.5 minutos procesando 11.6M filas.

### Qué datos consultan los checks EXCEPT e INTERSECT

```sql
-- Check 4 — EXCEPT
SELECT segmento FROM base_ivr_detalle WHERE trimestre = p_quarter
GROUP BY segmento
EXCEPT
SELECT segmento FROM base_ivr_clientes WHERE trimestre = p_quarter;

-- Check 5 — INTERSECT
SELECT segmento FROM base_ivr_detalle WHERE trimestre = p_quarter
GROUP BY segmento
INTERSECT
SELECT segmento FROM base_ivr_clientes WHERE trimestre = p_quarter;
```

Las consultas leen `base_ivr_detalle` — la tabla agregada, no `tbl_historico`.

### Análisis de costo a escala real

| Dimensión | Ejemplo | Producción |
|---|---|---|
| Filas escaneadas en `base_ivr_detalle` | ~2,700 | 10,000 – 60,000 |
| Índice disponible | `idx_trim_seg_fecha (trimestre, segmento, fecha)` | Mismo |
| Acceso al índice | Index range scan (covering index) | Mismo |
| Filas después del GROUP BY | 3 (los 3 segmentos) | 3 (fijo) |
| Filas en la operación EXCEPT/INTERSECT | 3 vs 3 | 3 vs 3 |

El índice `idx_trim_seg_fecha` incluye `(trimestre, segmento, fecha)`. La consulta
filtra por `trimestre = p_quarter` y agrupa por `segmento` — el índice la cubre
completamente sin leer el heap. MariaDB lee las entradas del índice para ese
quarter y produce 3 filas distintas.

### La operación EXCEPT/INTERSECT siempre trabaja sobre 3 × 3 filas

El sistema IVR tiene exactamente 3 DIDs registrados (`19020084`, `19028031`,
`19020001`) que mapean a 3 segmentos (`nacional_A`, `nacional_B`, `puebla`). Este
número no depende del volumen de llamadas. Si la producción tiene 100M llamadas
pero los mismos 3 DIDs, `GROUP BY segmento` sigue produciendo 3 filas.

**El costo de los checks 4 y 5 no escala con el volumen de llamadas — escala con
el número de segmentos, que es fijo en 3.**

### Comparativa de tiempo en el pipeline

| Paso | Tiempo estimado en producción |
|---|---|
| PASO 4 — `sp_etl_base_detalle` (11.6M filas) | ~4.5 minutos |
| PASO 4 — `sp_etl_base_clientes` (11.6M filas) | ~4.5 minutos |
| **Checks 1-3** (COUNT, SUM sobre `base_ivr_detalle`) | millisegundos |
| **Check 4 — EXCEPT** (3 vs 3 filas) | microsegundos |
| **Check 5 — INTERSECT** (3 vs 3 filas) | microsegundos |

Los checks EXCEPT e INTERSECT son despreciables en el contexto de un ETL de 9
minutos. Su valor es la detección de un error que el CHECK 2 original no podía
detectar, no la velocidad.

### Conclusión Módulo 12 a escala de producción

Los diseños del Módulo 12 no tienen ningún impacto de rendimiento perceptible en
producción. La corrección de la brecha de validación (segmentos inconsistentes
entre `base_ivr_detalle` y `base_ivr_clientes`) es igualmente válida a cualquier
escala porque el número de segmentos es estructuralmente fijo.

---

## Módulo 13 — `DENSE_RANK()` en `sp_rpt_centros_xsegmento`

### Qué opera el DENSE_RANK

La window function no lee `tbl_historico` ni `base_ivr_detalle` directamente.
Opera sobre el resultado del CTE 2 (`centros_calendario`), que ya tiene una fila
por cada par `(segmento, centro_transferencia)`:

```
tbl_historico (11.6M filas)
        ↓ ETL agrega
base_ivr_detalle (~10,000-60,000 filas por quarter)
        ↓ CTE 1 agrega por (segmento, centro)
centros (N_centros × 3 segmentos filas)
        ↓ CTE 2 añade métricas de calendario
centros_calendario (mismas N_centros × 3 filas)
        ↓ DENSE_RANK() OVER (PARTITION BY segmento ORDER BY total_llamadas DESC)
resultado (N_centros × 3 filas con rango)
```

### Escenarios de escala para N centros distintos

| Escenario | Centros/seg | CTE filas | fn-calls calendario O(1) | fn-calls si usara WHILE O(n) |
|---|---|---|---|---|
| Ejemplo seed | 28 | 84 | 756 | 23,184 |
| Producción moderada | 100 | 300 | 2,700 | 82,800 |
| Producción alta | 300 | 900 | 8,100 | 248,400 |
| Producción extrema | 1,000 | 3,000 | 27,000 | 828,000 |

Cada fila del CTE 2 invoca 3 funciones de calendario:
`ivr_contar_dias_semana × 2` + `ivr_agregar_dias_semana × 1`.

### Por qué FASE 4 es un prerequisito para escalar

A 300 centros por segmento, las funciones de calendario se invocan 8,100 veces.
Con la fórmula O(1) de FASE 4, cada invocación ejecuta aritmética pura — sin
bucle. Con el WHILE original (O(n), ~90 iteraciones por quarter de 92 días),
serían 248,400 iteraciones de WHILE solo para ese SP.

**Las fases 1-4 y la adición de `DENSE_RANK` forman una cadena de dependencias:**

```
FASE 4 (fórmula O(1))
  → convierte 248,400 WHILE-iter en 8,100 operaciones aritméticas
  → hace viable el SP a escala alta de centros

FASE 2 (3 CTEs en sp_rpt_centros_xsegmento)
  → elimina la subconsulta correlacionada (un scan por fila)
  → hace que el SP escale con el volumen de base_ivr_detalle

DENSE_RANK (Módulo 13)
  → añade valor informacional sin costo apreciable
  → opera sobre el resultado ya reducido del CTE (~150-600 filas)
```

### DENSE_RANK se vuelve más importante a mayor escala

Con 28 centros (ejemplo), hay 2 empates (posiciones 24 y 25). Con 300 centros
en producción, la probabilidad de empates en volúmenes medios y bajos aumenta
significativamente porque el espectro de volúmenes bajos (llamadas únicas o de
muy bajo volumen) es más denso.

Con más empates, la diferencia entre `RANK` y `DENSE_RANK` se vuelve más visible:

```
Ejemplo (28 centros, 2 empates):
  RANK:       ...24, 24, 26, 26, 28     (2 brechas)
  DENSE_RANK: ...24, 24, 25, 25, 26     (sin brechas)

Producción alta (300 centros, estimado 15-20 empates):
  RANK:       ...280, 280, 282, 283, 283, 285... (múltiples brechas)
  DENSE_RANK: ...280, 280, 281, 282, 282, 283... (sin brechas)
```

La elección de `DENSE_RANK` es más correcta cuanto mayor es el número de centros.

### El DENSE_RANK no añade costo apreciable

La window function `DENSE_RANK() OVER (PARTITION BY segmento ORDER BY total_llamadas DESC)`
opera sobre el resultado del CTE 2. MariaDB materializa el CTE una vez y aplica
la ventana sobre él. Para 150-600 filas, el sort interno es O(N log N):

```
150 filas × log(50) ≈ 150 × 5.6 ≈ 840 comparaciones por segmento
600 filas × log(200) ≈ 600 × 7.6 ≈ 4,560 comparaciones por segmento
```

Ambas son instantáneas para un motor de base de datos.

### Conclusión Módulo 13 a escala de producción

La adición de `DENSE_RANK` es válida y se vuelve **más correcta** a mayor escala
porque los empates son más frecuentes con más centros. El costo es despreciable.

El cuello de botella real del SP no es el `DENSE_RANK` — es el número de
invocaciones a las funciones de calendario, que FASE 4 resolvió con la fórmula
O(1). Sin FASE 4, el SP podría ser inutilizable a escala alta de centros.

---

## Cuadro resumen

| Componente | Escala ejemplo | Escala producción | Decisión sigue siendo válida |
|---|---|---|---|
| EXCEPT en `sp_etl_validar` | 3 vs 3 filas | 3 vs 3 filas (fijo) | Sí — sin impacto |
| INTERSECT en `sp_etl_validar` | 3 vs 3 filas | 3 vs 3 filas (fijo) | Sí — sin impacto |
| DENSE_RANK en `sp_rpt_centros_xsegmento` | 84 filas | 150–600+ filas | Sí — más importante a mayor escala |
| Funciones calendario O(1) | 756 llamadas | 2,700–27,000 llamadas | Sí — O(1) es el prerequisito |

El factor que cambia con el volumen real **no es ninguna de las decisiones de los
Módulos 12 y 13** — es la cantidad de centros distintos, cuya escala determina
si las funciones de calendario O(1) de FASE 4 eran necesarias (lo eran).
