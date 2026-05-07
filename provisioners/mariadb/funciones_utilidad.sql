-- =============================================================================
-- funciones_utilidad.sql
-- Funciones de utilidad para el pipeline ETL IVR (IACT)
-- Versión: 2.0.0
-- Motor: MariaDB 10.1.48+ (InnoDB, utf8mb4)
--
-- PREREQUISITO de todos los SPs del pipeline.
-- Ejecutar antes que schema_base_ivr.sql y sp_etl_pipeline.sql.
--
-- ORDEN DE CREACIÓN (dependencias):
--   1. fn_did_segmento           — sin dependencias
--   2. fn_normalizar_menu        — sin dependencias
--   3. fn_normalizar_centro      — sin dependencias
--   4. fn_duracion_seg           — sin dependencias (maneja G-29)
--   5. ivr_es_dia_habil          — sin dependencias (festivos MX)
--   6. ivr_contar_dias_habiles   — depende de ivr_es_dia_habil
--   7. ivr_agregar_dias_habiles  — depende de ivr_es_dia_habil
-- =============================================================================

DELIMITER $$

-- -----------------------------------------------------------------------------
-- fn_did_segmento
-- Convierte el DID de entrada numérico al nombre de segmento.
-- Fuente canónica: MAPEO-DID-SEGMENTOS.md
--
-- USO: fn_did_segmento(cDID_800Transfer)
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_did_segmento$$
CREATE FUNCTION fn_did_segmento(p_did VARCHAR(20))
RETURNS VARCHAR(20)
DETERMINISTIC
COMMENT 'Convierte DID numérico a etiqueta de segmento. Ver MAPEO-DID-SEGMENTOS.md'
BEGIN
    RETURN CASE p_did
        WHEN '19028031' THEN 'nacional_A'
        WHEN '19020001' THEN 'nacional_B'
        WHEN '19020084' THEN 'puebla'
        ELSE                 'desconocido'
    END;
END$$


-- -----------------------------------------------------------------------------
-- fn_normalizar_menu
-- Normaliza cMenu: convierte NULL/vacío/'sin cMenu' al sentinel 'VACIO'.
-- El resto de valores pasan sin modificación (mixed case — los SPs de reporte
-- aplican UPPER() para presentación; el ETL almacena el valor raw).
-- Ref: D-24, REPORTE-PROM-LLAMADAS.md H-1
--
-- USO: fn_normalizar_menu(cMenu)
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_normalizar_menu$$
CREATE FUNCTION fn_normalizar_menu(p_menu VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
COMMENT 'NULL/vacío/sin cMenu → VACIO. Demás valores: pass-through.'
BEGIN
    IF p_menu IS NULL OR TRIM(p_menu) = '' OR p_menu = 'sin cMenu' THEN
        RETURN 'VACIO';
    END IF;
    RETURN p_menu;
END$$


-- -----------------------------------------------------------------------------
-- fn_normalizar_centro
-- Normaliza cDID_Centro_Transferencia al VDN limpio o a un sentinel.
-- Implementa la lógica NK90 (BR-ROUTING-001) y los 5 sentinels canónicos.
--
-- ORDEN CRÍTICO — no alterar:
--   1. CASO_NULL           (NULL/vacío — antes de cualquier otra comparación)
--   2. CLIENTE_COLGO       (string literal — antes de NK90, len('cliente_colgo')=13>10)
--   3. CASO_ERROR_CEROS    (solo ceros)
--   4. ERROR_CARACTER_INICIAL (char no numérico)
--   5. NK90 len>10         (VDN + teléfono concatenados — extrae solo el VDN)
--   6. Valor limpio        (VDN de longitud normal)
--
-- Ref: BR-ROUTING-001, TBL-HISTORICO-ANOMALIAS.md, MAPEO-DID-SEGMENTOS.md
--
-- USO: fn_normalizar_centro(cDID_Centro_Transferencia)
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_normalizar_centro$$
CREATE FUNCTION fn_normalizar_centro(p_centro VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
COMMENT 'Normaliza cDID_Centro_Transferencia: NK90, sentinels, VDN limpio.'
BEGIN
    -- 1. CASO_NULL
    IF p_centro IS NULL OR TRIM(p_centro) = '' THEN
        RETURN 'CASO_NULL';
    END IF;

    -- 2. CLIENTE_COLGO (debe ir antes de la regla len>10)
    IF p_centro = 'cliente_colgo' THEN
        RETURN 'CLIENTE_COLGO';
    END IF;

    -- 3. CASO_ERROR_CEROS (Puebla Q02+ — P-22)
    IF p_centro REGEXP '^0+$' THEN
        RETURN 'CASO_ERROR_CEROS';
    END IF;

    -- 4. ERROR_CARACTER_INICIAL (0.05% del total)
    IF p_centro REGEXP '^[^0-9]' THEN
        RETURN 'ERROR_CARACTER_INICIAL';
    END IF;

    -- 5. NK90: VDN + cTelefono_Digitado concatenados
    --    len_17 = VDN 7dig + tel 10dig  (5.33% real Q1)
    --    len_16 = VDN 6dig + tel 10dig  (0.34% real Q1)
    --    len_18+ = VDN 8+dig + tel 10dig (variante rara)
    IF LENGTH(p_centro) > 10 THEN
        RETURN LEFT(p_centro, LENGTH(p_centro) - 10);
    END IF;

    -- 6. VDN de longitud normal (dominante: 82.18% son 8 dígitos en Q1)
    RETURN p_centro;
END$$


-- -----------------------------------------------------------------------------
-- fn_duracion_seg
-- Calcula la duración de una llamada en segundos.
-- Maneja el bug G-29: 38.8% de registros tienen dHoraInicio > dHoraFin.
-- La corrección usa ABS() para siempre retornar un valor positivo.
--
-- LIMITACIÓN CONOCIDA (documentada en TBL-HISTORICO-ANOMALIAS.md):
--   Llamadas que cruzan medianoche producen resultado incorrecto.
--   23:50 → 00:05 daría 23h45m en lugar de 15min.
--   Impacto estimado: < 0.1% de registros.
--
-- USO: fn_duracion_seg(dHoraInicio, dHoraFin)
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_duracion_seg$$
CREATE FUNCTION fn_duracion_seg(p_ini DATETIME, p_fin DATETIME)
RETURNS INT
DETERMINISTIC
COMMENT 'Duración en segundos. Maneja G-29 (ini>fin en 38.8% de registros).'
BEGIN
    IF p_ini IS NULL OR p_fin IS NULL THEN
        RETURN 0;
    END IF;
    RETURN ABS(
        TIME_TO_SEC(TIME(p_fin)) - TIME_TO_SEC(TIME(p_ini))
    );
END$$


-- -----------------------------------------------------------------------------
-- ivr_es_dia_habil
-- Determina si una fecha es dia de semana (lunes a viernes).
-- Prefijo ivr_ para evitar colision con posibles funciones del cliente (P-14).
--
-- CRITERIO: El IVR opera los 7 dias de la semana sin excepcion, incluyendo
-- festivos nacionales (los datos confirman volumen normal en todos los festivos).
-- Por lo tanto "dia habil" = lunes a viernes, "fin de semana" = sabado/domingo.
-- La logica de festivos Art.74 LFT fue eliminada porque no aplica a este contexto.
--
-- USO: ivr_es_dia_habil('2025-03-21')  -- TRUE (viernes, dia de semana)
--      ivr_es_dia_habil('2025-01-04')  -- FALSE (sabado)
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS ivr_es_dia_habil$$
CREATE FUNCTION ivr_es_dia_habil(p_fecha DATE)
RETURNS BOOLEAN
DETERMINISTIC
COMMENT 'TRUE si p_fecha es lunes a viernes. El IVR opera 7 dias — festivos no aplican.'
BEGIN
    -- 1=Domingo, 7=Sabado en MySQL DAYOFWEEK()
    RETURN DAYOFWEEK(p_fecha) NOT IN (1, 7);
END$$


-- -----------------------------------------------------------------------------
-- ivr_contar_dias_habiles
-- Cuenta los días hábiles entre dos fechas (ambas inclusive).
-- Depende de ivr_es_dia_habil.
--
-- COMPLEJIDAD: O(n) donde n = días en el rango.
-- Para un quarter (90 días) el bucle es de ≤90 iteraciones — aceptable.
-- Para rangos multi-año considera optimización con fórmula matemática.
--
-- USO: ivr_contar_dias_habiles('2025-01-01', '2025-03-31')
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS ivr_contar_dias_habiles$$
CREATE FUNCTION ivr_contar_dias_habiles(p_ini DATE, p_fin DATE)
RETURNS INT
DETERMINISTIC
COMMENT 'Cuenta días hábiles en rango [p_ini, p_fin] inclusive. O(n días).'
BEGIN
    DECLARE v_dias  INT     DEFAULT 0;
    DECLARE v_fecha DATE;

    IF p_ini IS NULL OR p_fin IS NULL OR p_ini > p_fin THEN
        RETURN 0;
    END IF;

    SET v_fecha = p_ini;
    WHILE v_fecha <= p_fin DO
        IF ivr_es_dia_habil(v_fecha) THEN
            SET v_dias = v_dias + 1;
        END IF;
        SET v_fecha = DATE_ADD(v_fecha, INTERVAL 1 DAY);
    END WHILE;

    RETURN v_dias;
END$$


-- -----------------------------------------------------------------------------
-- ivr_agregar_dias_habiles
-- Retorna la fecha resultante de agregar N días hábiles a p_fecha.
-- Depende de ivr_es_dia_habil.
--
-- USO: ivr_agregar_dias_habiles('2025-01-31', 3) → primer día hábil 3 días después
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS ivr_agregar_dias_habiles$$
CREATE FUNCTION ivr_agregar_dias_habiles(p_fecha DATE, p_n INT)
RETURNS DATE
DETERMINISTIC
COMMENT 'Fecha + N días hábiles. Depende de ivr_es_dia_habil.'
BEGIN
    DECLARE v_resultado DATE;
    DECLARE v_contador  INT DEFAULT 0;

    IF p_fecha IS NULL OR p_n <= 0 THEN
        RETURN p_fecha;
    END IF;

    SET v_resultado = p_fecha;
    WHILE v_contador < p_n DO
        SET v_resultado = DATE_ADD(v_resultado, INTERVAL 1 DAY);
        IF ivr_es_dia_habil(v_resultado) THEN
            SET v_contador = v_contador + 1;
        END IF;
    END WHILE;

    RETURN v_resultado;
END$$

DELIMITER ;

-- =============================================================================
-- VERIFICACIÓN
-- =============================================================================
SELECT 'fn_did_segmento'         AS funcion, fn_did_segmento('19028031')               AS resultado UNION ALL
SELECT 'fn_did_segmento_b',                  fn_did_segmento('19020001')                            UNION ALL
SELECT 'fn_normalizar_menu_null',            fn_normalizar_menu(NULL)                               UNION ALL
SELECT 'fn_normalizar_menu_vacio',           fn_normalizar_menu('')                                 UNION ALL
SELECT 'fn_normalizar_menu_ok',              fn_normalizar_menu('RES-FallaInternet')                UNION ALL
SELECT 'fn_normalizar_centro_null',          fn_normalizar_centro(NULL)                             UNION ALL
SELECT 'fn_normalizar_centro_cc',            fn_normalizar_centro('cliente_colgo')                  UNION ALL
SELECT 'fn_normalizar_centro_nk90',          fn_normalizar_centro('190100008190983030')             UNION ALL
SELECT 'fn_normalizar_centro_vdn',           fn_normalizar_centro('10828091')                       UNION ALL
SELECT 'fn_duracion_seg_normal',             fn_duracion_seg('2025-01-15 14:00:00','2025-01-15 14:05:30') UNION ALL
SELECT 'fn_duracion_seg_g29',               fn_duracion_seg('2025-01-15 14:35:00','2025-01-15 13:58:00') UNION ALL
SELECT 'ivr_es_dia_habil_lunes',            ivr_es_dia_habil('2025-01-06')                         UNION ALL
SELECT 'ivr_es_dia_habil_sabado',           ivr_es_dia_habil('2025-01-04')                         UNION ALL
SELECT 'ivr_es_dia_habil_1enero',           ivr_es_dia_habil('2025-01-01')                         UNION ALL
SELECT 'ivr_es_dia_habil_mayo1',            ivr_es_dia_habil('2025-05-01')                         UNION ALL
SELECT 'ivr_contar_dias_habiles_enero',     ivr_contar_dias_habiles('2025-01-01','2025-01-31')      UNION ALL
SELECT 'ivr_contar_dias_habiles_q2',        ivr_contar_dias_habiles('2025-04-01','2025-06-30')      UNION ALL
SELECT 'ivr_contar_dias_habiles_q3',        ivr_contar_dias_habiles('2025-07-01','2025-09-30')      UNION ALL
SELECT 'ivr_agregar_dias_habiles',          ivr_agregar_dias_habiles('2025-01-31', 3);
