# Hallazgos — Ejecución FASE 4 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 4  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-4.1 | `sp_etl_pipeline.sql` — agregar `UPDATE v_maestro_id` en handler PASO 5 (BUG-002) | COMPLETO | H-F4-001 |
| T-4.2 | Redespliegue de `sp_etl_pipeline.sql` en la BD | COMPLETO | — |
| T-4.3 | Verificación funcional del ETL completo y verify.sh | PASA | — |

---

## H-F4-001 — BUG-002 solo se manifiesta en una condición compuesta, no en cualquier fallo

**Detectado en:** T-4.1, durante el trazado del flujo de ejecución antes de implementar  
**Severidad:** ALTA — el bug bloquea el ETL de forma permanente cuando ocurre  
**Estado:** RESUELTO en T-4.1

### Descripción

El catálogo de bugs describía BUG-002 como: "si `sp_etl_base_clientes` falla,
`job_execution_log` queda con la fila del maestro en `status='RUNNING'`
indefinidamente". El análisis profundo del flujo de ejecución reveló que esta
descripción era incompleta: el bug **no se manifiesta en todos los casos de fallo**
de `sp_etl_base_clientes`.

### Análisis del flujo de ejecución completo

Cuando `sp_etl_base_clientes` lanza `SQLEXCEPTION`, el `EXIT HANDLER` del PASO 5
ejecuta y luego el control regresa al bloque externo de `sp_etl_maestro`,
**no** al llamador. La ejecución continúa en PASO 6:

```
PASO 5 handler dispara → actualiza v_step_id a FAILED
                       → NO actualiza v_maestro_id (BUG)
                       → handler termina → control al bloque externo

PASO 6: CALL sp_etl_validar(v_quarter, v_ok, v_msg)

PASO 7: UPDATE job_execution_log
        SET status = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL')
        WHERE id = v_maestro_id
```

Esto define dos escenarios distintos:

**Escenario A — sp_etl_validar tiene éxito (bug NO visible):**

`sp_etl_base_clientes` hace `DELETE FROM base_ivr_clientes WHERE trimestre=?`
*antes* del `EXECUTE` que falla. Cuando el SP falla, `base_ivr_clientes` queda
con 0 filas para el quarter. `sp_etl_validar` detecta `v_count_cli = 0 ≠ 3` y
retorna `v_ok = FALSE`. PASO 7 ejecuta y actualiza `v_maestro_id` a `'PARTIAL'`.
El check de concurrencia del PASO 1 solo bloquea en `status = 'RUNNING'`, no en
`'PARTIAL'`. La siguiente ejecución **procede normalmente**.

**Escenario B — sp_etl_validar también falla (bug VISIBLE):**

Si `sp_etl_validar` lanza una `SQLEXCEPTION` (tablas no existen, permisos
degradados, error de hardware), no hay ningún handler para esa excepción en el
bloque externo de `sp_etl_maestro`. La excepción propaga **fuera** del SP.
PASO 7 nunca se ejecuta. `v_maestro_id` queda en `status = 'RUNNING'`.

El check de concurrencia detecta ese `RUNNING` dentro de la ventana de 6 horas:

```sql
-- PASO 1 de sp_etl_maestro:
IF NOT v_abort AND EXISTS (
    SELECT 1 FROM job_execution_log
    WHERE job_name = 'etl_diario'
      AND step_name = 'maestro'
      AND status = 'RUNNING'
      AND start_time > DATE_SUB(NOW(), INTERVAL 6 HOUR)
) THEN
    -- hace SKIP → el ETL queda bloqueado
```

El ETL permanece bloqueado hasta intervención manual:

```sql
UPDATE job_execution_log
SET status = 'FAILED', end_time = NOW(),
    error_message = 'corregido manualmente — ETL bloqueado por BUG-002'
WHERE job_name = 'etl_diario' AND step_name = 'maestro' AND status = 'RUNNING';
```

**Escenario C — proceso matado externamente entre PASO 5 y PASO 6:**

Si el proceso Django que ejecuta `sp_etl_maestro` recibe `SIGKILL` (o el
servidor se reinicia) después de que el handler del PASO 5 termina pero antes
de que PASO 7 ejecute, el efecto es idéntico al Escenario B.

### Verificación del bug antes del fix

```sql
-- Estado producido por el bug (confirmado empíricamente):
maestro           | RUNNING  | NULL
etl_base_clientes | FAILED   | Table not found: tbl_historico_t2_2026

-- Check de concurrencia detecta 1 RUNNING → SKIP en próxima ejecución
SELECT COUNT(*) FROM job_execution_log
WHERE job_name='etl_diario' AND step_name='maestro'
  AND status='RUNNING' AND start_time > DATE_SUB(NOW(), INTERVAL 6 HOUR);
-- → 1 (ETL bloqueado)
```

---

## Cambios implementados

### `provisioners/mariadb/sp_etl_pipeline.sql` — T-4.1

**PASO 5 dentro de `sp_etl_maestro` — agregar `UPDATE v_maestro_id` en el handler:**

```sql
-- Antes (handler incompleto):
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(), error_message=v_err_msg
        WHERE id = v_step_id;
        -- v_maestro_id NO se actualiza → queda RUNNING si PASO 6/7 no ejecutan
    END;
    CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
END;

-- Después (handler simétrico con PASO 4):
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(), error_message=v_err_msg
        WHERE id = v_step_id;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(),
            error_message=CONCAT('Falló etl_base_clientes: ', v_err_msg)
        WHERE id = v_maestro_id;
        -- Mismo patrón que PASO 4. Si PASO 7 no ejecuta por cualquier razón,
        -- v_maestro_id queda FAILED — no RUNNING — y el check de concurrencia
        -- no bloquea la siguiente ejecución.
    END;
    CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
END;
```

El fix es simétrico con el handler del PASO 4 (`sp_etl_base_detalle`), que
ya tenía el UPDATE de `v_maestro_id` correcto. Si PASO 7 sí ejecuta,
sobreescribe el `'FAILED'` con `'PARTIAL'` o `'SUCCESS'` — ese overwrite es
correcto porque `'PARTIAL'` es más preciso que `'FAILED'` cuando el ETL
completa su ciclo aunque con errores parciales.

---

## Verificación funcional

### Prueba con el escenario del bug

```
Estado con el handler CORREGIDO:
  maestro           | FAILED  | Falló etl_base_clientes: <error>
  etl_base_clientes | FAILED  | <error>

Check de concurrencia: 0 RUNNING detectados → la siguiente ejecución procede ✓
```

### ETL completo con tabla existente

```
step_name          | status  | records_procesados
maestro            | SUCCESS | 0
etl_base_detalle   | SUCCESS | 1759
etl_base_clientes  | SUCCESS | 3

sp_etl_validar: OK — 1759 filas detalle, 3 filas clientes, 40,762 llamadas totales.
exit: 0
```

---

## Nota sobre el overwrite de v_maestro_id en PASO 7

El PASO 7 de `sp_etl_maestro` actualiza `v_maestro_id` de forma incondicional:

```sql
UPDATE job_execution_log
SET status = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL'),
    end_time = NOW(),
    error_message = IF(COALESCE(v_ok, FALSE), NULL, v_msg)
WHERE id = v_maestro_id;
```

Esto significa que si el handler del PASO 5 marca `v_maestro_id` como `FAILED`,
y luego PASO 6 y PASO 7 ejecutan normalmente, `v_maestro_id` queda como
`'PARTIAL'` (no `'FAILED'`). Esto es el comportamiento correcto: `'PARTIAL'`
indica que el pipeline completó su ciclo pero con validación fallida, que es
más preciso que `'FAILED'` que implicaría un error catastrófico.

El mismo comportamiento existe en el PASO 4 y es intencional según el comentario
original del código: `"el handler termina y el bloque externo continua"`.

---

## Estado de los bugs del plan tras FASE 4

| Bug | Descripción | Estado |
|---|---|---|
| BUG-002 | EXIT HANDLER de `sp_etl_base_clientes` no actualiza `v_maestro_id` | RESUELTO — T-4.1 |
