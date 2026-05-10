-- ====================================================================
-- Script          : Detalle Transfer × Menú × Opción v0.3.1 (CORREGIDO)
-- Original        : v0.3.1_q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION.sql
-- Correcciones    :
--   C-01 ALTO:    Separar nacional_A y nacional_B en columna segmento.
--                 Original colapsaba ambos como 'Nacional' perdiendo
--                 la distinción D-23 (nacional_A domina ~96%).
-- Sin cambios     : CASE NK90 correcto, CASE cMenu correcto,
--                   COALESCE opcion correcto, misma_linea / no_digito correctos.
-- ====================================================================

SET @Q1_nombre = 'Q01_25'; SET @Q2_nombre = 'Q02_25'; SET @Q3_nombre = 'Q03_25';
SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;

SET @total_t1 = (SELECT COUNT(*) FROM tbl_historico_t1_2025 WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB));
SET @total_t2 = (SELECT COUNT(*) FROM tbl_historico_t2_2025 WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB));
SET @total_t3 = (SELECT COUNT(*) FROM tbl_historico_t3_2025 WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB));

SELECT
    trimestre,
    DATE_FORMAT(dFecha,'%Y%m')                    AS fecha,
    -- C-01: separar nacional_A y nacional_B
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END                                            AS segmento,
    CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL
          OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$'     THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]'  THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10     THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10
            THEN LEFT(cDID_Centro_Transferencia,
                      LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END                                            AS centro_transferencia,
    CASE
        WHEN TRIM(cMenu) IS NULL OR TRIM(cMenu) = '' THEN 'SIN_MENU'
        WHEN cMenu REGEXP '^0+$'                     THEN 'CASO_ERROR_CEROS'
        WHEN cMenu REGEXP '^[0-9]{10}$'              THEN 'MENU_10_NUMEROS'
        WHEN cMenu REGEXP '^[0-9]{11}$'              THEN 'MENU_11_NUMEROS'
        ELSE cMenu
    END                                            AS menu,
    COALESCE(NULLIF(cOpcion,''), 'SIN_OPCION')     AS opcion,
    COUNT(*)                                       AS total_llamadas,
    ROUND(COUNT(*) * 100.0 / total_q, 7)           AS porcentaje,
    COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END)          AS misma_linea,
    COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado
                AND cTelefono_Digitado IS NOT NULL   THEN 1 END)               AS linea_diferente,
    COUNT(CASE WHEN cTelefono_Digitado IS NULL       THEN 1 END)               AS no_digito_telefono

FROM (
    SELECT @Q1_nombre AS trimestre, @total_t1 AS total_q,
           dFecha, cDID_800Transfer, cDID_Centro_Transferencia,
           cMenu, cOpcion, cTelefono_Origen, cTelefono_Digitado
    FROM tbl_historico_t1_2025
    WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB)

    UNION ALL

    SELECT @Q2_nombre, @total_t2,
           dFecha, cDID_800Transfer, cDID_Centro_Transferencia,
           cMenu, cOpcion, cTelefono_Origen, cTelefono_Digitado
    FROM tbl_historico_t2_2025
    WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB)

    UNION ALL

    SELECT @Q3_nombre, @total_t3,
           dFecha, cDID_800Transfer, cDID_Centro_Transferencia,
           cMenu, cOpcion, cTelefono_Origen, cTelefono_Digitado
    FROM tbl_historico_t3_2025
    WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB)
) datos

GROUP BY trimestre, fecha, segmento, centro_transferencia, menu, opcion
ORDER BY
    CASE trimestre
        WHEN @Q1_nombre THEN 1 WHEN @Q2_nombre THEN 2 WHEN @Q3_nombre THEN 3
    END,
    segmento, total_llamadas DESC, fecha ASC;
