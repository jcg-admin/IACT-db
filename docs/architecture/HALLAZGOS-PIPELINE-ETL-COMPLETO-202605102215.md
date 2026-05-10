# Hallazgos — Análisis completo del pipeline ETL IVR

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Fuente primaria:** `FLUJO-ETL-V2.1.md` (documento canónico activo)  
**Reemplaza:** `HALLAZGOS-SP-PIPELINE-202605102200.md` — análisis incompleto
que omitió el mecanismo de disparo, el heartbeat y la capa Django.  
**Referencia:** `sp_etl_pipeline.sql`, `sp_rpt_reportes.sql`,
`funciones_utilidad.sql`, `run_etl.py`

---

## Por qué el análisis anterior fue incorrecto

`HALLAZGOS-SP-PIPELINE-202605102200.md` describió el pipeline como si el ETL
comenzara directamente en `sp_etl_base_detalle`. El flujo real tiene 6 niveles:

```
Nivel 0 — Funciones de utilidad (prerequisito)
Nivel 1 — Disparo: evt_etl_diario (MySQL Event) + manage.py run_etl (Django)
Nivel 2 — Orquestación: sp_etl_maestro() con checkpoints en job_execution_log
Nivel 3A — ETL principal: sp_etl_base_detalle() → base_ivr_detalle
Nivel 3B — ETL secundario: sp_etl_base_clientes() → base_ivr_clientes
Nivel 4 — SPs de reporte (7) — leen base_ivr_* (read-only, milisegundos)
Nivel 5 — Django REST Framework — 9 endpoints via cursor.callproc()
```

El análisis anterior describía solo los niveles 3A/3B/4, ignorando los
mecanismos de disparo, el rol de `etl_runs`, el heartbeat y la capa API.

---

## Flujo completo

```
FUENTE (cliente, solo SELECT)      IACT — MariaDB ivr_legacy
──────────────────────────         ───────────────────────────────────────────

tbl_historico_t1_2025                    DISPARO A (automático)
tbl_historico_t2_2025              evt_etl_diario — MySQL Event 02:00 AM
tbl_historico_t3_2025                    CALL sp_etl_maestro()
tbl_historico_t4_2025
tbl_historico_t1_2026                    DISPARO B (manual / scheduler)
tbl_historico_t2_2026              manage.py run_etl
         │                               │ INSERT etl_runs (inicio_at, timeout_at)
         │                               │ threading.Thread heartbeat (cada 60s)
         │                               │ CALL sp_etl_maestro()
         │                               ↓
         │                         sp_etl_maestro()
         │                               │ Lee job_config → is_enabled, min_intervalo_h
         │                               │ checkpoint 'maestro' → job_execution_log
         │                               │
         ├── scan mes a mes ────────→    │ checkpoint 'etl_base_detalle'
         │                              sp_etl_base_detalle(quarter, ini, fin, tabla, log_id)
         │                               │   DELETE mes + INSERT GROUP BY grain
         │                               │   PREPARE/EXECUTE (tabla dinámica CNST-ETL-008)
         │                               ↓
         │                         base_ivr_detalle   ← miles de filas por quarter
         │
         └── scan full quarter ──────→  │ checkpoint 'etl_base_clientes'
                                        sp_etl_base_clientes(quarter, ini, fin, tabla, log_id)
                                         │   DELETE quarter + INSERT COUNT(DISTINCT)
                                         ↓
                                   base_ivr_clientes  ← 3 filas por quarter

                                   sp_etl_validar(quarter, OUT ok, OUT msg)
                                         │ Verifica conteos correctos post-ETL
                                         ↓
                                   job_execution_log (checkpoints)
                                   etl_runs (heartbeat Django)
                                         │
                                         ↓
                       sp_rpt_centros_transferencia(quarter, segmento)
                       sp_rpt_centros_xsegmento(quarter)
                       sp_rpt_llamadas_abandonadas(quarter, segmento)   ←── Django
                       sp_rpt_menu_redirigidos(quarter, segmento)            cursor.callproc()
                       sp_rpt_menu_centro(quarter, segmento)
                       sp_rpt_cMENU_ERROR(quarter, segmento)
                       sp_rpt_clientes(quarter)
                                         │
                                         ↓
                               Django REST Framework
                               9 endpoints /api/ivr/
```

---

## Nivel 1 — Los dos mecanismos de disparo

Esta distinción estaba completamente ausente en el análisis anterior.

### Mecanismo A — evt_etl_diario (MySQL Event)

Disparo automático nocturno sin intervención humana:

```sql
CREATE EVENT IF NOT EXISTS evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
COMMENT 'ETL IVR nocturno — ejecuta sp_etl_maestro()'
DO CALL sp_etl_maestro();
```

Características:
- Corre a las 02:00 AM sin intervención
- Registra solo en `job_execution_log` — **no en `etl_runs`**
- La concurrencia la maneja el propio SP maestro (consulta `job_execution_log`
  con `status='RUNNING'` en las últimas 6 horas)

### Mecanismo B — manage.py run_etl (Django)

Disparo manual o desde APScheduler Django:

```
python manage.py run_etl [--quarter Q02_26] [--force]
```

Responsabilidades **exclusivas** de este mecanismo (no las hace el event):

1. INSERT en `etl_runs` con `inicio_at`, `timeout_at = NOW() + 30 MIN`,
   `trigger_source = 'django_command'`
2. Lanzar `threading.Thread` (daemon) de heartbeat cada 60 segundos que:
   - Actualiza `etl_runs.heartbeat_at = NOW()`
   - Marca `etl_runs.status = 'timeout'` si `timeout_at < NOW()`
3. CALL `sp_etl_maestro()`
4. UPDATE `etl_runs.status` en `finally` (siempre, aunque fallen los pasos)

La tabla `etl_runs` es la fuente de verdad para la **UI Django** del estado
del ETL. `job_execution_log` es el tracking interno del SP maestro (granular
por paso). Ambas coexisten con propósitos distintos.

---

## Nivel 2 — sp_etl_maestro: orquestación con checkpoints

El SP maestro no solo llama a los SPs ETL — gestiona concurrencia, registra
checkpoints, maneja fallos y propaga el estado. Las decisiones que toma:

```
PASO 0: Lee job_config WHERE job_name='etl_diario'
        → is_enabled=FALSE → INSERT SKIP en job_execution_log → v_abort=TRUE

PASO 1: Verifica concurrencia (ventana mínima de 6 horas)
        → EXISTS job_execution_log WHERE status='RUNNING' en últimas 6h
        → Si hay uno → INSERT SKIP → v_abort=TRUE

PASO 2: Si NOT v_abort → calcula quarter actual y tabla fuente
        → INSERT 'maestro' RUNNING en job_execution_log

PASO 3: checkpoint 'etl_base_detalle'
        → CALL sp_etl_base_detalle(quarter, ini, fin, tabla, log_id)
        → Si falla → UPDATE checkpoint FAILED → UPDATE maestro FAILED

PASO 4: checkpoint 'etl_base_clientes'
        → CALL sp_etl_base_clientes(quarter, ini, fin, tabla, log_id)
        → Si falla → UPDATE checkpoint FAILED → UPDATE maestro PARTIAL

PASO 5: UPDATE maestro SUCCESS
```

---

## Nivel 1B auxiliar — sp_etl_historico (backfill)

Wrapper para carga histórica manual. **No modifica `job_config`** — el
documento `FLUJO-ETL-V2.1.md` lo describe incorrectamente como que
"habilita temporalmente etl_historico". El código real:

```sql
-- sp_etl_historico(p_year, p_quarter_num):
-- 1. Calcula nombres y fechas del quarter
-- 2. INSERT 'etl_base_detalle' RUNNING en job_execution_log con job_name='etl_historico'
-- 3. CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id)
-- 4. DO SLEEP(5)  -- pausa para no saturar en backfill
-- 5. INSERT 'etl_base_clientes' RUNNING en job_execution_log
-- 6. CALL sp_etl_base_clientes(...)
-- 7. CALL sp_etl_validar(...) y SELECT el resultado
```

`job_config.etl_historico` permanece con `is_enabled=0` durante todo el
proceso. El SP usa `job_name='etl_historico'` en el log solo para
identificar el origen de la ejecución.

Para ejecutar el backfill del seed histórico:

```sql
CALL sp_etl_historico(2025, 1);  -- Q01_25  ~30K filas seed
CALL sp_etl_historico(2025, 2);  -- Q02_25
CALL sp_etl_historico(2025, 3);  -- Q03_25
CALL sp_etl_historico(2025, 4);  -- Q04_25
CALL sp_etl_historico(2026, 1);  -- Q01_26
CALL sp_etl_historico(2026, 2);  -- Q02_26 parcial
```

---

## Hallazgos identificados

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-SP2-001 | `etl_runs` tiene nombres de columna distintos al documento | ALTA | DOCUMENTADO |
| H-SP2-002 | `event_scheduler` está OFF — `evt_etl_diario` nunca dispara | ALTA | PENDIENTE |
| H-SP2-003 | `fn_duracion_seg` definida pero no usada en ningún SP desplegado | MEDIA | DOCUMENTADO |
| H-SP2-004 | `FLUJO-ETL-V2.1.md` describe incorrectamente `sp_etl_historico` | BAJA | DOCUMENTADO |
| H-SP2-005 | `verify.sh` no verifica `ivr_contar_dias_semana` ni `ivr_agregar_dias_semana` | BAJA | PENDIENTE |
| H-SP2-006 | `base_ivr_detalle` y `base_ivr_clientes` vacías — ETL histórico no ejecutado | ALTA | PENDIENTE |

---

## H-SP2-001 — `etl_runs`: columnas reales vs documento

**Estado:** DOCUMENTADO — el código real (`run_etl.py`) ya usa los nombres correctos

El documento `FLUJO-ETL-V2.1.md` describe `etl_runs` con nombres que no
coinciden con el DDL real desplegado en la BD:

| Campo | Doc FLUJO-ETL-V2.1.md | BD real + run_etl.py |
|---|---|---|
| Inicio | `iniciado_en` | `inicio_at` |
| Fin | `finalizado_en` | `fin_at` |
| Responsable | `ejecutado_por` | `trigger_source` |
| Estado | `estado` | `status` |
| ENUM éxito | `'exitoso'` | `'success'` |
| ENUM fallo | `'fallido'` | `'failed'` |
| Heartbeat | — (no mencionado) | `heartbeat_at` |
| Intervalo heartbeat | 120 segundos | **60 segundos** |

`run_etl.py` ya usa la nomenclatura correcta de la BD (`inicio_at`, `fin_at`,
`trigger_source`, `status`, `'success'`, `'failed'`). El documento
`FLUJO-ETL-V2.1.md` tiene los nombres desactualizados — es deuda documental,
no un bug de código.

---

## H-SP2-002 — `event_scheduler` OFF: evt_etl_diario nunca dispara

**Severidad:** ALTA  
**Estado:** PENDIENTE

```
event_scheduler: OFF           ← global variable
evt_etl_diario:  ENABLED       ← event existe y está habilitado
LAST_EXECUTED:   NULL          ← nunca ha corrido
```

El MySQL Event Scheduler está desactivado a nivel de servidor. Aunque
`evt_etl_diario` existe con status `ENABLED`, nunca se disparará mientras
`event_scheduler = OFF`. Para activarlo:

```sql
-- Habilitar para esta sesión (no persiste tras reinicio)
SET GLOBAL event_scheduler = ON;

-- Persistir en my.cnf / mariadb.conf:
-- [mysqld]
-- event_scheduler = ON
```

En el entorno de desarrollo (contenedor sin systemd), esta configuración
se pierde en cada reinicio. El mecanismo B (`manage.py run_etl`) sigue
funcional independientemente de esta variable.

---

## H-SP2-003 — `fn_duracion_seg` definida pero no usada

**Estado:** DOCUMENTADO

`fn_duracion_seg(p_ini, p_fin)` existe en la BD (desplegada desde
`funciones_utilidad.sql`) pero no aparece en ningún SP de ETL ni de reporte
del repositorio actual:

```bash
grep -rn "fn_duracion_seg" provisioners/mariadb/sp_etl_pipeline.sql  → 0 resultados
grep -rn "fn_duracion_seg" provisioners/mariadb/sp_rpt_reportes.sql  → 0 resultados
```

Solo aparece en `funciones_utilidad.sql` (definición + tests de verificación).

`FLUJO-ETL-V2.1.md` documenta que la usa `sp_rpt_centros_xsegmento` para
calcular duración. El SP real en el repositorio calcula la duración de otra
manera o simplemente no la incluye. La función está disponible para uso
futuro pero no está en el camino crítico del pipeline actual.

---

## H-SP2-004 — sp_etl_historico no modifica job_config

**Estado:** DOCUMENTADO — corrección al documento FLUJO-ETL-V2.1.md

El documento dice en la sección "Carga histórica inicial":

> "sp_etl_historico habilita temporalmente etl_historico en job_config,
> corre el ETL, y deshabilita el job al terminar."

El código real no hace ningún UPDATE a `job_config`. El SP llama directamente
a `sp_etl_base_detalle` y `sp_etl_base_clientes`, registrando en
`job_execution_log` con `job_name='etl_historico'` para identificar el origen.
`job_config.etl_historico.is_enabled` permanece en `0` durante todo el proceso.

---

## H-SP2-005 — verify.sh: cobertura incompleta de funciones

**Estado:** PENDIENTE (mismo hallazgo H-SP-005 del análisis anterior)

`verify.sh` verifica 5 de 7 funciones desplegadas. Las dos omitidas son
usadas por `sp_rpt_centros_xsegmento`:

| Función | verify.sh | Usada por |
|---|---|---|
| `ivr_contar_dias_semana` | NO | `sp_rpt_centros_xsegmento` |
| `ivr_agregar_dias_semana` | NO | `sp_rpt_centros_xsegmento` |

---

## H-SP2-006 — base_ivr_* vacías: backfill pendiente

**Severidad:** ALTA  
**Estado:** PENDIENTE

```
base_ivr_detalle:   0 registros
base_ivr_clientes:  0 registros
job_execution_log:  0 registros
etl_runs:           0 registros
```

Los 7 SPs de reporte retornan 0 filas porque `base_ivr_*` está vacío.
El seed en `tbl_historico_*` (30K-37K registros por quarter) es correcto,
pero el ETL histórico no se ha ejecutado.

Para activar el pipeline completo, ejecutar en orden:

```sql
-- Paso 1: Verificar datos en fuente
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok, @msg;
-- Esperado: ok=0, msg="ERROR: base_ivr_detalle vacía..."
-- Esto confirma que tbl_historico_t1_2025 tiene datos pero el ETL no ha corrido

-- Paso 2: Backfill histórico (6 quarters)
CALL sp_etl_historico(2025, 1);
CALL sp_etl_historico(2025, 2);
CALL sp_etl_historico(2025, 3);
CALL sp_etl_historico(2025, 4);
CALL sp_etl_historico(2026, 1);
CALL sp_etl_historico(2026, 2);

-- Paso 3: Verificar resultado
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok, @msg;
-- Esperado: ok=1, msg="Q01_25: base_ivr_detalle OK..."

-- Paso 4: Confirmar que los SPs de reporte retornan datos
CALL sp_rpt_centros_xsegmento('Q01_25');
CALL sp_rpt_clientes('Q01_25');
```

---

## Inventario completo de routines — estado real en BD

### Nivel 0 — Funciones de utilidad (7) — todas desplegadas

| Función | Propósito | Usada por |
|---|---|---|
| `fn_did_segmento(p_did)` | DID → `nacional_A` / `nacional_B` / `puebla` | `sp_etl_base_detalle`, `sp_etl_base_clientes` |
| `fn_normalizar_menu(p_menu)` | NULL/vacío → `'VACIO'`, pass-through resto | `sp_etl_base_detalle` |
| `fn_normalizar_centro(p_centro)` | NK90, CLIENTE_COLGO, CASO_NULL, CASO_ERROR_CEROS | `sp_etl_base_detalle` |
| `fn_duracion_seg(p_ini, p_fin)` | `ABS(TIMESTAMPDIFF(SECOND,...))` — maneja G-29 | Definida. Sin uso en SPs actuales |
| `ivr_es_dia_semana(p_fecha)` | `DAYOFWEEK NOT IN (1,7)` — lun a vie | `sp_etl_base_detalle`, `ivr_contar_dias_semana`, `ivr_agregar_dias_semana`, `sp_rpt_centros_xsegmento` |
| `ivr_contar_dias_semana(p_ini, p_fin)` | COUNT de días lun-vie en el rango | `sp_rpt_centros_xsegmento` |
| `ivr_agregar_dias_semana(p_fecha, p_n)` | Avanza n días hábiles desde p_fecha | `sp_rpt_centros_xsegmento` |

### Nivel 1 — Disparo

| Componente | Tipo | Estado |
|---|---|---|
| `evt_etl_diario` | MySQL Event (02:00 AM) | Existe en BD. `event_scheduler=OFF` — nunca dispara (H-SP2-002) |
| `manage.py run_etl` | Django management command | Desplegado en IACT-api — funcional |

### Nivel 2 — Orquestación (1 SP)

| SP | Estado |
|---|---|
| `sp_etl_maestro()` | Desplegado — funcional |

### Nivel 3 — ETL (3 SPs)

| SP | Parámetros | Estado |
|---|---|---|
| `sp_etl_base_detalle` | `quarter, inicio, fin, tabla, log_id` | Desplegado |
| `sp_etl_base_clientes` | `quarter, inicio, fin, tabla, log_id` | Desplegado |
| `sp_etl_validar` | `quarter, OUT ok, OUT msg` | Desplegado |
| `sp_etl_historico` | `p_year, p_quarter_num` | Desplegado — backfill no ejecutado |

### Nivel 4 — Reportes (7 SPs)

| SP | Parámetros | Estado |
|---|---|---|
| `sp_rpt_clientes` | `quarter` | Desplegado — retorna 0 filas (H-SP2-006) |
| `sp_rpt_centros_transferencia` | `quarter, segmento` | Desplegado — retorna 0 filas |
| `sp_rpt_centros_xsegmento` | `quarter` | Desplegado — retorna 0 filas |
| `sp_rpt_llamadas_abandonadas` | `quarter, segmento` | Desplegado — retorna 0 filas |
| `sp_rpt_menu_centro` | `quarter, segmento` | Desplegado — retorna 0 filas |
| `sp_rpt_menu_redirigidos` | `quarter, segmento` | Desplegado — retorna 0 filas |
| `sp_rpt_cMENU_ERROR` | `quarter, segmento` | Desplegado — retorna 0 filas |

### Nivel 5 — Django API (pendiente de despliegue en IACT-api)

| Componente | Estado |
|---|---|
| `settings.py` DATABASES dual (default=PostgreSQL, ivr=MariaDB) | Pendiente |
| `IVRRouter` (app_label='ivr' → db='ivr', allow_migrate=False) | Pendiente |
| `services/ivr_reports.py` — motor `_call_sp()` + 7 getters | Pendiente |
| `views/ivr_reports.py` — 7 vistas DRF | Pendiente |
| `views/ivr_pipeline.py` — ETLEstadoView + ETLReintentarView | Pendiente |
| `urls/ivr.py` — 9 endpoints | Pendiente |

### Tablas de control

| Tabla | Registros | Estado |
|---|---|---|
| `base_ivr_detalle` | 0 | Vacía — ETL no ejecutado (H-SP2-006) |
| `base_ivr_clientes` | 0 | Vacía — ETL no ejecutado |
| `job_config` | 2 | `etl_diario=enabled`, `etl_historico=disabled` |
| `job_execution_log` | 0 | Vacía — ningún ETL ha corrido |
| `etl_runs` | 0 | Vacía — `manage.py run_etl` no invocado |

---

## Corrección de T-4.4 en el plan

```bash
# T-4.4 CORRECTO — verificar que el pipeline tiene datos para operar:

# 1. Verificar que tbl_historico_* tiene datos (el seed funcionó)
#    y que base_ivr_* está vacía (el ETL no ha corrido)
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "CALL sp_etl_validar('Q01_25', @ok, @msg);
        SELECT @ok AS etl_listo, @msg AS detalle;"
# Esperado: ok=0 — confirma seed OK, ETL pendiente

# 2. Ejecutar el backfill histórico
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "CALL sp_etl_historico(2025, 1);"
# ...repetir para los 6 quarters

# 3. Verificar que ahora sí hay datos en base_ivr_*
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "CALL sp_etl_validar('Q01_25', @ok, @msg);
        SELECT @ok AS etl_listo, @msg AS detalle;"
# Esperado: ok=1

# 4. Confirmar que los SPs de reporte retornan filas
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "CALL sp_rpt_clientes('Q01_25');"
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "CALL sp_rpt_centros_xsegmento('Q01_25');"
# Esperado: filas > 0
```

---

## Relación con el documento anterior

`HALLAZGOS-SP-PIPELINE-202605102200.md` sigue siendo válido para:
- H-SP-001: confirmación de que `sp_rpt_reportes` no existe (correcto)
- H-SP-004: `seed_historico_real.sql` obsoleto (correcto)

Queda **reemplazado** por este documento en:
- Descripción del flujo ETL (incompleta en el anterior)
- Mecanismo de disparo (ausente en el anterior)
- Rol de `etl_runs` y heartbeat (ausente en el anterior)
- Capa Django API (ausente en el anterior)
- Inventario completo de routines con estado real
