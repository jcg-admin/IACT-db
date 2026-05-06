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
SET @total_llamadas_t1 = (SELECT COUNT(*) FROM tbl_historico_t1_2025 WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB));
SET @total_llamadas_t2 = (SELECT COUNT(*) FROM tbl_historico_t2_2025 WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB));
SET @total_llamadas_t3 = (SELECT COUNT(*) FROM tbl_historico_t3_2025 WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB));

-- Consulta principal
SELECT 
    @Q1_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END AS cDID_800
    , CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END AS tipo_caso
    , CASE
        WHEN TRIM(cMenu) IS NULL OR TRIM(cMenu) = '' THEN 'SIN_MENU'
        WHEN cMenu REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cMenu REGEXP '^[0-9]{10}$' THEN 'MENU_10_NUMEROS'
        WHEN cMenu REGEXP '^[0-9]{11}$' THEN 'MENU_11_NUMEROS'
        ELSE cMenu
    END AS menu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) as total_llamadas
    , ROUND((COUNT(*) * 100.0 / @total_llamadas_t1), 7) AS porcentaje
    , COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END) as misma_línea
    , COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado AND cTelefono_Digitado IS NOT NULL THEN 1 END) as línea_diferente
    , COUNT(CASE WHEN cTelefono_Digitado IS NULL THEN 1 END) as no_digito_telefono
FROM tbl_historico_t1_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY cDID_800, tipo_caso, menu, cOpcion

UNION ALL

SELECT 
    @Q2_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END AS cDID_800
    , CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END AS tipo_caso
    , CASE
        WHEN TRIM(cMenu) IS NULL OR TRIM(cMenu) = '' THEN 'SIN_MENU'
        WHEN cMenu REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cMenu REGEXP '^[0-9]{10}$' THEN 'MENU_10_NUMEROS'
        WHEN cMenu REGEXP '^[0-9]{11}$' THEN 'MENU_11_NUMEROS'
        ELSE cMenu
    END AS menu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) as total_llamadas
    , ROUND((COUNT(*) * 100.0 / @total_llamadas_t2), 7) AS porcentaje
    , COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END) as misma_línea
    , COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado AND cTelefono_Digitado IS NOT NULL THEN 1 END) as línea_diferente
    , COUNT(CASE WHEN cTelefono_Digitado IS NULL THEN 1 END) as no_digito_telefono

FROM tbl_historico_t2_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY cDID_800, tipo_caso, menu, cOpcion

UNION ALL

SELECT 
    @Q3_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END AS cDID_800
    , CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL OR TRIM(cDID_Centro_Transferencia) = ''  THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
    END AS tipo_caso
    , CASE
        WHEN TRIM(cMenu) IS NULL OR TRIM(cMenu) = '' THEN 'SIN_MENU'
        WHEN cMenu REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cMenu REGEXP '^[0-9]{10}$' THEN 'MENU_10_NUMEROS'
       WHEN cMenu REGEXP '^[0-9]{11}$' THEN 'MENU_11_NUMEROS'
        ELSE cMenu
    END AS menu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) as total_llamadas
    , ROUND((COUNT(*) * 100.0 / @total_llamadas_t3), 7) AS porcentaje
    , COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END) as misma_línea
    , COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado AND cTelefono_Digitado IS NOT NULL THEN 1 END) as línea_diferente
    , COUNT(CASE WHEN cTelefono_Digitado IS NULL THEN 1 END) as no_digito_telefono
FROM tbl_historico_t3_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY cDID_800, tipo_caso, menu, cOpcion
ORDER BY 
    CASE trimestre
        WHEN @Q1_nombre THEN 1
        WHEN @Q2_nombre THEN 2
        WHEN @Q3_nombre THEN 3
    END,
    cDID_800,
    total_llamadas DESC;

-- FINALIZACIÓN
SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;