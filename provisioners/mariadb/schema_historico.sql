-- =============================================================================
-- schema_historico.sql — Tablas tbl_historico_tN_2025
-- =============================================================================
-- Crea las tres tablas fuente del IVR para el año 2025.
-- Estas tablas replican la estructura real del sistema IVR del cliente.
--
-- CARACTERÍSTICAS DEL SCHEMA REAL (confirmadas en análisis 2026-05-02):
--   · Sin índices — producción opera con full table scans (~11-14M filas/quarter)
--   · Particionamiento FÍSICO por trimestre (no columna quarter)
--   · dHoraInicio/dHoraFin: algunos registros tienen inicio > fin (bug IVR real)
--   · cDID_Centro_Transferencia: formato NK90 concatena teléfono en len > 10
--   · cMenu NULL o vacío → representa abandono (no hay columna status)
--   · cEtiquetacliente: etiqueta individual por registro (raw)
--
-- RANGOS DE FECHA:
--   Q1: 2025-01-01 → 2025-03-31
--   Q2: 2025-04-01 → 2025-06-30
--   Q3: 2025-07-01 → 2025-09-30
--
-- USO:
--   mysql -u django_user -pdjango_pass ivr_legacy < schema_historico.sql
-- =============================================================================

USE ivr_legacy;

-- -----------------------------------------------------------------------------
-- Q1 2025 — Enero, Febrero, Marzo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_historico_t1_2025 (
    dFecha                   DATE         NOT NULL
        COMMENT 'Fecha de la interaccion IVR',
    dHoraInicio              DATETIME     NOT NULL
        COMMENT 'Timestamp de inicio de la llamada (algunos registros tienen inicio > fin — bug IVR)',
    dHoraFin                 DATETIME     NOT NULL
        COMMENT 'Timestamp de fin de la llamada',
    cDID_800Transfer         VARCHAR(20)  NOT NULL
        COMMENT 'Numero DID de entrada (800 number). DIDs: Puebla=19020084 NacionalA=19028031 NacionalB=19020001',
    cDID_Centro_Transferencia VARCHAR(50) DEFAULT NULL
        COMMENT 'Centro de transferencia destino. Formato NK90: VDN concatenado con cTelefono_Digitado cuando len > 10. NULL o cliente_colgo indica abandono.',
    cMenu                    VARCHAR(100) DEFAULT NULL
        COMMENT 'Menu IVR navegado. NULL/vacio/VACIO/cliente_colgo/SinOpcion_Cabecera = abandono',
    cOpcion                  VARCHAR(100) DEFAULT NULL
        COMMENT 'Opcion especifica dentro del menu. NULLABLE.',
    cTelefono_Origen         VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero telefonico del llamante (CLI)',
    cTelefono_Digitado       VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero telefonico digitado por el usuario en el IVR. NULL si no ingreso.',
    cEtiquetacliente         VARCHAR(200) DEFAULT NULL
        COMMENT 'Etiqueta individual por registro (raw). La vista llamadas_QN agrega esto en etiquetas CSV.'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Historico IVR Q1 2025 (2025-01-01 a 2025-03-31). Sin indices — full table scan por diseno.';

-- -----------------------------------------------------------------------------
-- Q2 2025 — Abril, Mayo, Junio
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_historico_t2_2025 (
    dFecha                   DATE         NOT NULL
        COMMENT 'Fecha de la interaccion IVR',
    dHoraInicio              DATETIME     NOT NULL
        COMMENT 'Timestamp de inicio de la llamada',
    dHoraFin                 DATETIME     NOT NULL
        COMMENT 'Timestamp de fin de la llamada',
    cDID_800Transfer         VARCHAR(20)  NOT NULL
        COMMENT 'Numero DID de entrada',
    cDID_Centro_Transferencia VARCHAR(50) DEFAULT NULL
        COMMENT 'Centro de transferencia destino (formato NK90 cuando len > 10)',
    cMenu                    VARCHAR(100) DEFAULT NULL
        COMMENT 'Menu IVR navegado',
    cOpcion                  VARCHAR(100) DEFAULT NULL
        COMMENT 'Opcion dentro del menu',
    cTelefono_Origen         VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero del llamante (CLI)',
    cTelefono_Digitado       VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero digitado en el IVR',
    cEtiquetacliente         VARCHAR(200) DEFAULT NULL
        COMMENT 'Etiqueta individual por registro'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Historico IVR Q2 2025 (2025-04-01 a 2025-06-30). Sin indices.';

-- -----------------------------------------------------------------------------
-- Q3 2025 — Julio, Agosto, Septiembre
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_historico_t3_2025 (
    dFecha                   DATE         NOT NULL
        COMMENT 'Fecha de la interaccion IVR',
    dHoraInicio              DATETIME     NOT NULL
        COMMENT 'Timestamp de inicio de la llamada',
    dHoraFin                 DATETIME     NOT NULL
        COMMENT 'Timestamp de fin de la llamada',
    cDID_800Transfer         VARCHAR(20)  NOT NULL
        COMMENT 'Numero DID de entrada',
    cDID_Centro_Transferencia VARCHAR(50) DEFAULT NULL
        COMMENT 'Centro de transferencia destino (formato NK90 cuando len > 10)',
    cMenu                    VARCHAR(100) DEFAULT NULL
        COMMENT 'Menu IVR navegado',
    cOpcion                  VARCHAR(100) DEFAULT NULL
        COMMENT 'Opcion dentro del menu',
    cTelefono_Origen         VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero del llamante (CLI)',
    cTelefono_Digitado       VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero digitado en el IVR',
    cEtiquetacliente         VARCHAR(200) DEFAULT NULL
        COMMENT 'Etiqueta individual por registro'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Historico IVR Q3 2025 (2025-07-01 a 2025-09-30). Sin indices.';

-- -----------------------------------------------------------------------------
-- Q4 2025 — Octubre, Noviembre, Diciembre
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_historico_t4_2025 (
    dFecha                   DATE         NOT NULL
        COMMENT 'Fecha de la interaccion IVR',
    dHoraInicio              DATETIME     NOT NULL
        COMMENT 'Timestamp de inicio de la llamada',
    dHoraFin                 DATETIME     NOT NULL
        COMMENT 'Timestamp de fin de la llamada',
    cDID_800Transfer         VARCHAR(20)  NOT NULL
        COMMENT 'Numero DID de entrada',
    cDID_Centro_Transferencia VARCHAR(50) DEFAULT NULL
        COMMENT 'Centro de transferencia destino (formato NK90 cuando len > 10)',
    cMenu                    VARCHAR(100) DEFAULT NULL
        COMMENT 'Menu IVR navegado',
    cOpcion                  VARCHAR(100) DEFAULT NULL
        COMMENT 'Opcion dentro del menu',
    cTelefono_Origen         VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero del llamante (CLI)',
    cTelefono_Digitado       VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero digitado en el IVR',
    cEtiquetacliente         VARCHAR(200) DEFAULT NULL
        COMMENT 'Etiqueta individual por registro'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Historico IVR Q4 2025 (2025-10-01 a 2025-12-31). Sin indices.';

-- -----------------------------------------------------------------------------
-- Q1 2026 — Enero, Febrero, Marzo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_historico_t1_2026 (
    dFecha                   DATE         NOT NULL
        COMMENT 'Fecha de la interaccion IVR',
    dHoraInicio              DATETIME     NOT NULL
        COMMENT 'Timestamp de inicio de la llamada',
    dHoraFin                 DATETIME     NOT NULL
        COMMENT 'Timestamp de fin de la llamada',
    cDID_800Transfer         VARCHAR(20)  NOT NULL
        COMMENT 'Numero DID de entrada',
    cDID_Centro_Transferencia VARCHAR(50) DEFAULT NULL
        COMMENT 'Centro de transferencia destino (formato NK90 cuando len > 10)',
    cMenu                    VARCHAR(100) DEFAULT NULL
        COMMENT 'Menu IVR navegado',
    cOpcion                  VARCHAR(100) DEFAULT NULL
        COMMENT 'Opcion dentro del menu',
    cTelefono_Origen         VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero del llamante (CLI)',
    cTelefono_Digitado       VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero digitado en el IVR',
    cEtiquetacliente         VARCHAR(200) DEFAULT NULL
        COMMENT 'Etiqueta individual por registro'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Historico IVR Q1 2026 (2026-01-01 a 2026-03-31). Sin indices.';

-- -----------------------------------------------------------------------------
-- Q2 2026 — Abril, Mayo (en curso — datos parciales hasta hoy)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tbl_historico_t2_2026 (
    dFecha                   DATE         NOT NULL
        COMMENT 'Fecha de la interaccion IVR',
    dHoraInicio              DATETIME     NOT NULL
        COMMENT 'Timestamp de inicio de la llamada',
    dHoraFin                 DATETIME     NOT NULL
        COMMENT 'Timestamp de fin de la llamada',
    cDID_800Transfer         VARCHAR(20)  NOT NULL
        COMMENT 'Numero DID de entrada',
    cDID_Centro_Transferencia VARCHAR(50) DEFAULT NULL
        COMMENT 'Centro de transferencia destino (formato NK90 cuando len > 10)',
    cMenu                    VARCHAR(100) DEFAULT NULL
        COMMENT 'Menu IVR navegado',
    cOpcion                  VARCHAR(100) DEFAULT NULL
        COMMENT 'Opcion dentro del menu',
    cTelefono_Origen         VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero del llamante (CLI)',
    cTelefono_Digitado       VARCHAR(20)  DEFAULT NULL
        COMMENT 'Numero digitado en el IVR',
    cEtiquetacliente         VARCHAR(200) DEFAULT NULL
        COMMENT 'Etiqueta individual por registro'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Historico IVR Q2 2026 (2026-04-01 a 2026-06-30). En curso — datos parciales hasta hoy. Sin indices.';

-- Verificar creacion
SELECT
    table_name,
    table_comment,
    table_rows
FROM information_schema.tables
WHERE table_schema = 'ivr_legacy'
  AND table_name LIKE 'tbl_historico_%'
ORDER BY table_name;
