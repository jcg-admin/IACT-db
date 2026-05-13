SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_clientes.sql
    Version         : 2.1.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_clientes.sql
    Notas           : UC_RPT_17 — Lee base_ivr_clientes. 3 filas por quarter. NULLIF protege la division por SUM=0. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- =============================================================================
-- sp_rpt_clientes
-- Clientes únicos por quarter y segmento.
-- Lee base_ivr_clientes (3 filas por quarter — una por segmento).
-- UC_RPT_17
-- =============================================================================
CREATE OR REPLACE PROCEDURE sp_rpt_clientes(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    -- SIGNAL: validación de parámetros (Modulo 17 — equivalente a THROW/RAISERROR).
    -- SQLSTATE '22023' = Invalid parameter value (estandar SQL).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_clientes', '22023', 1644,
                p_quarter,
                CONCAT('p_quarter invalido: ', p_quarter),
                'django_api');
    END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY';
    END IF;

    SELECT
        c.trimestre,
        c.segmento,
        c.clientes_unicos,
        -- Window function reemplaza subconsulta (T2.3 — FASE 2).
        -- OVER() sin PARTITION BY: base_ivr_clientes solo tiene 3 filas por quarter
        -- (una por segmento). SUM() OVER() suma los 3 — idéntico a la subquery original.
        -- Verificado con Q02_25: pct_subq = pct_wf en los 3 segmentos.
        -- NULLIF defensivo: si ETL falló, SUM=0 → NULL explícito, no división por cero.
        ROUND(
            c.clientes_unicos
            / NULLIF(SUM(c.clientes_unicos) OVER(), 0) * 100, 2
        )                       AS pct_del_total,
        c.cargado_en            AS ultima_actualizacion
    FROM base_ivr_clientes c
    WHERE c.trimestre = p_quarter
    ORDER BY c.clientes_unicos DESC;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Ejemplo:
-- CALL sp_rpt_clientes('Q02_26');
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_clientes';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
