# Análisis — Módulo 14: Pivoting y Grouping Sets aplicados a IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Motor:** MariaDB 10.11.14-MariaDB-0ubuntu0.24.04.1

---

## Disponibilidad real en MariaDB 10.11.14

El módulo enseña características de T-SQL (SQL Server). La mayoría no existe en
MariaDB con la misma sintaxis, y algunas no existen en absoluto.

| Característica del módulo | MariaDB 10.11.14 | Error observado | Alternativa |
|---|---|---|---|
| `PIVOT ... FOR ... IN (...)` | **NO** — T-SQL únicamente | `ERROR 1064 (42000)` | `SUM(CASE WHEN col='val' THEN ...)` |
| `UNPIVOT` | **NO** — T-SQL únicamente | `ERROR 1064 (42000)` | `UNION ALL` de múltiples SELECTs |
| `GROUP BY GROUPING SETS(...)` | **NO** — no disponible | `ERROR 1064 (42000)` | `UNION ALL` de GROUP BY separados |
| `GROUP BY CUBE(...)` | **NO** — no disponible | `ERROR 1235: not yet supported` | No hay equivalente directo |
| `GROUP BY ROLLUP(...)` | **NO** — sintaxis T-SQL | `ERROR 1630: not a function` | `GROUP BY ... WITH ROLLUP` |
| `GROUP BY ... WITH ROLLUP` | **SÍ** — sintaxis MariaDB | — | Disponible y funcional |
| `GROUPING_ID(col)` | **NO** — función T-SQL | No existe | — |
| `GROUPING(col)` | **NO** — no registrado | `ERROR 1305: not exist` | `COALESCE(col, 'SUBTOTAL')` |

**Resultado:** de todo el módulo, solo `WITH ROLLUP` está disponible sin modificaciones.
El resto requiere emulación o no tiene equivalente.

---

## Restricción adicional de `WITH ROLLUP` en MariaDB

`WITH ROLLUP` no puede combinarse con `ORDER BY` en la misma consulta:

```sql
-- ERROR 1221: Incorrect usage of CUBE/ROLLUP and ORDER BY
GROUP BY segmento, menu WITH ROLLUP ORDER BY segmento;
```

Para ordenar el resultado de un ROLLUP se necesita una subconsulta o CTE envolvente:

```sql
SELECT * FROM (
    SELECT segmento, menu, SUM(total_llamadas) AS llamadas
    FROM base_ivr_detalle
    GROUP BY segmento, menu WITH ROLLUP
) t
ORDER BY segmento, menu;
```

---

## Lo que funciona: `WITH ROLLUP`

`WITH ROLLUP` genera subtotales jerárquicos en una sola query. El orden de las columnas
en el `GROUP BY` define los niveles de la jerarquía — de lo más específico a lo más general.
MariaDB genera filas de resumen con `NULL` en las columnas del nivel superior,
que se reemplazan con `COALESCE` para la presentación.

### Patrón básico — 2 niveles

```sql
SELECT
    COALESCE(segmento, 'TOTAL')  AS segmento
    , COALESCE(menu, 'SUBTOTAL') AS menu
    , SUM(total_llamadas)         AS abandonadas
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
GROUP BY segmento, menu WITH ROLLUP;
```

**Resultado real Q01_25:**
```
segmento     menu                 abandonadas
nacional_A   SinOpcion_Cabecera       1,698
nacional_A   VACIO                    4,410
nacional_A   cliente_colgo           12,278
nacional_A   SUBTOTAL                18,386   ← subtotal del segmento
nacional_B   SinOpcion_Cabecera       1,161
nacional_B   VACIO                    2,876
nacional_B   cliente_colgo            8,163
nacional_B   SUBTOTAL                12,200
puebla       SinOpcion_Cabecera       1,083
puebla       VACIO                    2,276
puebla       cliente_colgo            6,599
puebla       SUBTOTAL                 9,958
TOTAL        SUBTOTAL                40,544   ← gran total
```

La jerarquía tiene exactamente 3 niveles: detalle → subtotal por segmento → gran total.

### Patrón de 3 niveles — trimestre × segmento × menú

```sql
SELECT
    COALESCE(trimestre, 'TOTAL_GLOBAL')  AS trimestre
    , COALESCE(segmento, 'SUBTOTAL_QTR') AS segmento
    , COALESCE(menu,     'SUBTOTAL_SEG') AS menu
    , SUM(total_llamadas)                 AS abandonadas
FROM base_ivr_detalle
WHERE trimestre IN ('Q01_25','Q02_25','Q03_25','Q04_25')
  AND menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
GROUP BY trimestre, segmento, menu WITH ROLLUP;
```

**Extracto del resultado real:**
```
Q01_25   nacional_A  cliente_colgo    12,278
Q01_25   nacional_A  SinOpcion_Cabecera 1,698
Q01_25   nacional_A  VACIO             4,410
Q01_25   nacional_A  SUBTOTAL_SEG     18,386   ← subtotal nacional_A en Q01_25
Q01_25   ...
Q01_25   SUBTOTAL_QTR SUBTOTAL_SEG    40,544   ← subtotal Q01_25 (todos los segmentos)
Q02_25   ...                          32,078   ← subtotal Q02_25
Q03_25   ...                          25,669   ← subtotal Q03_25
Q04_25   ...                          27,874   ← subtotal Q04_25
TOTAL_GLOBAL SUBTOTAL_QTR SUBTOTAL_SEG 126,165  ← gran total 2025
```

El gran total 126,165 es la suma de las 4 subtotales de quarter — verificable
directamente: 40,544 + 32,078 + 25,669 + 27,874 = 126,165.

---

## Aplicación en IACT-db — `WITH ROLLUP`

### Nuevo SP: `sp_rpt_resumen_abandono_rollup`

El SP actual `sp_rpt_llamadas_abandonadas` devuelve solo el nivel de detalle
(segmento × menú). Un SP adicional con `WITH ROLLUP` entrega el resumen completo
en una sola consulta — sin requerir que Django haga tres llamadas separadas
(detalle + subtotales + grand total).

**Aplicable en:** un SP nuevo o vista de resumen ejecutivo. No se modifica
`sp_rpt_llamadas_abandonadas` existente porque su resultado tiene columnas
calculadas (`pct_del_total`, `pct_del_segmento`, `clasificacion_sla`) que son
ambiguas en los niveles de subtotal.

**Valor en producción:** una pantalla de dashboard puede mostrar la jerarquía
completa con una sola llamada a la API Django, sin concatenar múltiples endpoints.

---

## Lo que no funciona: GROUPING SETS y CUBE

### Por qué GROUPING SETS sería útil (y cómo emularlo)

`GROUPING SETS` permitiría calcular en una sola query el total por segmento Y
el total por menú Y el gran total — tres agrupaciones distintas sin relación jerárquica.

```sql
-- SQL Server — NO funciona en MariaDB 10.11.14
GROUP BY GROUPING SETS((segmento), (menu), ())
```

**Emulación en MariaDB con UNION ALL:**

```sql
-- Total por segmento
SELECT 'por_segmento' AS nivel, segmento, NULL AS menu, SUM(total_llamadas) AS llamadas
FROM base_ivr_detalle WHERE trimestre='Q01_25' AND menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
GROUP BY segmento

UNION ALL

-- Total por menu (sin importar segmento)
SELECT 'por_menu', NULL, menu, SUM(total_llamadas)
FROM base_ivr_detalle WHERE trimestre='Q01_25' AND menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
GROUP BY menu

UNION ALL

-- Gran total
SELECT 'grand_total', NULL, NULL, SUM(total_llamadas)
FROM base_ivr_detalle WHERE trimestre='Q01_25' AND menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera');
```

La emulación funciona pero escanea `base_ivr_detalle` tres veces. Con los índices
disponibles (`idx_trim_seg_fecha`, `idx_trim_menu`) el impacto es bajo en producción.

### Por qué CUBE no aplica

`CUBE(segmento, menu)` generaría las 4 combinaciones posibles de agrupación:
`(segmento,menu)`, `(segmento)`, `(menu)`, `()`. Para el caso de IACT-db esto
no tiene utilidad analítica: el total de "todas las llamadas de cliente_colgo
en todos los segmentos combinados" es equivalente al total global que ya entrega
el ROLLUP. La ausencia de CUBE no genera un gap funcional.

---

## Lo que funciona: PIVOT emulado con `SUM(CASE WHEN ...)`

La sintaxis `PIVOT ... FOR ... IN (...)` es T-SQL. MariaDB no la soporta. La
funcionalidad equivalente se logra con agregación condicional:

```sql
-- T-SQL (no funciona en MariaDB):
PIVOT(SUM(total_llamadas) FOR menu IN ([VACIO],[cliente_colgo],[SinOpcion_Cabecera]))

-- MariaDB — equivalente funcional:
SUM(CASE WHEN menu='VACIO'              THEN total_llamadas ELSE 0 END) AS vacio
SUM(CASE WHEN menu='cliente_colgo'      THEN total_llamadas ELSE 0 END) AS cliente_colgo
SUM(CASE WHEN menu='SinOpcion_Cabecera' THEN total_llamadas ELSE 0 END) AS sin_opcion
```

### Aplicación en IACT-db: evolución de abandono por quarter

```sql
SELECT
    menu
    , SUM(CASE WHEN trimestre='Q01_25' THEN total_llamadas ELSE 0 END) AS Q01_25
    , SUM(CASE WHEN trimestre='Q02_25' THEN total_llamadas ELSE 0 END) AS Q02_25
    , SUM(CASE WHEN trimestre='Q03_25' THEN total_llamadas ELSE 0 END) AS Q03_25
    , SUM(CASE WHEN trimestre='Q04_25' THEN total_llamadas ELSE 0 END) AS Q04_25
FROM base_ivr_detalle
WHERE menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
GROUP BY menu
ORDER BY menu;
```

**Resultado real:**
```
menu                Q01_25   Q02_25   Q03_25   Q04_25
SinOpcion_Cabecera   3,942    3,200    3,058    3,231
VACIO                9,562    7,975    7,037    7,750
cliente_colgo       27,040   20,903   15,574   16,893
```

**Insight:** `cliente_colgo` bajó de 27,040 (Q1) a 15,574 (Q3) — una reducción del 42%
en el año. `VACIO` bajó 26%. La comparación horizontal entre quarters no es visible
en el formato fila-por-fila que devuelve el SP actual.

### Aplicación: balance de abandono por segmento y quarter

```sql
SELECT
    trimestre
    , SUM(CASE WHEN segmento='nacional_A'
               THEN total_llamadas ELSE 0 END)  AS nacional_A
    , SUM(CASE WHEN segmento='nacional_B'
               THEN total_llamadas ELSE 0 END)  AS nacional_B
    , SUM(CASE WHEN segmento='puebla'
               THEN total_llamadas ELSE 0 END)  AS puebla
    , SUM(total_llamadas)                        AS total
FROM base_ivr_detalle
WHERE menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
  AND trimestre IN ('Q01_25','Q02_25','Q03_25','Q04_25')
GROUP BY trimestre
ORDER BY trimestre;
```

**Resultado real:**
```
trimestre   nacional_A   nacional_B   puebla   total
Q01_25        18,386       12,200     9,958   40,544
Q02_25        14,332        9,627     8,119   32,078
Q03_25        11,585        7,719     6,365   25,669
Q04_25        12,478        8,435     6,961   27,874
```

**Insight de producción:** `nacional_A` representa consistentemente el 45% del total
de abandonos en todos los quarters. La distribución `45% / 30% / 25%` es estable —
sugiere que es estructural (mayor tamaño de la red nacional_A) y no un problema.

---

## Limitación clave del PIVOT emulado

La sintaxis `SUM(CASE WHEN trimestre='Q01_25' ...)` exige conocer los valores
de la columna a pivotar en tiempo de escritura. En IACT-db los quarters son
conocidos y finitos (`Q01_25` ... `Qn_YY`) — la limitación es manejable.

Si los valores fueran dinámicos (por ejemplo, pivoting por código de centro,
que puede cambiar cada quarter), sería necesario SQL dinámico con `PREPARE`:

```sql
SET @sql = CONCAT('SELECT menu, ',
    GROUP_CONCAT(DISTINCT CONCAT('SUM(CASE WHEN trimestre=''',trimestre,''' THEN total_llamadas ELSE 0 END) AS `', trimestre, '`')
    ORDER BY trimestre),
    ' FROM base_ivr_detalle GROUP BY menu');
PREPARE stmt FROM @sql;
EXECUTE stmt;
```

Para los quarters de IACT-db, el SQL estático es suficiente.

---

## Cuadro de aplicabilidad

| Característica | Disponible | Aplicación en IACT-db |
|---|---|---|
| `PIVOT` (T-SQL) | No | Emular con `SUM(CASE WHEN ...)` — funcional |
| `UNPIVOT` (T-SQL) | No | Emular con `UNION ALL` si se necesita |
| `GROUPING SETS` | No | Emular con `UNION ALL` de GROUP BY separados |
| `CUBE` | No | Sin gap funcional para IACT-db |
| `WITH ROLLUP` | **Sí** | Nuevo SP de resumen ejecutivo con subtotales |
| `GROUPING_ID` / `GROUPING()` | No | Usar `COALESCE(col, 'SUBTOTAL')` |

**Resumen:** el módulo aporta dos patrones concretos a IACT-db:
`WITH ROLLUP` para reportes de resumen jerárquico, y
`SUM(CASE WHEN ...)` como emulación del PIVOT para vistas comparativas entre
quarters o segmentos. El resto del módulo no aplica en MariaDB 10.11.14.
