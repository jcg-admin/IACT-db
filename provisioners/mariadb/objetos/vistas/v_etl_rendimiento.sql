SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : v_etl_rendimiento.sql
    Version         : 1.0.0
    Create          : 2026-05-13
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : schema_base_ivr.sql (job_execution_log debe existir)
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < v_etl_rendimiento.sql
    Notas           : Vista de observabilidad del pipeline ETL — usa LAG() para detectar
                      regresiones de rendimiento comparando cada ejecución con la anterior.
                      Usa la columna STORED GENERATED duracion_seg de job_execution_log
                      (TIMESTAMPDIFF(SECOND, start_time, end_time)) directamente — no
                      necesita recomputar. Calculada por el motor al INSERT del row.

                      Filtro WHERE status='SUCCESS': excluye FAILED y PARTIAL
                      intencionalmente — duracion_seg de una ejecución interrumpida
                      no es representativa del tiempo real del paso y contaminaría
                      el cálculo de delta_seg con valores artificialmente bajos.

                      django_user tiene acceso via GRANT SELECT ON ivr_legacy.*
                      (grant de base aplicado por setup.sh) — no requiere grant adicional.

                      Uso operacional desde Django:
                        SELECT * FROM v_etl_rendimiento
                        WHERE step_name = 'etl_base_detalle'
                        ORDER BY start_time DESC LIMIT 10;
*********************************************************************************************/

-- DEFINICIÓN

CREATE OR REPLACE VIEW v_etl_rendimiento AS
SELECT
    job_name
    , quarter_name
    , step_name
    , status
    , start_time
    -- Columna STORED GENERATED del motor — no recomputar con TIMESTAMPDIFF.
    -- Es NULL si end_time es NULL (RUNNING/FAILED sin cierre), pero el filtro
    -- WHERE status='SUCCESS' garantiza que duracion_seg siempre tiene valor.
    , duracion_seg
    -- Duración de la ejecución anterior del mismo step en el mismo job.
    -- NULL para la primera ejecución registrada de cada (job_name, step_name).
    , LAG(duracion_seg)
        OVER (PARTITION BY job_name, step_name ORDER BY start_time)
                                                                AS duracion_anterior_seg
    -- Diferencia con la ejecución anterior:
    --   valor > 0: regresión (tardó más que la vez anterior)
    --   valor < 0: mejora
    --   valor = 0: igual
    --   NULL: primera ejecución registrada del step
    , duracion_seg
      - LAG(duracion_seg)
          OVER (PARTITION BY job_name, step_name ORDER BY start_time)
                                                                AS delta_seg
FROM job_execution_log
WHERE status = 'SUCCESS';

-- VERIFICACIÓN

SELECT
    'v_etl_rendimiento' AS nombre
    , COUNT(*)          AS filas_success
    , COUNT(DISTINCT CONCAT(job_name, '_', step_name)) AS steps_distintos
FROM v_etl_rendimiento;

-- Muestra: job, step, duracion, duracion_anterior, delta (últimas ejecuciones)
SELECT job_name, step_name, start_time, duracion_seg,
       duracion_anterior_seg, delta_seg
FROM v_etl_rendimiento
ORDER BY job_name, step_name, start_time DESC
LIMIT 10;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
