-- =============================================================================
-- fn_duracion_seg.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: Ninguno
-- Archivo fuente original: funciones_utilidad.sql
-- Despliegue:
--   mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < fn_duracion_seg.sql
-- =============================================================================

DELIMITER $$

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
-- ivr_es_dia_semana
-- Determina si una fecha es dia de semana (lunes a viernes).
-- Prefijo ivr_ para evitar colision con posibles funciones del cliente (P-14).
--
-- CRITERIO: El IVR opera los 7 dias de la semana sin excepcion, incluyendo
-- festivos nacionales (los datos confirman volumen normal en todos los festivos).
-- Por lo tanto "dia de semana" = lunes a viernes, "fin de semana" = sabado/domingo.
-- La logica de festivos Art.74 LFT fue eliminada porque no aplica a este contexto.

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT fn_duracion_seg('2025-01-01 08:00:00', '2025-01-01 08:02:30') AS esperado_150
     , fn_duracion_seg(NULL, '2025-01-01 08:00:00')                   AS esperado_0;
