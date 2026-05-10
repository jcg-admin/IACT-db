-- Análisis de Menús que Redirigen por Centro de Transferencia
-- Compatible con MariaDB 10.1
-- Muestra opciones en menú agrupadas por VDN/Centro de Transferencia

SELECT 
    id_CTransferencia as centro_transferencia_vdn,
    COUNT(*) as total_llamadas,
    COUNT(DISTINCT numero_digitado) as usuarios_unicos,
    -- Concatenación de menús y opciones que redirigen a este centro
    GROUP_CONCAT(
        DISTINCT CONCAT(
            COALESCE(menu, 'SIN_MENU'), 
            ':', 
            COALESCE(opcion, 'NULL')
        ) 
        ORDER BY menu, opcion 
        SEPARATOR ', '
    ) as menus_que_redirigen,
    -- Conteo de combinaciones menú:opción distintas
    COUNT(DISTINCT CONCAT(COALESCE(menu, 'SIN_MENU'), ':', COALESCE(opcion, 'NULL'))) as combinaciones_distintas,
    -- Fechas de actividad
    MIN(fecha) as fecha_primera_actividad,
    MAX(fecha) as fecha_ultima_actividad,
    -- Métricas temporales
    ROUND(AVG(
        CASE 
            WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                        TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                    ELSE 
                        TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                END
            ELSE NULL
        END
    ), 2) as duracion_promedio_seg,
    MIN(
        CASE 
            WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                        TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                    ELSE 
                        TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                END
            ELSE NULL
        END
    ) as duracion_minima_seg,
    MAX(
        CASE 
            WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                        TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                    ELSE 
                        TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                    END
            ELSE NULL
        END
    ) as duracion_maxima_seg,
    -- Distribución geográfica
    COUNT(DISTINCT id_8T) as zonas_geograficas,
    GROUP_CONCAT(DISTINCT id_8T ORDER BY id_8T SEPARATOR ', ') as lista_zonas,
    -- Distribución organizacional  
    COUNT(DISTINCT CONCAT(COALESCE(division, 'Sin_Div'), '-', COALESCE(area, 'Sin_Area'))) as unidades_organizacionales,
    -- Análisis de integración con mensajería
    COUNT(CASE WHEN nidMQ IS NOT NULL AND nidMQ != '' THEN 1 END) as con_mensajeria,
    ROUND((COUNT(CASE WHEN nidMQ IS NOT NULL AND nidMQ != '' THEN 1 END) / COUNT(*)) * 100, 2) as porcentaje_mensajeria,
    -- Detección de anomalías temporales en este centro
    COUNT(CASE 
        WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL 
             AND TIME_TO_SEC(TIME(hora_inicio)) > TIME_TO_SEC(TIME(hora_fin)) 
        THEN 1 
    END) as registros_hora_invertida,
    -- Clasificación del centro por volumen y complejidad
    CASE 
        WHEN COUNT(*) >= 50 AND AVG(
            CASE 
                WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                    CASE 
                        WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                            TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                        ELSE 
                            TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                    END
                ELSE NULL
            END
        ) > 300 
        THEN 'ALTO_VOLUMEN_COMPLEJO'
        WHEN COUNT(*) >= 50 
        THEN 'ALTO_VOLUMEN_SIMPLE'  
        WHEN AVG(
            CASE 
                WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                    CASE 
                        WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                            TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                        ELSE 
                            TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                    END
                ELSE NULL
            END
        ) > 300 
        THEN 'BAJO_VOLUMEN_COMPLEJO'
        ELSE 'BAJO_VOLUMEN_SIMPLE'
    END as clasificacion_centro
FROM llamadas_Q3
WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
GROUP BY id_CTransferencia
ORDER BY total_llamadas DESC, centro_transferencia_vdn;

-- Query detallado: Desglose por menú dentro de cada centro de transferencia
-- Muestra cuántas veces cada menú:opción se ejecutó por centro
SELECT 
    id_CTransferencia as centro_transferencia,
    COALESCE(menu, 'SIN_MENU') as menu,
    COALESCE(opcion, 'NULL') as opcion,
    COUNT(*) as ejecuciones,
    ROUND((COUNT(*) / centro_total.total_centro) * 100, 2) as porcentaje_dentro_centro,
    COUNT(DISTINCT numero_digitado) as usuarios_unicos,
    MIN(fecha) as fecha_primera_ejecucion,
    MAX(fecha) as fecha_ultima_ejecucion,
    ROUND(AVG(
        CASE 
            WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                        TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                    ELSE 
                        TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                END
            ELSE NULL
        END
    ), 2) as duracion_promedio_seg,
    -- Distribución temporal de esta combinación
    COUNT(CASE WHEN TIME(hora_inicio) BETWEEN '06:00:00' AND '11:59:59' THEN 1 END) as ejecuciones_manana,
    COUNT(CASE WHEN TIME(hora_inicio) BETWEEN '12:00:00' AND '17:59:59' THEN 1 END) as ejecuciones_tarde,
    COUNT(CASE WHEN TIME(hora_inicio) BETWEEN '18:00:00' AND '23:59:59' THEN 1 END) as ejecuciones_noche,
    -- Etiquetas asociadas a esta combinación
    SUBSTRING(
        GROUP_CONCAT(
            DISTINCT CASE 
                WHEN etiquetas IS NOT NULL AND etiquetas != '' 
                THEN etiquetas 
                ELSE NULL 
            END 
            ORDER BY etiquetas 
            SEPARATOR '; '
        ), 1, 150
    ) as etiquetas_asociadas
FROM llamadas_Q3
INNER JOIN (
    -- Subconsulta para obtener el total por centro
    SELECT 
        id_CTransferencia, 
        COUNT(*) as total_centro
    FROM llamadas_Q3 
    WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
    GROUP BY id_CTransferencia
) centro_total ON llamadas_Q3.id_CTransferencia = centro_total.id_CTransferencia
WHERE llamadas_Q3.id_CTransferencia IS NOT NULL AND llamadas_Q3.id_CTransferencia != ''
GROUP BY id_CTransferencia, menu, opcion
ORDER BY centro_transferencia_vdn, ejecuciones DESC;

-- Query de resumen ejecutivo: Top centros de transferencia con métricas clave
SELECT 
    'RESUMEN EJECUTIVO - CENTROS DE TRANSFERENCIA' as reporte_tipo,
    COUNT(DISTINCT id_CTransferencia) as total_centros_activos,
    SUM(total_llamadas) as llamadas_totales,
    ROUND(AVG(total_llamadas), 2) as promedio_llamadas_por_centro,
    MAX(total_llamadas) as maximo_llamadas_centro,
    MIN(total_llamadas) as minimo_llamadas_centro,
    ROUND(AVG(combinaciones_distintas), 2) as promedio_combinaciones_por_centro,
    SUM(CASE WHEN clasificacion_centro LIKE '%ALTO_VOLUMEN%' THEN 1 ELSE 0 END) as centros_alto_volumen,
    SUM(CASE WHEN clasificacion_centro LIKE '%COMPLEJO%' THEN 1 ELSE 0 END) as centros_complejos,
    ROUND(AVG(duracion_promedio_seg), 2) as duracion_promedio_global
FROM (
    SELECT 
        id_CTransferencia,
        COUNT(*) as total_llamadas,
        COUNT(DISTINCT CONCAT(COALESCE(menu, 'SIN_MENU'), ':', COALESCE(opcion, 'NULL'))) as combinaciones_distintas,
        ROUND(AVG(
            CASE 
                WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                    CASE 
                        WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                            TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                        ELSE 
                            TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                    END
                ELSE NULL
            END
        ), 2) as duracion_promedio_seg,
        CASE 
            WHEN COUNT(*) >= 50 AND AVG(
                CASE 
                    WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                        CASE 
                            WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                                TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                            ELSE 
                                TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                        END
                    ELSE NULL
                END
            ) > 300 
            THEN 'ALTO_VOLUMEN_COMPLEJO'
            WHEN COUNT(*) >= 50 
            THEN 'ALTO_VOLUMEN_SIMPLE'  
            WHEN AVG(
                CASE 
                    WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                        CASE 
                            WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                                TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                            ELSE 
                                TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                        END
                    ELSE NULL
                END
            ) > 300 
            THEN 'BAJO_VOLUMEN_COMPLEJO'
            ELSE 'BAJO_VOLUMEN_SIMPLE'
        END as clasificacion_centro
    FROM llamadas_Q3
    WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
    GROUP BY id_CTransferencia
) resumen_centros;