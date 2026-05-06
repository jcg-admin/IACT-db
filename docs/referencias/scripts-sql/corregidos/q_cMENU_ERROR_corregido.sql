-- ====================================================================
-- Script          : Anomalías cMENU_ERROR (CORREGIDO)
-- Original        : q_cMENU_ERROR.sql
-- Correcciones    :
--   C-01 CRÍTICO: Solo detectar anomalías NUMÉRICAS en cMenu.
--                 Original mezclaba NULL/vacío (que son VACIO, no anomalías)
--                 con los valores numéricos reales del error.
--   C-02 CRÍTICO: Agregar resultado (COUNT por cMenu) en lugar de SELECT *.
--                 El original devolvía registros individuales — no era un reporte.
--   C-03 ALTO:    Parametrizar por trimestre (original hardcodeado a Q3).
--   C-04 ALTO:    Incluir los 3 DIDs correctamente.
-- Engine          : MariaDB/MySQL
-- ====================================================================

-- Definición correcta de anomalía cMENU_ERROR (sp_rpt_cMENU_ERROR):
--   cMenu contiene un número de teléfono o valor puramente numérico
--   en lugar de un nombre de menú IVR.
--
-- Tipos de anomalía detectados:
--   1. cMenu = cTelefono_Digitado = cTelefono_Origen  → 'telefono_cMenu'
--   2. cMenu REGEXP '^[0-9]+'                          → numérico genérico
--
-- EXCLUIDOS (no son anomalías — se normalizan a 'VACIO' en el ETL):
--   cMenu IS NULL, TRIM(cMenu)='', cMenu='sin cMenu'

-- C-03: variables por trimestre (ajustar según el análisis deseado)
SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;   -- C-04: los 3 DIDs

SET @Q3_nombre  = 'Q03_25';
SET @Q3_inicio  = '2025-07-01';
SET @Q3_fin     = '2025-09-30';

-- C-02: resultado AGREGADO por tipo de anomalía
SELECT
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END                                    AS segmento,
    @Q3_nombre                             AS trimestre,
    -- Clasificar el tipo de anomalía
    CASE
        WHEN cTelefono_Digitado = cMenu
         AND cTelefono_Origen   = cMenu    THEN 'telefono_cMenu'
        WHEN LENGTH(cMenu) = 10            THEN 'MENU_10_NUMEROS'
        WHEN LENGTH(cMenu) = 11            THEN 'MENU_11_NUMEROS'
        WHEN cMenu REGEXP '^[0-9]+'        THEN 'MENU_NUMERICO_OTRO'
        ELSE                                    'OTRO'
    END                                    AS tipo_anomalia,
    cMenu                                  AS valor_anomalo,
    COUNT(*)                               AS total_ocurrencias
FROM tbl_historico_t3_2025
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
  -- C-01: SOLO anomalías numéricas — excluir NULL/vacío
  AND cMenu IS NOT NULL
  AND TRIM(cMenu) != ''
  AND cMenu != 'sin cMenu'
  AND (
      (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)
      OR cMenu REGEXP '^[0-9]+'
  )
GROUP BY segmento, tipo_anomalia, valor_anomalo
ORDER BY total_ocurrencias DESC;
