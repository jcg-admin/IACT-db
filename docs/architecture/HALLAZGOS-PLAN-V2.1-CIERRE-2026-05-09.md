# Hallazgos IACT-db — Sesión 2026-05-09 (Plan v2.1 cierre)

**Repositorio:** IACT-db + IACT-api  
**Fecha:** 2026-05-09  
**Resultado:** Plan v2.1 66/66 PASS  
**Alcance:** T-019, T-022, T-033, T-035, T-036, T-055–T-057, T-063, T-065,
T-074, T-081, T-082, T-083, T-084, T-085

---

## Resumen ejecutivo

El plan v2.1 cerró con 66/66 tareas PASS. Los hallazgos de esta sesión
se dividen en tres áreas: entorno de ejecución del sandbox, arquitectura
de configuración de IACT-api, y rendimiento del pipeline ETL.

---

## Área 1 — Entorno de ejecución (sandbox MariaDB)

### H-SBX-001 — Regla definitiva: arrancar MariaDB sin `--skip-grant-tables`

**Impacto:** Todos los objetos SQL (funciones, SPs, eventos) deben crearse
en modo normal para tener `DEFINER=django_user@localhost`. Con
`--skip-grant-tables` el DEFINER queda `@` y los objetos fallan en cualquier
servidor con autenticación activa.

**Patrón de arranque correcto:**

```python
subprocess.Popen([
    '/usr/sbin/mariadbd', '--user=mysql',
    '--socket=/run/mysqld/mysqld.sock',
    '--datadir=/var/lib/mysql',
    '--pid-file=/run/mysqld/mysqld.pid',
    '--innodb-buffer-pool-size=64M',
    '--event-scheduler=ON',
    # SIN --skip-grant-tables
])
```

**Fuentes corregidas:**
- `/tmp/mariadb_ensure.sh` → modo normal
- `IACT-api/tests/integration/pipeline/conftest.py` → modo normal
- `IACT-api/tests/fixtures/ivr.py` → credenciales explícitas

**Fuentes aceptables (se mantienen con skip-grant-tables):**
- `backup_ivr_legacy.sh` → solo `mysqldump`, BK-003 documenta limitación

**Referencia extensa:** `HALLAZGOS-EVENT-SCHEDULER-2026-05-09.md`

---

### H-SBX-002 — Event Scheduler requiere modo normal (Error 1577)

Con `--skip-grant-tables` activo, `CREATE EVENT` falla con:
```
ERROR 1577: Cannot proceed because system tables used by Event Scheduler
were found damaged at start of server
```

Con `--event-scheduler=ON` en los flags del servidor (sin skip-grant-tables),
`CREATE EVENT` funciona correctamente con `django_user`.

`SET GLOBAL event_scheduler = ON` requiere `SUPER` y no debe usarse desde
Django ni desde scripts de deploy. El DBA lo activa en `my.cnf`.

---

### H-SBX-003 — T-019 requiere sesión continua de MariaDB

El test T-019 modifica `ivr_es_dia_semana` temporalmente (función rota →
test → restaurar). Si MariaDB muere entre el paso de función rota y el
restore, la función queda inconsistente:

```
ERROR 1305: FUNCTION ivr_legacy.ivr_es_dia_semana_backup does not exist
```

**Fix cuando ocurre:** Redesplegar `funciones_utilidad.sql` completo y
reprocesar el quarter afectado con `sp_etl_base_detalle`.

**Prevención:** Ejecutar T-019 en una sola sesión Popen (proceso hijo),
no en comandos separados de shell.

---

## Área 2 — Pipeline ETL (resultados verificados)

### H-ETL-001 — end-to-end T-082 verificado

```
manage.py run_etl ejecutado:
  RC=0, elapsed=24.7s
  etl_runs: id=6, trimestre=Q02_26, status=success,
            trigger_source=django_command
  job_execution_log: 3 checkpoints
    maestro           SUCCESS  19s
    etl_base_detalle  SUCCESS  12s  (3,772 filas Q02_26)
    etl_base_clientes SUCCESS  7s   (3 filas)
```

---

### H-ETL-002 — Benchmark T-083 (Q01_25, N=3, ivr_legacy real)

| SP | Filas | Máx | Umbral |
|---|---|---|---|
| sp_rpt_clientes | 3 | 1ms | 500ms |
| sp_rpt_centros_transferencia | 5,215 | 88ms | 3,000ms |
| sp_rpt_llamadas_abandonadas | 9 | 13ms | 1,000ms |
| sp_rpt_menu_redirigidos | 687 | 28ms | 3,000ms |
| sp_rpt_menu_centro | 2,026 | 31ms | 3,000ms |
| sp_rpt_cMENU_ERROR | 0 | 8ms | 3,000ms |
| sp_rpt_centros_xsegmento | 84 | 500ms | 8,000ms |

`sp_rpt_centros_xsegmento` usa `ivr_contar_dias_semana` (WHILE O(n días))
por cada centro. 500ms con 84 centros es aceptable — no se requiere
pre-computar `dias_semana_sin_actividad` en el ETL con estos volúmenes.

---

### H-ETL-003 — Estado de ivr_legacy al cierre

```
base_ivr_detalle:
  Q01_25  5,215 filas  (1,031,847 llamadas)
  Q02_25  6,629 filas  (1,172,834 llamadas)
  Q03_25  5,889 filas  (983,741 llamadas)
  Q04_25  5,990 filas  (1,074,193 llamadas)
  Q01_26  5,429 filas  (1,041,623 llamadas)
  Q02_26  3,772 filas  (462,000 llamadas)  ← quarter activo

etl_runs:
  6 registros — todos status=success
  Último: 2026-05-09 02:14:55 → 02:15:14 (24.7s)

job_execution_log:
  Vacío post-limpieza (los registros del test T-082 se limpiaron)

evt_etl_diario:
  ENABLED, EVERY 1 DAY, STARTS 2026-05-10 02:00:00
  DEFINER=django_user@localhost

vw_monitor_dias_semana:
  17 registros (6 quarters × meses), 0 alertas
  pct_entre_semana en rango [66.7%, 74.3%] para todos los quarters
```

---

## Área 3 — Arquitectura de configuración IACT-api

### H-ARCH-001 — Principio settings vs .env (D-CFG-001)

**Decisión establecida:**

> Las decisiones de configuración van en los archivos de settings.
> Los secretos y valores específicos de la instancia van en `.env`.

Archivos de settings y su responsabilidad:

| Archivo | Responsabilidad |
|---|---|
| `base.py` | Lee todo el `.env` con `config()`. Defaults para desarrollo. |
| `production.py` | HTTPS, HSTS, headers de seguridad, logging a archivos. |
| `development.py` | DEBUG, django_extensions, logging DEBUG, cookies inseguras. |
| `testing_local.py` | Solo `TEST:` config para cada BD. Hereda todo de `base.py`. |

`.env` solo contiene: `SECRET_KEY`, contraseñas, `ALLOWED_HOSTS`,
`DB_SOCKET`/`IVR_DB_SOCKET`, `DJANGO_SETTINGS_MODULE`.

**NO va en `.env`:** `DEBUG`, timeouts de conexión, headers de seguridad,
configuración de logging, rutas de static files.

---

### H-ARCH-002 — Socket Unix para PostgreSQL (pg_hba.conf)

Para que Django conecte a PostgreSQL por socket Unix con un usuario que
no existe en el OS (como `django_user`), `pg_hba.conf` necesita una línea
`scram-sha-256` para conexiones locales **antes** de la línea `peer` genérica:

```
# ANTES de la línea peer genérica — el orden importa
local   all   django_user   scram-sha-256
local   all   all           peer
```

Sin esta línea: PostgreSQL intenta `peer` auth → falla porque el proceso
no corre como `django_user` OS → Django cae back a TCP.

**En `base.py`:** `DB_SOCKET` controla el tipo de conexión:
```python
'HOST': config('DB_SOCKET', default='') or config('DB_HOST', default='localhost'),
'PORT': '' if config('DB_SOCKET', default='') else config('DB_PORT', default='5432'),
```

---

## Estado de tests al cierre

| Suite | Estado | Notas |
|---|---|---|
| `tests/unit/` | 686 passed, 4 skipped | +6 vs estado inicial (T-056, T-057) |
| `tests/integration/pipeline/` | 39 passed | +8 vs estado inicial (T-082, T-083) |
| `tests/integration/users/` | pre-existente fallando | fixture module_id NULL — plan v3.1.0 |
| `tests/integration/authentication/` | pre-existente fallando | permisos — plan v3.1.0 |
| `tests/api/` | pre-existente fallando | URLs /api/v1/ inexistentes — plan v3.1.0 |

Los fallos pre-existentes no son responsabilidad del plan v2.1 (ETL IVR).
Se resuelven en el plan v3.1.0.

---

## Objetos desplegados en producción al cierre

### ivr_legacy (MariaDB)

**Funciones (7) — DEFINER=django_user@localhost:**
`fn_did_segmento`, `fn_normalizar_menu`, `fn_normalizar_centro`,
`fn_duracion_seg`, `ivr_es_dia_semana`, `ivr_contar_dias_semana`,
`ivr_agregar_dias_semana`

**SPs ETL (5) — DEFINER=django_user@localhost:**
`sp_etl_maestro`, `sp_etl_base_detalle`, `sp_etl_base_clientes`,
`sp_etl_validar`, `sp_etl_historico`

**SPs reporte (7) — DEFINER=django_user@localhost:**
`sp_rpt_clientes`, `sp_rpt_centros_transferencia`,
`sp_rpt_llamadas_abandonadas`, `sp_rpt_menu_redirigidos`,
`sp_rpt_menu_centro`, `sp_rpt_cMENU_ERROR`, `sp_rpt_centros_xsegmento`

**Evento:** `evt_etl_diario` — ENABLED, EVERY 1 DAY, 02:00:00

**Vista:** `vw_monitor_dias_semana` — monitoreo de ratio días hábiles

**Tablas etl_runs — columnas en inglés (D-NOM-001):**
`inicio_at`, `fin_at`, `timeout_at`, `heartbeat_at`, `status`,
`error_message`, `trigger_source`

### IACT-api (Django)

**Comando:** `manage.py run_etl` — escribe en `etl_runs`, heartbeat, llama SP

**Settings activos:** `config.settings.production`

**Conexiones:**
- PostgreSQL → socket Unix `/var/run/postgresql`
- MariaDB → socket Unix `/run/mysqld/mysqld.sock`

---

## Próximos pasos

Plan v3.1.0 — alcance:
- T-101: Fix skip injustificado en `utils/test_utils_network.py`
- T-102: Implementar modelo `MenuItem` (UC_ADM_04)
- T-103: Resolución DT-002 (17 tests en skip)
- T-104: Implementar `MenuLifecycleService` (UC_ADM_05)
- T-105: Tests para MenuItem y MenuLifecycleService

Estos items resuelven también los fallos pre-existentes en
`tests/integration/users/` y `tests/api/` (acceso a módulos RBAC).

---

## Ver también

- `HALLAZGOS-EVENT-SCHEDULER-2026-05-09.md` — detalle técnico de Event Scheduler
- `AUDITORIA-PLAN-V2.1-2026-05-09.md` — estado de las 66 tareas
- `BITACORA-SESION-2026-05-09.md` — log cronológico de la sesión
- `IACT-api/docs/architecture/HALLAZGOS-SESION-2026-05-09.md` — hallazgos en IACT-api
- `IACT-api/docs/setup/CONFIGURACION-ENTORNOS.md` — arquitectura settings vs .env
