SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_llamadas_abandonadas.sql
    Version         : 2.1.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_llamadas_abandonadas.sql
    Notas           : v2.1.0: GROUP BY segmento,menu WITH ROLLUP — añade fila SUBTOTAL por segmento
                      y fila TOTAL con tasa global de abandono (Modulo 14).
                      Identificar filas de rollup: menu='--- SUBTOTAL ---' o segmento='TOTAL'.
                      pct_del_segmento=NULL en fila TOTAL (sin sentido para total global).
                      v2.0.0: UC_RPT_13 — menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera').
                      SLA: <20% OPTIMO / 20-30% ACEPTABLE / >30% CRITICO.
                      Despues del despliegue ejecutar provision-mariadb.sh.
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
        p_quarter                                            AS trimestre,
        -- COALESCE identifica filas de rollup: TOTAL = subtotal global
        COALESCE(b.segmento, 'TOTAL')                       AS segmento,
        -- COALESCE identifica filas de rollup: '--- SUBTOTAL ---' = total del segmento
        COALESCE(UPPER(TRIM(b.menu)), '--- SUBTOTAL ---')   AS menu,
        SUM(b.total_llamadas)                                AS total_abandonadas,
        -- % respecto al total del quarter/segmento
        ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2)
                                                             AS pct_del_total,
        -- % respecto a cada segmento individualmente
        -- CASE suprime pct_del_segmento en la fila TOTAL (b.segmento=NULL, sin denominador)
        CASE WHEN b.segmento IS NULL THEN NULL
             ELSE ROUND(
                SUM(b.total_llamadas)
                / NULLIF(
                    (SELECT SUM(b3.total_llamadas)
                     FROM base_ivr_detalle b3
                     WHERE b3.trimestre = p_quarter
                       AND b3.segmento  = b.segmento),
                  0) * 100, 2)
        END                                                  AS pct_del_segmento,
        -- Clasificación SLA (D-ETL-007 recalibrado)
        CASE
            WHEN ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) < 20
                THEN 'OPTIMO'
            WHEN ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) <= 30
                THEN 'ACEPTABLE'
            ELSE 'CRITICO'
        END                                                  AS clasificacion_sla
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    -- WITH ROLLUP: genera fila '--- SUBTOTAL ---' por segmento y fila 'TOTAL' global.
    -- b.trimestre excluido del GROUP BY (fijo por WHERE) para evitar nivel redundante.
    GROUP BY b.segmento, b.menu WITH ROLLUP;
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
