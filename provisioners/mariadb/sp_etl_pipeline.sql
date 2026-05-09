-- =============================================================================
-- sp_etl_pipeline.sql
-- Stored Procedures del pipeline ETL IVR (IACT)
-- Versión: 2.0.0
--
-- PREREQUISITOS (en orden):
--   1. funciones_utilidad.sql
--   2. schema_base_ivr.sql
--
-- SPs CREADOS (orden de dependencias):
--   sp_etl_base_detalle    — ETL principal, scan de tbl_historico_*
--   sp_etl_base_clientes   — ETL secundario, COUNT DISTINCT
--   sp_etl_validar         — Validación post-load
--   sp_etl_maestro         — Orquestador con checkpoints
--   sp_etl_historico       — Wrapper para carga histórica
-- =============================================================================

DELIMITER $$

-- =============================================================================
-- sp_etl_base_detalle
-- Lee tbl_historico_tN_YYYY, normaliza y agrega en base_ivr_detalle.
-- Procesa por mes para mantener el tamaño del undo log manejable.
--
-- PARÁMETROS:
--   p_quarter   'Q02_26'
--   p_inicio    '2026-04-01'
--   p_fin       '2026-06-30'
--   p_table     'tbl_historico_t2_2026'
--   p_log_id    ID del registro en job_execution_log para actualizar progreso
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_base_detalle$$
CREATE PROCEDURE sp_etl_base_detalle(
    IN p_quarter  VARCHAR(10),
    IN p_inicio   DATE,
    IN p_fin      DATE,
    IN p_table    VARCHAR(100),
    IN p_log_id   INT
)
etl_detalle: BEGIN
    DECLARE v_mes_ini    DATE;
    DECLARE v_mes_fin    DATE;
    DECLARE v_total_ins  INT DEFAULT 0;
    DECLARE v_mes_ins    INT DEFAULT 0;
    DECLARE v_mes_num    INT DEFAULT 0;

    -- Validación básica
    IF p_table IS NULL OR p_table = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_base_detalle: p_table no puede ser NULL/vacío';
    END IF;

    -- Iterar mes a mes dentro del quarter (chunks ~4M filas c/u)
    SET v_mes_ini = p_inicio;

    WHILE v_mes_ini <= p_fin DO
        SET v_mes_fin = LAST_DAY(v_mes_ini);
        -- Si el último mes del quarter termina antes del fin del mes calendario
        IF v_mes_fin > p_fin THEN
            SET v_mes_fin = p_fin;
        END IF;

        SET v_mes_num = v_mes_num + 1;

        -- DELETE idempotente solo para este mes
        DELETE FROM base_ivr_detalle
        WHERE trimestre = p_quarter
          AND fecha = DATE_FORMAT(v_mes_ini, '%Y%m');

        -- INSERT con normalización usando las funciones de utilidad
        -- PREPARE/EXECUTE necesario por nombre de tabla dinámico (CNST-ETL-008)
        SET @etl_sql = CONCAT('
            INSERT INTO base_ivr_detalle
                (trimestre, fecha, segmento, centro_transferencia,
                 menu, opcion,
                 total_llamadas, misma_linea, linea_diferente, no_digito_telefono,
                 llamadas_entre_semana, llamadas_fines_semana)
            SELECT
                ?,                                           -- trimestre
                DATE_FORMAT(dFecha, ''%Y%m''),               -- fecha (YYYYMM)
                fn_did_segmento(cDID_800Transfer),           -- segmento
                fn_normalizar_centro(cDID_Centro_Transferencia), -- centro normalizado
                fn_normalizar_menu(cMenu),                   -- menu (VACIO si vacío)
                COALESCE(NULLIF(TRIM(cOpcion), ''''), ''SIN_OPCION''), -- opcion
                COUNT(*),                                    -- total_llamadas
                SUM(cTelefono_Origen = cTelefono_Digitado
                    AND cTelefono_Digitado IS NOT NULL),     -- misma_linea
                SUM(cTelefono_Origen != cTelefono_Digitado
                    AND cTelefono_Digitado IS NOT NULL),     -- linea_diferente
                SUM(cTelefono_Digitado IS NULL),             -- no_digito_telefono
                SUM(ivr_es_dia_semana(dFecha)),               -- llamadas_entre_semana
                SUM(NOT ivr_es_dia_semana(dFecha))            -- llamadas_fines_semana
            FROM ', p_table, '
            WHERE dFecha BETWEEN ? AND ?
              AND cDID_800Transfer IN (''19020084'', ''19028031'', ''19020001'')
            GROUP BY
                DATE_FORMAT(dFecha, ''%Y%m''),
                fn_did_segmento(cDID_800Transfer),
                fn_normalizar_centro(cDID_Centro_Transferencia),
                fn_normalizar_menu(cMenu),
                COALESCE(NULLIF(TRIM(cOpcion), ''''), ''SIN_OPCION'')
            ON DUPLICATE KEY UPDATE
                total_llamadas        = VALUES(total_llamadas),
                misma_linea           = VALUES(misma_linea),
                linea_diferente       = VALUES(linea_diferente),
                no_digito_telefono    = VALUES(no_digito_telefono),
                llamadas_entre_semana = VALUES(llamadas_entre_semana),
                llamadas_fines_semana = VALUES(llamadas_fines_semana),
                cargado_en         = CURRENT_TIMESTAMP
        ');

        PREPARE etl_stmt FROM @etl_sql;
        SET @etl_q = p_quarter, @etl_i = v_mes_ini, @etl_f = v_mes_fin;
        EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
        SET v_mes_ins = ROW_COUNT();
        DEALLOCATE PREPARE etl_stmt;

        SET v_total_ins = v_total_ins + v_mes_ins;

        -- Avanzar al siguiente mes
        SET v_mes_ini = DATE_ADD(LAST_DAY(v_mes_ini), INTERVAL 1 DAY);
    END WHILE;

    -- Actualizar progreso en el log
    IF p_log_id IS NOT NULL AND p_log_id > 0 THEN
        UPDATE job_execution_log
        SET records_procesados = v_total_ins,
            status             = 'SUCCESS',
            end_time           = NOW()
        WHERE id = p_log_id;
    END IF;

END etl_detalle$$


-- =============================================================================
-- sp_etl_base_clientes
-- Segundo scan de tbl_historico_*: COUNT(DISTINCT cTelefono_Origen).
-- Separado de sp_etl_base_detalle porque COUNT DISTINCT no es aditivo
-- y no puede calcularse desde base_ivr_detalle.
-- Resultado esperado: 3 filas (una por segmento).
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_base_clientes$$
CREATE PROCEDURE sp_etl_base_clientes(
    IN p_quarter  VARCHAR(10),
    IN p_inicio   DATE,
    IN p_fin      DATE,
    IN p_table    VARCHAR(100),
    IN p_log_id   INT
)
etl_clientes: BEGIN
    DECLARE v_rows INT DEFAULT 0;

    IF p_table IS NULL OR p_table = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_base_clientes: p_table no puede ser NULL/vacío';
    END IF;

    -- DELETE idempotente para el quarter completo
    DELETE FROM base_ivr_clientes WHERE trimestre = p_quarter;

    SET @cli_sql = CONCAT('
        INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
        SELECT
            ?,
            fn_did_segmento(cDID_800Transfer)  AS segmento,
            COUNT(DISTINCT cTelefono_Origen)   AS clientes_unicos
            -- NOTA P-NEW-04: pendiente confirmar con el equipo si debe ser
            -- cTelefono_Origen (siempre presente) o cTelefono_Digitado (21% NULL).
            -- Datos reales (ratio ~3.5 llamadas/cliente) apuntan a cTelefono_Origen.
        FROM ', p_table, '
        WHERE dFecha BETWEEN ? AND ?
          AND cDID_800Transfer IN (''19020084'', ''19028031'', ''19020001'')
        GROUP BY fn_did_segmento(cDID_800Transfer)
        ON DUPLICATE KEY UPDATE
            clientes_unicos = VALUES(clientes_unicos),
            cargado_en      = CURRENT_TIMESTAMP
    ');

    PREPARE cli_stmt FROM @cli_sql;
    SET @cli_q = p_quarter, @cli_i = p_inicio, @cli_f = p_fin;
    EXECUTE cli_stmt USING @cli_q, @cli_i, @cli_f;
    SET v_rows = ROW_COUNT();
    DEALLOCATE PREPARE cli_stmt;

    IF p_log_id IS NOT NULL AND p_log_id > 0 THEN
        UPDATE job_execution_log
        SET records_procesados = v_rows,
            status             = 'SUCCESS',
            end_time           = NOW()
        WHERE id = p_log_id;
    END IF;

END etl_clientes$$


-- =============================================================================
-- sp_etl_validar
-- Validación post-load: verifica integridad de los datos cargados.
-- Retorna una fila por check con su resultado.
-- El maestro usa estos resultados para determinar status='SUCCESS' o 'PARTIAL'.
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_validar$$
CREATE PROCEDURE sp_etl_validar(
    IN  p_quarter   VARCHAR(10),
    OUT p_ok        BOOLEAN,
    OUT p_mensaje   TEXT
)
BEGIN
    DECLARE v_count_det   INT DEFAULT 0;
    DECLARE v_count_cli   INT DEFAULT 0;
    DECLARE v_sum_llamadas BIGINT DEFAULT 0;
    DECLARE v_msg         TEXT DEFAULT '';

    SELECT COUNT(*), SUM(total_llamadas)
    INTO v_count_det, v_sum_llamadas
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter;

    SELECT COUNT(*)
    INTO v_count_cli
    FROM base_ivr_clientes
    WHERE trimestre = p_quarter;

    -- Check 1: base_ivr_detalle tiene datos
    IF v_count_det = 0 THEN
        SET v_msg = CONCAT(v_msg, 'ERROR: base_ivr_detalle vacía para ', p_quarter, '. ');
    END IF;

    -- Check 2: base_ivr_clientes tiene exactamente 3 filas (una por segmento)
    IF v_count_cli != 3 THEN
        SET v_msg = CONCAT(v_msg, 'ERROR: base_ivr_clientes tiene ',
                           v_count_cli, ' filas (esperado: 3) para ', p_quarter, '. ');
    END IF;

    -- Check 3: total_llamadas > 0 (detecta INSERT exitoso pero sin datos útiles)
    IF v_sum_llamadas = 0 THEN
        SET v_msg = CONCAT(v_msg, 'ADVERTENCIA: total_llamadas = 0 en base_ivr_detalle. ');
    END IF;

    -- Resultado
    SET p_ok = (v_count_det > 0 AND v_count_cli = 3 AND v_sum_llamadas > 0);
    SET p_mensaje = IF(p_ok, CONCAT('OK — ', v_count_det, ' filas detalle, ',
                                    v_count_cli, ' filas clientes, ',
                                    FORMAT(v_sum_llamadas, 0), ' llamadas totales.'),
                            v_msg);

    -- Emitir result set para consulta directa
    SELECT
        p_quarter                        AS quarter,
        v_count_det                      AS filas_detalle,
        v_count_cli                      AS filas_clientes,
        FORMAT(v_sum_llamadas, 0)        AS total_llamadas,
        p_ok                             AS validacion_ok,
        p_mensaje                        AS mensaje;
END$$


-- =============================================================================
-- sp_etl_maestro
-- Orquestador del pipeline con checkpoints por paso.
-- Determina automáticamente el quarter actual y la tabla fuente.
-- Registra cada paso en job_execution_log con su propio estado.
--
-- DISPARO: evt_etl_diario (MySQL Event, 02:00 AM)
--          manage.py run_etl (Django management command)
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_maestro$$
CREATE PROCEDURE sp_etl_maestro()
BEGIN
    -- FIX: eliminados labels de bloque y LEAVE en handlers anidados.
    -- MariaDB 10.11 no permite LEAVE de bloque externo desde EXIT HANDLER.
    -- Patron reemplazado: variable v_abort como flag de salida temprana.
    DECLARE v_year       INT;
    DECLARE v_qnum       INT;
    DECLARE v_quarter    VARCHAR(10);
    DECLARE v_table      VARCHAR(100);
    DECLARE v_inicio     DATE;
    DECLARE v_fin        DATE;
    DECLARE v_maestro_id INT;
    DECLARE v_step_id    INT;
    DECLARE v_enabled    BOOLEAN;
    DECLARE v_timeout    INT;
    DECLARE v_ok         BOOLEAN;
    DECLARE v_msg        TEXT;
    DECLARE v_err_msg    TEXT;
    DECLARE v_abort      BOOLEAN DEFAULT FALSE;

    -- -----------------------------------------------------------------------
    -- PASO 0: Verificar que el job está habilitado
    -- -----------------------------------------------------------------------
    SELECT is_enabled, timeout_seconds
    INTO v_enabled, v_timeout
    FROM job_config
    WHERE job_name = 'etl_diario';

    IF NOT v_enabled THEN
        INSERT INTO job_execution_log
            (job_name, step_name, status, start_time, end_time, ejecutado_por)
        VALUES ('etl_diario', 'maestro', 'SKIP', NOW(), NOW(), 'evt_etl_diario');
        SET v_abort = TRUE;
    END IF;

    -- -----------------------------------------------------------------------
    -- PASO 1: Verificar concurrencia (ventana mínima de 6 horas)
    -- -----------------------------------------------------------------------
    IF NOT v_abort AND EXISTS (
        SELECT 1 FROM job_execution_log
        WHERE job_name = 'etl_diario'
          AND step_name = 'maestro'
          AND status = 'RUNNING'
          AND start_time > DATE_SUB(NOW(), INTERVAL 6 HOUR)
    ) THEN
        INSERT INTO job_execution_log
            (job_name, step_name, status, start_time, end_time, ejecutado_por,
             error_message)
        VALUES ('etl_diario', 'maestro', 'SKIP', NOW(), NOW(), 'evt_etl_diario',
                'Otro job etl_diario está RUNNING en las últimas 6 horas.');
        SET v_abort = TRUE;
    END IF;

    IF NOT v_abort THEN

    -- -----------------------------------------------------------------------
    -- PASO 2: Calcular quarter y tabla fuente (dinámico — cualquier año)
    -- -----------------------------------------------------------------------
    SET v_year  = YEAR(CURDATE());
    SET v_qnum  = QUARTER(CURDATE());
    SET v_quarter = CONCAT('Q0', v_qnum, '_', RIGHT(v_year, 2));
    SET v_table   = CONCAT('tbl_historico_t', v_qnum, '_', v_year);

    SET v_inicio = MAKEDATE(v_year, 1)
                   + INTERVAL (v_qnum - 1) * 3 MONTH;
    SET v_fin    = LAST_DAY(v_inicio + INTERVAL 2 MONTH);

    -- -----------------------------------------------------------------------
    -- PASO 3: Registrar inicio del maestro
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_diario', v_quarter, 'maestro', v_table,
         'RUNNING', NOW(), 'evt_etl_diario');
    SET v_maestro_id = LAST_INSERT_ID();

    -- -----------------------------------------------------------------------
    -- PASO 4: ETL base_ivr_detalle
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_diario', v_quarter, 'etl_base_detalle', v_table,
         'RUNNING', NOW(), 'evt_etl_diario');
    SET v_step_id = LAST_INSERT_ID();

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(),
                error_message=CONCAT('Falló etl_base_detalle: ', v_err_msg)
            WHERE id = v_maestro_id;
            -- No LEAVE: el handler termina y el bloque externo continua
            -- v_ok quedara NULL, el UPDATE final marcara PARTIAL
        END;
        CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    -- -----------------------------------------------------------------------
    -- PASO 5: ETL base_ivr_clientes
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_diario', v_quarter, 'etl_base_clientes', v_table,
         'RUNNING', NOW(), 'evt_etl_diario');
    SET v_step_id = LAST_INSERT_ID();

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=v_err_msg
            WHERE id = v_step_id;
        END;
        CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
    END;

    -- -----------------------------------------------------------------------
    -- PASO 6: Validación post-load
    -- -----------------------------------------------------------------------
    CALL sp_etl_validar(v_quarter, v_ok, v_msg);

    -- -----------------------------------------------------------------------
    -- PASO 7: Estado final del maestro
    -- -----------------------------------------------------------------------
    UPDATE job_execution_log
    SET status     = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL'),
        end_time   = NOW(),
        error_message = IF(COALESCE(v_ok, FALSE), NULL, v_msg)
    WHERE id = v_maestro_id;

    END IF; -- END IF NOT v_abort

END$$


-- =============================================================================
-- sp_etl_historico
-- Wrapper para carga histórica de quarters pasados.
-- Corre sp_etl_base_detalle + sp_etl_base_clientes para un quarter específico.
-- Incluye pausa de 30s entre quarters para no saturar el servidor.
--
-- PARÁMETROS:
--   p_year        2025
--   p_quarter_num 1  (1=Q1, 2=Q2, 3=Q3, 4=Q4)
--
-- EJEMPLO:
--   CALL sp_etl_historico(2025, 1);  -- Q01_25
--   CALL sp_etl_historico(2025, 2);  -- Q02_25
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_etl_historico$$
CREATE PROCEDURE sp_etl_historico(
    IN p_year        INT,
    IN p_quarter_num INT
)
BEGIN
    DECLARE v_quarter  VARCHAR(10);
    DECLARE v_table    VARCHAR(100);
    DECLARE v_inicio   DATE;
    DECLARE v_fin      DATE;
    DECLARE v_step_id  INT;
    DECLARE v_ok       BOOLEAN;
    DECLARE v_msg      TEXT;

    -- Validación de parámetros
    IF p_quarter_num NOT IN (1, 2, 3, 4) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_etl_historico: p_quarter_num debe ser 1, 2, 3 o 4';
    END IF;

    -- Calcular nombres y fechas
    SET v_quarter = CONCAT('Q0', p_quarter_num, '_', RIGHT(p_year, 2));
    SET v_table   = CONCAT('tbl_historico_t', p_quarter_num, '_', p_year);
    SET v_inicio  = MAKEDATE(p_year, 1)
                    + INTERVAL (p_quarter_num - 1) * 3 MONTH;
    SET v_fin     = LAST_DAY(v_inicio + INTERVAL 2 MONTH);

    -- Registrar en log como job histórico
    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_historico', v_quarter, 'etl_base_detalle', v_table,
         'RUNNING', NOW(), 'manual');
    SET v_step_id = LAST_INSERT_ID();

    CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);

    -- Pausa entre pasos (no saturar el servidor en backfill)
    DO SLEEP(5);

    INSERT INTO job_execution_log
        (job_name, quarter_name, step_name, tabla_origen,
         status, start_time, ejecutado_por)
    VALUES
        ('etl_historico', v_quarter, 'etl_base_clientes', v_table,
         'RUNNING', NOW(), 'manual');
    SET v_step_id = LAST_INSERT_ID();

    CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);

    -- Validar resultado
    CALL sp_etl_validar(v_quarter, v_ok, v_msg);

    SELECT v_quarter AS quarter_procesado, v_ok AS ok, v_msg AS resultado;
END$$

DELIMITER ;


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
