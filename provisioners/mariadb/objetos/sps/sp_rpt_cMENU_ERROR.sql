SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_cMENU_ERROR.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : funciones_utilidad.sql — schema_base_ivr.sql — sp_etl_pipeline.sql (base_ivr_* con datos)
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
DROP PROCEDURE IF EXISTS sp_rpt_cMENU_ERROR$$
CREATE PROCEDURE sp_rpt_cMENU_ERROR(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        'telefono_cMenu'             AS tipo_anomalia,
        b.menu                       AS valor_cMenu_raw,  -- teléfono real del llamante
        b.centro_transferencia,      -- siempre 19020086 (bucket de abandono)
        SUM(b.total_llamadas)        AS total_llamadas,
        -- Total de anomalías en el quarter/segmento
        (SELECT SUM(b2.total_llamadas)
         FROM base_ivr_detalle b2
         WHERE b2.trimestre = p_quarter
           AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
           AND b2.menu REGEXP '^[0-9]+$'
           AND LENGTH(b2.menu) >= 7
        )                            AS total_anomalias_quarter
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
