-- ====================================================================
-- INFORMACIÓN DEL ENTORNO
-- ====================================================================

SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_fin
FROM DUAL;

/*********************************************************************************************
     Script          : Análisis LLamadas Menu
     
     Create          : AGOSTO/2025
     Engine          : MariaDB/MySQL
     
     Parámetros Variables:
     @OPuebla, @ONacional - Códigos de organización
     @Q1_inicio, @Q1_fin - Rango de fechas Q1 2025
     @Q2_inicio, @Q2_fin - Rango de fechas Q2 2025  
     @Q3_inicio, @Q3_fin - Rango de fechas Q3 2025
     
     Notas:
     
*********************************************************************************************/

-- ====================================================================
-- CONFIGURACIÓN DE VARIABLES
-- ====================================================================

SET @OPuebla = 19020084;
SET @ONacional = 19028031;
SET @ONacional02 = 1902001;

SET @Q1_nombre = 'Q01_25';
SET @Q1_inicio = '2025-01-01';
SET @Q1_fin = '2025-03-31';

SET @Q2_nombre = 'Q02_25';
SET @Q2_inicio = '2025-04-01';
SET @Q2_fin = '2025-06-30';

SET @Q3_nombre = 'Q03_25';
SET @Q3_inicio = '2025-07-01';
SET @Q3_fin = '2025-09-30';


-- ====================================================================
-- ANÁLISIS: LLAMADAS MENU
-- ====================================================================

SELECT 
    CASE 
        WHEN cDID_800Transfer = @OPuebla THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacional THEN 'Nacional'
    END as 'cDID',
    trimestre,
    CASE 
        WHEN cMenu = '' THEN 'VACIO'
        WHEN cMenu = 'sin cMenu' THEN 'VACIO'
        WHEN cMenu IS NULL THEN 'VACIO'
        WHEN TRIM(cMenu) = '' THEN 'VACIO'
        ELSE UPPER(TRIM(cMenu))
    END as cMenu,
    COUNT(*) as cantidad_registros
FROM (
    SELECT @Q1_nombre as trimestre
        , cDID_800Transfer
        , CASE WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu THEN 'telefono_cMenu' ELSE cMenu END AS cMenu
    FROM tbl_historico_t1_2025
    WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
    AND cDID_800Transfer IN (@OPuebla, @ONacional)

    UNION ALL

    SELECT @Q2_nombre as trimestre
        , cDID_800Transfer
        , CASE WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu THEN 'telefono_cMenu' ELSE cMenu END AS cMenu
    FROM tbl_historico_t2_2025
    WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
    AND cDID_800Transfer IN (@OPuebla, @ONacional)

    UNION ALL

    SELECT @Q3_nombre as trimestre
        , cDID_800Transfer
        , CASE WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu THEN 'telefono_cMenu' ELSE cMenu END AS cMenu
    FROM tbl_historico_t3_2025
    WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
    AND cDID_800Transfer IN (@OPuebla, @ONacional)
) datos_consolidados
GROUP BY cDID_800Transfer, trimestre, cMenu
ORDER BY 
    CASE WHEN cDID_800Transfer = @OPuebla THEN 1 ELSE 2 END,
    CASE trimestre
        WHEN @Q1_nombre THEN 1
        WHEN @Q2_nombre THEN 2
        WHEN @Q3_nombre THEN 3
    END,
    cantidad_registros DESC;

-- ====================================================================
-- FINALIZACIÓN
-- ====================================================================

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;