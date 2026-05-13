SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : fn_normalizar_centro.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : Ninguno — normalizacion de cDID_Centro_Transferencia sin dependencias
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < fn_normalizar_centro.sql
    Notas           : Sentinels: CASO_NULL / CLIENTE_COLGO / CASO_ERROR_CEROS / ERROR_CARACTER_INICIAL. Recorta sufijos > 10 chars.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

--   3. CASO_ERROR_CEROS    (solo ceros)
--   4. ERROR_CARACTER_INICIAL (char no numérico)
--   5. NK90 len>10         (VDN + teléfono concatenados — extrae solo el VDN)
--   6. Valor limpio        (VDN de longitud normal)
--
-- Ref: BR-ROUTING-001, TBL-HISTORICO-ANOMALIAS.md, MAPEO-DID-SEGMENTOS.md
--
-- USO: fn_normalizar_centro(cDID_Centro_Transferencia)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_normalizar_centro(p_centro VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
COMMENT 'Normaliza cDID_Centro_Transferencia: NK90, sentinels, VDN limpio.'
BEGIN
    -- 1. CASO_NULL
    IF p_centro IS NULL OR TRIM(p_centro) = '' THEN
        RETURN 'CASO_NULL';
    END IF;

    -- 2. CLIENTE_COLGO (debe ir antes de la regla len>10)
    IF p_centro = 'cliente_colgo' THEN
        RETURN 'CLIENTE_COLGO';
    END IF;

    -- 3. CASO_ERROR_CEROS (Puebla Q02+ — P-22)
    IF p_centro REGEXP '^0+$' THEN
        RETURN 'CASO_ERROR_CEROS';
    END IF;

    -- 4. ERROR_CARACTER_INICIAL (0.05% del total)
    IF p_centro REGEXP '^[^0-9]' THEN
        RETURN 'ERROR_CARACTER_INICIAL';
    END IF;

    -- 5. NK90: VDN + cTelefono_Digitado concatenados
    --    len_17 = VDN 7dig + tel 10dig  (5.33% real Q1)
    --    len_16 = VDN 6dig + tel 10dig  (0.34% real Q1)
    --    len_18+ = VDN 8+dig + tel 10dig (variante rara)
    IF LENGTH(p_centro) > 10 THEN
        RETURN LEFT(p_centro, LENGTH(p_centro) - 10);
    END IF;

    -- 6. VDN de longitud normal (dominante: 82.18% son 8 dígitos en Q1)
    RETURN p_centro;
END$$


-- -----------------------------------------------------------------------------
-- fn_duracion_seg
-- Calcula la duración de una llamada en segundos.
-- Maneja el bug G-29: 38.8% de registros tienen dHoraInicio > dHoraFin.
-- La corrección usa ABS() para siempre retornar un valor positivo.
--
-- LIMITACIÓN CONOCIDA (documentada en TBL-HISTORICO-ANOMALIAS.md):
--   Llamadas que cruzan medianoche producen resultado incorrecto.

DELIMITER ;

-- VERIFICACIÓN

SELECT 
    fn_normalizar_centro(NULL)            as esperado_CASO_NULL
    , fn_normalizar_centro('cliente_colgo') as esperado_CLIENTE_COLGO
    , fn_normalizar_centro('0000')        as esperado_CASO_ERROR_CEROS
    , fn_normalizar_centro('X12345')      as esperado_ERROR_CARACTER_INICIAL
    , fn_normalizar_centro('12345')       as esperado_12345
FROM DUAL;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
