SELECT 
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;

/*********************************************************************************************
    Script          : sp_rpt_centros_xsegmento.sql
    Version         : 2.2.2
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
    Despliegue      : mysql --socket=/var/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_centros_xsegmento.sql
    Notas           : v2.2.0: DENSE_RANK() por volumen dentro de cada segmento (Modulo 13).
                      DENSE_RANK elegido sobre RANK porque existen empates en volúmenes bajos
                      (verificado: 2 centros con 20 llamadas y 2 con 18 en Q01_25).
                      RANK produce brechas (24,24,26,26,28); DENSE_RANK produce secuencia continua (24,24,25,25,26).
                      v2.1.0: 3 CTEs eliminan evaluaciones redundantes de agregados y funciones WHILE (H-IACT-002).
                      UC_RPT_01 / UC_RPT_15. Despues del despliegue ejecutar provision-mariadb.sh.
*********************************************************************************************/

-- DEFINICIÓN

DELIMITER $$

CREATE OR REPLACE PROCEDURE sp_rpt_centros_xsegmento(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    -- SIGNAL: validación de parámetros (Modulo 17 — equivalente a THROW/RAISERROR).
    -- SQLSTATE '22023' = Invalid parameter value (estandar SQL).
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_centros_xsegmento', '22023', 1644,
                p_quarter,
                CONCAT('p_quarter invalido: ', p_quarter),
                'django_api');
    END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY';
    END IF;

    -- CTE 1: agregar base_ivr_detalle por trimestre × segmento × centro.
    -- primera_act y ultima_act se calculan UNA sola vez en el GROUP BY.
    -- El nivel siguiente recibe escalares — no re-evalúa MAX/MIN ni STR_TO_DATE.
    WITH centros AS (
        SELECT
            b.trimestre
            , b.segmento
            , b.centro_transferencia
            , SUM(b.total_llamadas)        AS total_llamadas
            , SUM(b.misma_linea)           AS misma_linea
            , SUM(b.linea_diferente)       AS linea_diferente
            , SUM(b.no_digito_telefono)    AS no_digito_telefono
            , SUM(b.llamadas_entre_semana) AS llamadas_entre_semana
            , SUM(b.llamadas_fines_semana) AS llamadas_fines_semana
            , STR_TO_DATE(CONCAT(MIN(b.fecha), '01'), '%Y%m%d')
                                           AS primera_act
            , LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d'))
                                           AS ultima_act
        FROM base_ivr_detalle b
        WHERE b.trimestre = p_quarter
          AND b.centro_transferencia NOT IN
              ('CASO_NULL', 'CASO_ERROR_CEROS', 'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO')
        GROUP BY
            b.trimestre
            , b.segmento
            , b.centro_transferencia
    )

    -- CTE 2: calcular métricas de calendario UNA sola vez por centro.
    -- dias_sin_actividad se materializa aquí para que el SELECT final
    -- lo use en el CASE sin re-invocar ivr_contar_dias_semana.
    , centros_calendario AS (
        SELECT
            c.trimestre
            , c.segmento
            , c.centro_transferencia
            , c.total_llamadas
            , c.misma_linea
            , c.linea_diferente
            , c.no_digito_telefono
            , c.llamadas_entre_semana
            , c.llamadas_fines_semana
            , c.primera_act
            , c.ultima_act
            , ivr_contar_dias_semana(c.primera_act, c.ultima_act)
                                           AS dias_semana_periodo
            , ivr_contar_dias_semana(c.ultima_act, CURDATE())
                                           AS dias_sin_actividad
            , ivr_agregar_dias_semana(c.ultima_act, 1)
                                           AS fecha_seguimiento_1_dia
            , ivr_agregar_dias_semana(c.ultima_act, 3)
                                           AS fecha_seguimiento_3_dias
            , ivr_agregar_dias_semana(c.ultima_act, 5)
                                           AS fecha_escalamiento
        FROM centros c
    )

    -- CTE 3: totales por segmento para pct_del_segmento.
    -- Un solo scan de base_ivr_detalle — elimina la subconsulta correlacionada.
    , totales_segmento AS (
        SELECT
            segmento
            , SUM(total_llamadas) AS total_seg
        FROM base_ivr_detalle
        WHERE trimestre = p_quarter
        GROUP BY segmento
    )

    SELECT
        cc.trimestre
        , cc.segmento
        , cc.centro_transferencia

        -- Volumen
        , cc.total_llamadas
        , cc.misma_linea
        , cc.linea_diferente
        , cc.no_digito_telefono

        -- Distribución por tipo de día (pre-computada en el ETL)
        , cc.llamadas_entre_semana
        , cc.llamadas_fines_semana
        , ROUND(
            cc.llamadas_entre_semana
            / NULLIF(cc.total_llamadas, 0) * 100, 1
          )                                AS pct_entre_semana

        -- Rango de actividad
        , cc.primera_act                   AS primera_actividad
        , cc.ultima_act                    AS ultima_actividad

        -- Métricas de calendario (calculadas en centros_calendario)
        , cc.dias_semana_periodo
        , cc.dias_sin_actividad            AS dias_semana_sin_actividad
        , cc.fecha_seguimiento_1_dia
        , cc.fecha_seguimiento_3_dias
        , cc.fecha_escalamiento

        -- Clasificación SLA: cc.dias_sin_actividad es un escalar —
        -- no invoca ivr_contar_dias_semana en cada WHEN
        , CASE
            WHEN cc.total_llamadas >= 1000
             AND cc.dias_sin_actividad = 0
                THEN 'ACTIVO_HOY'
            WHEN cc.total_llamadas >= 1000
             AND cc.dias_sin_actividad <= 3
                THEN 'DENTRO_SLA'
            WHEN cc.total_llamadas >= 1000
             AND cc.dias_sin_actividad <= 5
                THEN 'RIESGO_SLA'
            WHEN cc.total_llamadas >= 1000
                THEN 'FUERA_SLA'
            WHEN cc.total_llamadas >= 100
                THEN 'VOLUMEN_MEDIO'
            ELSE 'BAJO_VOLUMEN'
          END                              AS clasificacion_sla

        -- % del total del quarter para ese segmento (JOIN elimina subconsulta correlacionada)
        , ROUND(
            cc.total_llamadas
            / NULLIF(ts.total_seg, 0) * 100, 4
          )                                AS pct_del_segmento

        -- Posición del centro por volumen dentro de su segmento.
        -- DENSE_RANK elegido sobre RANK: existen empates en volúmenes bajos
        -- (Q01_25: 2 centros con 20 llamadas, 2 con 18). RANK produce brechas
        -- en la secuencia (24,24,26,26,28); DENSE_RANK mantiene continuidad
        -- (24,24,25,25,26) y su máximo coincide con el número de niveles de
        -- volumen distintos — interpretación más directa para priorización.
        , DENSE_RANK() OVER (
            PARTITION BY cc.segmento
            ORDER BY cc.total_llamadas DESC
          )                                AS rango_en_segmento

    FROM centros_calendario cc
    INNER JOIN totales_segmento ts
        ON ts.segmento = cc.segmento
    ORDER BY
        cc.segmento
        , cc.total_llamadas DESC;
END$$

DELIMITER ;

-- VERIFICACIÓN

-- Ejemplo:
-- CALL sp_rpt_centros_xsegmento('Q02_26');
SELECT 
    ROUTINE_NAME as nombre
    , ROUTINE_TYPE as tipo
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'ivr_legacy'
    AND ROUTINE_NAME = 'sp_rpt_centros_xsegmento';

-- FINALIZACIÓN

SELECT 
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
