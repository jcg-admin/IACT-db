# Hallazgos — Implementación FASE 3

**Versión:** 1.0.0
**Fecha:** 2026-05-13
**Alcance:** FASE 3 del plan PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resumen de tareas ejecutadas

| Tarea | Descripción | Estado | Hallazgos |
|---|---|---|---|
| T3.1 | v_etl_rendimiento v1.0.0 | COMPLETO | H-T3.1-001, H-T3.1-002 |
| T3.2 | sp_rpt_resumen_abandono_rollup v1.0.0 | COMPLETO | H-T3.2-001 |

---

## H-T3.1-001 — `duracion_seg` ya existe como columna STORED GENERATED

**Tarea:** T3.1
**Severidad:** Mejora — simplifica la vista y elimina trabajo redundante del motor
**Estado:** Incorporado en la implementación

### Descripción

El plan (`PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md`) especificaba usar
`TIMESTAMPDIFF(SECOND, start_time, end_time)` tanto para `duracion_seg` como
dentro de las dos llamadas a `LAG()`:

```sql
-- Plan original (redundante):
TIMESTAMPDIFF(SECOND, start_time, end_time)                      AS duracion_seg
, LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
    OVER (PARTITION BY job_name, step_name ORDER BY start_time)  AS duracion_anterior_seg
, TIMESTAMPDIFF(SECOND, start_time, end_time)
  - LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
      OVER (PARTITION BY job_name, step_name ORDER BY start_time) AS delta_seg
```

Al leer la estructura de `job_execution_log` con `DESCRIBE` antes de implementar,
se descubrió que `duracion_seg` es una columna STORED GENERATED:

```
duracion_seg  int(11)  NULL  STORED GENERATED
```

Esto significa que el motor calcula y almacena `TIMESTAMPDIFF(SECOND, start_time, end_time)`
automáticamente en cada INSERT/UPDATE. La vista puede referenciarla directamente
como una columna ordinaria sin recomputar nada.

### Vista implementada

```sql
CREATE OR REPLACE VIEW v_etl_rendimiento AS
SELECT
    job_name, quarter_name, step_name, status, start_time
    , duracion_seg                                             -- columna STORED GENERATED
    , LAG(duracion_seg)
        OVER (PARTITION BY job_name, step_name ORDER BY start_time) AS duracion_anterior_seg
    , duracion_seg
      - LAG(duracion_seg)
          OVER (PARTITION BY job_name, step_name ORDER BY start_time) AS delta_seg
FROM job_execution_log
WHERE status = 'SUCCESS';
```

**Ventajas:**
- El motor ya tiene el valor calculado — cero operaciones aritméticas en la vista
- `TIMESTAMPDIFF()` habría aparecido 3 veces; ahora se referencia la columna 1 vez
- La vista es más legible y maintainable

---

## H-T3.1-002 — `django_user` ya tiene SELECT sobre vistas sin grant adicional

**Tarea:** T3.1
**Severidad:** Informativo — sin acción requerida
**Estado:** Documentado

### Descripción

Antes de implementar se verificaron los privilegios reales de `django_user`:

```sql
SHOW GRANTS FOR 'django_user'@'localhost';
-- GRANT SELECT ON `ivr_legacy`.* TO `django_user`@`localhost`
```

El grant `SELECT ON ivr_legacy.*` es un grant de nivel base de datos que cubre
automáticamente todas las tablas Y vistas presentes y futuras en `ivr_legacy`.
Crear `v_etl_rendimiento` no requiere ningún GRANT adicional.

El plan mencionaba "verificar permisos" como acción necesaria. La verificación
confirmó que no hay acción requerida.

### Por qué el plan no lo anticipó

El plan fue escrito antes de inspeccionar los grants reales. La suposición implícita
era que Django tenía grants por tabla (como `etl_runs`). El grant de base de datos
`SELECT ON ivr_legacy.*` es más amplio y fue otorgado en `setup.sh`.

---

## H-T3.2-001 — `sp_rpt_resumen_abandono_rollup` necesita la misma distinción que T2.4

**Tarea:** T3.2
**Severidad:** Diseño — aclaración del KPI antes de implementar
**Estado:** Documentado y resuelto en el diseño

### Descripción

El KPI `pct_del_quarter` en este SP puede interpretarse de dos formas:

**Opción A — Denominador: total de TODAS las llamadas del quarter (119,205)**
```
CLIENTE_COLGO nacional_A → 12,278 / 119,205 = 10.30%
Fila TOTAL → 40,544 / 119,205 = 34.01%
```
KPI: "¿Qué porcentaje del total de llamadas se fue a este camino de abandono?"
Mismo denominador que `sp_rpt_llamadas_abandonadas`.

**Opción B — Denominador: total de los 3 menús de abandono (40,544)**
```
CLIENTE_COLGO nacional_A → 12,278 / 40,544 = 30.28%
Fila TOTAL → 40,544 / 40,544 = 100.00%
```
KPI: "¿Qué porcentaje de los abandonos del quarter corresponde a esta categoría?"

El plan especificaba la Opción B porque:
1. La fila TOTAL = 100.00% tiene sentido en un resumen ejecutivo de distribución
2. La Opción A daría 34.01% en la fila TOTAL, lo que no es intuitivo
3. El denominador de los 3 menús responde la pregunta correcta para un dashboard
   de abandono: "¿cómo se distribuyen los abandonos?"

La Opción A es la correcta para `sp_rpt_llamadas_abandonadas` que incluye SLA.
La Opción B es la correcta para `sp_rpt_resumen_abandono_rollup` que es el
resumen ejecutivo de distribución.

### Implementación con `v_total`

```sql
-- v_total = 40,544 (Opción B)
SELECT SUM(total_llamadas) INTO v_total
FROM base_ivr_detalle
WHERE trimestre = p_quarter
  AND menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera');
```

**Verificación Q01_25:**

```
nacional_A  CLIENTE_COLGO       12278   30.28%
nacional_A  SINOPCION_CABECERA   1698    4.19%
nacional_A  VACIO                4410   10.88%
nacional_A  --- SUBTOTAL ---    18386   45.35%
nacional_B  CLIENTE_COLGO        8163   20.13%
nacional_B  SINOPCION_CABECERA   1161    2.86%
nacional_B  VACIO                2876    7.09%
nacional_B  --- SUBTOTAL ---    12200   30.09%
puebla      CLIENTE_COLGO        6599   16.28%
puebla      SINOPCION_CABECERA   1083    2.67%
puebla      VACIO                2276    5.61%
puebla      --- SUBTOTAL ---     9958   24.56%
TOTAL       --- SUBTOTAL ---    40544  100.00%  ✓
```

---

## Estado final de objetos al cerrar FASE 3

| Objeto | Versión | Tipo | Cambio |
|---|---|---|---|
| `v_etl_rendimiento` | 1.0.0 | VIEW (nueva) | LAG() sobre duracion_seg STORED GENERATED |
| `sp_rpt_resumen_abandono_rollup` | 1.0.0 | PROCEDURE (nuevo) | WITH ROLLUP + validación + pipeline_event_log |
| `scripts/provision-mariadb.sh` | — | Script | +2 objetos, 23→25, EXECUTE grant nuevo SP |

---

## Verificaciones realizadas

### T3.1 — v_etl_rendimiento

```sql
-- 2026-05-13
-- Confirmar LAG() y columna STORED GENERATED funcionan:
SELECT job_name, step_name, duracion_seg, duracion_anterior_seg, delta_seg
FROM v_etl_rendimiento ORDER BY job_name, step_name, start_time DESC LIMIT 6;
-- etl_diario  etl_base_clientes  1  0  1   (mejoró 1 seg)
-- etl_diario  etl_base_clientes  0  0  0
-- etl_diario  etl_base_clientes  0  1  -1  (mejoró 1 seg)
-- ...

-- Verificar NULL en primera ejecución:
SELECT job_name, step_name, COUNT(*) AS ejecuciones,
       SUM(CASE WHEN duracion_anterior_seg IS NULL THEN 1 ELSE 0 END) AS sin_anterior
FROM v_etl_rendimiento GROUP BY job_name, step_name;
-- etl_diario etl_base_clientes  10  1   ← exactamente 1 sin anterior ✓
-- etl_diario etl_base_detalle   10  1   ✓
-- etl_diario maestro            10  1   ✓
-- etl_historico etl_base_*      10  1   ✓
```

### T3.2 — sp_rpt_resumen_abandono_rollup

```sql
-- 2026-05-13
-- 13 filas: 3 segs × 3 menus + 3 subtotales + 1 TOTAL
CALL sp_rpt_resumen_abandono_rollup('Q01_25');
-- Fila TOTAL: abandonadas=40544, pct_del_quarter=100.00 ✓

-- SIGNAL con quarter inválido:
CALL sp_rpt_resumen_abandono_rollup('INVALIDO');
-- ERROR 1644 (22023) + pipeline_event_log +1 (de 9 a 10 filas) ✓

-- EXECUTE grant aplicado para django_user@localhost y @% ✓
```

---

## Commits de la FASE 3

| Hash | Mensaje | Tareas |
|---|---|---|
| `f1639d0` | feat(observabilidad): FASE 3 | T3.1 + T3.2 |
