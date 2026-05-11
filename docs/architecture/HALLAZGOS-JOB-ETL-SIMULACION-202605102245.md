# Simulación de producción — Job ETL IVR (5 escenarios)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Entorno:** MariaDB 10.11.14, ivr_legacy sandbox  
**Datos fuente:** 83K–96K filas por quarter (poblar_historico.py 50K base)  
**Script de simulación:** `/tmp/simular_job.py`

---

## Por qué el job es el componente más importante

El grafo de dependencias del pipeline tiene 7 niveles. El job (Nivel 5)
es el único punto donde convergen los tres sistemas:

```
MariaDB (sp_etl_maestro)    ← job_config, job_execution_log
Django (run_etl.py)         ← etl_runs, heartbeat thread
MySQL Event Scheduler       ← evt_etl_diario (02:00 AM)
```

Sin el job, `base_ivr_detalle` nunca se actualiza. Sin `base_ivr_detalle`
actualizado, los 7 SPs de reporte devuelven datos obsoletos. Sin SPs de
reporte, los 9 endpoints Django sirven datos incorrectos.

El job también es el componente más frágil: puede fallar por concurrencia,
por configuración, por timeout, o por que el event_scheduler esté OFF.

---

## Datos de entrada de la simulación

| Tabla | Filas | Menús | G-29 |
|---|---|---|---|
| tbl_historico_t1_2025 | 83,085 | 44 | 38.8% |
| tbl_historico_t2_2025 | 96,244 | 50 | 38.8% |
| tbl_historico_t3_2025 | 81,091 | 55 | 38.6% |
| tbl_historico_t4_2025 | 88,094 | 55 | 38.8% |
| tbl_historico_t1_2026 | 85,588 | 44 | 38.6% |
| tbl_historico_t2_2026 | 39,410 | 50 | 38.2% |

Todas las distribuciones dentro de ±0.5pp del objetivo (G-29=38.8%,
null=21.2%, misma=28.2%). Catálogo real de perfiles por quarter activo.

---

## Escenario A — evt_etl_diario (MySQL Event, 02:00 AM)

**Pregunta:** ¿Qué hace exactamente el event cuando dispara?

```sql
-- Código del event (sp_etl_pipeline.sql):
CREATE EVENT evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
DO CALL sp_etl_maestro();
```

**Resultado de la simulación:**

```
[15:23:53] CALL sp_etl_maestro() ...
[15:23:55] Completado en 1.9s

job_execution_log: +3 filas (maestro, etl_base_detalle, etl_base_clientes)
etl_runs: sin cambio (el event NO registra en etl_runs)

Q02_26: 1,752 filas grain → 39,410 llamadas procesadas
```

**Lo que hace el event vs lo que NO hace:**

| Acción | evt_etl_diario | manage.py run_etl |
|---|---|---|
| CALL sp_etl_maestro() | Sí | Sí |
| INSERT en etl_runs | **No** | Sí |
| Heartbeat thread | **No** | Sí |
| UPDATE etl_runs en finally | **No** | Sí |
| Registra en job_execution_log | Sí (via el SP) | Sí (via el SP) |

El event es el mecanismo de producción nocturno. La UI Django (`ETLEstadoView`)
lee `etl_runs` — si el ETL corrió solo por el event, la UI no tendrá registros
para mostrar. En producción se espera que APScheduler llame `run_etl` también.

---

## Escenario B — manage.py run_etl (heartbeat real)

**Pregunta:** ¿Qué hace el management command que el event no hace?

**Resultado de la simulación:**

```
quarter_activo(): Q02_26  (2026-05-10)

[15:23:56] etl_runs INSERT: id=2, timeout_at=2026-05-10 15:53:56
[15:23:56] threading.Thread heartbeat iniciado (intervalo=60s)
[15:23:56] callproc('sp_etl_maestro', []) ...
[15:23:57] sp_etl_maestro completado en 1.7s

Heartbeat ticks: 0  ← el SP terminó en <3s, sin tiempo de tick
Estado final etl_runs id=2:
  trimestre=Q02_26, status=success, trigger_source=django_command
  inicio_at=15:23:56, fin_at=15:23:57, heartbeat_at=NULL
```

**Observación sobre heartbeat_at=NULL:**

Con datos de seed (~39K filas), el SP tarda ~2 segundos. El thread de
heartbeat tiene un intervalo de 60 segundos (3s en la simulación acelerada).
Como el SP terminó antes del primer tick, `heartbeat_at` quedó en NULL.

En producción con 11–14M filas reales por quarter, el SP tarda ~9 minutos
(~540 segundos). El heartbeat actualizaría `heartbeat_at` unas 9 veces:

```
tick 1:   t+60s   heartbeat_at = inicio + 1 min
tick 2:   t+120s  heartbeat_at = inicio + 2 min
...
tick 9:   t+540s  heartbeat_at = inicio + 9 min
fin:      t+541s  UPDATE etl_runs status='success', fin_at = NOW()
```

Si el SP se colgara en el tick 5 y no respondiera más, el heartbeat en
t+360s detectaría `timeout_at < NOW()` y marcaría `status='timeout'`.

**El ciclo de vida completo de etl_runs:**

```
INSERT  → status='en_ejecucion', timeout_at=NOW()+30min
           (heartbeat loop cada 60s actualiza heartbeat_at)
           (heartbeat detecta timeout_at<NOW() → status='timeout')
UPDATE  → status='success'|'failed'  (en finally del command)
```

---

## Escenario C — Protección de concurrencia

**Pregunta:** ¿Qué pasa si dos instancias del job intentan correr a la vez?

**Mecanismo:** `sp_etl_maestro` consulta `job_execution_log` antes de
procesar. Si hay un `maestro` con `status='RUNNING'` en las últimas 6 horas,
inserta un SKIP y aborta:

```sql
IF EXISTS (
    SELECT 1 FROM job_execution_log
    WHERE job_name = 'etl_diario'
      AND step_name = 'maestro'
      AND status = 'RUNNING'
      AND start_time > DATE_SUB(NOW(), INTERVAL 6 HOUR)
) THEN
    INSERT ... status='SKIP', error='Otro job etl_diario está RUNNING...'
    SET v_abort = TRUE;
END IF;
```

**Resultado de la simulación:**

```
[15:23:58] Insertado maestro RUNNING en job_execution_log (id=30)
[15:23:58] CALL sp_etl_maestro() — debería hacer SKIP ...
[15:23:58] job_execution_log: +1 fila
Última fila: maestro | SKIP | Otro job etl_diario está RUNNING en las últimas 6 horas.
```

**Comportamiento correcto.** El maestro detectó el RUNNING y no procesó nada.
`base_ivr_detalle` no fue modificado.

**Caso edge importante:** Este mecanismo protege contra concurrencia de
`evt_etl_diario` (si el event dispara varias veces por un reloj inestable).
Sin embargo, si `run_etl` llama al SP pero el SP sale limpiamente
(ej. SKIP por concurrencia), `etl_runs` igualmente quedará con
`status='success'` porque el command Django no diferencia entre
"SP corrió y procesó" y "SP corrió pero insertó SKIP". La UI Django
mostraría un run exitoso aunque no se procesaran datos.

---

## Escenario D — Job deshabilitado

**Pregunta:** ¿Cómo se para el ETL sin modificar código?

```sql
UPDATE job_config SET is_enabled = 0 WHERE job_name = 'etl_diario';
```

El SP maestro lee `job_config` como PASO 0. Con `is_enabled=0`:

```
[15:23:58] job_config: etl_diario.is_enabled = 0
[15:23:58] CALL sp_etl_maestro()
[15:23:58] job_execution_log: +1 fila
Última fila: maestro | SKIP
```

`base_ivr_detalle` no fue modificado. `etl_runs` tampoco (el command
Django registra el run como `success` igual — el SP salió sin error).

**Casos de uso:**
- Mantenimiento planificado: deshabilitar antes de migraciones de schema
- Debug: deshabilitar para analizar datos sin que el ETL sobrescriba
- Re-procesamiento manual: deshabilitar diario, correr histórico a mano

Re-habilitación:
```sql
UPDATE job_config SET is_enabled = 1 WHERE job_name = 'etl_diario';
```

---

## Escenario E — Detección de timeout por heartbeat

**Pregunta:** ¿Qué pasa si el SP se cuelga indefinidamente?

Simulando un SP que lleva 35 minutos corriendo (timeout=30 min):

```
Insertado etl_runs id=3:
  inicio_at  = NOW() - 35 min
  timeout_at = NOW() - 5 min  ← ya expiró hace 5 minutos
  status     = 'en_ejecucion' ← parece colgado

[15:23:58] Heartbeat tick — timeout_at < NOW(): True
[15:23:58] etl_runs id=3 → status='timeout', error='Sin respuesta > 30 min'
```

El heartbeat detectó el timeout y marcó la fila. Esto permite que la UI
Django (`ETLEstadoView`) muestre el problema y que `ETLReintentarView`
permita al operador lanzar un nuevo run.

**Lo que el heartbeat NO puede hacer:**
- Matar el SP en MariaDB (threading.Thread de Python no puede hacer KILL QUERY)
- El SP seguirá corriendo en MariaDB aunque etl_runs diga 'timeout'
- Para matar el SP hay que hacer `KILL QUERY <thread_id>` manualmente

**Solución correcta ante un timeout real:**
```sql
-- 1. Identificar el thread del SP colgado
SHOW PROCESSLIST;
-- 2. Matarlo
KILL QUERY <thread_id>;
-- 3. Verificar que job_execution_log quedó con RUNNING (el handler no actualizó)
SELECT * FROM job_execution_log WHERE status='RUNNING';
-- 4. Limpiar manualmente si es necesario
UPDATE job_execution_log SET status='FAILED', end_time=NOW(),
    error_message='Killed manualmente tras timeout'
WHERE status='RUNNING';
```

---

## Estado final del sistema post-simulación

### job_execution_log (32 filas — historial completo)

| Rango | job_name | Quarters | Status |
|---|---|---|---|
| id 1–10 | etl_historico | Q01_25..Q01_26 (primer backfill) | ALL SUCCESS |
| id 11–13 | etl_diario | Q02_26 (sim. anterior) | ALL SUCCESS |
| id 14–23 | etl_historico | Q01_25..Q01_26 (re-backfill 83K-96K filas) | ALL SUCCESS |
| id 24–26 | etl_diario | Q02_26 (Escenario A) | ALL SUCCESS |
| id 27–29 | etl_diario | Q02_26 (Escenario B) | ALL SUCCESS |
| id 31 | etl_diario | NULL | SKIP (concurrencia) |
| id 32 | etl_diario | NULL | SKIP (deshabilitado) |

### etl_runs (3 filas)

| id | trimestre | status | trigger_source | heartbeat |
|---|---|---|---|---|
| 1 | Q02_26 | success | simulacion_produccion | NULL |
| 2 | Q02_26 | success | django_command | NULL |
| 3 | Q02_26 | **timeout** | test_timeout | NULL |

### base_ivr_detalle (6 quarters procesados con datos frescos)

| trimestre | filas grain | total llamadas |
|---|---|---|
| Q01_25 | 2,616 | 83,084 |
| Q02_25 | 3,506 | 96,244 |
| Q03_25 | 2,962 | 81,091 |
| Q04_25 | 3,013 | 88,094 |
| Q01_26 | 2,699 | 85,588 |
| Q02_26 | 1,752 | 39,410 |
| **TOTAL** | **16,548** | **473,515** |

---

## Hallazgos de la simulación del job

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-JOB-001 | evt_etl_diario no registra en etl_runs — UI Django ciega al evento nocturno | ALTA | DOCUMENTADO |
| H-JOB-002 | etl_runs.status='success' aunque el SP haya hecho SKIP (concurrencia o disabled) | MEDIA | DOCUMENTADO |
| H-JOB-003 | heartbeat_at=NULL cuando el SP termina antes del primer tick — normal con datos de seed | INFO | DOCUMENTADO |
| H-JOB-004 | Heartbeat no puede matar el SP en MariaDB — solo marca timeout en etl_runs | MEDIA | DOCUMENTADO |
| H-JOB-005 | event_scheduler requiere flag explícito en arranque — no persiste sin my.cnf | ALTA | RESUELTO — `config/mariadb/99-iact.cnf` tiene `event_scheduler = ON`. Verificado: `SHOW VARIABLES LIKE 'event_scheduler'` → ON |

---

## H-JOB-001 — evt_etl_diario no registra en etl_runs

**Impacto en producción:**

Si el ETL nocturno corre solo por el event (02:00 AM, sin APScheduler Django),
la tabla `etl_runs` estará vacía para ese run. La UI Django que lee
`ETLEstadoView` mostrará "sin ejecuciones recientes" aunque `base_ivr_detalle`
esté actualizado.

**Solución documentada en FLUJO-ETL-V2.1.md:** APScheduler en Django debe
también llamar `run_etl` en la ventana 02:00–04:00, garantizando que
`etl_runs` siempre tenga el registro. Si tanto el event como APScheduler
disparan, la protección de concurrencia del Escenario C garantiza que
solo uno procese datos.

---

## H-JOB-002 — etl_runs.status='success' cuando el SP hizo SKIP

El management command `run_etl.py` registra `status='success'` en el
`finally` si no hubo excepción en Python. Cuando `sp_etl_maestro` hace
SKIP (concurrencia o job deshabilitado), el SP retorna sin error —
`callproc()` no lanza excepción. El command interpreta esto como éxito.

Para que la UI Django distinga entre "procesó datos" y "fue SKIP", el
command tendría que inspeccionar `job_execution_log` post-ejecución y
verificar si el último `maestro` tiene `status='SUCCESS'` o `status='SKIP'`.
Esto está pendiente de implementación en `ETLEstadoView`.

---

## Conclusión: orden correcto de operaciones en producción

```
02:00 AM  evt_etl_diario dispara         → sp_etl_maestro (sin etl_runs)
02:00 AM  APScheduler Django dispara     → manage.py run_etl
                                            → INSERT etl_runs
                                            → threading.Thread heartbeat
                                            → callproc sp_etl_maestro
                                              [SKIP — concurrencia con event]
                                            → UPDATE etl_runs status='success'
02:01 AM  event ya terminó (1.7s datos seed, ~9min producción real)
02:01 AM  run_etl registra SKIP como success en etl_runs
UI Django lee etl_runs: "success" ← correcto, aunque fue SKIP
job_execution_log tiene: RUNNING (event), SKIP (command) ← diagnóstico real
```

En producción real con ~11M filas, el event tardará ~9 minutos. El command
APScheduler hará SKIP si el event ya empezó. Si el event no disparó (event_scheduler=OFF),
el command será el único ejecutor y procesará datos completos.
