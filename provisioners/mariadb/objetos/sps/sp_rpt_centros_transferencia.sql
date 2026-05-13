SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_centros_transferencia.sql
    Version         : 2.1.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_centros_transferencia.sql
    Notas           : v2.1.0: JOIN con totales pre-calculados reemplaza subconsulta correlacionada para porcentaje (H-IACT-003).
                      UC_RPT_15. Despues del despliegue ejecutar provision-mariadb.sh.
*********************************************************************************************/

-- DEFINICIÓN

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
    -- totales pre-calculados por fecha para el porcentaje.
    -- Un solo scan de base_ivr_detalle en lugar de un scan por fila del resultado.
    -- La correlación (b2.fecha = b.fecha) del diseño original garantizaba SUM > 0,
    -- el LEFT JOIN con NULLIF mantiene la misma protección defensiva.
    SELECT
        b.trimestre
        , b.fecha
        , b.segmento
        , b.centro_transferencia
        , UPPER(TRIM(b.menu))          AS menu
        , b.opcion
        , b.total_llamadas
        , ROUND(
            b.total_llamadas
            / NULLIF(totales.total_mes, 0) * 100, 7
          )                            AS porcentaje
        , b.misma_linea
        , b.linea_diferente
        , b.no_digito_telefono
        , b.llamadas_entre_semana
        , b.llamadas_fines_semana
    FROM base_ivr_detalle b
    LEFT JOIN (
        SELECT
            fecha
            , SUM(total_llamadas) AS total_mes
        FROM base_ivr_detalle
        WHERE trimestre = p_quarter
          AND (p_segmento = 'todas' OR segmento = p_segmento)
        GROUP BY fecha
    ) AS totales
        ON totales.fecha = b.fecha
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
    ORDER BY
        b.fecha
        , b.segmento
        , b.total_llamadas DESC;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Ejemplo:
-- CALL sp_rpt_centros_transferencia('Q02_26', 'todas');
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_centros_transferencia';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
