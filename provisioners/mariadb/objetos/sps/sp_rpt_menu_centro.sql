-- =============================================================================
-- sp_rpt_menu_centro.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
-- DEFINER: root@localhost (SQL SECURITY DEFINER)
--
-- Prerequisito: funciones_utilidad.sql, schema_base_ivr.sql, sp_etl_pipeline.sql (base_ivr_* con datos)
-- Archivo fuente original: sp_rpt_reportes.sql
-- Despliegue:
--   mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_menu_centro.sql
-- NOTA: Despues del despliegue ejecutar provision-mariadb.sh
--       para restaurar GRANT EXECUTE (DROP PROCEDURE los elimina).
-- =============================================================================

DELIMITER $$

-- =============================================================================
-- sp_rpt_menu_centro
-- Perspectiva inversa: centro de transferencia → menús y opciones que lo alimentan.
-- Responde: ¿qué menús terminan en este centro y con qué opciones?
-- UC_RPT_16
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_menu_centro$$
CREATE PROCEDURE sp_rpt_menu_centro(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        b.centro_transferencia,
        UPPER(TRIM(b.menu))          AS menu,
        b.opcion,
        SUM(b.total_llamadas)        AS total_llamadas,
        -- % que representa este menu+opcion dentro del centro
        -- NULLIF defensivo: correlación b2.centro_transferencia = b.centro garantiza SUM > 0.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b2.total_llamadas)
                 FROM base_ivr_detalle b2
                 WHERE b2.trimestre            = p_quarter
                   AND b2.centro_transferencia = b.centro_transferencia
                   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
              0) * 100, 2
        )                            AS pct_del_centro,
        SUM(b.misma_linea)           AS misma_linea,
        SUM(b.linea_diferente)       AS linea_diferente,
        SUM(b.no_digito_telefono)    AS no_digito_telefono
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.centro_transferencia NOT IN
          ('CASO_NULL', 'CASO_ERROR_CEROS', 'ERROR_CARACTER_INICIAL')
    GROUP BY b.trimestre, b.segmento, b.centro_transferencia,
             b.menu, b.opcion
    ORDER BY b.segmento, b.centro_transferencia,
             total_llamadas DESC;
END$$

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='ivr_legacy' AND ROUTINE_NAME='sp_rpt_menu_centro';
