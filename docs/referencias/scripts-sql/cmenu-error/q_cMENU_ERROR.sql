-- ====================================================================
-- INFORMACIÓN DEL ENTORNO
-- ====================================================================

SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_fin
FROM DUAL;

/*********************************************************************************************
     Script          : Análisis Menu con numero
     
     Create          : AGOSTO/2025
     Engine          : MariaDB/MySQL
 
     Notas:
     
*********************************************************************************************/

-- ====================================================================
-- CONFIGURACIÓN DE VARIABLES
-- ====================================================================


-- ====================================================================
-- ANÁLISIS: LLAMADAS MENU
-- ====================================================================


SELECT *
FROM tbl_historico_t3_2025
WHERE cDID_800Transfer IN (19020084, 19028031 ,19020001)
AND(
    (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)
    OR cMenu REGEXP '^[0-9]+$' 
    OR cMenu IS NULL 
    OR TRIM(cMenu) = '' 
    OR cMenu IN ('', 'sin cMenu')
)ORDER BY cDID_800Transfer ASC;

-- ====================================================================
-- FINALIZACIÓN
-- ====================================================================

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;