SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : schema_pipeline_event_log.sql
    Version         : 1.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : schema_base_ivr.sql (job_execution_log debe existir para la FK)
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < schema_pipeline_event_log.sql
    Notas           : Tabla de eventos del pipeline analítico — inspirada en mysql.general_log (append-only).
                      Diseño semi-normalizado: ENUM para vocabulario controlado sin tablas satélite.
                      Las tablas de log son intencionalmente denormalizadas:
                        - Cada fila es autónoma (legible sin JOINs)
                        - INSERT en 1 sentencia desde EXIT HANDLER
                        - Sin FK obligatorias que puedan fallar durante la captura del error
                        - job_log_id es FK nullable (solo para errores ETL con contexto)
*********************************************************************************************/

-- ──────────────────────────────────────────────────────────────────────────────
-- TABLA PRINCIPAL: pipeline_event_log
-- ──────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS pipeline_event_log (

    -- Identidad
    id              INT          NOT NULL AUTO_INCREMENT,

    -- Marca temporal con milisegundos (DATETIME(3) — precisión real del evento)
    ts              DATETIME(3)  NOT NULL DEFAULT NOW(3),

    -- Taxonomía del error (ENUM = vocabulario controlado sin tabla satélite)
    -- PARAM_INVALIDO : p_quarter o p_segmento fuera del dominio aceptado
    -- ETL_FALLO      : error durante la carga de base_ivr_detalle o base_ivr_clientes
    -- ETL_PARTIAL    : ETL completó pero sp_etl_validar detectó inconsistencias
    -- VALIDACION     : sp_etl_validar — uno o más checks fallaron (p_ok = FALSE)
    -- REPORTE_VACIO  : SP de reporte ejecutó sin error pero devolvió 0 filas
    -- SISTEMA        : error de infraestructura (tabla no existe, OOM, timeout)
    error_type      ENUM(
                        'PARAM_INVALIDO',
                        'ETL_FALLO',
                        'ETL_PARTIAL',
                        'VALIDACION',
                        'REPORTE_VACIO',
                        'SISTEMA'
                    ) NOT NULL,

    -- Severidad operacional
    -- CRITICA : requiere intervención inmediata (ETL no cargó datos del día)
    -- ALTA    : ETL parcial o validación fallida (datos incompletos)
    -- MEDIA   : parámetro inválido desde la API (bug en cliente)
    -- BAJA    : reporte sin datos (quarter vacío — puede ser esperado)
    -- INFO    : evento informativo sin impacto operacional
    severity        ENUM(
                        'CRITICA',
                        'ALTA',
                        'MEDIA',
                        'BAJA',
                        'INFO'
                    ) NOT NULL,

    -- Origen del error — denormalizado intencionalmente (autónomo sin JOIN)
    sp_nombre       VARCHAR(100) NOT NULL
                    COMMENT 'Nombre del SP o función que generó el error',
    sql_state       CHAR(5)      NULL
                    COMMENT 'SQLSTATE SQL estándar: 22023=param inválido, 45000=error aplicación',
    mysql_errno     INT UNSIGNED NULL
                    COMMENT 'Código numérico de MariaDB: 1644=SIGNAL, 1305=not exist, etc.',

    -- Contexto del dominio (nullable — no siempre aplica)
    p_quarter       VARCHAR(10)  NULL
                    COMMENT 'Quarter en contexto: Q01_25, Q02_26 (null si no aplica)',
    p_segmento      VARCHAR(20)  NULL
                    COMMENT 'Segmento en contexto: todas|nacional_A|nacional_B|puebla',

    -- Mensaje completo
    error_message   TEXT         NOT NULL
                    COMMENT 'Texto del error — generado por SIGNAL o GET DIAGNOSTICS',

    -- Contexto adicional estructurado (JSON como TEXT con CHECK de validez)
    -- Permite extender sin alterar el schema: parámetros extra, stack parcial, etc.
    -- Ejemplos: {"tabla_origen":"tbl_historico_t2_2026"}, {"p_val":"INVALIDO"}
    contexto        LONGTEXT     NULL
                    COMMENT 'JSON con parámetros adicionales del contexto del error'
                    CHECK (contexto IS NULL OR JSON_VALID(contexto)),

    -- Vínculo opcional con el pipeline ETL (null para errores de reporte)
    job_log_id      INT          NULL
                    COMMENT 'FK nullable a job_execution_log — solo para errores ETL',

    -- Quién activó la operación que falló
    ejecutado_por   VARCHAR(50)  NOT NULL DEFAULT 'desconocido'
                    COMMENT 'evt_etl_diario | django_api | management_command | manual',

    -- PK
    PRIMARY KEY (id),

    -- Índices para las consultas más frecuentes
    -- 1. "todos los errores del último día"
    INDEX idx_ts              (ts),
    -- 2. "todos los errores CRITICOS pendientes"
    INDEX idx_severity_ts     (severity, ts),
    -- 3. "errores del SP de reporte X"
    INDEX idx_sp_ts           (sp_nombre, ts),
    -- 4. "errores del quarter Q02_26"
    INDEX idx_quarter_ts      (p_quarter, ts),
    -- 5. "errores ETL asociados a un job concreto"
    INDEX idx_job_log         (job_log_id),

    -- FK débil a job_execution_log — ON DELETE SET NULL para preservar el error
    -- aunque se purgue el log del job
    CONSTRAINT fk_error_job_log
        FOREIGN KEY (job_log_id)
        REFERENCES job_execution_log(id)
        ON DELETE SET NULL

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Eventos del pipeline analítico IACT — append-only. Semi-normalizado: ENUM para taxonomía, denormalizado para contexto (cada fila autónoma). Cubre ETL y API de reportes.';

-- ──────────────────────────────────────────────────────────────────────────────
-- VISTA: v_eventos_recientes
-- Consulta operacional — errores de las últimas 48 horas con contexto ETL
-- ──────────────────────────────────────────────────────────────────────────────

CREATE OR REPLACE VIEW v_eventos_recientes AS
SELECT
    e.id
    , e.ts
    , e.error_type
    , e.severity
    , e.sp_nombre
    , e.sql_state
    , e.p_quarter
    , e.p_segmento
    , LEFT(e.error_message, 120)                                AS error_resumen
    , e.ejecutado_por
    -- Contexto del job ETL (si aplica)
    , j.status                                                  AS job_status
    , j.step_name                                               AS job_step
    , j.start_time                                              AS job_inicio
FROM pipeline_event_log e
LEFT JOIN job_execution_log j ON j.id = e.job_log_id
WHERE e.ts >= NOW() - INTERVAL 48 HOUR
ORDER BY e.ts DESC;

-- ──────────────────────────────────────────────────────────────────────────────
-- VERIFICACIÓN
-- ──────────────────────────────────────────────────────────────────────────────

-- Confirmar que la tabla existe
SELECT
    TABLE_NAME                                                  AS tabla
    , TABLE_ROWS                                                AS filas
    , ROUND(DATA_LENGTH / 1024, 1)                             AS kb_datos
    , TABLE_COMMENT                                             AS comentario
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'ivr_legacy'
  AND TABLE_NAME   = 'pipeline_event_log';

-- Confirmar índices
SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ivr_legacy' AND TABLE_NAME = 'pipeline_event_log'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
