# Plan de implementación v2.0 — ETL IVR Pipeline

**Fecha:** 2026-05-06
**Versión anterior:** `PLAN-IMPLEMENTACION.md` (v1.0 — 58 tareas)
**Versión actual:** v2.0 — **66 tareas**

---

## Cambios respecto al plan v1

El análisis de grafo de dependencias (`GRAFO-DEPENDENCIAS.md`) identificó
7 gaps y 5 tasks que necesitaban criterios más precisos.

### Gaps nuevos → 8 tareas adicionales

| Gap identificado | Impacto | Tareas nuevas |
|---|---|---|
| `ivr_es_dia_habil` falla silenciosamente — 18 nodos afectados sin excepción | ALTO | T-018, T-019 |
| Columnas `llamadas_dias_habiles/fines_semana` nunca verificadas | MEDIO | (cubierto en T-018) |
| `etl_runs` recibe escrituras de 4 fuentes — secuencia no testeada | MEDIO | T-057 |
| `_call_sp()` con 0 filas — `cursor.description` puede ser None en Django+MySQL | ALTO | T-053b |
| Cadena más larga del sistema (11 nodos) sin test end-to-end explícito | ALTO | T-074 |
| `sp_etl_historico` debe deshabilitarse en `job_config` post-backfill | BAJO | T-044b |
| Sin monitoreo post-deployment del ratio días hábiles | MEDIO | T-085 |

### Tasks modificadas — criterios de aceptación más precisos

| Task | Qué cambió |
|---|---|
| T-013 | Agrega verificación explícita del ORDEN de ramas en `fn_normalizar_centro` |
| T-015 | Agrega fechas específicas de 2025 con festivos reales del año a procesar |
| T-032 | Agrega verificación de `llamadas_dias_habiles + llamadas_fines_semana = total` |
| T-051 | Agrega verificación de que IVRRouter bloquea migraciones en BD `ivr` |
| T-083 | Agrega umbral específico para `sp_rpt_centros_xsegmento` (cadena más larga) |

### Lo que NO cambia

El orden de las 6 fases del plan v1 es correcto — el grafo lo confirma.
Las funciones van primero porque no tienen dependencias internas.
Los schedulers van al final porque disparar el ETL sin datos produce `PARTIAL`.

---

## Resumen ejecutivo

| Dimensión | v1 | v2 |
|---|---|---|
| Tareas totales | 58 | **66** |
| Tareas críticas (ruta crítica) | 31 | **37** |
| Tareas ALTO riesgo | 8 | **13** |
| Tiempo estimado total | ~24.5h | **~28h** |
| Cobertura de fallos silenciosos | No | **Sí** |

---

## Diagrama de fases (sin cambios estructurales)

```
FASE 0 — Verificación entorno          (5 tasks)
    │
    ▼
FASE 1 — Funciones + Schema            (16 tasks)  ← +2 nuevas (T-018, T-019)
    │
    ├──────────────────────┐
    ▼                      ▼
FASE 2 — SPs ETL          FASE 4 — Django base
(9 tasks) ← +1 nueva      (9 tasks) ← +1 nueva +1 modificada
    │                          │
    ▼                          │
FASE 3 — Backfill              │
(6 tasks) ← +1 nueva           │
    │                          │
    └──────────┬───────────────┘
               ▼
         FASE 5 — SPs reporte + Django integración
         (15 tasks) ← +2 nuevas +1 modificada
               │
               ▼
         FASE 6 — Scheduler + Producción
         (6 tasks) ← +1 nueva
```

---

## FASE 0 — Verificación del entorno

*(Sin cambios respecto a v1 — 5 tareas)*

### T-001 — Verificar conectividad MariaDB

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy -e "SELECT VERSION(), DATABASE();"
```

**Criterio:** Versión 10.1.x, database = `ivr_legacy`.
**Riesgo:** ALTO | **Tiempo:** 15 min | **Depende de:** —

---

### T-002 — Verificar permisos GRANT

```sql
SHOW GRANTS FOR 'django_user'@'%';
SELECT 1 FROM tbl_historico_t1_2025 LIMIT 1;
```

**Criterio:** SELECT en `tbl_historico_*`, CREATE/INSERT/DELETE/UPDATE en tablas IACT.
**Riesgo:** ALTO | **Tiempo:** 15 min | **Depende de:** T-001

---

### T-003 — Verificar existencia y estructura de tablas fuente

```sql
SELECT TABLE_NAME, TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'ivr_legacy'
  AND TABLE_NAME LIKE 'tbl_historico_%'
ORDER BY TABLE_NAME;

DESCRIBE tbl_historico_t1_2025;
```

**Criterio:** 6 tablas, 10 columnas (dFecha, dHoraInicio, dHoraFin, cDID_800Transfer,
cDID_Centro_Transferencia, cMenu, cOpcion, cTelefono_Origen, cTelefono_Digitado, cEtiquetacliente).
**Riesgo:** ALTO | **Tiempo:** 20 min | **Depende de:** T-002

---

### T-004 — Verificar volúmenes en tablas fuente

```sql
SELECT 'tbl_historico_t1_2025' AS tabla, COUNT(*) AS total,
       COUNT(DISTINCT cDID_800Transfer) AS dids,
       MIN(dFecha) AS desde, MAX(dFecha) AS hasta
FROM tbl_historico_t1_2025;
-- Repetir para t2 y t3
```

**Criterio:** t1≈11.6M, t2≈13.6M, t3≈11.5M filas. Exactamente 3 DIDs distintos
(19028031, 19020001, 19020084) en todos.
**Riesgo:** MEDIO | **Tiempo:** 20 min | **Depende de:** T-003

---

### T-005 — Verificar proyecto Django

```bash
python manage.py check --database default
python manage.py showmigrations | head -5
```

**Criterio:** Sin errores críticos. PostgreSQL operacional accesible.
**Riesgo:** MEDIO | **Tiempo:** 15 min | **Depende de:** —

---

## FASE 1 — Funciones de utilidad + Schema

*16 tareas (v1: 14, +2 nuevas: T-018, T-019)*

### T-010 — Desplegar funciones_utilidad.sql

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/funciones_utilidad.sql
```

**Criterio:** Script ejecuta sin errores. La sección de verificación al final
retorna todos los valores esperados.
**Riesgo:** BAJO | **Tiempo:** 10 min | **Depende de:** T-002

---

### T-011 — Verificar fn_did_segmento

```sql
SELECT
    fn_did_segmento('19028031') AS r1,   -- 'nacional_A'
    fn_did_segmento('19020001') AS r2,   -- 'nacional_B'
    fn_did_segmento('19020084') AS r3,   -- 'puebla'
    fn_did_segmento('99999999') AS r4;   -- 'desconocido'
```

**Criterio:** Los 4 valores coinciden exactamente.
**Tiempo:** 5 min | **Depende de:** T-010

---

### T-012 — Verificar fn_normalizar_menu

```sql
SELECT
    fn_normalizar_menu(NULL)                AS r1,  -- 'VACIO'
    fn_normalizar_menu('')                  AS r2,  -- 'VACIO'
    fn_normalizar_menu('sin cMenu')         AS r3,  -- 'VACIO'
    fn_normalizar_menu('RES-FallaInternet') AS r4;  -- 'RES-FallaInternet'
```

**Criterio:** 3 casos → 'VACIO', 1 caso → pass-through exacto.
**Tiempo:** 5 min | **Depende de:** T-010

---

### T-013 — Verificar fn_normalizar_centro *(MODIFICADA)*

```sql
SELECT
    fn_normalizar_centro(NULL)                     AS c1,  -- 'CASO_NULL'
    fn_normalizar_centro('')                       AS c2,  -- 'CASO_NULL'
    fn_normalizar_centro('cliente_colgo')          AS c3,  -- 'CLIENTE_COLGO'
    fn_normalizar_centro('00000000')               AS c4,  -- 'CASO_ERROR_CEROS'
    fn_normalizar_centro('@1234567')               AS c5,  -- 'ERROR_CARACTER_INICIAL'
    fn_normalizar_centro('190100008190983030')     AS c6,  -- '19010000' (NK90 len18)
    fn_normalizar_centro('13090048190983030')      AS c7,  -- '1309004'  (NK90 len17)
    fn_normalizar_centro('3090048190983030')       AS c8,  -- '309004'   (NK90 len16)
    fn_normalizar_centro('10828091')               AS c9;  -- '10828091' (VDN limpio)
```

**ORDEN CRÍTICO (aportado por análisis de grafo):**
`'cliente_colgo'` tiene 13 caracteres. Si la rama `LENGTH > 10` se evalúa
ANTES que la rama `cliente_colgo`, el resultado sería `'clie'` en lugar
de `'CLIENTE_COLGO'`. Verificar que c3 = 'CLIENTE_COLGO' exactamente.

```sql
-- Test específico de orden: si falla, el orden de ramas es incorrecto
SELECT fn_normalizar_centro('cliente_colgo') = 'CLIENTE_COLGO' AS orden_correcto;
-- Debe retornar: 1 (TRUE)
```

**Criterio:** Los 9 casos retornan exactamente los valores esperados.
`orden_correcto = 1`.
**Riesgo:** ALTO | **Tiempo:** 10 min | **Depende de:** T-010

---

### T-014 — Verificar fn_duracion_seg

```sql
SELECT
    fn_duracion_seg('2025-01-15 14:00:00','2025-01-15 14:05:30') AS normal,   -- 330
    fn_duracion_seg('2025-01-15 14:35:00','2025-01-15 13:58:00') AS g29,      -- 2220
    fn_duracion_seg(NULL, '2025-01-15 14:00:00')                  AS con_null; -- 0
```

**Criterio:** normal=330, g29=2220 (positivo — G-29 corregido), con_null=0.
**Tiempo:** 5 min | **Depende de:** T-010

---

### T-015 — Verificar ivr_es_dia_habil *(MODIFICADA)*

```sql
-- Casos básicos
SELECT
    ivr_es_dia_habil('2025-01-06') AS lunes,        -- TRUE
    ivr_es_dia_habil('2025-01-04') AS sabado,        -- FALSE
    ivr_es_dia_habil('2025-01-05') AS domingo,       -- FALSE
    ivr_es_dia_habil('2025-01-01') AS anio_nuevo,   -- FALSE
    ivr_es_dia_habil('2025-05-01') AS dia_trabajo,  -- FALSE
    ivr_es_dia_habil('2025-09-16') AS independencia; -- FALSE

-- Fechas específicas del periodo Q1-Q3 2025 (datos reales que se procesarán)
-- Verificar festivos del año real — estos afectan las columnas llamadas_dias_habiles
SELECT
    ivr_es_dia_habil('2025-02-05') AS constitucion,  -- FALSE (festivo fijo)
    ivr_es_dia_habil('2025-03-21') AS juarez,        -- FALSE (festivo fijo)
    ivr_es_dia_habil('2025-03-24') AS lun_normal,    -- TRUE  (lunes, no es festivo)
    ivr_es_dia_habil('2025-11-20') AS revolucion,    -- FALSE (festivo fijo)
    ivr_es_dia_habil('2025-11-17') AS lun_pre_rev;   -- TRUE  (lunes previo, NO es festivo en esta implementación)
```

**NOTA sobre Semana Santa:** Las fechas de Jueves y Viernes Santo son variables.
Jueves Santo 2025 = 2025-04-17, Viernes Santo 2025 = 2025-04-18.
La implementación actual NO los incluye (hardcoded solo festivos fijos Art.74 LFT).
Esto es una limitación documentada — verificar que el equipo la acepta.

```sql
SELECT
    ivr_es_dia_habil('2025-04-17') AS jueves_santo_2025,  -- TRUE (no está en catálogo)
    ivr_es_dia_habil('2025-04-18') AS viernes_santo_2025;  -- TRUE (no está en catálogo)
-- Si el equipo requiere Semana Santa, agregar a funciones_utilidad.sql antes de continuar
```

**Criterio:** Todos los festivos fijos = FALSE. Días laborables = TRUE.
Equipo confirma comportamiento de Semana Santa.
**Riesgo:** ALTO | **Tiempo:** 15 min | **Depende de:** T-010

---

### T-016 — Verificar ivr_contar_dias_habiles

```sql
SELECT
    ivr_contar_dias_habiles('2025-01-01', '2025-01-31') AS enero_2025, -- 22
    ivr_contar_dias_habiles('2025-04-01', '2025-06-30') AS q2_2025,    -- 65
    ivr_contar_dias_habiles('2025-07-01', '2025-09-30') AS q3_2025,    -- 66
    ivr_contar_dias_habiles('2025-01-15', '2025-01-15') AS mismo_dia_h, -- 1
    ivr_contar_dias_habiles('2025-01-11', '2025-01-11') AS mismo_dia_f, -- 0 (sábado)
    ivr_contar_dias_habiles('2025-03-31', '2025-01-01') AS rango_inv;   -- 0
```

**Criterio:** enero=22, rango invertido=0.
**Tiempo:** 10 min | **Depende de:** T-010

---

### T-017 — Verificar ivr_agregar_dias_habiles

```sql
SELECT
    ivr_agregar_dias_habiles('2025-01-31', 1) AS sig_dia,    -- 2025-02-03 (lunes)
    ivr_agregar_dias_habiles('2025-01-31', 3) AS tres_dias,  -- 2025-02-05
    ivr_agregar_dias_habiles('2025-01-31', 5) AS cinco_dias, -- 2025-02-07
    ivr_agregar_dias_habiles('2025-01-15', 0) AS cero_dias;  -- 2025-01-15
```

**Criterio:** Los 4 valores son fechas laborables válidas.
**Tiempo:** 5 min | **Depende de:** T-010

---

### T-018 — Verificar integridad de llamadas_dias_habiles + llamadas_fines_semana *(NUEVA)*

**Origen:** Análisis de grafo — columnas nuevas en schema v2 nunca verificadas en plan v1.
`ivr_es_dia_habil` afecta 18 nodos silenciosamente si retorna valores incorrectos.

```sql
-- Ejecutar DESPUÉS de T-032 (cuando base_ivr_detalle tenga datos de Q01_25)
-- 1. Integridad: suma debe ser igual a total_llamadas en cada fila
SELECT COUNT(*) AS filas_con_error
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND (llamadas_dias_habiles + llamadas_fines_semana) != total_llamadas;
-- Esperado: 0

-- 2. Ratio razonable: días hábiles = 5/7 del tiempo ≈ 71.4%, ajustado por festivos ~69-72%
SELECT
    SUM(llamadas_dias_habiles) AS total_h,
    SUM(llamadas_fines_semana) AS total_fin,
    SUM(total_llamadas)        AS total,
    ROUND(SUM(llamadas_dias_habiles) / SUM(total_llamadas) * 100, 1) AS pct_habiles
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25';
-- Esperado: pct_habiles entre 65% y 80%
-- Si pct_habiles < 50% o > 90%: error en ivr_es_dia_habil

-- 3. Verificar que los 3 meses del quarter tienen distribución similar
SELECT fecha,
    ROUND(SUM(llamadas_dias_habiles) / SUM(total_llamadas) * 100, 1) AS pct_h
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
GROUP BY fecha
ORDER BY fecha;
-- Enero (22 días h / 31 total = 70.9%), Feb (20/28 = 71.4%), Mar (21/31 = 67.7%)
-- Tolerancia: ±5pp respecto al teórico
```

**Criterio:** `filas_con_error = 0`. `pct_habiles` entre 65% y 80%. Sin meses outliers.
**Riesgo:** ALTO — detecta fallo silencioso de `ivr_es_dia_habil`
**Tiempo:** 15 min | **Depende de:** T-032

---

### T-019 — Test de propagación del fallo silencioso de ivr_es_dia_habil *(NUEVA)*

**Origen:** Análisis de grafo — `ivr_es_dia_habil` afecta 18 nodos sin lanzar excepción.
Es el fallo más peligroso del sistema porque no hay señal de error visible.

```sql
-- Simular función incorrecta: modificar temporalmente para siempre retornar TRUE
-- (como si todos los días fueran hábiles)
DROP FUNCTION IF EXISTS ivr_es_dia_habil_backup;
CREATE FUNCTION ivr_es_dia_habil_backup(p_fecha DATE) RETURNS BOOLEAN DETERMINISTIC
BEGIN RETURN ivr_es_dia_habil(p_fecha); END;

-- Versión "rota" que siempre retorna TRUE
CREATE OR REPLACE FUNCTION ivr_es_dia_habil(p_fecha DATE) RETURNS BOOLEAN DETERMINISTIC
BEGIN RETURN TRUE; END;

-- Reprocesar enero Q01_25 con la función rota
DELETE FROM base_ivr_detalle WHERE trimestre = 'Q01_25' AND fecha = '202501';
CALL sp_etl_base_detalle('Q01_25', '2025-01-01', '2025-01-31',
     'tbl_historico_t1_2025', NULL);

-- Verificar que pct_habiles ahora es 100% (detecta la corrupción silenciosa)
SELECT ROUND(SUM(llamadas_dias_habiles)/SUM(total_llamadas)*100,1) AS pct_h
FROM base_ivr_detalle WHERE trimestre='Q01_25' AND fecha='202501';
-- Esperado: 100% (confirma que el test detecta el problema)

-- Restaurar función correcta
DROP FUNCTION ivr_es_dia_habil;
CREATE FUNCTION ivr_es_dia_habil(p_fecha DATE) RETURNS BOOLEAN DETERMINISTIC
BEGIN RETURN ivr_es_dia_habil_backup(p_fecha); END;
DROP FUNCTION ivr_es_dia_habil_backup;

-- Reprocesar con función correcta y verificar recuperación
DELETE FROM base_ivr_detalle WHERE trimestre = 'Q01_25' AND fecha = '202501';
CALL sp_etl_base_detalle('Q01_25', '2025-01-01', '2025-01-31',
     'tbl_historico_t1_2025', NULL);
SELECT ROUND(SUM(llamadas_dias_habiles)/SUM(total_llamadas)*100,1) AS pct_h
FROM base_ivr_detalle WHERE trimestre='Q01_25' AND fecha='202501';
-- Esperado: ~70% (correcto)
```

**Criterio:** Con función rota → pct=100%. Con función correcta → pct 65-80%.
El test CONFIRMA que T-018 puede detectar este tipo de fallo.
**Riesgo:** ALTO | **Tiempo:** 20 min | **Depende de:** T-017, T-032

---

### T-020 — Desplegar schema_base_ivr.sql

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/schema_base_ivr.sql
```

**Criterio:** 5 tablas creadas. La verificación al final del script muestra
TABLE_NAME y CREATE_TIME de cada una.
**Riesgo:** BAJO | **Tiempo:** 10 min | **Depende de:** T-010

---

### T-021 — Verificar base_ivr_detalle (schema v2)

```sql
DESCRIBE base_ivr_detalle;
SHOW INDEX FROM base_ivr_detalle;
```

**Criterio:** 13 columnas presentes incluyendo `llamadas_dias_habiles` y
`llamadas_fines_semana` (columnas nuevas de v2). 6 índices incluyendo `uk_grain`.

**Lista de columnas esperadas:**
`id, trimestre, fecha, segmento, centro_transferencia, menu, opcion,
total_llamadas, misma_linea, linea_diferente, no_digito_telefono,
llamadas_dias_habiles, llamadas_fines_semana, cargado_en`

**Riesgo:** MEDIO | **Tiempo:** 10 min | **Depende de:** T-020

---

### T-022 — Verificar etl_runs con timeout_at

```sql
DESCRIBE etl_runs;
INSERT INTO etl_runs (trimestre, iniciado_en, timeout_at, estado, ejecutado_por)
VALUES ('TEST', NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE), 'en_ejecucion', 'test');
SELECT id, timeout_at FROM etl_runs WHERE trimestre = 'TEST';
DELETE FROM etl_runs WHERE trimestre = 'TEST';
```

**Criterio:** INSERT exitoso. Campo `timeout_at` presente. `INDEX idx_timeout` existe.
**Tiempo:** 10 min | **Depende de:** T-020

---

### T-023 — Verificar job_config con datos iniciales

```sql
SELECT job_name, is_enabled, timeout_seconds FROM job_config ORDER BY job_name;
-- Esperado: 2 filas
-- etl_diario    | 1 | 1800
-- etl_historico | 0 | 7200
```

**Criterio:** 2 filas. `etl_historico.is_enabled = 0` (deshabilitado por defecto).
**Tiempo:** 5 min | **Depende de:** T-020

---

## FASE 2 — SPs del pipeline ETL

*9 tareas (v1: 8, +1 nueva: T-057)*

### T-030 — Desplegar sp_etl_pipeline.sql

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/sp_etl_pipeline.sql
```

**Criterio:**
```sql
SHOW PROCEDURE STATUS WHERE Db='ivr_legacy' AND Name LIKE 'sp_etl%';
-- 5 filas: sp_etl_base_clientes, sp_etl_base_detalle,
--          sp_etl_historico, sp_etl_maestro, sp_etl_validar
```
**Riesgo:** BAJO | **Tiempo:** 10 min | **Depende de:** T-021

---

### T-031 — Test sp_etl_base_detalle en Q01_25 enero (subset)

```sql
SELECT COUNT(*) FROM base_ivr_detalle WHERE trimestre = 'Q01_25';
-- Debe ser 0 (tabla vacía)

CALL sp_etl_base_detalle('Q01_25','2025-01-01','2025-01-31',
     'tbl_historico_t1_2025', NULL);

SELECT COUNT(*) AS filas, SUM(total_llamadas) AS total,
       COUNT(DISTINCT segmento) AS segmentos, MIN(fecha) AS f_min, MAX(fecha) AS f_max
FROM base_ivr_detalle WHERE trimestre = 'Q01_25';
-- total ≈ 3.8M (1/3 del quarter de 11.6M)
-- segmentos = 3, f_min = f_max = '202501'
```

**Criterio:** `segmentos=3`, `f_min=f_max='202501'`, `total>3_000_000`.
**Riesgo:** MEDIO | **Tiempo:** 30 min | **Depende de:** T-030

---

### T-032 — Verificar normalización Q01_25 *(MODIFICADA)*

```sql
-- 1. Distribución de segmentos (esperado: ~45% A, ~30% B, ~25% Puebla)
SELECT segmento, SUM(total_llamadas) AS total FROM base_ivr_detalle
WHERE trimestre='Q01_25' GROUP BY segmento;

-- 2. Sin NK90 crudos en centro_transferencia
SELECT COUNT(*) AS nk90_crudos FROM base_ivr_detalle
WHERE trimestre='Q01_25' AND LENGTH(centro_transferencia)>10
  AND centro_transferencia NOT IN
      ('CASO_NULL','CLIENTE_COLGO','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL');
-- Esperado: 0

-- 3. NUEVO v2: Integridad de llamadas_dias_habiles + llamadas_fines_semana
SELECT COUNT(*) AS filas_error FROM base_ivr_detalle
WHERE trimestre='Q01_25'
  AND (llamadas_dias_habiles + llamadas_fines_semana) != total_llamadas;
-- Esperado: 0

-- 4. NUEVO v2: Ratio días hábiles razonable
SELECT ROUND(SUM(llamadas_dias_habiles)/SUM(total_llamadas)*100,1) AS pct_h
FROM base_ivr_detalle WHERE trimestre='Q01_25';
-- Esperado: entre 65% y 80%
```

**Criterio:** NK90 crudos = 0. Filas error = 0. pct_h en rango 65-80%.
**Riesgo:** MEDIO | **Tiempo:** 20 min | **Depende de:** T-031

---

### T-033 — Verificar ON DUPLICATE KEY (idempotencia)

```sql
SELECT SUM(total_llamadas) AS antes FROM base_ivr_detalle
WHERE trimestre='Q01_25' AND fecha='202501';

CALL sp_etl_base_detalle('Q01_25','2025-01-01','2025-01-31',
     'tbl_historico_t1_2025', NULL);

SELECT SUM(total_llamadas) AS despues FROM base_ivr_detalle
WHERE trimestre='Q01_25' AND fecha='202501';
-- antes = despues
```

**Criterio:** `antes = despues`. Sin duplicación de filas.
**Tiempo:** 20 min | **Depende de:** T-032

---

### T-034 — Test sp_etl_base_clientes Q01_25

```sql
DELETE FROM base_ivr_clientes WHERE trimestre='Q01_25';
CALL sp_etl_base_clientes('Q01_25','2025-01-01','2025-03-31',
     'tbl_historico_t1_2025', NULL);
SELECT * FROM base_ivr_clientes WHERE trimestre='Q01_25';
-- Esperado: exactamente 3 filas
```

**Criterio:** Exactamente 3 filas. `clientes_unicos > 0` en las 3.
**Tiempo:** 25 min | **Depende de:** T-030

---

### T-035 — Verificar sp_etl_validar

```sql
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok AS ok, @msg AS msg;
-- Esperado: @ok = 1
```

**Criterio:** `@ok = TRUE`. Mensaje contiene filas > 0 y clientes = 3.
**Tiempo:** 5 min | **Depende de:** T-034

---

### T-036 — Verificar sp_etl_maestro — control de concurrencia

```sql
INSERT INTO job_execution_log (job_name, step_name, status, start_time, ejecutado_por)
VALUES ('etl_diario','maestro','RUNNING', NOW(), 'test');
SET @fake_id = LAST_INSERT_ID();

CALL sp_etl_maestro();

SELECT status FROM job_execution_log WHERE status='SKIP' ORDER BY id DESC LIMIT 1;
-- Esperado: 'SKIP'

UPDATE job_execution_log SET status='SUCCESS' WHERE id = @fake_id;
```

**Criterio:** Aparece un registro `status='SKIP'`.
**Tiempo:** 10 min | **Depende de:** T-030

---

### T-037 — Verificar checkpoints por paso en job_execution_log

```sql
SELECT step_name, status, records_procesados, duracion_seg
FROM job_execution_log WHERE job_name='etl_diario' ORDER BY id DESC LIMIT 10;
-- Esperado: registros para 'maestro', 'etl_base_detalle', 'etl_base_clientes'
-- Ninguno debe quedar en status='RUNNING' después de la ejecución
```

**Criterio:** 3 registros de paso. Ningún `status='RUNNING'` persistente.
**Tiempo:** 20 min | **Depende de:** T-036

---

### T-057 — Verificar secuencia de escritura en etl_runs desde 4 fuentes *(NUEVA)*

**Origen:** Análisis de grafo — `etl_runs` recibe escrituras de `svc_p`, `cmd_e`,
`hb` y `etl_m`. El estado final debe ser coherente.

```python
# Python en django shell
from django.db import connections

# 1. Insertar en etl_runs (simular svc_p)
with connections['ivr'].cursor() as c:
    c.execute("""
        INSERT INTO etl_runs (trimestre, iniciado_en, timeout_at, estado, ejecutado_por)
        VALUES ('Q_TEST', NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE),
                'en_ejecucion', 'test_svc_p')
    """)
    run_id = c.lastrowid

# 2. Simular que el SP ETL actualiza el estado (como etl_m haría)
with connections['ivr'].cursor() as c:
    c.execute("""
        UPDATE etl_runs SET estado='exitoso', finalizado_en=NOW()
        WHERE id=%s AND estado='en_ejecucion'
    """, [run_id])

# 3. Simular heartbeat que llega tarde (timeout_at ya pasó, pero estado ya cerrado)
with connections['ivr'].cursor() as c:
    c.execute("""
        UPDATE etl_runs
        SET estado='timeout', finalizado_en=NOW(), mensaje_error='timeout'
        WHERE id=%s AND estado='en_ejecucion' AND timeout_at < NOW()
    """, [run_id])
    # WHERE filtra: estado ya es 'exitoso', NO debe actualizarse

# 4. Verificar que el estado final es 'exitoso' (el heartbeat llegó tarde pero NO sobreescribió)
with connections['ivr'].cursor() as c:
    c.execute("SELECT estado FROM etl_runs WHERE id=%s", [run_id])
    estado = c.fetchone()[0]
    assert estado == 'exitoso', f"ERROR: heartbeat sobreescribió el estado: {estado}"
    print(f"OK: estado final = {estado}")

# Limpiar
with connections['ivr'].cursor() as c:
    c.execute("DELETE FROM etl_runs WHERE id=%s", [run_id])
```

**Criterio:** `estado final = 'exitoso'`. El heartbeat con `AND estado='en_ejecucion'`
evita sobreescribir un estado ya cerrado.
**Riesgo:** MEDIO | **Tiempo:** 20 min | **Depende de:** T-055

---

## FASE 3 — Carga histórica (backfill)

*6 tareas (v1: 5, +1 nueva: T-044b)*

### T-040 — Backfill Q01_25

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy -e "CALL sp_etl_historico(2025, 1);"
```

**Criterio:** `SUM(total_llamadas) ≈ 11,643,679`.
**Riesgo:** MEDIO | **Tiempo:** 35 min | **Depende de:** T-037

---

### T-041 — Backfill Q02_25

```sql
CALL sp_etl_historico(2025, 2);
-- SUM(total_llamadas) ≈ 13,612,375
```

**Tiempo:** 40 min | **Depende de:** T-040

---

### T-042 — Backfill Q03_25

```sql
CALL sp_etl_historico(2025, 3);
-- SUM(total_llamadas) ≈ 11,482,117
```

**Tiempo:** 35 min | **Depende de:** T-041

---

### T-043 — Backfill Q04_25 y Q01_26

```sql
CALL sp_etl_historico(2025, 4);
CALL sp_etl_historico(2026, 1);
```

**Tiempo:** 35 min | **Depende de:** T-042

---

### T-044 — Verificar integridad del backfill completo

```sql
SELECT trimestre, COUNT(*) AS filas,
       FORMAT(SUM(total_llamadas),0) AS total,
       COUNT(DISTINCT segmento) AS segmentos
FROM base_ivr_detalle GROUP BY trimestre ORDER BY trimestre;

SELECT trimestre, segmento, clientes_unicos
FROM base_ivr_clientes ORDER BY trimestre, segmento;
-- 15 filas: 5 quarters × 3 segmentos
```

**Criterio:** 5 quarters en `base_ivr_detalle`. 15 filas en `base_ivr_clientes`.
Ningún `status='FAILED'` en `job_execution_log`.
**Tiempo:** 15 min | **Depende de:** T-043

---

### T-044b — Deshabilitar sp_etl_historico en job_config post-backfill *(NUEVA)*

**Origen:** Análisis de grafo — `sp_etl_historico` tiene 0 nodos que lo llamen.
Es una puerta de entrada MANUAL. Dejarla habilitada en job_config es un riesgo
operativo (alguien podría invocarla accidentalmente).

```sql
-- Verificar estado actual
SELECT job_name, is_enabled FROM job_config;

-- Debe estar deshabilitada (ya debería estarlo por la configuración inicial)
-- Si por alguna razón quedó habilitada, deshabilitar explícitamente:
UPDATE job_config SET is_enabled = FALSE WHERE job_name = 'etl_historico';

-- Verificar
SELECT job_name, is_enabled FROM job_config WHERE job_name = 'etl_historico';
-- Esperado: is_enabled = 0
```

**NOTA:** Para re-ejecutar un backfill en el futuro, habilitar manualmente:
`UPDATE job_config SET is_enabled = TRUE WHERE job_name = 'etl_historico';`
y deshabilitar inmediatamente después.

**Criterio:** `etl_historico.is_enabled = 0`.
**Riesgo:** BAJO | **Tiempo:** 5 min | **Depende de:** T-044

---

## FASE 4 — Django: base y capa de datos

*9 tareas (v1: 7, +2 nuevas: T-053b, +1 modificada T-051)*

### T-050 — Configurar DATABASES['ivr'] en settings.py

```python
DATABASES = {
    'default': { ... },
    'ivr': {
        'ENGINE':   'django.db.backends.mysql',
        'NAME':     'ivr_legacy',
        'USER':     os.environ.get('IVR_DB_USER', 'django_user'),
        'PASSWORD': os.environ.get('IVR_DB_PASSWORD', 'django_pass'),
        'OPTIONS': {
            'charset':     'utf8mb4',
            'unix_socket': os.environ.get('IVR_DB_SOCKET','/run/mysqld/mysqld.sock'),
        },
    }
}
```

**Criterio:**
```bash
python manage.py dbshell --database=ivr
# Abre prompt MySQL sin errores
```
**Riesgo:** MEDIO | **Tiempo:** 30 min | **Depende de:** T-005

---

### T-051 — Crear IVRRouter *(MODIFICADA)*

```python
# iact/routers.py
class IVRRouter:
    def db_for_read(self, model, **hints):
        if model._meta.app_label == 'ivr': return 'ivr'
        return None
    def db_for_write(self, model, **hints):
        if model._meta.app_label == 'ivr': return 'ivr'
        return None
    def allow_migrate(self, db, app_label, **hints):
        if app_label == 'ivr': return False
        return None
```

**Criterio (test de migración — crítico por impacto del grafo):**
```bash
python manage.py migrate --database=ivr
# DEBE mostrar: 'No migrations to apply'
# NO debe crear tablas de Django en MariaDB
```

**IMPORTANTE:** Si `allow_migrate` no retorna `False` correctamente, Django
podría crear `django_migrations`, `auth_*`, `contenttypes_*` etc. en `ivr_legacy`.
Esto contamina el schema y puede causar conflictos con las tablas IACT.

**Riesgo:** MEDIO | **Tiempo:** 30 min | **Depende de:** T-050

---

### T-052 — Verificar cursor.callproc() desde Django

```python
from django.db import connections
with connections['ivr'].cursor() as cursor:
    cursor.execute("SELECT VERSION(), DATABASE()")
    print(cursor.fetchone())
    # ('10.1.48-MariaDB', 'ivr_legacy')
```

**Criterio:** Retorna versión y database correctas.
**Tiempo:** 15 min | **Depende de:** T-051

---

### T-053 — Crear services/ivr_reports.py con _call_sp()

```python
def _call_sp(sp_name: str, params: list) -> list[dict]:
    with connections['ivr'].cursor() as cursor:
        cursor.callproc(sp_name, params)
        if cursor.description is None:          # SP retornó 0 filas
            return []
        cols = [c[0] for c in cursor.description]
        return [dict(zip(cols, row)) for row in cursor.fetchall()]
```

**Criterio:** Módulo importable. `get_clientes('Q01_25')` retorna lista de dicts.
**Tiempo:** 45 min | **Depende de:** T-052

---

### T-053b — Test _call_sp() con SP que retorna 0 filas *(NUEVA)*

**Origen:** Análisis de grafo — `_call_sp()` con 11 nodos dependientes.
En Django+MySQL, `cursor.description` es `None` cuando el SP retorna 0 filas.
Sin el guard `if cursor.description is None`, la línea `cursor.description`
lanza `AttributeError` y fallan los 11 nodos dependientes.

```python
# Crear SP temporal que retorna 0 filas
with connections['ivr'].cursor() as c:
    c.execute("""
        CREATE PROCEDURE IF NOT EXISTS sp_test_vacio()
        BEGIN SELECT * FROM base_ivr_clientes WHERE trimestre = 'INEXISTENTE'; END
    """)

# Test que _call_sp() maneja el caso vacío sin excepción
result = _call_sp('sp_test_vacio', [])
assert result == [], f"Esperado [], obtenido: {result}"
print("OK: _call_sp() maneja 0 filas correctamente")

# Test con SP real con quarter inexistente
result = _call_sp('sp_rpt_clientes', ['Q99_99'])
assert isinstance(result, list), "Debe retornar lista (puede ser vacía)"
print(f"OK: sp_rpt_clientes con quarter inválido retorna: {result}")

# Limpiar
with connections['ivr'].cursor() as c:
    c.execute("DROP PROCEDURE IF EXISTS sp_test_vacio")
```

**Criterio:** `result == []` sin excepción. SP real con quarter inexistente → lista vacía.
**Riesgo:** ALTO | **Tiempo:** 20 min | **Depende de:** T-053

---

### T-054 — Crear services/ivr_pipeline.py

```python
def get_etl_status(limit: int = 20) -> list[dict]:
    """Retorna los últimos N registros de etl_runs."""

def get_job_log(quarter: str = None, limit: int = 50) -> list[dict]:
    """Retorna registros de job_execution_log."""

def trigger_etl(quarter: str, ejecutado_por: str) -> int:
    """Inserta en etl_runs. Retorna run_id."""
```

**Criterio:** `get_etl_status()` retorna lista. `trigger_etl()` retorna entero.
**Tiempo:** 30 min | **Depende de:** T-053

---

### T-055 — Crear management/commands/run_etl.py

```python
class Command(BaseCommand):
    def handle(self, *args, **options):
        # 1. INSERT etl_runs (estado='en_ejecucion', timeout_at=NOW()+30min)
        # 2. Iniciar heartbeat thread (verifica timeout_at cada 2 min)
        # 3. CALL sp_etl_maestro()
        # 4. UPDATE etl_runs (exitoso/fallido)
        # 5. Detener heartbeat thread
```

**Criterio:**
```bash
python manage.py run_etl --help  # Sin errores de importación
python manage.py run_etl         # etl_runs.estado IN ('exitoso','fallido') al finalizar
```
**Riesgo:** MEDIO | **Tiempo:** 2 horas | **Depende de:** T-054

---

### T-056 — Test heartbeat timeout

```python
with connections['ivr'].cursor() as c:
    c.execute("""
        INSERT INTO etl_runs (trimestre, iniciado_en, timeout_at, estado)
        VALUES ('TEST', NOW(), DATE_SUB(NOW(), INTERVAL 1 MINUTE), 'en_ejecucion')
    """)
    run_id = c.lastrowid

# Invocar el método heartbeat con timeout_at en el pasado
# Verificar que marca estado='timeout'
with connections['ivr'].cursor() as c:
    c.execute("SELECT estado FROM etl_runs WHERE id=%s", [run_id])
    assert c.fetchone()[0] == 'timeout'
```

**Criterio:** Registro con `timeout_at` en el pasado → `estado='timeout'`.
**Tiempo:** 30 min | **Depende de:** T-055

---

## FASE 5 — SPs de reporte + API REST

*15 tareas (v1: 14, +1 nueva: T-074, +1 modificada: T-083)*

### T-060 — Desplegar sp_rpt_reportes.sql

```bash
mysql ... ivr_legacy < provisioners/mariadb/sp_rpt_reportes.sql
```

**Criterio:** 7 SPs presentes.
**Riesgo:** BAJO | **Tiempo:** 10 min | **Depende de:** T-044

---

### T-061 — Verificar sp_rpt_clientes

```sql
CALL sp_rpt_clientes('Q01_25');
-- 3 filas, SUM(pct_del_total) ≈ 100%
```

**Criterio:** 3 filas. pct_del_total suma ~100%.
**Tiempo:** 10 min | **Depende de:** T-060

---

### T-062 — Verificar sp_rpt_llamadas_abandonadas con datos reales

```sql
CALL sp_rpt_llamadas_abandonadas('Q01_25','todas');
-- 3 filas (VACIO, cliente_colgo, SinOpcion_Cabecera)
-- pct_del_total combinado ≈ 27-32% (BR-016 recalibrado)
CALL sp_rpt_llamadas_abandonadas('Q01_25','nacional_A');
CALL sp_rpt_llamadas_abandonadas('Q01_25','puebla');
```

**Criterio:** pct_del_total ≈ 27-32% para 'todas'.
**Tiempo:** 15 min | **Depende de:** T-060

---

### T-063 — Verificar sp_rpt_cMENU_ERROR con Q03_25

```sql
CALL sp_rpt_cMENU_ERROR('Q03_25','todas');
-- Esperado: filas con menu REGEXP '^[0-9]+$'
-- centro_transferencia dominante = '19020086'
```

**Criterio:** Retorna filas (no vacío). `centro_transferencia = '19020086'` dominante.
**Tiempo:** 10 min | **Depende de:** T-060

---

### T-064 — Verificar sp_rpt_centros_xsegmento

```sql
CALL sp_rpt_centros_xsegmento('Q01_25');
-- clasificacion_sla no NULL
-- fecha_seguimiento_1_dia > ultima_actividad
-- pct_del_segmento suma ≈ 100% por segmento
-- llamadas_dias_habiles > 0 para centros activos
```

**Criterio:** Sin errores. `clasificacion_sla` es uno de los 6 valores válidos.
`fecha_seguimiento_*` son fechas válidas.
**Riesgo:** MEDIO | **Tiempo:** 20 min | **Depende de:** T-060

---

### T-065 — Verificar patrón p_segmento='todas'

```sql
-- Las 3 sumas por segmento deben igualar el total de 'todas'
CALL sp_rpt_llamadas_abandonadas('Q01_25','todas');       -- A
CALL sp_rpt_llamadas_abandonadas('Q01_25','nacional_A');  -- B1
CALL sp_rpt_llamadas_abandonadas('Q01_25','nacional_B');  -- B2
CALL sp_rpt_llamadas_abandonadas('Q01_25','puebla');      -- B3
-- SUM(B1+B2+B3) por menu = A
```

**Criterio:** Totales de los 3 segmentos suman el total de 'todas'.
**Tiempo:** 20 min | **Depende de:** T-062

---

### T-070 — Crear views/ivr_reports.py

```python
class LlamadasAbandonadasView(APIView):
    def get(self, request):
        quarter  = request.query_params.get('quarter','Q01_25')
        segmento = request.query_params.get('segmento','todas')
        errores  = _validar(quarter=quarter, segmento=segmento)
        if errores: return Response({'errores':errores}, status=400)
        data = ivr_reports.get_abandonadas(quarter, segmento)
        return Response({'quarter':quarter,'segmento':segmento,
                         'total_filas':len(data),'datos':data})
```

**Criterio:** 7 vistas importan sin error. Parámetros inválidos → HTTP 400.
**Tiempo:** 2 horas | **Depende de:** T-053

---

### T-071 — Crear views/ivr_pipeline.py

```python
class ETLEstadoView(APIView):
    """GET /api/ivr/pipeline/estado/"""

class ETLReintentarView(APIView):
    """POST /api/ivr/pipeline/reintentar/ {"quarter":"Q02_26"}"""
```

**Criterio:** GET retorna lista. POST retorna `{"run_id":N, "estado":"en_ejecucion"}`.
**Tiempo:** 45 min | **Depende de:** T-054

---

### T-072 — Crear urls/ivr.py y registrar en urls.py

```python
urlpatterns = [
    path('reportes/clientes/',         ClientesView.as_view()),
    path('reportes/centros/',           CentrosTransferenciaView.as_view()),
    path('reportes/centros-segmento/', CentrosXSegmentoView.as_view()),
    path('reportes/abandonadas/',       LlamadasAbandonadasView.as_view()),
    path('reportes/menu-redirigidos/', MenuRedirigidosView.as_view()),
    path('reportes/menu-centro/',       MenuCentroView.as_view()),
    path('reportes/cmenu-error/',       CMENUErrorView.as_view()),
    path('pipeline/estado/',            ETLEstadoView.as_view()),
    path('pipeline/reintentar/',        ETLReintentarView.as_view()),
]
```

**Criterio:** `python manage.py show_urls | grep api/ivr` lista 9 rutas.
**Tiempo:** 20 min | **Depende de:** T-071

---

### T-073 — Test HTTP de todos los endpoints

```bash
curl "http://localhost:8000/api/ivr/reportes/clientes/?quarter=Q01_25"
# HTTP 200, 3 filas

curl "http://localhost:8000/api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=todas"
# HTTP 200, pct_del_total en rango 27-32%

curl "http://localhost:8000/api/ivr/reportes/clientes/?quarter=INVALIDO"
# HTTP 400, {"errores":["quarter inválido: INVALIDO"]}
```

**Criterio:** 9 endpoints responden. Parámetros inválidos → 400.
**Tiempo:** 45 min | **Depende de:** T-072

---

### T-074 — Test end-to-end cadena más larga (CentrosXSegmentoView → 11 nodos) *(NUEVA)*

**Origen:** Análisis de grafo — cadena de 11 nodos, la más larga del sistema.
Toca `ivr_es_dia_habil`, `ivr_contar_dias_habiles`, `ivr_agregar_dias_habiles`
y `fn_duracion_seg`. Ningún otro endpoint usa tantas funciones de utilidad.

```bash
# Test del endpoint más complejo
curl -v "http://localhost:8000/api/ivr/reportes/centros-segmento/?quarter=Q01_25"
```

```python
# Verificar que la respuesta contiene los campos calculados por las funciones
import requests
resp = requests.get(
    'http://localhost:8000/api/ivr/reportes/centros-segmento/',
    params={'quarter': 'Q01_25'}
)
assert resp.status_code == 200
data = resp.json()['datos']
assert len(data) > 0, "Debe retornar datos"

# Verificar que los campos de días hábiles están presentes
primer = data[0]
required = ['clasificacion_sla','dias_habiles_sin_actividad',
            'fecha_seguimiento_1_dia','fecha_seguimiento_3_dias',
            'fecha_escalamiento','llamadas_dias_habiles','pct_dias_habiles']
for campo in required:
    assert campo in primer, f"Campo faltante: {campo}"
    assert primer[campo] is not None, f"Campo None: {campo}"

# Verificar valores razonables
for row in data:
    assert row['clasificacion_sla'] in [
        'ACTIVO_HOY','DENTRO_SLA','RIESGO_SLA','FUERA_SLA',
        'VOLUMEN_MEDIO','BAJO_VOLUMEN'
    ], f"SLA inválido: {row['clasificacion_sla']}"
    assert 0 <= row.get('pct_dias_habiles',0) <= 100

print(f"OK: {len(data)} centros retornados con todos los campos correctos")
```

**Criterio:** HTTP 200. Todos los campos de días hábiles presentes y no-nulos.
`clasificacion_sla` es uno de los 6 valores válidos. `pct_dias_habiles` en [0,100].
**Riesgo:** ALTO — valida la cadena más larga incluyendo `ivr_es_dia_habil`
**Tiempo:** 30 min | **Depende de:** T-073, T-018

---

## FASE 6 — Scheduler y puesta en producción

*6 tareas (v1: 5, +1 nueva: T-085)*

### T-080 — Configurar APScheduler en Django

```python
scheduler.add_job(
    func=lambda: call_command('run_etl'),
    trigger=CronTrigger(hour=2, minute=0),
    id='etl_nocturno',
    replace_existing=True,
)
```

**Criterio:** Job `etl_nocturno` visible en `scheduler.get_jobs()`.
**Tiempo:** 45 min | **Depende de:** T-055

---

### T-081 — Crear MySQL Event evt_etl_diario

```sql
SET GLOBAL event_scheduler = ON;
CREATE EVENT IF NOT EXISTS evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
DO CALL sp_etl_maestro();
SHOW EVENTS FROM ivr_legacy;
```

**Criterio:** Event en `SHOW EVENTS` con `STATUS='ENABLED'`.
**Tiempo:** 20 min | **Depende de:** T-037

---

### T-082 — Test end-to-end del ciclo completo

```bash
python manage.py run_etl
curl "http://localhost:8000/api/ivr/pipeline/estado/"
mysql -e "SELECT step_name, status, duracion_seg FROM job_execution_log
          WHERE job_name='etl_diario' ORDER BY id DESC LIMIT 5;"
```

**Criterio:** `etl_runs.estado='exitoso'`. 3 checkpoints en log. API retorna datos.
**Tiempo:** 30 min | **Depende de:** T-080, T-081

---

### T-083 — Test de rendimiento de endpoints *(MODIFICADA)*

```bash
for ep in clientes centros abandonadas menu-redirigidos menu-centro cmenu-error; do
    time curl -s "http://localhost:8000/api/ivr/reportes/${ep}/?quarter=Q01_25" > /dev/null
done

# Especial: centros-segmento es la cadena más larga (11 nodos, WHILE O(n días))
time curl -s "http://localhost:8000/api/ivr/reportes/centros-segmento/?quarter=Q01_25" > /dev/null
```

**Umbrales (derivados del análisis de grafo):**

| Endpoint | SP | Tiempo esperado | Umbral |
|---|---|---|---|
| clientes | sp_rpt_clientes | < 200ms | < 500ms |
| abandonadas | sp_rpt_llamadas_abandonadas | < 500ms | < 1s |
| centros | sp_rpt_centros_transferencia | < 1s | < 3s |
| **centros-segmento** | **sp_rpt_centros_xsegmento** | **< 3s** | **< 8s** |

**Si `centros-segmento` supera 8s:** `ivr_contar_dias_habiles` usa un WHILE
O(n días) por cada fila del result set. Pre-computar `dias_habiles_sin_actividad`
en el ETL como columna de `base_ivr_detalle` o en una tabla auxiliar.

**Criterio:** Ningún endpoint supera su umbral máximo.
**Riesgo:** MEDIO | **Tiempo:** 30 min | **Depende de:** T-082

---

### T-084 — Documentar variables de entorno

```bash
# .env.example
IVR_DB_USER=django_user
IVR_DB_PASSWORD=changeme
IVR_DB_HOST=               # vacío = usa socket
IVR_DB_SOCKET=/run/mysqld/mysqld.sock
IVR_DB_NAME=ivr_legacy
ETL_TIMEOUT_MINUTES=30
ETL_SCHEDULE_HOUR=2
ETL_SCHEDULE_MINUTE=0
```

**Criterio:** `.env.example` commiteado. `settings.py` usa `os.environ.get()` para todo.
**Tiempo:** 20 min | **Depende de:** T-082

---

### T-085 — Crear query de monitoreo del ratio días hábiles *(NUEVA)*

**Origen:** Análisis de grafo — `ivr_es_dia_habil` genera fallos silenciosos
que afectan 18 nodos. Se necesita una query de monitoreo continuo para detectar
si el ratio empieza a desviarse sin que ningún componente lance excepciones.

```sql
-- Query de monitoreo — ejecutar semanalmente o después de cada ETL
-- Alertar si pct_habiles < 60% o > 85% en cualquier quarter

CREATE OR REPLACE VIEW vw_monitor_dias_habiles AS
SELECT
    trimestre,
    fecha,
    SUM(total_llamadas)        AS total,
    SUM(llamadas_dias_habiles) AS habiles,
    SUM(llamadas_fines_semana) AS fin_semana,
    -- Integridad: debe ser 0 siempre
    SUM(total_llamadas) - SUM(llamadas_dias_habiles)
        - SUM(llamadas_fines_semana)    AS error_suma,
    -- Ratio: fuera de [60%, 85%] indica problema en ivr_es_dia_habil
    ROUND(SUM(llamadas_dias_habiles)
          / NULLIF(SUM(total_llamadas),0) * 100, 1) AS pct_habiles,
    CASE
        WHEN SUM(total_llamadas)=0 THEN 'SIN_DATOS'
        WHEN SUM(total_llamadas) != SUM(llamadas_dias_habiles)
             + SUM(llamadas_fines_semana) THEN 'ERROR_INTEGRIDAD'
        WHEN SUM(llamadas_dias_habiles)/SUM(total_llamadas)*100 NOT BETWEEN 60 AND 85
            THEN 'ALERTA_RATIO'
        ELSE 'OK'
    END AS estado_monitor
FROM base_ivr_detalle
GROUP BY trimestre, fecha;

-- Verificar que no hay alertas activas post-backfill
SELECT * FROM vw_monitor_dias_habiles WHERE estado_monitor != 'OK';
-- Esperado: 0 filas
```

**Criterio:** Vista creada. `SELECT ... WHERE estado_monitor != 'OK'` retorna 0 filas.
**Riesgo:** MEDIO — detecta fallos futuros silenciosos de `ivr_es_dia_habil`
**Tiempo:** 20 min | **Depende de:** T-082

---

## Resumen de tareas por fase — v2

| Fase | Nombre | Tareas v1 | Tareas v2 | Tiempo est. |
|---|---|---|---|---|
| 0 | Verificación entorno | 5 | 5 | 1.5h |
| 1 | Funciones + Schema | 14 | **16** | 3.5h |
| 2 | SPs ETL | 8 | **9** | 4.5h |
| 3 | Backfill histórico | 5 | **6** | 2h |
| 4 | Django base + datos | 7 | **9** | 5.5h |
| 5 | SPs reporte + API | 14 | **15** | 6.5h |
| 6 | Scheduler + producción | 5 | **6** | 3.5h |
| **Total** | | **58** | **66** | **~27h** |

---

## Ruta crítica v2

Las tareas que bloquean directamente la puesta en producción:

```
T-001 → T-002 → T-003 → T-004  (entorno)
                   ↓
T-010 → T-013 → T-015 → T-019  (funciones — ALTA prioridad por fallo silencioso)
         ↓
T-020 → T-021 → T-030 → T-031 → T-032 → T-033 → T-034 → T-035
                                    ↓
                                   T-018  (verificación días hábiles — NUEVA)
                                    ↓
T-040 → T-041 → T-042 → T-043 → T-044 → T-044b (backfill + disable historico)
                                              ↓
T-060 → T-061 → T-062 → T-064 → T-065  (SPs reporte)
                                    ↓
T-070 → T-071 → T-072 → T-073 → T-074  (API + cadena más larga — NUEVA)
                                    ↓
T-080 → T-081 → T-082 → T-083 → T-085  (producción + monitoreo — NUEVA)
```

**37 tareas en la ruta crítica** (v1: 31). Las 29 restantes son paralelas.

---

## Puntos de decisión abiertos (sin cambios de v1)

| ID | Pregunta | Bloquea |
|---|---|---|
| P-NEW-04 | ¿`sp_etl_base_clientes` usa `cTelefono_Origen` o `cTelefono_Digitado`? | T-034 |
| P-Semana-Santa | ¿La función `ivr_es_dia_habil` debe incluir Jueves/Viernes Santo? | T-015 |

---

## Ver también

- `GRAFO-DEPENDENCIAS.md` — análisis que motivó esta versión del plan
- `FLUJO-ETL-V2.md` — arquitectura que el plan implementa
- `ANALISIS-ARQUITECTURA-ETL.md` — problemas de diseño resueltos en v2
- `PLAN-IMPLEMENTACION.md` — versión anterior (v1, 58 tareas)
- `provisioners/mariadb/` — los 4 SQL a desplegar en Fases 1 y 2

