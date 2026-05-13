SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_historico.sql
    Version         : 2.0.0
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

    -- Validación de parámetros
    IF p_quarter_num NOT IN (1, 2, 3, 4) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_historico: p_quarter_num debe ser 1, 2, 3 o 4';
    END IF;

    -- Calcular nombres y fechas
    SET v_quarter = CONCAT('Q0', p_quarter_num, '_', RIGHT(p_year, 2));
    SET v_table   = CONCAT('tbl_historico_t', p_quarter_num, '_', p_year);
    SET v_inicio  = MAKEDATE(p_year, 1)
                    + INTERVAL (p_quarter_num - 1) * 3 MONTH;
    SET v_fin     = LAST_DAY(v_inicio + INTERVAL 2 MONTH);

    -- Registrar en log como job histórico
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_historico', v_quarter, 'etl_base_detalle', v_table,
         'RUNNING', NOW(), 'manual');
    SET v_step_id = LAST_INSERT_ID();

    CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);

    -- Pausa entre pasos (no saturar el servidor en backfill)
    DO SLEEP(5);

    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_historico', v_quarter, 'etl_base_clientes', v_table,
         'RUNNING', NOW(), 'manual');
    SET v_step_id = LAST_INSERT_ID();

    CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);

    -- Validar resultado
    CALL sp_etl_validar(v_quarter, v_ok, v_msg);

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
