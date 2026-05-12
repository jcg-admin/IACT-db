SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_base_clientes.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : funciones_utilidad.sql — schema_base_ivr.sql
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_etl_base_clientes.sql
    Notas           : COUNT DISTINCT no aditivo — scan completo del quarter. Resultado esperado: 3 filas. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_base_clientes$$
CREATE PROCEDURE sp_etl_base_clientes(
    IN p_quarter  VARCHAR(10),
    IN p_inicio   DATE,
    IN p_fin      DATE,
    IN p_table    VARCHAR(100),
    IN p_log_id   INT
)
etl_clientes: BEGIN
    DECLARE v_rows INT DEFAULT 0;

    IF p_table IS NULL OR p_table = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_base_clientes: p_table no puede ser NULL/vacío';
    END IF;

    -- DELETE idempotente para el quarter completo
    DELETE FROM base_ivr_clientes WHERE trimestre = p_quarter;

    SET @cli_sql = CONCAT('
        INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
        SELECT
            ?,
            fn_did_segmento(cDID_800Transfer)  AS segmento,
            COUNT(DISTINCT cTelefono_Origen)   AS clientes_unicos
            -- NOTA P-NEW-04: pendiente confirmar con el equipo si debe ser
            -- cTelefono_Origen (siempre presente) o cTelefono_Digitado (21% NULL).
            -- Datos reales (ratio ~3.5 llamadas/cliente) apuntan a cTelefono_Origen.
        FROM ', p_table, '
        WHERE dFecha BETWEEN ? AND ?
          AND cDID_800Transfer IN (''19020084'', ''19028031'', ''19020001'')
        GROUP BY fn_did_segmento(cDID_800Transfer)
        ON DUPLICATE KEY UPDATE
            clientes_unicos = VALUES(clientes_unicos),
            cargado_en      = CURRENT_TIMESTAMP
    ');

    PREPARE cli_stmt FROM @cli_sql;
    SET @cli_q = p_quarter, @cli_i = p_inicio, @cli_f = p_fin;
    EXECUTE cli_stmt USING @cli_q, @cli_i, @cli_f;
    SET v_rows = ROW_COUNT();
    DEALLOCATE PREPARE cli_stmt;

    IF p_log_id IS NOT NULL AND p_log_id > 0 THEN
        UPDATE job_execution_log
        SET records_procesados = v_rows,
            status             = 'SUCCESS',
            end_time           = NOW()
        WHERE id = p_log_id;
    END IF;

END etl_clientes$$

DELIMITER ;

-- VERIFICACIÓN

SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
    , DEFINER as definer
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_etl_base_clientes';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
