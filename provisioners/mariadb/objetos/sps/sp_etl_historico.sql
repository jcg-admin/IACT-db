SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_historico.sql
    Version         : 2.1.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : sp_etl_base_detalle — sp_etl_base_clientes — sp_etl_validar
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_etl_historico.sql
    Notas           : Backfill manual. Sin check de concurrencia. SLEEP(5) entre detalle y clientes. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
CREATE OR REPLACE PROCEDURE sp_etl_historico(
    IN p_year        INT,
    IN p_quarter_num INT
)
BEGIN
    DECLARE v_quarter  VARCHAR(10);
    DECLARE v_table    VARCHAR(100);
    DECLARE v_inicio   DATE;
    DECLARE v_fin      DATE;
    DECLARE v_step_id  INT;
    DECLARE v_ok       BOOLEAN;
    DECLARE v_msg      TEXT;
    DECLARE v_err_msg  TEXT;
    -- Guard: si base_ivr_detalle no se cargó, no intentar base_ivr_clientes.
    -- Sin esta bandera sp_etl_historico continuaría hacia sp_etl_base_clientes
    -- aunque la fuente no exista, generando entradas redundantes en pipeline_event_log
    -- y dejando job_execution_log con dos steps FAILED en lugar de uno.
    -- Mismo patron que sp_etl_maestro (v_detalle_cargado).
    DECLARE v_detalle_cargado BOOLEAN DEFAULT TRUE;

    -- -----------------------------------------------------------------------
    -- Validación de parámetros
    -- INSERT a pipeline_event_log antes del SIGNAL (patron T1.3).
    -- v_quarter no está calculado aún — se omite del INSERT (NULL implícito).
    -- -----------------------------------------------------------------------
    IF p_quarter_num NOT IN (1, 2, 3, 4) THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO pipeline_event_log
                (error_type, severity, sp_nombre, sql_state, mysql_errno,
                 error_message, ejecutado_por)
            VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_etl_historico', '45000', 1644,
                    CONCAT('p_quarter_num invalido: ', p_quarter_num,
                           '. Esperado: 1, 2, 3 o 4'),
                    'django_api');
        END;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_historico: p_quarter_num debe ser 1, 2, 3 o 4';
    END IF;

    -- Calcular nombres y fechas
    SET v_quarter = CONCAT('Q0', p_quarter_num, '_', RIGHT(p_year, 2));
    SET v_table   = CONCAT('tbl_historico_t', p_quarter_num, '_', p_year);
    SET v_inicio  = MAKEDATE(p_year, 1)
                    + INTERVAL (p_quarter_num - 1) * 3 MONTH;
    SET v_fin     = LAST_DAY(v_inicio + INTERVAL 2 MONTH);

    -- -----------------------------------------------------------------------
    -- Registrar inicio + cargar base_ivr_detalle
    -- EXIT HANDLER: si sp_etl_base_detalle falla → RESIGNAL propagaría sin
    -- handler y job_execution_log quedaría en RUNNING indefinidamente (GAP 2b).
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_historico', v_quarter, 'etl_base_detalle', v_table,
         'RUNNING', NOW(), 'manual');
    SET v_step_id = LAST_INSERT_ID();

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre, sql_state,
                     p_quarter, error_message, job_log_id, ejecutado_por)
                VALUES ('ETL_FALLO', 'CRITICA', 'sp_etl_historico', '45000',
                        v_quarter,
                        CONCAT('Falló etl_base_detalle: ', v_err_msg),
                        v_step_id, 'manual');
            END;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
            SET v_detalle_cargado = FALSE;
        END;
        CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    -- Pausa entre pasos (no saturar el servidor en backfill)
    DO SLEEP(5);

    -- -----------------------------------------------------------------------
    -- Cargar base_ivr_clientes
    -- Solo ejecuta si base_ivr_detalle se cargó correctamente.
    -- EXIT HANDLER análogo al de base_ivr_detalle.
    -- -----------------------------------------------------------------------
    IF v_detalle_cargado THEN

    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_historico', v_quarter, 'etl_base_clientes', v_table,
         'RUNNING', NOW(), 'manual');
    SET v_step_id = LAST_INSERT_ID();

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre, sql_state,
                     p_quarter, error_message, job_log_id, ejecutado_por)
                VALUES ('ETL_FALLO', 'CRITICA', 'sp_etl_historico', '45000',
                        v_quarter,
                        CONCAT('Falló etl_base_clientes: ', v_err_msg),
                        v_step_id, 'manual');
            END;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
        END;
        CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    END IF; -- END IF v_detalle_cargado

    -- -----------------------------------------------------------------------
    -- Validar resultado — solo si base_ivr_detalle se cargó.
    -- Si v_ok=FALSE: insertar en pipeline_event_log como VALIDACION (GAP 2c).
    -- -----------------------------------------------------------------------
    IF v_detalle_cargado THEN
        CALL sp_etl_validar(v_quarter, v_ok, v_msg);
        IF NOT COALESCE(v_ok, FALSE) THEN
            BEGIN
                DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
                INSERT INTO pipeline_event_log
                    (error_type, severity, sp_nombre,
                     p_quarter, error_message, ejecutado_por)
                VALUES ('VALIDACION', 'ALTA', 'sp_etl_validar',
                        v_quarter, v_msg, 'manual');
            END;
        END IF;
    ELSE
        -- base_ivr_detalle falló — validar no tiene sentido, indicar a Django
        SET v_ok  = FALSE;
        SET v_msg = 'ETL abortado: base_ivr_detalle no se cargó correctamente.';
    END IF;

    SELECT v_quarter AS quarter_procesado, v_ok AS ok, v_msg AS resultado;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Ejemplo de uso:
-- CALL sp_etl_historico(2025, 1);
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_etl_historico';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
