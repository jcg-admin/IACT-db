SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/********************************************************************************************
    Script          : ivr_agregar_dias_semana.sql
    Version         : 3.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : Ninguno — sin dependencias (v3.0.0 elimina la dependencia de ivr_es_dia_semana)
    Despliegue      : mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < ivr_agregar_dias_semana.sql
    Notas           : v3.0.0: formula O(1) sin WHILE (H-IACT-001). p_n<=0 retorna p_fecha.
                      Valores SLA estandar: 1, 3 y 5 dias habiles.
                      v2.0.0: iteracion O(n) dia a dia con WHILE.
********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

CREATE OR REPLACE FUNCTION ivr_agregar_dias_semana(p_fecha DATE, p_n INT)
RETURNS DATE
DETERMINISTIC
COMMENT 'Fecha + N dias hábiles L-V. O(1) — sin WHILE ni ivr_es_dia_semana.'
BEGIN
    -- v_pos: Lun=0, Mar=1, Mié=2, Jue=3, Vie=4, Sáb=5, Dom=6
    DECLARE v_pos     INT;
    DECLARE v_advance INT DEFAULT 0;
    DECLARE v_w       INT;
    DECLARE v_r       INT;
    DECLARE v_extra   INT;

    IF p_fecha IS NULL OR p_n <= 0 THEN
        RETURN p_fecha;
    END IF;

    SET v_pos = (DAYOFWEEK(p_fecha) + 5) MOD 7;

    -- Si p_fecha cae en fin de semana, avanzar al lunes siguiente.
    -- El lunes de llegada se cuenta como el primer día hábil: p_n decrece en 1.
    IF v_pos >= 5 THEN
        SET v_advance = 7 - v_pos;   -- Sáb→+2 días, Dom→+1 día
        SET p_n       = p_n - 1;     -- el lunes ya es el día hábil 1
        SET v_pos     = 0;           -- posición de inicio: Lunes
    END IF;

    SET v_w     = FLOOR(p_n / 5);
    SET v_r     = p_n MOD 5;
    -- Días calendario para los v_r días hábiles restantes.
    -- Si v_pos + v_r >= 5 cruzamos el fin de semana (Sáb+Dom = 2 días extra).
    SET v_extra = v_r + IF(v_r > 0 AND v_pos + v_r >= 5, 2, 0);

    RETURN DATE_ADD(
               DATE_ADD(p_fecha, INTERVAL v_advance DAY),
               INTERVAL 7 * v_w + v_extra DAY
           );
END$$

DELIMITER ;

-- VERIFICACIÓN

SELECT
    ivr_agregar_dias_semana('2025-01-31', 1) AS esperado_2025_02_03
    , ivr_agregar_dias_semana('2025-01-31', 3) AS esperado_2025_02_05
    , ivr_agregar_dias_semana('2025-01-31', 5) AS esperado_2025_02_07
    , ivr_agregar_dias_semana('2025-01-11', 1) AS esperado_2025_01_13_sab
    , ivr_agregar_dias_semana('2025-01-12', 1) AS esperado_2025_01_13_dom
FROM DUAL;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
