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

SELECT 
    @Q1_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END as cDID_800Transfer
    , CASE
        WHEN COALESCE(NULLIF(cDID_Centro_Transferencia, ''), cDID_Centro_Transferencia) IS NULL THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'cliente_colgo'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
        END as tipo_caso
	
    , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU') AS cMenu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) as total_llamadas
    , ROUND((COUNT(*) * 100.0 / total_general.total), 4) as porcentaje
    , COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END) as misma_línea
    , COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado AND cTelefono_Digitado IS NOT NULL THEN 1 END) as línea_diferente
    , COUNT(CASE WHEN cTelefono_Digitado IS NULL THEN 1 END) as no_digito_telefono

FROM tbl_historico_t1_2025
JOIN (SELECT COUNT(*) as total 
        FROM tbl_historico_t1_2025
        WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
    ) total_general
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY tipo_caso, cMenu, cOpcion

UNION ALL

SELECT 
    @Q2_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END as cDID_800Transfer
    , CASE
        WHEN COALESCE(NULLIF(cDID_Centro_Transferencia, ''), cDID_Centro_Transferencia) IS NULL THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'cliente_colgo'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
        END as tipo_caso
	
    , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU') AS cMenu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) as total_llamadas
    , ROUND((COUNT(*) * 100.0 / total_general.total), 4) as porcentaje
    , COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END) as misma_línea
    , COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado AND cTelefono_Digitado IS NOT NULL THEN 1 END) as línea_diferente
    , COUNT(CASE WHEN cTelefono_Digitado IS NULL THEN 1 END) as no_digito_telefono

FROM tbl_historico_t2_2025
JOIN (SELECT COUNT(*) as total 
        FROM tbl_historico_t2_2025
        WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
    ) total_general
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
GROUP BY tipo_caso, cMenu, cOpcion

UNION ALL

SELECT 
    @Q3_nombre as trimestre
    , CASE WHEN cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN cDID_800Transfer IN (@ONacionalA,@ONacionalB)  THEN 'Nacional' END as cDID_800Transfer
    , CASE
        WHEN COALESCE(NULLIF(cDID_Centro_Transferencia, ''), cDID_Centro_Transferencia) IS NULL THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'cliente_colgo'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) <= 10 THEN cDID_Centro_Transferencia
        WHEN LENGTH(cDID_Centro_Transferencia) > 10 THEN LEFT(cDID_Centro_Transferencia, LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE 'FORMATO_ESPECIAL'
        END as tipo_caso
	
    , COALESCE(NULLIF(cMenu, ''), 'SIN_MENU') AS cMenu
    , COALESCE(NULLIF(cOpcion, ''), 'SIN_OPCION') AS cOpcion
    , COUNT(*) as total_llamadas
    , ROUND((COUNT(*) * 100.0 / total_general.total), 2) as porcentaje
    , COUNT(CASE WHEN cTelefono_Origen = cTelefono_Digitado THEN 1 END) as validaciones_exitosas
    , COUNT(CASE WHEN cTelefono_Origen != cTelefono_Digitado AND cTelefono_Digitado IS NOT NULL THEN 1 END) as línea_diferente
    , COUNT(CASE WHEN cTelefono_Digitado IS NULL THEN 1 END) as no_digito_telefono

FROM tbl_historico_t3_2025
JOIN (SELECT COUNT(*) as total 
        FROM tbl_historico_t3_2025
        WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
    ) total_general
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