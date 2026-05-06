SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : Análisis - detallado de Transfer, Menu y Opcion
    Create          : SEPTEMBER/2025
    Engine          : MariaDB/MySQL
    Notas:     
*********************************************************************************************/

-- CONFIGURACIÓN DE VARIABLES
SET @Q1_nombre = 'Q01_25';
SET @Q2_nombre = 'Q02_25';
SET @Q3_nombre = 'Q03_25';

SET @OPuebla = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;

-- ANÁLISIS
SET @total_llamadas_t1 = (
    SELECT COUNT(*) FROM tbl_historico_t1_2025 WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
);

-- Calcular factor de corrección en una subconsulta
SET @factor_correccion_t1 = (
    SELECT 100.0 / SUM(porcentaje)
    FROM (
        SELECT ROUND(COUNT(*) * 100.0 / @total_llamadas_t1, 7) AS porcentaje
        FROM tbl_historico_t1_2025
        WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
        GROUP BY 
            CASE
                WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
                WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
                WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
                WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
                WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
                WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
                ELSE 'FORMATO_ESPECIAL'
            END
            , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU')
            , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION')
    ) AS subtotal
);


SET @total_llamadas_t2 = (
    SELECT COUNT(*) FROM tbl_historico_t2_2025 WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
);

SET @factor_correccion_t2 = (
    SELECT 100.0 / SUM(porcentaje)
    FROM (
        SELECT ROUND(COUNT(*) * 100.0 / @total_llamadas_t2, 7) AS porcentaje
        FROM tbl_historico_t2_2025
        WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
        GROUP BY 
            CASE
                WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
                WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
                WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
                WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
                WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
                WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
                ELSE 'FORMATO_ESPECIAL'
            END
            , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU')
            , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION')
    ) AS subtotal
);

SET @total_llamadas_t3 = (
    SELECT COUNT(*) FROM tbl_historico_t3_2025 WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
);

-- Calcular factor de corrección en una subconsulta
SET @factor_correccion_t3 = (
    SELECT 100.0 / SUM(porcentaje)
    FROM (
        SELECT ROUND(COUNT(*) * 100.0 / @total_llamadas_t3, 7) AS porcentaje
        FROM tbl_historico_t3_2025
        WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
        GROUP BY 
            CASE
                WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
                WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
                WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
                WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
                WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
                WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
                ELSE 'FORMATO_ESPECIAL'
            END
            , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU')
            , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION')
    ) AS subtotal
);

-- Consulta principal
SELECT 
    @Q1_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END as cDID_800Transfer
    , CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END AS tipo_caso
    , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU') AS cMenu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) AS total_llamadas
    , ROUND(COUNT(*) * 100.0 / @total_llamadas_t1 * @factor_correccion_t1, 7) AS porcentaje_ajustado
FROM tbl_historico_t1_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY tipo_caso, cMenu, cOpcion

UNION ALL

-- Consulta principal
SELECT 
    @Q2_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END as cDID_800Transfer
    , CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END AS tipo_caso
    , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU') AS cMenu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) AS total_llamadas
    , ROUND(COUNT(*) * 100.0 / @total_llamadas_t2 * @factor_correccion_t2, 7) AS porcentaje_ajustado
FROM tbl_historico_t2_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY tipo_caso, cMenu, cOpcion

UNION ALL

-- Consulta principal
SELECT 
    @Q3_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END as cDID_800Transfer
    , CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END AS tipo_caso
    , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU') AS cMenu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) AS total_llamadas
    , ROUND(COUNT(*) * 100.0 / @total_llamadas_t3 * @factor_correccion_t3, 7) AS porcentaje_ajustado
FROM tbl_historico_t3_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY tipo_caso, cMenu, cOpcion
ORDER BY 
    CASE trimestre
        WHEN @Q1_nombre THEN 1
        WHEN @Q2_nombre THEN 2
        WHEN @Q3_nombre THEN 3
    END,
    cDID_800Transfer,
    total_llamadas DESC;

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;