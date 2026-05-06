-- ====================================================================
-- ANÁLISIS: Desglose por menú dentro de cada centro de transferencia
-- Muestra cuántas veces cada menú:opción se ejecutó por centro
-- q_menu_centro_transferecia_010925
-- ====================================================================

SET @Q1_nombre = 'Q01_25';
SET @Q1_inicio = '2025-01-01';
SET @Q1_fin = '2025-01-15';

SET @OPuebla = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19028031;

SELECT 
    tbl_historico_t1_2025.cDID_Centro_Transferencia as centro_transferencia_vdn,
    COALESCE(cMenu, 'SIN_MENU') as cMenu,
    COALESCE(cOpcion, 'NULL') as cOpcion,
    COUNT(*) as ejecuciones,
    ROUND((COUNT(*) / centro_total.total_centro) * 100, 2) as porcentaje_dentro_centro,
    COUNT(DISTINCT cTelefono_Digitado) as usuarios_unicos,
    MIN(dFecha) as fecha_primera_ejecucion,
    MAX(dFecha) as fecha_ultima_ejecucion,
    ROUND(AVG(
        CASE 
            WHEN dHoraInicio IS NOT NULL AND dHoraFin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin)) THEN 
                        TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio))
                    ELSE 
                        TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin))
                END
            ELSE NULL
        END
    ), 2) as duracion_promedio_seg,
    -- Distribución temporal de esta combinación
    COUNT(CASE WHEN TIME(dHoraInicio) BETWEEN '06:00:00' AND '11:59:59' THEN 1 END) as ejecuciones_manana,
    COUNT(CASE WHEN TIME(dHoraInicio) BETWEEN '12:00:00' AND '17:59:59' THEN 1 END) as ejecuciones_tarde,
    COUNT(CASE WHEN TIME(dHoraInicio) BETWEEN '18:00:00' AND '23:59:59' THEN 1 END) as ejecuciones_noche,
    -- Etiquetas asociadas a esta combinación
    SUBSTRING(
        GROUP_CONCAT(
            DISTINCT CASE 
                WHEN cEtiquetacliente IS NOT NULL AND cEtiquetacliente != '' 
                THEN cEtiquetacliente 
                ELSE NULL 
            END 
            ORDER BY cEtiquetacliente 
            SEPARATOR '; '
        ), 1, 150
    ) as etiquetas_asociadas
FROM tbl_historico_t1_2025
INNER JOIN (
    -- Subconsulta para obtener el total por centro
    SELECT 
        cDID_Centro_Transferencia, 
        COUNT(*) as total_centro
    FROM tbl_historico_t1_2025 
    WHERE cDID_Centro_Transferencia IS NOT NULL AND cDID_Centro_Transferencia != ''
    GROUP BY cDID_Centro_Transferencia
) centro_total ON tbl_historico_t1_2025.cDID_Centro_Transferencia = centro_total.cDID_Centro_Transferencia
WHERE tbl_historico_t1_2025.cDID_Centro_Transferencia IS NOT NULL AND tbl_historico_t1_2025.cDID_Centro_Transferencia != ''
    AND tbl_historico_t1_2025.dFecha BETWEEN @Q1_inicio AND @Q1_fin
    AND tbl_historico_t1_2025.cDID_800Transfer IN (@ONacionalA, @ONacionalB, @OPuebla)
GROUP BY centro_transferencia_vdn, cMenu, cOpcion
ORDER BY centro_transferencia_vdn, ejecuciones DESC;


