-- ====================================================================
-- INFORMACIÓN DEL ENTORNO
-- ====================================================================

SELECT 'EJECUTADO EN:' as info;

SELECT 
    DATABASE() as 'Base de Datos'
    , USER() as 'Usuario'
    , @@version as 'Versión MySQL/MariaDB'
FROM DUAL;

SELECT NOW() as 'FECHA DE INICIO';

/*********************************************************************************************
     Script          : Análisis colgadas
     
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

-- Mostrar configuración
SELECT 
    'CONFIGURACIÓN DE VARIABLES' as seccion
    , @OPuebla
    , @ONacional 
    , @Q1_nombre
    , @Q1_inicio
    , @Q1_fin
    , @Q2_nombre
    , @Q2_inicio
    , @Q2_fin
    , @Q3_nombre
    , @Q3_inicio
    , @Q3_fin;

-- ====================================================================
-- ANÁLISIS: LLAMADAS COLGADAS
-- ====================================================================

SELECT 'EJECUTANDO ANÁLISIS: LLAMADAS COLGADAS' as proceso;

WITH todos_los_menu AS (
    SELECT DISTINCT cMenu
    FROM (
        SELECT cMenu FROM tbl_historico_t1_2025
        WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
        AND cDID_800Transfer IN (@OPuebla, @ONacional)

        UNION

        SELECT cMenu FROM tbl_historico_t2_2025
        WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
        AND cDID_800Transfer IN (@OPuebla, @ONacional)

        UNION

        SELECT cMenu FROM tbl_historico_t3_2025
        WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
        AND cDID_800Transfer IN (@OPuebla, @ONacional)
    ) categorias_totales
),
todos_los_trimestres AS (
    SELECT @Q1_nombre as trimestre
    UNION ALL
    SELECT @Q2_nombre
    UNION ALL
    SELECT @Q3_nombre
)
SELECT 
    t.trimestre,
    c.cMenu,
    CASE 
        -- Q1: ¿Existe esta menu en tbl_historico_t1_2025
        WHEN t.trimestre = @Q1_nombre AND EXISTS (
            SELECT 1 FROM tbl_historico_t1_2025 v1
            WHERE v1.cMenu = c.cMenu
            AND v1.dFecha >= @Q1_inicio AND v1.dFecha <= @Q1_fin
            AND v1.cDID_800Transfer IN (@OPuebla, @ONacional)
        ) THEN 'vacia'
        
        -- Q2: ¿Existe esta menu en tbl_historico_t2_2025?
        WHEN t.trimestre = @Q2_nombre AND EXISTS (
            SELECT 1 FROM tbl_historico_t2_2025 v2
            WHERE v2.cMenu = c.cMenu
            AND v2.dFecha >= @Q2_inicio AND v2.dFecha <= @Q2_fin
            AND v2.cDID_800Transfer IN (@OPuebla, @ONacional)
        ) THEN 'vacia'
        
        -- Q3: ¿Existe esta menu en tbl_historico_t3_2025?
        WHEN t.trimestre = @Q3_nombre AND EXISTS (
            SELECT 1 FROM tbl_historico_t3_2025 v3
            WHERE v3.cMenu = c.cMenu
            AND v3.dFecha >= @Q3_inicio AND v3.dFecha <= @Q3_fin
            AND v3.cDID_800Transfer IN (@OPuebla, @ONacional)
        ) THEN 'vacia'
        
        ELSE 'NO'
    END as estado
FROM todos_los_menu c
CROSS JOIN todos_los_trimestres t
ORDER BY 
    CASE t.trimestre
        WHEN @Q1_nombre THEN 1
        WHEN @Q2_nombre THEN 2
        WHEN @Q3_nombre THEN 3
    END,
    c.cMenu;

-- ====================================================================
-- FINALIZACIÓN
-- ====================================================================

SELECT '<<< ANÁLISIS CON EXISTS COMPLETADO >>>' as resultado;

SELECT 
    'PROCESO COMPLETADO' as evento,
    'EXISTS - SEMÁNTICA CLARA' as metodo_elegante,
    NOW() as timestamp_fin
FROM DUAL;