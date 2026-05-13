SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : v_sla_distribucion.sql
    Version         : 1.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : schema_base_ivr.sql — base_ivr_detalle con datos (post-ETL)
                      objetos/funciones/ivr_contar_dias_semana.sql (v3.0.0)
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < v_sla_distribucion.sql
    Notas           : PIVOT emulado con SUM(CASE WHEN) — Modulo 14.
                      Muestra cuántos centros caen en cada categoria SLA por quarter.
                      Una fila por quarter — columnas: FUERA_SLA, RIESGO_SLA, DENTRO_SLA,
                      ACTIVO_HOY, VOLUMEN_MEDIO, BAJO_VOLUMEN, total_centros.
                      Excluye centros centinela (CASO_NULL, etc.).
                      Consulta directamente sin parámetros — útil para dashboard ejecutivo.
********************************************************************************************/

-- DEFINICIÓN

DROP VIEW IF EXISTS v_sla_distribucion;

CREATE VIEW v_sla_distribucion AS
SELECT
    trimestre
    , SUM(CASE WHEN sla = 'FUERA_SLA'     THEN 1 ELSE 0 END) AS fuera_sla
    , SUM(CASE WHEN sla = 'RIESGO_SLA'    THEN 1 ELSE 0 END) AS riesgo_sla
    , SUM(CASE WHEN sla = 'DENTRO_SLA'    THEN 1 ELSE 0 END) AS dentro_sla
    , SUM(CASE WHEN sla = 'ACTIVO_HOY'    THEN 1 ELSE 0 END) AS activo_hoy
    , SUM(CASE WHEN sla = 'VOLUMEN_MEDIO' THEN 1 ELSE 0 END) AS volumen_medio
    , SUM(CASE WHEN sla = 'BAJO_VOLUMEN'  THEN 1 ELSE 0 END) AS bajo_volumen
    , COUNT(*)                                                 AS total_centros
FROM (
    SELECT
        trimestre
        , segmento
        , centro_transferencia
        , CASE
            WHEN SUM(total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                 LAST_DAY(STR_TO_DATE(CONCAT(MAX(fecha),'01'),'%Y%m%d')),
                 CURDATE()) = 0                              THEN 'ACTIVO_HOY'
            WHEN SUM(total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                 LAST_DAY(STR_TO_DATE(CONCAT(MAX(fecha),'01'),'%Y%m%d')),
                 CURDATE()) <= 3                             THEN 'DENTRO_SLA'
            WHEN SUM(total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                 LAST_DAY(STR_TO_DATE(CONCAT(MAX(fecha),'01'),'%Y%m%d')),
                 CURDATE()) <= 5                             THEN 'RIESGO_SLA'
            WHEN SUM(total_llamadas) >= 1000                THEN 'FUERA_SLA'
            WHEN SUM(total_llamadas) >= 100                 THEN 'VOLUMEN_MEDIO'
            ELSE 'BAJO_VOLUMEN'
          END AS sla
    FROM base_ivr_detalle
    WHERE centro_transferencia NOT IN
          ('CASO_NULL', 'CASO_ERROR_CEROS', 'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO')
    GROUP BY trimestre, segmento, centro_transferencia
) clasificados
GROUP BY trimestre
ORDER BY trimestre;

-- VERIFICACIÓN

SELECT * FROM v_sla_distribucion;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
