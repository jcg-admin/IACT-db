SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_cMENU_ERROR.sql
    Version         : 2.1.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_cMENU_ERROR.sql
    Notas           : UC_RPT_16 — Detecta numeros de telefono en cMenu (REGEXP '^[0-9]+$' AND LENGTH >= 7). Despues del despliegue ejecutar provision-mariadb.sh para restaurar GRANT EXECUTE.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

-- sp_rpt_cMENU_ERROR
-- Anomalías donde cMenu contiene un número de teléfono en lugar de un menú.
-- En base_ivr_detalle se almacenan como el número raw (no como 'telefono_cMenu').
-- El reporte agrupa todos bajo el sentinel 'telefono_cMenu' para presentación.
-- Ref: REPORTE-C-MENU.md H-6, REPORTE-LLAMADAS-CMENU.md H-5
-- UC_RPT_16
-- =============================================================================
CREATE OR REPLACE PROCEDURE sp_rpt_cMENU_ERROR(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    -- SIGNAL: validación de parámetros (Modulo 17 — equivalente a THROW/RAISERROR).
    -- SQLSTATE '22023' = Invalid parameter value (estandar SQL).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_cMENU_ERROR', '22023', 1644,
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
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_cMENU_ERROR', '22023', 1644,
                p_quarter, p_segmento,
                CONCAT('p_segmento invalido: ', p_segmento),
                'django_api');
    END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_segmento: valor no reconocido. Esperado: todas | nacional_A | nacional_B | puebla';
    END IF;

    SELECT
        b.trimestre,
        b.segmento,
        'telefono_cMenu'             AS tipo_anomalia,
        b.menu                       AS valor_cMenu_raw,  -- teléfono real del llamante
        b.centro_transferencia,      -- siempre 19020086 (bucket de abandono)
        SUM(b.total_llamadas)        AS total_llamadas,
        -- Window function reemplaza subconsulta correlacionada (T2.1 — FASE 2).
        -- OVER() sin PARTITION BY: suma todas las filas visibles tras el WHERE.
        -- Corrección respecto al análisis previo: OVER(PARTITION BY segmento)
        -- daría el total POR segmento, no el total del scope completo.
        -- Verificado: subq=119, OVER(seg)=55, OVER()=119 con p_segmento='todas'.
        SUM(SUM(b.total_llamadas)) OVER()  AS total_anomalias_quarter
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      -- Detectar números de teléfono: solo dígitos, longitud >= 7
      AND b.menu REGEXP '^[0-9]+$'
      AND LENGTH(b.menu) >= 7
    GROUP BY b.trimestre, b.segmento, b.menu, b.centro_transferencia
    ORDER BY b.segmento, total_llamadas DESC;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Ejemplo:
-- CALL sp_rpt_cMENU_ERROR('Q02_26', 'todas');
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_cMENU_ERROR';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
