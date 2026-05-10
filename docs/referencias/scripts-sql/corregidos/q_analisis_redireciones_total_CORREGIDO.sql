-- ====================================================================
-- Script          : Análisis de redirecciones (CORREGIDO)
-- Original        : q_analisis_redireciones_total_290825.sql
-- Correcciones    :
--   C-01 ALTO:    @ONacionalB declarada. Original la usaba en SELECT
--                 sin SET → evaluaba como NULL → Nacional B quedaba
--                 como cDID_800Transfer=NULL en el resultado.
--   C-02 ALTO:    WHERE con lógica invertida corregida.
--                 Original: IS NULL OR != ''  → incluía NULLs, excluía vacíos.
--                 Correcto: IS NOT NULL AND != '' → excluye ambos.
--   C-03 MEDIO:   Normalización NK90 en tipo_interaccion.
--                 Original solo manejaba exactamente 10 dígitos; los de
--                 17 dígitos (el caso NK90 dominante, 5.33%) no se normalizaban.
--   C-04 MENOR:   Separar nacional_A / nacional_B.
--   C-05 MENOR:   Rango ampliado al quarter completo.
-- ====================================================================

SET @Q1_nombre  = 'Q01_25';
SET @Q1_inicio  = '2025-01-01';
SET @Q1_fin     = '2025-03-31';       -- C-05

SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;           -- C-01: DECLARADA (faltaba en original)

SELECT
    -- C-04
    CASE
        WHEN l.cDID_800Transfer = @OPuebla    THEN 'Puebla'
        WHEN l.cDID_800Transfer = @ONacionalA THEN 'nacional_A'
        WHEN l.cDID_800Transfer = @ONacionalB THEN 'nacional_B'
        ELSE CAST(l.cDID_800Transfer AS CHAR)
    END                                        AS segmento,

    -- C-03: NK90 completo (no solo 10 dígitos exactos)
    CASE
        WHEN TRIM(l.cDID_Centro_Transferencia) IS NULL
          OR TRIM(l.cDID_Centro_Transferencia) = ''   THEN 'CASO_NULL'
        WHEN l.cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
        WHEN l.cDID_Centro_Transferencia REGEXP '^0+$' THEN 'CASO_ERROR_CEROS'
        WHEN LENGTH(l.cDID_Centro_Transferencia) > 10
            THEN LEFT(l.cDID_Centro_Transferencia,
                      LENGTH(l.cDID_Centro_Transferencia) - 10)
        ELSE l.cDID_Centro_Transferencia
    END                                        AS tipo_interaccion,

    COUNT(*)                                   AS frecuencia,
    COUNT(DISTINCT l.cTelefono_Origen)         AS cuenta_entradas,
    COUNT(DISTINCT l.dFecha)                   AS dias_activos,
    MIN(l.dFecha)                              AS primera_redireccion,
    MAX(l.dFecha)                              AS ultima_redireccion,
    COALESCE(GROUP_CONCAT(
        DISTINCT CONCAT(
            COALESCE(l.cMenu,'SIN_MENU'), ':',
            COALESCE(l.cOpcion,'SIN_OPCION')
        ) SEPARATOR ', '
    ), 'SIN_MENU')                             AS menu_opciones_usadas

FROM tbl_historico_t1_2025 l
JOIN (
    SELECT cTelefono_Origen,
           MIN(dFecha) AS primera_aparicion,
           MAX(dFecha) AS ultima_aparicion
    FROM tbl_historico_t1_2025
    WHERE cTelefono_Origen IS NOT NULL
    GROUP BY cTelefono_Origen
) fechas ON l.cTelefono_Origen = fechas.cTelefono_Origen

WHERE
    -- C-02: lógica corregida — excluir NULL y vacío (original era al revés)
    l.cDID_Centro_Transferencia IS NOT NULL
    AND l.cDID_Centro_Transferencia != ''
    AND l.cEtiquetacliente IS NOT NULL
    AND l.cEtiquetacliente != ''
    AND l.dFecha BETWEEN @Q1_inicio AND @Q1_fin
    -- C-01: @ONacionalB ahora declarada — evalúa correctamente
    AND (
        l.cDID_800Transfer = @OPuebla
        OR l.cDID_800Transfer IN (@ONacionalA, @ONacionalB)
    )

GROUP BY segmento, tipo_interaccion
ORDER BY frecuencia DESC;
