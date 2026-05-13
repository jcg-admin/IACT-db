SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : v_quarter_actual.sql
    Version         : 1.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : schema_base_ivr.sql
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < v_quarter_actual.sql
    Notas           : Equivalente MariaDB de CREATE SYNONYM (Modulo 16).
                      MariaDB no soporta SYNONYM — VIEW es la alternativa para encapsular
                      lógica de cálculo compartida entre sp_etl_maestro y sp_etl_historico.
                      Centraliza la lógica de quarter en un solo lugar:
                        YEAR/QUARTER/CURDATE() → quarter, tabla_origen, fecha_inicio, fecha_fin
                      Django puede consultar esta vista para conocer el quarter activo sin
                      llamar a un SP ni replicar la lógica de cálculo en el cliente.
*********************************************************************************************/

-- DEFINICIÓN

CREATE OR REPLACE VIEW v_quarter_actual AS
SELECT
    -- Nombre del quarter en formato Q0N_YY
    CONCAT('Q0', QUARTER(CURDATE()), '_', RIGHT(YEAR(CURDATE()), 2))        AS quarter
    -- Nombre de la tabla fuente dinámica de tbl_historico
    , CONCAT('tbl_historico_t', QUARTER(CURDATE()), '_', YEAR(CURDATE()))   AS tabla_origen
    -- Primer día del quarter actual
    , MAKEDATE(YEAR(CURDATE()), 1)
      + INTERVAL (QUARTER(CURDATE()) - 1) * 3 MONTH                         AS fecha_inicio
    -- Último día del quarter actual
    , LAST_DAY(
        MAKEDATE(YEAR(CURDATE()), 1)
        + INTERVAL QUARTER(CURDATE()) * 3 - 1 MONTH
      )                                                                       AS fecha_fin;

-- VERIFICACIÓN

SELECT
    'v_quarter_actual' AS nombre
    , quarter
    , tabla_origen
    , fecha_inicio
    , fecha_fin
FROM v_quarter_actual;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
