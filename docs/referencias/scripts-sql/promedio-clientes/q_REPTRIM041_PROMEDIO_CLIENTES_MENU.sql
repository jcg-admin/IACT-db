-- ====================================================================
-- INFORMACIÓN DEL ENTORNO
-- ====================================================================

SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
     Script          : Análisis - Promedio de Clientes por menu
     
     Create          : AGOSTO/2025
     Engine          : MariaDB/MySQL
     
     Parámetros Variables:
     @OPuebla, @ONacional - Códigos de cDID
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
-- ANÁLISIS: PROMEDIO DE CLIENTES POR MENU
-- ====================================================================


SELECT
    trimestre
    , cDID_800Transfer
    , cMenu
    , FORMAT(AVG(clientes_por_trimestre), 2) as promedio_clientes
    , MIN(clientes_por_trimestre) as min_clientes
    , MAX(clientes_por_trimestre) as max_clientes
    , COUNT(*) as trimestres_con_datos
FROM (
    SELECT 
        trimestre
        , cDID_800Transfer
        , cMenu
        , COUNT(DISTINCT cTelefono_Digitado) as clientes_por_trimestre
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
    ) datos
    GROUP BY cDID_800Transfer, cMenu, trimestre
) clientes_menu_trimestre
GROUP BY cMenu, cDID_800Transfer
ORDER BY promedio_clientes DESC;

-- ====================================================================
-- FINALIZACIÓN
-- ====================================================================

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;