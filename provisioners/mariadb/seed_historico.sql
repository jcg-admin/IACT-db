-- =============================================================================
-- seed_historico.sql — Poblar tbl_historico_tN_YYYY con datos representativos
-- =============================================================================
-- Genera datos que replican los patrones reales del IVR.
--
-- IDEMPOTENCIA:
--   Por defecto: SKIP si la tabla ya tiene datos (no duplica).
--   Con forzado:  SET @FORCE_RESEED = 1 antes de ejecutar → TRUNCATE + re-seed.
--
-- COMPORTAMIENTO POR EJECUCION:
--   1ra ejecucion  → inserta SEED_ROWS en cada tabla vacía.
--   2da ejecucion  → skip de tablas ya sembradas, mensaje informativo.
--   Con --force    → trunca y re-siembra todas las tablas.
--
-- TRACKING:
--   Registra cada ejecucion en seed_executions con:
--   timestamp, tabla, filas_antes, filas_despues, accion, seed_rows, script_version.
--
-- DIDs de entrada (cDID_800Transfer) — confirmados por segmento:
--   NacionalA  19028031  45%
--   NacionalB  19020001  30%
--   Puebla     19020084  25%
--
-- Distribucion de cMenu (basada en analisis real Q3 2025):
--   cliente_colgo       52%   abandono principal
--   NULL/vacio/sin cMenu 9%   abandono (cMenu vacio en fuente)
--   SinOpcion_Cabecera   4%   abandono
--   Desborde_Cabecera    5%   enrutamiento por etiqueta (no es abandono)
--   Desborde_Promocional 2%   enrutamiento promocional
--   menus reales        28%   Saldo / Pagos / Atencion / Transferencia / etc.
--
-- Bugs reales replicados:
--   ~0.3% registros con dHoraInicio > dHoraFin (campos swapped — bug IVR real)
--
-- USO normal:
--   mysql -u django_user -pdjango_pass ivr_legacy < seed_historico.sql
--
-- USO con forzado de re-seed:
--   mysql -u django_user -pdjango_pass ivr_legacy \
--         -e "SET @FORCE_RESEED=1;" seed_historico.sql
--   # o desde el bash wrapper:
--   FORCE_RESEED=1 sudo bash provisioners/mariadb/schema_historico.sh
--
-- SEED_ROWS por quarter (default 5000):
--   Desarrollo:   5000   (~5  seg)
--   Integracion: 50000   (~1  min)
--   Staging:    500000   (~10 min)
-- =============================================================================

USE ivr_legacy;

-- Variables de control (pueden sobreescribirse antes de ejecutar este script)
SET @SEED_ROWS     = IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 5000, @SEED_ROWS);
SET @FORCE_RESEED  = IF(@FORCE_RESEED IS NULL, 0, @FORCE_RESEED);
SET @SCRIPT_VER    = '2.0.0';

-- =============================================================================
-- Tabla de tracking de ejecuciones (idempotente)
-- =============================================================================
CREATE TABLE IF NOT EXISTS seed_executions (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    ejecutado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tabla          VARCHAR(60)  NOT NULL,
    accion         ENUM('SEED','SKIP','TRUNCATE+SEED') NOT NULL,
    filas_antes    INT          NOT NULL DEFAULT 0,
    filas_despues  INT          NOT NULL DEFAULT 0,
    seed_rows_cfg  INT          NOT NULL,
    script_version VARCHAR(20)  NOT NULL,
    commit_hash    VARCHAR(40)  DEFAULT NULL,
    ejecutado_por  VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Registro de ejecuciones de seed_historico.sql';

-- =============================================================================
-- SP principal: sp_seed_historico
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_seed_historico;

DELIMITER $$

CREATE PROCEDURE sp_seed_historico(
    IN  p_tabla        VARCHAR(60),
    IN  p_fecha_ini    DATE,
    IN  p_fecha_fin    DATE,
    IN  p_rows         INT,
    IN  p_force        TINYINT,   -- 1 = TRUNCATE + re-seed, 0 = skip si ya hay datos
    IN  p_script_ver   VARCHAR(20),
    IN  p_commit_hash  VARCHAR(40)
)
BEGIN
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
    DECLARE v_vdn          VARCHAR(10);
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

    -- Decidir accion
    IF v_count_antes > 0 AND p_force = 0 THEN
        -- Ya tiene datos y no se forzó re-seed: SKIP
        SET v_accion = 'SKIP';
        SELECT CONCAT('SKIP: ', p_tabla, ' ya tiene ', v_count_antes,
                      ' registros. Usar FORCE_RESEED=1 para re-sembrar.') AS info;

        INSERT INTO seed_executions
            (tabla, accion, filas_antes, filas_despues,
             seed_rows_cfg, script_version, commit_hash)
        VALUES (p_tabla, 'SKIP', v_count_antes, v_count_antes,
                p_rows, p_script_ver, p_commit_hash);
        LEAVE sp_seed_historico;
    END IF;

    -- Forzado: truncar antes de insertar
    IF p_force = 1 AND v_count_antes > 0 THEN
        SET v_accion = 'TRUNCATE+SEED';
        SET v_sql = CONCAT('TRUNCATE TABLE ', p_tabla);
        PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
        SELECT CONCAT('TRUNCATE: ', p_tabla, ' vaciada (',
                      v_count_antes, ' registros eliminados).') AS info;
        SET v_count_antes = 0;
    ELSE
        SET v_accion = 'SEED';
    END IF;

    SET v_dias_rango = DATEDIFF(p_fecha_fin, p_fecha_ini) + 1;

    SELECT CONCAT('Sembrando ', p_tabla, ' (', p_rows, ' registros, ',
                  p_fecha_ini, ' a ', p_fecha_fin, ')...') AS info;

    SET v_i = 0;
    WHILE v_i < p_rows DO

        SET v_rand  = RAND();
        SET v_rand2 = RAND();

        -- dFecha distribuida uniformemente en el rango
        SET v_fecha = DATE_ADD(p_fecha_ini,
                          INTERVAL FLOOR(v_rand * v_dias_rango) DAY);

        -- Horario 07:00-21:00
        SET v_inicio_hora = (7 * 3600) + FLOOR(RAND() * (14 * 3600));
        SET v_duracion_seg = FLOOR(5 + RAND() * 895);

        SET v_hora_ini = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora));
        SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora + v_duracion_seg));

        -- Bug real: ~0.3% registros con dHoraInicio > dHoraFin
        IF RAND() < 0.003 THEN
            SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora));
            SET v_hora_ini = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora + v_duracion_seg));
        END IF;

        -- cDID_800Transfer: NacionalA 45% / NacionalB 30% / Puebla 25%
        SET v_rand = RAND();
        IF    v_rand < 0.45 THEN SET v_did = '19028031';
        ELSEIF v_rand < 0.75 THEN SET v_did = '19020001';
        ELSE                      SET v_did = '19020084';
        END IF;

        -- cTelefono_Origen: prefijos reales MX
        SET v_rand = RAND();
        IF    v_rand < 0.30 THEN
            SET v_tel_origen = CONCAT('443', LPAD(FLOOR(RAND()*9999999),7,'0'));
        ELSEIF v_rand < 0.55 THEN
            SET v_tel_origen = CONCAT('722', LPAD(FLOOR(RAND()*9999999),7,'0'));
        ELSEIF v_rand < 0.75 THEN
            SET v_tel_origen = CONCAT('222', LPAD(FLOOR(RAND()*9999999),7,'0'));
        ELSE
            SET v_tel_origen = CONCAT('55',  LPAD(FLOOR(RAND()*99999999),8,'0'));
        END IF;

        -- cTelefono_Digitado: 30% NULL / 45% igual / 25% diferente
        SET v_rand = RAND();
        IF    v_rand < 0.30 THEN SET v_tel_digitado = NULL;
        ELSEIF v_rand < 0.75 THEN SET v_tel_digitado = v_tel_origen;
        ELSE  SET v_tel_digitado = CONCAT('443',LPAD(FLOOR(RAND()*9999999),7,'0'));
        END IF;

        -- cMenu y cOpcion
        SET v_rand = RAND();
        IF    v_rand < 0.52 THEN SET v_menu='cliente_colgo';  SET v_opcion=NULL;
        ELSEIF v_rand < 0.61 THEN
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.50 THEN SET v_menu=NULL;
            ELSEIF v_rand2 < 0.80 THEN SET v_menu='';
            ELSE                        SET v_menu='sin cMenu';
            END IF;
            SET v_opcion=NULL;
        ELSEIF v_rand < 0.65 THEN SET v_menu='SinOpcion_Cabecera';  SET v_opcion=NULL;
        ELSEIF v_rand < 0.70 THEN SET v_menu='Desborde_Cabecera';   SET v_opcion=NULL;
        ELSEIF v_rand < 0.72 THEN SET v_menu='Desborde_Promocional';SET v_opcion=NULL;
        ELSE
            SET v_rand2 = RAND();
            IF    v_rand2 < 0.18 THEN SET v_menu='Saldo';
                SET v_opcion=IF(RAND()<0.5,'ConsultaTelefonica','ConsultaMovil');
            ELSEIF v_rand2 < 0.34 THEN SET v_menu='Pagos';
                SET v_opcion=IF(RAND()<0.6,'PagoLineaTelefonica','PagoMovil');
            ELSEIF v_rand2 < 0.48 THEN SET v_menu='Atencion';
                SET v_opcion=IF(RAND()<0.5,'AtencionEspecializada','AtencionGeneral');
            ELSEIF v_rand2 < 0.58 THEN SET v_menu='Transferencia';
                SET v_opcion=IF(RAND()<0.7,'TransferenciaDirecta','TransferenciaIVR');
            ELSEIF v_rand2 < 0.68 THEN SET v_menu='Informacion';
                SET v_opcion=IF(RAND()<0.5,'InfoProductos','InfoServicios');
            ELSEIF v_rand2 < 0.76 THEN SET v_menu='ReclamacionesTecnicas';
                SET v_opcion=IF(RAND()<0.6,'FallaServicio','EquipoDefectuoso');
            ELSEIF v_rand2 < 0.84 THEN SET v_menu='BajasModificaciones';
                SET v_opcion=IF(RAND()<0.5,'BajaServicio','ModificacionPlan');
            ELSEIF v_rand2 < 0.90 THEN SET v_menu='ConsultaFactura';
                SET v_opcion=IF(RAND()<0.5,'FacturaDetallada','ResumenFactura');
            ELSE SET v_menu='SolicitudProducto';
                SET v_opcion=IF(RAND()<0.5,'NuevoProducto','ActivacionProducto');
            END IF;
        END IF;

        -- cDID_Centro_Transferencia
        IF v_menu IN ('cliente_colgo','SinOpcion_Cabecera')
           OR v_menu IS NULL OR v_menu='' OR v_menu='sin cMenu' THEN
            SET v_rand = RAND();
            IF    v_rand < 0.80 THEN SET v_centro=NULL;
            ELSEIF v_rand < 0.95 THEN SET v_centro='cliente_colgo';
            ELSE                      SET v_centro='0000000';
            END IF;
        ELSE
            SET v_rand = RAND();
            IF    v_rand < 0.25 THEN SET v_vdn='1309004';
            ELSEIF v_rand < 0.45 THEN SET v_vdn='15070013';
            ELSEIF v_rand < 0.60 THEN SET v_vdn='2309004';
            ELSEIF v_rand < 0.72 THEN SET v_vdn='1205003';
            ELSEIF v_rand < 0.82 THEN SET v_vdn='1408002';
            ELSE                      SET v_vdn='1705001';
            END IF;
            IF v_tel_digitado IS NOT NULL AND RAND() < 0.70 THEN
                SET v_centro = CONCAT(v_vdn, v_tel_digitado);
            ELSE
                SET v_centro = v_vdn;
            END IF;
        END IF;

        -- cEtiquetacliente
        SET v_rand = RAND();
        IF    v_rand < 0.05 THEN SET v_etiqueta=NULL;
        ELSEIF v_rand < 0.35 THEN SET v_etiqueta='VIP';
        ELSEIF v_rand < 0.55 THEN SET v_etiqueta='REGULAR';
        ELSEIF v_rand < 0.70 THEN SET v_etiqueta='MOROSO';
        ELSEIF v_rand < 0.82 THEN SET v_etiqueta='NUEVO';
        ELSEIF v_rand < 0.90 THEN SET v_etiqueta='BAJA_RIESGO';
        ELSE                       SET v_etiqueta='RETENCION';
        END IF;

        -- INSERT dinamico
        SET v_sql = CONCAT(
            'INSERT INTO ', p_tabla,
            ' (dFecha,dHoraInicio,dHoraFin,cDID_800Transfer,',
            '  cDID_Centro_Transferencia,cMenu,cOpcion,',
            '  cTelefono_Origen,cTelefono_Digitado,cEtiquetacliente) VALUES (',
            QUOTE(v_fecha),',',QUOTE(v_hora_ini),',',QUOTE(v_hora_fin),',',
            QUOTE(v_did),',',
            IF(v_centro IS NULL,'NULL',QUOTE(v_centro)),',',
            IF(v_menu IS NULL,'NULL',IF(v_menu='','""',QUOTE(v_menu))),',',
            IF(v_opcion IS NULL,'NULL',QUOTE(v_opcion)),',',
            IF(v_tel_origen IS NULL,'NULL',QUOTE(v_tel_origen)),',',
            IF(v_tel_digitado IS NULL,'NULL',QUOTE(v_tel_digitado)),',',
            IF(v_etiqueta IS NULL,'NULL',QUOTE(v_etiqueta)),')'
        );
        SET @dyn_sql = v_sql;
        PREPARE stmt FROM @dyn_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET v_i = v_i + 1;
        IF MOD(v_i, 1000) = 0 THEN COMMIT; END IF;

    END WHILE;
    COMMIT;

    -- Contar resultado y registrar en tracking
    SET v_sql = CONCAT('SELECT COUNT(*) INTO @_cnt FROM ', p_tabla);
    SET @_cnt = 0;
    PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
    SET v_count_des = @_cnt;

    INSERT INTO seed_executions
        (tabla, accion, filas_antes, filas_despues,
         seed_rows_cfg, script_version, commit_hash)
    VALUES (p_tabla, v_accion, v_count_antes, v_count_des,
            p_rows, p_script_ver, p_commit_hash);

    SELECT CONCAT('OK: ', p_tabla, ' — ',
                  v_count_des, ' registros (accion: ', v_accion, ')') AS resultado;

END sp_seed_historico$$

DELIMITER ;

-- =============================================================================
-- Ejecutar seed para los 6 quarters
-- =============================================================================

-- Capturar usuario actual para el tracking
SELECT USER() INTO @_current_user;

-- Q1 2025
CALL sp_seed_historico('tbl_historico_t1_2025','2025-01-01','2025-03-31',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

-- Q2 2025
CALL sp_seed_historico('tbl_historico_t2_2025','2025-04-01','2025-06-30',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

-- Q3 2025
CALL sp_seed_historico('tbl_historico_t3_2025','2025-07-01','2025-09-30',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

-- Q4 2025
CALL sp_seed_historico('tbl_historico_t4_2025','2025-10-01','2025-12-31',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

-- Q1 2026
CALL sp_seed_historico('tbl_historico_t1_2026','2026-01-01','2026-03-31',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

-- Q2 2026 (parcial — 36 dias de 91 = ~40%)
SET @SEED_ROWS_PARCIAL = GREATEST(500, FLOOR(@SEED_ROWS * 36 / 91));
CALL sp_seed_historico('tbl_historico_t2_2026','2026-04-01','2026-05-06',
    @SEED_ROWS_PARCIAL, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

DROP PROCEDURE IF EXISTS sp_seed_historico;

-- =============================================================================
-- Historial de todas las ejecuciones
-- =============================================================================
SELECT
    id,
    ejecutado_en,
    tabla,
    accion,
    filas_antes,
    filas_despues,
    filas_despues - filas_antes AS filas_nuevas,
    seed_rows_cfg,
    script_version,
    COALESCE(commit_hash, 'N/A') AS commit_hash
FROM seed_executions
ORDER BY id DESC
LIMIT 20;
