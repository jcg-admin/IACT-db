-- Query de Centros de Transferencia con análisis de días hábiles
-- Combina el análisis de menús que redirigen con métricas temporales

SELECT 
    id_CTransferencia as centro_transferencia,
    COUNT(*) as total_llamadas,
    COUNT(DISTINCT numero_entrada) as usuarios_unicos,
    
    -- Concatenación de menús como en el ejemplo original
    GROUP_CONCAT(
        DISTINCT CONCAT(
            COALESCE(menu, 'SIN_MENU'), 
            ':', 
            COALESCE(opcion, 'NULL')
        ) 
        ORDER BY menu, opcion 
        SEPARATOR ', '
    ) as menus_que_redirigen,
    
    -- ANÁLISIS TEMPORAL CON DÍAS HÁBILES
    -- Fechas de actividad
    MIN(fecha) as fecha_primera_actividad,
    MAX(fecha) as fecha_ultima_actividad,
    
    -- Análisis de seguimiento por centro de transferencia
    fn_agregar_dias_habiles(MAX(fecha), 1) as fecha_seguimiento_1_dia,
    fn_agregar_dias_habiles(MAX(fecha), 3) as fecha_seguimiento_3_dias,
    fn_agregar_dias_habiles(MAX(fecha), 5) as fecha_escalamiento,
    
    -- Distribución por tipo de día (análisis histórico)
    COUNT(CASE WHEN fn_es_dia_habil(fecha) THEN 1 END) as llamadas_dias_habiles,
    COUNT(CASE WHEN NOT fn_es_dia_habil(fecha) THEN 1 END) as llamadas_fines_semana,
    ROUND((COUNT(CASE WHEN fn_es_dia_habil(fecha) THEN 1 END) / COUNT(*)) * 100, 1) as porcentaje_dias_habiles,
    
    -- Duración del período de actividad del centro
    fn_contar_dias_habiles(MIN(fecha), MAX(fecha)) as dias_habiles_periodo_actividad,
    DATEDIFF(MAX(fecha), MIN(fecha)) as dias_calendario_periodo_actividad,
    
    -- Clasificación del centro por patrón de uso
    CASE 
        WHEN COUNT(CASE WHEN fn_es_dia_habil(fecha) THEN 1 END) / COUNT(*) >= 0.8 THEN 'CENTRO_EMPRESARIAL'
        WHEN COUNT(CASE WHEN NOT fn_es_dia_habil(fecha) THEN 1 END) / COUNT(*) >= 0.4 THEN 'CENTRO_MIXTO'
        ELSE 'CENTRO_PERSONAL'
    END as patron_uso_centro,
    
    -- Métricas de performance corrigiendo anomalías temporales
    ROUND(AVG(
        CASE 
            WHEN hora_inicio IS NOT NULL AND hora_fin IS NOT NULL THEN
                CASE 
                    WHEN TIME_TO_SEC(TIME(hora_inicio)) <= TIME_TO_SEC(TIME(hora_fin)) THEN 
                        TIME_TO_SEC(TIME(hora_fin)) - TIME_TO_SEC(TIME(hora_inicio))
                    ELSE 
                        TIME_TO_SEC(TIME(hora_inicio)) - TIME_TO_SEC(TIME(hora_fin))
                END
        END
    ), 2) as duracion_promedio_segundos,
    
    -- Análisis de patrones por horario
    COUNT(CASE 
        WHEN fn_es_dia_habil(fecha) AND TIME(hora_inicio) BETWEEN '08:00:00' AND '18:00:00' 
        THEN 1 
    END) as llamadas_horario_comercial,
    
    COUNT(CASE 
        WHEN fn_es_dia_habil(fecha) AND TIME(hora_inicio) NOT BETWEEN '08:00:00' AND '18:00:00' 
        THEN 1 
    END) as llamadas_fuera_horario_comercial,
    
    -- Clasificación del centro por actividad y urgencia
    CASE 
        WHEN COUNT(*) >= 20 AND fn_contar_dias_habiles(MAX(fecha), CURDATE()) <= 1 THEN 'CENTRO_CRITICO_ACTIVO'
        WHEN COUNT(*) >= 20 AND fn_contar_dias_habiles(MAX(fecha), CURDATE()) > 3 THEN 'CENTRO_ALTO_VOLUMEN_INACTIVO'
        WHEN COUNT(*) >= 10 THEN 'CENTRO_VOLUMEN_MEDIO'
        ELSE 'CENTRO_BAJO_VOLUMEN'
    END as clasificacion_centro
    
FROM llamadas_Q3
WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
GROUP BY id_CTransferencia
ORDER BY total_llamadas DESC, dias_habiles_desde_ultima_actividad ASC;

-- Query complementario: Centros que requieren seguimiento inmediato
SELECT 
    'CENTROS PARA SEGUIMIENTO INMEDIATO' as analisis,
    id_CTransferencia,
    total_llamadas,
    usuarios_unicos,
    dias_habiles_transcurridos,
    estado_seguimiento,
    menus_principales,
    fecha_ultima_actividad,
    fecha_seguimiento_requerido
FROM (
    SELECT 
        id_CTransferencia,
        COUNT(*) as total_llamadas,
        COUNT(DISTINCT numero_entrada) as usuarios_unicos,
        MAX(fecha) as fecha_ultima_actividad,
        fn_contar_dias_habiles(MAX(fecha), CURDATE()) as dias_habiles_transcurridos,
        fn_agregar_dias_habiles(MAX(fecha), 3) as fecha_seguimiento_requerido,
        CASE 
            WHEN fn_contar_dias_habiles(MAX(fecha), CURDATE()) <= 1 THEN 'URGENTE_1_DIA'
            WHEN fn_contar_dias_habiles(MAX(fecha), CURDATE()) <= 3 THEN 'NORMAL_3_DIAS'
            WHEN fn_contar_dias_habiles(MAX(fecha), CURDATE()) <= 5 THEN 'URGENTE_5_DIAS'
            ELSE 'ESCALAMIENTO_REQUERIDO'
        END as estado_seguimiento,
        SUBSTRING(
            GROUP_CONCAT(DISTINCT COALESCE(menu, 'SIN_MENU') ORDER BY menu SEPARATOR ', '), 
            1, 100
        ) as menus_principales
    FROM llamadas_Q3
    WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
    GROUP BY id_CTransferencia
    HAVING COUNT(*) >= 2  -- Solo centros con actividad significativa
) centros_analisis
WHERE estado_seguimiento IN ('URGENTE_1_DIA', 'URGENTE_5_DIAS', 'ESCALAMIENTO_REQUERIDO')
ORDER BY 
    CASE estado_seguimiento 
        WHEN 'URGENTE_1_DIA' THEN 1
        WHEN 'URGENTE_5_DIAS' THEN 2  
        WHEN 'ESCALAMIENTO_REQUERIDO' THEN 3
    END,
    total_llamadas DESC;

-- Query de SLA por centro de transferencia
SELECT 
    'CUMPLIMIENTO DE SLA POR CENTRO' as analisis,
    estado_sla,
    COUNT(*) as cantidad_centros,
    ROUND(AVG(total_llamadas), 2) as promedio_llamadas_por_centro,
    ROUND(AVG(usuarios_unicos), 2) as promedio_usuarios_por_centro,
    ROUND((COUNT(*) / total.total_centros) * 100, 2) as porcentaje_centros
FROM (
    SELECT 
        id_CTransferencia,
        COUNT(*) as total_llamadas,
        COUNT(DISTINCT numero_entrada) as usuarios_unicos,
        CASE 
            WHEN fn_contar_dias_habiles(MAX(fecha), CURDATE()) = 0 THEN 'DENTRO_SLA_HOY'
            WHEN fn_contar_dias_habiles(MAX(fecha), CURDATE()) <= 3 THEN 'DENTRO_SLA_3_DIAS'
            WHEN fn_contar_dias_habiles(MAX(fecha), CURDATE()) <= 5 THEN 'FUERA_SLA_CRITICO'
            ELSE 'FUERA_SLA_ESCALAMIENTO'
        END as estado_sla
    FROM llamadas_Q3
    WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
    GROUP BY id_CTransferencia
) sla_centros
CROSS JOIN (
    SELECT COUNT(DISTINCT id_CTransferencia) as total_centros 
    FROM llamadas_Q3 
    WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
) total
GROUP BY estado_sla
ORDER BY 
    CASE estado_sla
        WHEN 'DENTRO_SLA_HOY' THEN 1
        WHEN 'DENTRO_SLA_3_DIAS' THEN 2
        WHEN 'FUERA_SLA_CRITICO' THEN 3
        WHEN 'FUERA_SLA_ESCALAMIENTO' THEN 4
    END;

-- Query ejemplo con resultado esperado similar al tuyo
-- Para el centro 15070013 mencionado en tu ejemplo
SELECT 
    CONCAT('id_CTransferencia = ', id_CTransferencia) as centro_info,
    CONCAT('# concatenación de menu y opcion') as descripcion,
    menus_que_redirigen,
    CONCAT('Total llamadas: ', total_llamadas) as volumen,
    CONCAT('Última actividad: ', fecha_ultima_actividad, ' (hace ', 
           dias_habiles_desde_ultima_actividad, ' días hábiles)') as seguimiento_info,
    CONCAT('Próximo seguimiento requerido: ', fecha_seguimiento_3_dias) as accion_requerida
FROM (
    SELECT 
        id_CTransferencia,
        COUNT(*) as total_llamadas,
        GROUP_CONCAT(
            DISTINCT CONCAT(COALESCE(menu, 'SIN_MENU'), ':', COALESCE(opcion, 'DEFAULT'))
            ORDER BY menu, opcion 
            SEPARATOR ', '
        ) as menus_que_redirigen,
        MAX(fecha) as fecha_ultima_actividad,
        fn_contar_dias_habiles(MAX(fecha), CURDATE()) as dias_habiles_desde_ultima_actividad,
        fn_agregar_dias_habiles(MAX(fecha), 3) as fecha_seguimiento_3_dias
    FROM llamadas_Q3
    WHERE id_CTransferencia IS NOT NULL AND id_CTransferencia != ''
    GROUP BY id_CTransferencia
) resultado
WHERE id_CTransferencia = '15070013';  -- Ejemplo específico mencionado