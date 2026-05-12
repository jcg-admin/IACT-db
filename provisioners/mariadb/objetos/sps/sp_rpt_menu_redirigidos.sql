-- =============================================================================
-- sp_rpt_menu_redirigidos.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
-- DEFINER: root@localhost (SQL SECURITY DEFINER)
--
-- Prerequisito: funciones_utilidad.sql, schema_base_ivr.sql, sp_etl_pipeline.sql (base_ivr_* con datos)
-- Archivo fuente original: sp_rpt_reportes.sql
-- Despliegue:
--   mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_menu_redirigidos.sql
-- NOTA: Despues del despliegue ejecutar provision-mariadb.sh
--       para restaurar GRANT EXECUTE (DROP PROCEDURE los elimina).
-- =============================================================================

DELIMITER $$

-- Perspectiva menú → centro de transferencia.
-- Responde: ¿a qué centros redirige cada menú y con qué volumen?
-- UC_RPT_16
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_menu_redirigidos$$
CREATE PROCEDURE sp_rpt_menu_redirigidos(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))          AS menu,
        b.centro_transferencia,
        SUM(b.total_llamadas)        AS total_llamadas,
        -- % de ese menú que va a ese centro
        -- NULLIF defensivo: correlación b2.menu = b.menu garantiza SUM > 0.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b2.total_llamadas)
                 FROM base_ivr_detalle b2
                 WHERE b2.trimestre = p_quarter
                   AND b2.menu      = b.menu
                   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
              0) * 100, 2
        )                            AS pct_del_menu,
        -- % del total del quarter
        -- NULLIF defensivo: misma tabla y quarter que la consulta exterior.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b3.total_llamadas)
                 FROM base_ivr_detalle b3
                 WHERE b3.trimestre = p_quarter
                   AND (p_segmento = 'todas' OR b3.segmento = p_segmento)),
              0) * 100, 4
        )                            AS pct_del_total
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu != 'VACIO'          -- excluir llamadas sin menú identificado
      AND b.centro_transferencia NOT IN ('CASO_NULL', 'CASO_ERROR_CEROS')
    GROUP BY b.trimestre, b.segmento, b.menu, b.centro_transferencia
    ORDER BY b.segmento, UPPER(TRIM(b.menu)), total_llamadas DESC;
END$$

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='ivr_legacy' AND ROUTINE_NAME='sp_rpt_menu_redirigidos';
