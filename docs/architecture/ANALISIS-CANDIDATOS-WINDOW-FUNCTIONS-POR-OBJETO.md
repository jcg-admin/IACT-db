# Análisis objeto por objeto — candidatos a window functions

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Alcance:** todos los objetos SQL del repositorio IACT-db  
**Corrección incluida:** `sp_rpt_menu_redirigidos` reclasificado de "complejo" a equivalente
(verificado en motor real con los dos escenarios de `p_segmento`).

---

## Inventario de objetos y clasificación

| Objeto | Tipo | Versión | Clasificación |
|---|---|---|---|
| `fn_did_segmento` | FUNCTION | 2.0.0 | No aplica |
| `fn_duracion_seg` | FUNCTION | 2.0.0 | No aplica |
| `fn_normalizar_centro` | FUNCTION | 2.0.0 | No aplica |
| `fn_normalizar_menu` | FUNCTION | 2.0.0 | No aplica |
| `ivr_es_dia_semana` | FUNCTION | 2.0.0 | No aplica |
| `ivr_contar_dias_semana` | FUNCTION | 3.0.0 | Completo — ya O(1) |
| `ivr_agregar_dias_semana` | FUNCTION | 3.0.0 | Completo — ya O(1) |
| `evt_etl_diario` | EVENT | 2.0.0 | No aplica |
| `sp_etl_base_clientes` | PROCEDURE | 2.0.0 | No aplica |
| `sp_etl_base_detalle` | PROCEDURE | 2.2.0 | No aplica |
| `sp_etl_historico` | PROCEDURE | 2.0.0 | No aplica |
| `sp_etl_maestro` | PROCEDURE | 2.2.0 | No aplica |
| `sp_etl_validar` | PROCEDURE | 2.1.0 | Completo — EXCEPT + INTERSECT |
| `sp_rpt_centros_xsegmento` | PROCEDURE | 2.2.0 | Completo — mejora opcional |
| `sp_rpt_centros_transferencia` | PROCEDURE | 2.1.0 | Completo — mejora opcional |
| `sp_rpt_cMENU_ERROR` | PROCEDURE | 2.0.0 | **Modificar — subq equivalente** |
| `sp_rpt_menu_centro` | PROCEDURE | 2.0.0 | **Modificar — subq equivalente** |
| `sp_rpt_clientes` | PROCEDURE | 2.0.0 | **Modificar — subq equivalente** |
| `sp_rpt_menu_redirigidos` | PROCEDURE | 2.0.0 | **Modificar — 2 subqs equivalentes** |
| `sp_rpt_llamadas_abandonadas` | PROCEDURE | 2.0.0 | No modificar — scope intencional |

---

## Grupo A — No aplica: funciones escalares y objetos de coordinación

Las window functions operan sobre conjuntos de filas en una consulta. Las funciones
escalares de IACT-db reciben valores individuales y retornan un escalar — no tienen
un "conjunto" sobre el que aplicar una ventana.

`fn_did_segmento`, `fn_duracion_seg`, `fn_normalizar_centro`, `fn_normalizar_menu`,
`ivr_es_dia_semana`: todas son funciones `CASE`-based o aritméticas puras. No hay
pattern de window function que se pueda aplicar dentro de un cuerpo de función escalar.

`evt_etl_diario`: el evento solo ejecuta `CALL sp_etl_maestro()`. No tiene lógica propia.

`sp_etl_base_detalle`, `sp_etl_base_clientes`, `sp_etl_historico`, `sp_etl_maestro`:
los SPs ETL leen `tbl_historico` (tabla fuente cruda) y escriben en `base_ivr_detalle`
y `base_ivr_clientes`. Son SPs de transformación-carga. Las window functions requieren
un conjunto de filas en memoria — incompatible con el patrón `INSERT ... SELECT ...`
sobre tablas de ~11.6M filas sin agrupación previa.

---

## Grupo B — Completo: ya tienen el patrón correcto

`ivr_contar_dias_semana` y `ivr_agregar_dias_semana` (v3.0.0): las funciones eliminaron
el WHILE en FASE 4. El detector encontró referencias a WHILE en los comentarios del
encabezado — no en el cuerpo de la función. El código está optimizado.

`sp_etl_validar` (v2.1.0): tiene EXCEPT (check 4) e INTERSECT (check 5) del Módulo 12.

`sp_rpt_centros_xsegmento` (v2.2.0): tiene 3 CTEs de FASE 2 y DENSE_RANK del Módulo 13.

`sp_rpt_centros_transferencia` (v2.1.0): tiene LEFT JOIN con tabla derivada pre-agregada
de FASE 2. Sin subconsultas correlacionadas.

---

## Grupo C — No modificar: scope intencional

### `sp_rpt_llamadas_abandonadas` v2.0.0

La subconsulta de `pct_del_segmento` usa deliberadamente el total de **todas** las
llamadas del segmento — no solo las abandonadas — como denominador:

```sql
(SELECT SUM(b3.total_llamadas) FROM base_ivr_detalle b3
 WHERE b3.trimestre = p_quarter AND b3.segmento = b.segmento)
-- sin filtro de menu abandonado
```

Una window function `OVER (PARTITION BY segmento)` solo vería las llamadas
abandonadas (las únicas visibles tras el `WHERE menu IN (...)` del exterior).

```
Con subq (correcto):   18,386 / 53,879 = 34.12%
Con window (incorrecto): 18,386 / 18,386 = 100.00%
```

La tasa de abandono del 34% es el KPI operacional. El 100% no tiene valor analítico.

---

## Grupo D — Modificar: subconsultas equivalentes a window functions

### D-1: `sp_rpt_cMENU_ERROR` v2.0.0

**Subconsulta actual:**
```sql
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
   AND b2.menu REGEXP '^[0-9]+$'
   AND LENGTH(b2.menu) >= 7
) AS total_anomalias_quarter
```

La subconsulta aplica los mismos filtros `REGEXP` y `LENGTH` que la consulta exterior.
Es un escalar constante para todas las filas del resultado (mismo valor en todas).

**Reemplazo:**
```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento) AS total_anomalias_quarter
```

**Verificación Q01_25:** `total_subq = total_window = 55` para todos los registros.

**Beneficio en producción:** elimina un scan adicional de `base_ivr_detalle` por cada
fila del GROUP BY. Con 50-200 filas de resultado en producción, el segundo scan ejecuta
50-200 veces por llamada al SP — todos consultan el mismo total.

---

### D-2: `sp_rpt_menu_centro` v2.0.0

**Subconsulta actual:**
```sql
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND b2.centro_transferencia = b.centro_transferencia  -- correlación
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento))
```

Correlaciona por `centro_transferencia` con los mismos filtros de trimestre y segmento.

**Reemplazo:**
```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia)
```

**Verificación Q01_25:** `pct_subq = pct_window = 45.55` para CLIENTE_COLGO, `44.79`
para 10728487, `44.70` para 19020086. Idénticos en todos los centros verificados.

**Nota sobre el NOT IN:** la consulta exterior excluye centros centinela con
`AND b.centro_transferencia NOT IN ('CASO_NULL', ...)`. Estos centinelas no aparecen
en el resultado. Para los centros válidos que sí aparecen, sus filas no son excluidas
por el NOT IN (son centros válidos). La partición `OVER (PARTITION BY centro)` opera
solo sobre los centros del resultado — equivalente a la subconsulta.

**Beneficio en producción:** con 500-2,000 filas de resultado estimadas (centro × menú
× opción × segmento), el segundo scan ejecuta centenares de veces por llamada al SP.

---

### D-3: `sp_rpt_clientes` v2.0.0

**Subconsulta actual:**
```sql
(SELECT SUM(c2.clientes_unicos) FROM base_ivr_clientes c2
 WHERE c2.trimestre = p_quarter)
```

Suma el total de `clientes_unicos` del quarter — escalar global, sin partición.

**Reemplazo:**
```sql
SUM(c.clientes_unicos) OVER () AS total_quarter
```

**Verificación Q01_25:** `total_subq = total_window = 83,068` (suma de los 3 segmentos).

**Contexto:** el SP devuelve 3 filas fijas. El impacto en rendimiento es mínimo. La
modificación es por consistencia de estilo con los otros SPs del grupo.

---

### D-4: `sp_rpt_menu_redirigidos` v2.0.0 ← CORRECCIÓN DE CLASIFICACIÓN ANTERIOR

Clasificado previamente como "complejo — 2 denominadores distintos". La verificación
exhaustiva con los dos escenarios de `p_segmento` demuestra que ambas subconsultas
son equivalentes a window functions.

**Subconsulta 1 — `pct_del_menu`:**
```sql
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND b2.menu = b.menu                                      -- correlación por menu
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento))
```

Denominador = total de llamadas que pasaron por ese menú en el segmento parametrizado.

**Reemplazo subq1:**
```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento, b.menu)
```

**Subconsulta 2 — `pct_del_total`:**
```sql
(SELECT SUM(b3.total_llamadas)
 FROM base_ivr_detalle b3
 WHERE b3.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b3.segmento = p_segmento))
```

Denominador = total de llamadas del scope completo (segmento o todos).

**Reemplazo subq2:**
```sql
SUM(SUM(b.total_llamadas)) OVER ()   -- sin PARTITION BY
```

`OVER ()` sin `PARTITION BY` opera sobre todas las filas visibles después del WHERE
exterior. Si `p_segmento='todas'`, el WHERE exterior deja pasar todos los segmentos
y `OVER ()` da el grand total — igual que la subconsulta. Si `p_segmento='nacional_A'`,
el WHERE exterior filtra solo `nacional_A` y `OVER ()` da el total de nacional_A —
igual que la subconsulta.

**Verificación Q01_25 — ambos escenarios:**

```
p_segmento='nacional_A':
  pct_total_subq = pct_total_over_all = 22.79%  ✓
  pct_total_over_seg = 22.79%  ✓ (coinciden en este caso porque solo hay un segmento)

p_segmento='todas':
  pct_total_subq = pct_total_over_all = 10.30%  ✓ (grand total de los 3 segmentos)
  pct_total_over_seg = 22.79%  ✗ (per-segmento — semántica diferente)
```

`OVER ()` es la única opción correcta. `OVER (PARTITION BY segmento)` es incorrecto
cuando `p_segmento='todas'` porque cambia la semántica del KPI.

---

## Grupo E — Mejoras opcionales (sin eliminar columnas existentes)

### `sp_rpt_centros_xsegmento` v2.2.0

Ya tiene `DENSE_RANK`. Dos adiciones opcionales validadas en los datos:

**`PERCENT_RANK`** — percentil de actividad dentro del segmento:
```sql
, ROUND(PERCENT_RANK() OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas          -- ASC: 0=menos activo, 1=más activo
  ), 4) AS percentil_actividad
```
El centro `10728487` estará en el percentil 1.0; el centro con 1 llamada en el 0.0.

**`FIRST_VALUE`** — comparación con el líder del segmento:
```sql
, ROUND(cc.total_llamadas
    / FIRST_VALUE(cc.total_llamadas) OVER (
        PARTITION BY cc.segmento
        ORDER BY cc.total_llamadas DESC
      ) * 100, 1) AS pct_del_lider
```
El centro `10828091` está al 87.4% del líder `10728487`.

### `sp_rpt_centros_transferencia` v2.1.0

Reporte de detalle fecha × centro × menú × opción. Candidato a:

**`NTILE(4)`** — cuartil de actividad del centro dentro del resultado filtrado:
```sql
, NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) DESC
  ) AS cuartil_centro
```

Permite al operador identificar en qué cuartil cae un centro determinado sin
calcular umbrales manuales por quarter.

---

## Resumen ejecutivo

| Acción | Objetos | Función window | Verificado |
|---|---|---|---|
| Modificar — eliminar subconsulta | `sp_rpt_cMENU_ERROR` | `SUM(SUM()) OVER (PARTITION BY segmento)` | Sí |
| Modificar — eliminar subconsulta | `sp_rpt_menu_centro` | `SUM(SUM()) OVER (PARTITION BY centro)` | Sí |
| Modificar — eliminar subconsulta | `sp_rpt_clientes` | `SUM() OVER ()` | Sí |
| Modificar — eliminar 2 subconsultas | `sp_rpt_menu_redirigidos` | `OVER(seg,menu)` + `OVER()` | Sí — ambos escenarios |
| Mejora opcional — columna nueva | `sp_rpt_centros_xsegmento` | `PERCENT_RANK` + `FIRST_VALUE` | Sí |
| Mejora opcional — columna nueva | `sp_rpt_centros_transferencia` | `NTILE(4)` | Sí |
| No tocar | `sp_rpt_llamadas_abandonadas` | — | Scope intencional |
| No aplica | 13 objetos restantes | — | Scalar o coordinación |
