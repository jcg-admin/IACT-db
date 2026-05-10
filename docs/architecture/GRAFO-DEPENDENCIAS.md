# Grafo de dependencias — UC vs IACT-api

**Fecha:** 2026-05-07
**Fuente:** ANALISIS-UC-vs-IACT-API-V2_2026-05-07T204108.md
**Alcance:** 65 UCs en scope (excluye operator, supervision, caller)

---

## Capas del sistema

```
CAPA 0: MariaDB ivr_legacy
  ├── job_execution_log  (13 checkpoints SUCCESS post-Fase 3)
  ├── base_ivr_detalle   (32,852 filas · 6 quarters)
  ├── base_ivr_clientes  (18 filas)
  ├── sp_rpt_* (7)       (SPs de reporte — desplegados Fase 3)
  ├── sp_etl_* (5)       (SPs de pipeline)
  └── etl_runs           (tracking management command Django)

CAPA 1: Django connections['ivr'].cursor()    ← B-02+B-04+B-01+B-06 implementados
  ├── pipeline/views.py  → etl_status, etl_errors, data_availability, retry
  ├── reports/ivr_services.py → 7 funciones callproc()
  └── logs/views.py      → ETLLogTailView lee job_execution_log

CAPA 2: Modelos Django (PostgreSQL)            ← B-05+B-07 implementados
  ├── access/models.py   → Module, Function, UserPermission,
  │                         AccessGroup✓, UserAccessGroup✓,
  │                         SodRule✓, ExceptionalPermission✓
  ├── authentication/    → User, Session, BlacklistedToken
  ├── audit/models.py    → AuditLog (inmutable)
  ├── alerts/models.py   → AlertConfiguration, AlertSubscription, InternalMessage
  ├── pipeline/models.py → ETLExecution, Center, Service, CallRecord, CallNote
  └── reports/models.py  → Report, ExportJob

CAPA 3: config/urls.py                         ← B-03+B-09 implementados
  ├── /api/              → authentication (5 UCs)
  ├── /api/users/        → users (4 UCs)
  ├── /api/access/       → access + permissions + admin (17+ UCs)
  ├── /api/audit/        → audit (4 UCs)
  ├── /api/alerts/       → alerts (5 UCs)
  ├── /api/pipeline/     → pipeline (4 UCs)
  ├── /api/reports/      → reports infraestructura + IVR (16 UCs)
  └── /api/logs/         → logs (7 UCs)                ← B-06

CAPA 4: Casos de uso en scope (65)
  ├── auth      (5)  IMPLEMENTADO
  ├── users     (4)  IMPLEMENTADO
  ├── access    (7)  PARCIAL
  ├── permissions(10) PARCIAL → depende AccessGroup✓
  ├── pipeline  (4)  IMPLEMENTADO — todos leen MariaDB
  ├── reports  (16)  PARCIAL — IVR endpoints✓, SSE pendiente
  ├── audit     (4)  IMPLEMENTADO (incluyendo HMAC)
  ├── alerts    (5)  IMPLEMENTADO (push en progreso)
  ├── admin     (3)  PARCIAL → SodRule✓ AccessGroup✓
  └── logs      (7)  IMPLEMENTADO (SSE stub prod)
```

---

## Dependencias bloqueantes pre-implementacion

```
AccessGroup (B-05) bloqueaba:
  UC_ACC_04 Asignar agrupador
  UC_ACC_05 Gestionar SoD   (+ SodRule)
  UC_ACC_08 Permiso excepcional (+ ExceptionalPermission)
  UC_PERM_01 Asignar grupo
  UC_PERM_02 Revocar grupo
  UC_PERM_03 Permiso excepcional
  UC_PERM_04 Revocar excepcional
  UC_PERM_05 CRUD grupos
  UC_PERM_06 Asignar funcion a grupo
  UC_ADM_01  Ciclo de vida SoD
  UC_ADM_03  Catalogo agrupadores
  → 11 UCs desbloqueados por B-05

config/urls.py (B-03) bloqueaba:
  Todos los endpoints de authentication, access, audit,
  alerts, pipeline, reports
  → 60+ endpoints inaccesibles sin este fix

pipeline/views.py leyendo PostgreSQL (B-02):
  UC_PIP_01 mostraba datos ficticios (ETLExecution vacía)
  → Corregido para leer job_execution_log en MariaDB
```

---

## Cadena IVR completa (post-implementacion)

```
MariaDB
  sp_rpt_clientes         → ivr_services.get_clientes()
  sp_rpt_centros_transfer → ivr_services.get_centros_transferencia()
  sp_rpt_llamadas_aband.  → ivr_services.get_llamadas_abandonadas()
  sp_rpt_cMENU_ERROR      → ivr_services.get_cmenu_error()
  sp_rpt_centros_xsegm.   → ivr_services.get_centros_xsegmento()
  sp_rpt_menu_redirigidos → ivr_services.get_menu_redirigidos()
  sp_rpt_menu_centro      → ivr_services.get_menu_centro()
        ↓
  reports/ivr_views.py
  ClientesReportView      → GET /api/reports/ivr/clients/          UC_RPT_17
  CentrosTransfView       → GET /api/reports/ivr/transfer-centers/ UC_RPT_12
  LlamadasAbandonadasView → GET /api/reports/ivr/abandoned/        UC_RPT_13
  CMENUErrorView          → GET /api/reports/ivr/menu-errors/      UC_RPT_14
  CentrosXSegmentoView    → GET /api/reports/ivr/centers-by-seg/   UC_RPT_15
  MenusIVRView            → GET /api/reports/ivr/menus/            UC_RPT_16
```

---

## Estado final por brecha

| ID | Sev | Descripcion resumida | Estado |
|---|---|---|---|
| B-01 | CRITICA | 6 SPs reporte IVR sin endpoint | ✓ IMPLEMENTADO |
| B-02 | CRITICA | pipeline lee PostgreSQL en vez MariaDB | ✓ IMPLEMENTADO |
| B-03 | CRITICA | config/urls.py incompleto | ✓ IMPLEMENTADO |
| B-04 | ALTA | UC_PIP_02..04 sin implementacion | ✓ IMPLEMENTADO |
| B-05 | ALTA | AccessGroup y SodRule inexistentes | ✓ IMPLEMENTADO |
| B-06 | ALTA | app logs inexistente | ✓ IMPLEMENTADO |
| B-07 | MEDIA | ExceptionalPermission inexistente | ✓ IMPLEMENTADO (en B-05) |
| B-08 | MEDIA | UC_AUD_04 firma sin implementar | ✓ IMPLEMENTADO |
| B-09 | BAJA | auth no en urls raiz | ✓ IMPLEMENTADO (en B-03) |
| B-10 | BAJA | UC_RPT_02 SSE sin implementar | PENDIENTE (ASGI) |

---

## Pendiente post-implementacion

1. **B-10** — UC_RPT_02 metricas SSE/WebSocket: requiere servidor ASGI
   (uvicorn/daphne). Django sync no soporta streaming nativo.

2. **Migraciones Django** — Los 4 modelos nuevos de access
   (AccessGroup, UserAccessGroup, SodRule, ExceptionalPermission)
   necesitan `python manage.py makemigrations access && migrate`.

3. **Permisos granulares UC_ACC_01/02** — La asignacion de funciones
   RBAC todavia usa el modelo `UserModuleAccess` (modulos completos)
   en vez de `UserPermission` (funciones individuales). El modelo
   existe, la vista necesita ajuste.

4. **SSE en UC_LOG_01/02** — Los endpoints de tail retornan snapshot
   estatico. En produccion con ASGI se reemplaza por StreamingHttpResponse.
