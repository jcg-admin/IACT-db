# Hallazgos — Ejecución FASE 3 (atomicidad del ETL)

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Plan de referencia:** `PLAN-IMPL-HALLAZGOS-SQL-SERVER-IACT-DB.md` FASE 3  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Archivo modificado

| Archivo | Objeto | Versión anterior | Versión nueva | Hallazgo resuelto |
|---|---|---|---|---|
| `objetos/sps/sp_etl_base_detalle.sql` | `sp_etl_base_detalle` | 2.1.0 | 2.2.0 | H-IACT-004 |

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-3.1 | Verificación de compatibilidad TX + PREPARE/EXECUTE en MariaDB 10.11 | PASA | H-F3-001 |
| T-3.2 | `START TRANSACTION` + EXIT HANDLER(`ROLLBACK` + `RESIGNAL`) + `COMMIT` por mes | COMPLETO | — |
| T-3.3 | ETL completo + verificación de atomicidad + verify.sh | PASA | — |

---

## H-F3-001 — El plan T-3.2 era incompleto: `START TRANSACTION` sin `ROLLBACK` contamina la TX del SP padre

**Detectado en:** T-3.1, durante la verificación de compatibilidad  
**Severidad:** CRÍTICA — sin la corrección, los `UPDATE` de `job_execution_log` en el handler de `sp_etl_maestro` quedarían dentro de la TX abierta por `sp_etl_base_detalle`, con resultado indeterminado  
**Estado:** RESUELTO en T-3.2 con `EXIT HANDLER(ROLLBACK + RESIGNAL)`

### Descripción

El plan original especificaba:

```sql
WHILE v_mes_ini <= p_fin DO
    START TRANSACTION;
    DELETE ...;
    EXECUTE etl_stmt USING ...;
    COMMIT;
END WHILE;
```

Sin manejo de errores dentro del bloque transaccional, se ejecutó el escenario 3 de T-3.1:

```sql
-- Test: ¿qué estado tiene @@in_transaction en el EXIT HANDLER del padre
--       cuando el hijo falla con una TX abierta?
SELECT @@in_transaction AS tx_activa_en_handler;  -- Resultado: 1
SELECT @@in_transaction AS tx_activa_post_handler; -- Resultado: 1
```

**Resultado:** `tx_activa_en_handler = 1` y `tx_activa_post_handler = 1`.

La transacción abierta por `sp_etl_base_detalle` viaja intacta al `EXIT HANDLER` de `sp_etl_maestro`. Las consecuencias serían:

| Situación | Consecuencia |
|---|---|
| TX hace COMMIT implícito (fin de SP) | El DELETE del mes fallido se confirma → mes queda vacío |
| TX hace ROLLBACK | Los `UPDATE job_execution_log SET status='FAILED'` del handler se revierten → maestro queda RUNNING indefinidamente |

Ambas consecuencias son incorrectas. El primer caso viola la atomicidad (el mes puede quedar vacío). El segundo es potencialmente catastrófico: el maestro en estado `RUNNING` bloquea todas las ejecuciones siguientes durante 6 horas (PASO 1 de concurrencia).

### Corrección implementada — `ROLLBACK + RESIGNAL`

```sql
WHILE v_mes_ini <= p_fin DO
    START TRANSACTION;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;   -- cerrar la TX limpiamente antes de propagar
            RESIGNAL;   -- relanzar el error al SP padre sin TX abierta
        END;
        DELETE ...;
        EXECUTE etl_stmt USING ...;
        SET v_mes_ins = ROW_COUNT();
    END;
    COMMIT;
    ...
END WHILE;
```

El EXIT HANDLER local cierra la TX con `ROLLBACK` antes de propagar el error. Cuando `sp_etl_maestro` recibe el error, `@@in_transaction = 0` — sus UPDATEs de `job_execution_log` ejecutan en autocommit y persisten correctamente.

### Verificación del escenario 3 con la corrección

```sql
-- Con ROLLBACK + RESIGNAL en el SP interno:
tx_activa_en_handler   = 0  ← TX cerrada antes de llegar al padre
tx_activa_post_handler = 0  ← no hay TX pendiente tras el handler
```

### Verificación de atomicidad (fallo simulado en mes 2)

```
Snapshot mes 2 (202502) ANTES del fallo simulado: grupos=882, llamadas=37077
@@in_transaction tras el error: 0  ← TX cerrada por ROLLBACK
Snapshot mes 2 DESPUÉS del fallo: grupos=882, llamadas=37077  ← datos intactos
```

El mes 2 conserva sus datos anteriores. El mes 1 (ya `COMMIT`ted en la iteración anterior) no se ve afectado.

---

## Por qué la transacción es por mes y no por quarter

La transacción envuelve el par `DELETE + EXECUTE` de cada iteración del WHILE, no el WHILE completo. Las razones:

**Undo log:** Un quarter puede tener ~4 millones de filas por mes. Una transacción de quarter completo generaría un undo log de ~12 millones de filas — potencialmente mayor que `innodb_log_file_size`, causando un error `Row size too large` o degradando el rendimiento por presión sobre el buffer pool.

**Granularidad de idempotencia:** Con la transacción por mes, si el mes 2 falla, el mes 1 ya está confirmado y el mes 2 conserva sus datos anteriores. En la siguiente ejecución, solo el mes 2 necesita reprocesarse. Con una transacción por quarter, un fallo en el mes 2 revierte también el mes 1 — se perdería el trabajo del primer mes.

**Comportamiento antes de FASE 3 (sin transacciones):**

| Situación | Estado del mes fallido |
|---|---|
| Sin TX: EXECUTE del mes 2 falla | DELETE confirmado, INSERT no ejecutado → mes 2 vacío hasta próxima ejecución |
| Con TX por mes + ROLLBACK: EXECUTE del mes 2 falla | DELETE revertido → mes 2 conserva datos anteriores |

La ventana de inconsistencia pasa de "hasta la próxima ejecución" (máx. 24h) a cero.

---

## Cambios en `sp_etl_base_detalle.sql` (T-3.2)

| Elemento añadido | Posición | Propósito |
|---|---|---|
| `START TRANSACTION` | Inicio de cada iteración del WHILE | Abrir TX para el par DELETE+INSERT del mes |
| `BEGIN ... END` con handler | Envuelve DELETE + EXECUTE | Aísla el manejo de error local |
| `DECLARE EXIT HANDLER FOR SQLEXCEPTION` | Dentro del BEGIN | Captura cualquier fallo de DELETE o EXECUTE |
| `ROLLBACK` | En el handler | Revierte DELETE si EXECUTE falla — cierra TX |
| `RESIGNAL` | En el handler | Propaga el error al SP padre sin TX abierta |
| `COMMIT` | Después del END | Confirma el par DELETE+INSERT si todo fue correcto |

---

## Verificación funcional final

```
sp_etl_base_detalle Q01_25 con transacciones:
  Ejecución 1:
    202501: 909 grupos, 40918 llamadas
    202502: 882 grupos, 37077 llamadas
    202503: 913 grupos, 41210 llamadas
  Ejecución 2 (idempotencia):
    202501: 909 grupos, 40918 llamadas  ← idéntico
    202502: 882 grupos, 37077 llamadas  ← idéntico
    202503: 913 grupos, 41210 llamadas  ← idéntico

sp_etl_maestro completo Q02_26:
  1805 filas detalle, 3 clientes, 55,656 llamadas — status=SUCCESS

Prueba de atomicidad (fallo simulado mes 2):
  @@in_transaction tras el error: 0  ← TX cerrada por ROLLBACK
  Datos del mes 2 post-fallo: 882 grupos, 37077 llamadas  ← intactos

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```
