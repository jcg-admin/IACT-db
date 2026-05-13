SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_menu_redirigidos.sql
    Version         : 2.1.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_menu_redirigidos.sql
    Notas           : UC_RPT_16 — Perspectiva menu → centro. Excluye menu='VACIO' y sentinels de centro. Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- Perspectiva menú → centro de transferencia.
-- Responde: ¿a qué centros redirige cada menú y con qué volumen?
-- UC_RPT_16
-- =============================================================================
CREATE OR REPLACE PROCEDURE sp_rpt_menu_redirigidos(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    -- Variable para el denominador de pct_del_total (T2.4 — FASE 2).
    -- Calculada UNA sola vez antes del SELECT — reemplaza la subconsulta b3
    -- que se ejecutaba N veces (una por fila del GROUP BY).
    -- Incluye VACIO y centros centinela (misma semántica que la subq2 original).
    -- No puede reemplazarse con OVER(): el WHERE del SP excluye VACIO y centinelas
    -- pero la subq2 original NO los excluía — los denominadores difieren en 9,566
    -- filas cuando hay datos de VACIO. Verificado con datos Q01_25: subq2=119,205,
    -- OVER()=109,639, diferencia=9,566 → KPI diferente.
    DECLARE v_total_scope BIGINT DEFAULT 0;
    -- SIGNAL: validación de parámetros (Modulo 17 — equivalente a THROW/RAISERROR).
    -- SQLSTATE '22023' = Invalid parameter value (estandar SQL).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_menu_redirigidos', '22023', 1644,
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
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_menu_redirigidos', '22023', 1644,
                p_quarter, p_segmento,
                CONCAT('p_segmento invalido: ', p_segmento),
                'django_api');
    END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_segmento: valor no reconocido. Esperado: todas | nacional_A | nacional_B | puebla';
    END IF;

    -- Pre-calcular denominador de pct_del_total: respeta el filtro de segmento
    -- pero incluye VACIO y todos los centros (mismo alcance que la subq2 original).
    SELECT SUM(total_llamadas)
    INTO v_total_scope
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento);

    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))          AS menu,
        b.centro_transferencia,
        SUM(b.total_llamadas)        AS total_llamadas,
        -- Window function reemplaza subq1 (T2.4 FASE 2).
        -- OVER(PARTITION BY menu): total del menú M entre todos los segmentos
        -- visibles en el WHERE. Corrección respecto al análisis previo:
        -- OVER(PARTITION BY segmento,menu) daría per-segment, no cross-segment.
        -- Verificado: SinOpcion_Cabecera todas → subq=96.32% wf=96.32% ✓
        --             SinOpcion_Cabecera nac_A → subq=96.76% wf=96.76% ✓
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.menu),
              0) * 100, 2
        )                            AS pct_del_menu,
        -- Variable v_total_scope reemplaza subq2 (T2.4 FASE 2).
        -- No es OVER(): subq2 original incluye VACIO y centros centinela como
        -- denominador — OVER() los excluiría (diferencia de 9,566 filas en Q01_25).
        -- v_total_scope se calcula UNA vez antes del SELECT (SELECT...INTO arriba).
        -- Verificado: cliente_colgo pct_del_total → subq=22.6836% variable=22.6836% ✓
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(v_total_scope, 0) * 100, 4
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

-- VERIFICACIÓN

-- Ejemplo:
-- CALL sp_rpt_menu_redirigidos('Q02_26', 'todas');
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_menu_redirigidos';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
