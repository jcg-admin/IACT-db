# Hallazgos — Ejecución FASE 0 (Pre-condición)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Verificación de estado base antes de implementar correcciones del
`PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md`

---

## Resultado de las tareas del plan

| Tarea | Descripción | Resultado | Observaciones |
|---|---|---|---|
| T-0.1 | MariaDB y PostgreSQL activos | PASA | MariaDB PID 2477, arranque directo |
| T-0.2 | Tablas históricas con 0 registros | PASA | Estructura correcta, 0 rows |
| T-0.3 | `sp_seed_historico` no existe | PASA | COUNT: 0 confirmado |

**FASE 0 completada. El entorno está en estado correcto para iniciar FASE 1.**

---

## Hallazgos identificados

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-F0-001 | `information_schema.table_rows` reporta 0 para InnoDB aunque existan filas | Comportamiento de motor | — | DOCUMENTADO |
| H-F0-002 | `seed_executions` tiene 1 fila con `filas_despues=3000` pero `tbl_historico_t1_2025` tiene 0 filas | Inconsistencia de datos | ALTA | PENDIENTE evaluación |
| H-F0-003 | `vw_monitor_dias_semana` — vista no documentada en el inventario del plan | Cobertura de documentación | BAJA | DOCUMENTADO |
| H-F0-004 | `sp_seed_historico` no existe — el SP de seed fue destruido por `DROP PROCEDURE IF EXISTS` al final del SQL con `DELIMITER` roto | Causa raíz confirmada | — | DOCUMENTADO |
| H-F0-005 | `job_config` tiene `etl_historico` deshabilitado — carga histórica manual requiere habilitación explícita | Configuración | MEDIA | DOCUMENTADO |
| H-F0-006 | `sp_etl_base_detalle` lee `tbl_historico_*` via tabla dinámica (`p_table VARCHAR`) — confirma dependencia directa | Confirmación arquitectónica | — | DOCUMENTADO |

---

## H-F0-001 — `information_schema.table_rows` es una estimación para InnoDB

**Tipo:** Comportamiento documentado del motor  
**Estado:** DOCUMENTADO

### Descripción

La consulta inicial de T-0.2 usó `information_schema.tables.table_rows` para
verificar el estado de las tablas históricas. El resultado reportó 0 para todas
las tablas, incluyendo `seed_executions`.

Al verificar con `COUNT(*)` real:

```
information_schema.table_rows:  seed_executions = 0  ← estimación
COUNT(*) real:                  seed_executions = 1  ← real
AUTO_INCREMENT:                 seed_executions = 2  ← confirma 1 insert histórico
```

### Causa

Para tablas InnoDB, `information_schema.table_rows` es una estimación estadística
que se actualiza periódicamente via `ANALYZE TABLE` o durante el checkpoint de
InnoDB. En un proceso `mariadbd` recién iniciado (PID 2477, arranque del mismo
día), las estadísticas pueden estar desactualizadas o no haberse calculado aún.

### Impacto en el plan

Los scripts de verificación del plan que comparan `table_rows` contra 0 para
determinar si las tablas están vacías son **no confiables**. El plan ya usa
`COUNT(*)` para T-0.2 y T-4.2 — esto es correcto. No se debe usar
`information_schema.table_rows` en ninguna verificación del plan.

---

## H-F0-002 — `seed_executions` registra 3000 filas pero `tbl_historico_t1_2025` tiene 0

**Tipo:** Inconsistencia de datos — registro de ejecución huérfano  
**Severidad:** ALTA  
**Estado:** PENDIENTE evaluación antes de FASE 4

### Descripción

`seed_executions` contiene exactamente 1 fila:

```
id: 1
ejecutado_en: 2026-05-10 06:33:51
tabla:        tbl_historico_t1_2025
accion:       SEED
filas_antes:  0
filas_despues: 3000
seed_rows_cfg: 3000
commit_hash:  abc12345
script_version: 2.1.0
```

Sin embargo, `COUNT(*) FROM tbl_historico_t1_2025 = 0`.

### Causa

Esta fila fue insertada durante las pruebas de FASE 0 del plan de correcciones
anterior (sesión del mismo día), donde se ejecutó `my_exec_file_root` con un
INSERT manual de prueba en `seed_executions` para verificar que la función raíz
funcionaba. El `commit_hash = 'abc12345'` confirma que es un registro de prueba
— no un seed real. La tabla `tbl_historico_t1_2025` nunca recibió datos porque
el SP `sp_seed_historico` no pudo crearse por el bug de DELIMITER.

### Impacto en FASE 4

Cuando `setup.sh mariadb --full` ejecute el seed en FASE 4:

1. `seed_historico.sql` creará `sp_seed_historico` correctamente (con el fix de FASE 1)
2. El SP verificará `COUNT(*) FROM tbl_historico_t1_2025` → retorna 0
3. Con `FORCE_RESEED=0` (default): `v_count_antes = 0`, la condición de skip no se activa → procede con SEED
4. El registro huérfano en `seed_executions` no bloquea el seed — el SP verifica la tabla, no `seed_executions`

El seed procederá correctamente sin intervención manual.

### Acción recomendada antes de FASE 4

Por claridad de datos, limpiar el registro huérfano antes de ejecutar el seed real:

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "DELETE FROM seed_executions WHERE commit_hash = 'abc12345';"
```

Esto no es bloqueante — el seed funcionará igual — pero evita confusión al
revisar el historial de ejecuciones después de FASE 4.

---

## H-F0-003 — `vw_monitor_dias_semana` — vista no documentada en el inventario

**Tipo:** Cobertura de documentación  
**Severidad:** BAJA  
**Estado:** DOCUMENTADO

### Descripción

La consulta de inventario de tablas detectó `vw_monitor_dias_semana` con
`engine = NULL`, indicando que es una vista (no una tabla). La vista fue creada
por `sp_rpt_reportes.sql` y no aparece en el inventario documentado del plan.

Definición:

```sql
CREATE VIEW vw_monitor_dias_semana AS
SELECT
    trimestre, fecha,
    SUM(total_llamadas)         AS total,
    SUM(llamadas_entre_semana)  AS habiles,
    SUM(llamadas_fines_semana)  AS fin_semana,
    SUM(total) - SUM(habiles) - SUM(fin_semana) AS error_suma,
    ROUND(SUM(habiles)/NULLIF(SUM(total),0)*100, 1) AS pct_entre_semana,
    CASE WHEN SUM(total)=0    THEN 'SIN_DATOS'
         WHEN error_suma != 0 THEN 'ERROR_INTEGRIDAD'
         WHEN pct_entre_semana NOT BETWEEN 60 AND 85 THEN 'ALERTA_RATIO'
         ELSE 'OK'
    END AS estado_monitor
FROM base_ivr_detalle
GROUP BY trimestre, fecha
```

Es una vista de monitoreo de integridad sobre `base_ivr_detalle`. No requiere
datos en `tbl_historico_*` directamente — opera sobre la tabla analítica
`base_ivr_detalle`, que se puebla vía el pipeline ETL.

### Acción

Agregar `vw_monitor_dias_semana` al inventario de verificación de `verify.sh 3b`
en una iteración futura. No bloquea el objetivo de este plan.

---

## H-F0-004 — `sp_seed_historico` no existe por `DROP PROCEDURE` ejecutado correctamente

**Tipo:** Confirmación de causa raíz  
**Estado:** DOCUMENTADO

### Descripción

T-0.3 confirmó que `sp_seed_historico` no existe en `ivr_legacy`. Esto es
consistente con el bug H-F3-003 / H-PROV-003:

1. `seed_historico.sql` contiene `DROP PROCEDURE IF EXISTS sp_seed_historico`
   antes del `CREATE PROCEDURE` — esta línea SÍ se ejecutó correctamente
   (termina en `;`, no en `$$`)
2. El `CREATE PROCEDURE ... BEGIN ... END sp_seed_historico$$` fue dividido
   por el `;` interno del cuerpo → el SP nunca se creó
3. `DELIMITER ;` al final se ejecutó como un statement vacío
4. `DROP PROCEDURE IF EXISTS sp_seed_historico` al final del SQL (después de
   los CALL) se ejecutó sobre un SP inexistente → sin error (IF EXISTS)

El resultado: cada ejecución de `schema_historico.sh` limpia el SP si existiera
y falla al crearlo, dejando el entorno sin `sp_seed_historico`. El estado es
determinístico y reproducible.

### Implicación para FASE 1

Con el fix de `my_exec_vars_root` (archivo temporal), el flujo correcto será:

```
1. DROP PROCEDURE IF EXISTS sp_seed_historico  → OK
2. DELIMITER $$                                → procesado (archivo, no pipe)
3. CREATE PROCEDURE sp_seed_historico(...)
   sp_seed_historico: BEGIN ... END sp_seed_historico$$   → SP creado
4. DELIMITER ;                                 → restaurado
5. CALL sp_seed_historico(...)                 → ejecuta seed
6. DROP PROCEDURE IF EXISTS sp_seed_historico  → limpia SP temporal
```

El SP es creado, usado y destruido en la misma ejecución del SQL — por diseño
(el SP es un artefacto temporal del proceso de seed, no un objeto permanente
del schema).

---

## H-F0-005 — `job_config`: `etl_historico` deshabilitado por diseño

**Tipo:** Configuración del pipeline  
**Severidad:** MEDIA  
**Estado:** DOCUMENTADO

### Descripción

`job_config` contiene dos jobs:

| job_name | is_enabled | timeout | notas |
|---|---|---|---|
| `etl_diario` | 1 (habilitado) | 1800s | ETL nocturno automático — procesa quarter actual |
| `etl_historico` | 0 (deshabilitado) | 7200s | Carga histórica manual — habilitar solo durante backfill |

`sp_etl_maestro` lee `job_config` para determinar si debe ejecutar:

```sql
SELECT is_enabled, timeout_seconds
INTO v_enabled, v_timeout
FROM job_config
WHERE job_name = 'etl_diario';

IF NOT v_enabled THEN
    -- abortar
END IF;
```

### Implicación

El pipeline `etl_diario` ya está habilitado. Con datos en `tbl_historico_*`
(objetivo de este plan), `sp_etl_maestro` podrá ejecutarse y poblar
`base_ivr_detalle` y `base_ivr_clientes`.

El `etl_historico` debe permanecer deshabilitado hasta que se decida hacer un
backfill completo — es una operación de carga masiva que requiere hasta 7200s
(2 horas) de timeout.

---

## H-F0-006 — `sp_etl_base_detalle` lee `tbl_historico_*` via parámetro dinámico

**Tipo:** Confirmación arquitectónica  
**Estado:** DOCUMENTADO

### Descripción

`sp_etl_base_detalle` recibe `p_table VARCHAR(100)` como parámetro. El SP
construye la query dinámicamente:

```sql
SELECT ... FROM ', p_table, '
WHERE dFecha BETWEEN ? AND ?
  AND cDID_800Transfer IN ('19020084', '19028031', '19020001')
```

`sp_etl_maestro` calcula el nombre de la tabla según el quarter actual:

```sql
SET v_table = CONCAT('tbl_historico_t', v_qnum, '_', v_year);
```

### Implicación directa para el objetivo del plan

Con `tbl_historico_t2_2026` vacía (quarter actual: Q2 2026), `sp_etl_maestro`
ejecutaría `sp_etl_base_detalle` contra esa tabla y retornaría 0 filas — sin
error, pero sin poblar `base_ivr_detalle`. El plan debe asegurar que al menos
`tbl_historico_t2_2026` tenga datos del período actual
(`2026-04-01` a `2026-05-06`).

`seed_historico.sql` ya maneja este caso con:

```sql
SET @SEED_ROWS_PARCIAL = GREATEST(500, FLOOR(@SEED_ROWS * 36 / 91));
CALL sp_seed_historico('tbl_historico_t2_2026', '2026-04-01', '2026-05-06',
    @SEED_ROWS_PARCIAL, ...)
```

36 de 91 días ≈ 40% del quarter → `SEED_ROWS_PARCIAL ≈ 1200` registros con
el default de 3000. El pipeline ETL tendrá datos del período actual.

---

## Estado del entorno al cierre de FASE 0

```
MariaDB 10.11.14     activo   PID 2477   /run/mysqld/mysqld.sock
PostgreSQL 16        activo   127.0.0.1:5432

ivr_legacy:
  tbl_historico_*    6 tablas   0 registros (estructura correcta)
  tbl_temp_prueba_ivr            3000 registros (funcional)
  seed_executions                1 fila (huérfana de prueba — limpiar antes de FASE 4)
  sp_seed_historico              NO existe (correcto para este estado)
  SPs ETL                        5/5 presentes
  SPs reporte                    7/7 presentes
  Funciones utilidad             7/7 presentes
  vw_monitor_dias_semana         vista presente (no documentada previamente)
  job_config                     etl_diario=habilitado, etl_historico=deshabilitado

iact_analytics:
  BD vacía (sin migrate ejecutado)
```

**FASE 1 puede iniciar.** No hay bloqueos técnicos. La única acción
pre-FASE 4 recomendada (no bloqueante) es limpiar el registro huérfano
de `seed_executions` (H-F0-002).
