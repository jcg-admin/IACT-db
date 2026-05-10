-- ====================================================================
-- Script          : Desglose menú×opción por centro (CORREGIDO)
-- Original        : q_menu_centro_transferecia_010925.sql
-- Correcciones    :
--   C-01 CRÍTICO: @ONacionalB = 19020001 (original = 19028031 — igual a A,
--                 duplicaba Nacional A y excluía Nacional B totalmente).
--   C-02 ALTO:    Rango ampliado al quarter completo (01/01→31/03).
--                 Original estaba acotado a 2025-01-15.
--   C-03 ALTO:    Normalización NK90 en centro_transferencia.
--                 Original usaba cDID_Centro_Transferencia crudo.
--   C-04 MEDIO:   cOpcion normalizado a 'SIN_OPCION' (original usaba 'NULL').
--   C-05 MENOR:   Alias de columna sin keyword reservado ('800_transfer').
-- ====================================================================

SET @Q1_nombre = 'Q01_25';
SET @Q1_inicio = '2025-01-01';
SET @Q1_fin    = '2025-03-31';        -- C-02: quarter completo

SET @OPuebla   = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;           -- C-01: corregido (original: 19028031)

SELECT
    -- C-05: alias sin keyword reservado
    CASE
        WHEN cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN cDID_800Transfer = @ONacionalB THEN 'nacional_B'
    END                                        AS segmento,

    -- C-03: centro normalizado con NK90
    CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL
          OR TRIM(cDID_Centro_Transferencia) = ''      THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$'   THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) > 10
            THEN LEFT(cDID_Centro_Transferencia,
                      LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE cDID_Centro_Transferencia
    END                                        AS centro_transferencia,

    COALESCE(NULLIF(TRIM(cMenu), ''), 'SIN_MENU') AS menu,
    COALESCE(NULLIF(TRIM(cOpcion), ''), 'SIN_OPCION') AS opcion,  -- C-04

    COUNT(*)                                   AS ejecuciones,
    ROUND(COUNT(*) * 100.0
          / centro_total.total_centro, 2)      AS porcentaje_dentro_centro,
    COUNT(DISTINCT cTelefono_Digitado)         AS usuarios_unicos,
    MIN(dFecha)                                AS fecha_primera_ejecucion,
    MAX(dFecha)                                AS fecha_ultima_ejecucion,
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
    ), 2)                                      AS duracion_promedio_seg,
    COUNT(CASE WHEN TIME(dHoraInicio) BETWEEN '06:00:00' AND '11:59:59' THEN 1 END) AS ejecuciones_manana,
    COUNT(CASE WHEN TIME(dHoraInicio) BETWEEN '12:00:00' AND '17:59:59' THEN 1 END) AS ejecuciones_tarde,
    COUNT(CASE WHEN TIME(dHoraInicio) BETWEEN '18:00:00' AND '23:59:59' THEN 1 END) AS ejecuciones_noche,
    SUBSTRING(GROUP_CONCAT(
        DISTINCT CASE
            WHEN cEtiquetacliente IS NOT NULL AND cEtiquetacliente != ''
            THEN cEtiquetacliente ELSE NULL END
        ORDER BY cEtiquetacliente SEPARATOR '; '
    ), 1, 150)                                 AS etiquetas_asociadas

FROM tbl_historico_t1_2025

-- Subconsulta de total por centro (sobre el campo normalizado para consistencia)
INNER JOIN (
    SELECT
        CASE
            WHEN TRIM(cDID_Centro_Transferencia) IS NULL
              OR TRIM(cDID_Centro_Transferencia) = ''     THEN 'CASO_NULL'
            WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
            WHEN cDID_Centro_Transferencia REGEXP '^0+$'  THEN 'CASO_ERROR_CEROS'
            WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
            WHEN LENGTH(cDID_Centro_Transferencia) > 10
                THEN LEFT(cDID_Centro_Transferencia,
                          LENGTH(cDID_Centro_Transferencia) - 10)
            ELSE cDID_Centro_Transferencia
        END                  AS centro_norm,
        COUNT(*)             AS total_centro
    FROM tbl_historico_t1_2025
    WHERE dFecha BETWEEN @Q1_inicio AND @Q1_fin
      AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
    GROUP BY centro_norm
) centro_total
    ON CASE
        WHEN TRIM(cDID_Centro_Transferencia) IS NULL
          OR TRIM(cDID_Centro_Transferencia) = ''     THEN 'CASO_NULL'
        WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN cDID_Centro_Transferencia REGEXP '^0+$'  THEN 'CASO_ERROR_CEROS'
        WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
        WHEN LENGTH(cDID_Centro_Transferencia) > 10
            THEN LEFT(cDID_Centro_Transferencia,
                      LENGTH(cDID_Centro_Transferencia) - 10)
        ELSE cDID_Centro_Transferencia
    END = centro_total.centro_norm

WHERE dFecha BETWEEN @Q1_inicio AND @Q1_fin
  AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)

GROUP BY segmento, centro_transferencia, menu, opcion
ORDER BY centro_transferencia, ejecuciones DESC;
