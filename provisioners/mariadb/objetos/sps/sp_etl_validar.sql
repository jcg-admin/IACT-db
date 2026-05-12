SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_validar.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : schema_base_ivr.sql — base_ivr_detalle y base_ivr_clientes deben existir
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_etl_validar.sql
    Notas           : 3 checks: detalle > 0 filas / clientes = 3 filas / total_llamadas > 0. Solo lectura. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_validar$$
CREATE PROCEDURE sp_etl_validar(
    IN  p_quarter   VARCHAR(10),
    OUT p_ok        BOOLEAN,
    OUT p_mensaje   TEXT
)
BEGIN
    DECLARE v_count_det   INT DEFAULT 0;
    DECLARE v_count_cli   INT DEFAULT 0;
    DECLARE v_sum_llamadas BIGINT DEFAULT 0;
    DECLARE v_msg         TEXT DEFAULT '';

    SELECT COUNT(*), SUM(total_llamadas)
    INTO v_count_det, v_sum_llamadas
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter;

    SELECT COUNT(*)
    INTO v_count_cli
    FROM base_ivr_clientes
    WHERE trimestre = p_quarter;

    -- Check 1: base_ivr_detalle tiene datos
    IF v_count_det = 0 THEN
        SET v_msg = CONCAT(v_msg, 'ERROR: base_ivr_detalle vacía para ', p_quarter, '. ');
    END IF;

    -- Check 2: base_ivr_clientes tiene exactamente 3 filas (una por segmento)
    IF v_count_cli != 3 THEN
        SET v_msg = CONCAT(v_msg, 'ERROR: base_ivr_clientes tiene ',
                           v_count_cli, ' filas (esperado: 3) para ', p_quarter, '. ');
    END IF;

    -- Check 3: total_llamadas > 0 (detecta INSERT exitoso pero sin datos útiles)
    IF v_sum_llamadas = 0 THEN
        SET v_msg = CONCAT(v_msg, 'ADVERTENCIA: total_llamadas = 0 en base_ivr_detalle. ');
    END IF;

    -- Resultado
    SET p_ok = (v_count_det > 0 AND v_count_cli = 3 AND v_sum_llamadas > 0);
    SET p_mensaje = IF(p_ok, CONCAT('OK — ', v_count_det, ' filas detalle, ',
                                    v_count_cli, ' filas clientes, ',
                                    FORMAT(v_sum_llamadas, 0), ' llamadas totales.'),
                            v_msg);

    -- Emitir result set para consulta directa
    SELECT
        p_quarter                        AS quarter,
        v_count_det                      AS filas_detalle,
        v_count_cli                      AS filas_clientes,
        FORMAT(v_sum_llamadas, 0)        AS total_llamadas,
        p_ok                             AS validacion_ok,
        p_mensaje                        AS mensaje;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Invocar directamente para diagnostico:
-- CALL sp_etl_validar('Q02_26', @ok, @msg);
-- SELECT @ok AS validacion_ok, @msg AS mensaje;
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_etl_validar';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
