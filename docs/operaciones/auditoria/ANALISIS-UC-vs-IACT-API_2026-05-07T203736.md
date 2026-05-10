# Analisis: Casos de uso (IACT-docs) vs Implementacion (IACT-api)

**Fecha:** 2026-05-07
**Rama docs:** `feature/cnst-033-uml-conformance`
**Fuente UCs:** `source/requisitos/casos-uso/`
**Fuente API:** `/tmp/references/IACT-api/callcentersite/`

---

## Resumen ejecutivo

| Dominio | UCs documentados | Implementado en API | Estado |
|---|---|---|---|
| auth | 5 (auth-01..05) | SI — app authentication | IMPLEMENTADO |
| users | 4 (usr-01..04) | SI — app users | IMPLEMENTADO |
| access | 5+ (acc-01..09) | PARCIAL — app access | PARCIAL |
| permissions | 10 (perm-01..10) | PARCIAL — app access | PARCIAL |
| pipeline | 4 (pip-01..04) | PARCIAL — app pipeline | PARCIAL |
| reports | 17 (rpt-01..17) | PARCIAL — app reports | PARCIAL |
| audit | 4 (aud-01..04) | SI — app audit | IMPLEMENTADO |
| alerts | 5 (alr-01..05) | SI — app alerts | IMPLEMENTADO |
| operator | 10 (opr-01..10) | NO — no existe app operator | NO IMPLEMENTADO |
| caller | 5 (cli-01..05) | NO — no existe app caller | NO IMPLEMENTADO |
| logs | 7 (log-01..07) | NO — no existe app logs | NO IMPLEMENTADO |
| supervision | 3 (sup-01..03) | PARCIAL — app dashboard | PARCIAL |
| admin | 3 (adm-01..03) | NO — solo Django admin | PARCIAL |

---

## Hallazgo critico — app `ivr` e `ivr_legacy` casi vacias

La conexion con el pipeline ETL de IACT-db es el corazon del sistema.
El estado actual en IACT-api es alarmante:

### app `ivr` (callcentersite/apps/ivr/)

```
views.py:
  # Create your views here.
  # (vacio — sin implementacion)

models.py:
  # Todo el modelo CallLog esta comentado con deuda tecnica:
  # "Fecha de eliminacion: 2026-03-21"
  # "El modelo CallLog fue desactivado. La tabla call_logs no existe."
```

### app `ivr_legacy` (callcentersite/apps/ivr_legacy/)

```
Contiene solo: __init__.py
# Completamente vacia
```

### Configuracion existente (settings/base.py)

La conexion dual SI esta configurada:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME', default='iact_analytics'),
        ...
    },
    'ivr': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': config('IVR_DB_NAME', default='ivr_legacy'),
        'USER': config('IVR_DB_USER', default='ivr_readonly'),
        ...
        'OPTIONS': {
            'unix_socket': config('IVR_DB_SOCKET', default='/run/mysqld/mysqld.sock'),
        },
    }
}
DATABASE_ROUTERS = ['config.db_router.DatabaseRouter']
```

El `DatabaseRouter` existe y enruta correctamente. Pero `ivr_apps = {'ivr'}` y
la app `ivr` no tiene ningun model ni view implementado. La conexion esta
configurada pero nadie la usa.

---

## Dominio: Pipeline (UC_PIP_01..04)

### Lo que documentan los UCs

| UC | Nombre | Endpoint | Estado en API |
|---|---|---|---|
| UC_PIP_01 | Supervision estado ETL | GET /api/pipeline/status/ | PARCIAL |
| UC_PIP_02 | Ver errores ETL | GET /api/pipeline/errors/ | NO |
| UC_PIP_03 | Ver disponibilidad de datos | GET /api/pipeline/data-availability/ | NO |
| UC_PIP_04 | Solicitar reintento | POST /api/pipeline/retry/ | NO |

### UC_PIP_01 — Estado ETL

El UC especifica `SupervisionETLView` leyendo de `pipeline_runs` en ivr_legacy:

```
SELECT id, source_table, trimestre, started_at, finished_at,
       estado, base_records, error_message, executed_by
FROM pipeline_runs
ORDER BY started_at DESC LIMIT 20
```

En IACT-db la tabla equivalente es `job_execution_log` con `etl_runs`.
El UC no esta alineado con el schema real de IACT-db.

La implementacion en `app pipeline/views.py` usa `ETLExecution` de Django
(modelo PostgreSQL), NO la tabla real de MariaDB `job_execution_log`.

```python
# Lo que hay implementado (incorrecto — usa ORM Django, no MariaDB):
last = ETLExecution.objects.first()

# Lo que deberia haber (segun UC_PIP_01):
with connections['ivr'].cursor() as c:
    c.execute("SELECT ... FROM job_execution_log ORDER BY start_time DESC LIMIT 20")
```

**Gap:** El endpoint existe pero lee del modelo ORM Django (PostgreSQL), no
de la tabla real de MariaDB donde esta el historial real del ETL.

### UC_PIP_02 al 04

No hay views ni endpoints implementados para estos UCs.

---

## Dominio: Reports (UC_RPT_01..17)

### Lo que documentan los UCs

| UC | Nombre | Estado en API |
|---|---|---|
| UC_RPT_01 | Ver Dashboard (metricas agregadas) | PARCIAL |
| UC_RPT_02 | Ver metricas en tiempo real | NO (SSE/WS no implementado) |
| UC_RPT_03 | Ver reportes historicos | PARCIAL |
| UC_RPT_04 | Exportar reporte | PARCIAL |
| UC_RPT_07 | Programar reporte | NO |
| UC_RPT_08..17 | Reportes especificos IVR | NO |

### App reports — estado actual

`ReportViewSet` y `ExportJobViewSet` existen con CRUD completo (list, create,
retrieve, update, destroy). Pero reportan sobre un modelo `Report` Django
(almacenado en PostgreSQL), no sobre los SPs de MariaDB.

Los 7 SPs de reporte de IACT-db (`sp_rpt_clientes`, `sp_rpt_centros_xsegmento`,
etc.) no estan invocados en ninguna view de IACT-api.

```
Buscando en callcentersite/ cualquier referencia a sp_rpt_:
grep -r "sp_rpt" callcentersite/ → 0 resultados
grep -r "callproc" callcentersite/ → 0 resultados
grep -r "sp_etl" callcentersite/ → 0 resultados
```

**Gap critico:** Los 7 SPs de reporte de MariaDB no tienen ningun endpoint
en la API. Los UCs UC_RPT_08 a UC_RPT_17 que corresponden a reportes
especificos del IVR no tienen implementacion.

---

## Dominio: Auth (UC_AUTH_01..05) — IMPLEMENTADO

App `authentication` tiene todos los flows cubiertos:
- Login (tokens JWT)
- Logout (blacklist)
- Recuperacion de contrasena
- Cambio de contrasena
- Gestion de sesiones multiples

---

## Dominio: Users (UC_USR_01..04) — IMPLEMENTADO

App `users` tiene CRUD completo con:
- Creacion con validacion
- Consulta con filtros y paginacion
- Modificacion (PATCH)
- Baja logica (soft delete via DELETE)

---

## Dominio: Access (UC_ACC_01..09) — PARCIAL

App `access` implementa asignacion y revocacion de funciones.
Falta la gestion completa de AccessGroups (UC_ACC_04) y SoD Rules (UC_ACC_05,
UC_ACC_08, UC_ACC_09) que aparecen como modelos pero sin views completos.

---

## Dominio: Audit (UC_AUD_01..04) — IMPLEMENTADO

App `audit` con decorators, services y views para registro y consulta
de eventos de auditoria. El modelo AuditLog esta presente con
full-text search y exportacion.

---

## Dominio: Alerts (UC_ALR_01..05) — IMPLEMENTADO

App `alerts` con modelos, scheduler, permisos y serializers.
Configuracion de umbrales, evaluacion y reconocimiento implementados.

---

## Dominios sin implementacion

### Operator (UC_OPR_01..10) — NO IMPLEMENTADO

Los 10 casos de uso del operador (cambio de estado de agente, gestion de
llamadas, disposicion, transferencia, mensajeria push) no tienen app
equivalente en IACT-api. No existe `apps/operator/`.

### Caller (UC_CLI_01..05) — NO IMPLEMENTADO

Los casos de uso del llamante (registro de llamada, resolucion, reintento,
abandono, anonimizacion) no tienen implementacion. No existe `apps/caller/`.

### Logs (UC_LOG_01..07) — NO IMPLEMENTADO

Los 7 casos de uso de logs (acceso tail SSE, consulta, exportacion, metricas
de infraestructura) no tienen app equivalente.

---

## Configuracion dual-DB — Existe pero no se usa para IVR

La configuracion de `DATABASES['ivr']` esta presente y funcional.
El `DatabaseRouter` esta implementado. El `.env` tiene las variables
`IVR_DB_NAME`, `IVR_DB_SOCKET`. Pero:

```
grep -r "connections\['ivr'\]" callcentersite/ → 0 resultados
grep -r "cursor.callproc" callcentersite/ → 0 resultados
```

Nadie llama a la base MariaDB desde Python. La arquitectura dual-DB
existe en configuracion pero no en codigo de aplicacion.

---

## Brechas criticas ordenadas por impacto

### BRECHA-01 — CRITICA: SPs de reporte sin endpoint

Los 7 SPs de MariaDB (`sp_rpt_clientes`, `sp_rpt_centros_xsegmento`,
`sp_rpt_llamadas_abandonadas`, etc.) estan desplegados y verificados
en IACT-db pero ningun endpoint de IACT-api los invoca.

Impacto: Los datos del backfill son inaccesibles desde la API.

### BRECHA-02 — CRITICA: pipeline/views.py usa ORM Django en vez de MariaDB

`etl_status` lee de `ETLExecution` (modelo Django, PostgreSQL) en lugar
de `job_execution_log` o `etl_runs` (MariaDB). El historial real del ETL
no es visible desde la API.

### BRECHA-03 — ALTA: app `ivr` completamente vacia

La app dedicada a la integracion con MariaDB esta vacia. Todo el codigo
que deberia estar ahi (adapters, services, viewsets) no existe.

### BRECHA-04 — ALTA: UC_PIP_02..04 sin implementacion

Ver errores ETL, disponibilidad de datos y reintentar pipeline son
funcionalidades operacionales criticas sin implementacion.

### BRECHA-05 — MEDIA: Dominios Operator, Caller y Logs sin implementacion

10 + 5 + 7 = 22 casos de uso sin ninguna app equivalente.

---

## Relacion IACT-db → IACT-api pendiente de implementar

Lo que IACT-db tiene listo y IACT-api deberia consumir:

| Componente IACT-db | Endpoint IACT-api requerido | UC |
|---|---|---|
| `sp_rpt_clientes` | GET /api/ivr/reports/clients/ | UC_RPT_08 |
| `sp_rpt_centros_transferencia` | GET /api/ivr/reports/transfer-centers/ | UC_RPT_09 |
| `sp_rpt_centros_xsegmento` | GET /api/ivr/reports/centers-by-segment/ | UC_RPT_10 |
| `sp_rpt_llamadas_abandonadas` | GET /api/ivr/reports/abandoned/ | UC_RPT_11 |
| `sp_rpt_menu_redirigidos` | GET /api/ivr/reports/redirected-menus/ | UC_RPT_12 |
| `sp_rpt_menu_centro` | GET /api/ivr/reports/menu-center/ | UC_RPT_13 |
| `sp_rpt_cMENU_ERROR` | GET /api/ivr/reports/menu-errors/ | UC_RPT_14 |
| `job_execution_log` | GET /api/ivr/pipeline/status/ | UC_PIP_01 |
| `etl_runs` | GET /api/ivr/pipeline/history/ | UC_PIP_02 |
| `sp_etl_maestro` (via trigger) | POST /api/ivr/pipeline/retry/ | UC_PIP_04 |

---

## Conclusion

IACT-api tiene una base solida para auth, users, access, audit y alerts.
La integracion con IACT-db (el pipeline ETL y los reportes IVR) esta
completamente pendiente de implementacion.

La arquitectura dual-DB esta configurada correctamente en `settings/base.py`
y `db_router.py`. Las variables de entorno estan definidas en `.env`.
Lo que falta es el codigo de aplicacion que use esa conexion para:

1. Invocar los SPs de reporte via `cursor.callproc()`
2. Leer `job_execution_log` y `etl_runs` para el estado del pipeline
3. Exponer los datos a traves de endpoints DRF

El trabajo de Fases 4-6 del PLAN-IMPLEMENTACION-V2.1.md corresponde
exactamente a implementar estas brechas.
