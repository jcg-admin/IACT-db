SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_clientes.sql
    Version         : 2.0.0
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
DROP PROCEDURE IF EXISTS sp_rpt_clientes$$
CREATE PROCEDURE sp_rpt_clientes(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    SELECT
        c.trimestre,
        c.segmento,
        c.clientes_unicos,
        -- Total del quarter para calcular % por segmento.
        -- NULLIF(..., 0): si el ETL falló y clientes_unicos=0 en todas las filas,
        -- SUM=0 produce NULL silencioso sin NULLIF. Con NULLIF retorna NULL explícito
        -- en lugar de dividir por cero.
        ROUND(
            c.clientes_unicos
            / NULLIF(
                (SELECT SUM(c2.clientes_unicos)
                 FROM base_ivr_clientes c2
                 WHERE c2.trimestre = p_quarter),
              0) * 100, 2
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
