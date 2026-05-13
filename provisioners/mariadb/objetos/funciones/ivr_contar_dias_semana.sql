SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/********************************************************************************************
    Script          : ivr_contar_dias_semana.sql
    Version         : 3.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : Ninguno — sin dependencias (v3.0.0 elimina la dependencia de ivr_es_dia_semana)
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < ivr_contar_dias_semana.sql
    Notas           : v3.0.0: formula O(1) sin WHILE — elimina ~18,900 iteraciones por llamada
                      a sp_rpt_centros_xsegmento con 300 filas (H-IACT-001).
                      v2.0.0: iteracion O(n) dia a dia con WHILE.
********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

DROP FUNCTION IF EXISTS ivr_contar_dias_semana$$
CREATE FUNCTION ivr_contar_dias_semana(p_ini DATE, p_fin DATE)
RETURNS INT
DETERMINISTIC
COMMENT 'Cuenta días L-V en [p_ini,p_fin] inclusive. O(1) — sin WHILE ni ivr_es_dia_semana.'
BEGIN
    -- Mapeo de DAYOFWEEK a posición L-V:
    --   MariaDB DAYOFWEEK: 1=Dom, 2=Lun, 3=Mar, 4=Mié, 5=Jue, 6=Vie, 7=Sáb
    --   v_pos: Lun=0, Mar=1, Mié=2, Jue=3, Vie=4, Sáb=5, Dom=6
    DECLARE v_N    INT;
    DECLARE v_w    INT;
    DECLARE v_rem  INT;
    DECLARE v_pos  INT;
    DECLARE v_wrem INT;

    IF p_ini IS NULL OR p_fin IS NULL OR p_ini > p_fin THEN
        RETURN 0;
    END IF;

    SET v_N    = DATEDIFF(p_fin, p_ini) + 1;
    SET v_w    = FLOOR(v_N / 7);
    SET v_rem  = v_N MOD 7;
    SET v_pos  = (DAYOFWEEK(p_ini) + 5) MOD 7;
    -- Días hábiles que quedan en la semana parcial de inicio (desde p_ini inclusive)
    SET v_wrem = GREATEST(0, 5 - v_pos);

    -- Semanas completas * 5
    -- + días hábiles en el fragmento de inicio (hasta Vie o hasta v_rem, lo que ocurra antes)
    -- + días hábiles que "desbordan" al Lunes siguiente si v_rem cruza el fin de semana
    RETURN v_w * 5
         + LEAST(v_rem, v_wrem)
         + GREATEST(0, v_rem + v_pos - 7);
END$$

DELIMITER ;

-- VERIFICACIÓN

SELECT
    ivr_contar_dias_semana('2025-01-01', '2025-03-31') AS esperado_64
    , ivr_contar_dias_semana('2025-04-01', '2025-06-30') AS esperado_65
    , ivr_contar_dias_semana('2025-07-01', '2025-09-30') AS esperado_66
    , ivr_contar_dias_semana('2025-01-01', '2025-01-31') AS esperado_23
    , ivr_contar_dias_semana('2025-01-11', '2025-01-11') AS esperado_0_sabado
    , ivr_contar_dias_semana('2025-01-12', '2025-01-12') AS esperado_0_domingo
FROM DUAL;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
