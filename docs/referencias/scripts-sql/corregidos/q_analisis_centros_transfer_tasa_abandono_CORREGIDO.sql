-- ====================================================================
-- Script          : Tasa de abandono por duración (CORREGIDO)
-- Original        : q_analisis_centros_transfer_tasa_abandono_010925.sql
-- Correcciones    :
--   C-01 ALTO:    Paréntesis en cláusula WHERE.
--                 Original: cDID_800Transfer = @OPuebla OR cDID_800Transfer IN (...)
--                 Con AND antes sin paréntesis, la precedencia de SQL es:
--                   (... AND cDID_800Transfer = @OPuebla) OR (cDID_800Transfer IN (...))
--                 Esto incluía TODOS los registros donde el DID es Nacional,
--                 ignorando el filtro de fecha para Nacional.
--   C-02 MEDIO:   Rango ampliado al quarter completo.
--                 Original acotado a 2025-01-15.
--   C-03 MENOR:   Separar nacional_A / nacional_B.
-- Sin cambios     : Lógica de duración < 30 seg como proxy de abandono (investigación).
-- ====================================================================

SET @Q1_nombre  = 'Q01_25';
SET @Q1_inicio  = '2025-01-01';
SET @Q1_fin     = '2025-03-31';       -- C-02: quarter completo

SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;

SELECT
    'CENTROS CON ALTA TASA DE ABANDONO (duración < 30 seg)' AS analisis,
    -- C-03: segmento separado
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END                                      AS segmento,
    cDID_Centro_Transferencia,
    total_llamadas,
    llamadas_cortas,
    ROUND(llamadas_cortas * 100.0 / total_llamadas, 2) AS pct_llamadas_cortas,
    menus_principales,
    duracion_promedio_segundos
FROM (
    SELECT
        cDID_800Transfer,
        cDID_Centro_Transferencia,
        COUNT(*)                             AS total_llamadas,
        COUNT(CASE
            WHEN dHoraInicio IS NOT NULL AND dHoraFin IS NOT NULL THEN
                CASE
                    WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin))
                         AND TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio)) < 30
                        THEN 1
                    WHEN TIME_TO_SEC(TIME(dHoraInicio)) > TIME_TO_SEC(TIME(dHoraFin))
                         AND TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin)) < 30
                        THEN 1
                END
        END)                                 AS llamadas_cortas,
        SUBSTRING(GROUP_CONCAT(
            DISTINCT COALESCE(cMenu,'SIN_MENU')
            ORDER BY cMenu SEPARATOR ', '
        ), 1, 100)                           AS menus_principales,
        ROUND(AVG(
            CASE
                WHEN dHoraInicio IS NOT NULL AND dHoraFin IS NOT NULL THEN
                    CASE
                        WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin))
                            THEN TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio))
                        ELSE
                            TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin))
                    END
            END
        ), 2)                                AS duracion_promedio_segundos
    FROM tbl_historico_t1_2025
    WHERE cDID_Centro_Transferencia IS NOT NULL
      AND cDID_Centro_Transferencia != ''
      AND dFecha BETWEEN @Q1_inicio AND @Q1_fin
      -- C-01: paréntesis — el AND fecha debe aplicar a TODOS los DIDs
      AND (
          cDID_800Transfer = @OPuebla
          OR cDID_800Transfer IN (@ONacionalA, @ONacionalB)
      )
    GROUP BY cDID_800Transfer, cDID_Centro_Transferencia
    HAVING total_llamadas >= 5
) centros_problema
WHERE ROUND(llamadas_cortas * 100.0 / total_llamadas, 2) > 40
ORDER BY pct_llamadas_cortas DESC, total_llamadas DESC;
