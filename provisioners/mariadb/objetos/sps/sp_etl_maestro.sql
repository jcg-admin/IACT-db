SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_maestro.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : sp_etl_base_detalle — sp_etl_base_clientes — sp_etl_validar — schema_base_ivr.sql
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_etl_maestro.sql
    Notas           : Orquestador principal. 7 pasos con checkpoints. Calcula quarter automaticamente. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_maestro$$
CREATE PROCEDURE sp_etl_maestro()
BEGIN
    -- FIX: eliminados labels de bloque y LEAVE en handlers anidados.
    -- MariaDB 10.11 no permite LEAVE de bloque externo desde EXIT HANDLER.
    -- Patron reemplazado: variable v_abort como flag de salida temprana.
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
    DECLARE v_abort      BOOLEAN DEFAULT FALSE;

    -- -----------------------------------------------------------------------
    -- PASO 0: Verificar que el job está habilitado
    -- -----------------------------------------------------------------------
    SELECT is_enabled, timeout_seconds
    INTO v_enabled, v_timeout
    FROM job_config
    WHERE job_name = 'etl_diario';

    IF NOT v_enabled THEN
        INSERT INTO job_execution_log
            (job_name, step_name, status, start_time, end_time, ejecutado_por)
        VALUES ('etl_diario', 'maestro', 'SKIP', NOW(), NOW(), 'evt_etl_diario');
        SET v_abort = TRUE;
    END IF;

    -- -----------------------------------------------------------------------
    -- PASO 1: Verificar concurrencia (ventana mínima de 6 horas)
    -- -----------------------------------------------------------------------
    IF NOT v_abort AND EXISTS (
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
        SET v_abort = TRUE;
    END IF;

    IF NOT v_abort THEN

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
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(),
                error_message=CONCAT('Falló etl_base_detalle: ', v_err_msg)
            WHERE id = v_maestro_id;
            -- No LEAVE: el handler termina y el bloque externo continua
            -- v_ok quedara NULL, el UPDATE final marcara PARTIAL
        END;
        CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    -- -----------------------------------------------------------------------
    -- PASO 5: ETL base_ivr_clientes
    -- -----------------------------------------------------------------------
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

    -- -----------------------------------------------------------------------
    -- PASO 6: Validación post-load
    -- -----------------------------------------------------------------------
    CALL sp_etl_validar(v_quarter, v_ok, v_msg);

    -- -----------------------------------------------------------------------
    -- PASO 7: Estado final del maestro
    -- -----------------------------------------------------------------------
    UPDATE job_execution_log
    SET status     = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL'),
        end_time   = NOW(),
        error_message = IF(COALESCE(v_ok, FALSE), NULL, v_msg)
    WHERE id = v_maestro_id;

    END IF; -- END IF NOT v_abort

END$$

DELIMITER ;

-- VERIFICACIÓN

-- Verificar ultimas ejecuciones:
SELECT 
    step_name as paso
    , status
    , start_time
    , records_procesados
    , LEFT(error_message, 60) AS error
FROM job_execution_log
WHERE job_name = 'etl_diario'
ORDER BY id DESC
LIMIT 5;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
