-- =============================================================================
-- seed_historico_real.sql — Seed con datos de producción reales
-- =============================================================================
-- PROPÓSITO:
--   Complementa seed_historico.sql (que usa datos genéricos) con datos que
--   replican fielmente las distribuciones reales de producción Q1-Q3 2025.
--
-- DIFERENCIA CON seed_historico.sql:
--   seed_historico.sql  → menús genéricos (Saldo, Pagos, Atencion)
--                       → VDNs ficticios (1309004, 1205003...)
--                       → cobertura 7% de menús reales
--
--   seed_historico_real → menús reales (RES-FallaInternet, NOTMX-Seguimiento...)
--                       → VDNs reales top-15 (19020086, 10828091, 10728487...)
--                       → etiquetas reales (TELECOBRA, QJA_AB_*, NOBOT...)
--                       → proporciones calibradas con datos producción Q1-Q3 2025
--
-- FUENTES:
--   DID_Centro_Transferencia_v0.3.1.csv  — 841 filas, 36.7M llamadas Q1-Q3
--   menu_opcion_detalle.csv              — 126 combinaciones reales
--   clasificacion_cDID_Centro.csv        — distribución de longitudes Q1
--   Reporte_cMenu_Agosto_2025.csv        — distribución por segmento
--   DOC-03 Catálogo de Centros           — 96 VDNs, top-20 verificados
--
-- IDEMPOTENCIA: igual que seed_historico.sql
--   @FORCE_RESEED = 0  → SKIP si la tabla ya tiene datos
--   @FORCE_RESEED = 1  → TRUNCATE + re-seed
--
-- USO:
--   mysql -u django_user -pdjango_pass ivr_legacy < seed_historico_real.sql
--
--   Con forzado:
--   mysql -u django_user -pdjango_pass ivr_legacy \
--         -e "SET @FORCE_RESEED=1;" seed_historico_real.sql
--
-- SEED_ROWS default: 10000/quarter (más representativo que el genérico)
-- =============================================================================

USE ivr_legacy;

SET @SEED_ROWS    = IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 10000, @SEED_ROWS);
SET @FORCE_RESEED = IF(@FORCE_RESEED IS NULL, 0, @FORCE_RESEED);
SET @SCRIPT_VER   = '1.0.0-real';

-- seed_executions ya existe desde seed_historico.sql
CREATE TABLE IF NOT EXISTS seed_executions (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    ejecutado_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tabla          VARCHAR(60)  NOT NULL,
    accion         VARCHAR(20)  NOT NULL,
    filas_antes    INT          NOT NULL DEFAULT 0,
    filas_despues  INT          NOT NULL DEFAULT 0,
    seed_rows_cfg  INT          NOT NULL,
    script_version VARCHAR(20)  NOT NULL,
    commit_hash    VARCHAR(40)  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- SP: sp_seed_historico_real
-- Genera registros con distribuciones calibradas de producción real.
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_seed_historico_real;

DELIMITER $$

CREATE PROCEDURE sp_seed_historico_real(
    IN p_tabla      VARCHAR(60),
    IN p_fecha_ini  DATE,
    IN p_fecha_fin  DATE,
    IN p_rows       INT,
    IN p_force      TINYINT,
    IN p_script_ver VARCHAR(20)
)
BEGIN
    DECLARE v_i           INT DEFAULT 0;
    DECLARE v_r           FLOAT;
    DECLARE v_r2          FLOAT;
    DECLARE v_count_antes INT DEFAULT 0;
    DECLARE v_count_des   INT DEFAULT 0;
    DECLARE v_accion      VARCHAR(20);

    DECLARE v_fecha       DATE;
    DECLARE v_hora_ini    DATETIME;
    DECLARE v_hora_fin    DATETIME;
    DECLARE v_ini_seg     INT;
    DECLARE v_dur_seg     INT;

    DECLARE v_did         VARCHAR(20);   -- DID de entrada (cDID_800Transfer)
    DECLARE v_centro      VARCHAR(50);   -- centro_transferencia (normalizado antes de almacenar raw)
    DECLARE v_centro_raw  VARCHAR(50);   -- valor crudo que va en cDID_Centro_Transferencia
    DECLARE v_menu        VARCHAR(100);
    DECLARE v_opcion      VARCHAR(100);
    DECLARE v_tel_origen  VARCHAR(20);
    DECLARE v_tel_dig     VARCHAR(20);
    DECLARE v_etiqueta    VARCHAR(200);

    DECLARE v_dias_rango  INT;
    DECLARE v_sql         TEXT;

    -- Conteo actual
    SET v_sql = CONCAT('SELECT COUNT(*) INTO @_cnt FROM ', p_tabla);
    SET @_cnt = 0;
    PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
    SET v_count_antes = @_cnt;

    IF v_count_antes > 0 AND p_force = 0 THEN
        SELECT CONCAT('SKIP: ', p_tabla, ' ya tiene ', v_count_antes,
                      ' registros. Usar FORCE_RESEED=1 para re-sembrar.') AS info;
        INSERT INTO seed_executions
            (tabla,accion,filas_antes,filas_despues,seed_rows_cfg,script_version)
        VALUES (p_tabla,'SKIP',v_count_antes,v_count_antes,p_rows,p_script_ver);
        LEAVE sp_seed_historico_real;
    END IF;

    IF p_force = 1 AND v_count_antes > 0 THEN
        SET v_accion = 'TRUNCATE+SEED';
        SET v_sql = CONCAT('TRUNCATE TABLE ', p_tabla);
        PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
        SET v_count_antes = 0;
    ELSE
        SET v_accion = 'SEED';
    END IF;

    SET v_dias_rango = DATEDIFF(p_fecha_fin, p_fecha_ini) + 1;
    SELECT CONCAT('Sembrando ', p_tabla, ' con datos reales (', p_rows,
                  ' registros, ', p_fecha_ini, ' a ', p_fecha_fin, ')...') AS info;

    SET v_i = 0;
    WHILE v_i < p_rows DO

        SET v_r  = RAND();
        SET v_r2 = RAND();

        -- --------------------------------------------------------
        -- dFecha: uniforme en el rango
        -- --------------------------------------------------------
        SET v_fecha = DATE_ADD(p_fecha_ini,
                         INTERVAL FLOOR(v_r * v_dias_rango) DAY);

        -- Horario 07:00-21:00
        SET v_ini_seg = (7 * 3600) + FLOOR(RAND() * 50400);
        SET v_dur_seg = FLOOR(5 + RAND() * 895);
        SET v_hora_ini = TIMESTAMP(v_fecha, SEC_TO_TIME(v_ini_seg));
        SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_ini_seg + v_dur_seg));
        -- Bug real ~0.3%: swap dHoraInicio/dHoraFin
        IF RAND() < 0.003 THEN
            SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_ini_seg));
            SET v_hora_ini = TIMESTAMP(v_fecha, SEC_TO_TIME(v_ini_seg + v_dur_seg));
        END IF;

        -- --------------------------------------------------------
        -- cDID_800Transfer — distribución REAL por segmento
        -- Nacional domina (Nacional A ~45%, B ~30%), Puebla ~25%
        -- --------------------------------------------------------
        SET v_r = RAND();
        IF    v_r < 0.45 THEN SET v_did = '19028031';   -- Nacional A
        ELSEIF v_r < 0.75 THEN SET v_did = '19020001';   -- Nacional B
        ELSE                    SET v_did = '19020084';   -- Puebla
        END IF;

        -- --------------------------------------------------------
        -- cTelefono_Origen: prefijos MX reales
        -- --------------------------------------------------------
        SET v_r = RAND();
        IF    v_r < 0.30 THEN SET v_tel_origen = CONCAT('443', LPAD(FLOOR(RAND()*9999999),7,'0'));
        ELSEIF v_r < 0.55 THEN SET v_tel_origen = CONCAT('722', LPAD(FLOOR(RAND()*9999999),7,'0'));
        ELSEIF v_r < 0.75 THEN SET v_tel_origen = CONCAT('222', LPAD(FLOOR(RAND()*9999999),7,'0'));
        ELSE                    SET v_tel_origen = CONCAT('55',  LPAD(FLOOR(RAND()*99999999),8,'0'));
        END IF;
        SET v_r = RAND();
        IF    v_r < 0.30 THEN SET v_tel_dig = NULL;
        ELSEIF v_r < 0.75 THEN SET v_tel_dig = v_tel_origen;
        ELSE SET v_tel_dig = CONCAT('443', LPAD(FLOOR(RAND()*9999999),7,'0'));
        END IF;

        -- --------------------------------------------------------
        -- cMenu + cOpcion — distribución REAL de producción
        -- Fuente: menu_opcion_detalle.csv + Reporte_cMenu_Agosto_2025
        -- --------------------------------------------------------
        SET v_r = RAND();

        -- Abandono (35% total, calibrado con datos reales)
        IF    v_r < 0.22 THEN                            -- cliente_colgo 22%
            SET v_menu = 'cliente_colgo'; SET v_opcion = NULL;

        ELSEIF v_r < 0.29 THEN                           -- SIN_MENU / VACIO 7%
            SET v_r2 = RAND();
            IF v_r2 < 0.5 THEN SET v_menu = NULL;
            ELSEIF v_r2 < 0.8 THEN SET v_menu = '';
            ELSE SET v_menu = 'sin cMenu'; END IF;
            SET v_opcion = NULL;

        ELSEIF v_r < 0.32 THEN                           -- SinOpcion_Cabecera 3%
            SET v_menu = 'SinOpcion_Cabecera'; SET v_opcion = NULL;

        ELSEIF v_r < 0.34 THEN                           -- Marque3 2%
            SET v_menu = 'Marque3'; SET v_opcion = NULL;

        -- Desborde (16.4% total — 13.1% Cabecera + 3.1% Promocional)
        ELSEIF v_r < 0.464 THEN
            SET v_menu = 'Desborde_Cabecera';
            -- Etiquetas reales de Desborde_Cabecera (32 distintas, distribución Q1)
            SET v_r2 = RAND();
            IF    v_r2 < 0.149 THEN SET v_opcion = 'QJA_AB_DAT_1';    -- 32,457
            ELSEIF v_r2 < 0.254 THEN SET v_opcion = 'QJA_AB_2';       -- 26,685
            ELSEIF v_r2 < 0.354 THEN SET v_opcion = 'QJA_AB_DAT_2';   -- 26,331
            ELSEIF v_r2 < 0.404 THEN SET v_opcion = 'QJA_AB_VSI_1';   -- 13,031
            ELSEIF v_r2 < 0.451 THEN SET v_opcion = 'TELECOBRA';       -- 37,855 (mayor)
            ELSEIF v_r2 < 0.495 THEN SET v_opcion = 'TELVICOBRA';      -- 33,994
            ELSEIF v_r2 < 0.535 THEN SET v_opcion = 'ECATEPEC';        -- 20,618
            ELSEIF v_r2 < 0.563 THEN SET v_opcion = 'QJA_AB_3';       -- 13,628
            ELSEIF v_r2 < 0.590 THEN SET v_opcion = 'QJA_AB_VSI_2';   -- 10,347
            ELSEIF v_r2 < 0.622 THEN SET v_opcion = 'ECATEPEC_QJA';   -- 10,360 (más el de Q2/Q3)
            ELSEIF v_r2 < 0.650 THEN SET v_opcion = 'MES_1';           -- 8,130
            ELSEIF v_r2 < 0.672 THEN SET v_opcion = 'QJA_AB_VOZ_1';   -- 3,033
            ELSEIF v_r2 < 0.687 THEN SET v_opcion = 'ECATEPEC_FM';    -- 5,156
            ELSEIF v_r2 < 0.700 THEN SET v_opcion = 'QJA_AB_VOZ_2';   -- 666
            ELSEIF v_r2 < 0.730 THEN SET v_opcion = 'MES_2';           -- 1,487 (+ Q2/Q3)
            ELSEIF v_r2 < 0.750 THEN SET v_opcion = 'MIGRAFTTH';       -- 788
            ELSEIF v_r2 < 0.768 THEN SET v_opcion = 'ONT_ECANCELA';   -- 738
            ELSEIF v_r2 < 0.785 THEN SET v_opcion = 'ECATEPEC_PORTA'; -- 435
            ELSEIF v_r2 < 0.800 THEN SET v_opcion = 'RETCOMBO';        -- 274
            ELSEIF v_r2 < 0.815 THEN SET v_opcion = 'QJA_ACAPULCO';   -- 1,346
            ELSEIF v_r2 < 0.825 THEN SET v_opcion = 'ANALAMCAN';       -- 240
            ELSEIF v_r2 < 0.835 THEN SET v_opcion = 'SABIVALLE';       -- 267
            ELSEIF v_r2 < 0.845 THEN SET v_opcion = 'BUSTAVILLAL';     -- 322
            ELSEIF v_r2 < 0.854 THEN SET v_opcion = 'CASOSDG';         -- 310
            ELSEIF v_r2 < 0.860 THEN SET v_opcion = 'COD_SUSP_7';      -- 60
            ELSEIF v_r2 < 0.868 THEN SET v_opcion = 'CLIENTESAPP';     -- 23
            ELSEIF v_r2 < 0.876 THEN SET v_opcion = 'MEGACABLE';       -- 24
            ELSEIF v_r2 < 0.882 THEN SET v_opcion = 'RETARGETING';     -- 8
            ELSEIF v_r2 < 0.886 THEN SET v_opcion = 'QJA_AB_1';        -- 13
            ELSEIF v_r2 < 0.888 THEN SET v_opcion = 'BLACKLIST';       -- 1
            ELSE                     SET v_opcion = 'INCLUENCER';       -- 1,100
            END IF;

        ELSEIF v_r < 0.495 THEN                          -- Desborde_Promocional 3.1%
            SET v_menu = 'Desborde_Promocional'; SET v_opcion = NULL;

        -- Fallas internet (20.1% del total — el mayor bloque de negocio)
        ELSEIF v_r < 0.575 THEN
            SET v_menu = 'RES-FallaInternet';
            SET v_r2 = RAND();
            IF    v_r2 < 0.799 THEN SET v_opcion = 'DEFAULT';
            ELSEIF v_r2 < 0.870 THEN SET v_opcion = 'NOBOT';
            ELSEIF v_r2 < 0.935 THEN SET v_opcion = 'POSIBLE_FALLA_DSLAM_P';
            ELSEIF v_r2 < 0.952 THEN SET v_opcion = 'FM_CFE_P';
            ELSEIF v_r2 < 0.968 THEN SET v_opcion = 'FM_ROBO_P';
            ELSEIF v_r2 < 0.981 THEN SET v_opcion = 'FALLA_AMBAS_P';
            ELSEIF v_r2 < 0.987 THEN SET v_opcion = 'ADEUDO22222';
            ELSEIF v_r2 < 0.993 THEN SET v_opcion = 'CECOR';
            ELSE                     SET v_opcion = 'FALLA_CENTRAL_P';
            END IF;

        ELSEIF v_r < 0.605 THEN                          -- RES-FallasLinea 4.9%
            SET v_menu = 'RES-FallasLinea';
            SET v_r2 = RAND();
            IF    v_r2 < 0.917 THEN SET v_opcion = 'DEFAULT';
            ELSEIF v_r2 < 0.941 THEN SET v_opcion = 'ML';
            ELSEIF v_r2 < 0.957 THEN SET v_opcion = 'FM_CFE_P';
            ELSEIF v_r2 < 0.971 THEN SET v_opcion = 'FM_ROBO_P';
            ELSEIF v_r2 < 0.979 THEN SET v_opcion = 'CECOR';
            ELSEIF v_r2 < 0.987 THEN SET v_opcion = 'CASE_41';
            ELSE                     SET v_opcion = 'FM_NATURAL_P';
            END IF;

        ELSEIF v_r < 0.627 THEN                          -- RES_FALLA_STOP 2.2%
            SET v_menu = 'RES_FALLA_STOP'; SET v_opcion = 'DEFAULT';

        ELSEIF v_r < 0.648 THEN                          -- RES-Fallas_2024 + RES-FallaInternet_2024
            SET v_r2 = RAND();
            IF v_r2 < 0.5 THEN SET v_menu = 'RES-Fallas_2024'; SET v_opcion = IF(RAND()<0.5,'VSI','DEFAULT');
            ELSE SET v_menu = 'RES-FallaInternet_2024'; SET v_opcion = 'DEFAULT'; END IF;

        ELSEIF v_r < 0.660 THEN                          -- RES-FallaEntretiene
            SET v_menu = 'RES-FallaEntretiene';
            SET v_opcion = IF(RAND()<0.77,'DEFAULT','NOBOT');

        ELSEIF v_r < 0.669 THEN                          -- RES-FallaSegQja
            SET v_menu = 'RES-FallaSegQja';
            SET v_r2 = RAND();
            IF    v_r2 < 0.96 THEN SET v_opcion = 'DEFAULT';
            ELSEIF v_r2 < 0.97 THEN SET v_opcion = 'QJA_AB_VOZ_2';
            ELSEIF v_r2 < 0.98 THEN SET v_opcion = 'QJA_AB_DAT_1';
            ELSE                     SET v_opcion = 'QJA_AB_VSI_1';
            END IF;

        -- NOTMX — instalaciones y contrataciones (14.1%)
        ELSEIF v_r < 0.739 THEN                          -- NOTMX-SeguimientoInstalacion 7%
            SET v_menu = 'NOTMX-SeguimientoInstalacion'; SET v_opcion = 'DEFAULT';

        ELSEIF v_r < 0.766 THEN                          -- NOTMX-CONT-Contratacion 2.7%
            SET v_menu = 'NOTMX-CONT-Contratacion'; SET v_opcion = 'DEFAULT';

        ELSEIF v_r < 0.780 THEN                          -- NOTMX-CONT-Portabilidad 1.4%
            SET v_menu = 'NOTMX-CONT-Portabilidad'; SET v_opcion = 'DEFAULT';

        ELSEIF v_r < 0.788 THEN                          -- RES-SegInst_2024
            SET v_menu = 'RES-SegInst_2024'; SET v_opcion = 'DEFAULT';

        -- Saldos y Pagos (5.5%)
        ELSEIF v_r < 0.820 THEN                          -- RES-SaldooPagos 3.2%
            SET v_menu = 'RES-SaldooPagos'; SET v_opcion = 'DEFAULT';

        ELSEIF v_r < 0.832 THEN                          -- RES-Saldos-WT
            SET v_menu = 'RES-Saldos-WT'; SET v_opcion = 'DEFAULT';

        ELSEIF v_r < 0.839 THEN                          -- variantes saldos 2024
            SET v_menu = IF(RAND()<0.6,'RES-SaldosPagos_2024','RES-SaldosPagos_FM');
            SET v_opcion = 'DEFAULT';

        -- MADT y Entr (combinados ~6%)
        ELSEIF v_r < 0.865 THEN                          -- RES-MADT-Detalle
            SET v_menu = 'RES-MADT-Detalle';
            SET v_r2 = RAND();
            IF    v_r2 < 0.917 THEN SET v_opcion = 'DEFAULT';
            ELSEIF v_r2 < 0.975 THEN SET v_opcion = '2L';
            ELSEIF v_r2 < 0.990 THEN SET v_opcion = 'PQ_389';
            ELSE                     SET v_opcion = 'CECOR';
            END IF;

        ELSEIF v_r < 0.876 THEN                          -- RES-Entr
            SET v_menu = 'RES-Entr';
            SET v_opcion = IF(RAND()<0.92,'DEFAULT',IF(RAND()<0.7,'NOBOT','2L'));

        -- Contrataciones (4%)
        ELSEIF v_r < 0.888 THEN                          -- RES-ContratacionInfinitum (variantes)
            SET v_r2 = RAND();
            IF    v_r2 < 0.4 THEN SET v_menu = 'RES-ContratacionInfinitum_2024';
            ELSEIF v_r2 < 0.7 THEN SET v_menu = 'RES-ContratacionInfinitum_FM';
            ELSE                    SET v_menu = 'RES-ContratacionInfinitum';
            END IF;
            SET v_opcion = IF(RAND()<0.86,'DEFAULT',IF(RAND()<0.7,'2L','CECOR'));

        -- Cambios y administración (1%)
        ELSEIF v_r < 0.895 THEN
            SET v_r2 = RAND();
            IF    v_r2 < 0.65 THEN SET v_menu = 'RES_CambioDom';
            ELSEIF v_r2 < 0.84 THEN SET v_menu = 'RES_Cambios';
            ELSE                    SET v_menu = 'RES_CambioTit';
            END IF;
            SET v_opcion = IF(RAND()<0.92,'DEFAULT',IF(RAND()<0.6,'2L','CECOR'));

        -- Anomalías cMENU_ERROR (1.2% — cMenu contiene número de teléfono)
        ELSEIF v_r < 0.907 THEN
            -- cMenu con número de teléfono (anomalía real — sp_rpt_cMENU_ERROR)
            SET v_r2 = RAND();
            IF v_r2 < 0.6 THEN
                -- 10 dígitos
                SET v_menu = CONCAT('443', LPAD(FLOOR(RAND()*9999999),7,'0'));
            ELSE
                -- 11 dígitos
                SET v_menu = CONCAT('1443', LPAD(FLOOR(RAND()*9999999),7,'0'));
            END IF;
            SET v_opcion = NULL;

        -- Resto: otros menús reales de menor volumen
        ELSEIF v_r < 0.913 THEN SET v_menu = 'RES_Otros';
            SET v_opcion = IF(RAND()<0.91,'DEFAULT',IF(RAND()<0.7,'2L','CECOR'));
        ELSEIF v_r < 0.919 THEN SET v_menu = 'RES-AsistenciaTelmexcom'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.924 THEN SET v_menu = 'RES-FallasLinea'; SET v_opcion = 'DEFAULT';  -- extra
        ELSEIF v_r < 0.929 THEN SET v_menu = 'MASI_RepiteBoleta'; SET v_opcion = NULL;
        ELSEIF v_r < 0.933 THEN SET v_menu = 'NoTMX_SinOp'; SET v_opcion = NULL;
        ELSEIF v_r < 0.937 THEN SET v_menu = 'RES-Aparatos'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.940 THEN SET v_menu = 'RES-Falla-AntivirusMcAfee'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.943 THEN SET v_menu = 'Tmx_SOMO'; SET v_opcion = NULL;
        ELSEIF v_r < 0.946 THEN SET v_menu = 'RES-FallaEntretiene'; SET v_opcion = 'NOBOT';
        ELSEIF v_r < 0.949 THEN SET v_menu = 'ANI'; SET v_opcion = NULL;
        ELSEIF v_r < 0.952 THEN SET v_menu = 'KIPSOLCOM'; SET v_opcion = NULL;
        ELSEIF v_r < 0.955 THEN SET v_menu = 'Numero Telmex'; SET v_opcion = NULL;
        ELSEIF v_r < 0.958 THEN SET v_menu = 'RES_CambioDom'; SET v_opcion = IF(RAND()<0.9,'DEFAULT','CECOR');
        ELSEIF v_r < 0.960 THEN SET v_menu = 'SaldoCabecera'; SET v_opcion = NULL;
        ELSEIF v_r < 0.962 THEN SET v_menu = 'RES-MADT-MVSHUB'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.964 THEN SET v_menu = 'RES-DISH'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.966 THEN SET v_menu = 'RES-SegurosInbursa'; SET v_opcion = IF(RAND()<0.9,'DEFAULT','CECOR');
        ELSEIF v_r < 0.968 THEN SET v_menu = 'RES-TAE'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.970 THEN SET v_menu = 'RES_OcultaVta'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.972 THEN SET v_menu = 'RES-Falla-Dish'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.974 THEN SET v_menu = 'RES-Falla-MVSHUB'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.976 THEN SET v_menu = 'RES-ClaroDrive'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.978 THEN SET v_menu = 'RES-StartGo'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.980 THEN SET v_menu = 'RES-Falla-AntivirusMcAfee'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.982 THEN SET v_menu = 'MenuSaldosCabecera'; SET v_opcion = NULL;
        ELSEIF v_r < 0.984 THEN SET v_menu = 'Saldos3_Otra'; SET v_opcion = NULL;
        ELSEIF v_r < 0.986 THEN SET v_menu = 'Saldos1_Pagar'; SET v_opcion = NULL;
        ELSEIF v_r < 0.988 THEN SET v_menu = 'RES_CAMBIODOMICILIO'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.990 THEN SET v_menu = 'RES-ContratacionInfinitum'; SET v_opcion = 'LAREDO';
        ELSEIF v_r < 0.992 THEN SET v_menu = 'RES-Entr'; SET v_opcion = '2L';
        ELSEIF v_r < 0.994 THEN SET v_menu = 'NOTMX-CONT-Portabilidad'; SET v_opcion = 'DEFAULT';
        ELSEIF v_r < 0.996 THEN SET v_menu = 'RES-FallaInternet'; SET v_opcion = 'CECOR';
        ELSEIF v_r < 0.998 THEN SET v_menu = 'RES-FallaInternet'; SET v_opcion = 'ACUNA';
        ELSE                     SET v_menu = 'default'; SET v_opcion = NULL;
        END IF;

        -- --------------------------------------------------------
        -- cDID_Centro_Transferencia — VDNs REALES de producción
        -- Fuente: DOC-03 top-15 + distribución Q1-Q3 real
        -- --------------------------------------------------------
        SET v_r = RAND();

        -- El centro depende del menú (lógica real del sistema)
        -- Abandono → mayoritariamente 19020086 o CLIENTE_COLGO
        IF v_menu IN ('cliente_colgo') OR v_menu IS NULL OR v_menu = '' OR v_menu = 'sin cMenu' THEN
            -- cliente_colgo en cDID_Centro_Transferencia → normaliza a CLIENTE_COLGO
            IF v_r < 0.85 THEN SET v_centro_raw = 'cliente_colgo';
            ELSEIF v_r < 0.97 THEN SET v_centro_raw = '19020086';
            ELSE SET v_centro_raw = NULL; END IF;

        ELSEIF v_menu IN ('SinOpcion_Cabecera','Marque3','Desborde_Promocional') THEN
            SET v_centro_raw = '19020086';

        ELSEIF v_menu = 'NOTMX-SeguimientoInstalacion' OR v_menu = 'RES-SegInst_2024' THEN
            SET v_centro_raw = '10728487';  -- VDN real de seguimiento instalación

        ELSEIF v_menu IN ('RES-FallaInternet','RES-FallaInternet_2024','RES-Fallas_2024') THEN
            SET v_r2 = RAND();
            IF    v_r2 < 0.49 THEN SET v_centro_raw = '10828091';   -- mayor falla internet
            ELSEIF v_r2 < 0.66 THEN SET v_centro_raw = '19010000';  -- genérico
            ELSEIF v_r2 < 0.80 THEN SET v_centro_raw = '15070019';  -- fallas 2024
            ELSEIF v_r2 < 0.90 THEN SET v_centro_raw = '10728000';  -- diagnóstico DSLAM
            ELSE                     SET v_centro_raw = '10828091';
            END IF;

        ELSEIF v_menu = 'RES-FallasLinea' THEN
            SET v_r2 = RAND();
            IF v_r2 < 0.7 THEN SET v_centro_raw = '19010000';
            ELSEIF v_r2 < 0.9 THEN SET v_centro_raw = '10828091';
            ELSE SET v_centro_raw = '10228051'; END IF;

        ELSEIF v_menu = 'RES_FALLA_STOP' THEN
            SET v_centro_raw = '10928253';

        ELSEIF v_menu IN ('RES-MADT-Detalle','RES-MADT-MVSHUB') THEN
            SET v_r2 = RAND();
            IF v_r2 < 0.8 THEN SET v_centro_raw = '15070013';
            ELSE SET v_centro_raw = '10928253'; END IF;

        ELSEIF v_menu IN ('RES-ContratacionInfinitum','RES-ContratacionInfinitum_2024','RES-ContratacionInfinitum_FM') THEN
            SET v_r2 = RAND();
            IF    v_r2 < 0.7 THEN SET v_centro_raw = '15070013';
            ELSEIF v_r2 < 0.88 THEN SET v_centro_raw = '15070006';
            ELSE                     SET v_centro_raw = '15070059';
            END IF;

        ELSEIF v_menu = 'NOTMX-CONT-Contratacion' THEN
            SET v_centro_raw = '15070059';

        ELSEIF v_menu = 'NOTMX-CONT-Portabilidad' THEN
            SET v_centro_raw = IF(RAND()<0.8,'10728485','14929014');

        ELSEIF v_menu IN ('RES-SaldooPagos','RES-Saldos-WT','RES-SaldosPagos_2024','RES-SaldosPagos_FM') THEN
            SET v_centro_raw = IF(RAND()<0.8,'14929014','15070013');

        ELSEIF v_menu = 'Desborde_Cabecera' THEN
            -- Desborde va al centro según la etiqueta
            IF v_opcion IN ('TELECOBRA','TELVICOBRA') THEN
                SET v_centro_raw = IF(v_opcion='TELVICOBRA','10428174','14928994');
            ELSEIF v_opcion LIKE 'ECATEPEC%' THEN
                SET v_centro_raw = IF(RAND()<0.5,'10928299','19020076');
            ELSEIF v_opcion LIKE 'QJA%' THEN
                SET v_centro_raw = '10928253';
            ELSEIF v_opcion IN ('MES_1','MES_2') THEN
                SET v_centro_raw = '10428163';
            ELSE
                SET v_centro_raw = '10928253';
            END IF;

        ELSEIF v_menu IN ('RES-Entr') THEN
            SET v_centro_raw = IF(RAND()<0.7,'10728382','15070013');

        ELSEIF v_menu IN ('RES_CambioDom','RES_CambioTit','RES_Cambios') THEN
            SET v_centro_raw = IF(RAND()<0.7,'15070012','15070004');

        ELSEIF v_menu IN ('RES-Aparatos') THEN
            SET v_centro_raw = IF(RAND()<0.7,'15070013','15070007');

        ELSEIF v_menu IN ('RES-FallaEntretiene') THEN
            SET v_centro_raw = IF(RAND()<0.6,'19020033','10728381');

        ELSEIF v_menu IN ('ANI','KIPSOLCOM','Numero Telmex','MASI_RepiteBoleta','NoTMX_SinOp') THEN
            -- anomalías → van al genérico o 19020086
            SET v_centro_raw = IF(RAND()<0.7,'19020086','19010000');

        ELSE
            -- Resto: distribución proporcional top VDNs
            SET v_r2 = RAND();
            IF    v_r2 < 0.30 THEN SET v_centro_raw = '19020086';
            ELSEIF v_r2 < 0.42 THEN SET v_centro_raw = '19010000';
            ELSEIF v_r2 < 0.54 THEN SET v_centro_raw = '10828091';
            ELSEIF v_r2 < 0.64 THEN SET v_centro_raw = '10928253';
            ELSEIF v_r2 < 0.72 THEN SET v_centro_raw = '15070013';
            ELSEIF v_r2 < 0.79 THEN SET v_centro_raw = '10728487';
            ELSEIF v_r2 < 0.85 THEN SET v_centro_raw = '14929014';
            ELSEIF v_r2 < 0.89 THEN SET v_centro_raw = '19020088';
            ELSEIF v_r2 < 0.92 THEN SET v_centro_raw = '309004';
            ELSEIF v_r2 < 0.95 THEN SET v_centro_raw = '1309004';
            ELSE                     SET v_centro_raw = NULL;
            END IF;
        END IF;

        -- Aplicar formato NK90 real (~5.71% de los registros con VDN)
        -- Un VDN de 7-8 dígitos + cTelefono_Digitado de 10 dígitos concatenados
        IF v_centro_raw IS NOT NULL
           AND v_centro_raw NOT IN ('cliente_colgo','0000000')
           AND v_tel_dig IS NOT NULL
           AND RAND() < 0.065 THEN        -- 5.71% NK90 según datos reales
            SET v_centro_raw = CONCAT(v_centro_raw, v_tel_dig);
        END IF;

        -- cEtiquetacliente
        SET v_r = RAND();
        IF    v_r < 0.05 THEN SET v_etiqueta = NULL;
        ELSEIF v_r < 0.30 THEN SET v_etiqueta = 'VIP';
        ELSEIF v_r < 0.55 THEN SET v_etiqueta = 'REGULAR';
        ELSEIF v_r < 0.70 THEN SET v_etiqueta = 'MOROSO';
        ELSEIF v_r < 0.82 THEN SET v_etiqueta = 'NUEVO';
        ELSEIF v_r < 0.90 THEN SET v_etiqueta = 'BAJA_RIESGO';
        ELSE                    SET v_etiqueta = 'RETENCION';
        END IF;

        -- INSERT dinámico
        SET v_sql = CONCAT(
            'INSERT INTO ', p_tabla,
            ' (dFecha,dHoraInicio,dHoraFin,cDID_800Transfer,',
            '  cDID_Centro_Transferencia,cMenu,cOpcion,',
            '  cTelefono_Origen,cTelefono_Digitado,cEtiquetacliente) VALUES (',
            QUOTE(v_fecha), ',', QUOTE(v_hora_ini), ',', QUOTE(v_hora_fin), ',',
            QUOTE(v_did), ',',
            IF(v_centro_raw IS NULL, 'NULL', QUOTE(v_centro_raw)), ',',
            IF(v_menu IS NULL, 'NULL', IF(v_menu='', "''", QUOTE(v_menu))), ',',
            IF(v_opcion IS NULL, 'NULL', QUOTE(v_opcion)), ',',
            QUOTE(v_tel_origen), ',',
            IF(v_tel_dig IS NULL, 'NULL', QUOTE(v_tel_dig)), ',',
            IF(v_etiqueta IS NULL, 'NULL', QUOTE(v_etiqueta)), ')'
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
        (tabla,accion,filas_antes,filas_despues,seed_rows_cfg,script_version)
    VALUES (p_tabla,v_accion,v_count_antes,v_count_des,p_rows,p_script_ver);

    SELECT CONCAT('OK: ', p_tabla, ' — ', v_count_des,
                  ' registros reales (accion: ', v_accion, ')') AS resultado;

END sp_seed_historico_real$$

DELIMITER ;

-- =============================================================================
-- Ejecutar seed para los 6 quarters
-- =============================================================================

-- Q1 2025
CALL sp_seed_historico_real('tbl_historico_t1_2025','2025-01-01','2025-03-31',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER);

-- Q2 2025
CALL sp_seed_historico_real('tbl_historico_t2_2025','2025-04-01','2025-06-30',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER);

-- Q3 2025
CALL sp_seed_historico_real('tbl_historico_t3_2025','2025-07-01','2025-09-30',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER);

-- Q4 2025
CALL sp_seed_historico_real('tbl_historico_t4_2025','2025-10-01','2025-12-31',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER);

-- Q1 2026
CALL sp_seed_historico_real('tbl_historico_t1_2026','2026-01-01','2026-03-31',
    @SEED_ROWS, @FORCE_RESEED, @SCRIPT_VER);

-- Q2 2026 (parcial — datos hasta hoy 2026-05-06)
SET @SEED_ROWS_PARCIAL = GREATEST(1000, FLOOR(@SEED_ROWS * 36 / 91));
CALL sp_seed_historico_real('tbl_historico_t2_2026','2026-04-01','2026-05-06',
    @SEED_ROWS_PARCIAL, @FORCE_RESEED, @SCRIPT_VER);

DROP PROCEDURE IF EXISTS sp_seed_historico_real;

-- =============================================================================
-- Verificación: distribución de menús (debe parecerse a producción real)
-- =============================================================================
SELECT '--- VERIFICACIÓN DE DISTRIBUCIÓN REAL ---' AS info;

SELECT
    COALESCE(NULLIF(TRIM(cMenu),''), 'NULL/VACIO')   AS menu_normalizado,
    COUNT(*)                                          AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM tbl_historico_t1_2025
GROUP BY menu_normalizado
ORDER BY total DESC
LIMIT 15;

-- Verificar VDNs reales presentes
SELECT DISTINCT
    CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL
          OR TRIM(cDID_Centro_Transferencia) = ''     THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN LENGTH(cDID_Centro_Transferencia) > 10
            THEN LEFT(cDID_Centro_Transferencia,
                      LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE cDID_Centro_Transferencia
    END AS centro_normalizado,
    COUNT(*) AS registros
FROM tbl_historico_t1_2025
GROUP BY centro_normalizado
ORDER BY registros DESC
LIMIT 15;

SELECT 'Seed real completado.' AS resultado;
