-- ====================================================================
-- Script          : Centros × segmento con días hábiles (CORREGIDO)
-- Original        : query_centros_transferencia_dias_habiles.sql
-- Correcciones    :
--   C-01 MEDIO:   ORDER BY dias_habiles_desde_ultima_actividad eliminado.
--                 Esa columna no existe en el SELECT principal — solo en
--                 subconsultas internas. Se reemplaza por total_llamadas DESC.
--   C-02 ALTO:    Tabla fuente: tbl_historico_t3_2025 en lugar de "llamadas_Q3"
--                 (vista temporal que no existe en el entorno IACT-db).
--   C-03 ALTO:    Normalización NK90 en id_CTransferencia.
--   C-04 INFO:    fn_es_dia_habil(), fn_contar_dias_habiles(), fn_agregar_dias_habiles()
--                 son funciones custom — PENDIENTE confirmar si existen en
--                 MariaDB del cliente (P-14). Se mantienen pero con comentario.
--
-- NOTA P-14: Si las funciones fn_* no existen, usar las versiones
--            sin días hábiles hasta que se creen.
-- ====================================================================

SET @Q3_nombre  = 'Q03_25';
SET @Q3_inicio  = '2025-07-01';
SET @Q3_fin     = '2025-09-30';

SET @OPuebla    = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;

-- Query principal: un centro por fila
SELECT
    -- C-03: normalización NK90
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
    END                                                AS id_CTransferencia,

    COUNT(*)                                           AS total_llamadas,
    COUNT(DISTINCT cTelefono_Origen)                   AS usuarios_unicos,

    GROUP_CONCAT(
        DISTINCT CONCAT(
            COALESCE(cMenu,'SIN_MENU'), ':',
            COALESCE(NULLIF(cOpcion,''),'SIN_OPCION')
        )
        ORDER BY cMenu, cOpcion SEPARATOR ', '
    )                                                  AS menus_que_redirigen,

    MIN(dFecha)                                        AS fecha_primera_actividad,
    MAX(dFecha)                                        AS fecha_ultima_actividad,

    -- P-14: funciones custom — verificar existencia antes de ejecutar
    fn_agregar_dias_habiles(MAX(dFecha), 1)            AS fecha_seguimiento_1_dia,
    fn_agregar_dias_habiles(MAX(dFecha), 3)            AS fecha_seguimiento_3_dias,
    fn_agregar_dias_habiles(MAX(dFecha), 5)            AS fecha_escalamiento,

    COUNT(CASE WHEN fn_es_dia_habil(dFecha) THEN 1 END)     AS llamadas_dias_habiles,
    COUNT(CASE WHEN NOT fn_es_dia_habil(dFecha) THEN 1 END) AS llamadas_fines_semana,
    ROUND(COUNT(CASE WHEN fn_es_dia_habil(dFecha) THEN 1 END) * 100.0
          / COUNT(*), 1)                               AS porcentaje_dias_habiles,

    fn_contar_dias_habiles(MIN(dFecha), MAX(dFecha))   AS dias_habiles_periodo,
    DATEDIFF(MAX(dFecha), MIN(dFecha))                 AS dias_calendario_periodo,

    CASE
        WHEN COUNT(CASE WHEN fn_es_dia_habil(dFecha) THEN 1 END) * 1.0
             / NULLIF(COUNT(*), 0) >= 0.8              THEN 'CENTRO_EMPRESARIAL'
        WHEN COUNT(CASE WHEN NOT fn_es_dia_habil(dFecha) THEN 1 END) * 1.0
             / NULLIF(COUNT(*), 0) >= 0.4              THEN 'CENTRO_MIXTO'
        ELSE                                                'CENTRO_PERSONAL'
    END                                                AS patron_uso_centro,

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
    ), 2)                                              AS duracion_promedio_segundos,

    COUNT(CASE
        WHEN fn_es_dia_habil(dFecha)
         AND TIME(dHoraInicio) BETWEEN '08:00:00' AND '18:00:00'
        THEN 1 END)                                    AS llamadas_horario_comercial,

    COUNT(CASE
        WHEN fn_es_dia_habil(dFecha)
         AND TIME(dHoraInicio) NOT BETWEEN '08:00:00' AND '18:00:00'
        THEN 1 END)                                    AS llamadas_fuera_horario,

    CASE
        WHEN COUNT(*) >= 20
         AND fn_contar_dias_habiles(MAX(dFecha), CURDATE()) <= 1  THEN 'CENTRO_CRITICO_ACTIVO'
        WHEN COUNT(*) >= 20
         AND fn_contar_dias_habiles(MAX(dFecha), CURDATE()) > 3   THEN 'CENTRO_ALTO_VOLUMEN_INACTIVO'
        WHEN COUNT(*) >= 10                                        THEN 'CENTRO_VOLUMEN_MEDIO'
        ELSE                                                            'CENTRO_BAJO_VOLUMEN'
    END                                                AS clasificacion_centro

-- C-02: tabla real en lugar de "llamadas_Q3"
FROM tbl_historico_t3_2025
WHERE cDID_Centro_Transferencia IS NOT NULL
  AND cDID_Centro_Transferencia != ''
  AND dFecha BETWEEN @Q3_inicio AND @Q3_fin
  AND cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)

GROUP BY id_CTransferencia

-- C-01: columna que SÍ existe en el SELECT
ORDER BY total_llamadas DESC, fecha_ultima_actividad DESC;
