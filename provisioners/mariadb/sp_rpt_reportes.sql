-- =============================================================================
-- sp_rpt_reportes.sql
-- Stored Procedures de reporte IVR — consumidos por Django REST Framework
-- Versión: 2.0.0
--
-- PREREQUISITOS (en orden):
--   1. funciones_utilidad.sql
--   2. schema_base_ivr.sql
--   3. sp_etl_pipeline.sql  (para que base_ivr_* tenga datos)
--
-- SPs CREADOS:
--   sp_rpt_clientes                — UC_RPT_17 — clientes únicos por quarter
--   sp_rpt_centros_transferencia   — UC_RPT_15 — detalle por fecha×centro×menu×opcion
--   sp_rpt_llamadas_abandonadas    — UC_RPT_13 — tasa de abandono
--   sp_rpt_menu_redirigidos        — UC_RPT_16 — menú → centro
--   sp_rpt_menu_centro             — UC_RPT_16 — centro → menú+opción
--   sp_rpt_cMENU_ERROR             — UC_RPT_16 — anomalías cMenu=teléfono
--   sp_rpt_centros_xsegmento       — UC_RPT_01 — KPIs con SLA y dias de semana (lunes-viernes)
--
-- CONVENCIÓN DE PARÁMETROS (todos los SPs):
--   p_quarter  VARCHAR(10)  — 'Q01_25' | 'Q02_25' | ... | 'Q02_26'
--   p_segmento VARCHAR(20)  — 'todas' | 'nacional_A' | 'nacional_B' | 'puebla'
--
-- PATRÓN DE FILTRO (equivalente al @FORM de FUNC_REPORTE_COBRANZA):
--   WHERE (p_segmento = 'todas' OR b.segmento = p_segmento)
--   Un solo SELECT — evita la duplicación de 3 bloques IF que genera bugs.
--
-- NORMALIZACIÓN EN LOS SPs DE REPORTE:
--   UPPER(TRIM(b.menu)) — los SPs aplican UPPER para presentación.
--   El ETL almacena mixed case (valor raw de la fuente).
--   Ref: REPORTE-PROM-LLAMADAS.md H-1, REPORTE-C-MENU.md H-1
-- =============================================================================

DELIMITER $$


-- =============================================================================
-- sp_rpt_clientes
-- Clientes únicos por quarter y segmento.
-- Lee base_ivr_clientes (3 filas por quarter — una por segmento).
-- UC_RPT_17
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_clientes$$
CREATE PROCEDURE sp_rpt_clientes(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    SELECT
        c.trimestre,
        c.segmento,
        c.clientes_unicos,
        -- Total del quarter para calcular % por segmento
        ROUND(
            c.clientes_unicos
            / (SELECT SUM(c2.clientes_unicos)
               FROM base_ivr_clientes c2
               WHERE c2.trimestre = p_quarter)
            * 100, 2
        )                       AS pct_del_total,
        c.cargado_en            AS ultima_actualizacion
    FROM base_ivr_clientes c
    WHERE c.trimestre = p_quarter
    ORDER BY c.clientes_unicos DESC;
END$$


-- =============================================================================
-- sp_rpt_centros_transferencia
-- Detalle de transferencias: fecha × segmento × centro × menú × opción.
-- Incluye métricas de comportamiento del llamante.
-- UC_RPT_15
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_centros_transferencia$$
CREATE PROCEDURE sp_rpt_centros_transferencia(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.fecha,                                     -- YYYYMM
        b.segmento,
        b.centro_transferencia,
        UPPER(TRIM(b.menu))          AS menu,         -- UPPERCASE para presentación
        b.opcion,
        b.total_llamadas,
        ROUND(
            b.total_llamadas
            / (SELECT SUM(b2.total_llamadas)
               FROM base_ivr_detalle b2
               WHERE b2.trimestre = p_quarter
                 AND b2.fecha     = b.fecha
                 AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
              ) * 100, 7
        )                            AS porcentaje,
        b.misma_linea,
        b.linea_diferente,
        b.no_digito_telefono,
        b.llamadas_entre_semana,
        b.llamadas_fines_semana
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
    ORDER BY b.fecha, b.segmento, b.total_llamadas DESC;
END$$


-- =============================================================================
-- sp_rpt_llamadas_abandonadas
-- Tasa de abandono por menú para el quarter y segmento indicados.
-- Abandono definido por D-ETL-006:
--   menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
-- Umbrales recalibrados (D-ETL-007):
--   < 20% óptimo | 20–30% aceptable | > 30% crítico
-- UC_RPT_13
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_llamadas_abandonadas$$
CREATE PROCEDURE sp_rpt_llamadas_abandonadas(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    -- Total del quarter + segmento (denominador para %)
    DECLARE v_total_quarter BIGINT DEFAULT 0;

    SELECT SUM(total_llamadas)
    INTO v_total_quarter
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento);

    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))                          AS menu,
        SUM(b.total_llamadas)                        AS total_abandonadas,
        -- % respecto al total del quarter/segmento
        ROUND(SUM(b.total_llamadas) / v_total_quarter * 100, 2)
                                                     AS pct_del_total,
        -- % respecto a cada segmento individualmente (para comparar A vs B vs Puebla)
        ROUND(
            SUM(b.total_llamadas)
            / (SELECT SUM(b3.total_llamadas)
               FROM base_ivr_detalle b3
               WHERE b3.trimestre = p_quarter
                 AND b3.segmento  = b.segmento
              ) * 100, 2
        )                                            AS pct_del_segmento,
        -- Clasificación SLA (D-ETL-007 recalibrado)
        CASE
            WHEN ROUND(SUM(b.total_llamadas) / v_total_quarter * 100, 2) < 20
                THEN 'OPTIMO'
            WHEN ROUND(SUM(b.total_llamadas) / v_total_quarter * 100, 2) <= 30
                THEN 'ACEPTABLE'
            ELSE 'CRITICO'
        END                                          AS clasificacion_sla
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.trimestre, b.segmento, b.menu
    ORDER BY b.segmento, total_abandonadas DESC;
END$$


-- =============================================================================
-- sp_rpt_menu_redirigidos
-- Perspectiva menú → centro de transferencia.
-- Responde: ¿a qué centros redirige cada menú y con qué volumen?
-- UC_RPT_16
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_menu_redirigidos$$
CREATE PROCEDURE sp_rpt_menu_redirigidos(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))          AS menu,
        b.centro_transferencia,
        SUM(b.total_llamadas)        AS total_llamadas,
        -- % de ese menú que va a ese centro
        ROUND(
            SUM(b.total_llamadas)
            / (SELECT SUM(b2.total_llamadas)
               FROM base_ivr_detalle b2
               WHERE b2.trimestre = p_quarter
                 AND b2.menu      = b.menu
                 AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
              ) * 100, 2
        )                            AS pct_del_menu,
        -- % del total del quarter
        ROUND(
            SUM(b.total_llamadas)
            / (SELECT SUM(b3.total_llamadas)
               FROM base_ivr_detalle b3
               WHERE b3.trimestre = p_quarter
                 AND (p_segmento = 'todas' OR b3.segmento = p_segmento)
              ) * 100, 4
        )                            AS pct_del_total
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu != 'VACIO'          -- excluir llamadas sin menú identificado
      AND b.centro_transferencia NOT IN ('CASO_NULL', 'CASO_ERROR_CEROS')
    GROUP BY b.trimestre, b.segmento, b.menu, b.centro_transferencia
    ORDER BY b.segmento, UPPER(TRIM(b.menu)), total_llamadas DESC;
END$$


-- =============================================================================
-- sp_rpt_menu_centro
-- Perspectiva inversa: centro de transferencia → menús y opciones que lo alimentan.
-- Responde: ¿qué menús terminan en este centro y con qué opciones?
-- UC_RPT_16
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_menu_centro$$
CREATE PROCEDURE sp_rpt_menu_centro(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        b.centro_transferencia,
        UPPER(TRIM(b.menu))          AS menu,
        b.opcion,
        SUM(b.total_llamadas)        AS total_llamadas,
        -- % que representa este menu+opcion dentro del centro
        ROUND(
            SUM(b.total_llamadas)
            / (SELECT SUM(b2.total_llamadas)
               FROM base_ivr_detalle b2
               WHERE b2.trimestre            = p_quarter
                 AND b2.centro_transferencia = b.centro_transferencia
                 AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
              ) * 100, 2
        )                            AS pct_del_centro,
        SUM(b.misma_linea)           AS misma_linea,
        SUM(b.linea_diferente)       AS linea_diferente,
        SUM(b.no_digito_telefono)    AS no_digito_telefono
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.centro_transferencia NOT IN
          ('CASO_NULL', 'CASO_ERROR_CEROS', 'ERROR_CARACTER_INICIAL')
    GROUP BY b.trimestre, b.segmento, b.centro_transferencia,
             b.menu, b.opcion
    ORDER BY b.segmento, b.centro_transferencia,
             total_llamadas DESC;
END$$


-- =============================================================================
-- sp_rpt_cMENU_ERROR
-- Anomalías donde cMenu contiene un número de teléfono en lugar de un menú.
-- En base_ivr_detalle se almacenan como el número raw (no como 'telefono_cMenu').
-- El reporte agrupa todos bajo el sentinel 'telefono_cMenu' para presentación.
-- Ref: REPORTE-C-MENU.md H-6, REPORTE-LLAMADAS-CMENU.md H-5
-- UC_RPT_16
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_cMENU_ERROR$$
CREATE PROCEDURE sp_rpt_cMENU_ERROR(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        'telefono_cMenu'             AS tipo_anomalia,
        b.menu                       AS valor_cMenu_raw,  -- teléfono real del llamante
        b.centro_transferencia,      -- siempre 19020086 (bucket de abandono)
        SUM(b.total_llamadas)        AS total_llamadas,
        -- Total de anomalías en el quarter/segmento
        (SELECT SUM(b2.total_llamadas)
         FROM base_ivr_detalle b2
         WHERE b2.trimestre = p_quarter
           AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
           AND b2.menu REGEXP '^[0-9]+$'
           AND LENGTH(b2.menu) >= 7
        )                            AS total_anomalias_quarter
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      -- Detectar números de teléfono: solo dígitos, longitud >= 7
      AND b.menu REGEXP '^[0-9]+$'
      AND LENGTH(b.menu) >= 7
    GROUP BY b.trimestre, b.segmento, b.menu, b.centro_transferencia
    ORDER BY b.segmento, total_llamadas DESC;
END$$


-- =============================================================================
-- sp_rpt_centros_xsegmento
-- KPIs por centro de transferencia con clasificacion SLA y dias de semana.
-- El SP más complejo — usa todas las funciones de utilidad.
-- Requiere llamadas_entre_semana y llamadas_fines_semana en base_ivr_detalle
-- (pre-computados en el ETL con ivr_es_dia_semana).
-- UC_RPT_01, UC_RPT_15
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_rpt_centros_xsegmento$$
CREATE PROCEDURE sp_rpt_centros_xsegmento(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        b.centro_transferencia,

        -- Volumen
        SUM(b.total_llamadas)                        AS total_llamadas,
        SUM(b.misma_linea)                           AS misma_linea,
        SUM(b.linea_diferente)                       AS linea_diferente,
        SUM(b.no_digito_telefono)                    AS no_digito_telefono,

        -- Distribución por tipo de día (pre-computada en el ETL)
        SUM(b.llamadas_entre_semana)                 AS llamadas_entre_semana,
        SUM(b.llamadas_fines_semana)                 AS llamadas_fines_semana,
        ROUND(
            SUM(b.llamadas_entre_semana)
            / NULLIF(SUM(b.total_llamadas), 0) * 100, 1
        )                                            AS pct_entre_semana,

        -- Rango de actividad (primer y último mes con datos)
        STR_TO_DATE(CONCAT(MIN(b.fecha), '01'), '%Y%m%d')
                                                     AS primera_actividad,
        LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d'))
                                                     AS ultima_actividad,

        -- Dias lunes-viernes del periodo de actividad
        ivr_contar_dias_semana(
            STR_TO_DATE(CONCAT(MIN(b.fecha), '01'), '%Y%m%d'),
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d'))
        )                                            AS dias_semana_periodo,

        -- Dias lunes-viernes transcurridos desde la ultima actividad hasta hoy
        ivr_contar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
            CURDATE()
        )                                            AS dias_semana_sin_actividad,

        -- Fechas de seguimiento (SLA operativo del equipo)
        ivr_agregar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')), 1
        )                                            AS fecha_seguimiento_1_dia,
        ivr_agregar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')), 3
        )                                            AS fecha_seguimiento_3_dias,
        ivr_agregar_dias_semana(
            LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')), 5
        )                                            AS fecha_escalamiento,

        -- Clasificación SLA
        -- Basada en volumen total y dias de semana sin actividad reciente
        -- Ref: ANALISIS-ARQUITECTURA-ETL.md, BR-016 recalibrado (D-ETL-007)
        CASE
            WHEN SUM(b.total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                     LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
                     CURDATE()) = 0
                THEN 'ACTIVO_HOY'
            WHEN SUM(b.total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                     LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
                     CURDATE()) <= 3
                THEN 'DENTRO_SLA'
            WHEN SUM(b.total_llamadas) >= 1000
             AND ivr_contar_dias_semana(
                     LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d')),
                     CURDATE()) <= 5
                THEN 'RIESGO_SLA'
            WHEN SUM(b.total_llamadas) >= 1000
                THEN 'FUERA_SLA'
            WHEN SUM(b.total_llamadas) >= 100
                THEN 'VOLUMEN_MEDIO'
            ELSE 'BAJO_VOLUMEN'
        END                                          AS clasificacion_sla,

        -- % del total del quarter para ese segmento
        ROUND(
            SUM(b.total_llamadas)
            / (SELECT SUM(b2.total_llamadas)
               FROM base_ivr_detalle b2
               WHERE b2.trimestre = p_quarter
                 AND b2.segmento  = b.segmento
              ) * 100, 4
        )                                            AS pct_del_segmento

    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      -- Excluir sentinels de error — centros que no son VDNs reales
      AND b.centro_transferencia NOT IN
          ('CASO_NULL', 'CASO_ERROR_CEROS', 'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO')
    GROUP BY
        b.trimestre,
        b.segmento,
        b.centro_transferencia
    ORDER BY
        b.segmento,
        total_llamadas DESC;
END$$

DELIMITER ;

-- =============================================================================
-- VERIFICACIÓN — ejecutar después de que base_ivr_* tenga datos
-- =============================================================================
-- CALL sp_rpt_clientes('Q01_25');
-- CALL sp_rpt_centros_transferencia('Q01_25', 'nacional_A');
-- CALL sp_rpt_llamadas_abandonadas('Q01_25', 'todas');
-- CALL sp_rpt_menu_redirigidos('Q01_25', 'puebla');
-- CALL sp_rpt_menu_centro('Q01_25', 'nacional_A');
-- CALL sp_rpt_cMENU_ERROR('Q03_25', 'todas');
-- CALL sp_rpt_centros_xsegmento('Q01_25');
