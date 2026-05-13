SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_maestro.sql
    Version         : 2.5.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : sp_etl_base_detalle — sp_etl_base_clientes — sp_etl_validar — schema_base_ivr.sql
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < sp_etl_maestro.sql
    Notas           : v2.3.0: LEAVE etl_maestro reemplaza v_abort flag (Modulo 16).
                      Elimina IF NOT v_abort anidado — flujo secuencial lineal.
                      Notas           : v2.2.0: renombrar v_paso4_failed → v_detalle_cargado (clean code).
                      v2.1.0: guardar PASO 5 y PASO 7 cuando base_ivr_detalle no se carga.
                      Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
CREATE OR REPLACE PROCEDURE sp_etl_maestro()
-- Label de bloque: permite LEAVE etl_maestro para salida temprana (Modulo 16).
-- LEAVE es valido desde el body principal del SP.
-- La restriccion de MariaDB aplica a LEAVE desde EXIT HANDLER — no desde aqui.
-- Patron: IF condicion THEN LEAVE etl_maestro; END IF; reemplaza v_abort flag.
etl_maestro: BEGIN
    DECLARE v_year       INT;
    DECLARE v_qnum       INT;
    DECLARE v_quarter    VARCHAR(10);
    DECLARE v_table      VARCHAR(100);
    DECLARE v_inicio     DATE;
    DECLARE v_fin        DATE;
    DECLARE v_maestro_id INT;
    DECLARE v_step_id    INT;
    DECLARE v_enabled    BOOLEAN;
    DECLARE v_timeout    INT;
    DECLARE v_ok         BOOLEAN;
    DECLARE v_msg        TEXT;
    DECLARE v_err_msg    TEXT;
    -- TRUE mientras base_ivr_detalle se cargó correctamente.
    -- FALSE si el ETL de detalle falló — impide cargar base_ivr_clientes
    -- con datos inconsistentes y preserva el status FAILED del maestro.
    DECLARE v_detalle_cargado BOOLEAN DEFAULT TRUE;

    -- -----------------------------------------------------------------------
    -- PASO 0: Verificar que el job está habilitado
    -- LEAVE: si el job no está habilitado, registrar SKIP y salir.
    -- No hay v_maestro_id aún — no hay nada más que actualizar.
    -- -----------------------------------------------------------------------
    SELECT is_enabled, timeout_seconds
    INTO v_enabled, v_timeout
    FROM job_config
    WHERE job_name = 'etl_diario';

    IF NOT v_enabled THEN
        INSERT INTO job_execution_log
            (job_name, step_name, status, start_time, end_time, ejecutado_por)
        VALUES ('etl_diario', 'maestro', 'SKIP', NOW(), NOW(), 'evt_etl_diario');
        LEAVE etl_maestro;
    END IF;

    -- -----------------------------------------------------------------------
    -- PASO 1: Verificar concurrencia (ventana mínima de 6 horas)
    -- LEAVE: si hay un job RUNNING reciente, registrar SKIP y salir.
    -- -----------------------------------------------------------------------
    IF EXISTS (
        SELECT 1 FROM job_execution_log
        WHERE job_name = 'etl_diario'
          AND step_name = 'maestro'
          AND status = 'RUNNING'
          AND start_time > DATE_SUB(NOW(), INTERVAL 6 HOUR)
    ) THEN
        INSERT INTO job_execution_log
            (job_name, step_name, status, start_time, end_time, ejecutado_por,
             error_message)
        VALUES ('etl_diario', 'maestro', 'SKIP', NOW(), NOW(), 'evt_etl_diario',
                'Otro job etl_diario está RUNNING en las últimas 6 horas.');
        LEAVE etl_maestro;
    END IF;

    -- -----------------------------------------------------------------------
    -- PASO 2: Calcular quarter y tabla fuente (dinámico — cualquier año)
    -- -----------------------------------------------------------------------
    SET v_year  = YEAR(CURDATE());
    SET v_qnum  = QUARTER(CURDATE());
    SET v_quarter = CONCAT('Q0', v_qnum, '_', RIGHT(v_year, 2));
    SET v_table   = CONCAT('tbl_historico_t', v_qnum, '_', v_year);

    SET v_inicio = MAKEDATE(v_year, 1)
                   + INTERVAL (v_qnum - 1) * 3 MONTH;
    SET v_fin    = LAST_DAY(v_inicio + INTERVAL 2 MONTH);

    -- -----------------------------------------------------------------------
    -- PASO 3: Registrar inicio del maestro
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_diario', v_quarter, 'maestro', v_table,
         'RUNNING', NOW(), 'evt_etl_diario');
    SET v_maestro_id = LAST_INSERT_ID();

    -- -----------------------------------------------------------------------
    -- PASO 4: ETL base_ivr_detalle
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_diario', v_quarter, 'etl_base_detalle', v_table,
         'RUNNING', NOW(), 'evt_etl_diario');
    SET v_step_id = LAST_INSERT_ID();

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            -- Registrar en pipeline_event_log antes de actualizar job_execution_log.
            -- CONTINUE HANDLER interno: si el INSERT al log falla, no enmascara el error.
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre, sql_state,
                     p_quarter, error_message, job_log_id, ejecutado_por)
                VALUES ('ETL_FALLO', 'CRITICA', 'sp_etl_maestro', '45000',
                        v_quarter,
                        CONCAT('Falló etl_base_detalle: ', v_err_msg),
                        v_maestro_id, 'evt_etl_diario');
            END;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(),
                error_message=CONCAT('Falló etl_base_detalle: ', v_err_msg)
            WHERE id = v_maestro_id;
            -- base_ivr_detalle no se cargó — base_ivr_clientes no debe cargarse.
            SET v_detalle_cargado = FALSE;
        END;
        CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    -- -----------------------------------------------------------------------
    -- PASO 5: ETL base_ivr_clientes
    -- Solo ejecuta si base_ivr_detalle se cargó correctamente.
    -- Sin detalle válido, los clientes quedarían sin contexto de llamadas.
    -- -----------------------------------------------------------------------
    IF v_detalle_cargado THEN

    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_diario', v_quarter, 'etl_base_clientes', v_table,
         'RUNNING', NOW(), 'evt_etl_diario');
    SET v_step_id = LAST_INSERT_ID();

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            -- Registrar en pipeline_event_log antes de actualizar job_execution_log.
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre, sql_state,
                     p_quarter, error_message, job_log_id, ejecutado_por)
                VALUES ('ETL_FALLO', 'CRITICA', 'sp_etl_maestro', '45000',
                        v_quarter,
                        CONCAT('Falló etl_base_clientes: ', v_err_msg),
                        v_maestro_id, 'evt_etl_diario');
            END;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(),
                error_message=CONCAT('Falló etl_base_clientes: ', v_err_msg)
            WHERE id = v_maestro_id;
            -- Mismo patrón que el handler del PASO 4 (sp_etl_base_detalle).
            -- Si sp_etl_validar o cualquier sentencia posterior también falla
            -- y la excepción propaga fuera de sp_etl_maestro, el PASO 7 no
            -- se ejecutará y v_maestro_id quedaría RUNNING indefinidamente.
            -- Con este UPDATE el maestro queda FAILED de inmediato — el check
            -- de concurrencia del PASO 1 solo bloquea en status='RUNNING',
            -- no en 'FAILED', por lo que la siguiente ejecución puede proceder.
        END;
        CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    END IF; -- END IF v_detalle_cargado (PASO 5)

    -- -----------------------------------------------------------------------
    -- PASO 6: Validación post-load
    -- Envuelto en BEGIN...END con EXIT HANDLER (Modulo 17).
    -- Si sp_etl_validar falla inesperadamente (error de infraestructura),
    -- el handler marca el maestro como PARTIAL — no lo deja RUNNING.
    -- sp_etl_validar ya maneja sus propios errores internos via EXIT HANDLER,
    -- retornando p_ok=FALSE. Este handler captura fallos externos al SP.
    -- -----------------------------------------------------------------------
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            -- Registrar en pipeline_event_log antes de actualizar job_execution_log.
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre, sql_state,
                     p_quarter, error_message, job_log_id, ejecutado_por)
                VALUES ('ETL_PARTIAL', 'ALTA', 'sp_etl_maestro', '45000',
                        v_quarter,
                        CONCAT('Error en sp_etl_validar: ', v_err_msg),
                        v_maestro_id, 'evt_etl_diario');
            END;
            UPDATE job_execution_log
            SET status='PARTIAL', end_time=NOW(),
                error_message=CONCAT('Error en sp_etl_validar: ', v_err_msg)
            WHERE id = v_maestro_id;
        END;
        CALL sp_etl_validar(v_quarter, v_ok, v_msg);
    END;

    -- -----------------------------------------------------------------------
    -- PASO 7: Estado final del maestro
    -- Si base_ivr_detalle no se cargó, el handler ya marcó el maestro como
    -- FAILED. No sobreescribir con PARTIAL — el dato de dominio manda.
    -- -----------------------------------------------------------------------
    IF NOT v_detalle_cargado THEN
        -- El handler ya fijó status=FAILED y error_message.
        -- Garantizar que end_time quede seteado.
        UPDATE job_execution_log
        SET end_time = COALESCE(end_time, NOW())
        WHERE id = v_maestro_id;
    ELSE
        -- Cuando v_ok=FALSE: la validacion de negocio detectó inconsistencias.
        -- Registrar en pipeline_event_log (error_type VALIDACION) antes del UPDATE.
        IF NOT COALESCE(v_ok, FALSE) THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre,
                     p_quarter, error_message, job_log_id, ejecutado_por)
                VALUES ('VALIDACION', 'ALTA', 'sp_etl_validar',
                        v_quarter, v_msg, v_maestro_id, 'evt_etl_diario');
            END;
        END IF;
        UPDATE job_execution_log
        SET status        = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL'),
            end_time      = NOW(),
            error_message = IF(COALESCE(v_ok, FALSE), NULL, v_msg)
        WHERE id = v_maestro_id;
    END IF;

END etl_maestro$$

DELIMITER ;

-- VERIFICACIÓN

-- Verificar ultimas ejecuciones:
SELECT 
    step_name as paso
    , status
    , start_time
    , records_procesados
    , LEFT(COALESCE(error_message,''), 60) AS error
FROM job_execution_log
WHERE job_name = 'etl_diario'
ORDER BY id DESC
LIMIT 5;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
