SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_resumen_abandono_rollup.sql
    Version         : 1.0.0
    Create          : 2026-05-13
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : schema_base_ivr.sql, schema_pipeline_event_log.sql
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_resumen_abandono_rollup.sql
    Notas           : SP de resumen ejecutivo para el dashboard de abandono.
                      Diferencia de sp_rpt_llamadas_abandonadas:
                        - sp_rpt_llamadas_abandonadas: detalle con pct_del_segmento y
                          clasificacion_sla. No usa ROLLUP — la subconsulta de pct_del_segmento
                          es incompatible con filas ROLLUP (denominador NULL en TOTAL).
                        - sp_rpt_resumen_abandono_rollup: jerarquía completa en una llamada.
                          Entrega detalle + subtotal por segmento + TOTAL global.
                          KPI: pct_del_quarter es % sobre el total de los 3 menús
                          (no % del total de llamadas del quarter).
                          Fila TOTAL siempre muestra 100.00%.

                      WITH ROLLUP genera automáticamente:
                        - Filas de detalle: (segmento, menu)
                        - Subtotales: (segmento, NULL) → COALESCE → '--- SUBTOTAL ---'
                        - Grand total: (NULL, NULL) → COALESCE → TOTAL / '--- SUBTOTAL ---'

                      v_total: pre-calculado antes del SELECT para evitar subconsulta
                      correlacionada N-veces. Cubre solo los 3 menús del análisis —
                      el denominador es "total de abandono" no "total del quarter".

                      Diseñado para uso desde Django sin parámetro de segmento:
                      el SP siempre devuelve la jerarquía completa de los 3 segmentos.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

CREATE OR REPLACE PROCEDURE sp_rpt_resumen_abandono_rollup(
    IN p_quarter VARCHAR(10)
)
BEGIN
    DECLARE v_total BIGINT DEFAULT 0;

    -- Validación: p_quarter debe tener formato Q0N_YY
    -- Patrón: INSERT a pipeline_event_log antes del SIGNAL (FASE 1 — T1.3).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO pipeline_event_log
                (error_type, severity, sp_nombre, sql_state, mysql_errno,
                 p_quarter, error_message, ejecutado_por)
            VALUES ('PARAM_INVALIDO', 'MEDIA',
                    'sp_rpt_resumen_abandono_rollup', '22023', 1644,
                    p_quarter,
                    CONCAT('p_quarter invalido: ', p_quarter,
                           '. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY'),
                    'django_api');
        END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY';
    END IF;

    -- Pre-calcular el total de los 3 menús de abandono para el denominador.
    -- Una sola ejecución — no depende del segmento (el SP no filtra por segmento).
    -- El denominador son las llamadas abandonadas totales del quarter, no el
    -- total de todas las llamadas. La fila TOTAL siempre mostrará 100.00%.
    SELECT SUM(total_llamadas)
    INTO v_total
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera');

    -- Resultado con jerarquía completa:
    --   Nivel 1: (segmento, menu)         — detalle
    --   Nivel 2: (segmento, NULL→SUBTOTAL) — total por segmento
    --   Nivel 3: (NULL→TOTAL, NULL→SUBTOTAL) — grand total del quarter
    SELECT
        p_quarter                                                   AS trimestre
        -- COALESCE identifica filas generadas por ROLLUP:
        --   segmento=NULL  → 'TOTAL' (fila grand total)
        --   menu=NULL      → '--- SUBTOTAL ---' (fila de subtotal)
        , COALESCE(b.segmento, 'TOTAL')                            AS segmento
        , COALESCE(UPPER(TRIM(b.menu)), '--- SUBTOTAL ---')        AS menu
        , SUM(b.total_llamadas)                                     AS abandonadas
        -- % respecto al total de abandono del quarter (no % del total de llamadas).
        -- La fila TOTAL siempre muestra 100.00%.
        -- NULLIF defensivo: si v_total=0 (ETL no cargó datos), retorna NULL.
        , ROUND(SUM(b.total_llamadas) / NULLIF(v_total, 0) * 100, 2) AS pct_del_quarter
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.segmento, b.menu WITH ROLLUP;
END$$

DELIMITER ;

-- VERIFICACIÓN

SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_resumen_abandono_rollup';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
