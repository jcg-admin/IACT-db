-- ====================================================================
-- Script          : Llamadas Menú v2 REPTRIM121 (CORREGIDO)
-- Original        : v2_q_REPTRIM121_LLAMADAS_MENU.sql
-- Correcciones    :
--   C-01 MEDIO:   cMenu = NULL → cMenu IS NULL dentro del CASE.
--                 En SQL, x = NULL siempre es UNKNOWN (nunca TRUE),
--                 por lo que la rama 'VACIO' nunca se activaba para NULL.
--   C-02 MENOR:   Agregar paréntesis en la condición del CASE para
--                 evitar ambigüedad con el OR entre condiciones.
--   C-03 MENOR:   Separar nacional_A / nacional_B (consistencia D-23).
-- Sin cambios     : Lógica telefono_cMenu correcta, UPPER(TRIM(cMenu)) correcto.
-- ====================================================================

SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;

SET @Q1_nombre  = 'Q01_25'; SET @Q1_inicio = '2025-01-01'; SET @Q1_fin = '2025-03-31';
SET @Q2_nombre  = 'Q02_25'; SET @Q2_inicio = '2025-04-01'; SET @Q2_fin = '2025-06-30';
SET @Q3_nombre  = 'Q03_25'; SET @Q3_inicio = '2025-07-01'; SET @Q3_fin = '2025-09-30';

SELECT
    -- C-03: separar segmentos
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END          AS segmento,
    trimestre,
    cMenu,
    COUNT(*)     AS cantidad_registros
FROM (
    SELECT @Q1_nombre AS trimestre, cDID_800Transfer,
        CASE
            -- telefono_cMenu: el cMenu es igual al teléfono de origen Y al digitado
            WHEN (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)
              OR cMenu REGEXP '^[0-9]+$'        THEN 'telefono_cMenu'
            -- C-01: cMenu IS NULL (era "cMenu = NULL" — nunca TRUE)
            -- C-02: paréntesis explícitos para cada condición
            WHEN (cMenu IS NULL)
              OR (TRIM(cMenu) = '')
              OR (cMenu = 'sin cMenu')           THEN 'VACIO'
            ELSE UPPER(TRIM(cMenu))
        END AS cMenu
    FROM tbl_historico_t1_2025
    WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
      AND cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB)

    UNION ALL

    SELECT @Q2_nombre, cDID_800Transfer,
        CASE
            WHEN (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)
              OR cMenu REGEXP '^[0-9]+$'        THEN 'telefono_cMenu'
            WHEN (cMenu IS NULL)
              OR (TRIM(cMenu) = '')
              OR (cMenu = 'sin cMenu')           THEN 'VACIO'
            ELSE UPPER(TRIM(cMenu))
        END AS cMenu
    FROM tbl_historico_t2_2025
    WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
      AND cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB)

    UNION ALL

    SELECT @Q3_nombre, cDID_800Transfer,
        CASE
            WHEN (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)
              OR cMenu REGEXP '^[0-9]+$'        THEN 'telefono_cMenu'
            WHEN (cMenu IS NULL)
              OR (TRIM(cMenu) = '')
              OR (cMenu = 'sin cMenu')           THEN 'VACIO'
            ELSE UPPER(TRIM(cMenu))
        END AS cMenu
    FROM tbl_historico_t3_2025
    WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
      AND cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB)
) datos_consolidados

GROUP BY cDID_800Transfer, trimestre, cMenu
ORDER BY
    CASE trimestre
        WHEN @Q1_nombre THEN 1 WHEN @Q2_nombre THEN 2 WHEN @Q3_nombre THEN 3
    END,
    segmento, cantidad_registros DESC;
