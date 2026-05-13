SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_llamadas_abandonadas.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_llamadas_abandonadas.sql
    Notas           : UC_RPT_13 — menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera'). SLA: <20% OPTIMO / 20-30% ACEPTABLE / >30% CRITICO. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- sp_rpt_llamadas_abandonadas
-- Tasa de abandono por menú para el quarter y segmento indicados.
-- Abandono definido por D-ETL-006:
--   menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
-- Umbrales recalibrados (D-ETL-007):
--   < 20% óptimo | 20–30% aceptable | > 30% crítico
-- UC_RPT_13
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_llamadas_abandonadas$$
CREATE PROCEDURE sp_rpt_llamadas_abandonadas(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    -- Total del quarter + segmento (denominador para %)
    -- NULLIF(..., 0): v_total_quarter tiene DEFAULT 0. Si base_ivr_detalle
    -- no tiene filas para este quarter/segmento, SUM retorna NULL y la
    -- asignación deja v_total_quarter en 0 (no NULL, por el DEFAULT).
    -- Dividir por 0 en MariaDB produce NULL silencioso; el CASE usa NULL
    -- en las comparaciones (UNKNOWN), cayendo al ELSE='CRITICO' incorrectamente.
    DECLARE v_total_quarter BIGINT DEFAULT 0;

    SELECT SUM(total_llamadas)
    INTO v_total_quarter
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento);

    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))                          AS menu,
        SUM(b.total_llamadas)                        AS total_abandonadas,
        -- % respecto al total del quarter/segmento
        ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2)
                                                     AS pct_del_total,
        -- % respecto a cada segmento individualmente (para comparar A vs B vs Puebla)
        -- NULLIF defensivo: subconsulta correlacionada (b3.segmento = b.segmento)
        -- garantiza SUM > 0 mientras 'b' exista.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b3.total_llamadas)
                 FROM base_ivr_detalle b3
                 WHERE b3.trimestre = p_quarter
                   AND b3.segmento  = b.segmento),
              0) * 100, 2
        )                                            AS pct_del_segmento,
        -- Clasificación SLA (D-ETL-007 recalibrado)
        CASE
            WHEN ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) < 20
                THEN 'OPTIMO'
            WHEN ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) <= 30
                THEN 'ACEPTABLE'
            ELSE 'CRITICO'
        END                                          AS clasificacion_sla
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.trimestre, b.segmento, b.menu
    ORDER BY b.segmento, total_abandonadas DESC;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Ejemplo:
-- CALL sp_rpt_llamadas_abandonadas('Q02_26', 'todas');
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_llamadas_abandonadas';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
