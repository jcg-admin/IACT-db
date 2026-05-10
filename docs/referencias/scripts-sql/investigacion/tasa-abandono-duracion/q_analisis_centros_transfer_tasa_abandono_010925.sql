-- ====================================================================
-- ANÁLISIS: Centros de transferencia con mayor tasa de abandono
-- q_analisis_centros_transfer_tasa_abandono_010925

-- ====================================================================

SET @Q1_nombre = 'Q01_25';
SET @Q1_inicio = '2025-01-01';
SET @Q1_fin = '2025-01-15';

SET @OPuebla = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;


SELECT 
    'CENTROS CON ALTA TASA DE ABANDONO' as problema_detectado,
    cDID_Centro_Transferencia,
    total_llamadas,
    llamadas_abandonadas,
    porcentaje_abandonadas,
    menus_principales,
    duracion_promedio_segundos,
    clasificacion_centro_duracion
FROM (
    SELECT 
        cDID_Centro_Transferencia,
        COUNT(*) as total_llamadas,
        COUNT(CASE 
            WHEN dHoraInicio IS NOT NULL AND dHoraFin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin)) THEN 
                        CASE WHEN TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio)) < 30 THEN 1 END
                    ELSE 
                        CASE WHEN TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin)) < 30 THEN 1 END
                END
        END) as llamadas_abandonadas,
        ROUND((COUNT(CASE 
            WHEN dHoraInicio IS NOT NULL AND dHoraFin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin)) THEN 
                        CASE WHEN TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio)) < 30 THEN 1 END
                    ELSE 
                        CASE WHEN TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin)) < 30 THEN 1 END
                END
        END) / COUNT(*)) * 100, 2) as porcentaje_abandonadas,
        SUBSTRING(GROUP_CONCAT(DISTINCT COALESCE(cMenu, 'SIN_MENU') ORDER BY cMenu SEPARATOR ', '), 1, 100) as menus_principales,
        ROUND(AVG(
            CASE 
                WHEN dHoraInicio IS NOT NULL AND dHoraFin IS NOT NULL THEN
                    CASE 
                        WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin)) THEN 
                            TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio))
                        ELSE 
                            TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin))
                    END
            END
        ), 2) as duracion_promedio_segundos,
        'CENTRO_ALTA_ABANDONO' as clasificacion_centro_duracion
    FROM tbl_historico_t1_2025
    WHERE cDID_Centro_Transferencia IS NOT NULL AND cDID_Centro_Transferencia != ''
        AND cDID_800Transfer = @OPuebla OR cDID_800Transfer IN (@ONacionalA, @ONacionalB)
        AND dFecha BETWEEN @Q1_inicio AND @Q1_fin
    GROUP BY cDID_Centro_Transferencia
    HAVING porcentaje_abandonadas > 40  -- Más del 40% de abandono
) centros_problema
WHERE total_llamadas >= 5  -- Solo centros con volumen significativo
ORDER BY porcentaje_abandonadas DESC, total_llamadas DESC;