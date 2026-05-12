-- =============================================================================
-- fn_did_segmento.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: Ninguno
-- Archivo fuente original: funciones_utilidad.sql
-- Despliegue:
--   mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < fn_did_segmento.sql
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

DELIMITER ;

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT fn_did_segmento('19028031') AS esperado_nacional_A
     , fn_did_segmento('19020001') AS esperado_nacional_B
     , fn_did_segmento('19020084') AS esperado_puebla
     , fn_did_segmento('99999999') AS esperado_desconocido;
