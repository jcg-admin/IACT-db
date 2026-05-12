-- =============================================================================
-- sp_rpt_centros_transferencia.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
-- DEFINER: root@localhost (SQL SECURITY DEFINER)
--
-- Prerequisito: funciones_utilidad.sql, schema_base_ivr.sql, sp_etl_pipeline.sql (base_ivr_* con datos)
-- Archivo fuente original: sp_rpt_reportes.sql
-- Despliegue:
--   mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_centros_transferencia.sql
-- NOTA: Despues del despliegue ejecutar provision-mariadb.sh
--       para restaurar GRANT EXECUTE (DROP PROCEDURE los elimina).
-- =============================================================================

DELIMITER $$

-- =============================================================================
-- sp_rpt_centros_transferencia
-- Detalle de transferencias: fecha × segmento × centro × menú × opción.
-- Incluye métricas de comportamiento del llamante.
-- UC_RPT_15
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_centros_transferencia$$
CREATE PROCEDURE sp_rpt_centros_transferencia(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.fecha,                                     -- YYYYMM
        b.segmento,
        b.centro_transferencia,
        UPPER(TRIM(b.menu))          AS menu,         -- UPPERCASE para presentación
        b.opcion,
        b.total_llamadas,
        -- NULLIF defensivo: la subconsulta correlacionada (b2.fecha = b.fecha)
        -- garantiza SUM > 0 mientras 'b' exista, pero se aplica por consistencia
        -- con el resto de los SPs de reporte.
        ROUND(
            b.total_llamadas
            / NULLIF(
                (SELECT SUM(b2.total_llamadas)
                 FROM base_ivr_detalle b2
                 WHERE b2.trimestre = p_quarter
                   AND b2.fecha     = b.fecha
                   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
              0) * 100, 7
        )                            AS porcentaje,
        b.misma_linea,
        b.linea_diferente,
        b.no_digito_telefono,
        b.llamadas_entre_semana,
        b.llamadas_fines_semana
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
    ORDER BY b.fecha, b.segmento, b.total_llamadas DESC;
END$$

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='ivr_legacy' AND ROUTINE_NAME='sp_rpt_centros_transferencia';
