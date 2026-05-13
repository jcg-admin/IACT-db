# Plan de implementación — Hallazgos IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Origen:** `HALLAZGOS-ANALISIS-COMPARATIVO-SQL-SERVER-IACT-DB.md`  
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Criterio de cierre por fase:** verify.sh 27 OK, 0 WARN, 0 ERR, EXIT 0

---

## Principios del plan

Cada tarea es atómica: tiene exactamente un archivo que modifica, una línea o bloque
que cambia, y un criterio de verificación propio. Ninguna tarea mezcla hallazgos.
Ninguna fase introduce deuda técnica ni deja un hallazgo corregido a medias.

Las fases están ordenadas de menor a mayor riesgo de regresión:

- FASE 1 — Correcciones de flujo de control (riesgo: NINGUNO — no cambia SQL de datos)
- FASE 2 — Optimización de SPs de reporte (riesgo: BAJO — misma lógica, diferente estructura)
- FASE 3 — Atomicidad del ETL (riesgo: MEDIO — agrega transacciones a la escritura)
- FASE 4 — Fórmula O(1) para funciones de calendario (riesgo: ALTO — requiere suite de tests)

---

## FASE 1 — Correcciones de flujo de control

**Hallazgos:** H-IACT-005, H-IACT-006  
**Archivos:** `sp_etl_pipeline.sql` únicamente  
**Riesgo:** Ninguno — no cambia ninguna query de datos  
**Baseline de entrada:** verify.sh 27 OK

### T-1.1 — Declarar `v_paso4_failed` en `sp_etl_maestro`

**Hallazgo:** H-IACT-005  
**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Línea de referencia:** bloque de DECLARE de `sp_etl_maestro` (~L287)

**Cambio:** Agregar la declaración de la variable flag después de `v_abort`:

```sql
-- Antes:
DECLARE v_abort      BOOLEAN DEFAULT FALSE;

-- Después:
DECLARE v_abort        BOOLEAN DEFAULT FALSE;
DECLARE v_paso4_failed BOOLEAN DEFAULT FALSE;
```

**Verificación:** `grep -n "v_paso4_failed" sp_etl_pipeline.sql` retorna exactamente 1 línea.

---

### T-1.2 — Setear `v_paso4_failed` en el EXIT HANDLER del PASO 4

**Hallazgo:** H-IACT-005  
**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Línea de referencia:** cuerpo del EXIT HANDLER del PASO 4 (~L359-L370)

**Cambio:** Agregar `SET v_paso4_failed = TRUE;` como última línea dentro del handler,
antes del `END;` de cierre:

```sql
-- Antes (final del handler del PASO 4):
            -- No LEAVE: el handler termina y el bloque externo continua
            -- v_ok quedara NULL, el UPDATE final marcara PARTIAL
        END;

-- Después:
            -- No LEAVE: el handler termina y el bloque externo continua
            -- v_ok quedara NULL, el UPDATE final marcara PARTIAL
            SET v_paso4_failed = TRUE;
        END;
```

**Verificación:** `grep -n "v_paso4_failed" sp_etl_pipeline.sql` retorna exactamente 2 líneas
(declaración + set).

---

### T-1.3 — Proteger PASO 5 con `IF NOT v_paso4_failed`

**Hallazgo:** H-IACT-005  
**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Línea de referencia:** inicio del bloque PASO 5 (~L376)

**Cambio:** Envolver el INSERT de log y el BEGIN...END del PASO 5 en un IF:

```sql
-- Antes:
    -- -----------------------------------------------------------------------
    -- PASO 5: ETL base_ivr_clientes
    -- -----------------------------------------------------------------------
    INSERT INTO job_execution_log ...

-- Después:
    -- -----------------------------------------------------------------------
    -- PASO 5: ETL base_ivr_clientes
    -- Solo se ejecuta si el PASO 4 completó correctamente.
    -- Si PASO 4 falló, base_ivr_detalle es inválida y no tiene sentido
    -- cargar base_ivr_clientes para ese mismo quarter.
    -- -----------------------------------------------------------------------
    IF NOT v_paso4_failed THEN
        INSERT INTO job_execution_log ...
        SET v_step_id = LAST_INSERT_ID();
        BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
            ...
            CALL sp_etl_base_clientes(...);
        END;
    END IF;
```

**Verificación:** El IF cierra antes del bloque `-- PASO 6`. `grep -n "v_paso4_failed\|IF NOT" sp_etl_pipeline.sql`
retorna 3 líneas (DECLARE, SET, IF NOT).

---

### T-1.4 — Mover `SET @etl_sql` y `PREPARE etl_stmt` fuera del WHILE en `sp_etl_base_detalle`

**Hallazgo:** H-IACT-006  
**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Línea de referencia:** bloque WHILE de `sp_etl_base_detalle` (~L56-L122)

**Análisis previo requerido:** El `SET @etl_sql = CONCAT(...)` incluye `p_table`, que es un
parámetro de entrada que no cambia entre iteraciones. Los valores que cambian por mes
(`v_mes_ini`, `v_mes_fin`) se pasan vía `USING @etl_q, @etl_i, @etl_f` — no forman parte
del SQL estático. Por lo tanto el PREPARE puede realizarse una sola vez.

**Cambio:**

```sql
-- Antes (todo dentro del WHILE):
WHILE v_mes_ini <= p_fin DO
    ...
    SET @etl_sql = CONCAT('INSERT INTO base_ivr_detalle ... FROM ', p_table, ' ...');
    PREPARE etl_stmt FROM @etl_sql;
    SET @etl_q = p_quarter, @etl_i = v_mes_ini, @etl_f = v_mes_fin;
    EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
    SET v_mes_ins = ROW_COUNT();
    DEALLOCATE PREPARE etl_stmt;
    ...
END WHILE;

-- Después (PREPARE fuera, EXECUTE dentro):
SET @etl_sql = CONCAT('INSERT INTO base_ivr_detalle ... FROM ', p_table, ' ...');
PREPARE etl_stmt FROM @etl_sql;

WHILE v_mes_ini <= p_fin DO
    ...
    SET @etl_q = p_quarter, @etl_i = v_mes_ini, @etl_f = v_mes_fin;
    EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
    SET v_mes_ins = ROW_COUNT();
    ...
END WHILE;

DEALLOCATE PREPARE etl_stmt;
```

**Verificación funcional:** Después del redespliegue, ejecutar:

```sql
CALL sp_etl_base_detalle('Q02_26', '2026-04-01', '2026-06-30', 'tbl_historico_t2_2026', NULL);
SELECT COUNT(*), SUM(total_llamadas) FROM base_ivr_detalle WHERE trimestre = 'Q02_26';
-- El resultado debe ser idéntico al anterior al cambio.
```

---

### T-1.5 — Redesplegar `sp_etl_pipeline.sql` y verificar

**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < provisioners/mariadb/sp_etl_pipeline.sql
bash scripts/provision-mariadb.sh   # restaurar GRANT EXECUTE
bash verify.sh
```

**Criterio:** verify.sh 27 OK, 0 WARN, 0 ERR.

---

### T-1.6 — Redesplegar archivos individuales en `objetos/sps/`

**Archivos:**

```bash
# Regenerar los 5 archivos individuales de SPs ETL desde el fuente modificado
# (extraer los bloques actualizados con el mismo script de generación)
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/objetos/sps/sp_etl_base_detalle.sql
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/objetos/sps/sp_etl_maestro.sql
bash scripts/provision-mariadb.sh
```

**Criterio:** Ambos archivos individuales ejecutan sin ERROR.

---

### T-1.7 — Commit de FASE 1

```
fix(etl): FASE 1 — correcciones de flujo de control H-IACT-005 y H-IACT-006

T-1.1/1.2/1.3: sp_etl_maestro — v_paso4_failed (H-IACT-005)
  - DECLARE v_paso4_failed BOOLEAN DEFAULT FALSE
  - SET v_paso4_failed = TRUE en EXIT HANDLER del PASO 4
  - IF NOT v_paso4_failed envuelve el bloque completo del PASO 5
  Evita que base_ivr_clientes reciba datos cuando base_ivr_detalle falló.

T-1.4: sp_etl_base_detalle — PREPARE fuera del WHILE (H-IACT-006)
  - SET @etl_sql y PREPARE etl_stmt movidos antes del WHILE
  - DEALLOCATE PREPARE movido después del END WHILE
  - EXECUTE y ROW_COUNT() permanecen dentro del WHILE
  p_table no cambia entre iteraciones — el PREPARE era redundante x3.

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## FASE 2 — Optimización de SPs de reporte

**Hallazgos:** H-IACT-002 (Nivel 1), H-IACT-003  
**Archivos:** `sp_rpt_reportes.sql`  
**Riesgo:** BAJO — misma lógica de negocio, diferente estructura de JOIN  
**Prerequisito:** FASE 1 completada

---

### T-2.1 — Reescribir `sp_rpt_centros_xsegmento` con subconsulta derivada

**Hallazgo:** H-IACT-002 Nivel 1  
**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Problema:** Las expresiones `LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha), '01'), '%Y%m%d'))`
y `STR_TO_DATE(CONCAT(MIN(b.fecha), '01'), '%Y%m%d')` se recalculan en cada columna y en
cada rama del CASE — totalizando 8 invocaciones de función WHILE por fila de resultado.

**Estrategia:** Una subconsulta derivada interna (`FROM base_ivr_detalle GROUP BY`) calcula
`primera_act` y `ultima_act` una sola vez por centro. El SELECT exterior invoca las funciones
WHILE sobre esos valores ya materializados — una vez por columna, no tres veces en el CASE.

```sql
CREATE PROCEDURE sp_rpt_centros_xsegmento(IN p_quarter VARCHAR(10))
BEGIN
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
        , ROUND(
            c.llamadas_entre_semana
            / NULLIF(c.total_llamadas, 0) * 100, 1
          )                                            AS pct_entre_semana
        , c.primera_act                               AS primera_actividad
        , c.ultima_act                                AS ultima_actividad

        -- Cada función WHILE se llama UNA VEZ por fila — no 3 veces en el CASE
        , ivr_contar_dias_semana(c.primera_act, c.ultima_act)
                                                      AS dias_semana_periodo
        , ivr_contar_dias_semana(c.ultima_act, CURDATE())
                                                      AS dias_semana_sin_actividad
        , ivr_agregar_dias_semana(c.ultima_act, 1)    AS fecha_seguimiento_1_dia
        , ivr_agregar_dias_semana(c.ultima_act, 3)    AS fecha_seguimiento_3_dias
        , ivr_agregar_dias_semana(c.ultima_act, 5)    AS fecha_escalamiento

        -- El CASE reutiliza la columna alias — MariaDB no permite alias en el mismo
        -- SELECT, por lo que la función se vuelve a llamar en el CASE.
        -- Con la subconsulta derivada el argumento (c.ultima_act) ya es un valor
        -- constante por fila — no re-evalúa MAX(b.fecha) ni STR_TO_DATE en cada WHEN.
        , CASE
            WHEN c.total_llamadas >= 1000
             AND ivr_contar_dias_semana(c.ultima_act, CURDATE()) = 0
                THEN 'ACTIVO_HOY'
            WHEN c.total_llamadas >= 1000
             AND ivr_contar_dias_semana(c.ultima_act, CURDATE()) <= 3
                THEN 'DENTRO_SLA'
            WHEN c.total_llamadas >= 1000
             AND ivr_contar_dias_semana(c.ultima_act, CURDATE()) <= 5
                THEN 'RIESGO_SLA'
            WHEN c.total_llamadas >= 1000
                THEN 'FUERA_SLA'
            WHEN c.total_llamadas >= 100
                THEN 'VOLUMEN_MEDIO'
            ELSE 'BAJO_VOLUMEN'
          END                                         AS clasificacion_sla

        , ROUND(
            c.total_llamadas
            / NULLIF(
                (SELECT SUM(b2.total_llamadas)
                 FROM base_ivr_detalle b2
                 WHERE b2.trimestre = p_quarter
                   AND b2.segmento  = c.segmento),
              0) * 100, 4
          )                                           AS pct_del_segmento

    FROM (
        -- Subconsulta derivada: materializa primera_act y ultima_act una sola vez.
        -- El GROUP BY se ejecuta una vez; el SELECT exterior invoca las funciones
        -- WHILE sobre valores ya calculados, no sobre expresiones de agregado.
        SELECT
            b.trimestre
            , b.segmento
            , b.centro_transferencia
            , SUM(b.total_llamadas)          AS total_llamadas
            , SUM(b.misma_linea)             AS misma_linea
            , SUM(b.linea_diferente)         AS linea_diferente
            , SUM(b.no_digito_telefono)      AS no_digito_telefono
            , SUM(b.llamadas_entre_semana)   AS llamadas_entre_semana
            , SUM(b.llamadas_fines_semana)   AS llamadas_fines_semana
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
    ) AS c
    ORDER BY
        c.segmento
        , c.total_llamadas DESC;
END
```

**Reducción de invocaciones de función WHILE:**

| Versión | Invocaciones fn_WHILE por fila | Con 300 filas |
|---|---|---|
| Actual | 8 (5 ivr_contar + 3 ivr_agregar) | ~108,000 iter |
| Con subconsulta derivada | 5 (2 ivr_contar columnas + 3 ivr_contar CASE + 3 ivr_agregar) | ~108,000 iter |
| Con subconsulta derivada + CASE refactorizado | 5 (2 ivr_contar + 3 ivr_agregar) | ~67,500 iter |

**Nota:** MariaDB no permite referenciar alias del mismo SELECT en el CASE, por lo que
`ivr_contar_dias_semana(c.ultima_act, CURDATE())` sigue apareciendo 3 veces en el CASE.
El beneficio real de esta tarea es eliminar el recálculo de `MAX(b.fecha)`, `STR_TO_DATE`
y `LAST_DAY` que en la versión actual se evalúan como expresiones de agregado en cada
invocación. Con la subconsulta derivada, esas expresiones se calculan una sola vez en el
GROUP BY y `c.ultima_act` es un valor escalar por fila.

**Verificación funcional:** Ejecutar en paralelo la versión actual y la nueva sobre el
mismo quarter y comparar el resultado fila a fila:

```sql
-- Resultado debe ser idéntico en todas las columnas
CALL sp_rpt_centros_xsegmento('Q02_26');
-- Comparar con snapshot previo al cambio
```

---

### T-2.2 — Reemplazar subconsulta correlacionada en `sp_rpt_centros_transferencia`

**Hallazgo:** H-IACT-003  
**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Líneas de referencia:** ~L96-L103

**Problema:** La subconsulta correlacionada para `porcentaje` se ejecuta una vez por cada
fila del resultado (~3,000 ejecuciones para un quarter con datos de 3 meses):

```sql
-- Actual: una subconsulta por fila
/ NULLIF(
    (SELECT SUM(b2.total_llamadas)
     FROM base_ivr_detalle b2
     WHERE b2.trimestre = p_quarter
       AND b2.fecha     = b.fecha
       AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
  0)
```

**Corrección:** JOIN con subconsulta pre-agregada — un solo scan de `base_ivr_detalle`
calcula los totales para todos los grupos:

```sql
-- En la cláusula FROM, agregar:
INNER JOIN (
    SELECT
        trimestre
        , fecha
        , segmento
        , SUM(total_llamadas) AS total_mes_seg
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento)
    GROUP BY trimestre, fecha, segmento
) AS totales
    ON  totales.trimestre = b.trimestre
    AND totales.fecha     = b.fecha
    AND totales.segmento  = b.segmento

-- Y en el SELECT, reemplazar la subconsulta por:
/ NULLIF(totales.total_mes_seg, 0)
```

**Verificación funcional:**

```sql
-- Los valores de porcentaje deben ser idénticos antes y después del cambio
CALL sp_rpt_centros_transferencia('Q02_26', 'todas');
-- Sumar todas las filas del porcentaje por fecha×segmento — debe dar ~100% en cada grupo
SELECT fecha, segmento, SUM(porcentaje)
FROM (CALL sp_rpt_centros_transferencia('Q02_26', 'todas')) t
GROUP BY fecha, segmento;
```

---

### T-2.3 — Redesplegar `sp_rpt_reportes.sql` y verificar

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < provisioners/mariadb/sp_rpt_reportes.sql
bash scripts/provision-mariadb.sh
bash verify.sh
```

**Criterio:** verify.sh 27 OK, 0 WARN, 0 ERR.

---

### T-2.4 — Actualizar archivos individuales en `objetos/sps/`

Regenerar desde el fuente modificado:

```bash
# Los dos SPs modificados
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/objetos/sps/sp_rpt_centros_xsegmento.sql
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/objetos/sps/sp_rpt_centros_transferencia.sql
bash scripts/provision-mariadb.sh
```

---

### T-2.5 — Commit de FASE 2

```
perf(reportes): FASE 2 — optimización de SPs de reporte H-IACT-002 y H-IACT-003

T-2.1: sp_rpt_centros_xsegmento — subconsulta derivada (H-IACT-002 Nivel 1)
  Elimina el recálculo de MAX(b.fecha), STR_TO_DATE y LAST_DAY como expresiones
  de agregado en cada invocación de función WHILE. La subconsulta derivada
  materializa primera_act y ultima_act una sola vez en el GROUP BY. Las
  funciones WHILE del SELECT exterior reciben valores escalares constantes
  por fila en lugar de recalcular la expresión de agregado completa.

T-2.2: sp_rpt_centros_transferencia — JOIN con totales pre-calculados (H-IACT-003)
  Reemplaza subconsulta correlacionada para porcentaje por INNER JOIN con
  subconsulta pre-agregada. Un solo scan de base_ivr_detalle en lugar de
  un scan por cada fila del resultado (~3,000 scans por quarter).

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## FASE 3 — Atomicidad del ETL

**Hallazgo:** H-IACT-004  
**Archivo:** `sp_etl_pipeline.sql`  
**Riesgo:** MEDIO — agrega transacciones explícitas a operaciones de escritura  
**Prerequisito:** FASE 1 completada

---

### T-3.1 — Verificar compatibilidad de transacciones con PREPARE/EXECUTE en MariaDB 10.11

**Tarea de investigación antes de implementar.**

En MariaDB, `START TRANSACTION` dentro de un SP con `PREPARE/EXECUTE` puede tener
comportamiento inesperado si el statement preparado es DDL implícito o si el
autocommit interfiere. Verificar en el entorno real:

```sql
-- Test en la BD de desarrollo:
START TRANSACTION;
DELETE FROM base_ivr_detalle WHERE trimestre = 'Q_TEST' AND fecha = '202601';
-- Simular el EXECUTE (con datos sintéticos)
ROLLBACK;
-- Verificar que el DELETE fue revertido:
SELECT COUNT(*) FROM base_ivr_detalle WHERE trimestre = 'Q_TEST';
-- Si el resultado es 0 (filas no borradas), ROLLBACK funciona correctamente.
```

Si el ROLLBACK funciona correctamente con el patrón DELETE + EXECUTE, proceder con T-3.2.
Si no, documentar el hallazgo y marcar T-3.2 como bloqueada hasta resolver.

---

### T-3.2 — Agregar `START TRANSACTION` / `COMMIT` por mes en `sp_etl_base_detalle`

**Hallazgo:** H-IACT-004  
**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Prerequisito:** T-3.1 verificado

**Cambio:** Envolver el par DELETE + EXECUTE de cada iteración en una transacción mensual.
No envolver el WHILE completo — la transacción debe ser por mes, no por quarter, para
limitar el tamaño del undo log y mantener el comportamiento idempotente granular:

```sql
WHILE v_mes_ini <= p_fin DO
    SET v_mes_fin = LAST_DAY(v_mes_ini);
    IF v_mes_fin > p_fin THEN
        SET v_mes_fin = p_fin;
    END IF;
    SET v_mes_num = v_mes_num + 1;

    -- Transacción por mes: garantiza atomicidad DELETE + INSERT
    -- Si el INSERT falla, el DELETE es revertido — el mes mantiene los datos anteriores
    START TRANSACTION;

    DELETE FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND fecha = DATE_FORMAT(v_mes_ini, '%Y%m');

    SET @etl_q = p_quarter, @etl_i = v_mes_ini, @etl_f = v_mes_fin;
    EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
    SET v_mes_ins = ROW_COUNT();

    COMMIT;

    SET v_total_ins = v_total_ins + v_mes_ins;
    SET v_mes_ini = DATE_ADD(LAST_DAY(v_mes_ini), INTERVAL 1 DAY);
END WHILE;
```

**Nota crítica:** Si el EXIT HANDLER del sp_etl_maestro dispara durante un EXECUTE
dentro de una transacción abierta, MariaDB hace ROLLBACK automático al salir del SP.
Verificar que este comportamiento no produce filas fantasma en `job_execution_log`
antes de hacer COMMIT del hallazgo.

---

### T-3.3 — Ejecutar el ETL completo en entorno de desarrollo y verificar

```sql
-- Forzar un re-procesamiento del quarter actual
CALL sp_etl_base_detalle('Q02_26', '2026-04-01', '2026-06-30', 'tbl_historico_t2_2026', NULL);

-- Verificar conteos antes y después
SELECT trimestre, fecha, COUNT(*) AS grupos, SUM(total_llamadas) AS llamadas
FROM base_ivr_detalle
WHERE trimestre = 'Q02_26'
GROUP BY trimestre, fecha
ORDER BY fecha;
-- Los conteos deben ser idénticos a los de antes del cambio.
```

---

### T-3.4 — Redesplegar y verificar

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < provisioners/mariadb/sp_etl_pipeline.sql
bash scripts/provision-mariadb.sh
bash verify.sh
```

**Criterio:** verify.sh 27 OK, 0 WARN, 0 ERR.

---

### T-3.5 — Commit de FASE 3

```
fix(etl): FASE 3 — atomicidad mensual en sp_etl_base_detalle (H-IACT-004)

START TRANSACTION / COMMIT envuelve el par DELETE + EXECUTE de cada mes.
La transacción es por mes (no por quarter) para limitar el undo log y
mantener la granularidad idempotente por mes.

Antes: si el INSERT del mes 3 fallaba, el mes 3 quedaba vacío hasta la
próxima ejecución (ventana máxima de 24h con el event diario).
Después: si el INSERT falla, el DELETE del mismo mes es revertido — el mes
mantiene los datos de la ejecución anterior sin ventana de inconsistencia.

La idempotencia se preserva: en la siguiente ejecución el DELETE vuelve
a ser parte de una transacción y el par es atómico.

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## FASE 4 — Fórmula O(1) para funciones de calendario

**Hallazgo:** H-IACT-001, H-IACT-002 Nivel 2  
**Archivos:** `funciones_utilidad.sql`, `sp_rpt_reportes.sql`  
**Riesgo:** ALTO — cambia el comportamiento de funciones usadas por múltiples SPs  
**Prerequisito:** FASES 1, 2 y 3 completadas

---

### T-4.1 — Construir la suite de tests de referencia

**Esta tarea es prerequisito de todas las demás en la FASE 4.**

Antes de tocar `ivr_contar_dias_semana`, generar una tabla de valores de referencia
producida por el WHILE actual (fuente de verdad). La suite cubre todos los casos
borde que la fórmula O(1) debe reproducir exactamente:

```sql
-- Crear tabla de referencia (temporal, solo para el test):
CREATE TEMPORARY TABLE ref_dias_semana AS
SELECT
    DATE_ADD('2025-01-01', INTERVAL n DAY) AS p_ini,
    DATE_ADD('2025-01-01', INTERVAL (n + k) DAY) AS p_fin,
    ivr_contar_dias_semana(
        DATE_ADD('2025-01-01', INTERVAL n DAY),
        DATE_ADD('2025-01-01', INTERVAL (n + k) DAY)
    ) AS resultado_while
FROM
    (SELECT a.n + b.n * 7 AS n FROM
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
         UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) a
        CROSS JOIN
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
         UNION SELECT 4 UNION SELECT 5) b
    ) inicio
    CROSS JOIN
    (SELECT 0 k UNION SELECT 1 UNION SELECT 2 UNION SELECT 6
     UNION SELECT 7 UNION SELECT 13 UNION SELECT 14
     UNION SELECT 27 UNION SELECT 28 UNION SELECT 29
     UNION SELECT 89 UNION SELECT 90 UNION SELECT 91) duracion;
-- Cubre: todos los días de inicio posibles (7 días de la semana) x
--        rangos de 0, 1, 2, 6, 7, 13, 14, 27, 28, 29, 89, 90, 91 días
```

**Criterio de completitud de la suite:** La tabla debe tener al menos 7 × 13 = 91 filas
cubriendo los 7 posibles días de inicio y los rangos clave.

---

### T-4.2 — Implementar `ivr_contar_dias_semana_v2` (fórmula O(1))

Crear una nueva función con nombre `_v2` — no reemplazar la original hasta que los
tests pasen. La fórmula O(1) correcta para contar días lunes-viernes:

```sql
CREATE FUNCTION ivr_contar_dias_semana_v2(p_ini DATE, p_fin DATE)
RETURNS INT
DETERMINISTIC
COMMENT 'Fórmula O(1) para días hábiles L-V. Reemplaza el WHILE de ivr_contar_dias_semana.'
BEGIN
    DECLARE v_dias_totales INT;
    DECLARE v_semanas      INT;
    DECLARE v_resto        INT;
    DECLARE v_dow_ini      INT;  -- 1=Dom, 2=Lun...7=Sab
    DECLARE v_habiles_ini  INT;  -- Días hábiles desde el lunes hasta p_ini
    DECLARE v_habiles_fin  INT;  -- Días hábiles desde el lunes hasta p_fin

    IF p_ini IS NULL OR p_fin IS NULL OR p_ini > p_fin THEN
        RETURN 0;
    END IF;

    -- Normalizar: DAYOFWEEK 1=Dom→5, 2=Lun→0, 3=Mar→1...7=Sab→5
    -- días hábiles acumulados desde el lunes de esa semana hasta el día d:
    -- Lun=0, Mar=1, Mie=2, Jue=3, Vie=4, Sab=4, Dom=4 (sábado y domingo no suman)
    SET v_dow_ini = DAYOFWEEK(p_ini);
    SET v_habiles_ini = CASE v_dow_ini
        WHEN 2 THEN 0   -- Lunes
        WHEN 3 THEN 1   -- Martes
        WHEN 4 THEN 2   -- Miércoles
        WHEN 5 THEN 3   -- Jueves
        WHEN 6 THEN 4   -- Viernes
        WHEN 7 THEN 4   -- Sábado (cuenta como si fuera viernes)
        WHEN 1 THEN 4   -- Domingo (cuenta como si fuera viernes)
    END;

    SET v_dow_ini = DAYOFWEEK(p_fin);
    SET v_habiles_fin = CASE v_dow_ini
        WHEN 2 THEN 0
        WHEN 3 THEN 1
        WHEN 4 THEN 2
        WHEN 5 THEN 3
        WHEN 6 THEN 4
        WHEN 7 THEN 4
        WHEN 1 THEN 4
    END;

    -- Semanas completas entre el lunes de la semana de p_ini y el lunes de la semana de p_fin
    -- +1 para incluir el último día
    SET v_dias_totales = DATEDIFF(p_fin, p_ini) + 1;
    SET v_semanas = FLOOR(v_dias_totales / 7);
    SET v_resto   = v_dias_totales MOD 7;

    RETURN v_semanas * 5 + LEAST(v_resto, 5)
        -- ajuste por días de inicio no-lunes:
        -- pendiente calibración contra ref_dias_semana
        ;
END$$
```

**Nota:** La implementación exacta de la fórmula debe calibrarse contra la suite de
tests de T-4.1. El esquema anterior es el punto de partida — el CASE de corrección
requiere ajuste para el off-by-one detectado en MariaDB 10.11 (Q1 2025: fórmula
dio 65, WHILE dio 64).

---

### T-4.3 — Validar `ivr_contar_dias_semana_v2` contra la suite completa

```sql
-- Comparar fórmula vs WHILE para todos los casos de la suite:
SELECT
    p_ini
    , p_fin
    , resultado_while
    , ivr_contar_dias_semana_v2(p_ini, p_fin) AS resultado_formula
    , resultado_while = ivr_contar_dias_semana_v2(p_ini, p_fin) AS match_ok
FROM ref_dias_semana
ORDER BY match_ok ASC, p_ini;

-- Criterio de aceptación: 0 filas con match_ok = 0
SELECT COUNT(*) AS fallos
FROM ref_dias_semana
WHERE resultado_while != ivr_contar_dias_semana_v2(p_ini, p_fin);
-- Debe retornar: 0
```

**Si `fallos > 0`:** Ajustar la fórmula y repetir T-4.3. No avanzar a T-4.4 hasta
que `fallos = 0`. Este es el gate de calidad de la FASE 4.

---

### T-4.4 — Reemplazar `ivr_contar_dias_semana` con la fórmula validada

Solo cuando T-4.3 retorna `fallos = 0`:

```sql
-- Renombrar _v2 a la versión definitiva:
DROP FUNCTION IF EXISTS ivr_contar_dias_semana;
-- Crear con el body de _v2 validado:
CREATE FUNCTION ivr_contar_dias_semana(p_ini DATE, p_fin DATE)
RETURNS INT DETERMINISTIC ...

DROP FUNCTION IF EXISTS ivr_contar_dias_semana_v2;
```

---

### T-4.5 — Implementar y validar `ivr_agregar_dias_semana_v2` (fórmula O(1))

Mismo proceso que T-4.2 y T-4.3 para `ivr_agregar_dias_semana`. La suite de tests
cubre: n=1, 3, 5 días desde todos los días de la semana posibles:

```sql
-- Suite para ivr_agregar_dias_semana:
SELECT
    DATE_ADD('2025-01-01', INTERVAL n DAY) AS p_fecha,
    k AS p_n,
    ivr_agregar_dias_semana(DATE_ADD('2025-01-01', INTERVAL n DAY), k) AS while_result,
    ivr_agregar_dias_semana_v2(DATE_ADD('2025-01-01', INTERVAL n DAY), k) AS formula_result,
    ivr_agregar_dias_semana(...) = ivr_agregar_dias_semana_v2(...) AS match_ok
FROM
    (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
     UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) dias
    CROSS JOIN
    (SELECT 1 k UNION SELECT 2 UNION SELECT 3 UNION SELECT 5 UNION SELECT 10) ns;
-- Criterio: 0 filas con match_ok = 0
```

---

### T-4.6 — Redesplegar `funciones_utilidad.sql` completo y verificar

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/funciones_utilidad.sql
bash scripts/provision-mariadb.sh
bash verify.sh
```

**Criterio:** verify.sh 27 OK, 0 WARN, 0 ERR.

---

### T-4.7 — Actualizar archivos individuales en `objetos/funciones/`

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/objetos/funciones/ivr_contar_dias_semana.sql
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/objetos/funciones/ivr_agregar_dias_semana.sql
bash scripts/provision-mariadb.sh
```

---

### T-4.8 — Verificar que `sp_rpt_centros_xsegmento` produce resultados idénticos

```sql
-- Los resultados de todos los SPs de reporte deben ser byte-a-byte idénticos
-- antes y después de cambiar las funciones:
CALL sp_rpt_centros_xsegmento('Q02_26');
CALL sp_rpt_centros_xsegmento('Q01_25');
-- Comparar contra snapshots tomados antes de la FASE 4
```

---

### T-4.9 — Commit de FASE 4

```
perf(funciones): FASE 4 — fórmula O(1) para funciones de calendario (H-IACT-001)

ivr_contar_dias_semana: reemplaza WHILE O(n) con fórmula O(1).
ivr_agregar_dias_semana: reemplaza WHILE O(n) con fórmula O(1).

Ambas funciones validadas contra suite de tests de 91+ casos que cubre
todos los días de inicio posibles (7) y rangos clave (0-91 días).
Criterio de aceptación: 0 fallos en la suite completa.

Impacto en sp_rpt_centros_xsegmento:
  Antes:  ~108,000 iteraciones WHILE por ejecución (con 300 centros)
  Después: 0 iteraciones WHILE — todas las funciones son O(1)

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## Resumen del plan

| Fase | Tareas | Hallazgos | Riesgo | Prerequisito |
|---|---|---|---|---|
| FASE 1 | T-1.1 → T-1.7 | H-IACT-005, H-IACT-006 | Ninguno | — |
| FASE 2 | T-2.1 → T-2.5 | H-IACT-002 N1, H-IACT-003 | Bajo | FASE 1 |
| FASE 3 | T-3.1 → T-3.5 | H-IACT-004 | Medio | FASE 1 |
| FASE 4 | T-4.1 → T-4.9 | H-IACT-001, H-IACT-002 N2 | Alto | FASES 1-3 |

**Total de tareas atómicas:** 24  
**Orden de ejecución:** FASE 1 → (FASE 2 y FASE 3 pueden ejecutarse en paralelo) → FASE 4

---

## Criterio de cierre del plan completo

```
verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
Suite de tests FASE 4: 0 fallos
sp_rpt_centros_xsegmento: resultados idénticos antes y después de todas las fases
sp_etl_maestro: PASO 5 no ejecuta cuando PASO 4 falla (verificado con prueba de fallo simulado)
```
