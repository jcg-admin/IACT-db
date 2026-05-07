# Analisis: Casos de uso en scope vs Implementacion (IACT-api)

**Fecha:** 2026-05-07
**Rama docs:** `feature/cnst-033-uml-conformance`
**Fuente UCs:** `source/requisitos/casos-uso/`
**Fuente API:** `IACT-api/callcentersite/`

**Fuera de scope (excluidos de este analisis):**
- `operator/` (uc-opr-01..10) — no se implementa
- `supervision/` (uc-sup-01..03) — no se implementa
- `caller/` (uc-cli-01..05) — no se implementa

---

## Resumen ejecutivo

| Dominio | UCs en scope | Estado | App Django |
|---|---|---|---|
| auth | 5 | IMPLEMENTADO | authentication |
| users | 4 | IMPLEMENTADO | users |
| access | 7 | PARCIAL | access |
| permissions | 10 | PARCIAL | access |
| pipeline | 4 | NO IMPLEMENTADO (config OK, codigo NO) | pipeline |
| reports | 16 | PARCIAL | reports |
| audit | 4 | IMPLEMENTADO | audit |
| alerts | 5 | IMPLEMENTADO | alerts |
| admin | 3 | PARCIAL | solo Django Admin |
| logs | 7 | NO IMPLEMENTADO | — |

**Total en scope:** 65 UCs. Implementados: 18. Parciales: 27. No implementados: 20.

---

## Dominio: auth (5 UCs) — IMPLEMENTADO

App `authentication/` con `AuthViewSet` y `SessionViewSet`.

| UC | Nombre | Endpoint | Estado |
|---|---|---|---|
| UC_AUTH_01 | Iniciar Sesion | POST /auth/login/ | OK |
| UC_AUTH_02 | Cerrar Sesion | POST /auth/logout/ | OK |
| UC_AUTH_03 | Recuperar Contrasena | POST /auth/reset-password/ | OK |
| UC_AUTH_04 | Cambiar Contrasena | POST /auth/change-password/ | OK |
| UC_AUTH_05 | Gestionar Sesiones | GET/DELETE /sessions/ | OK |

**Brecha menor:** Las URLs de `authentication` no estan registradas en
`config/urls.py`. Solo aparece `api/users/`. El router de `authentication`
existe pero no esta conectado al URL raiz del proyecto.

---

## Dominio: users (4 UCs) — IMPLEMENTADO

App `users/` con `UserViewSet` (ModelViewSet completo).

| UC | Nombre | Endpoint | Estado |
|---|---|---|---|
| UC_USR_01 | Crear Usuario | POST /api/users/ | OK |
| UC_USR_02 | Consultar Usuarios | GET /api/users/, GET /api/users/{id}/ | OK |
| UC_USR_03 | Modificar Usuario | PATCH /api/users/{id}/ | OK |
| UC_USR_04 | Eliminar Usuario (baja logica) | DELETE /api/users/{id}/ | OK |

RBAC con funciones `USR_VIEW`, `USR_CREATE`, `USR_EDIT`, `USR_DELETE`.
`get_queryset` filtra por usuario activo vs superuser.

**Brecha menor:** `lock/unlock` mencionado en tarjetas de flujo no tiene
endpoint dedicado — se resuelve via PATCH al estado del usuario.

---

## Dominio: access (7 UCs) — PARCIAL

App `access/` con modelos `Module`, `Function`, `UserPermission`.
ViewSets: `ModuleViewSet`, `UserModuleAccessViewSet`, `MyModulesView`.

| UC | Nombre | Estado |
|---|---|---|
| UC_ACC_01 | Asignar Funciones a Usuario | PARCIAL — existe UserModuleAccess, faltan funciones RBAC granulares |
| UC_ACC_02 | Revocar Funciones de Usuario | PARCIAL — DELETE en UserModuleAccess existe |
| UC_ACC_03 | Consultar Permisos Efectivos | PARCIAL — `get_user_function_codes()` en services.py, sin endpoint dedicado |
| UC_ACC_04 | Asignar Agrupador a Usuario | NO — modelo AccessGroup no existe en esta app |
| UC_ACC_05 | Gestionar Reglas SoD | NO — ningun modelo ni endpoint SoD |
| UC_ACC_08 | Otorgar Permiso Temporal Excepcional | NO — ExceptionalPermission no implementado |
| UC_ACC_09 | Auditar Cambios de Acceso | PARCIAL — audit app existe pero no filtra por cambios de acceso especificamente |

**Brechas de access:**
- `SodRule` (UC_ACC_05): pide GET/POST/PATCH/DELETE `/api/access/sod-rules/` — no existe.
- `ExceptionalPermission` (UC_ACC_08): pide POST/PATCH `/api/access/exceptional/` — no existe.
- `AccessGroup` (UC_ACC_04): pide POST `/api/users/{id}/access-groups/` — no existe.
- Endpoint `/api/users/{id}/effective-permissions/` (UC_ACC_03) — no registrado.

---

## Dominio: permissions (10 UCs) — PARCIAL

Los UCs de permissions son la vista alternativa del modelo RBAC,
complementarios a access. Dependen en gran medida de AccessGroup
y ExceptionalPermission que tampoco estan en access.

| UC | Nombre | Estado |
|---|---|---|
| UC_PERM_01 | Asignar Grupo a Usuario | NO — AccessGroup no existe |
| UC_PERM_02 | Revocar Grupo a Usuario | NO — AccessGroup no existe |
| UC_PERM_03 | Conceder Permiso Excepcional | NO — ExceptionalPermission no existe |
| UC_PERM_04 | Revocar Permiso Excepcional | NO |
| UC_PERM_05 | Crear/Modificar/Retirar Grupo de Permisos | NO |
| UC_PERM_06 | Asignar Funciones a Grupo (composicion AGR) | NO |
| UC_PERM_07 | Verificar Permiso de Usuario | PARCIAL — `get_user_function_codes()` existe sin endpoint HTTP |
| UC_PERM_08 | Generar Menu Dinamico | IMPLEMENTADO — `get_navigation_modules()` + `MyModulesView` |
| UC_PERM_09 | Auditar Acceso (write side) | PARCIAL — via app audit, sin filtro especifico de permisos |
| UC_PERM_10 | Consultar Auditoria de Permisos | PARCIAL — `AuditLogViewSet` existe sin filtro por tipo de cambio de permiso |

**Brecha central:** El modelo `AccessGroup` (agrupador de funciones) que
es la base de PERM-01..06 no esta implementado en ninguna app.
El modelo RBAC actual solo tiene `Module → Function → UserPermission`
sin el nivel intermedio de AccessGroup.

---

## Dominio: pipeline (4 UCs) — NO IMPLEMENTADO (configuracion correcta)

Los 4 UCs piden leer de MariaDB via `connections['ivr'].cursor()`.
La configuracion dual-DB existe y es correcta:

```python
# settings/base.py — EXISTE
DATABASES = {
    'ivr': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': config('IVR_DB_NAME', default='ivr_legacy'),
        'OPTIONS': {'unix_socket': config('IVR_DB_SOCKET')},
    }
}
DATABASE_ROUTERS = ['config.db_router.DatabaseRouter']  # EXISTE
```

Pero en todo el codebase:
```
grep -r "connections['ivr']" callcentersite/ → 0 resultados
grep -r "callproc"            callcentersite/ → 0 resultados
```

| UC | Nombre | Endpoint requerido | Estado |
|---|---|---|---|
| UC_PIP_01 | Supervision estado ETL | GET /api/pipeline/status/ | INCORRECTO |
| UC_PIP_02 | Ver errores ETL | GET /api/pipeline/errors/ | NO |
| UC_PIP_03 | Ver disponibilidad de datos | GET /api/pipeline/data-availability/ | NO |
| UC_PIP_04 | Solicitar reintento de pipeline | POST /api/pipeline/retry/ | NO |

**UC_PIP_01 en detalle — implementado pero incorrecto:**

El endpoint `GET /api/pipeline/status/` existe en `pipeline/urls.py` y
`pipeline/views.py`. Sin embargo lee de `ETLExecution` (modelo ORM Django
en PostgreSQL) en lugar de `job_execution_log` o `etl_runs` en MariaDB.

El UC pide:
```sql
SELECT id, source_table, trimestre, started_at, finished_at,
       estado, base_records, error_message, executed_by
FROM pipeline_runs            -- tabla que en IACT-db se llama job_execution_log
ORDER BY started_at DESC LIMIT 20
```

Lo implementado:
```python
last = ETLExecution.objects.first()   -- modelo Django, PostgreSQL, vacio
```

La tabla `pipeline_runs` del UC corresponde a `job_execution_log` de IACT-db.
El nombre difiere — es necesario alinear el UC con el schema real o
viceversa.

**UC_PIP_04 — reintento via sp_etl_historico:**

El UC especifica llamar directamente:
```sql
CALL sp_etl_historico(:year, :quarter_num)
```
Este SP existe en IACT-db y fue verificado en Fase 3. No tiene endpoint.

---

## Dominio: reports (16 UCs) — PARCIAL

Los UCs de reports se dividen en dos grupos.

### Grupo A — Infraestructura de reportes (sin IVR directo)

| UC | Nombre | Estado |
|---|---|---|
| UC_INC_RPT_01 | Resolver Segmento del Usuario | PARCIAL — logica de segmento no implementada como componente |
| UC_RPT_01 | Ver Dashboard | PARCIAL — `dashboard/` app existe sin datos reales de IVR |
| UC_RPT_02 | Ver Metricas en Tiempo Real | NO — SSE/WebSocket no implementado |
| UC_RPT_03 | Ver Reportes Historicos | PARCIAL — `ReportViewSet` existe con datos Django |
| UC_RPT_04 | Exportar Reporte | PARCIAL — `ExportJobViewSet` existe, exporta datos Django |
| UC_RPT_07 | Programar Reporte | NO — no existe scheduler de reportes |
| UC_RPT_08 | Ver Reportes Programados | NO |
| UC_RPT_09 | Aplicar Filtro Guardado | NO |
| UC_RPT_10 | Guardar Vista | NO |
| UC_RPT_11 | Compartir Vista | NO |

### Grupo B — Reportes IVR (requieren SPs de MariaDB)

Los 7 UCs siguientes piden invocar los SPs de IACT-db via
`connections['ivr'].cursor()` con `callproc`. Ninguno esta implementado.

| UC | Nombre | SP de IACT-db | Endpoint requerido |
|---|---|---|---|
| UC_RPT_12 | Reporte de Agentes | `sp_rpt_centros_transferencia` | GET /api/reports/ivr/transfer-centers/ |
| UC_RPT_13 | Reporte de Colas (Abandonadas) | `sp_rpt_llamadas_abandonadas` | GET /api/reports/ivr/abandoned/ |
| UC_RPT_14 | Reporte de Campanas | `sp_rpt_cMENU_ERROR` | GET /api/reports/ivr/menu-errors/ |
| UC_RPT_15 | Reporte de Transferencias | `sp_rpt_centros_xsegmento` | GET /api/reports/ivr/centers-by-segment/ |
| UC_RPT_16 | Reporte de Menus IVR | `sp_rpt_menu_redirigidos` + `sp_rpt_menu_centro` | GET /api/reports/ivr/menus/ |
| UC_RPT_17 | Reporte de Clientes Unicos | `sp_rpt_clientes` | GET /api/reports/ivr/clients/ |

Estos 6 SPs estan desplegados y verificados en IACT-db (Fase 3).
Ninguno tiene un endpoint en IACT-api.

**El septimo SP, `sp_rpt_centros_transferencia`, no tiene UC asignado
en el scope actual** — es posible que corresponda a UC_RPT_12 o sea
un sub-reporte de otro UC.

---

## Dominio: audit (4 UCs) — IMPLEMENTADO

App `audit/` con `AuditLogViewSet` (ReadOnlyModelViewSet).
Decorator `@audit_action` para registrar eventos.

| UC | Estado |
|---|---|
| UC_AUD_01 | OK — registro automatico via decorator |
| UC_AUD_02 | OK — busqueda en AuditLog via ViewSet |
| UC_AUD_03 | OK — exportacion via ExportJob |
| UC_AUD_04 | PARCIAL — firma/verificacion de integridad mencionada en UC, no evidente en codigo |

---

## Dominio: alerts (5 UCs) — IMPLEMENTADO

App `alerts/` con `InternalMessageViewSet`, `AlertConfigurationViewSet`,
`AlertSubscriptionViewSet`, `scheduler.py`.

| UC | Estado |
|---|---|
| UC_ALR_01 | OK — AlertConfiguration CRUD |
| UC_ALR_02 | OK — evaluacion de alertas en scheduler |
| UC_ALR_03 | OK — reconocimiento via PATCH |
| UC_ALR_04 | PARCIAL — suscripcion existe, notificacion push no confirmada |
| UC_ALR_05 | PARCIAL — historial de alertas sin endpoint dedicado |

---

## Dominio: admin (3 UCs) — PARCIAL

Los UCs de admin (SoD rules, catalogo de funciones, catalogo de
agrupadores) dependen del mismo modelo AccessGroup y SodRule
que access/permissions no tienen implementado.

| UC | Estado |
|---|---|
| UC_ADM_01 | NO — SodRule no existe |
| UC_ADM_02 | PARCIAL — Function model existe en access, sin CRUD completo de catalogo |
| UC_ADM_03 | NO — AccessGroup no existe |

---

## Dominio: logs (7 UCs) — NO IMPLEMENTADO

No existe app `logs/` en IACT-api. Los UCs piden:

| UC | Descripcion | Patron |
|---|---|---|
| UC_LOG_01 | Tail de logs Django (SSE) | GET /api/logs/django/tail/ via SSE |
| UC_LOG_02 | Log de pipeline ETL en tiempo real | GET /api/logs/etl/tail/ via SSE |
| UC_LOG_03 | Consulta libre sobre LogStore | GET /api/logs/search/ con filtros y date range |
| UC_LOG_04 | Export async de logs | POST/GET /api/logs/export/ |
| UC_LOG_05 | Logs de infraestructura (host, container) | GET /api/logs/infra/ |
| UC_LOG_06 | Estado general del sistema de logs | GET /api/logs/health/ |
| UC_LOG_07 | Metricas de logs (pipelines, volumen) | GET /api/logs/metrics/ |

---

## Brecha estructural — `config/urls.py` incompleto

El archivo raiz de URLs solo registra dos rutas:

```python
urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/navigation/', include('apps.core.navigation.urls')),
    path('api/users/', include('apps.users.urls')),
]
```

Las siguientes apps tienen sus propios `urls.py` pero NO estan
incluidas en el router principal:

| App | Router propio | En config/urls.py |
|---|---|---|
| authentication | SI | NO |
| access | SI | NO |
| alerts | SI | NO |
| audit | SI | NO |
| pipeline | SI | NO |
| reports | SI | NO |

En la practica ninguno de estos endpoints es accesible desde la API.
Solo `api/users/` y `api/navigation/` estan activos.

---

## Tabla consolidada de brechas

| ID | Severidad | Descripcion | Afecta |
|---|---|---|---|
| B-01 | CRITICA | 6 SPs de reporte IVR sin endpoint | UC_RPT_12..17 |
| B-02 | CRITICA | pipeline/views.py lee PostgreSQL en vez de MariaDB | UC_PIP_01 |
| B-03 | CRITICA | config/urls.py solo registra users y navigation — todo lo demas inaccesible | Todos |
| B-04 | ALTA | UC_PIP_02..04 sin implementacion | pipeline |
| B-05 | ALTA | AccessGroup y SodRule no existen — bloquean access, permissions y admin | 14 UCs |
| B-06 | ALTA | app logs inexistente | UC_LOG_01..07 |
| B-07 | MEDIA | ExceptionalPermission no existe | UC_ACC_08, UC_PERM_03..04 |
| B-08 | MEDIA | UC_AUD_04 firma de integridad no evidente | audit |
| B-09 | BAJA | authentication no registrado en urls raiz | UC_AUTH_01..05 |
| B-10 | BAJA | UC_RPT_02 (SSE/WS metricas real-time) sin implementacion | reports |

---

## Conclusion

**Lo que funciona (si se conecta config/urls.py):** auth, users, audit, alerts
tienen implementacion funcional y solo necesitan el registro en el router raiz.

**Lo que tiene infraestructura pero no codigo:** La conexion dual-DB esta
correctamente configurada. Los SPs de MariaDB estan desplegados y verificados.
Falta escribir los servicios Python que usen `connections['ivr'].cursor()`
para invocarlos.

**Lo que requiere modelos nuevos:** AccessGroup, SodRule y ExceptionalPermission
son los tres modelos que desbloquean 14 UCs de access, permissions y admin.

**Lo que requiere app nueva:** logs (7 UCs, SSE + query + export).
