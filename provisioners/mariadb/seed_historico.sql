-- =============================================================================
-- seed_historico.sql — Poblar tbl_historico_tN_2025 con datos representativos
-- =============================================================================
-- Genera datos que replican los patrones reales del IVR:
--
-- DIDs de entrada (cDID_800Transfer):
--   Puebla    19020084  (~25% del volumen)
--   NacionalA 19028031  (~45% del volumen)
--   NacionalB 19020001  (~30% del volumen)
--
-- Distribución de cMenu (basada en análisis real Q3):
--   cliente_colgo       ~52%   abandono — mayor grupo
--   VACIO               ~9%    abandono — cMenu vacío/NULL normalizado
--   SinOpcion_Cabecera  ~4%    abandono
--   Desborde_Cabecera   ~5%    enrutamiento por etiqueta (no es abandono)
--   Desborde_Promocional ~2%   enrutamiento promocional
--   menu reales          ~28%  llamadas completadas (navegaron el IVR)
--
-- Menús reales documentados (PROVEN de scripts de producción):
--   Saldo, Pagos, Atencion, Transferencia, Informacion,
--   ReclamacionesTecnicas, BajasModificaciones, CambioNumero,
--   ConsultaFactura, SolicitudProducto
--
-- cDID_Centro_Transferencia:
--   Formato NK90 (len > 10): VDN + cTelefono_Digitado concatenados
--   Formato normal (len <= 10): solo VDN (post-IPVR o directo)
--   NULL: llamada no transferida (abandono o sin centro)
--   'cliente_colgo': llamada terminada por cliente
--
-- Bugs reales replicados:
--   ~0.3% de registros: dHoraInicio > dHoraFin (swapped)
--
-- SEED_ROWS_PER_QUARTER controla el volumen. Producción: ~11-14M/quarter.
-- Para desarrollo: 5000 por quarter (ajustar según necesidad).
--
-- IDEMPOTENTE: DROP + recreación del SP en cada ejecución.
-- No trunca las tablas — acumula si se corre múltiples veces.
--
-- USO:
--   mysql -u django_user -pdjango_pass ivr_legacy < seed_historico.sql
-- =============================================================================

USE ivr_legacy;

-- Configurar variables de sesion para mejor rendimiento en insert masivo
SET SESSION foreign_key_checks = 0;
SET SESSION unique_checks      = 0;
SET SESSION sql_log_bin        = 0;

-- =============================================================================
-- SP: sp_seed_historico
-- Genera registros realistas para una tabla historica.
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_seed_historico;

DELIMITER $$

CREATE PROCEDURE sp_seed_historico(
    IN  p_tabla      VARCHAR(60),   -- nombre de la tabla destino
    IN  p_fecha_ini  DATE,           -- inicio del rango (ej: '2025-01-01')
    IN  p_fecha_fin  DATE,           -- fin del rango   (ej: '2025-03-31')
    IN  p_rows       INT             -- numero de registros a generar
)
BEGIN
    DECLARE v_i            INT DEFAULT 0;
    DECLARE v_rand         FLOAT;
    DECLARE v_rand2        FLOAT;

    DECLARE v_fecha        DATE;
    DECLARE v_hora_ini     DATETIME;
    DECLARE v_hora_fin     DATETIME;
    DECLARE v_duracion_seg INT;
    DECLARE v_inicio_hora  INT;   -- hora del dia en segundos desde medianoche
    DECLARE v_swapped      TINYINT DEFAULT 0;

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

    SET v_dias_rango = DATEDIFF(p_fecha_fin, p_fecha_ini) + 1;

    SET v_i = 0;
    WHILE v_i < p_rows DO

        SET v_rand  = RAND();
        SET v_rand2 = RAND();

        -- --------------------------------------------------------
        -- dFecha: distribuida uniformemente en el rango
        -- --------------------------------------------------------
        SET v_fecha = DATE_ADD(p_fecha_ini,
                          INTERVAL FLOOR(v_rand * v_dias_rango) DAY);

        -- --------------------------------------------------------
        -- Horario de operacion: 07:00-21:00 (pico 09:00-18:00)
        -- --------------------------------------------------------
        SET v_inicio_hora = (7 * 3600)
            + FLOOR(RAND() * (14 * 3600));  -- 07:00 + hasta 14h

        -- Duracion: 5 segundos a 15 minutos (900 seg)
        -- Abandonos tipicamente cortos (< 60 seg)
        SET v_duracion_seg = FLOOR(5 + RAND() * 895);

        SET v_hora_ini = TIMESTAMP(v_fecha,
            SEC_TO_TIME(v_inicio_hora));
        SET v_hora_fin = TIMESTAMP(v_fecha,
            SEC_TO_TIME(v_inicio_hora + v_duracion_seg));

        -- Bug real: ~0.3% de registros con inicio > fin (swap de campos en IVR)
        SET v_swapped = IF(RAND() < 0.003, 1, 0);
        IF v_swapped THEN
            SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora));
            SET v_hora_ini = TIMESTAMP(v_fecha,
                SEC_TO_TIME(v_inicio_hora + v_duracion_seg));
        END IF;

        -- --------------------------------------------------------
        -- cDID_800Transfer: pesos confirmados por segmento
        -- NacionalA 45%, NacionalB 30%, Puebla 25%
        -- --------------------------------------------------------
        SET v_rand = RAND();
        IF v_rand < 0.45 THEN
            SET v_did = '19028031';   -- NacionalA
        ELSEIF v_rand < 0.75 THEN
            SET v_did = '19020001';   -- NacionalB
        ELSE
            SET v_did = '19020084';   -- Puebla
        END IF;

        -- --------------------------------------------------------
        -- cTelefono_Origen: 10 digitos, prefijos reales MX
        -- --------------------------------------------------------
        SET v_rand = RAND();
        IF v_rand < 0.3 THEN
            SET v_tel_origen = CONCAT('443',
                LPAD(FLOOR(RAND() * 9999999), 7, '0'));  -- Michoacan
        ELSEIF v_rand < 0.55 THEN
            SET v_tel_origen = CONCAT('722',
                LPAD(FLOOR(RAND() * 9999999), 7, '0'));  -- Estado de Mexico
        ELSEIF v_rand < 0.75 THEN
            SET v_tel_origen = CONCAT('222',
                LPAD(FLOOR(RAND() * 9999999), 7, '0'));  -- Puebla
        ELSE
            SET v_tel_origen = CONCAT('55',
                LPAD(FLOOR(RAND() * 99999999), 8, '0')); -- CDMX
        END IF;

        -- cTelefono_Digitado: ~30% NULL (no digito), resto igual o diferente
        SET v_rand = RAND();
        IF v_rand < 0.30 THEN
            SET v_tel_digitado = NULL;
        ELSEIF v_rand < 0.75 THEN
            SET v_tel_digitado = v_tel_origen;   -- misma linea
        ELSE
            -- Linea diferente
            SET v_tel_digitado = CONCAT('443',
                LPAD(FLOOR(RAND() * 9999999), 7, '0'));
        END IF;

        -- --------------------------------------------------------
        -- cMenu y cOpcion: distribucion real documentada
        -- --------------------------------------------------------
        SET v_rand = RAND();

        IF v_rand < 0.52 THEN
            -- Abandono tipo 1: cliente colgo
            SET v_menu   = 'cliente_colgo';
            SET v_opcion = NULL;

        ELSEIF v_rand < 0.61 THEN
            -- Abandono tipo 2: VACIO (cMenu NULL o vacio en fuente)
            -- En la tabla fuente puede ser NULL, '' o 'sin cMenu'
            SET v_rand2 = RAND();
            IF v_rand2 < 0.50 THEN
                SET v_menu = NULL;
            ELSEIF v_rand2 < 0.80 THEN
                SET v_menu = '';
            ELSE
                SET v_menu = 'sin cMenu';
            END IF;
            SET v_opcion = NULL;

        ELSEIF v_rand < 0.65 THEN
            -- Abandono tipo 3: SinOpcion_Cabecera
            SET v_menu   = 'SinOpcion_Cabecera';
            SET v_opcion = NULL;

        ELSEIF v_rand < 0.70 THEN
            -- Enrutamiento por etiqueta (NO es abandono)
            SET v_menu   = 'Desborde_Cabecera';
            SET v_opcion = NULL;

        ELSEIF v_rand < 0.72 THEN
            -- Enrutamiento promocional (NO es abandono)
            SET v_menu   = 'Desborde_Promocional';
            SET v_opcion = NULL;

        ELSE
            -- Llamada completada: navego el IVR
            SET v_rand2 = RAND();
            IF v_rand2 < 0.18 THEN
                SET v_menu   = 'Saldo';
                SET v_opcion = IF(RAND() < 0.5, 'ConsultaTelefonica', 'ConsultaMovil');
            ELSEIF v_rand2 < 0.34 THEN
                SET v_menu   = 'Pagos';
                SET v_opcion = IF(RAND() < 0.6, 'PagoLineaTelefonica', 'PagoMovil');
            ELSEIF v_rand2 < 0.48 THEN
                SET v_menu   = 'Atencion';
                SET v_opcion = IF(RAND() < 0.5, 'AtencionEspecializada', 'AtencionGeneral');
            ELSEIF v_rand2 < 0.58 THEN
                SET v_menu   = 'Transferencia';
                SET v_opcion = IF(RAND() < 0.7, 'TransferenciaDirecta', 'TransferenciaIVR');
            ELSEIF v_rand2 < 0.68 THEN
                SET v_menu   = 'Informacion';
                SET v_opcion = IF(RAND() < 0.5, 'InfoProductos', 'InfoServicios');
            ELSEIF v_rand2 < 0.76 THEN
                SET v_menu   = 'ReclamacionesTecnicas';
                SET v_opcion = IF(RAND() < 0.6, 'FallaServicio', 'EquipoDefectuoso');
            ELSEIF v_rand2 < 0.84 THEN
                SET v_menu   = 'BajasModificaciones';
                SET v_opcion = IF(RAND() < 0.5, 'BajaServicio', 'ModificacionPlan');
            ELSEIF v_rand2 < 0.90 THEN
                SET v_menu   = 'ConsultaFactura';
                SET v_opcion = IF(RAND() < 0.5, 'FacturaDetallada', 'ResumenFactura');
            ELSE
                SET v_menu   = 'SolicitudProducto';
                SET v_opcion = IF(RAND() < 0.5, 'NuevoProducto', 'ActivacionProducto');
            END IF;
        END IF;

        -- --------------------------------------------------------
        -- cDID_Centro_Transferencia
        -- NULL si abandono, valor si transferencia exitosa
        -- --------------------------------------------------------
        IF v_menu IN ('cliente_colgo', 'SinOpcion_Cabecera')
           OR v_menu IS NULL OR v_menu = '' OR v_menu = 'sin cMenu' THEN
            -- Abandono: ~80% NULL, ~15% 'cliente_colgo', ~5% ceros
            SET v_rand = RAND();
            IF v_rand < 0.80 THEN
                SET v_centro = NULL;
            ELSEIF v_rand < 0.95 THEN
                SET v_centro = 'cliente_colgo';
            ELSE
                SET v_centro = '0000000';
            END IF;
        ELSE
            -- Llamada enrutada o completada
            SET v_rand = RAND();

            -- VDN real confirmado: 1309004 (7 digitos), 15070013 (8 digitos)
            IF v_rand < 0.25 THEN
                SET v_vdn = '1309004';
            ELSEIF v_rand < 0.45 THEN
                SET v_vdn = '15070013';
            ELSEIF v_rand < 0.60 THEN
                SET v_vdn = '2309004';    -- variante Q2-Q3
            ELSEIF v_rand < 0.72 THEN
                SET v_vdn = '1205003';
            ELSEIF v_rand < 0.82 THEN
                SET v_vdn = '1408002';
            ELSE
                SET v_vdn = '1705001';
            END IF;

            -- Formato NK90 (~70%): VDN + telefono_digitado concatenados
            -- Formato directo (~30%): solo VDN
            IF v_tel_digitado IS NOT NULL AND RAND() < 0.70 THEN
                SET v_centro = CONCAT(v_vdn, v_tel_digitado);
            ELSE
                SET v_centro = v_vdn;
            END IF;
        END IF;

        -- --------------------------------------------------------
        -- cEtiquetacliente: etiqueta de segmento del cliente
        -- --------------------------------------------------------
        SET v_rand = RAND();
        IF v_rand < 0.05 THEN
            SET v_etiqueta = NULL;
        ELSEIF v_rand < 0.35 THEN
            SET v_etiqueta = 'VIP';
        ELSEIF v_rand < 0.55 THEN
            SET v_etiqueta = 'REGULAR';
        ELSEIF v_rand < 0.70 THEN
            SET v_etiqueta = 'MOROSO';
        ELSEIF v_rand < 0.82 THEN
            SET v_etiqueta = 'NUEVO';
        ELSEIF v_rand < 0.90 THEN
            SET v_etiqueta = 'BAJA_RIESGO';
        ELSE
            SET v_etiqueta = 'RETENCION';
        END IF;

        -- --------------------------------------------------------
        -- INSERT dinamico segun la tabla destino
        -- --------------------------------------------------------
        SET v_sql = CONCAT(
            'INSERT INTO ', p_tabla,
            ' (dFecha, dHoraInicio, dHoraFin, cDID_800Transfer,',
            '  cDID_Centro_Transferencia, cMenu, cOpcion,',
            '  cTelefono_Origen, cTelefono_Digitado, cEtiquetacliente)',
            ' VALUES (',
            QUOTE(v_fecha),          ', ',
            QUOTE(v_hora_ini),       ', ',
            QUOTE(v_hora_fin),       ', ',
            QUOTE(v_did),            ', ',
            IF(v_centro IS NULL,       'NULL', QUOTE(v_centro)),    ', ',
            IF(v_menu   IS NULL,       'NULL',
               IF(v_menu = '',         "''",   QUOTE(v_menu))),     ', ',
            IF(v_opcion IS NULL,       'NULL', QUOTE(v_opcion)),    ', ',
            IF(v_tel_origen IS NULL,   'NULL', QUOTE(v_tel_origen)),', ',
            IF(v_tel_digitado IS NULL, 'NULL', QUOTE(v_tel_digitado)),', ',
            IF(v_etiqueta IS NULL,     'NULL', QUOTE(v_etiqueta)),
            ')'
        );

        SET @dyn_sql = v_sql;
        PREPARE stmt FROM @dyn_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET v_i = v_i + 1;

        -- Commit cada 1000 registros para no saturar el undo log
        IF MOD(v_i, 1000) = 0 THEN
            COMMIT;
        END IF;

    END WHILE;

    COMMIT;
END$$

DELIMITER ;

-- =============================================================================
-- Ejecutar el seed
-- SEED_ROWS_PER_QUARTER: ajustar segun entorno
--   Desarrollo:   5000 (rapido, ~5 seg)
--   Integracion: 50000 (~1 min)
--   Staging:    500000 (~10 min)
-- =============================================================================

SET @SEED_ROWS = 5000;

-- Q1: ya tiene datos si se corrio antes — solo insertar si esta vacia
SELECT COUNT(*) INTO @q1_count FROM tbl_historico_t1_2025;
SELECT COUNT(*) INTO @q2_count FROM tbl_historico_t2_2025;
SELECT COUNT(*) INTO @q3_count FROM tbl_historico_t3_2025;

-- Q1 2025
SELECT CONCAT('Sembrando Q1 2025 (', @SEED_ROWS, ' registros)...') AS info;
CALL sp_seed_historico(
    'tbl_historico_t1_2025',
    '2025-01-01',
    '2025-03-31',
    @SEED_ROWS
);
SELECT COUNT(*) AS total_q1_2025 FROM tbl_historico_t1_2025;

-- Q2 2025
SELECT CONCAT('Sembrando Q2 2025 (', @SEED_ROWS, ' registros)...') AS info;
CALL sp_seed_historico(
    'tbl_historico_t2_2025',
    '2025-04-01',
    '2025-06-30',
    @SEED_ROWS
);
SELECT COUNT(*) AS total_q2_2025 FROM tbl_historico_t2_2025;

-- Q3 2025
SELECT CONCAT('Sembrando Q3 2025 (', @SEED_ROWS, ' registros)...') AS info;
CALL sp_seed_historico(
    'tbl_historico_t3_2025',
    '2025-07-01',
    '2025-09-30',
    @SEED_ROWS
);
SELECT COUNT(*) AS total_q3_2025 FROM tbl_historico_t3_2025;

-- Q4 2025
SELECT CONCAT('Sembrando Q4 2025 (', @SEED_ROWS, ' registros)...') AS info;
CALL sp_seed_historico(
    'tbl_historico_t4_2025',
    '2025-10-01',
    '2025-12-31',
    @SEED_ROWS
);
SELECT COUNT(*) AS total_q4_2025 FROM tbl_historico_t4_2025;

-- Q1 2026
SELECT CONCAT('Sembrando Q1 2026 (', @SEED_ROWS, ' registros)...') AS info;
CALL sp_seed_historico(
    'tbl_historico_t1_2026',
    '2026-01-01',
    '2026-03-31',
    @SEED_ROWS
);
SELECT COUNT(*) AS total_q1_2026 FROM tbl_historico_t1_2026;

-- Q2 2026 (parcial — datos hasta 2026-05-06, dia actual)
-- Volumen proporcional: 36 dias de 91 del trimestre (~40%)
SET @SEED_ROWS_PARCIAL = GREATEST(500, FLOOR(@SEED_ROWS * 36 / 91));
SELECT CONCAT('Sembrando Q2 2026 parcial (', @SEED_ROWS_PARCIAL,
              ' registros — 2026-04-01 a 2026-05-06)...') AS info;
CALL sp_seed_historico(
    'tbl_historico_t2_2026',
    '2026-04-01',
    '2026-05-06',
    @SEED_ROWS_PARCIAL
);
SELECT COUNT(*) AS total_q2_2026_parcial FROM tbl_historico_t2_2026;


-- =============================================================================
-- Verificacion de calidad del seed
-- =============================================================================
SELECT '--- VERIFICACION DE DATOS ---' AS info;

-- Distribucion de DIDs en Q1
SELECT
    'Q1' AS trimestre,
    cDID_800Transfer,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM tbl_historico_t1_2025
GROUP BY cDID_800Transfer
ORDER BY total DESC;

-- Distribucion de cMenu en Q1 (top 10)
SELECT
    'Q1' AS trimestre,
    COALESCE(NULLIF(TRIM(cMenu), ''), 'NULL/vacio') AS menu_normalizado,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM tbl_historico_t1_2025
GROUP BY menu_normalizado
ORDER BY total DESC
LIMIT 10;

-- Bug dHoraInicio > dHoraFin (esperado ~0.3% del total)
SELECT
    'bug_swap_fecha' AS tipo,
    COUNT(*) AS registros_con_bug,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tbl_historico_t1_2025), 3) AS pct
FROM tbl_historico_t1_2025
WHERE dHoraInicio > dHoraFin;

-- Formato NK90 (len > 10) en cDID_Centro_Transferencia
SELECT
    'NK90_format' AS tipo,
    SUM(CASE WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN 1 ELSE 0 END) AS formato_nk90,
    SUM(CASE WHEN LENGTH(cDID_Centro_Transferencia) <= 10
             AND cDID_Centro_Transferencia IS NOT NULL
             AND cDID_Centro_Transferencia != 'cliente_colgo'
             AND cDID_Centro_Transferencia != '0000000'
             THEN 1 ELSE 0 END) AS formato_directo,
    SUM(CASE WHEN cDID_Centro_Transferencia IS NULL THEN 1 ELSE 0 END) AS nulo,
    COUNT(*) AS total
FROM tbl_historico_t1_2025;

-- Limpiar el SP
DROP PROCEDURE IF EXISTS sp_seed_historico;

SELECT 'Seed completado. SP temporal eliminado.' AS resultado;
