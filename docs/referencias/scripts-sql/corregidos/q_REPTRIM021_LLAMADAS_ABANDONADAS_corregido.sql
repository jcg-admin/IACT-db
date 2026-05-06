-- ====================================================================
-- Script          : Llamadas Abandonadas (CORREGIDO)
-- Original        : q_REPTRIM021_LLAMADAS_ABDANDONADAS.sql
-- Correcciones    :
--   C-01 CRÍTICO: @ONacionalB = 19020001 corregido (original: 1902001).
--   C-02 CRÍTICO: WHERE filtra SOLO las 3 categorías de abandono (D-ETL-006).
--                 El original mostraba TODOS los menús sin filtro.
--   C-03 ALTO:    Nacional A y B separados en el resultado.
--   C-04 MEDIO:   Sentinel normalizado a 'VACIO' (mayúsculas canónico).
--                 Original usaba 'vacio' (minúsculas).
--   C-05 NUEVO:   Agrega columnas de tasa de abandono sobre el total.
-- Engine          : MariaDB/MySQL
-- ====================================================================

SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;   -- C-01: era 1902001 (faltaba un cero)

SET @Q1_nombre = 'Q01_25'; SET @Q1_inicio = '2025-01-01'; SET @Q1_fin = '2025-03-31';
SET @Q2_nombre = 'Q02_25'; SET @Q2_inicio = '2025-04-01'; SET @Q2_fin = '2025-06-30';
SET @Q3_nombre = 'Q03_25'; SET @Q3_inicio = '2025-07-01'; SET @Q3_fin = '2025-09-30';

-- Totales por quarter+segmento para calcular la tasa
SET @total_q1 = (SELECT COUNT(*) FROM tbl_historico_t1_2025
                 WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB));
SET @total_q2 = (SELECT COUNT(*) FROM tbl_historico_t2_2025
                 WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB));
SET @total_q3 = (SELECT COUNT(*) FROM tbl_historico_t3_2025
                 WHERE cDID_800Transfer IN (@OPuebla,@ONacionalA,@ONacionalB));

SELECT
    -- C-03: segmentos separados
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END                                          AS segmento,
    trimestre,
    -- C-04: sentinel canónico 'VACIO' (mayúsculas)
    CASE
        WHEN cMenu IS NULL         THEN 'VACIO'
        WHEN TRIM(cMenu) = ''      THEN 'VACIO'
        WHEN cMenu = 'sin cMenu'   THEN 'VACIO'
        ELSE TRIM(cMenu)
    END                                          AS categoria_abandono,
    COUNT(*)                                     AS llamadas_abandono,
    -- C-05: tasa sobre el total del quarter
    ROUND(COUNT(*) * 100.0 /
          CASE trimestre
              WHEN @Q1_nombre THEN @total_q1
              WHEN @Q2_nombre THEN @total_q2
              WHEN @Q3_nombre THEN @total_q3
          END, 2)                                AS pct_sobre_total_quarter
FROM (
    SELECT @Q1_nombre AS trimestre, cDID_800Transfer, cMenu
    FROM tbl_historico_t1_2025
    WHERE dFecha >= @Q1_inicio AND dFecha <= @Q1_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
      -- C-02: solo las 3 categorías de abandono (D-ETL-006)
      AND (
          cMenu IS NULL
          OR TRIM(cMenu) = ''
          OR cMenu = 'sin cMenu'
          OR cMenu = 'cliente_colgo'
          OR cMenu = 'SinOpcion_Cabecera'
          -- Marque3: confirmar con el equipo si es abandono oficial
          -- OR cMenu = 'Marque3'
      )

    UNION ALL

    SELECT @Q2_nombre, cDID_800Transfer, cMenu
    FROM tbl_historico_t2_2025
    WHERE dFecha >= @Q2_inicio AND dFecha <= @Q2_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
      AND (cMenu IS NULL OR TRIM(cMenu)='' OR cMenu='sin cMenu'
           OR cMenu='cliente_colgo' OR cMenu='SinOpcion_Cabecera')

    UNION ALL

    SELECT @Q3_nombre, cDID_800Transfer, cMenu
    FROM tbl_historico_t3_2025
    WHERE dFecha >= @Q3_inicio AND dFecha <= @Q3_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
      AND (cMenu IS NULL OR TRIM(cMenu)='' OR cMenu='sin cMenu'
           OR cMenu='cliente_colgo' OR cMenu='SinOpcion_Cabecera')
) datos
GROUP BY cDID_800Transfer, trimestre, categoria_abandono
ORDER BY trimestre, segmento, llamadas_abandono DESC;
