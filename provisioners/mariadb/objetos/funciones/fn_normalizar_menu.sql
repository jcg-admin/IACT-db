SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : fn_normalizar_menu.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : Ninguno — normalizacion de campo cMenu sin dependencias
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < fn_normalizar_menu.sql
    Notas           : NULL / vacio / 'sin cMenu' → 'VACIO'. Resto pasa sin modificacion (mixed case).
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$


-- -----------------------------------------------------------------------------
-- fn_normalizar_menu
-- Normaliza cMenu: convierte NULL/vacío/'sin cMenu' al sentinel 'VACIO'.
-- El resto de valores pasan sin modificación (mixed case — los SPs de reporte
-- aplican UPPER() para presentación; el ETL almacena el valor raw).
-- Ref: D-24, REPORTE-PROM-LLAMADAS.md H-1
--
-- USO: fn_normalizar_menu(cMenu)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_normalizar_menu(p_menu VARCHAR(100))
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

DELIMITER ;

-- VERIFICACIÓN

SELECT 
    fn_normalizar_menu(NULL)         as esperado_VACIO
    , fn_normalizar_menu('')         as esperado_VACIO
    , fn_normalizar_menu('sin cMenu') as esperado_VACIO
    , fn_normalizar_menu('COBRO')    as esperado_COBRO
FROM DUAL;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
