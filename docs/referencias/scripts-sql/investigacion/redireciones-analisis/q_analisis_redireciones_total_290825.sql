-- ====================================================================
-- ANÁLISIS: REDIRECIONES DEL SISTEMA
-- q_analisis_redireciones_290825
-- ====================================================================

SET @Q1_nombre = 'Q01_25';
SET @Q1_inicio = '2025-01-01';
SET @Q1_fin = '2025-01-15';

SET @OPuebla = 19020084;
SET @ONacionalA = 19028031;

SELECT
    CASE WHEN l.cDID_800Transfer = @OPuebla THEN 'Puebla' WHEN l.cDID_800Transfer IN (@ONacionalA, @ONacionalB) THEN 'Nacional' ELSE cDID_800Transfer END AS cDID_800Transfer
    , CASE WHEN l.cDID_Centro_Transferencia REGEXP '^[0-9]{10}$' THEN SUBSTRING(l.cDID_Centro_Transferencia, 1, 10) ELSE l.cDID_Centro_Transferencia END AS tipo_interaccion
    , COUNT(*) AS frecuencia
    , COUNT(DISTINCT l.cTelefono_Origen) AS cuenta_entrada

    , COUNT(DISTINCT l.dFecha) AS dias_activos
    , MIN(l.dFecha) AS primera_redireccion
    , MAX(l.dFecha) AS ultima_redireccion

    , COUNT(DISTINCT l.cTelefono_Origen) AS cTelefono_Origen

    , COALESCE(GROUP_CONCAT(DISTINCT CONCAT(COALESCE(l.cMenu, 'Sin Menú'), ':', COALESCE(l.cOpcion, 'Sin Opción')) SEPARATOR ', '), 'Sin Opción') AS menu_opciones_usadas


FROM 
    tbl_historico_t1_2025 l
JOIN (
    -- Subconsulta para obtener las fechas mín/máx
    SELECT 
        cTelefono_Origen
        , MIN(dFecha) AS primera_aparicion
        , MAX(dFecha) AS ultima_aparicion
    FROM tbl_historico_t1_2025
    WHERE cTelefono_Origen IS NOT NULL  -- Asegúrate de que cTelefono_Origen no sea nulo
    GROUP BY cTelefono_Origen
) fechas ON l.cTelefono_Origen = fechas.cTelefono_Origen 
        
WHERE 
    (l.cDID_Centro_Transferencia IS NULL OR l.cDID_Centro_Transferencia != '')
    AND (l.cEtiquetacliente IS NULL OR l.cEtiquetacliente != '')
    AND l.dFecha BETWEEN @Q1_inicio AND @Q1_fin
    AND (l.cDID_800Transfer = @OPuebla OR l.cDID_800Transfer IN (@ONacionalA, @ONacionalB))
GROUP BY 
    tipo_interaccion, l.cMenu, l.cOpcion, fechas.primera_aparicion, fechas.ultima_aparicion, cDID_800Transfer
ORDER BY 
    frecuencia DESC;
