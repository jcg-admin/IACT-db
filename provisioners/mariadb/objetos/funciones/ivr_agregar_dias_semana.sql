-- =============================================================================
-- ivr_agregar_dias_semana.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: ivr_es_dia_semana
-- Archivo fuente original: funciones_utilidad.sql
-- Despliegue:
--   mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < ivr_agregar_dias_semana.sql
-- =============================================================================

DELIMITER $$

-- Retorna la fecha resultante de agregar N dias de semana a p_fecha.
-- Depende de ivr_es_dia_semana.
--
-- USO: ivr_agregar_dias_semana('2025-01-31', 3) → primer dia de semana 3 días después
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS ivr_agregar_dias_semana$$
CREATE FUNCTION ivr_agregar_dias_semana(p_fecha DATE, p_n INT)
RETURNS DATE
DETERMINISTIC
COMMENT 'Fecha + N dias de semana. Depende de ivr_es_dia_semana.'
BEGIN
    DECLARE v_resultado DATE;
    DECLARE v_contador  INT DEFAULT 0;

    IF p_fecha IS NULL OR p_n <= 0 THEN
        RETURN p_fecha;
    END IF;

    SET v_resultado = p_fecha;
    WHILE v_contador < p_n DO
        SET v_resultado = DATE_ADD(v_resultado, INTERVAL 1 DAY);
        IF ivr_es_dia_semana(v_resultado) THEN
            SET v_contador = v_contador + 1;
        END IF;
    END WHILE;

    RETURN v_resultado;
END$$

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ivr_agregar_dias_semana('2025-01-31', 1) AS esperado_2025_02_03
     , ivr_agregar_dias_semana('2025-01-31', 3) AS esperado_2025_02_05
     , ivr_agregar_dias_semana('2025-01-31', 5) AS esperado_2025_02_07;
