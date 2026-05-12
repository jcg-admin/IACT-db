-- =============================================================================
-- evt_etl_diario.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: sp_etl_maestro (debe existir antes de crear el event)
-- Archivo fuente original: sp_etl_pipeline.sql
-- Despliegue:
--   mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < evt_etl_diario.sql
-- REQUISITO: event_scheduler = ON en MariaDB
--   SET GLOBAL event_scheduler = ON;
-- =============================================================================

-- Verificar que event_scheduler esta activo antes de desplegar:
-- SHOW VARIABLES LIKE 'event_scheduler';



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

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT EVENT_NAME, STATUS, EVENT_TYPE, INTERVAL_VALUE, INTERVAL_FIELD, STARTS
FROM information_schema.EVENTS
WHERE EVENT_SCHEMA='ivr_legacy' AND EVENT_NAME='evt_etl_diario';
