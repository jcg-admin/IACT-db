-- =============================================================================
-- ivr_contar_dias_semana.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: ivr_es_dia_semana
-- Archivo fuente original: funciones_utilidad.sql
-- Despliegue:
--   mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < ivr_contar_dias_semana.sql
-- =============================================================================

DELIMITER $$

-- Para un quarter (90 días) el bucle es de ≤90 iteraciones — aceptable.
-- Para rangos multi-año considera optimización con fórmula matemática.
--
-- USO: ivr_contar_dias_semana('2025-01-01', '2025-03-31')
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS ivr_contar_dias_semana$$
CREATE FUNCTION ivr_contar_dias_semana(p_ini DATE, p_fin DATE)
RETURNS INT
DETERMINISTIC
COMMENT 'Cuenta dias de semana en rango [p_ini, p_fin] inclusive. O(n días).'
BEGIN
    DECLARE v_dias  INT     DEFAULT 0;
    DECLARE v_fecha DATE;

    IF p_ini IS NULL OR p_fin IS NULL OR p_ini > p_fin THEN
        RETURN 0;
    END IF;

    SET v_fecha = p_ini;
    WHILE v_fecha <= p_fin DO
        IF ivr_es_dia_semana(v_fecha) THEN
            SET v_dias = v_dias + 1;
        END IF;
        SET v_fecha = DATE_ADD(v_fecha, INTERVAL 1 DAY);
    END WHILE;

    RETURN v_dias;
END$$


-- -----------------------------------------------------------------------------
-- ivr_agregar_dias_semana

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ivr_contar_dias_semana('2025-01-01', '2025-01-31') AS esperado_23
     , ivr_contar_dias_semana('2025-04-01', '2025-06-30') AS esperado_65
     , ivr_contar_dias_semana('2025-07-01', '2025-09-30') AS esperado_66;
