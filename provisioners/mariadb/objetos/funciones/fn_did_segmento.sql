SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : fn_did_segmento.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : Ninguno — funcion de mapeo puro sin dependencias externas
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < fn_did_segmento.sql
    Notas           : DID 19028031=nacional_A / 19020001=nacional_B / 19020084=puebla
*********************************************************************************************/

-- DEFINICIÓN

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

-- VERIFICACIÓN

SELECT 
    fn_did_segmento('19028031') as esperado_nacional_A
    , fn_did_segmento('19020001') as esperado_nacional_B
    , fn_did_segmento('19020084') as esperado_puebla
    , fn_did_segmento('99999999') as esperado_desconocido
FROM DUAL;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
