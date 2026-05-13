# Análisis profundo — `SUM(SUM(col)) OVER (PARTITION BY ...)` como alternativa a subconsultas correlacionadas

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Contexto:** El análisis del Módulo 13 identificó que `sp_rpt_cMENU_ERROR`,
`sp_rpt_menu_centro` y `sp_rpt_llamadas_abandonadas` tenían subconsultas
correlacionadas "semánticamente equivalentes" a window aggregates. Este documento
corrige esa afirmación con evidencia del motor real.

---

## El patrón `SUM(SUM(col)) OVER (PARTITION BY ...)`

Antes de evaluar cada SP, es necesario entender qué hace este patrón
y por qué su sintaxis parece redundante.

### Los tres niveles de agregación

En MariaDB (y SQL estándar), cuando un `SELECT` tiene `GROUP BY`, cada columna
del resultado representa valores ya agregados. Una window function aplicada a ese
resultado opera sobre los grupos, no sobre las filas originales.

```sql
SELECT
    b.segmento
    , b.menu
    , SUM(b.total_llamadas)                                      AS sum_grupo
    , SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento)  AS sum_segmento
FROM base_ivr_detalle b
WHERE b.trimestre = 'Q01_25'
  AND b.menu REGEXP '^[0-9]+$' AND LENGTH(b.menu) >= 7
GROUP BY b.segmento, b.menu
```

Los tres niveles:

```
Nivel 1 — filas en base_ivr_detalle
         segmento    menu        total_llamadas
         ─────────── ─────────── ──────────────
         nacional_A  4439869720  1              ← fila cruda
         nacional_A  4439869720  1              ← otra fila del mismo grupo
         nacional_A  4438089813  1

Nivel 2 — GROUP BY: SUM(b.total_llamadas)
         Agrega las filas del nivel 1 en grupos (segmento, menu).
         segmento    menu        sum_grupo
         nacional_A  4439869720  2          ← suma de las filas del grupo
         nacional_A  4438089813  1

Nivel 3 — OVER (PARTITION BY b.segmento): SUM(sum_grupo)
         La window function suma los sum_grupo de cada fila
         que comparte el mismo segmento.
         segmento    menu        sum_grupo   sum_segmento
         nacional_A  4439869720  2           55          ← 2+1+...+n = 55
         nacional_A  4438089813  1           55          ← mismo total para toda la partición
```

Resultado verificado en MariaDB 10.11 con datos de Q01_25:
```
nacional_A  4439869720   sum_grupo=1   sum_segmento=55   pct=1.82
nacional_A  4438089813   sum_grupo=1   sum_segmento=55   pct=1.82
```

El `SUM` exterior no agrega los datos originales, sino los resultados ya
agrupados por el `GROUP BY`. La sintaxis de doble `SUM` es la forma en que
SQL expresa "aplica esta función de ventana sobre valores que ya fueron
agregados".

---

## Condición de equivalencia semántica

Una window function es equivalente a una subconsulta correlacionada **si y solo
si** el conjunto de filas sobre el que opera la ventana es el mismo que el
conjunto que la subconsulta consulta.

La window function opera sobre las filas **visibles tras el `WHERE`** de la
consulta exterior. La subconsulta correlacionada puede consultar la tabla con un
`WHERE` propio, de alcance independiente.

```
Equivalentes cuando:
  WHERE de la consulta exterior ≡ WHERE de la subconsulta
  (mismo conjunto de filas, mismos filtros)

No equivalentes cuando:
  WHERE de la consulta exterior ⊂ WHERE de la subconsulta
  (la subconsulta necesita ver MÁS filas que las del resultado)
```

Los tres SPs demuestran los dos casos.

---

## SP 1 — `sp_rpt_cMENU_ERROR`: EQUIVALENTE ✓

### Subconsulta actual

```sql
-- Columna: total_anomalias_quarter
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
   AND b2.menu REGEXP '^[0-9]+$'   -- ← mismo filtro que el exterior
   AND LENGTH(b2.menu) >= 7        -- ← mismo filtro que el exterior
) AS total_anomalias_quarter
```

La subconsulta usa exactamente los mismos filtros que la consulta exterior,
incluidos `REGEXP` y `LENGTH`. No es una subconsulta correlacionada en el
sentido estricto — no hace referencia a columnas del grupo actual. Es un
escalar que calcula el mismo total para todas las filas del resultado.

### Equivalente con window function

```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento) AS total_anomalias_quarter
```

### Verificación en MariaDB 10.11

```
Q01_25 — nacional_A:
  total_subq    = 55
  total_window  = 55    ← idénticos
```

La window function produce el mismo total porque la partición `PARTITION BY
segmento` sobre las filas ya filtradas por `REGEXP` y `LENGTH` tiene exactamente
el mismo alcance que la subconsulta.

---

## SP 2 — `sp_rpt_menu_centro`: EQUIVALENTE ✓

### Subconsulta actual

```sql
-- Columna: pct_del_centro
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        (SELECT SUM(b2.total_llamadas)
         FROM base_ivr_detalle b2
         WHERE b2.trimestre            = p_quarter
           AND b2.centro_transferencia = b.centro_transferencia  -- correlación
           AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
      0) * 100, 2
) AS pct_del_centro
```

El denominador es el total de llamadas de ese `centro_transferencia` a través
de todos sus menús y opciones. La correlación es `b2.centro = b.centro` con el
mismo filtro de segmento que el exterior.

La consulta exterior tiene un `NOT IN` adicional para centros centinela:
```sql
AND b.centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL')
```

La subconsulta no tiene este `NOT IN`. ¿Genera diferencias? No: el `NOT IN`
excluye los centros centinela del resultado, pero la correlación
`b2.centro = b.centro` hace que la subconsulta solo consulte el centro actual.
Si el centro actual pasó el `NOT IN` (es un centro válido), la subconsulta
también busca solo filas de ese centro válido — que no son afectadas por el `NOT IN`.

### Equivalente con window function

```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia) AS total_centro
```

La partición por `centro_transferencia` sobre las filas ya filtradas (`NOT IN`
excluye centinelas) da el mismo total por centro que la subconsulta.

### Verificación en MariaDB 10.11

```
Q01_25 — nacional_A:
  CLIENTE_COLGO:  pct_subq = 45.55  pct_window = 45.55  ✓
  10728487:       pct_subq = 44.79  pct_window = 44.79  ✓
  19020086:       pct_subq = 44.70  pct_window = 44.70  ✓
  10828091:       pct_subq = 45.29  pct_window = 45.29  ✓
```

---

## SP 3 — `sp_rpt_llamadas_abandonadas`: NO EQUIVALENTE ✗

### La subconsulta — alcance deliberadamente más amplio

```sql
-- Columna: pct_del_segmento
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        (SELECT SUM(b3.total_llamadas)
         FROM base_ivr_detalle b3
         WHERE b3.trimestre = p_quarter
           AND b3.segmento  = b.segmento   -- sin filtro de menu
        ),
      0) * 100, 2
) AS pct_del_segmento
```

La consulta exterior filtra solo las llamadas abandonadas:
```sql
WHERE b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
```

La subconsulta **no tiene este filtro**. Consulta el total de **todas** las
llamadas del segmento: abandonadas + no abandonadas.

### Por qué el alcance amplio es correcto

`pct_del_segmento` responde a la pregunta: *¿qué porcentaje del total de llamadas
del segmento fueron abandonadas?* El denominador correcto es el total de
llamadas del segmento — no solo las abandonadas.

Si el denominador fuera solo las abandonadas, el porcentaje sería siempre 100%
(cada menú abandonado sería el 100% de "los abandonados por ese menú"). Eso no
tiene valor analítico. El valor real está en comparar las abandonadas contra
el total.

### Lo que daría una window function

```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento)
```

Esta window function suma `total_llamadas` solo para las filas visibles tras el
`WHERE` de la consulta exterior — es decir, solo las llamadas abandonadas.

### Verificación en MariaDB 10.11

```
Q01_25:
  segmento      total_segmento_subq   total_segmento_window   diferencia
  ──────────    ───────────────────   ─────────────────────   ──────────
  nacional_A         53,879                 18,386              35,493
  nacional_B         35,572                 12,200              23,372
  puebla             29,754                  9,958              19,796
```

La diferencia (35,493 / 23,372 / 19,796) son exactamente las llamadas
**no abandonadas** de cada segmento — las que pasaron por menús distintos
de `VACIO`, `cliente_colgo` y `SinOpcion_Cabecera`.

Con la subconsulta: `pct_del_segmento(nacional_A)` = 18,386 / 53,879 = **34.12%**  
Con la window: sería 18,386 / 18,386 = **100%** — incorrecto.

La tasa de abandono real por segmento, verificada:
```
nacional_A: 18,386 / 53,879 = 34.12%   (KPI correcto)
nacional_B: 12,200 / 35,572 = 34.30%
puebla:      9,958 / 29,754 = 33.47%
```

### Corrección de la afirmación anterior

El análisis del Módulo 13 afirmó que `sp_rpt_llamadas_abandonadas` era
"equivalente". Eso era incorrecto. La diferencia entre el denominador de la
subconsulta (53,879) y el que daría la window function (18,386) no es un
detalle técnico — es la diferencia entre una tasa de abandono significativa
(34%) y un valor sin sentido (100%).

---

## Cuadro de decisión final

| SP | Columna afectada | Veredicto | Razón |
|---|---|---|---|
| `sp_rpt_cMENU_ERROR` | `total_anomalias_quarter` | **Equivalente** | Subq y consulta exterior tienen los mismos filtros |
| `sp_rpt_menu_centro` | `pct_del_centro` | **Equivalente** | Correlación por `centro` con mismo filtro de segmento |
| `sp_rpt_llamadas_abandonadas` | `pct_del_segmento` | **No equivalente** | Denominador requiere todas las llamadas del segmento; la window solo ve las abandonadas |

Para `sp_rpt_llamadas_abandonadas`, si se quisiera eliminar la subconsulta
preservando la semántica correcta, el patrón a usar sería un CTE previo al
`SELECT` principal (como en FASE 2), no una window function:

```sql
-- Opción: CTE que pre-agrega el total por segmento (sin filtro de menu)
WITH totales_segmento AS (
    SELECT segmento, SUM(total_llamadas) AS total_seg
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento)
    GROUP BY segmento
)
SELECT ...,
    ROUND(SUM(b.total_llamadas) / NULLIF(ts.total_seg, 0) * 100, 2) AS pct_del_segmento
FROM base_ivr_detalle b
JOIN totales_segmento ts ON ts.segmento = b.segmento
WHERE b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
...
```

Este patrón es el de FASE 2 (CTE), no el de Módulo 13 (window function).
La variable `v_total_quarter` del SP también podría absorberse con un CTE,
pero el SP actual ya la maneja correctamente como variable escalar.

---

## Cuándo usar cada patrón

| Situación | Patrón recomendado |
|---|---|
| Denominador = total del mismo conjunto filtrado | `SUM(SUM(col)) OVER (PARTITION BY ...)` |
| Denominador = total de un conjunto más amplio | CTE pre-agregado + JOIN (patrón FASE 2) |
| Denominador = total sin ninguna partición | Variable escalar o `SUM(SUM(col)) OVER ()` |

`sp_rpt_llamadas_abandonadas` pertenece al segundo caso. La subconsulta
correlacionada actual es correcta. No debe reemplazarse por una window function.
