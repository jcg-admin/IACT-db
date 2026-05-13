---
id: DOC-BACKEND-PLANIFICACION
titulo: Planificación de Documentación de Apps Django
estado: activo
fecha_creacion: 2025-11-04
ultima_actualizacion: 2025-11-04
relacionados: ["DOC-SOL-SC03", "DOC-ARQ-BACKEND", "DOC-BACKEND-INDEX"]
date: 2025-11-13
---

# Planificación de Documentación de Apps Django

## Índice

1. [Visión General](#visión-general)
2. [Desglose por App](#desglose-por-app)
3. [Plantillas y Diagramas](#plantillas-y-diagramas)
4. [Timeline y Fases](#timeline-y-fases)
5. [Recursos Necesarios](#recursos-necesarios)
6. [Métricas y KPIs](#métricas-y-kpis)
7. [Plan de Ejecución](#plan-de-ejecución)

---

## Visión General

### Objetivo

Documentar exhaustivamente las **10 aplicaciones Django** del backend siguiendo las plantillas establecidas en SC02 y los patrones arquitectónicos identificados.

### Alcance Total

| Métrica | Cantidad | Notas |
|---------|----------|-------|
| Apps a documentar | 10 | Todas las apps de `api/callcentersite/apps/` |
| Documentos markdown | 10 | Uno por app |
| Diagramas PlantUML | ~40 | 4-5 diagramas por app |
| Plantillas utilizadas | 2 | Django App, ETL Job |
| Líneas estimadas | ~12,000 | 1,200 líneas promedio por app |
| Duración estimada | 16-20 días | 4-5 semanas |

### Entregables Finales

1. **10 documentos técnicos completos** en `docs/backend/diseno_detallado/apps/`
2. **~40 diagramas PlantUML** embebidos en documentos
3. **Guía consolidada de APIs REST**
4. **Mapa de dependencias entre apps**
5. **Troubleshooting general del backend**

---

## Desglose por App

### FASE 1: Apps Críticas (Semana 1-2)

---

#### 1. ETL (Extract-Transform-Load)

**Prioridad**: CRÍTICA | **Complejidad**: Alta | **Estimación**: 2-3 días

##### Información General
- **Propósito**: Pipeline de datos desde IVR legacy a Analytics
- **Patrón arquitectónico**: ETL Pipeline Pattern
- **Plantilla**: `plantilla_etl_job.md`
- **Líneas estimadas**: 1,400

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información del Job | `jobs.py`, `scheduler.py` | 2h |
| 2. Fuente de datos (Extract) | `extractors.py` | 3h |
| 3. Transformaciones (Transform) | `transformers.py` | 4h |
| 4. Destino (Load) | `loaders.py` | 3h |
| 5. Dependencias | `__init__.py`, imports | 1h |
| 6. Monitoreo y métricas | logs, settings | 2h |
| 7. Recuperación ante fallos | exception handling | 2h |
| 8. Testing y validación | `tests/` | 2h |

**Total estimado**: 19 horas (~2.5 días)

##### Diagramas a Crear

1. **Diagrama de flujo general** (PlantUML Activity)
 ```plantuml
 Scheduler → Job Orquestador → Extractor → Transformer → Loader
 ```
 - **Tipo**: Activity Diagram
 - **Elementos**: 5 componentes principales
 - **Complejidad**: Media
 - **Tiempo**: 1h

2. **Diagrama de secuencia E-T-L** (PlantUML Sequence)
 ```plantuml
 Job → IVRDataExtractor → IVRDataAdapter → MariaDB
 Job → CallDataTransformer → validación/limpieza
 Job → AnalyticsDataLoader → PostgreSQL
 ```
 - **Tipo**: Sequence Diagram
 - **Elementos**: 7 participantes, 15+ mensajes
 - **Complejidad**: Alta
 - **Tiempo**: 2h

3. **Diagrama de flujo de datos** (PlantUML Component)
 ```plantuml
 [IVR MariaDB] --> [Extractor] : raw_calls
 [Extractor] --> [Transformer] : List[IVRCall]
 [Transformer] --> [Loader] : List[dict]
 [Loader] --> [Analytics PostgreSQL] : CallAnalytics
 ```
 - **Tipo**: Component Diagram
 - **Elementos**: 4 componentes, 3 flujos
 - **Complejidad**: Baja
 - **Tiempo**: 1h

4. **Diagrama de componentes** (PlantUML Component)
 - **Tipo**: Component Diagram
 - **Elementos**: Estructura de archivos ETL
 - **Complejidad**: Media
 - **Tiempo**: 1h

5. **Diagrama de manejo de errores** (PlantUML Activity)
 - **Tipo**: Activity Diagram
 - **Elementos**: Try/catch, retry logic
 - **Complejidad**: Media
 - **Tiempo**: 1h

**Total diagramas**: 5 | **Tiempo total**: 6 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de extracción de datos
- [ ] Ejemplo de transformación con validación
- [ ] Ejemplo de carga con transacción
- [ ] Ejemplo de manejo de errores
- [ ] Ejemplo de configuración de scheduler

##### Dependencias

- Requiere analizar: `ivr_legacy.adapters`, `analytics.models`
- Requiere entender: configuración de bases de datos
- Requiere revisar: logs y monitoreo

---

#### 2. Analytics

**Prioridad**: CRÍTICA | **Complejidad**: Media | **Estimación**: 1-2 días

##### Información General
- **Propósito**: Almacenamiento de métricas y KPIs
- **Patrón arquitectónico**: Data Sink
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 800

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py`, `__init__.py` | 1h |
| 2. Modelos | `models.py` | 3h |
| 3. Servicios | (no existe) | - |
| 4. Vistas | (no existe) | - |
| 5. URLs | (no existe) | - |
| 6. Configuración | settings | 1h |
| 7. Tests | `tests/` | 1h |
| 8. Diagramas | - | 4h |

**Total estimado**: 10 horas (~1.5 días)

##### Diagramas a Crear

1. **Diagrama de clases** (PlantUML Class)
 ```plantuml
 class CallAnalytics {
 +call_id: CharField
 +duration: IntegerField
 +queue_time: IntegerField
 +call_date: DateTimeField
 }
 class DailyMetrics {
 +date: DateField
 +total_calls: IntegerField
 +avg_duration: FloatField
 }
 TimeStampedModel <|-- CallAnalytics
 TimeStampedModel <|-- DailyMetrics
 ```
 - **Tipo**: Class Diagram
 - **Elementos**: 3 clases, herencia
 - **Complejidad**: Baja
 - **Tiempo**: 1h

2. **Diagrama ER** (PlantUML Entity-Relationship)
 - **Tipo**: ER Diagram
 - **Elementos**: 2 tablas, campos
 - **Complejidad**: Baja
 - **Tiempo**: 1h

3. **Diagrama de componentes** (PlantUML Component)
 ```plantuml
 [ETL Loader] --> [CallAnalytics]
 [ETL Loader] --> [DailyMetrics]
 [Dashboard] --> [CallAnalytics] : reads
 [Dashboard] --> [DailyMetrics] : reads
 ```
 - **Tipo**: Component Diagram
 - **Elementos**: 4 componentes
 - **Complejidad**: Baja
 - **Tiempo**: 1h

4. **Flujo de datos** (PlantUML Sequence)
 ```plantuml
 ETL -> CallAnalytics : save()
 Dashboard -> CallAnalytics : filter(date=today)
 ```
 - **Tipo**: Sequence Diagram
 - **Elementos**: 3 participantes
 - **Complejidad**: Baja
 - **Tiempo**: 1h

**Total diagramas**: 4 | **Tiempo total**: 4 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de creación de CallAnalytics
- [ ] Ejemplo de query para métricas diarias
- [ ] Ejemplo de agregación de datos

---

#### 3. Reports

**Prioridad**: CRÍTICA | **Complejidad**: Media-Alta | **Estimación**: 2 días

##### Información General
- **Propósito**: Generación de reportes en múltiples formatos
- **Patrón arquitectónico**: Strategy Pattern
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 1,300

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos | `models.py` | 3h |
| 3. Servicios | (si existe) | 2h |
| 4. Generadores (Strategy) | `generators/*.py` | 5h |
| 5. Vistas | `views.py` | 2h |
| 6. URLs | `urls.py` | 1h |
| 7. Tests | `tests/` | 2h |
| 8. Diagramas | - | 5h |

**Total estimado**: 21 horas (~2.5 días, ajustado a 2)

##### Diagramas a Crear

1. **Diagrama de clases (modelos)** (PlantUML Class)
 - **Elementos**: ReportTemplate, GeneratedReport
 - **Complejidad**: Media
 - **Tiempo**: 1h

2. **Diagrama ER** (PlantUML ER)
 - **Elementos**: 2 tablas con relaciones
 - **Complejidad**: Baja
 - **Tiempo**: 1h

3. **Diagrama de Strategy Pattern** (PlantUML Class)
 ```plantuml
 abstract class BaseReportGenerator {
 +generate(queryset, params)
 }
 class CSVGenerator
 class ExcelGenerator
 class PDFGenerator
 BaseReportGenerator <|-- CSVGenerator
 BaseReportGenerator <|-- ExcelGenerator
 BaseReportGenerator <|-- PDFGenerator
 ```
 - **Tipo**: Class Diagram
 - **Elementos**: 4 clases, patrón Strategy
 - **Complejidad**: Media
 - **Tiempo**: 1.5h

4. **Flujo de generación de reportes** (PlantUML Sequence)
 - **Tipo**: Sequence Diagram
 - **Elementos**: Usuario, View, Service, Generator, FileSystem
 - **Complejidad**: Alta
 - **Tiempo**: 2h

5. **Diagrama de componentes** (PlantUML Component)
 - **Elementos**: models, generators, views
 - **Complejidad**: Media
 - **Tiempo**: 1h

**Total diagramas**: 5 | **Tiempo total**: 6.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de creación de ReportTemplate
- [ ] Ejemplo de generación de reporte CSV
- [ ] Ejemplo de generación de reporte Excel
- [ ] Ejemplo de uso del registry de generadores
- [ ] Ejemplo de vista REST para descargar reporte

---

### FASE 2: Apps de Soporte (Semana 3-4)

---

#### 4. Audit

**Prioridad**: MEDIA | **Complejidad**: Media | **Estimación**: 1 día

##### Información General
- **Propósito**: Sistema de auditoría inmutable
- **Patrón arquitectónico**: Service Layer Pattern
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 900

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos | `models.py` (AuditLog) | 2h |
| 3. Servicios | `services.py` (AuditService) | 3h |
| 4. Vistas | (si existe) | 1h |
| 5. Tests | `tests/` | 1h |
| 6. Diagramas | - | 4h |

**Total estimado**: 12 horas (~1.5 días)

##### Diagramas a Crear

1. **Diagrama de clases** (PlantUML Class)
 ```plantuml
 class AuditLog {
 +user: ForeignKey
 +action: CharField
 +resource: CharField
 +details: JSONField
 +save()
 }
 class AuditService {
 +{static} log(action, user, resource)
 }
 ```
 - **Complejidad**: Baja
 - **Tiempo**: 1h

2. **Diagrama ER** (PlantUML ER)
 - **Elementos**: 1 tabla con FK a User
 - **Tiempo**: 0.5h

3. **Flujo de auditoría** (PlantUML Sequence)
 ```plantuml
 App -> AuditService : log(action, user, resource)
 AuditService -> AuditLog : create()
 AuditLog -> DB : INSERT (no UPDATE allowed)
 ```
 - **Complejidad**: Media
 - **Tiempo**: 1.5h

4. **Integración con otras apps** (PlantUML Component)
 - **Elementos**: Muestra cómo todas las apps usan AuditService
 - **Tiempo**: 1h

**Total diagramas**: 4 | **Tiempo total**: 4 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de uso de AuditService.log()
- [ ] Ejemplo de modelo inmutable
- [ ] Ejemplo de consulta de logs

---

#### 5. Dashboard

**Prioridad**: MEDIA | **Complejidad**: Media-Alta | **Estimación**: 2 días

##### Información General
- **Propósito**: Orquestación de widgets, API REST
- **Patrón arquitectónico**: Service Layer + Registry Pattern
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 1,200

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos | `models.py` (si existe) | 1h |
| 3. Servicios | `services.py` (DashboardService) | 3h |
| 4. Widgets (Registry) | `widgets.py` | 4h |
| 5. Vistas (DRF) | `views.py` | 3h |
| 6. URLs | `urls.py` | 1h |
| 7. Tests | `tests/` | 2h |
| 8. Diagramas | - | 5h |

**Total estimado**: 20 horas (~2.5 días)

##### Diagramas a Crear

1. **Diagrama de clases** (PlantUML Class)
 - **Elementos**: DashboardService, Widget base, widgets concretos
 - **Complejidad**: Alta
 - **Tiempo**: 2h

2. **Diagrama de Registry Pattern** (PlantUML Class)
 ```plantuml
 class Widget {
 +widget_id: str
 +get_data()
 +is_available()
 }
 class CallMetricsWidget
 class UnreadMessagesWidget
 class PendingReportsWidget

 Widget <|-- CallMetricsWidget
 Widget <|-- UnreadMessagesWidget
 Widget <|-- PendingReportsWidget

 WIDGET_REGISTRY --> Widget : contains
 ```
 - **Complejidad**: Media
 - **Tiempo**: 1.5h

3. **Flujo de construcción de dashboard** (PlantUML Sequence)
 ```plantuml
 Client -> DashboardOverviewView : GET /api/dashboard
 DashboardOverviewView -> DashboardService : overview()
 DashboardService -> WIDGET_REGISTRY : get all widgets
 loop for each widget
 DashboardService -> Widget : get_data()
 end
 DashboardService --> DashboardOverviewView : data
 DashboardOverviewView --> Client : JSON response
 ```
 - **Complejidad**: Alta
 - **Tiempo**: 2h

4. **Diagrama de componentes** (PlantUML Component)
 - **Elementos**: Services, Widgets, Views, APIs externas
 - **Tiempo**: 1h

**Total diagramas**: 4 | **Tiempo total**: 6.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de creación de widget custom
- [ ] Ejemplo de registro de widget (@register_widget)
- [ ] Ejemplo de llamada a API REST
- [ ] Ejemplo de respuesta JSON

---

#### 6. Authentication

**Prioridad**: MEDIA | **Complejidad**: Media | **Estimación**: 1-2 días

##### Información General
- **Propósito**: Autenticación y seguridad
- **Patrón arquitectónico**: Mixto (Service + Active Record)
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 1,000

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos | `models.py` (SecurityQuestion, LoginAttempt) | 3h |
| 3. Servicios | `services.py` (LoginAttemptService) | 2h |
| 4. Vistas | `views.py` | 2h |
| 5. Tests | `tests/` | 2h |
| 6. Configuración seguridad | settings, middleware | 2h |
| 7. Diagramas | - | 4h |

**Total estimado**: 16 horas (~2 días)

##### Diagramas a Crear

1. **Diagrama de clases** (PlantUML Class)
 - **Elementos**: SecurityQuestion, LoginAttempt, LoginAttemptService
 - **Tiempo**: 1h

2. **Diagrama ER** (PlantUML ER)
 - **Elementos**: 2 tablas con FK a User
 - **Tiempo**: 1h

3. **Flujo de login y rate limiting** (PlantUML Sequence)
 - **Elementos**: Usuario, View, LoginAttemptService, LoginAttempt
 - **Tiempo**: 1.5h

4. **Flujo de recuperación de cuenta** (PlantUML Sequence)
 - **Elementos**: Usuario, View, SecurityQuestion
 - **Tiempo**: 1h

**Total diagramas**: 4 | **Tiempo total**: 4.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de creación de pregunta de seguridad
- [ ] Ejemplo de verificación de respuesta
- [ ] Ejemplo de registro de intento de login
- [ ] Ejemplo de rate limiting

---

#### 7. Users

**Prioridad**: MEDIA | **Complejidad**: Alta | **Estimación**: 2 días

##### Información General
- **Propósito**: Sistema custom de permisos
- **Patrón arquitectónico**: Service Layer (arquitectura única in-memory)
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 1,400

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos (dataclasses) | `models.py` | 5h |
| 3. Managers (InMemoryManager) | `models.py` | 3h |
| 4. Servicios | `services.py` (PermissionService) | 4h |
| 5. Tests | `tests/` | 2h |
| 6. Diagramas | - | 6h |

**Total estimado**: 21 horas (~2.5 días, ajustado a 2)

##### Diagramas a Crear

1. **Diagrama de clases (modelos)** (PlantUML Class)
 ```plantuml
 class User {
 +username: str
 +password: str
 +objects: UserManager
 }
 class Permission
 class Role
 class Segment
 class InMemoryManager

 User --> InMemoryManager
 Role --> Permission : many-to-many
 Segment --> Permission : many-to-many
 ```
 - **Complejidad**: Alta
 - **Tiempo**: 2h

2. **Diagrama de precedencia de permisos** (PlantUML Activity)
 ```plantuml
 start
 :Check direct permissions;
 if (has direct?) then (yes)
 :return true;
 stop
 endif
 :Check role permissions;
 if (has role?) then (yes)
 :return true;
 stop
 endif
 :Check segment permissions;
 if (has segment?) then (yes)
 :return true;
 endif
 :return false;
 stop
 ```
 - **Complejidad**: Media
 - **Tiempo**: 1.5h

3. **Flujo de evaluación de permisos** (PlantUML Sequence)
 - **Elementos**: View, PermissionService, UserPermission, RoleAssignment, Segment
 - **Complejidad**: Alta
 - **Tiempo**: 2h

4. **Arquitectura in-memory** (PlantUML Component)
 - **Elementos**: Muestra cómo funciona InMemoryManager
 - **Tiempo**: 1h

**Total diagramas**: 4 | **Tiempo total**: 6.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de creación de usuario
- [ ] Ejemplo de asignación de permisos directos
- [ ] Ejemplo de asignación de rol
- [ ] Ejemplo de evaluación de permisos

---

### FASE 3: Apps de Integración (Semana 5)

---

#### 8. IVR Legacy

**Prioridad**: BAJA | **Complejidad**: Media | **Estimación**: 1 día

##### Información General
- **Propósito**: Integración read-only con BD legacy
- **Patrón arquitectónico**: Adapter Pattern
- **Plantilla**: `plantilla_django_app.md`
- **Líneas estimadas**: 900

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos (managed=False) | `models.py` | 2h |
| 3. Adapters | `adapters.py` | 3h |
| 4. Database router | `database_router.py` | 2h |
| 5. Configuración BD | settings | 1h |
| 6. Tests | `tests/` | 1h |
| 7. Diagramas | - | 4h |

**Total estimado**: 14 horas (~1.75 días)

##### Diagramas a Crear

1. **Diagrama de Adapter Pattern** (PlantUML Class)
 ```plantuml
 class IVRDataAdapter {
 +get_calls(start, end)
 +get_client(client_id)
 }
 class IVRCall {
 managed = False
 }
 class IVRClient {
 managed = False
 }
 IVRDataAdapter --> IVRCall
 IVRDataAdapter --> IVRClient
 ```
 - **Tiempo**: 1.5h

2. **Diagrama de integración con BD externa** (PlantUML Deployment)
 ```plantuml
 node "Django App" {
 [ETL]
 [IVRDataAdapter]
 }
 database "PostgreSQL" {
 [Analytics]
 }
 database "MariaDB Legacy" {
 [IVR Tables]
 }
 [ETL] --> [IVRDataAdapter]
 [IVRDataAdapter] --> [IVR Tables] : read-only
 [ETL] --> [Analytics] : write
 ```
 - **Tiempo**: 1.5h

3. **Flujo de lectura de datos** (PlantUML Sequence)
 - **Elementos**: ETL, IVRDataAdapter, IVRCall, MariaDB
 - **Tiempo**: 1.5h

4. **Protección read-only** (PlantUML Activity)
 - **Elementos**: Router que bloquea escrituras
 - **Tiempo**: 1h

**Total diagramas**: 4 | **Tiempo total**: 5.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de lectura de llamadas
- [ ] Ejemplo de configuración de BD read-only
- [ ] Ejemplo de router que previene escrituras

---

#### 9. Notifications

**Prioridad**: BAJA | **Complejidad**: Baja | **Estimación**: 1 día

##### Información General
- **Propósito**: Mensajería interna del sistema
- **Patrón arquitectónico**: Active Record Pattern
- **Plantilla**: `plantilla_django_app.md` (simplificada)
- **Líneas estimadas**: 700

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos | `models.py` (InternalMessage) | 2h |
| 3. Vistas | `views.py` | 2h |
| 4. URLs | `urls.py` | 1h |
| 5. Tests | `tests/` | 1h |
| 6. Diagramas | - | 3h |

**Total estimado**: 10 horas (~1.25 días)

##### Diagramas a Crear

1. **Diagrama de clases** (PlantUML Class)
 ```plantuml
 class InternalMessage {
 +recipient: ForeignKey
 +sender: ForeignKey
 +subject: CharField
 +message_type: CharField
 +priority: CharField
 +is_read: BooleanField
 +mark_as_read()
 }
 ```
 - **Tiempo**: 1h

2. **Diagrama ER** (PlantUML ER)
 - **Elementos**: 1 tabla con 2 FK a User
 - **Tiempo**: 0.5h

3. **Flujo de envío/lectura** (PlantUML Sequence)
 - **Elementos**: Sender, System, InternalMessage, Recipient
 - **Tiempo**: 1h

**Total diagramas**: 3 | **Tiempo total**: 2.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de envío de mensaje
- [ ] Ejemplo de marcar como leído
- [ ] Ejemplo de consulta de mensajes no leídos

---

#### 10. Common

**Prioridad**: BAJA | **Complejidad**: Baja | **Estimación**: 1 día

##### Información General
- **Propósito**: Utilidades compartidas (abstract models)
- **Patrón arquitectónico**: Utilidades
- **Plantilla**: `plantilla_django_app.md` (simplificada)
- **Líneas estimadas**: 600

##### Secciones a Documentar

| Sección | Archivos a analizar | Estimación |
|---------|---------------------|------------|
| 1. Información general | `apps.py` | 1h |
| 2. Modelos abstractos | `models.py` | 3h |
| 3. Guía de uso | ejemplos | 2h |
| 4. Tests | `tests/` | 1h |
| 5. Diagramas | - | 3h |

**Total estimado**: 10 horas (~1.25 días)

##### Diagramas a Crear

1. **Diagrama de herencia** (PlantUML Class)
 ```plantuml
 abstract class TimeStampedModel {
 +created_at: DateTimeField
 +updated_at: DateTimeField
 }
 abstract class SoftDeleteModel {
 +is_deleted: BooleanField
 +soft_delete()
 }
 abstract class BaseModel

 BaseModel <|-- TimeStampedModel
 BaseModel <|-- SoftDeleteModel

 ' Ejemplos de uso
 TimeStampedModel <|-- CallAnalytics
 SoftDeleteModel <|-- Report
 ```
 - **Tiempo**: 1.5h

2. **Ejemplos de uso en otras apps** (PlantUML Component)
 - **Elementos**: Muestra herencia en analytics, reports, etc.
 - **Tiempo**: 1h

**Total diagramas**: 2 | **Tiempo total**: 2.5 horas

##### Ejemplos de Código a Incluir

- [ ] Ejemplo de uso de TimeStampedModel
- [ ] Ejemplo de uso de SoftDeleteModel
- [ ] Ejemplo de herencia múltiple

---

## Plantillas y Diagramas

### Resumen de Plantillas

| Plantilla | Apps que la usan | Total usos |
|-----------|------------------|------------|
| `plantilla_django_app.md` | analytics, audit, authentication, common, dashboard, ivr_legacy, notifications, reports, users | 9 |
| `plantilla_etl_job.md` | etl | 1 |

### Resumen de Diagramas por Tipo

| Tipo de Diagrama | Cantidad | Apps | Tiempo total |
|------------------|----------|------|--------------|
| **Class Diagram** | ~12 | Todas excepto common | 15h |
| **ER Diagram** | ~8 | analytics, audit, authentication, ivr_legacy, notifications, reports | 7h |
| **Sequence Diagram** | ~10 | Todas | 16h |
| **Component Diagram** | ~8 | Todas | 9h |
| **Activity Diagram** | ~4 | etl, users, ivr_legacy | 5h |
| **Deployment Diagram** | ~1 | ivr_legacy | 1.5h |
| **TOTAL** | **~43** | **10 apps** | **53.5h** |

### Desglose de Diagramas por App

| App | Class | ER | Sequence | Component | Activity | Other | Total |
|-----|-------|----|----|-----------|----------|-------|-------|
| etl | 1 | - | 1 | 1 | 2 | - | 5 |
| analytics | 1 | 1 | 1 | 1 | - | - | 4 |
| reports | 2 | 1 | 1 | 1 | - | - | 5 |
| audit | 1 | 1 | 1 | 1 | - | - | 4 |
| dashboard | 2 | - | 1 | 1 | - | - | 4 |
| authentication | 1 | 1 | 2 | - | - | - | 4 |
| users | 1 | - | 1 | 1 | 1 | - | 4 |
| ivr_legacy | 1 | - | 1 | 1 | 1 | 1 (deploy) | 5 |
| notifications | 1 | 1 | 1 | - | - | - | 3 |
| common | 1 | - | - | 1 | - | - | 2 |
| **TOTAL** | **12** | **5** | **10** | **8** | **4** | **1** | **40** |

---

## Timeline y Fases

### Calendario Detallado

| Semana | Días | Apps | Documentos | Diagramas | Horas |
|--------|------|------|------------|-----------|-------|
| **Semana 1** | 1-2 | etl | 1 | 5 | 25h |
| | 3 | analytics | 1 | 4 | 14h |
| | 4-5 | reports | 1 | 5 | 27h |
| **Semana 2** | 1-2 | audit | 1 | 4 | 16h |
| | 3-4 | dashboard | 1 | 4 | 26h |
| **Semana 3** | 1-2 | authentication | 1 | 4 | 20h |
| | 3-5 | users | 1 | 4 | 27h |
| **Semana 4** | 1-2 | ivr_legacy | 1 | 5 | 19h |
| | 3 | notifications | 1 | 3 | 12h |
| | 4 | common | 1 | 2 | 12h |
| **Semana 5** | 1-2 | Consolidación | 3 guías | - | 16h |
| | 3-5 | Revisión y ajustes | - | - | 24h |

**Total**: 238 horas (~30 días laborales = 6 semanas)

### Hitos

| Hito | Fecha objetivo | Entregables | Criterio de éxito |
|------|----------------|-------------|-------------------|
| **Hito 1**: Fase 1 completada | Fin Semana 2 | etl, analytics, reports documentados | 3 docs + 14 diagramas |
| **Hito 2**: Fase 2 completada | Fin Semana 4 | audit, dashboard, authentication, users | 4 docs + 16 diagramas |
| **Hito 3**: Fase 3 completada | Fin Semana 4 | ivr_legacy, notifications, common | 3 docs + 10 diagramas |
| **Hito 4**: Consolidación | Semana 5 | Guías consolidadas | 3 guías completas |
| **Hito 5**: Cierre | Fin Semana 5 | PR aprobado | Merge a main |

---

## Recursos Necesarios

### Equipo

| Rol | Asignación | Responsabilidades |
|-----|------------|-------------------|
| **Documentador técnico** | 1 persona full-time | Escribir documentación, crear diagramas |
| **Revisor técnico** | 1 persona part-time | Revisar precisión técnica |
| **Arquitecto** | Consultas según necesidad | Validar patrones y decisiones |
| **Desarrollador original** | Consultas según necesidad | Aclarar dudas de implementación |

### Herramientas

| Herramienta | Propósito | Estado |
|-------------|-----------|--------|
| **MkDocs** | Generar sitio estático | Instalado |
| **PlantUML** | Crear diagramas | Disponible vía Kroki |
| **Kroki plugin** | Renderizar PlantUML en MkDocs | Configurado |
| **VS Code** | Editor de markdown | Disponible |
| **Git** | Control de versiones | Configurado |
| **GitHub** | Repositorio y PRs | Acceso |

### Acceso Requerido

- Código fuente en `api/callcentersite/`
- Tests en `api/callcentersite/tests/`
- Settings en `api/callcentersite/callcentersite/settings/`
- Base de datos de desarrollo (para validar queries)
- Logs de aplicación (para troubleshooting)
- Acceso a desarrolladores originales (para consultas)

---

## Métricas y KPIs

### Métricas de Progreso

| Métrica | Objetivo | Tracking |
|---------|----------|----------|
| **Apps documentadas** | 10 | Por completar en SC03 checklist |
| **Documentos creados** | 10 | Uno por app |
| **Diagramas creados** | 40 | ~4 por app |
| **Líneas de documentación** | 12,000 | ~1,200 por app |
| **Tiempo invertido** | 238h | Timesheet semanal |

### Métricas de Calidad

| Métrica | Objetivo | Método de verificación |
|---------|----------|------------------------|
| **Broken links** | 0 | MkDocs build |
| **Diagramas rotos** | 0 | Renderizado en navegador |
| **Cobertura de secciones** | 100% | Checklist de plantilla |
| **Ejemplos de código** | Min 3 por app | Revisión manual |
| **Claridad** | >80% comprensión | Feedback de equipo |

### Métricas de Impacto

| Métrica | Objetivo | Medición |
|---------|----------|----------|
| **Tiempo de onboarding** | <2h por app | Encuesta a nuevo dev |
| **Tiempo de troubleshooting** | -50% vs. actual | Tickets resueltos |
| **Consultas al equipo** | -40% vs. actual | Contador de consultas |
| **Satisfacción del equipo** | >4/5 | Encuesta post-entrega |

---

## Plan de Ejecución

### Semana 1: Apps Críticas (Parte 1)

#### Días 1-2: ETL
- [ ] **Día 1 AM**: Análisis de código (extractors, transformers, loaders)
- [ ] **Día 1 PM**: Documentar secciones 1-4 (Información, Extract, Transform, Load)
- [ ] **Día 2 AM**: Documentar secciones 5-8 (Dependencias, Monitoreo, Recuperación, Testing)
- [ ] **Día 2 PM**: Crear 5 diagramas PlantUML

#### Día 3: Analytics
- [ ] **AM**: Análisis de modelos (CallAnalytics, DailyMetrics)
- [ ] **PM**: Documentar todas las secciones + crear 4 diagramas

#### Días 4-5: Reports
- [ ] **Día 4 AM**: Análisis de modelos y generadores
- [ ] **Día 4 PM**: Documentar modelos y Strategy Pattern
- [ ] **Día 5 AM**: Documentar vistas y URLs
- [ ] **Día 5 PM**: Crear 5 diagramas

### Semana 2: Apps Críticas (Parte 2) + Soporte

#### Días 1-2: Audit
- [ ] **Día 1 AM**: Análisis de AuditLog y AuditService
- [ ] **Día 1 PM**: Documentar modelos y servicios
- [ ] **Día 2 AM**: Documentar integración con otras apps
- [ ] **Día 2 PM**: Crear 4 diagramas

#### Días 3-4: Dashboard
- [ ] **Día 3 AM**: Análisis de DashboardService y widgets
- [ ] **Día 3 PM**: Documentar servicios y Registry Pattern
- [ ] **Día 4 AM**: Documentar vistas REST y URLs
- [ ] **Día 4 PM**: Crear 4 diagramas

#### Día 5: Buffer / Revisión
- [ ] Revisar documentos de Semana 1-2
- [ ] Ajustes y correcciones
- [ ] Revisión con equipo

### Semana 3: Apps de Soporte (Continuación)

#### Días 1-2: Authentication
- [ ] **Día 1 AM**: Análisis de modelos de seguridad
- [ ] **Día 1 PM**: Documentar SecurityQuestion y LoginAttempt
- [ ] **Día 2 AM**: Documentar LoginAttemptService y vistas
- [ ] **Día 2 PM**: Crear 4 diagramas

#### Días 3-5: Users
- [ ] **Día 3 AM**: Análisis de arquitectura in-memory
- [ ] **Día 3 PM**: Documentar modelos (dataclasses)
- [ ] **Día 4 AM**: Documentar InMemoryManager
- [ ] **Día 4 PM**: Documentar PermissionService
- [ ] **Día 5**: Crear 4 diagramas complejos

### Semana 4: Apps de Integración

#### Días 1-2: IVR Legacy
- [ ] **Día 1 AM**: Análisis de modelos read-only
- [ ] **Día 1 PM**: Documentar IVRDataAdapter
- [ ] **Día 2 AM**: Documentar database router
- [ ] **Día 2 PM**: Crear 5 diagramas

#### Día 3: Notifications
- [ ] **AM**: Análisis y documentación de InternalMessage
- [ ] **PM**: Crear 3 diagramas

#### Día 4: Common
- [ ] **AM**: Análisis y documentación de modelos abstractos
- [ ] **PM**: Crear 2 diagramas + ejemplos de uso

#### Día 5: Buffer / Revisión
- [ ] Revisar todos los documentos
- [ ] Verificar broken links
- [ ] Verificar diagramas

### Semana 5: Consolidación y Cierre

#### Días 1-2: Guías Consolidadas

##### Día 1: Guía de APIs REST
- [ ] **AM**: Recopilar endpoints de todas las apps
- [ ] **PM**: Documentar autenticación JWT
- [ ] Crear ejemplos con curl
- [ ] Documentar códigos de error

##### Día 2: Mapa de Dependencias + Troubleshooting
- [ ] **AM**: Crear diagrama de dependencias global
- [ ] **PM**: Consolidar troubleshooting de todas las apps

#### Días 3-5: Revisión Final y Cierre

##### Día 3: Control de Calidad
- [ ] Verificar 10 documentos completos
- [ ] Verificar 40 diagramas renderizan
- [ ] Ejecutar `mkdocs build` sin errores
- [ ] Spell check

##### Día 4: Revisión con Equipo
- [ ] Presentar documentación al equipo Backend
- [ ] Presentar a Arquitectura
- [ ] Incorporar feedback

##### Día 5: Cierre
- [ ] Crear Pull Request
- [ ] Obtener aprobaciones
- [ ] Merge a main
- [ ] Actualizar estado de SC03 a "completado"
- [ ] Comunicar al equipo

---

## Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Código sin documentar** | Media | Alto | Consultar a desarrolladores originales |
| **Lógica compleja sin tests** | Media | Medio | Experimentar en entorno de desarrollo |
| **Timeline muy optimista** | Alta | Medio | Buffer del 20% en cada fase |
| **Cambios en código durante documentación** | Baja | Alto | Freeze de features en apps siendo documentadas |
| **Diagramas muy grandes** | Media | Bajo | Dividir en sub-diagramas |
| **PlantUML no renderiza** | Baja | Medio | Usar alternativas (Mermaid, imágenes) |
| **Falta de acceso a desarrolladores** | Media | Alto | Documentar según análisis de código + marcar dudas |

---

## Dependencias y Bloqueadores

### Dependencias Internas

- SC02 completado (patrones, plantillas)
- MkDocs configurado
- Kroki plugin funcionando
- Plantillas creadas

### Dependencias Externas

- Acceso a desarrolladores originales (para consultas)
- Tiempo del arquitecto (para revisiones)
- Tiempo del revisor técnico
- Ambiente de desarrollo funcional

### Bloqueadores Potenciales

- Código en refactorización activa
- Cambios mayores en arquitectura
- Prioridades del equipo cambian
- Recursos reasignados

---

## Criterios de Aceptación

### Por App

- Documento completo siguiendo plantilla
- Todas las secciones documentadas
- Mínimo 3 ejemplos de código
- Todos los diagramas creados y renderizando
- Sección de troubleshooting completa
- Referencias cruzadas funcionando
- En navegación de MkDocs

### Global

- 10 apps documentadas
- 40 diagramas funcionando
- Guía de APIs REST creada
- Mapa de dependencias creado
- Troubleshooting general creado
- Índices actualizados
- `mkdocs build` exitoso (0 errores)
- Revisión por equipo completada
- PR aprobado y mergeado

---

## Próximos Pasos

1. **Revisar y aprobar esta planificación**
2. **Asignar recursos** (documentador, revisor)
3. **Configurar ambiente de trabajo** (accesos, herramientas)
4. **Kick-off meeting** con equipo
5. **Comenzar Semana 1: ETL**

---

## Referencias

- [SC03 - Solicitud](../solicitudes/sc03/README.md)
- [SC03 - Alcance](../solicitudes/sc03/alcance.md)
- [SC03 - Checklist](../solicitudes/sc03/checklist.md)
- [Patrones Arquitectónicos](arquitectura/patrones_arquitectonicos.md)
- [Guía de Decisión de Patrones](arquitectura/guia_decision_patrones.md)
- [Plantilla Django App](../plantillas/plantilla_django_app.md)
- [Plantilla ETL Job](../plantillas/plantilla_etl_job.md)

---

**Última actualización**: 2025-11-04
**Versión**: 1.0
**Estado**: Aprobado para ejecución
