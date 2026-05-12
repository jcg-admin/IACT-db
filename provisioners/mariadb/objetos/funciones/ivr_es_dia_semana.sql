-- =============================================================================
-- ivr_es_dia_semana.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: Ninguno
-- Archivo fuente original: funciones_utilidad.sql
-- Despliegue:
--   mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < ivr_es_dia_semana.sql
-- =============================================================================

DELIMITER $$

--
-- USO: ivr_es_dia_semana('2025-03-21')  -- TRUE (viernes, dia de semana)
--      ivr_es_dia_semana('2025-01-04')  -- FALSE (sabado)
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS ivr_es_dia_semana$$
CREATE FUNCTION ivr_es_dia_semana(p_fecha DATE)
RETURNS BOOLEAN
DETERMINISTIC
COMMENT 'TRUE si p_fecha es lunes a viernes. El IVR opera 7 dias — festivos no aplican.'
BEGIN
    -- 1=Domingo, 7=Sabado en MySQL DAYOFWEEK()
    RETURN DAYOFWEEK(p_fecha) NOT IN (1, 7);
END$$


-- -----------------------------------------------------------------------------
-- ivr_contar_dias_semana
-- Cuenta los dias de semana entre dos fechas (ambas inclusive).
-- Depende de ivr_es_dia_semana.
--
-- COMPLEJIDAD: O(n) donde n = días en el rango.

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT ivr_es_dia_semana('2025-01-06') AS lunes_esperado_1
     , ivr_es_dia_semana('2025-01-04') AS sabado_esperado_0
     , ivr_es_dia_semana('2025-01-05') AS domingo_esperado_0;
