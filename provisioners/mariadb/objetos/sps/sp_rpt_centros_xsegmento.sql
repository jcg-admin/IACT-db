-- =============================================================================
-- sp_rpt_centros_xsegmento.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
-- DEFINER: root@localhost (SQL SECURITY DEFINER)
--
-- Prerequisito: funciones_utilidad.sql, schema_base_ivr.sql, sp_etl_pipeline.sql (base_ivr_* con datos)
-- Archivo fuente original: sp_rpt_reportes.sql
-- Despliegue:
--   mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_centros_xsegmento.sql
-- NOTA: Despues del despliegue ejecutar provision-mariadb.sh
--       para restaurar GRANT EXECUTE (DROP PROCEDURE los elimina).
-- =============================================================================

DELIMITER $$

-- KPIs por centro de transferencia con clasificacion SLA y dias de semana.
-- El SP más complejo — usa todas las funciones de utilidad.
-- Requiere llamadas_entre_semana y llamadas_fines_semana en base_ivr_detalle
-- (pre-computados en el ETL con ivr_es_dia_semana).
-- UC_RPT_01, UC_RPT_15
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_centros_xsegmento$$
CREATE PROCEDURE sp_rpt_centros_xsegmento(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        b.centro_transferencia,

        -- Volumen
        SUM(b.total_llamadas)                        AS total_llamadas,
        SUM(b.misma_linea)                           AS misma_linea,
        SUM(b.linea_diferente)                       AS linea_diferente,
        SUM(b.no_digito_telefono)                    AS no_digito_telefono,

        -- Distribución por tipo de día (pre-computada en el ETL)
        SUM(b.llamadas_entre_semana)                 AS llamadas_entre_semana,
        SUM(b.llamadas_fines_semana)                 AS llamadas_fines_semana,
        ROUND(
            SUM(b.llamadas_entre_semana)
            / NULLIF(SUM(b.total_llamadas), 0) * 100, 1
        )                                            AS pct_entre_semana,

        -- Rango de actividad (primer y último mes con datos)
        STR_TO_DATE(CONCAT(MIN(b.fecha), '01'), '%Y%m%d')
                                                     AS primera_actividad,
        LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d'))
                                                     AS ultima_actividad,

        -- Dias lunes-viernes del periodo de actividad
        ivr_contar_dias_semana(
            STR_TO_DATE(CONCAT(MIN(b.fecha), '01'), '%Y%m%d'),
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d'))
        )                                            AS dias_semana_periodo,

        -- Dias lunes-viernes transcurridos desde la ultima actividad hasta hoy
        ivr_contar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
            CURDATE()
        )                                            AS dias_semana_sin_actividad,

        -- Fechas de seguimiento (SLA operativo del equipo)
        ivr_agregar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')), 1
        )                                            AS fecha_seguimiento_1_dia,
        ivr_agregar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')), 3
        )                                            AS fecha_seguimiento_3_dias,
        ivr_agregar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')), 5
        )                                            AS fecha_escalamiento,

        -- Clasificación SLA
        -- Basada en volumen total y dias de semana sin actividad reciente
        -- Ref: ANALISIS-ARQUITECTURA-ETL.md, BR-016 recalibrado (D-ETL-007)
        CASE
            WHEN SUM(b.total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                     LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
                     CURDATE()) = 0
                THEN 'ACTIVO_HOY'
            WHEN SUM(b.total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                     LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
                     CURDATE()) <= 3
                THEN 'DENTRO_SLA'
            WHEN SUM(b.total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                     LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
                     CURDATE()) <= 5
                THEN 'RIESGO_SLA'
            WHEN SUM(b.total_llamadas) >= 1000
                THEN 'FUERA_SLA'
            WHEN SUM(b.total_llamadas) >= 100
                THEN 'VOLUMEN_MEDIO'
            ELSE 'BAJO_VOLUMEN'
        END                                          AS clasificacion_sla,

        -- % del total del quarter para ese segmento
        -- NULLIF defensivo: correlación b2.segmento = b.segmento garantiza SUM > 0.
        ROUND(
            SUM(b.total_llamadas)
            / NULLIF(
                (SELECT SUM(b2.total_llamadas)
                 FROM base_ivr_detalle b2
                 WHERE b2.trimestre = p_quarter
                   AND b2.segmento  = b.segmento),
              0) * 100, 4
        )                                            AS pct_del_segmento

    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      -- Excluir sentinels de error — centros que no son VDNs reales
      AND b.centro_transferencia NOT IN
          ('CASO_NULL', 'CASO_ERROR_CEROS', 'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO')
    GROUP BY
        b.trimestre,
        b.segmento,
        b.centro_transferencia
    ORDER BY
        b.segmento,
        total_llamadas DESC;
END$$

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ROUTINE_NAME, ROUTINE_TYPE FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='ivr_legacy' AND ROUTINE_NAME='sp_rpt_centros_xsegmento';
