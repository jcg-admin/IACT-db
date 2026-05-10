-- ====================================================================
-- INFORMACIÓN DEL ENTORNO
-- ====================================================================

SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
     Script          : Análisis - Promedio de Clientes unicos
     
     Create          : AGOSTO/2025
     Engine          : MariaDB/MySQL
     
     Parámetros Variables:
     @OPuebla, @ONacional - Códigos cDID
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
-- ANÁLISIS: PROMEDIO DE CLIENTES UNICOS
-- ====================================================================

SELECT 
    trimestre
    , CASE 
        WHEN cDID_800Transfer = @OPuebla THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacional THEN 'Nacional'
    END as 'cDID'
    , cMenu
    , ROUND(AVG(clientes_unicos), 2) as promedio_clientes
FROM (
    SELECT 
        cDID_800Transfer
        , cMenu
        , trimestre
        , COUNT(*) as clientes_unicos
    FROM (
        -- Se eliminan duplicados con DISTINCT (aplicado solo una vez)
        SELECT DISTINCT 
            cDID_800Transfer
            , cMenu
            , trimestre
            , cTelefono_Digitado
        FROM (
            SELECT 
                @Q1_nombre as trimestre
                , cDID_800Transfer
                , CASE WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu THEN 'telefono_cMenu' ELSE cMenu END AS cMenu
                , cTelefono_Digitado
            FROM tbl_historico_t1_2025
            WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
            AND cDID_800Transfer IN (@OPuebla, @ONacional)

            UNION ALL

            SELECT 
                @Q2_nombre as trimestre
                , cDID_800Transfer
                , CASE WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu THEN 'telefono_cMenu' ELSE cMenu END AS cMenu
                , cTelefono_Digitado
            FROM tbl_historico_t2_2025
            WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
            AND cDID_800Transfer IN (@OPuebla, @ONacional)

            UNION ALL

            SELECT 
                @Q3_nombre as trimestre
                , cDID_800Transfer
                , CASE WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu THEN 'telefono_cMenu' ELSE cMenu END AS cMenu
                , cTelefono_Digitado
            FROM tbl_historico_t3_2025
            WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
            AND cDID_800Transfer IN (@OPuebla, @ONacional)
        ) datos_consolidados
    ) clientes_deduplicados
    GROUP BY cDID_800Transfer, cMenu, trimestre
) conteos_por_trimestre
GROUP BY trimestre, cDID_800Transfer, cMenu
ORDER BY 
    trimestre,
    CASE WHEN cDID_800Transfer = @OPuebla THEN 1 ELSE 2 END,
    promedio_clientes DESC;

-- ====================================================================
-- FINALIZACIÓN
-- ====================================================================

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;