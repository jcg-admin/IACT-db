---
id: DOC-REQ-MAPEO-FUNCIONES
tipo: mapeo_tecnico
titulo: Mapeo de Funciones a Módulos Django
version: 1.0.0
fecha_creacion: 2025-11-07
estado: completo
propietario: equipo-backend
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "CATALOGO_GRUPOS_FUNCIONALES"]
date: 2025-11-13
---

# Mapeo de Funciones a Módulos Django

**Proyecto:** Sistema de Permisos Granular
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0

---

## Introducción

Este documento mapea las 13 funciones del sistema de permisos granular con los módulos Django (apps) existentes o a crear.

**Propósito:**
- Identificar qué módulos ya existen
- Determinar qué módulos necesitan crearse
- Establecer plan de integración

---

## Resumen Ejecutivo

| Estado | Cantidad | Módulos |
|--------|----------|---------|
| **Existen** | 5 | users, dashboard, ivr_legacy, reports, analytics, notifications, audit, common |
| **A Crear** | 5 | tickets, clients, teams, schedules, evaluations |
| **TOTAL** | **13 funciones** | 8 existentes + 5 nuevos = 13 módulos |

---

## Mapeo Completo

### FUNCIONES CORE (Prioridad 2)

#### 1. Usuarios → users (EXISTE)

```yaml
Función: sistema.administracion.usuarios
Módulo Django: users
Ubicación: api/callcentersite/callcentersite/apps/users/
Estado: EXISTE
Acción: EXTENDER
```

**Estado Actual:**
- Modelos in-memory para permisos granulares
- UserManager, PermissionManager, RoleManager
- PermissionService con evaluación de 3 niveles

**Cambios Necesarios:**
- Agregar UserManagementService (crear, suspender, asignar_grupos)
- Crear endpoints REST /api/usuarios/
- Integrar con tabla usuarios_grupos de PostgreSQL

**Archivos a Modificar:**
- `users/services.py` - Agregar UserManagementService
- `users/views.py` - Crear UserViewSet
- `users/urls.py` - Configurar rutas

---

#### 2. Dashboards → dashboard (EXISTE)

```yaml
Función: sistema.vistas.dashboards
Módulo Django: dashboard
Ubicación: api/callcentersite/callcentersite/apps/dashboard/
Estado: EXISTE
Acción: EXTENDER con permisos
```

**Estado Actual:**
- Módulo básico de dashboards

**Cambios Necesarios:**
- Integrar verificación de permisos granulares
- Agregar endpoints: exportar, personalizar, compartir
- Implementar filtros por capacidad

**Archivos a Modificar:**
- `dashboard/views.py` - Agregar decoradores de permisos
- `dashboard/serializers.py` - Agregar campos de permisos

---

#### 3. Configuración → common (EXISTE)

```yaml
Función: sistema.tecnico.configuracion
Módulo Django: common
Ubicación: api/callcentersite/callcentersite/apps/common/
Estado: EXISTE
Acción: EXTENDER con gestión de configuración
```

**Estado Actual:**
- Módulo común con utilidades

**Cambios Necesarios:**
- Crear ConfigurationService
- Agregar endpoints /api/configuracion/
- Implementar exportar/importar configuración

**Archivos a Crear:**
- `common/services/configuration_service.py`
- `common/views/configuration_views.py`
- `common/models/system_config.py`

---

### FUNCIONES OPERATIVAS (Prioridad 3)

#### 4. Llamadas IVR → ivr_legacy (EXISTE)

```yaml
Función: sistema.operaciones.llamadas
Módulo Django: ivr_legacy
Ubicación: api/callcentersite/callcentersite/apps/ivr_legacy/
Estado: EXISTE
Acción: EXTENDER con permisos y servicios
```

**Estado Actual:**
- Modelos: IVRCall, IVRClient
- Integración con sistema IVR legacy

**Cambios Necesarios:**
- Crear CallService con permisos granulares
- Agregar endpoints /api/llamadas/
- Implementar: realizar, recibir, transferir, escuchar_grabaciones

**Archivos a Crear:**
- `ivr_legacy/services/call_service.py`
- `ivr_legacy/views/call_views.py`
- `ivr_legacy/serializers/call_serializers.py`

---

#### 5. Tickets → tickets (NO EXISTE)

```yaml
Función: sistema.operaciones.tickets
Módulo Django: tickets
Ubicación: api/callcentersite/callcentersite/apps/tickets/
Estado: NO EXISTE
Acción: CREAR NUEVO
```

**A Implementar:**
- Modelo: Ticket (título, descripción, estado, prioridad, asignado_a)
- Servicio: TicketService (crear, editar, asignar, cerrar, reabrir)
- Endpoints: /api/tickets/
- Relaciones: con IVRCall, IVRClient

**Archivos a Crear:**
```
tickets/
 __init__.py
 apps.py
 models.py
 services/
 ticket_service.py
 views.py
 serializers.py
 urls.py
 migrations/
```

---

#### 6. Clientes → clients (NO EXISTE)

```yaml
Función: sistema.operaciones.clientes
Módulo Django: clients
Ubicación: api/callcentersite/callcentersite/apps/clients/
Estado: NO EXISTE
Acción: CREAR NUEVO (integra con IVRClient)
```

**A Implementar:**
- Extender IVRClient existente o crear Client nuevo
- Servicio: ClientService (crear, editar, ver_historial, exportar)
- Endpoints: /api/clientes/
- Integración con IVRClient de ivr_legacy

**Nota:** Evaluar si extender IVRClient o crear modelo separado

**Archivos a Crear:**
```
clients/
 __init__.py
 apps.py
 models.py (o extender IVRClient)
 services/
 client_service.py
 views.py
 serializers.py
 urls.py
```

---

#### 7. Métricas → analytics (EXISTE)

```yaml
Función: sistema.analisis.metricas
Módulo Django: analytics
Ubicación: api/callcentersite/callcentersite/apps/analytics/
Estado: EXISTE
Acción: EXTENDER con permisos granulares
```

**Estado Actual:**
- Sistema de analytics básico

**Cambios Necesarios:**
- Agregar MetricsService con permisos
- Endpoints /api/metricas/ con filtros por capacidad
- Implementar: ver, ver_detalladas, exportar, configurar, crear_alertas

**Archivos a Modificar/Crear:**
- `analytics/services/metrics_service.py`
- `analytics/views/metrics_views.py`

---

#### 8. Reportes → reports (EXISTE)

```yaml
Función: sistema.analisis.reportes
Módulo Django: reports
Ubicación: api/callcentersite/callcentersite/apps/reports/
Estado: EXISTE
Acción: EXTENDER con permisos y generación
```

**Estado Actual:**
- Módulo de reportes básico

**Cambios Necesarios:**
- Agregar ReportsService con permisos
- Endpoints /api/reportes/
- Implementar: ver, generar, programar, exportar, compartir

**Archivos a Modificar:**
- `reports/services/report_service.py`
- `reports/views/report_views.py`

---

#### 9. Alertas → notifications (EXISTE)

```yaml
Función: sistema.monitoreo.alertas
Módulo Django: notifications
Ubicación: api/callcentersite/callcentersite/apps/notifications/
Estado: EXISTE
Acción: EXTENDER con gestión de alertas
```

**Estado Actual:**
- Sistema de notificaciones básico

**Cambios Necesarios:**
- Agregar AlertService con permisos
- Endpoints /api/alertas/
- Implementar: ver, crear, editar, activar, desactivar, configurar_notificaciones

**Archivos a Modificar:**
- `notifications/services/alert_service.py`
- `notifications/views/alert_views.py`

---

### FUNCIONES DE GESTIÓN (Prioridad 4)

#### 10. Equipos → teams (NO EXISTE)

```yaml
Función: sistema.supervision.equipos
Módulo Django: teams
Ubicación: api/callcentersite/callcentersite/apps/teams/
Estado: NO EXISTE
Acción: CREAR NUEVO
```

**A Implementar:**
- Modelos: Team, TeamMember
- Servicio: TeamManagementService
- Endpoints: /api/equipos/
- Relaciones: Team has many Users, User can be in multiple Teams

**Archivos a Crear:**
```
teams/
 __init__.py
 apps.py
 models.py
 services/
 team_management_service.py
 views.py
 serializers.py
 urls.py
```

---

#### 11. Horarios → schedules (NO EXISTE)

```yaml
Función: sistema.supervision.horarios
Módulo Django: schedules
Ubicación: api/callcentersite/callcentersite/apps/schedules/
Estado: NO EXISTE
Acción: CREAR NUEVO
```

**A Implementar:**
- Modelos: Schedule, Shift, TimeSlot
- Servicio: ScheduleService
- Endpoints: /api/horarios/
- Aprobaciones workflow

**Archivos a Crear:**
```
schedules/
 __init__.py
 apps.py
 models.py
 services/
 schedule_service.py
 views.py
 serializers.py
 urls.py
```

---

#### 12. Evaluaciones → evaluations (NO EXISTE)

```yaml
Función: sistema.calidad.evaluaciones
Módulo Django: evaluations
Ubicación: api/callcentersite/callcentersite/apps/evaluations/
Estado: NO EXISTE
Acción: CREAR NUEVO
```

**A Implementar:**
- Modelos: Evaluation, EvaluationCriteria
- Servicio: EvaluationService
- Endpoints: /api/evaluaciones/
- Workflow de aprobación

**Archivos a Crear:**
```
evaluations/
 __init__.py
 apps.py
 models.py
 services/
 evaluation_service.py
 views.py
 serializers.py
 urls.py
```

---

#### 13. Auditoría → audit (EXISTE)

```yaml
Función: sistema.calidad.auditoria
Módulo Django: audit
Ubicación: api/callcentersite/callcentersite/apps/audit/
Estado: EXISTE
Acción: EXTENDER con auditoría de calidad
```

**Estado Actual:**
- Sistema de auditoría de accesos

**Cambios Necesarios:**
- Agregar QualityAuditService
- Endpoints /api/auditoria/
- Implementar: auditar_llamadas, auditar_tickets, ver_reportes, exportar

**Archivos a Crear:**
- `audit/services/quality_audit_service.py`
- `audit/models/quality_audit.py`
- `audit/views/quality_audit_views.py`

---

## Plan de Implementación por Módulo

### Fase 1: Módulos Existentes a Extender (Semana 1-2)

```python
# [ ] users - Agregar UserManagementService
# [ ] dashboard - Agregar permisos granulares
# [ ] common - Agregar ConfigurationService
# [ ] ivr_legacy - Agregar CallService
# [ ] analytics - Agregar MetricsService
# [ ] reports - Agregar ReportsService
# [ ] notifications - Agregar AlertService
# [ ] audit - Agregar QualityAuditService
```

### Fase 2: Módulos Nuevos a Crear (Semana 3-4)

```python
# [ ] tickets - Crear módulo completo
# [ ] clients - Crear módulo (integrar con IVRClient)
# [ ] teams - Crear módulo completo
# [ ] schedules - Crear módulo completo
# [ ] evaluations - Crear módulo completo
```

---

## Checklist de Integración por Módulo

### Template: Integrar Módulo Existente

```python
# [ ] 1. Agregar PermissionService check en views
# [ ] 2. Crear Service class con métodos
# [ ] 3. Agregar endpoints REST en urls.py
# [ ] 4. Crear serializers
# [ ] 5. Agregar tests de permisos
# [ ] 6. Integrar con AuditService
# [ ] 7. Documentar en Swagger/OpenAPI
```

### Template: Crear Módulo Nuevo

```python
# [ ] 1. Crear app Django con startapp
# [ ] 2. Registrar en INSTALLED_APPS
# [ ] 3. Crear modelos
# [ ] 4. Crear y ejecutar migraciones
# [ ] 5. Crear Service class
# [ ] 6. Crear ViewSet con permisos
# [ ] 7. Configurar URLs
# [ ] 8. Crear serializers
# [ ] 9. Escribir tests
# [ ] 10. Documentar API
```

---

## Scripts de Verificación

### Listar todos los módulos Django

```bash
cd api/callcentersite/callcentersite/apps/
ls -d */ | sort
```

### Verificar módulos registrados en settings

```python
# api/callcentersite/callcentersite/settings.py

INSTALLED_APPS = [
 # Django apps
 'django.contrib.admin',
 # ...

 # Project apps
 'callcentersite.apps.users',
 'callcentersite.apps.authentication',
 'callcentersite.apps.dashboard',
 'callcentersite.apps.ivr_legacy',
 'callcentersite.apps.reports',
 'callcentersite.apps.analytics',
 'callcentersite.apps.notifications',
 'callcentersite.apps.audit',
 'callcentersite.apps.common',
 'callcentersite.apps.etl',

 # Nuevos módulos
 'callcentersite.apps.tickets', # A crear
 'callcentersite.apps.clients', # A crear
 'callcentersite.apps.teams', # A crear
 'callcentersite.apps.schedules', # A crear
 'callcentersite.apps.evaluations', # A crear
]
```

---

## Resumen de Acciones

| Módulo Django | Función | Acción | Prioridad |
|---------------|---------|--------|-----------|
| users | Usuarios | EXTENDER | P2 |
| dashboard | Dashboards | EXTENDER | P2 |
| common | Configuración | EXTENDER | P2 |
| ivr_legacy | Llamadas | EXTENDER | P3 |
| tickets | Tickets | CREAR | P3 |
| clients | Clientes | CREAR | P3 |
| analytics | Métricas | EXTENDER | P3 |
| reports | Reportes | EXTENDER | P3 |
| notifications | Alertas | EXTENDER | P3 |
| teams | Equipos | CREAR | P4 |
| schedules | Horarios | CREAR | P4 |
| evaluations | Evaluaciones | CREAR | P4 |
| audit | Auditoría | EXTENDER | P4 |

---

**Documento:** Mapeo de Funciones a Módulos Django
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0
**Estado:** Completo

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Mapeo completo de 13 funciones a módulos Django | equipo-arquitectura |
