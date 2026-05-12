SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : ivr_es_dia_semana.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : Ninguno — predicado puro sin dependencias
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < ivr_es_dia_semana.sql
    Notas           : DAYOFWEEK NOT IN (1,7). Festivos NO excluidos — IVR opera 7 dias (H-F1-002).
*********************************************************************************************/

-- DEFINICIÓN

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

-- VERIFICACIÓN

SELECT 
    ivr_es_dia_semana('2025-01-06') as lunes_esperado_1
    , ivr_es_dia_semana('2025-01-04') as sabado_esperado_0
    , ivr_es_dia_semana('2025-01-05') as domingo_esperado_0
FROM DUAL;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
