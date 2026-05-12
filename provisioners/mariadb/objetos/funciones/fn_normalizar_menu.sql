-- =============================================================================
-- fn_normalizar_menu.sql
-- Schema: ivr_legacy (MariaDB 10.11)
-- Version: 2.0.0
--
-- Prerequisito: Ninguno
-- Archivo fuente original: funciones_utilidad.sql
-- Despliegue:
--   mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < fn_normalizar_menu.sql
-- =============================================================================

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
DROP FUNCTION IF EXISTS fn_normalizar_menu$$
CREATE FUNCTION fn_normalizar_menu(p_menu VARCHAR(100))
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

-- =============================================================================
-- Verificacion
-- =============================================================================
SELECT fn_normalizar_menu(NULL)          AS esperado_VACIO
     , fn_normalizar_menu('')            AS esperado_VACIO
     , fn_normalizar_menu('sin cMenu')  AS esperado_VACIO
     , fn_normalizar_menu('COBRO')       AS esperado_COBRO;
