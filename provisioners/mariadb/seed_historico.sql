-- =============================================================================
-- seed_historico.sql — Poblar tbl_historico_tN_YYYY con datos representativos
-- =============================================================================
-- Genera datos que replican los patrones reales del IVR del cliente.
-- Fuentes de calibración: TBL-HISTORICO-ANOMALIAS.md, perfiles/q01_2025.py,
-- SUPUESTOS-VOLUMENES_2026-05-07T154105.md, datos reales Q1-Q3 2025 (34.1M filas)
--
-- COMPORTAMIENTO POR EJECUCION:
--   1ra ejecucion  → SEED: inserta @SEED_Qnn registros en tabla vacía.
--   2da ejecucion  → APPEND: inserta @SEED_Qnn registros adicionales.
--   Sin SKIP, sin TRUNCATE — cada ejecucion agrega datos.
--   Los datos históricos tienen valor aunque contengan errores documentados.
--
-- TRACKING:
--   Registra en seed_executions: timestamp, tabla, filas_antes, filas_despues,
--   accion (SEED|APPEND), seed_rows_cfg, script_version, commit_hash.
--
-- ESCALAS POR QUARTER (proporcionales a datos reales Q1-Q3 2025):
--   Q01_25: base  1.000  (11,643,679 reales)
--   Q02_25: pico  1.136  (13,612,375 reales — mayor del año)
--   Q03_25: valle 0.954  (11,482,117 reales)
--   Q04_25:       1.041  (supuesto — fin de año +8% sobre Q03)
--   Q01_26:       1.010  (supuesto — crecimiento YoY ~4%)
--   Q02_26: parcial 36/91 días del Q02_26 proyectado
--   Offset aleatorio [3..17] garantiza que ningún quarter termina en cero.
--
-- DISTRIBUCIONES CALIBRADAS (perfiles/q01_2025.py, TBL-HISTORICO-ANOMALIAS.md):
--   G-29 (dHoraInicio > dHoraFin): 38.8% — bug real del sistema IVR
--   cMenu: distribución Q01_2025 real — cliente_colgo 22.6%, RES-FallaInternet
--          14.3%, NOTMX-SeguimientoInstalacion 11.6%, etc.
--   cTelefono_Digitado NULL:        21.2%  (P_NULL en poblar_historico.py)
--   cTelefono_Digitado = Origen:    28.2%  (P_MISMA en poblar_historico.py)
--   cDID_Centro_Transferencia NK90: ~9.9% de registros enrutados
--
-- BUGS REALES REPLICADOS (TBL-HISTORICO-ANOMALIAS.md):
--   G-29:            38.8% dHoraInicio > dHoraFin (campos swapped — bug IVR)
--   CLIENTE_COLGO:   cDID_Centro_Transferencia='cliente_colgo' cuando el
--                    cliente colgó antes de completar la transferencia
--   NK90:            VDN+cTelefono_Digitado concatenados (migración a IPVR)
--   __CMENU_ERROR__: ~1.2% teléfono en cMenu (bug IVR Puebla Q02+)
--
-- LIMITACIONES — cubiertas por NIVEL 2 (poblar_historico.py):
--   · Solo top 22 menús de Q01_2025 (el catálogo real tiene 39+)
--   · Sin evolución de menús por quarter (Q02 agrega 8, Q03 agrega 5)
--   · VDNs por menú simplificados (no cubre los 28+ VDNs por menú)
--
-- USO:
--   Nivel 1 (automático via schema_historico.sh):
--     SKIP_SEED=0 sudo bash provisioners/mariadb/schema_historico.sh
--
--   Nivel 2 (alta fidelidad, requiere Python 3):
--     FULL_SEED=1 sudo bash provisioners/mariadb/schema_historico.sh
--
-- SEED_ROWS base Q01_25 (default 3000):
--   Desarrollo:   3000    (~15 seg)
--   Integración: 30000    (~2  min)
--   Staging:    300000    (~20 min)
-- =============================================================================
--
-- CHANGELOG:
--   v3.0.0 (2026-05-10):
--     H-SEED-001: SKIP → APPEND incremental (sin LEAVE, sin corte)
--     H-SEED-002: FORCE_RESEED/TRUNCATE eliminados (datos siempre tienen valor)
--     H-SEED-003: G-29 calibrado 0.003 → 0.388
--     H-SEED-004: cMenu con 22 menús reales Q01_2025 y proporciones correctas
--     H-SEED-005/006: cTelefono calibrado P_NULL=0.212, P_MISMA=0.282
--     H-SEED-007: LPAD → rango fijo FLOOR(1000000+RAND()*9000000)
--     H-SEED-008: @SCRIPT_VER como fallback condicional (no sobreescribe)
--     H-SEED-010/011: escalas por quarter y offset aleatorio (no-cero)
--     T-1.1 (FASE 0 plan anterior): label sp_seed_historico: en BEGIN
--     Ref: HALLAZGOS-SEED-SQL-202605102030.md,
--          HALLAZGOS-SEED-VOLUMEN-MENUS-202605102045.md
--
--   v2.0.0 (2026-05-06): versión original — ver git log
-- =============================================================================

USE ivr_legacy;

-- =============================================================================
-- Variables de control
-- =============================================================================
SET @SEED_ROWS  = IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 3000, @SEED_ROWS);
-- @SCRIPT_VER: usar la versión inyectada por schema_historico.sh si existe.
-- Fallback a '3.0.0' solo si no viene ninguna (H-SEED-008).
SET @SCRIPT_VER = IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '3.0.0', @SCRIPT_VER);

-- =============================================================================
-- Escalas de volumen por quarter (H-SEED-010, H-SEED-011)
-- Ref: SUPUESTOS-VOLUMENES_2026-05-07T154105.md
-- Offset [3..17]: ningún quarter termina en 0, ningún par es idéntico.
-- =============================================================================
SET @_OFF = FLOOR(RAND() * 15) + 3;

SET @SEED_Q01_25 = @SEED_ROWS + @_OFF;
SET @SEED_Q02_25 = FLOOR(@SEED_ROWS * 1.136) + @_OFF + FLOOR(RAND() * 5) + 1;
SET @SEED_Q03_25 = FLOOR(@SEED_ROWS * 0.954) + @_OFF + FLOOR(RAND() * 5) + 2;
SET @SEED_Q04_25 = FLOOR(@SEED_ROWS * 1.041) + @_OFF + FLOOR(RAND() * 5) + 3;
SET @SEED_Q01_26 = FLOOR(@SEED_ROWS * 1.010) + @_OFF + FLOOR(RAND() * 5) + 4;
SET @SEED_Q02_26 = GREATEST(500,
    FLOOR(@SEED_ROWS * 1.136 * 36 / 91) + FLOOR(RAND() * 7) + 3);

-- =============================================================================
-- Tabla de tracking (H-SEED-001: VARCHAR en lugar de ENUM para soportar APPEND)
-- =============================================================================
CREATE TABLE IF NOT EXISTS seed_executions (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    ejecutado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tabla          VARCHAR(60)  NOT NULL,
    accion         VARCHAR(20)  NOT NULL,
    filas_antes    INT          NOT NULL DEFAULT 0,
    filas_despues  INT          NOT NULL DEFAULT 0,
    seed_rows_cfg  INT          NOT NULL,
    script_version VARCHAR(20)  NOT NULL,
    commit_hash    VARCHAR(40)  DEFAULT NULL,
    ejecutado_por  VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Registro de ejecuciones de seed_historico.sql';

-- Migrar instalaciones previas con ENUM (no-op en instalaciones nuevas con VARCHAR)
ALTER TABLE seed_executions MODIFY COLUMN accion VARCHAR(20) NOT NULL;

-- =============================================================================
-- SP principal
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_seed_historico;

DELIMITER $$

CREATE PROCEDURE sp_seed_historico(
    IN  p_tabla        VARCHAR(60),
    IN  p_fecha_ini    DATE,
    IN  p_fecha_fin    DATE,
    IN  p_rows         INT,
    IN  p_script_ver   VARCHAR(20),
    IN  p_commit_hash  VARCHAR(40)
)
sp_seed_historico: BEGIN
    DECLARE v_i            INT DEFAULT 0;
    DECLARE v_count_antes  INT DEFAULT 0;
    DECLARE v_count_des    INT DEFAULT 0;
    DECLARE v_accion       VARCHAR(20);
    DECLARE v_rand         FLOAT;
    DECLARE v_rand2        FLOAT;
    DECLARE v_fecha        DATE;
    DECLARE v_hora_ini     DATETIME;
    DECLARE v_hora_fin     DATETIME;
    DECLARE v_duracion_seg INT;
    DECLARE v_inicio_hora  INT;
    DECLARE v_did          VARCHAR(20);
    DECLARE v_centro       VARCHAR(50);
    DECLARE v_menu         VARCHAR(100);
    DECLARE v_opcion       VARCHAR(100);
    DECLARE v_tel_origen   VARCHAR(20);
    DECLARE v_tel_digitado VARCHAR(20);
    DECLARE v_etiqueta     VARCHAR(200);
    DECLARE v_dias_rango   INT;
    DECLARE v_sql          TEXT;

    -- Contar registros actuales
    SET v_sql = CONCAT('SELECT COUNT(*) INTO @_cnt FROM ', p_tabla);
    SET @_cnt = 0;
    PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
    SET v_count_antes = @_cnt;

    -- H-SEED-001: SEED en primera insercion, APPEND en siguientes.
    -- H-SEED-002: sin SKIP ni TRUNCATE — cada ejecucion agrega datos.
    IF v_count_antes = 0 THEN
        SET v_accion = 'SEED';
        SELECT CONCAT('SEED: ', p_tabla, ' — primera siembra de ', p_rows,
                      ' registros') AS info;
    ELSE
        SET v_accion = 'APPEND';
        SELECT CONCAT('APPEND: ', p_tabla, ' ya tiene ', v_count_antes,
                      ' registros — agregando ', p_rows, ' mas') AS info;
    END IF;

    SET v_dias_rango = DATEDIFF(p_fecha_fin, p_fecha_ini) + 1;

    SET v_i = 0;
    WHILE v_i < p_rows DO

        SET v_rand  = RAND();
        SET v_rand2 = RAND();

        SET v_fecha = DATE_ADD(p_fecha_ini,
                          INTERVAL FLOOR(v_rand * v_dias_rango) DAY);

        SET v_inicio_hora  = (7 * 3600) + FLOOR(RAND() * 50400);
        SET v_duracion_seg = FLOOR(5 + RAND() * 895);
        SET v_hora_ini     = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora));
        SET v_hora_fin     = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora + v_duracion_seg));

        -- G-29: 38.8% (H-SEED-003)
        IF RAND() < 0.388 THEN
            SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora));
            SET v_hora_ini = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora + v_duracion_seg));
        END IF;

        -- cDID_800Transfer
        SET v_rand = RAND();
        IF    v_rand < 0.45 THEN SET v_did = '19028031';
        ELSEIF v_rand < 0.75 THEN SET v_did = '19020001';
        ELSE                      SET v_did = '19020084';
        END IF;

        -- cTelefono_Origen (H-SEED-007: rango fijo, sin ceros internos)
        SET v_rand = RAND();
        IF    v_rand < 0.30 THEN
            SET v_tel_origen = CONCAT('443', FLOOR(1000000 + RAND() * 9000000));
        ELSEIF v_rand < 0.55 THEN
            SET v_tel_origen = CONCAT('722', FLOOR(1000000 + RAND() * 9000000));
        ELSEIF v_rand < 0.75 THEN
            SET v_tel_origen = CONCAT('222', FLOOR(1000000 + RAND() * 9000000));
        ELSE
            SET v_tel_origen = CONCAT('55', FLOOR(10000000 + RAND() * 90000000));
        END IF;

        -- cTelefono_Digitado (H-SEED-005/006: P_NULL=0.212, P_MISMA=0.282)
        SET v_rand = RAND();
        IF    v_rand < 0.212 THEN
            SET v_tel_digitado = NULL;
        ELSEIF v_rand < 0.494 THEN
            SET v_tel_digitado = v_tel_origen;
        ELSE
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.30 THEN
                SET v_tel_digitado = CONCAT('443', FLOOR(1000000 + RAND() * 9000000));
            ELSEIF v_rand2 < 0.55 THEN
                SET v_tel_digitado = CONCAT('722', FLOOR(1000000 + RAND() * 9000000));
            ELSEIF v_rand2 < 0.75 THEN
                SET v_tel_digitado = CONCAT('222', FLOOR(1000000 + RAND() * 9000000));
            ELSE
                SET v_tel_digitado = CONCAT('55', FLOOR(10000000 + RAND() * 90000000));
            END IF;
        END IF;

        -- cMenu y cOpcion (H-SEED-004: distribucion q01_2025.py real)
        SET v_rand = RAND();
        IF    v_rand < 0.226 THEN
            SET v_menu = 'cliente_colgo'; SET v_opcion = NULL;
        ELSEIF v_rand < 0.306 THEN
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.60 THEN SET v_menu = NULL;
            ELSEIF v_rand2 < 0.85 THEN SET v_menu = '';
            ELSE                        SET v_menu = 'sin cMenu';
            END IF;
            SET v_opcion = NULL;
        ELSEIF v_rand < 0.339 THEN
            SET v_menu = 'SinOpcion_Cabecera'; SET v_opcion = NULL;
        ELSEIF v_rand < 0.360 THEN
            SET v_menu = 'Marque3'; SET v_opcion = NULL;
        ELSEIF v_rand < 0.493 THEN
            SET v_menu = 'Desborde_Cabecera';
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.15 THEN SET v_opcion = 'QJA_AB_DAT_1';
            ELSEIF v_rand2 < 0.30 THEN SET v_opcion = 'TELECOBRA';
            ELSEIF v_rand2 < 0.43 THEN SET v_opcion = 'TELVICOBRA';
            ELSEIF v_rand2 < 0.51 THEN SET v_opcion = 'ECATEPEC';
            ELSEIF v_rand2 < 0.62 THEN SET v_opcion = 'QJA_AB_2';
            ELSE                        SET v_opcion = NULL;
            END IF;
        ELSEIF v_rand < 0.522 THEN
            SET v_menu = 'Desborde_Promocional'; SET v_opcion = NULL;
        ELSEIF v_rand < 0.665 THEN
            SET v_menu = 'RES-FallaInternet';
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.80 THEN SET v_opcion = 'DEFAULT';
            ELSEIF v_rand2 < 0.87 THEN SET v_opcion = 'NOBOT';
            ELSE                        SET v_opcion = 'POSIBLE_FALLA_DSLAM_P';
            END IF;
        ELSEIF v_rand < 0.694 THEN
            SET v_menu = 'RES-FallasLinea';
            SET v_opcion = IF(RAND() < 0.92, 'DEFAULT', 'ML');
        ELSEIF v_rand < 0.704 THEN
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.60 THEN SET v_menu = 'RES-Fallas_2024';
            ELSEIF v_rand2 < 0.80 THEN SET v_menu = 'RES-FallaEntretiene';
            ELSE                        SET v_menu = 'RES-FallaSegQja';
            END IF;
            SET v_opcion = 'DEFAULT';
        ELSEIF v_rand < 0.820 THEN
            SET v_menu = 'NOTMX-SeguimientoInstalacion'; SET v_opcion = 'DEFAULT';
        ELSEIF v_rand < 0.847 THEN
            SET v_menu = 'NOTMX-CONT-Contratacion'; SET v_opcion = 'DEFAULT';
        ELSEIF v_rand < 0.861 THEN
            SET v_menu = 'NOTMX-CONT-Portabilidad'; SET v_opcion = 'DEFAULT';
        ELSEIF v_rand < 0.915 THEN
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.76 THEN SET v_menu = 'RES-SaldooPagos';
            ELSEIF v_rand2 < 0.83 THEN SET v_menu = 'RES-SaldosPagos_2024';
            ELSE                        SET v_menu = 'RES-Saldos-WT';
            END IF;
            SET v_opcion = 'DEFAULT';
        ELSEIF v_rand < 0.962 THEN
            SET v_menu = 'RES-MADT-Detalle';
            SET v_opcion = IF(RAND() < 0.92, 'DEFAULT', '2L');
        ELSEIF v_rand < 0.979 THEN
            SET v_menu = 'RES-Entr';
            SET v_opcion = IF(RAND() < 0.92, 'DEFAULT', '2L');
        ELSEIF v_rand < 0.988 THEN
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.55 THEN SET v_menu = 'RES-ContratacionInfinitum';
            ELSEIF v_rand2 < 0.75 THEN SET v_menu = 'RES-ContratacionInfinitum_2024';
            ELSEIF v_rand2 < 0.85 THEN SET v_menu = 'RES_CambioDom';
            ELSE                        SET v_menu = 'RES_CambioTit';
            END IF;
            SET v_opcion = 'DEFAULT';
        ELSEIF v_rand < 0.990 THEN
            -- __CMENU_ERROR__: telefono en cMenu (bug real IVR ~1.2%)
            SET v_menu = CONCAT('443', FLOOR(1000000 + RAND() * 9000000));
            SET v_opcion = NULL;
        ELSE
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.30 THEN SET v_menu = 'RES_Otros';
            ELSEIF v_rand2 < 0.55 THEN SET v_menu = 'RES-DISH';
            ELSEIF v_rand2 < 0.75 THEN SET v_menu = 'RES-TAE';
            ELSEIF v_rand2 < 0.90 THEN SET v_menu = 'RES-SegurosInbursa';
            ELSE                        SET v_menu = 'default';
            END IF;
            SET v_opcion = 'DEFAULT';
        END IF;

        -- cDID_Centro_Transferencia (VDNs reales q01_2025.py VDN_POR_MENU)
        -- Cada menu tiene su propio VDN — no agrupar categorias distintas.
        IF v_menu = 'cliente_colgo' THEN
            -- cMenu='cliente_colgo' → cDID es SIEMPRE 'cliente_colgo' (100%)
            -- Ref: q01_2025.py 'cliente_colgo': ('cliente_colgo',)
            SET v_centro = 'cliente_colgo';
        ELSEIF v_menu IS NULL OR v_menu = '' OR v_menu = 'sin cMenu' THEN
            -- VACIO (NULL/vacio/sin cMenu) → 80% cliente_colgo, 17% 19020086, 3% NULL
            -- Ref: q01_2025.py None: [('cliente_colgo',0.80),('19020086',0.97),(None,1.0)]
            SET v_rand = RAND();
            IF    v_rand < 0.80 THEN SET v_centro = 'cliente_colgo';
            ELSEIF v_rand < 0.97 THEN SET v_centro = '19020086';
            ELSE                       SET v_centro = NULL;
            END IF;
        ELSEIF v_menu IN ('SinOpcion_Cabecera','Marque3') THEN
            -- SinOpcion_Cabecera y Marque3 → SIEMPRE '19020086' (nunca 'cliente_colgo')
            -- Ref: q01_2025.py 'SinOpcion_Cabecera':[('19020086',1.0)]
            --                  'Marque3':            [('19020086',1.0)]
            SET v_centro = '19020086';
        ELSEIF v_menu = 'Desborde_Cabecera' THEN
            SET v_centro = IF(RAND() < 0.75, 'cliente_colgo', '10928253');
        ELSEIF v_menu = 'Desborde_Promocional' THEN
            SET v_centro = '19020086';
        ELSEIF v_menu = 'RES-FallaInternet' THEN
            SET v_rand = RAND();
            IF    v_rand < 0.49 THEN SET v_centro = '10828091';
            ELSEIF v_rand < 0.66 THEN SET v_centro = '19010000';
            ELSEIF v_rand < 0.80 THEN SET v_centro = '15070019';
            ELSE                       SET v_centro = '10728000';
            END IF;
        ELSEIF v_menu = 'RES-FallasLinea' THEN
            SET v_rand = RAND();
            IF    v_rand < 0.70 THEN SET v_centro = '15070019';
            ELSEIF v_rand < 0.90 THEN SET v_centro = '10828091';
            ELSE                       SET v_centro = '10228051';
            END IF;
        ELSEIF v_menu IN ('RES-Fallas_2024','RES-FallaEntretiene') THEN
            SET v_centro = '10828091';
        ELSEIF v_menu = 'RES-FallaSegQja' THEN
            SET v_centro = '10928253';
        ELSEIF v_menu = 'NOTMX-SeguimientoInstalacion' THEN
            SET v_centro = '10728487';
        ELSEIF v_menu = 'NOTMX-CONT-Contratacion' THEN
            SET v_centro = '15070059';
        ELSEIF v_menu = 'NOTMX-CONT-Portabilidad' THEN
            SET v_centro = '10728485';
        ELSEIF v_menu IN ('RES-SaldooPagos','RES-Saldos-WT') THEN
            SET v_centro = IF(RAND() < 0.60, '14929014', '1309004');
        ELSEIF v_menu = 'RES-SaldosPagos_2024' THEN
            SET v_centro = IF(RAND() < 0.70, '309004', '14929014');
        ELSEIF v_menu = 'RES-MADT-Detalle' THEN
            SET v_centro = IF(RAND() < 0.80, '15070013', '10928253');
        ELSEIF v_menu = 'RES-Entr' THEN
            SET v_centro = '10728382';
        ELSEIF v_menu IN ('RES-ContratacionInfinitum','RES-ContratacionInfinitum_2024') THEN
            SET v_rand = RAND();
            IF    v_rand < 0.70 THEN SET v_centro = '15070013';
            ELSEIF v_rand < 0.88 THEN SET v_centro = '15070006';
            ELSE                       SET v_centro = '15070059';
            END IF;
        ELSEIF v_menu IN ('RES_CambioDom','RES_CambioTit') THEN
            SET v_centro = IF(RAND() < 0.60, '15070004', '15070071');
        ELSEIF v_menu REGEXP '^[0-9]+' THEN
            -- __CMENU_ERROR__: sp_rpt_cMENU_ERROR enruta estos a 19020086
            SET v_centro = '19020086';
        ELSE
            SET v_centro = IF(RAND() < 0.65, '15070013', '19020086');
        END IF;

        -- NK90: VDN+cTelefono_Digitado concatenados (~9.9% de enrutados)
        -- Normalización en sp_etl_base_detalle: LEFT(campo, LENGTH-10)
        IF v_centro IS NOT NULL
           AND v_centro NOT IN ('cliente_colgo','19020086')
           AND v_tel_digitado IS NOT NULL
           AND RAND() < 0.099 THEN
            SET v_centro = CONCAT(v_centro, v_tel_digitado);
        END IF;

        -- cEtiquetacliente
        SET v_rand = RAND();
        IF    v_rand < 0.05 THEN SET v_etiqueta = NULL;
        ELSEIF v_rand < 0.15 THEN SET v_etiqueta = 'VIP';
        ELSEIF v_rand < 0.45 THEN SET v_etiqueta = 'REGULAR';
        ELSEIF v_rand < 0.60 THEN SET v_etiqueta = 'MOROSO';
        ELSEIF v_rand < 0.75 THEN SET v_etiqueta = 'NUEVO';
        ELSEIF v_rand < 0.87 THEN SET v_etiqueta = 'BAJA_RIESGO';
        ELSE                       SET v_etiqueta = 'RETENCION';
        END IF;

        SET v_sql = CONCAT(
            'INSERT INTO ', p_tabla,
            ' (dFecha,dHoraInicio,dHoraFin,cDID_800Transfer,',
            '  cDID_Centro_Transferencia,cMenu,cOpcion,',
            '  cTelefono_Origen,cTelefono_Digitado,cEtiquetacliente) VALUES (',
            QUOTE(v_fecha),        ',',
            QUOTE(v_hora_ini),     ',',
            QUOTE(v_hora_fin),     ',',
            QUOTE(v_did),          ',',
            IF(v_centro IS NULL,       'NULL', QUOTE(v_centro)),       ',',
            IF(v_menu IS NULL,         'NULL', QUOTE(v_menu)),         ',',
            IF(v_opcion IS NULL,       'NULL', QUOTE(v_opcion)),       ',',
            IF(v_tel_origen IS NULL,   'NULL', QUOTE(v_tel_origen)),   ',',
            IF(v_tel_digitado IS NULL, 'NULL', QUOTE(v_tel_digitado)), ',',
            IF(v_etiqueta IS NULL,     'NULL', QUOTE(v_etiqueta)),     ')'
        );
        SET @dyn_sql = v_sql;
        PREPARE stmt FROM @dyn_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET v_i = v_i + 1;
        IF MOD(v_i, 1000) = 0 THEN COMMIT; END IF;

    END WHILE;
    COMMIT;

    SET v_sql = CONCAT('SELECT COUNT(*) INTO @_cnt FROM ', p_tabla);
    SET @_cnt = 0;
    PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
    SET v_count_des = @_cnt;

    INSERT INTO seed_executions
        (tabla, accion, filas_antes, filas_despues,
         seed_rows_cfg, script_version, commit_hash)
    VALUES (p_tabla, v_accion, v_count_antes, v_count_des,
            p_rows, p_script_ver, p_commit_hash);

    SELECT CONCAT('OK: ', p_tabla, ' — ', v_count_des,
                  ' registros totales (accion: ', v_accion,
                  ', aniadidos: ', v_count_des - v_count_antes, ')') AS resultado;

END sp_seed_historico$$

DELIMITER ;

-- =============================================================================
-- Ejecutar seed para los 6 quarters
-- =============================================================================
SELECT USER() INTO @_current_user;

CALL sp_seed_historico('tbl_historico_t1_2025','2025-01-01','2025-03-31',
    @SEED_Q01_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t2_2025','2025-04-01','2025-06-30',
    @SEED_Q02_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t3_2025','2025-07-01','2025-09-30',
    @SEED_Q03_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t4_2025','2025-10-01','2025-12-31',
    @SEED_Q04_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t1_2026','2026-01-01','2026-03-31',
    @SEED_Q01_26, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t2_2026','2026-04-01','2026-05-06',
    @SEED_Q02_26, @SCRIPT_VER, @COMMIT_HASH);

DROP PROCEDURE IF EXISTS sp_seed_historico;

-- =============================================================================
-- Historial de ejecuciones
-- =============================================================================
SELECT
    id,
    DATE_FORMAT(ejecutado_en,'%Y-%m-%d %H:%i:%s') AS cuando,
    tabla,
    accion,
    filas_antes,
    filas_despues,
    filas_despues - filas_antes                    AS filas_nuevas,
    seed_rows_cfg,
    script_version,
    COALESCE(LEFT(commit_hash,8),'N/A')            AS commit
FROM seed_executions
ORDER BY id DESC
LIMIT 20;
