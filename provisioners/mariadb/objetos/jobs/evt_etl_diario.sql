SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : evt_etl_diario.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : sp_etl_maestro debe existir. event_scheduler = ON en MariaDB.
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < evt_etl_diario.sql
    Notas           : Requiere event_scheduler=ON. Control operacional: UPDATE job_config SET is_enabled=FALSE/TRUE.
*********************************************************************************************/

-- CONFIGURACIÓN

-- Verificar que el scheduler esta activo antes de desplegar:
-- SHOW VARIABLES LIKE 'event_scheduler';

-- DEFINICIÓN



-- =============================================================================
-- evt_etl_diario — disparo nocturno automático del pipeline ETL IVR
-- Ref: T-081, HALLAZGOS-EVENT-SCHEDULER-2026-05-09.md H-081-04
-- =============================================================================

DROP EVENT IF EXISTS evt_etl_diario;

CREATE EVENT evt_etl_diario
    ON SCHEDULE EVERY 1 DAY
    STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
    COMMENT 'ETL IVR nocturno — ejecuta sp_etl_maestro()'
    DO CALL sp_etl_maestro();

-- VERIFICACIÓN

SELECT 
    EVENT_NAME as nombre
    , STATUS as estado
    , EVENT_TYPE as tipo
    , INTERVAL_VALUE as intervalo
    , INTERVAL_FIELD as unidad
    , STARTS as inicio
FROM information_schema.EVENTS
WHERE EVENT_SCHEMA = 'ivr_legacy'
    AND EVENT_NAME = 'evt_etl_diario';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
