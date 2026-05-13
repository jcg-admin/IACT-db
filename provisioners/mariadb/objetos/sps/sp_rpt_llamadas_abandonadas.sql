SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_llamadas_abandonadas.sql
    Version         : 2.2.2
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_llamadas_abandonadas.sql
    Notas           : v2.2.0: tabla derivada — pct_del_total se calcula UNA vez,
                      CASE clasificacion_sla referencia el alias (Modulo 16).
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
CREATE OR REPLACE PROCEDURE sp_rpt_llamadas_abandonadas(
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
    -- SIGNAL: validación de parámetros (Modulo 17 — equivalente a THROW/RAISERROR).
    -- SQLSTATE '22023' = Invalid parameter value (estandar SQL).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_llamadas_abandonadas', '22023', 1644,
                p_quarter,
                CONCAT('p_quarter invalido: ', p_quarter),
                'django_api');
    END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY';
    END IF;
    IF p_segmento NOT IN ('todas', 'nacional_A', 'nacional_B', 'puebla') THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, p_segmento, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_llamadas_abandonadas', '22023', 1644,
                p_quarter, p_segmento,
                CONCAT('p_segmento invalido: ', p_segmento),
                'django_api');
    END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_segmento: valor no reconocido. Esperado: todas | nacional_A | nacional_B | puebla';
    END IF;


    SELECT SUM(total_llamadas)
    INTO v_total_quarter
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento);

    -- Tabla derivada: pct_del_total se calcula UNA sola vez (Modulo 16).
    -- El SELECT externo referencia el alias — sin repetir la expresion ROUND(SUM/NULLIF).
    -- Antes: la expresion aparecia x3 (pct_del_total + 2 WHEN del CASE clasificacion_sla).
    SELECT
        p_quarter                                            AS trimestre,
        COALESCE(t.segmento, 'TOTAL')                       AS segmento,
        COALESCE(t.menu,     '--- SUBTOTAL ---')            AS menu,
        t.total_abandonadas,
        t.pct_del_total,
        -- CASE referencia alias pct_del_total del SELECT interno — sin recalcular
        CASE
            WHEN t.pct_del_total < 20  THEN 'OPTIMO'
            WHEN t.pct_del_total <= 30 THEN 'ACEPTABLE'
            ELSE 'CRITICO'
        END                                                  AS clasificacion_sla,
        -- pct_del_segmento NULL en fila TOTAL (segmento=NULL, sin denominador válido)
        CASE WHEN t.segmento IS NULL THEN NULL
             ELSE t.pct_del_segmento
        END                                                  AS pct_del_segmento
    FROM (
        SELECT
            b.segmento,
            UPPER(TRIM(b.menu))                              AS menu,
            SUM(b.total_llamadas)                            AS total_abandonadas,
            -- Una sola evaluacion de la expresion por fila del GROUP BY
            ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2)
                                                             AS pct_del_total,
            -- pct por segmento: CASE suprime en fila TOTAL (b.segmento=NULL via ROLLUP)
            CASE WHEN b.segmento IS NULL THEN NULL
                 ELSE ROUND(
                    SUM(b.total_llamadas)
                    / NULLIF(
                        (SELECT SUM(b3.total_llamadas)
                         FROM base_ivr_detalle b3
                         WHERE b3.trimestre = p_quarter
                           AND b3.segmento  = b.segmento),
                      0) * 100, 2)
            END                                              AS pct_del_segmento
        FROM base_ivr_detalle b
        WHERE b.trimestre = p_quarter
          AND (p_segmento = 'todas' OR b.segmento = p_segmento)
          AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
        GROUP BY b.segmento, b.menu WITH ROLLUP
    ) t;
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
