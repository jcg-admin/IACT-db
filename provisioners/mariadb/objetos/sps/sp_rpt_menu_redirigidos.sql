SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_menu_redirigidos.sql
    Version         : 2.0.1
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
    -- SIGNAL: validación de parámetros (Modulo 17 — equivalente a THROW/RAISERROR).
    -- SQLSTATE '22023' = Invalid parameter value (estandar SQL).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY';
    END IF;
    IF p_segmento NOT IN ('todas', 'nacional_A', 'nacional_B', 'puebla') THEN
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_segmento: valor no reconocido. Esperado: todas | nacional_A | nacional_B | puebla';
    END IF;

    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))          AS menu,
        b.centro_transferencia,
        SUM(b.total_llamadas)        AS total_llamadas,
        -- % de ese menú que va a ese centro
        -- NULLIF defensivo: correlación b2.menu = b.menu garantiza SUM > 0.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b2.total_llamadas)
                 FROM base_ivr_detalle b2
                 WHERE b2.trimestre = p_quarter
                   AND b2.menu      = b.menu
                   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
              0) * 100, 2
        )                            AS pct_del_menu,
        -- % del total del quarter
        -- NULLIF defensivo: misma tabla y quarter que la consulta exterior.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b3.total_llamadas)
                 FROM base_ivr_detalle b3
                 WHERE b3.trimestre = p_quarter
                   AND (p_segmento = 'todas' OR b3.segmento = p_segmento)),
              0) * 100, 4
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
