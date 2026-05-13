# Análisis — SP_RELACIONAR_PAGOS como referencia de patrones

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Fuente:** SP_RELACIONAR_PAGOS — SQL Server 2019 — dominio: créditos y pagos  
**Propósito:** El SP procesa pagos bancarios entrantes, los relaciona con préstamos,
y registra errores. No se incluye en el proyecto — se usa como referencia de diseño.

---

## Contexto del SP

El SP recibe pagos de múltiples bancos (`BD_INGRESO_PAGOS`), valida que cada pago
tenga una referencia de préstamo válida, e inserta el depósito en `BD_DEPOSITO`.
Los errores — por referencia inválida, préstamo no encontrado, o duplicado — van
a `BD_PAGO_ERROR`. El proceso nunca aborta por un error individual: procesa todos
los pagos candidatos y registra los que fallan.

---

## Patrón 1 — Tabla variable como buffer de staging

```sql
DECLARE @PAGOS TABLE (
    ID_PAGO  BIGINT        NOT NULL,
    FECHA    DATETIME      NOT NULL,
    MONTO    NUMERIC(12,2) NOT NULL,
    STATUS   NVARCHAR(20)  NOT NULL,
    ...
);
INSERT INTO @PAGOS SELECT ... FROM BD_INGRESO_PAGOS WHERE STATUS='ACTIVO';
```

La tabla variable `@PAGOS` aisla el conjunto de trabajo. Aunque lleguen nuevos
pagos durante la ejecución del SP, `@PAGOS` ya tiene su snapshot. Los locks sobre
`BD_INGRESO_PAGOS` son mínimos — solo el UPDATE inicial a BLOQUEO y el final a
PROCESADO.

**Equivalente en IACT-db:** `base_ivr_detalle` cumple la misma función de staging,
pero es persistente entre sesiones. `@PAGOS` es efímera (muere con la sesión).

---

## Patrón 2 — Pre-bloqueo con STATUS='BLOQUEO'

```sql
UPDATE BD_INGRESO_PAGOS SET STATUS='BLOQUEO'
WHERE ID_PAGO IN (SELECT ID_PAGO FROM @PAGOS);
```

Antes de procesar, la fuente se marca como BLOQUEO. Si el SP falla a mitad de
camino, esos registros no serán reprocesados automáticamente — quedan en BLOQUEO
hasta intervención manual. Previene doble procesamiento por ejecuciones concurrentes.

**Equivalente en IACT-db:** `sp_etl_maestro` verifica concurrencia con el check
de `status='RUNNING'` en las últimas 6 horas. El DELETE+INSERT transaccional
de `sp_etl_base_detalle` logra el mismo aislamiento via atomicidad de la TX,
no via marcado de estado.

---

## Patrón 3 — Validación acumulativa sobre la tabla variable

```sql
UPDATE @PAGOS SET STATUS='NO REFERENCIA'
WHERE dbo.FUNC_IS_VALID_REFERENCIA(REFERENCIA) = 0;

UPDATE @PAGOS SET STATUS='NO REFERENCIA'
WHERE ID_PRESTAMO NOT IN (SELECT ID_PRESTAMO FROM BD_PRESTAMO WHERE STATUS IN (4,5,8,16));

UPDATE @PAGOS SET STATUS='NO REFERENCIA'
WHERE ID_SUCURSAL NOT IN (SELECT ID_SUCURSAL FROM C_SUCURSALES);

UPDATE @PAGOS SET STATUS='NO REFERENCIA'
WHERE ID_PRESTAMO NOT IN (SELECT ... WHERE SUCURSAL IN (...));
```

Cada `UPDATE` acumula rechazos. Los `ACTIVO` son los que sobrevivieron todos los
filtros. Los `NO REFERENCIA` se insertan masivamente en `BD_PAGO_ERROR` al final.

**Equivalente en IACT-db:** `sp_etl_validar` con sus 5 checks. La diferencia
de diseño: el SP valida ANTES de procesar (filtro pre-INSERT). `sp_etl_validar`
valida DESPUÉS del ETL (auditoría post-INSERT). Cada enfoque tiene sentido en
su contexto.

---

## Patrón 4 — CURSOR + @@ERROR: "procesar y continuar"

```sql
DECLARE cPAGOS_CANDIDATOS CURSOR FOR
SELECT ... FROM @PAGOS WHERE STATUS='ACTIVO';

OPEN cPAGOS_CANDIDATOS
FETCH NEXT FROM cPAGOS_CANDIDATOS INTO @ID_PAGO, ...
WHILE @@fetch_status = 0
BEGIN
    SET @ERRNUMBER = 0           -- reset por iteración

    INSERT INTO BD_DEPOSITO (...) VALUES (...);

    SET @ERRNUMBER = @@ERROR     -- capturar después del DML
    IF @ERRNUMBER <> 0
    BEGIN
        INSERT INTO BD_PAGO_ERROR (...) VALUES ('REFERENCIA ERRONEA', ...)
        -- el WHILE continúa con el siguiente pago
    END

    FETCH NEXT FROM cPAGOS_CANDIDATOS INTO ...
END
CLOSE cPAGOS_CANDIDATOS;
DEALLOCATE cPAGOS_CANDIDATOS;
```

**Semántica "procesar y continuar":** un pago fallido no aborta el SP. El error
se registra y el WHILE avanza al siguiente pago. Todos los pagos candidatos son
evaluados independientemente.

**Contraste con IACT-db:** `sp_etl_maestro` usa EXIT HANDLER + RESIGNAL — si un
mes del ETL falla, el SP completo aborta. Esto es correcto para IACT-db porque
la carga de cada mes es atómica: un mes con datos parciales es peor que un mes
sin datos. El SP de pagos procesa unidades independientes donde el fallo de una
no invalida a las demás.

**Diferencia técnica T-SQL vs MariaDB:**
- T-SQL: `@@ERROR` se evalúa DESPUÉS de cada sentencia DML
- MariaDB: no existe `@@ERROR`. El equivalente es `DECLARE EXIT HANDLER` (automático)
  o `DECLARE CONTINUE HANDLER` (mantiene el flujo como @@ERROR)

---

## Patrón 5 — BD_PAGO_ERROR: la tabla de errores usada inline con el flujo

La tabla de errores se alimenta en dos momentos distintos:

**Momento A — dentro del WHILE, error técnico:**
```sql
IF @ERRNUMBER <> 0
    INSERT INTO BD_PAGO_ERROR (..., 'REFERENCIA ERRONEA', ...)
```

**Momento B — dentro del WHILE, regla de negocio:**
```sql
ELSE  -- el depósito ya existe (duplicado)
    INSERT INTO BD_PAGO_ERROR (..., 'REFERENCIA REPETIDA', ...)
```

**Momento C — fuera del WHILE, bulk de rechazados:**
```sql
INSERT INTO BD_PAGO_ERROR (...)
SELECT ..., 'REFERENCIA DESCONOCIDA'
FROM @PAGOS WHERE STATUS='NO REFERENCIA';
```

El error se registra INLINE con la lógica de negocio, no solo en los bordes del
sistema. Esto es el patrón que `ivr_error_log` debe adoptar.

### Diseño de BD_PAGO_ERROR vs ivr_error_log

| Columna | BD_PAGO_ERROR | ivr_error_log |
|---|---|---|
| Clave | ID_PRESTAMO + ID_PAGO | id AUTO_INCREMENT |
| Timestamp | FEC_ERROR = GETDATE() | ts DATETIME(3) DEFAULT NOW(3) |
| Categoría | ERROR VARCHAR libre | error_type ENUM (vocabulario controlado) |
| Mensaje | ERROR VARCHAR libre | error_message TEXT |
| Contexto | DEPOSITO, REFERENCIA, BANCO | p_quarter, p_segmento, contexto JSON |
| Quién | ID_USUARIO, NOMBRE_ARCHIVO | ejecutado_por VARCHAR |

`ivr_error_log` mejora el diseño usando ENUM para la categoría — `BD_PAGO_ERROR`
usa VARCHAR libre, lo que permite inconsistencias de tipografía entre versiones del SP.

---

## Patrón 6 — Lo que el SP NO tiene (y sus consecuencias)

**Sin TRY/CATCH global:** si algo falla fuera del WHILE (el UPDATE inicial a BLOQUEO,
la apertura del cursor, el UPDATE final a PROCESADO), la excepción propaga al caller
sin registrarse en `BD_PAGO_ERROR`. Los registros quedan en BLOQUEO sin diagnóstico.
Este es el mismo gap que tenía `sp_etl_maestro` antes de agregar el EXIT HANDLER
para el PASO 6.

**DEADLOCK_PRIORITY 10:** instrucción T-SQL sin equivalente directo en MariaDB.
En MariaDB los deadlocks se gestionan con `innodb_lock_wait_timeout`. No aplica.

**@@fetch_status de cursores:** MariaDB usa `DECLARE CONTINUE HANDLER FOR NOT FOUND`
en lugar de `@@fetch_status`. Los cursores de IACT-db (si se usaran) seguirían
el patrón MariaDB.

---

## Lo que inspira a IACT-db

### Inspiración A — Conectar ivr_error_log con los EXIT HANDLERs de sp_etl_maestro

El SP muestra que la tabla de errores es parte del flujo de negocio, no un elemento
secundario. Los EXIT HANDLERs de sp_etl_maestro PASO 4, 5 y 6 deben INSERT a
`ivr_error_log` antes de actualizar `job_execution_log`.

**Patrón verificado en MariaDB 10.11:**

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;

    -- Proteger el INSERT al log: si falla, no enmascarar el error original
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log
            (error_type, severity, sp_nombre, sql_state,
             p_quarter, error_message, job_log_id, ejecutado_por)
        VALUES
            ('ETL_FALLO', 'CRITICA', 'sp_etl_maestro', '45000',
             v_quarter, v_err_msg, v_maestro_id, 'evt_etl_diario');
    END;

    -- Continuar con la lógica existente del handler
    UPDATE job_execution_log SET status='FAILED', end_time=NOW(),
        error_message=v_err_msg WHERE id = v_step_id;
    UPDATE job_execution_log SET status='FAILED', end_time=NOW(),
        error_message=CONCAT('Falló: ', v_err_msg) WHERE id = v_maestro_id;
    SET v_detalle_cargado = FALSE;
END;
```

El `DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END` dentro del bloque anidado
garantiza que si el INSERT a `ivr_error_log` falla (tabla bloqueada, OOM), el error
original se registra en `job_execution_log` y se propaga correctamente. El log de
errores no puede convertirse en un nuevo punto de fallo.

Verificado en motor real: `CALL _test_log_seguro(0)` → ERROR llega al caller
via RESIGNAL Y aparece en `ivr_error_log`.

### Inspiración B — Conectar ivr_error_log con los SIGNAL de los 7 SPs de reporte

Los SIGNAL actuales lanzan el error pero no lo persisten. El SP de pagos muestra
que registrar antes de lanzar es el patrón correcto:

```sql
IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    -- Registrar en ivr_error_log ANTES de lanzar
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             error_message, ejecutado_por)
        VALUES
            ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_clientes', '22023', 1644,
             CONCAT('p_quarter invalido: ', p_quarter), 'django_api');
    END;
    -- Luego lanzar como antes
    SIGNAL SQLSTATE '22023'
        SET MESSAGE_TEXT = 'p_quarter: formato invalido...';
END IF;
```

Resultado: Django recibe el error Y queda en `ivr_error_log` para análisis posterior
("¿qué endpoints llaman con parámetros inválidos? ¿con qué frecuencia?").

---

## Comparación de filosofías de manejo de errores

| Dimensión | SP_RELACIONAR_PAGOS | IACT-db |
|---|---|---|
| Granularidad | Por registro individual (pago) | Por operación completa (mes ETL) |
| Error en un ítem | Registrar + continuar | Abortar + RESIGNAL |
| Semántica | Eventual consistency aceptable | Todo o nada (atomicidad) |
| Mecanismo | `@@ERROR` + IF manual | `EXIT HANDLER` automático |
| Tabla de errores | BD_PAGO_ERROR — VARCHAR libre | ivr_error_log — ENUM estructurado |
| TRY/CATCH global | No tiene | sp_etl_maestro cubre PASO 4/5/6 |

Ninguna filosofía es superior — depende del dominio. Los pagos individuales son
independientes entre sí; los meses del ETL son dependientes (base_ivr_clientes
necesita base_ivr_detalle completo). La arquitectura de IACT-db es la correcta
para su dominio.
