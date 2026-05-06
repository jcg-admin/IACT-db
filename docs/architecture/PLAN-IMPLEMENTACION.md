# Plan de implementación — ETL IVR Pipeline v2.0

**Fecha:** 2026-05-06
**Versión del pipeline:** 2.0.0
**Repositorio:** IACT-db (rama develop)

---

## Resumen ejecutivo

| Dimensión | Valor |
|---|---|
| Fases | 6 |
| Tareas totales | 64 |
| Tareas críticas (ruta crítica) | 31 |
| Tiempo estimado total | ~52 horas |
| Filas a procesar (backfill) | 65,198,171 |
| Tiempo estimado backfill | ~50 minutos |

---

## Principios del plan

Cada tarea es **atómica**: tiene un único entregable verificable,
puede ejecutarse de forma independiente una vez cumplidas sus dependencias,
y su criterio de aceptación es binario (pasa / no pasa).

Las tareas se organizan en 6 fases con dependencia secuencial entre fases
y paralelismo posible dentro de algunas fases.

**Notación de riesgo:**
- BAJO — falla es recuperable sin pérdida de datos
- MEDIO — falla requiere reprocesamiento parcial
- ALTO — falla bloquea fases posteriores

---

## Diagrama de dependencias entre fases

```
FASE 0 — Verificación entorno
    │
    ▼
FASE 1 — Funciones de utilidad + Schema
    │
    ├──────────────────────┐
    ▼                      ▼
FASE 2 — SPs ETL    FASE 4 — Django base
    │                      │
    ▼                      │
FASE 3 — Backfill          │
    │                      │
    └──────────┬───────────┘
               ▼
         FASE 5 — SPs reporte + Django integración
               │
               ▼
         FASE 6 — Scheduler + Producción
```

---

## FASE 0 — Verificación del entorno

**Objetivo:** Confirmar que el entorno de ejecución cumple todos los
prerequisitos antes de tocar código.

**Tiempo estimado:** 2 horas

---

### T-001 — Verificar conectividad MariaDB

**Descripción:** Confirmar que el servidor IACT puede conectarse a la
instancia MariaDB donde residen las tablas `tbl_historico_*`.

**Comando de verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy -e "SELECT VERSION(), DATABASE();"
```

**Resultado esperado:**
```
VERSION()         DATABASE()
10.1.48-MariaDB   ivr_legacy
```

**Criterio de aceptación:** Retorna sin error, versión 10.1.x confirmada.
**Riesgo:** ALTO — bloquea todo lo demás.
**Tiempo estimado:** 15 min
**Depende de:** —

---

### T-002 — Verificar permisos GRANT en ivr_legacy

**Descripción:** Confirmar que `django_user` tiene SELECT en las tablas
fuente y CREATE/INSERT/DELETE/UPDATE en el schema propio de IACT.

**Comando de verificación:**
```sql
SHOW GRANTS FOR 'django_user'@'%';
-- Debe incluir:
-- GRANT SELECT ON `ivr_legacy`.`tbl_historico_*` TO 'django_user'@'%'
-- GRANT ALL PRIVILEGES ON `ivr_legacy`.* TO 'django_user'@'%'
-- (o equivalente con los privilegios mínimos necesarios)
```

**Resultado esperado:** Tiene SELECT en `tbl_historico_*` y CREATE FUNCTION,
CREATE PROCEDURE, CREATE TABLE, INSERT, DELETE, UPDATE en las tablas IACT.

**Criterio de aceptación:** Sin errores de permiso al intentar
`SELECT 1 FROM tbl_historico_t1_2025 LIMIT 1`.
**Riesgo:** ALTO
**Tiempo estimado:** 15 min
**Depende de:** T-001

---

### T-003 — Verificar existencia y estructura de tablas fuente

**Descripción:** Confirmar que las 6 tablas `tbl_historico_*` existen
y tienen las columnas que el ETL espera.

**Comando de verificación:**
```sql
SELECT TABLE_NAME, TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'ivr_legacy'
  AND TABLE_NAME LIKE 'tbl_historico_%'
ORDER BY TABLE_NAME;

DESCRIBE tbl_historico_t1_2025;
-- Verificar: dFecha, dHoraInicio, dHoraFin, cDID_800Transfer,
--            cDID_Centro_Transferencia, cMenu, cOpcion,
--            cTelefono_Origen, cTelefono_Digitado, cEtiquetacliente
```

**Resultado esperado:** 6 tablas presentes con las 10 columnas esperadas.
**Criterio de aceptación:** Todas las columnas del schema confirmadas. TABLE_ROWS > 0 en al menos t1_2025, t2_2025, t3_2025.
**Riesgo:** ALTO
**Tiempo estimado:** 20 min
**Depende de:** T-002

---

### T-004 — Verificar datos reales en tablas fuente

**Descripción:** Confirmar que las tablas fuente tienen los volúmenes
esperados y que los DIDs de segmento son los canónicos.

**Comando de verificación:**
```sql
SELECT
    'tbl_historico_t1_2025'   AS tabla,
    COUNT(*)                  AS total,
    COUNT(DISTINCT cDID_800Transfer) AS dids_distintos,
    MIN(dFecha)               AS desde,
    MAX(dFecha)               AS hasta
FROM tbl_historico_t1_2025;
-- Repetir para t2 y t3
```

**Resultado esperado:**
| Tabla | Total (aprox.) | DIDs distintos |
|---|---|---|
| t1_2025 | ~11.6M | 3 (19028031, 19020001, 19020084) |
| t2_2025 | ~13.6M | 3 |
| t3_2025 | ~11.5M | 3 |

**Criterio de aceptación:** Los 3 DIDs canónicos presentes, sin DIDs desconocidos con volumen significativo.
**Riesgo:** MEDIO
**Tiempo estimado:** 20 min
**Depende de:** T-003

---

### T-005 — Verificar estructura del proyecto Django

**Descripción:** Confirmar que el proyecto Django existe, tiene la
conexión base configurada y puede correr comandos de management.

**Comando de verificación:**
```bash
cd /ruta/al/proyecto/iact
python manage.py check --database default
python manage.py showmigrations | head -5
```

**Resultado esperado:** Sin errores de configuración. PostgreSQL operacional accesible.
**Criterio de aceptación:** `manage.py check` retorna sin errores críticos.
**Riesgo:** MEDIO
**Tiempo estimado:** 15 min
**Depende de:** —

---

## FASE 1 — Funciones de utilidad + Schema de tablas

**Objetivo:** Desplegar el Nivel 0 (funciones) y las tablas IACT.
Es el prerequisito más estricto — ningún SP del pipeline puede
ejecutarse sin estas funciones.

**Tiempo estimado:** 3 horas
**Puede correr en paralelo con:** FASE 4 (parcialmente)

---

### T-010 — Desplegar funciones_utilidad.sql

**Descripción:** Ejecutar el script en ivr_legacy. Crea las 7 funciones
de utilidad. El script incluye `DROP FUNCTION IF EXISTS` por lo que es
idempotente.

**Comando:**
```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/funciones_utilidad.sql
```

**Resultado esperado:** Sin errores. La sección de verificación al final
del script muestra el resultado de cada función en una tabla.

**Criterio de aceptación:** La tabla de verificación del script muestra
todos los valores esperados (ver T-011 a T-017).
**Riesgo:** BAJO
**Tiempo estimado:** 10 min
**Depende de:** T-002

---

### T-011 — Verificar fn_did_segmento

```sql
SELECT
    fn_did_segmento('19028031') AS nacional_a,   -- esperado: 'nacional_A'
    fn_did_segmento('19020001') AS nacional_b,   -- esperado: 'nacional_B'
    fn_did_segmento('19020084') AS puebla,        -- esperado: 'puebla'
    fn_did_segmento('99999999') AS desconocido;  -- esperado: 'desconocido'
```

**Criterio de aceptación:** Los 4 valores coinciden exactamente.
**Tiempo estimado:** 5 min | **Depende de:** T-010

---

### T-012 — Verificar fn_normalizar_menu

```sql
SELECT
    fn_normalizar_menu(NULL)               AS caso_null,   -- 'VACIO'
    fn_normalizar_menu('')                 AS caso_vacio,  -- 'VACIO'
    fn_normalizar_menu('sin cMenu')        AS caso_sincmenu, -- 'VACIO'
    fn_normalizar_menu('RES-FallaInternet') AS caso_normal; -- 'RES-FallaInternet'
```

**Criterio de aceptación:** 3 casos → 'VACIO', 1 caso → pass-through exacto.
**Tiempo estimado:** 5 min | **Depende de:** T-010

---

### T-013 — Verificar fn_normalizar_centro

```sql
SELECT
    fn_normalizar_centro(NULL)                     AS c1, -- 'CASO_NULL'
    fn_normalizar_centro('')                       AS c2, -- 'CASO_NULL'
    fn_normalizar_centro('cliente_colgo')          AS c3, -- 'CLIENTE_COLGO'
    fn_normalizar_centro('00000000')               AS c4, -- 'CASO_ERROR_CEROS'
    fn_normalizar_centro('@1234567')               AS c5, -- 'ERROR_CARACTER_INICIAL'
    fn_normalizar_centro('190100008190983030')     AS c6, -- '19010000' (NK90 len18)
    fn_normalizar_centro('13090048190983030')      AS c7, -- '1309004'  (NK90 len17)
    fn_normalizar_centro('3090048190983030')       AS c8, -- '309004'   (NK90 len16)
    fn_normalizar_centro('10828091')               AS c9; -- '10828091' (VDN limpio)
```

**Criterio de aceptación:** Los 9 casos retornan exactamente los valores esperados. Especialmente crítico: `'cliente_colgo'` → `'CLIENTE_COLGO'` (no pasa por NK90).
**Tiempo estimado:** 10 min | **Depende de:** T-010

---

### T-014 — Verificar fn_duracion_seg

```sql
SELECT
    fn_duracion_seg('2025-01-15 14:00:00', '2025-01-15 14:05:30') AS normal,   -- 330
    fn_duracion_seg('2025-01-15 14:35:00', '2025-01-15 13:58:00') AS g29,      -- 2220 (no negativo)
    fn_duracion_seg(NULL, '2025-01-15 14:00:00')                  AS con_null; -- 0
```

**Criterio de aceptación:** normal=330, g29=2220 (positivo), con_null=0.
**Tiempo estimado:** 5 min | **Depende de:** T-010

---

### T-015 — Verificar ivr_es_dia_habil

```sql
SELECT
    ivr_es_dia_habil('2025-01-06') AS lunes_normal,  -- TRUE
    ivr_es_dia_habil('2025-01-04') AS sabado,         -- FALSE
    ivr_es_dia_habil('2025-01-05') AS domingo,        -- FALSE
    ivr_es_dia_habil('2025-01-01') AS anio_nuevo,    -- FALSE
    ivr_es_dia_habil('2025-05-01') AS dia_trabajo,   -- FALSE
    ivr_es_dia_habil('2025-09-16') AS independencia; -- FALSE
```

**Criterio de aceptación:** Todos los valores coinciden exactamente.
**Tiempo estimado:** 5 min | **Depende de:** T-010

---

### T-016 — Verificar ivr_contar_dias_habiles

```sql
SELECT
    ivr_contar_dias_habiles('2025-01-01', '2025-01-31') AS enero_2025,   -- 22
    ivr_contar_dias_habiles('2025-04-01', '2025-06-30') AS q2_2025,      -- 65
    ivr_contar_dias_habiles('2025-07-01', '2025-09-30') AS q3_2025,      -- 66
    ivr_contar_dias_habiles('2025-01-15', '2025-01-15') AS mismo_dia_h,  -- 1 (si es lunes)
    ivr_contar_dias_habiles('2025-01-11', '2025-01-11') AS mismo_dia_f,  -- 0 (sábado)
    ivr_contar_dias_habiles('2025-03-31', '2025-01-01') AS rango_inv;    -- 0 (rango invertido)
```

**Criterio de aceptación:** enero=22, rango invertido=0.
**Tiempo estimado:** 10 min | **Depende de:** T-010

---

### T-017 — Verificar ivr_agregar_dias_habiles

```sql
SELECT
    ivr_agregar_dias_habiles('2025-01-31', 1) AS sig_dia_h,  -- 2025-02-03 (lunes)
    ivr_agregar_dias_habiles('2025-01-31', 3) AS tres_dias_h, -- 2025-02-05
    ivr_agregar_dias_habiles('2025-01-31', 5) AS cinco_dias_h, -- 2025-02-07
    ivr_agregar_dias_habiles('2025-01-15', 0) AS cero_dias;   -- 2025-01-15 (sin cambio)
```

**Criterio de aceptación:** Los 4 valores son fechas laborables válidas.
**Tiempo estimado:** 5 min | **Depende de:** T-010

---

### T-020 — Desplegar schema_base_ivr.sql

**Descripción:** Crea las 5 tablas IACT: `base_ivr_detalle`,
`base_ivr_clientes`, `job_execution_log`, `etl_runs`, `job_config`.
El script usa `CREATE TABLE IF NOT EXISTS` — es idempotente.

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/schema_base_ivr.sql
```

**Resultado esperado:** 5 tablas creadas. Verificación al final del
script muestra TABLE_NAME y CREATE_TIME de cada una.
**Criterio de aceptación:** Las 5 tablas aparecen en `information_schema.TABLES`.
**Riesgo:** BAJO
**Tiempo estimado:** 10 min | **Depende de:** T-010

---

### T-021 — Verificar base_ivr_detalle

```sql
DESCRIBE base_ivr_detalle;
SHOW INDEX FROM base_ivr_detalle;
-- Verificar columnas:
-- trimestre, fecha, segmento, centro_transferencia, menu, opcion,
-- total_llamadas, misma_linea, linea_diferente, no_digito_telefono,
-- llamadas_dias_habiles, llamadas_fines_semana, cargado_en
-- Verificar índices:
-- PRIMARY, idx_trim_seg_fecha, idx_trim_menu, idx_trim_centro,
-- idx_fecha_seg, uk_grain
```

**Criterio de aceptación:** 13 columnas presentes, 6 índices creados (incluido uk_grain).
**Tiempo estimado:** 10 min | **Depende de:** T-020

---

### T-022 — Verificar etl_runs con timeout_at

```sql
DESCRIBE etl_runs;
-- Verificar que timeout_at existe y tiene DEFAULT NULL o similar
-- Verificar INDEX idx_timeout (estado, timeout_at)

-- Test de inserción de prueba
INSERT INTO etl_runs
    (trimestre, iniciado_en, timeout_at, estado, ejecutado_por)
VALUES ('TEST', NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE), 'en_ejecucion', 'test');
SELECT * FROM etl_runs WHERE trimestre = 'TEST';
DELETE FROM etl_runs WHERE trimestre = 'TEST';
```

**Criterio de aceptación:** INSERT exitoso. Campo `timeout_at` presente y acepta DATETIME.
**Tiempo estimado:** 10 min | **Depende de:** T-020

---

### T-023 — Verificar job_config con datos iniciales

```sql
SELECT job_name, is_enabled, timeout_seconds
FROM job_config;
-- Esperado: 2 filas
-- etl_diario    | 1 | 1800
-- etl_historico | 0 | 7200
```

**Criterio de aceptación:** 2 filas con los valores correctos.
**Tiempo estimado:** 5 min | **Depende de:** T-020

---

## FASE 2 — SPs del pipeline ETL

**Objetivo:** Desplegar y verificar los 5 SPs del pipeline ETL.
Incluye tests individuales contra `tbl_historico_t1_2025` (datos reales).

**Tiempo estimado:** 4 horas
**Puede correr en paralelo con:** FASE 4

---

### T-030 — Desplegar sp_etl_pipeline.sql

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/sp_etl_pipeline.sql
```

**Resultado esperado:** 5 SPs creados sin errores de sintaxis.
**Criterio de aceptación:**
```sql
SHOW PROCEDURE STATUS WHERE Db = 'ivr_legacy'
  AND Name LIKE 'sp_etl%';
-- Esperado: 5 filas
-- sp_etl_base_clientes, sp_etl_base_detalle, sp_etl_historico,
-- sp_etl_maestro, sp_etl_validar
```
**Riesgo:** BAJO
**Tiempo estimado:** 10 min | **Depende de:** T-021

---

### T-031 — Test sp_etl_base_detalle en Q01_25 (subset)

**Descripción:** Ejecutar el ETL solo para enero 2025 (un mes) para
validar la lógica de normalización sin el tiempo completo del quarter.

```sql
-- Primero verificar que la tabla destino está vacía para este quarter
SELECT COUNT(*) FROM base_ivr_detalle WHERE trimestre = 'Q01_25';

-- Ejecutar solo para enero (un mes)
CALL sp_etl_base_detalle(
    'Q01_25',
    '2025-01-01',
    '2025-01-31',
    'tbl_historico_t1_2025',
    NULL  -- sin log_id para este test
);
```

**Resultado esperado:** Ejecución en ~1.5 min. Filas insertadas en `base_ivr_detalle`.
**Criterio de aceptación:**
```sql
SELECT
    COUNT(*)           AS filas_insertadas,
    SUM(total_llamadas) AS total_llamadas,
    COUNT(DISTINCT segmento) AS segmentos,   -- esperado: 3
    MIN(fecha)         AS min_fecha,         -- esperado: '202501'
    MAX(fecha)         AS max_fecha          -- esperado: '202501'
FROM base_ivr_detalle WHERE trimestre = 'Q01_25';
```
`total_llamadas` aproximadamente 3.8M (enero ~1/3 del quarter de 11.6M).
**Riesgo:** MEDIO — primer scan real de 11.6M filas.
**Tiempo estimado:** 30 min | **Depende de:** T-030

---

### T-032 — Verificar normalización de datos Q01_25 enero

**Descripción:** Confirmar que la normalización aplicada produce resultados
consistentes con los datos reales documentados en los reportes de referencia.

```sql
-- Verificar distribución de segmentos (esperado: ~45% A, ~30% B, ~25% Puebla)
SELECT segmento, SUM(total_llamadas) AS total,
       ROUND(SUM(total_llamadas) / SUM(SUM(total_llamadas)) OVER() * 100, 1) AS pct
FROM base_ivr_detalle WHERE trimestre = 'Q01_25'
GROUP BY segmento;

-- Verificar presencia de VACIO (esperado: ~8%)
SELECT menu, SUM(total_llamadas) AS total
FROM base_ivr_detalle WHERE trimestre = 'Q01_25' AND menu = 'VACIO';

-- Verificar ausencia de NK90 crudos en centro_transferencia
SELECT COUNT(*) AS nk90_crudos
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND LENGTH(centro_transferencia) > 10
  AND centro_transferencia NOT IN ('CASO_NULL','CLIENTE_COLGO',
      'CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL');
-- Esperado: 0 (todos los NK90 fueron normalizados)

-- Verificar llamadas_dias_habiles > 0
SELECT SUM(llamadas_dias_habiles), SUM(llamadas_fines_semana)
FROM base_ivr_detalle WHERE trimestre = 'Q01_25';
-- Esperado: ambas > 0, dias_habiles >> fines_semana (~80/20)
```

**Criterio de aceptación:** NK90 crudos = 0. Segmentos suman al total. `llamadas_dias_habiles` > 0.
**Riesgo:** MEDIO
**Tiempo estimado:** 20 min | **Depende de:** T-031

---

### T-033 — Verificar ON DUPLICATE KEY (idempotencia)

**Descripción:** Re-ejecutar el ETL del mismo mes y confirmar que no
duplica datos.

```sql
-- Registrar total antes
SELECT SUM(total_llamadas) AS antes FROM base_ivr_detalle
WHERE trimestre = 'Q01_25' AND fecha = '202501';

-- Re-ejecutar mismo mes
CALL sp_etl_base_detalle('Q01_25','2025-01-01','2025-01-31',
    'tbl_historico_t1_2025', NULL);

-- Verificar que total NO cambió
SELECT SUM(total_llamadas) AS despues FROM base_ivr_detalle
WHERE trimestre = 'Q01_25' AND fecha = '202501';
-- antes = despues
```

**Criterio de aceptación:** `antes` = `despues`. Sin duplicación de filas.
**Tiempo estimado:** 20 min | **Depende de:** T-032

---

### T-034 — Test sp_etl_base_clientes Q01_25

```sql
-- Limpiar clientes de Q01_25 (solo para el test)
DELETE FROM base_ivr_clientes WHERE trimestre = 'Q01_25';

CALL sp_etl_base_clientes(
    'Q01_25',
    '2025-01-01',
    '2025-03-31',
    'tbl_historico_t1_2025',
    NULL
);

SELECT * FROM base_ivr_clientes WHERE trimestre = 'Q01_25';
-- Esperado: 3 filas
-- nacional_A  ~9.8M–11.6M dependiendo de definitición (pendiente P-NEW-04)
-- nacional_B  ~3M (pero recuérdese el bug Q01: mislabel)
-- puebla      ~516K aprox
```

**Criterio de aceptación:** Exactamente 3 filas. `clientes_unicos` > 0 en las 3.
**Riesgo:** MEDIO
**Tiempo estimado:** 25 min | **Depende de:** T-030

---

### T-035 — Verificar sp_etl_validar

```sql
-- Con datos cargados de T-031 + T-034:
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok AS validacion_ok, @msg AS mensaje;
-- Esperado: @ok = 1, @msg = 'OK — X filas detalle, 3 filas clientes, ...'
```

**Criterio de aceptación:** `@ok = TRUE`. Mensaje contiene filas > 0 y clientes = 3.
**Tiempo estimado:** 5 min | **Depende de:** T-034

---

### T-036 — Verificar sp_etl_maestro — control de concurrencia

**Descripción:** Verificar que el mecanismo anti-concurrencia funciona
insertando manualmente un registro RUNNING y comprobando que el maestro
hace SKIP.

```sql
-- Simular job corriendo
INSERT INTO job_execution_log
    (job_name, step_name, status, start_time, ejecutado_por)
VALUES ('etl_diario', 'maestro', 'RUNNING', NOW(), 'test');
SET @fake_id = LAST_INSERT_ID();

-- Intentar ejecutar el maestro — debe hacer SKIP
CALL sp_etl_maestro();

-- Verificar que se insertó un registro SKIP
SELECT id, status, error_message
FROM job_execution_log
WHERE job_name = 'etl_diario' AND status = 'SKIP'
ORDER BY id DESC LIMIT 1;

-- Limpiar
UPDATE job_execution_log SET status='SUCCESS' WHERE id = @fake_id;
```

**Criterio de aceptación:** Aparece un registro `status='SKIP'` en `job_execution_log`.
**Tiempo estimado:** 10 min | **Depende de:** T-030

---

### T-037 — Verificar sp_etl_maestro — checkpoints por paso

**Descripción:** Ejecutar el maestro en condición normal (con `tbl_historico_t2_2026`
si existe, o habilitando un quarter que tenga tabla) y verificar que genera
3 registros en `job_execution_log` (maestro, etl_base_detalle, etl_base_clientes).

```sql
-- Verificar estructura del log después de una ejecución exitosa
SELECT step_name, status, records_procesados, duracion_seg
FROM job_execution_log
WHERE job_name = 'etl_diario'
ORDER BY id DESC LIMIT 10;
```

**Criterio de aceptación:** Se generan registros para cada paso con `status='SUCCESS'` o `status='FAILED'` (nunca queda en `RUNNING` sin actualizar).
**Tiempo estimado:** 20 min | **Depende de:** T-036

---

## FASE 3 — Carga histórica (backfill)

**Objetivo:** Poblar `base_ivr_detalle` y `base_ivr_clientes` con los
datos de los 5 quarters históricos (Q01_25 a Q01_26).

**Tiempo estimado:** 2 horas (incluyendo monitoreo)
**NOTA:** Esta fase es la más larga en tiempo de ejecución (~50 min de
procesamiento en MariaDB). Se puede iniciar y monitorear mientras avanza.

---

### T-040 — Backfill Q01_25

```bash
# Recomendado: ejecutar con nohup si es conexión SSH
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy -e "CALL sp_etl_historico(2025, 1);"
```

**Resultado esperado:**
```
quarter_procesado | ok | resultado
Q01_25            | 1  | OK — X filas detalle, 3 filas clientes, 11,643,679 llamadas totales
```

**Criterio de aceptación:**
```sql
SELECT COUNT(*), SUM(total_llamadas)
FROM base_ivr_detalle WHERE trimestre = 'Q01_25';
-- SUM(total_llamadas) ≈ 11,643,679
```
**Riesgo:** MEDIO — scan de 11.6M filas reales.
**Tiempo estimado:** 25 min (ejecución) + 10 min (verificación)
**Depende de:** T-037

---

### T-041 — Backfill Q02_25

```sql
CALL sp_etl_historico(2025, 2);
-- Verificar: SUM(total_llamadas) ≈ 13,612,375
```

**Resultado esperado:** Q02_25 con 3 meses en `base_ivr_detalle` y 3 filas en `base_ivr_clientes`.
**Criterio de aceptación:**
```sql
SELECT trimestre, COUNT(*), SUM(total_llamadas)
FROM base_ivr_detalle WHERE trimestre = 'Q02_25' GROUP BY trimestre;
```
**Tiempo estimado:** 30 min | **Depende de:** T-040

---

### T-042 — Backfill Q03_25

```sql
CALL sp_etl_historico(2025, 3);
-- Verificar: SUM(total_llamadas) ≈ 11,482,117
```

**Tiempo estimado:** 25 min | **Depende de:** T-041

---

### T-043 — Backfill Q04_25 y Q01_26

```sql
CALL sp_etl_historico(2025, 4);
CALL sp_etl_historico(2026, 1);
```

**Nota:** Estos quarters usan datos del seed (no datos reales). Los
totales dependen del tamaño del seed generado por `poblar_historico.py`.
**Tiempo estimado:** 25 min | **Depende de:** T-042

---

### T-044 — Verificar integridad del backfill completo

```sql
-- Resumen de todos los quarters cargados
SELECT
    trimestre,
    COUNT(*)                       AS filas_detalle,
    FORMAT(SUM(total_llamadas), 0) AS total_llamadas,
    COUNT(DISTINCT segmento)       AS segmentos
FROM base_ivr_detalle
GROUP BY trimestre ORDER BY trimestre;

-- Verificar base_ivr_clientes
SELECT trimestre, segmento, clientes_unicos
FROM base_ivr_clientes ORDER BY trimestre, segmento;
-- Esperado: 15 filas (5 quarters × 3 segmentos)

-- Verificar job_execution_log
SELECT quarter_name, step_name, status, duracion_seg
FROM job_execution_log
WHERE job_name = 'etl_historico'
ORDER BY id;
```

**Criterio de aceptación:** 5 quarters en `base_ivr_detalle`, 15 filas en `base_ivr_clientes`. Ningún `status='FAILED'`.
**Riesgo:** BAJO
**Tiempo estimado:** 15 min | **Depende de:** T-043

---

## FASE 4 — Django: base y capa de datos

**Objetivo:** Configurar Django para conectarse a MariaDB y crear la
capa de servicio que consume los SPs de reporte.

**Tiempo estimado:** 5 horas
**Puede empezar desde:** Fase 1 completada (no requiere datos en base_ivr_*)

---

### T-050 — Configurar DATABASES['ivr'] en settings.py

**Descripción:** Agregar la conexión MariaDB al diccionario `DATABASES`
del proyecto Django.

```python
# settings.py
DATABASES = {
    'default': { ... },  # PostgreSQL existente — no modificar
    'ivr': {
        'ENGINE':   'django.db.backends.mysql',
        'NAME':     'ivr_legacy',
        'USER':     os.environ.get('IVR_DB_USER', 'django_user'),
        'PASSWORD': os.environ.get('IVR_DB_PASSWORD', 'django_pass'),
        'HOST':     os.environ.get('IVR_DB_HOST', ''),
        'PORT':     '',
        'OPTIONS': {
            'charset':     'utf8mb4',
            'unix_socket': os.environ.get('IVR_DB_SOCKET', '/run/mysqld/mysqld.sock'),
        },
    }
}
```

**Criterio de aceptación:**
```bash
python manage.py dbshell --database=ivr
# Abre un prompt MySQL sin errores
```
**Riesgo:** MEDIO
**Tiempo estimado:** 30 min | **Depende de:** T-005

---

### T-051 — Crear IVRRouter

**Descripción:** Router que dirige las queries de modelos IVR a la
conexión `'ivr'` y evita migraciones accidentales en esa BD.

```python
# iact/routers.py
class IVRRouter:
    """Rutas las queries de modelos con app_label='ivr' a la BD MariaDB."""
    def db_for_read(self, model, **hints):
        if model._meta.app_label == 'ivr':
            return 'ivr'
        return None

    def db_for_write(self, model, **hints):
        if model._meta.app_label == 'ivr':
            return 'ivr'
        return None

    def allow_migrate(self, db, app_label, **hints):
        if app_label == 'ivr':
            return False   # nunca migrar en MariaDB con Django
        return None

# settings.py
DATABASE_ROUTERS = ['iact.routers.IVRRouter']
```

**Criterio de aceptación:**
```bash
python manage.py migrate --database=ivr
# Debe mostrar 'No migrations to apply' — no aplica migraciones en ivr
```
**Tiempo estimado:** 30 min | **Depende de:** T-050

---

### T-052 — Verificar cursor.callproc() desde Django

```python
# Shell de Django (python manage.py shell)
from django.db import connections

with connections['ivr'].cursor() as cursor:
    cursor.execute("SELECT VERSION(), DATABASE()")
    print(cursor.fetchone())
    # ('10.1.48-MariaDB', 'ivr_legacy')
```

**Criterio de aceptación:** Retorna versión y database correctas sin errores.
**Tiempo estimado:** 15 min | **Depende de:** T-051

---

### T-053 — Crear services/ivr_reports.py

**Descripción:** Motor `_call_sp()` compartido y los 7 métodos de
acceso a los SPs de reporte.

```python
# services/ivr_reports.py
from django.db import connections

QUARTERS_VALIDOS  = {'Q01_25','Q02_25','Q03_25','Q04_25','Q01_26','Q02_26'}
SEGMENTOS_VALIDOS = {'todas','nacional_A','nacional_B','puebla'}

def _call_sp(sp_name: str, params: list) -> list[dict]:
    with connections['ivr'].cursor() as cursor:
        cursor.callproc(sp_name, params)
        cols = [c[0] for c in cursor.description]
        return [dict(zip(cols, row)) for row in cursor.fetchall()]

def get_clientes(quarter: str) -> list[dict]:
    return _call_sp('sp_rpt_clientes', [quarter])

# ... 6 métodos más
```

**Criterio de aceptación:** Módulo importable sin errores. `get_clientes('Q01_25')` retorna lista de dicts (requiere FASE 3 completada).
**Tiempo estimado:** 45 min | **Depende de:** T-052

---

### T-054 — Crear services/ivr_pipeline.py

**Descripción:** Servicios para consultar el estado del ETL y disparar
re-ejecuciones desde la UI.

```python
# services/ivr_pipeline.py
def get_etl_status(limit: int = 20) -> list[dict]:
    """Retorna los últimos N registros de etl_runs."""

def get_job_log(quarter: str = None, limit: int = 50) -> list[dict]:
    """Retorna registros de job_execution_log con filtro opcional por quarter."""

def trigger_etl(quarter: str, ejecutado_por: str) -> int:
    """Inserta en etl_runs con estado='en_ejecucion'. Retorna run_id."""
```

**Criterio de aceptación:** `get_etl_status()` retorna lista (posiblemente vacía). `trigger_etl()` retorna un entero (run_id).
**Tiempo estimado:** 30 min | **Depende de:** T-053

---

### T-055 — Crear management/commands/run_etl.py

**Descripción:** Management command con heartbeat en thread paralelo.

**Estructura del comando:**
```python
class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--quarter')
        parser.add_argument('--force', action='store_true')

    def handle(self, *args, **options):
        # 1. Insertar en etl_runs con timeout_at = NOW() + 30 min
        # 2. Iniciar heartbeat thread
        # 3. CALL sp_etl_maestro()
        # 4. Actualizar etl_runs (exitoso/fallido)
        # 5. Detener heartbeat thread
```

**Criterio de aceptación:**
```bash
python manage.py run_etl --help
# Muestra los argumentos sin errores de importación

python manage.py run_etl
# Inserta en etl_runs y llama sp_etl_maestro()
# Al finalizar: etl_runs.estado IN ('exitoso', 'fallido')
```
**Riesgo:** MEDIO — requiere correcta sincronización de threads.
**Tiempo estimado:** 2 horas | **Depende de:** T-054

---

### T-056 — Test heartbeat timeout

**Descripción:** Verificar que el heartbeat detecta y marca correctamente
un ETL que supera el timeout.

```python
# Insertar en etl_runs con timeout_at en el pasado
with connections['ivr'].cursor() as c:
    c.execute("""
        INSERT INTO etl_runs (trimestre, iniciado_en, timeout_at, estado)
        VALUES ('TEST', NOW(), DATE_SUB(NOW(), INTERVAL 1 MINUTE), 'en_ejecucion')
    """)
    run_id = c.lastrowid

# Invocar el método heartbeat manualmente
# Verificar que marca estado='timeout'
with connections['ivr'].cursor() as c:
    c.execute("SELECT estado FROM etl_runs WHERE id=%s", [run_id])
    assert c.fetchone()[0] == 'timeout'
```

**Criterio de aceptación:** El registro con `timeout_at` en el pasado queda marcado como `'timeout'`.
**Tiempo estimado:** 30 min | **Depende de:** T-055

---

## FASE 5 — SPs de reporte + API REST

**Objetivo:** Desplegar los 7 SPs de reporte, verificar cada uno con
datos reales del backfill, y exponer todos como endpoints DRF.

**Tiempo estimado:** 6 horas
**Prerequisito:** FASE 3 completada (base_ivr_* con datos)

---

### T-060 — Desplegar sp_rpt_reportes.sql

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy < provisioners/mariadb/sp_rpt_reportes.sql
```

**Criterio de aceptación:**
```sql
SHOW PROCEDURE STATUS WHERE Db = 'ivr_legacy' AND Name LIKE 'sp_rpt%';
-- 7 filas: sp_rpt_clientes, sp_rpt_centros_transferencia,
--          sp_rpt_llamadas_abandonadas, sp_rpt_menu_redirigidos,
--          sp_rpt_menu_centro, sp_rpt_cMENU_ERROR, sp_rpt_centros_xsegmento
```
**Riesgo:** BAJO
**Tiempo estimado:** 10 min | **Depende de:** T-044

---

### T-061 — Verificar sp_rpt_clientes

```sql
CALL sp_rpt_clientes('Q01_25');
-- Esperado: 3 filas, SUM(clientes_unicos) ≈ 9.6M (datos reales)
-- pct_del_total debe sumar ~100%
```

**Criterio de aceptación:** 3 filas. `SUM(pct_del_total)` ≈ 100%. `clientes_unicos > 0` en las 3.
**Tiempo estimado:** 10 min | **Depende de:** T-060

---

### T-062 — Verificar sp_rpt_llamadas_abandonadas con datos reales

```sql
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'todas');
-- Esperado: 3 filas (VACIO, cliente_colgo, SinOpcion_Cabecera)
-- pct_del_total combinado ≈ 27-32% (BR-016 recalibrado)
-- clasificacion_sla: probablemente 'CRITICO' o 'ACEPTABLE'

CALL sp_rpt_llamadas_abandonadas('Q01_25', 'nacional_A');
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'puebla');
```

**Criterio de aceptación:** Porcentajes consistentes con `REPORTE-PROM-LLAMADAS.md` (29-32% real Q1).
**Tiempo estimado:** 15 min | **Depende de:** T-060

---

### T-063 — Verificar sp_rpt_cMENU_ERROR con Q03_25

```sql
CALL sp_rpt_cMENU_ERROR('Q03_25', 'todas');
-- Q03_25 tiene ~111 teléfonos como cMenu en Nacional y ~297 en Puebla
-- Esperado: filas con menu REGEXP '^[0-9]+$'
-- centro_transferencia = '19020086' (bucket de abandono)
```

**Criterio de aceptación:** Retorna filas (no vacío para Q03_25). `centro_transferencia` dominante = '19020086'.
**Tiempo estimado:** 10 min | **Depende de:** T-060

---

### T-064 — Verificar sp_rpt_centros_xsegmento

```sql
CALL sp_rpt_centros_xsegmento('Q01_25');
-- Verificar columnas:
-- clasificacion_sla no es NULL
-- dias_habiles_sin_actividad >= 0
-- fecha_seguimiento_1_dia > ultima_actividad
-- pct_del_segmento suma ≈ 100% por segmento
-- llamadas_dias_habiles > 0 para los centros activos
```

**Criterio de aceptación:** Sin errores. `fecha_seguimiento_*` son fechas válidas. `clasificacion_sla` es uno de los 6 valores válidos.
**Riesgo:** MEDIO — este SP es el más complejo y usa todas las funciones `ivr_*`.
**Tiempo estimado:** 20 min | **Depende de:** T-060

---

### T-065 — Verificar patrón p_segmento='todas' en todos los SPs

**Descripción:** Confirmar que el patrón unificado de filtro funciona
correctamente — que `p_segmento='todas'` retorna la suma de los 3 segmentos.

```sql
-- Para sp_rpt_llamadas_abandonadas:
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'todas');       -- A
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'nacional_A');  -- B1
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'nacional_B');  -- B2
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'puebla');      -- B3

-- SUM de B1+B2+B3 por menu = A para ese mismo menu
```

**Criterio de aceptación:** Los totales de los 3 segmentos suman el total de 'todas'.
**Tiempo estimado:** 20 min | **Depende de:** T-062

---

### T-070 — Crear views/ivr_reports.py

**Descripción:** 7 vistas DRF con validación de parámetros `quarter` y
`segmento` antes de llamar al servicio.

**Estructura:**
```python
class LlamadasAbandonadasView(APIView):
    def get(self, request):
        quarter  = request.query_params.get('quarter', 'Q01_25')
        segmento = request.query_params.get('segmento', 'todas')
        errores  = _validar(quarter=quarter, segmento=segmento)
        if errores:
            return Response({'errores': errores}, status=400)
        data = ivr_reports.get_abandonadas(quarter, segmento)
        return Response({'quarter': quarter, 'segmento': segmento,
                         'total_filas': len(data), 'datos': data})
```

**Criterio de aceptación:** Las 7 vistas importan sin errores. Parámetros inválidos retornan HTTP 400 con descripción del error.
**Tiempo estimado:** 2 horas | **Depende de:** T-053

---

### T-071 — Crear views/ivr_pipeline.py

**Descripción:** 2 vistas para monitoreo y control del ETL.

```python
class ETLEstadoView(APIView):
    """GET /api/ivr/pipeline/estado/ — últimos N registros de etl_runs"""

class ETLReintentarView(APIView):
    """POST /api/ivr/pipeline/reintentar/ {"quarter": "Q02_26"}
    Llama manage.py run_etl en background — retorna run_id"""
```

**Criterio de aceptación:** GET retorna lista de ejecuciones. POST retorna `{"run_id": N, "estado": "en_ejecucion"}`.
**Tiempo estimado:** 45 min | **Depende de:** T-054

---

### T-072 — Crear urls/ivr.py y registrar en urls.py principal

```python
# urls/ivr.py
urlpatterns = [
    path('reportes/clientes/',          ClientesView.as_view()),
    path('reportes/centros/',            CentrosTransferenciaView.as_view()),
    path('reportes/centros-segmento/',   CentrosXSegmentoView.as_view()),
    path('reportes/abandonadas/',        LlamadasAbandonadasView.as_view()),
    path('reportes/menu-redirigidos/',   MenuRedirigidosView.as_view()),
    path('reportes/menu-centro/',        MenuCentroView.as_view()),
    path('reportes/cmenu-error/',        CMENUErrorView.as_view()),
    path('pipeline/estado/',             ETLEstadoView.as_view()),
    path('pipeline/reintentar/',         ETLReintentarView.as_view()),
]

# urls.py principal
path('api/ivr/', include('urls.ivr')),
```

**Criterio de aceptación:** `python manage.py show_urls | grep api/ivr` lista las 9 rutas.
**Tiempo estimado:** 20 min | **Depende de:** T-071

---

### T-073 — Test HTTP de todos los endpoints

```bash
# Usando httpx, curl o el browsable API de DRF
curl "http://localhost:8000/api/ivr/reportes/clientes/?quarter=Q01_25"
# Esperado: HTTP 200, JSON con 3 filas

curl "http://localhost:8000/api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=todas"
# Esperado: HTTP 200, JSON con 3 filas, pct_del_total en rango 27-32%

curl "http://localhost:8000/api/ivr/reportes/centros-segmento/?quarter=Q01_25"
# Esperado: HTTP 200, JSON con filas de los 3 segmentos

curl "http://localhost:8000/api/ivr/reportes/cmenu-error/?quarter=Q03_25&segmento=todas"
# Esperado: HTTP 200, JSON con filas de teléfonos como cMenu

# Test validación
curl "http://localhost:8000/api/ivr/reportes/clientes/?quarter=INVALIDO"
# Esperado: HTTP 400, {"errores": ["quarter inválido: INVALIDO"]}
```

**Criterio de aceptación:** 9 endpoints responden. Parámetros inválidos retornan 400. Datos Q01_25 consistentes con los reales documentados.
**Riesgo:** MEDIO
**Tiempo estimado:** 45 min | **Depende de:** T-072

---

## FASE 6 — Scheduler y puesta en producción

**Objetivo:** Configurar los dos mecanismos de disparo automático del ETL
y verificar que el ciclo completo funciona end-to-end en producción.

**Tiempo estimado:** 3 horas

---

### T-080 — Configurar APScheduler en Django

```python
# apps.py del módulo IVR (o scheduler.py)
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger

scheduler = BackgroundScheduler()

def setup_etl_scheduler():
    scheduler.add_job(
        func   = lambda: call_command('run_etl'),
        trigger= CronTrigger(hour=2, minute=0),
        id     = 'etl_nocturno',
        replace_existing = True,
    )
    scheduler.start()
```

**Criterio de aceptación:** `python manage.py runserver` inicia sin errores de scheduler. `scheduler.get_jobs()` lista el job `etl_nocturno`.
**Riesgo:** BAJO
**Tiempo estimado:** 45 min | **Depende de:** T-055

---

### T-081 — Crear MySQL Event evt_etl_diario

```sql
-- Verificar que el Event Scheduler está habilitado
SHOW VARIABLES LIKE 'event_scheduler';
-- Si OFF: SET GLOBAL event_scheduler = ON;

-- Crear el Event
CREATE EVENT IF NOT EXISTS evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
COMMENT 'ETL IVR nocturno — ejecuta sp_etl_maestro()'
DO CALL sp_etl_maestro();

SHOW EVENTS FROM ivr_legacy;
```

**Criterio de aceptación:** El Event aparece en `SHOW EVENTS` con `STATUS='ENABLED'`.
**Riesgo:** BAJO
**Tiempo estimado:** 20 min | **Depende de:** T-037

---

### T-082 — Test end-to-end del ciclo completo

**Descripción:** Simular un ciclo completo de ETL manual y verificar
que todos los componentes interactúan correctamente.

```bash
# 1. Disparar ETL manualmente
python manage.py run_etl

# 2. Verificar estado en etl_runs
curl "http://localhost:8000/api/ivr/pipeline/estado/"

# 3. Verificar que job_execution_log tiene los checkpoints
mysql -e "SELECT step_name, status, duracion_seg FROM job_execution_log \
          WHERE job_name='etl_diario' ORDER BY id DESC LIMIT 5;"

# 4. Verificar que los datos del quarter se actualizaron
curl "http://localhost:8000/api/ivr/reportes/clientes/?quarter=Q02_26"
```

**Criterio de aceptación:** `etl_runs.estado = 'exitoso'`. 3 checkpoints en `job_execution_log`. API retorna datos actualizados.
**Riesgo:** MEDIO
**Tiempo estimado:** 30 min | **Depende de:** T-080, T-081

---

### T-083 — Test de rendimiento de endpoints

**Descripción:** Medir tiempos de respuesta de cada endpoint con datos
reales del backfill (base_ivr_detalle con 5 quarters).

```bash
# Medir tiempo de respuesta
for endpoint in clientes centros abandonadas menu-redirigidos \
                menu-centro cmenu-error centros-segmento; do
    time curl -s "http://localhost:8000/api/ivr/reportes/${endpoint}/?quarter=Q01_25&segmento=todas" > /dev/null
done
```

**Resultado esperado:**
| SP | Tiempo esperado |
|---|---|
| `sp_rpt_clientes` | < 200ms |
| `sp_rpt_llamadas_abandonadas` | < 500ms |
| `sp_rpt_centros_transferencia` | < 1s |
| `sp_rpt_centros_xsegmento` | < 3s (usa funciones ivr_*) |

**Criterio de aceptación:** Ningún endpoint supera 5 segundos con datos de un quarter.
**Riesgo:** MEDIO — `sp_rpt_centros_xsegmento` llama a `ivr_contar_dias_habiles` por cada fila del result set.
**Tiempo estimado:** 30 min | **Depende de:** T-082

---

### T-084 — Documentar variables de entorno

**Descripción:** Crear `.env.example` con todas las variables necesarias
para el despliegue.

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

**Criterio de aceptación:** Archivo `.env.example` commiteado. `settings.py` usa `os.environ.get()` para todas las variables.
**Tiempo estimado:** 20 min | **Depende de:** T-082

---

## Resumen de tareas por fase

| Fase | Nombre | Tareas | Tiempo est. | Bloqueada por |
|---|---|---|---|---|
| 0 | Verificación entorno | 5 | 1.5h | — |
| 1 | Funciones + Schema | 14 | 3h | Fase 0 |
| 2 | SPs ETL | 8 | 4h | Fase 1 |
| 3 | Backfill histórico | 5 | 2h | Fase 2 |
| 4 | Django base + capa datos | 7 | 5h | Fase 1 (parcial) |
| 5 | SPs reporte + API REST | 14 | 6h | Fases 3 y 4 |
| 6 | Scheduler + producción | 5 | 3h | Fases 2, 4, 5 |
| **Total** | | **58** | **~24.5h** | |

---

## Ruta crítica

Las tareas que bloquean directamente la puesta en producción:

```
T-001 → T-002 → T-003 → T-004  (entorno)
                   ↓
T-010 → T-020 → T-030 → T-031 → T-032 → T-033 → T-034 → T-035 (funciones + ETL)
                                                              ↓
T-040 → T-041 → T-042 → T-043 → T-044  (backfill)
                                    ↓
T-060 → T-061 → T-062 → T-064 → T-065  (SPs reporte)
                                    ↓
T-070 → T-071 → T-072 → T-073  (API REST)
                                    ↓
T-080 → T-081 → T-082 → T-083 → T-084  (producción)
```

**31 tareas en la ruta crítica** — las restantes 27 pueden hacerse en paralelo.

---

## Tareas que pueden hacerse en paralelo

Una vez completada la **Fase 1**:
- La **Fase 4** (Django base: T-050 a T-056) puede empezar independientemente
  de la **Fase 2** (SPs ETL). No necesita datos en `base_ivr_*` hasta T-053.
- La documentación y variables de entorno (T-084) pueden prepararse en cualquier momento.

---

## Puntos de decisión (requieren confirmación del equipo)

| ID | Pregunta | Bloquea | Estado |
|---|---|---|---|
| P-NEW-04 | ¿`sp_etl_base_clientes` usa `cTelefono_Origen` o `cTelefono_Digitado`? | T-034 | Pendiente |
| P-NEW-07 | ¿El duplicado Nacional en llamadas_cmenu es bug o comportamiento esperado? | T-065 | Pendiente |
| R-10 | ¿`job_execution_log` o `etl_runs` es la fuente de verdad en la UI? | T-071 | Resuelta: `etl_runs` |

---

## Ver también

- `FLUJO-ETL-V2.md` — arquitectura que este plan implementa
- `ANALISIS-ARQUITECTURA-ETL.md` — problemas que motivaron el diseño v2
- `provisioners/mariadb/` — los 4 archivos SQL a desplegar
- `perfiles/` — seed de datos por quarter para testing

