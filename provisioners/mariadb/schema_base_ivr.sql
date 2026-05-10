-- =============================================================================
-- schema_base_ivr.sql
-- DDL de tablas base analíticas y de control — propiedad IACT
-- Versión: 2.0.0
-- Motor: MariaDB 10.1.48+ (InnoDB, utf8mb4)
--
-- PREREQUISITO: funciones_utilidad.sql debe haberse ejecutado.
-- EJECUTAR EN: ivr_legacy (mismo servidor que tbl_historico_*)
--
-- TABLAS CREADAS:
--   base_ivr_detalle      — resultado del ETL, fuente de 6 SPs de reporte
--   base_ivr_clientes     — clientes únicos por quarter/segmento
--   job_execution_log     — tracking del MySQL Event Scheduler (paso a paso)
--   etl_runs              — tracking del management command Django
--   job_config            — configuración de jobs (enable/disable, timeout)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- base_ivr_detalle
-- Grain: (trimestre, fecha_mes, segmento, centro_transferencia, menu, opcion)
-- Contiene métricas aditivas precalculadas por el ETL.
-- Fuente de 6 de los 7 SPs de reporte.
--
-- VOLUMEN ESTIMADO: ~5,000-15,000 filas por quarter
-- (vs 11-14M filas en tbl_historico_* — reducción de ~1000x)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS base_ivr_detalle (
    id                   INT           NOT NULL AUTO_INCREMENT,

    -- Dimensiones (grain)
    trimestre            VARCHAR(10)   NOT NULL
        COMMENT 'Quarter en formato Q01_25, Q02_25... Q02_26',
    fecha                VARCHAR(6)    NOT NULL
        COMMENT 'Mes en formato YYYYMM: 202501, 202502...',
    segmento             VARCHAR(20)   NOT NULL
        COMMENT 'nacional_A (19028031) | nacional_B (19020001) | puebla (19020084)',
    centro_transferencia VARCHAR(100)  NOT NULL
        COMMENT 'VDN normalizado por fn_normalizar_centro, o sentinel: CASO_NULL, CLIENTE_COLGO, CASO_ERROR_CEROS, ERROR_CARACTER_INICIAL',
    menu                 VARCHAR(100)  NOT NULL
        COMMENT 'Valor raw de cMenu normalizado por fn_normalizar_menu. Mixed case. Los SPs aplican UPPER() para presentación.',
    opcion               VARCHAR(100)  NOT NULL
        COMMENT 'Valor de cOpcion o SIN_OPCION si es NULL/vacío.',

    -- Métricas aditivas (pueden sumarse entre filas del mismo grain)
    total_llamadas       INT           NOT NULL DEFAULT 0
        COMMENT 'COUNT(*) por grupo — métrica base de todos los reportes',
    misma_linea          INT           NOT NULL DEFAULT 0
        COMMENT 'COUNT donde cTelefono_Origen = cTelefono_Digitado (BR-CLIENT-001)',
    linea_diferente      INT           NOT NULL DEFAULT 0
        COMMENT 'COUNT donde cTelefono_Origen != cTelefono_Digitado (BR-CLIENT-001)',
    no_digito_telefono   INT           NOT NULL DEFAULT 0
        COMMENT 'COUNT donde cTelefono_Digitado IS NULL (BR-CLIENT-001)',

    -- Metricas lunes-viernes vs fin de semana (pre-computadas en ETL con ivr_es_dia_semana)
    -- Necesarias para sp_rpt_centros_xsegmento sin regresar a la tabla fuente.
    llamadas_entre_semana INT          NOT NULL DEFAULT 0
        COMMENT 'COUNT de llamadas en dias lunes-viernes. El IVR opera 7 dias — festivos incluidos.',
    llamadas_fines_semana INT          NOT NULL DEFAULT 0
        COMMENT 'COUNT de llamadas en sábado o domingo',

    -- Metadata
    cargado_en           DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    -- Índice compuesto principal: cubre la mayoría de los WHERE de los SPs
    INDEX idx_trim_seg_fecha  (trimestre, segmento, fecha),
    -- Índices secundarios para filtros específicos
    INDEX idx_trim_menu       (trimestre, menu),
    INDEX idx_trim_centro     (trimestre, centro_transferencia),
    INDEX idx_fecha_seg       (fecha, segmento),

    -- Constraint de unicidad: garantiza idempotencia del ETL
    UNIQUE KEY uk_grain (trimestre, fecha, segmento, centro_transferencia(50), menu(50), opcion(50))

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Base analítica IVR — grain por quarter×mes×segmento×centro×menu×opcion. Fuente de 6/7 SPs de reporte.';


-- Garantizar que el COMMENT de llamadas_entre_semana este actualizado
-- aunque la tabla ya exista (CREATE TABLE IF NOT EXISTS no modifica columnas existentes)
ALTER TABLE base_ivr_detalle
    MODIFY COLUMN llamadas_entre_semana INT NOT NULL DEFAULT 0
    COMMENT 'COUNT de llamadas en dias lunes-viernes. El IVR opera 7 dias — festivos incluidos.';


-- -----------------------------------------------------------------------------
-- base_ivr_clientes
-- Grain: (trimestre, segmento)
-- COUNT(DISTINCT cTelefono_Origen) — NO aditivo, requiere scan separado.
-- Resultado: 3 filas por quarter (una por segmento).
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS base_ivr_clientes (
    id              INT          NOT NULL AUTO_INCREMENT,
    trimestre       VARCHAR(10)  NOT NULL
        COMMENT 'Quarter en formato Q01_25...',
    segmento        VARCHAR(20)  NOT NULL
        COMMENT 'nacional_A | nacional_B | puebla',
    clientes_unicos INT          NOT NULL DEFAULT 0
        COMMENT 'COUNT(DISTINCT cTelefono_Origen). P-NEW-04: pendiente confirmar si debe ser cTelefono_Digitado.',
    cargado_en      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_trim_seg (trimestre, segmento),
    UNIQUE KEY uk_grain (trimestre, segmento)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Clientes únicos por quarter y segmento. COUNT DISTINCT no aditivo — scan separado del ETL.';


-- -----------------------------------------------------------------------------
-- job_execution_log
-- Tracking granular del MySQL Event Scheduler y sp_etl_maestro.
-- Un registro por PASO (no por job completo) para diagnóstico preciso.
-- Si un paso falla, los demás quedan con su propio estado.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS job_execution_log (
    id               INT          NOT NULL AUTO_INCREMENT,
    job_name         VARCHAR(100) NOT NULL
        COMMENT 'Nombre del job: etl_diario | etl_historico | etl_manual',
    quarter_name     VARCHAR(20)
        COMMENT 'Q01_25 | Q02_25 | ...',
    step_name        VARCHAR(50)
        COMMENT 'Paso del pipeline: etl_base_detalle | etl_base_clientes | validacion | maestro',
    tabla_origen     VARCHAR(100)
        COMMENT 'tbl_historico_tN_YYYY procesada en este paso',
    start_time       DATETIME     NOT NULL,
    end_time         DATETIME,
    status           ENUM('RUNNING','SUCCESS','PARTIAL','FAILED','SKIP','TIMEOUT')
                     NOT NULL DEFAULT 'RUNNING',
    records_procesados INT        DEFAULT 0
        COMMENT 'Filas insertadas en base_ivr_detalle o base_ivr_clientes',
    duracion_seg     INT          GENERATED ALWAYS AS
                     (CASE WHEN end_time IS NOT NULL
                           THEN TIMESTAMPDIFF(SECOND, start_time, end_time)
                           ELSE NULL END) STORED
        COMMENT 'Duración calculada automáticamente al actualizar end_time',
    error_message    TEXT,
    ejecutado_por    VARCHAR(50)  DEFAULT 'evt_etl_diario'
        COMMENT 'evt_etl_diario | management_command | manual',

    PRIMARY KEY (id),
    INDEX idx_status_start (status, start_time DESC),
    INDEX idx_quarter_step (quarter_name, step_name),
    INDEX idx_job_start    (job_name, start_time DESC)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tracking granular del pipeline ETL. Un registro por paso, no por job.';


-- -----------------------------------------------------------------------------
-- etl_runs
-- Tracking del management command Django.
-- Fuente de verdad para la UI Django (UC_PIP_01/02/03/04).
-- A diferencia de job_execution_log, esta tabla es consultada por Django.
-- -----------------------------------------------------------------------------
-- etl_runs — D-NOM-001 (2026-05-09): columnas en inglés
-- Tablas de infraestructura del pipeline usan inglés (coherente con job_execution_log).
CREATE TABLE IF NOT EXISTS etl_runs (
    id                INT           NOT NULL AUTO_INCREMENT,
    trimestre         VARCHAR(20)   NOT NULL,
    inicio_at         DATETIME      NOT NULL,
    fin_at            DATETIME,
    timeout_at        DATETIME      NOT NULL
        COMMENT 'Fecha/hora límite. Si sigue en en_ejecucion después → timeout.',
    heartbeat_at      DATETIME      NULL
        COMMENT 'Actualizado cada 60s por el thread de heartbeat de run_etl.py',
    status            ENUM('en_ejecucion','success','failed','timeout','skip')
                      NOT NULL DEFAULT 'en_ejecucion',
    registros_detalle INT           DEFAULT 0,
    registros_clientes INT          DEFAULT 0,
    error_message     TEXT,
    trigger_source    VARCHAR(100)  DEFAULT 'django_command'
        COMMENT 'django_command | evt_etl_diario | manual',

    PRIMARY KEY (id),
    INDEX idx_status_inicio  (status, inicio_at DESC),
    INDEX idx_trimestre      (trimestre),
    INDEX idx_timeout        (status, timeout_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tracking del management command run_etl — heartbeat y estado de cada ejecución ETL.';


-- -----------------------------------------------------------------------------
-- job_config
-- Configuración operacional por job. Permite habilitar/deshabilitar
-- sin modificar código.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS job_config (
    job_name         VARCHAR(100) NOT NULL,
    is_enabled       BOOLEAN      NOT NULL DEFAULT TRUE,
    timeout_seconds  INT          NOT NULL DEFAULT 1800
        COMMENT 'Timeout del job en segundos. Default 30min.',
    ventana_inicio   TIME         DEFAULT '02:00:00'
        COMMENT 'Hora de inicio de la ventana de ejecución',
    ventana_fin      TIME         DEFAULT '04:00:00'
        COMMENT 'Hora de fin de la ventana de ejecución',
    min_intervalo_h  INT          NOT NULL DEFAULT 6
        COMMENT 'Mínimo de horas entre ejecuciones (evita concurrencia)',
    notas            TEXT,
    actualizado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                     ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (job_name)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Configuración operacional de jobs ETL. Modificar aquí para habilitar/deshabilitar.';

-- Configuración inicial
INSERT INTO job_config
    (job_name, is_enabled, timeout_seconds, min_intervalo_h, notas)
VALUES
    ('etl_diario',    TRUE,  1800, 6,
     'ETL nocturno automático. Procesa el quarter actual.'),
    ('etl_historico', FALSE, 7200, 24,
     'Carga histórica manual. Habilitar solo durante backfill inicial.')
ON DUPLICATE KEY UPDATE notas = VALUES(notas);

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================
SELECT
    TABLE_NAME,
    TABLE_ROWS    AS filas_estimadas,
    CREATE_TIME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN (
      'base_ivr_detalle','base_ivr_clientes',
      'job_execution_log','etl_runs','job_config'
  )
ORDER BY TABLE_NAME;

-- vw_monitor_dias_semana — monitoreo ratio días hábiles
CREATE OR REPLACE VIEW vw_monitor_dias_semana AS
SELECT
    trimestre, fecha,
    SUM(total_llamadas)        AS total,
    SUM(llamadas_entre_semana) AS habiles,
    SUM(llamadas_fines_semana) AS fin_semana,
    SUM(total_llamadas) - SUM(llamadas_entre_semana)
        - SUM(llamadas_fines_semana) AS error_suma,
    ROUND(SUM(llamadas_entre_semana)
          / NULLIF(SUM(total_llamadas),0) * 100, 1) AS pct_entre_semana,
    CASE
        WHEN SUM(total_llamadas) = 0 THEN 'SIN_DATOS'
        WHEN SUM(total_llamadas) != SUM(llamadas_entre_semana)
             + SUM(llamadas_fines_semana) THEN 'ERROR_INTEGRIDAD'
        WHEN SUM(llamadas_entre_semana)/SUM(total_llamadas)*100
             NOT BETWEEN 60 AND 85 THEN 'ALERTA_RATIO'
        ELSE 'OK'
    END AS estado_monitor
FROM base_ivr_detalle
GROUP BY trimestre, fecha;

-- =============================================================================
-- vw_monitor_dias_semana — T-085 (2026-05-09)
-- Vista de monitoreo del ratio días hábiles en base_ivr_detalle.
-- Detecta fallos silenciosos de ivr_es_dia_semana (afecta 18 nodos).
--
-- Uso: SELECT * FROM vw_monitor_dias_semana WHERE estado_monitor != 'OK';
-- Esperado post-ETL: 0 filas.
--
-- estado_monitor:
--   OK               pct_entre_semana en [60%,85%], suma íntegra
--   ALERTA_RATIO     ratio fuera de rango → posible bug en ivr_es_dia_semana
--   ERROR_INTEGRIDAD llamadas_entre_semana + llamadas_fines_semana != total
--   SIN_DATOS        0 llamadas en el período
-- =============================================================================
CREATE OR REPLACE VIEW vw_monitor_dias_semana AS
SELECT
    trimestre,
    fecha,
    SUM(total_llamadas)        AS total,
    SUM(llamadas_entre_semana) AS habiles,
    SUM(llamadas_fines_semana) AS fin_semana,
    SUM(total_llamadas) - SUM(llamadas_entre_semana)
        - SUM(llamadas_fines_semana)               AS error_suma,
    ROUND(SUM(llamadas_entre_semana)
          / NULLIF(SUM(total_llamadas), 0) * 100, 1) AS pct_entre_semana,
    CASE
        WHEN SUM(total_llamadas) = 0
            THEN 'SIN_DATOS'
        WHEN SUM(total_llamadas) != SUM(llamadas_entre_semana)
             + SUM(llamadas_fines_semana)
            THEN 'ERROR_INTEGRIDAD'
        WHEN SUM(llamadas_entre_semana) / SUM(total_llamadas) * 100
             NOT BETWEEN 60 AND 85
            THEN 'ALERTA_RATIO'
        ELSE 'OK'
    END AS estado_monitor
FROM base_ivr_detalle
GROUP BY trimestre, fecha;
