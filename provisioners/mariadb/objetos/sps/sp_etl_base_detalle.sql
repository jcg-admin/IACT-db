SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_etl_base_detalle.sql
    Version         : 2.2.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < sp_etl_base_detalle.sql
    Notas           : v2.2.0: transaccion por mes — DELETE+INSERT atomico con ROLLBACK+RESIGNAL (H-IACT-004).
                      v2.1.0: PREPARE etl_stmt movido fuera del WHILE (H-IACT-006).
                      Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_base_detalle$$
CREATE PROCEDURE sp_etl_base_detalle(
    IN p_quarter  VARCHAR(10),
    IN p_inicio   DATE,
    IN p_fin      DATE,
    IN p_table    VARCHAR(100),
    IN p_log_id   INT
)
etl_detalle: BEGIN
    DECLARE v_mes_ini    DATE;
    DECLARE v_mes_fin    DATE;
    DECLARE v_total_ins  INT DEFAULT 0;
    DECLARE v_mes_ins    INT DEFAULT 0;
    DECLARE v_mes_num    INT DEFAULT 0;

    -- Validación básica
    IF p_table IS NULL OR p_table = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_base_detalle: p_table no puede ser NULL/vacío';
    END IF;

    -- Iterar mes a mes dentro del quarter (chunks ~4M filas c/u)
    SET v_mes_ini = p_inicio;

    -- PREPARE/EXECUTE necesario por nombre de tabla dinámico (CNST-ETL-008).
    -- p_table es un parámetro IN — no cambia entre iteraciones del WHILE.
    -- Los valores que cambian por mes (v_mes_ini, v_mes_fin) se pasan
    -- vía USING como @etl_i y @etl_f — no forman parte del SQL estático.
    -- PREPARE fuera del WHILE: el statement se compila una sola vez (H-IACT-006).
    SET @etl_sql = CONCAT('
            INSERT INTO base_ivr_detalle
                (trimestre, fecha, segmento, centro_transferencia,
                 menu, opcion,
                 total_llamadas, misma_linea, linea_diferente, no_digito_telefono,
                 llamadas_entre_semana, llamadas_fines_semana)
            SELECT
                ?,                                           -- trimestre
                DATE_FORMAT(dFecha, ''%Y%m''),               -- fecha (YYYYMM)
                fn_did_segmento(cDID_800Transfer),           -- segmento
                fn_normalizar_centro(cDID_Centro_Transferencia), -- centro normalizado
                fn_normalizar_menu(cMenu),                   -- menu (VACIO si vacío)
                COALESCE(NULLIF(TRIM(cOpcion), ''''), ''SIN_OPCION''), -- opcion
                COUNT(*),                                    -- total_llamadas
                SUM(cTelefono_Origen = cTelefono_Digitado
                    AND cTelefono_Digitado IS NOT NULL),     -- misma_linea
                SUM(cTelefono_Origen != cTelefono_Digitado
                    AND cTelefono_Digitado IS NOT NULL),     -- linea_diferente
                SUM(cTelefono_Digitado IS NULL),             -- no_digito_telefono
                SUM(ivr_es_dia_semana(dFecha)),               -- llamadas_entre_semana
                SUM(NOT ivr_es_dia_semana(dFecha))            -- llamadas_fines_semana
            FROM ', p_table, '
            WHERE dFecha BETWEEN ? AND ?
              AND cDID_800Transfer IN (''19020084'', ''19028031'', ''19020001'')
            GROUP BY
                DATE_FORMAT(dFecha, ''%Y%m''),
                fn_did_segmento(cDID_800Transfer),
                fn_normalizar_centro(cDID_Centro_Transferencia),
                fn_normalizar_menu(cMenu),
                COALESCE(NULLIF(TRIM(cOpcion), ''''), ''SIN_OPCION'')
            ON DUPLICATE KEY UPDATE
                total_llamadas        = VALUES(total_llamadas),
                misma_linea           = VALUES(misma_linea),
                linea_diferente       = VALUES(linea_diferente),
                no_digito_telefono    = VALUES(no_digito_telefono),
                llamadas_entre_semana = VALUES(llamadas_entre_semana),
                llamadas_fines_semana = VALUES(llamadas_fines_semana),
                cargado_en         = CURRENT_TIMESTAMP
        ');
    PREPARE etl_stmt FROM @etl_sql;

    WHILE v_mes_ini <= p_fin DO
        SET v_mes_fin = LAST_DAY(v_mes_ini);
        -- Si el último mes del quarter termina antes del fin del mes calendario
        IF v_mes_fin > p_fin THEN
            SET v_mes_fin = p_fin;
        END IF;

        SET v_mes_num = v_mes_num + 1;

        -- Transacción por mes: DELETE + INSERT son atómicos.
        -- Si el INSERT falla, el DELETE es revertido — el mes conserva
        -- los datos de la ejecución anterior sin ventana de inconsistencia.
        -- El EXIT HANDLER hace ROLLBACK antes de RESIGNAL para que la TX
        -- quede cerrada cuando el error llegue al SP padre (sp_etl_maestro).
        -- Sin este ROLLBACK, la TX abierta viajaría al handler del padre
        -- y los UPDATEs de job_execution_log quedarían dentro de ella.
        START TRANSACTION;

        BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                ROLLBACK;
                RESIGNAL;
            END;

            -- DELETE idempotente solo para este mes
            DELETE FROM base_ivr_detalle
            WHERE trimestre = p_quarter
              AND fecha = DATE_FORMAT(v_mes_ini, '%Y%m');

            -- INSERT con normalización usando las funciones de utilidad
            SET @etl_q = p_quarter, @etl_i = v_mes_ini, @etl_f = v_mes_fin;
            EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
            SET v_mes_ins = ROW_COUNT();
        END;

        COMMIT;

        SET v_total_ins = v_total_ins + v_mes_ins;

        -- Avanzar al siguiente mes
        SET v_mes_ini = DATE_ADD(LAST_DAY(v_mes_ini), INTERVAL 1 DAY);
    END WHILE;

    DEALLOCATE PREPARE etl_stmt;

    -- Actualizar progreso en el log
    IF p_log_id IS NOT NULL AND p_log_id > 0 THEN
        UPDATE job_execution_log
        SET records_procesados = v_total_ins,
            status             = 'SUCCESS',
            end_time           = NOW()
        WHERE id = p_log_id;
    END IF;

END etl_detalle$$

DELIMITER ;

-- VERIFICACIÓN

-- Verificar que el SP existe:
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
    , DEFINER as definer
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_etl_base_detalle';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
