---
title: Arquitectura del Sistema de Permisos - Diagramas UML
date: 2025-11-13
domain: backend
status: active
---

# Arquitectura del Sistema de Permisos - Diagramas UML

**Fecha:** 2025-11-11
**Propósito:** Documentar la arquitectura actual y propuesta del sistema de permisos con diagramas UML
**Referencia:** ADR_2025_017-sistema-permisos-sin-roles-jerarquicos.md

---

## 1. Arquitectura ACTUAL (Decorator-based)

### 1.1 Diagrama de Clases - Arquitectura Actual

```mermaid
classDiagram
 class PermisoService {
 <<Service>>
 +usuario_tiene_permiso(usuario_id: int, capacidad: str) bool$
 +obtener_capacidades_usuario(usuario_id: int) List~str~$
 +obtener_funciones_accesibles(usuario_id: int) QuerySet$
 +registrar_acceso(usuario_id: int, capacidad: str, accion: str, ...) AuditoriaPermiso$
 }

 class verificar_permiso {
 <<Decorator>>
 -capacidad_requerida: str | list
 -auditar: bool
 -mensaje_error: str
 +decorator(view_func) Callable
 +wrapper(request, *args, **kwargs) HttpResponse
 }

 class View {
 <<Django View>>
 +handle_request(request) HttpResponse
 }

 class HttpRequest {
 +user: User
 +path: str
 +method: str
 +META: dict
 }

 class HttpResponse {
 +status_code: int
 +content: str
 }

 verificar_permiso ..> PermisoService : usa
 verificar_permiso --> View : envuelve
 View --> HttpRequest : recibe
 View --> HttpResponse : retorna
 verificar_permiso --> HttpResponse : retorna 401/403

 note for verificar_permiso "Se aplica MANUALMENTE\nen cada view:\n@verificar_permiso('capacidad')"
```

### 1.2 Diagrama de Secuencia - Flujo Actual con Decorator

```mermaid
sequenceDiagram
 participant Client
 participant Django
 participant JWTMiddleware
 participant Decorator as @verificar_permiso
 participant PermisoService
 participant DB
 participant View

 Client->>Django: HTTP Request
 Django->>JWTMiddleware: process_request()
 JWTMiddleware->>DB: Validate JWT & Load User
 DB-->>JWTMiddleware: User Object
 JWTMiddleware->>Django: Continue

 Django->>Decorator: Call decorated view

 alt Usuario no autenticado
 Decorator-->>Client: 401 Unauthorized
 else Usuario autenticado
 Decorator->>PermisoService: usuario_tiene_permiso(user_id, capacidad)
 PermisoService->>DB: Query 1: Get Capacidad
 DB-->>PermisoService: Capacidad obj
 PermisoService->>DB: Query 2: PermisoExcepcional
 DB-->>PermisoService: Excepcionales
 PermisoService->>DB: Query 3: GrupoCapacidad (JOIN)
 DB-->>PermisoService: tiene_capacidad
 PermisoService-->>Decorator: bool (tiene/no tiene)

 alt Sin permiso
 Decorator->>PermisoService: registrar_acceso(DENEGADO) [si auditar=True]
 PermisoService->>DB: INSERT auditoria
 Decorator-->>Client: 403 Forbidden
 else Con permiso
 Decorator->>PermisoService: registrar_acceso(PERMITIDO) [si auditar=True]
 PermisoService->>DB: INSERT auditoria
 Decorator->>View: Execute view
 View->>DB: Business logic
 View-->>Decorator: HttpResponse
 Decorator-->>Client: 200 OK + Data
 end
 end
```

### 1.3 Diagrama de Componentes - Vista de Deployment Actual

```mermaid
graph TB
 subgraph "Django Application"
 subgraph "apps/permissions"
 Service[PermisoService<br/>services.py]
 Decorator[verificar_permiso<br/>middleware.py]
 Models[Models<br/>Capacidad, GrupoCapacidad,<br/>PermisoExcepcional, etc.]
 end

 subgraph "apps/llamadas"
 ViewLlamadas[@verificar_permiso<br/>LlamadaViewSet]
 end

 subgraph "apps/reportes"
 ViewReportes[IsAuthenticated<br/>ReporteViewSet]
 end

 subgraph "apps/notifications"
 ViewNotif[IsAuthenticated<br/>NotificationViewSet]
 end

 subgraph "apps/etl"
 ViewETL[IsAuthenticated<br/>ETLViewSet]
 end

 ViewLlamadas -->|usa| Decorator
 ViewReportes -.->|NO usa permisos<br/>granulares| Service
 ViewNotif -.->|NO usa permisos<br/>granulares| Service
 ViewETL -.->|NO usa permisos<br/>granulares| Service

 Decorator -->|llama| Service
 Service -->|consulta| Models
 end

 subgraph "Database"
 DB[(PostgreSQL<br/>Analytics)]
 end

 Models -->|ORM| DB

 style ViewReportes fill:#ffcccc
 style ViewNotif fill:#ffcccc
 style ViewETL fill:#ffcccc
 style ViewLlamadas fill:#ccffcc
```

**Leyenda:**
- [COMPLETADO] Verde: Usa permisos granulares correctamente
- [CRITICO] Rojo: Solo usa `IsAuthenticated`, NO permisos granulares

---

## 2. Problemas de la Arquitectura Actual

### 2.1 Problema 1: Aplicación Manual del Decorator

```python
# [NO] PROBLEMA: Desarrollador debe recordar aplicar decorator
class ReporteViewSet(viewsets.ModelViewSet):
 permission_classes = [IsAuthenticated] # Solo autenticación básica

 def list(self, request):
 # CUALQUIER usuario autenticado puede listar reportes
 return Response(...)
```

**Consecuencias:**
- [CRITICO] Inconsistente: 3 módulos (Reportes, Notificaciones, ETL) NO usan permisos granulares
- [CRITICO] Error humano: Fácil olvidar aplicar el decorator
- [CRITICO] Sin centralización: Cada view decide si verificar permisos

### 2.2 Problema 2: No es un Middleware Django Real

**Middleware Django** se ejecuta en el pipeline automáticamente:

```python
# settings.py
MIDDLEWARE = [
 'django.middleware.security.SecurityMiddleware',
 'django.middleware.common.CommonMiddleware',
 'django.middleware.csrf.CsrfViewMiddleware',
 'django.contrib.auth.middleware.AuthenticationMiddleware',
 # [NO] FALTA: PermisoMiddleware (no existe)
]
```

**El decorator NO está en MIDDLEWARE**, por lo que:
- [ATENCION] No se ejecuta automáticamente
- [ATENCION] No tiene acceso al pipeline de Django
- [ATENCION] No puede interceptar requests antes de routing

### 2.3 Problema 3: Verificación Repetida por View

```mermaid
graph LR
 A[Request] --> B{ViewLlamadas}
 A --> C{ViewReportes}
 A --> D{ViewNotificaciones}

 B --> E[@verificar_permiso<br/>verifica cada request]
 C -.-> F[IsAuthenticated<br/>NO verifica permisos]
 D -.-> G[IsAuthenticated<br/>NO verifica permisos]

 E --> H[PermisoService<br/>3 queries]

 style F fill:#ffcccc
 style G fill:#ffcccc
```

**Problema:** Cada view decorada hace 3 queries independientes. No hay caché ni optimización centralizada.

---

## 3. Arquitectura PROPUESTA (Middleware-based)

### 3.1 Diagrama de Clases - Nueva Arquitectura

```mermaid
classDiagram
 class PermisoMiddleware {
 <<Django Middleware>>
 -permission_cache: dict
 +__init__(get_response)
 +__call__(request) HttpResponse
 +process_view(request, view_func, view_args, view_kwargs) HttpResponse|None
 -_verificar_permisos(request, capacidades) bool
 -_get_required_permissions(view_func) List~str~
 }

 class PermisoService {
 <<Service>>
 +usuario_tiene_permiso(usuario_id: int, capacidad: str) bool$
 +usuario_tiene_permisos(usuario_id: int, capacidades: List~str~) dict$
 +obtener_capacidades_usuario(usuario_id: int) List~str~$
 +registrar_acceso(...) AuditoriaPermiso$
 }

 class PermisoMixin {
 <<Mixin>>
 +required_permissions: List~str~
 +permission_auditable: bool
 +get_required_permissions() List~str~
 }

 class BaseViewSet {
 <<DRF ViewSet>>
 +permission_classes: List
 +get_permissions() List
 }

 class LlamadaViewSet {
 +required_permissions: ['sistema.operaciones.llamadas.realizar']
 }

 class ReporteViewSet {
 +required_permissions: ['sistema.reportes.ivr.ver']
 }

 PermisoMiddleware ..> PermisoService : usa
 PermisoMiddleware --> PermisoMixin : verifica
 BaseViewSet <|-- PermisoMixin : hereda
 PermisoMixin <|-- LlamadaViewSet : implementa
 PermisoMixin <|-- ReporteViewSet : implementa

 note for PermisoMiddleware "Se ejecuta AUTOMÁTICAMENTE\nen TODAS las requests"
 note for PermisoMixin "Views declaran permisos\ncomo atributo de clase"
```

### 3.2 Diagrama de Secuencia - Flujo Propuesto con Middleware

```mermaid
sequenceDiagram
 participant Client
 participant SecurityMiddleware
 participant JWTMiddleware
 participant PermisoMiddleware
 participant PermisoService
 participant DB
 participant View

 Client->>SecurityMiddleware: HTTP Request
 SecurityMiddleware->>JWTMiddleware: Continue
 JWTMiddleware->>DB: Validate JWT & Load User
 DB-->>JWTMiddleware: User Object

 JWTMiddleware->>PermisoMiddleware: Continue

 Note over PermisoMiddleware: process_view() se ejecuta<br/>ANTES de llamar a la view

 PermisoMiddleware->>PermisoMiddleware: _get_required_permissions(view)

 alt No requiere permisos
 PermisoMiddleware->>View: Continue (sin verificar)
 View-->>Client: Response
 else Requiere permisos
 alt Usuario no autenticado
 PermisoMiddleware-->>Client: 401 Unauthorized
 else Usuario autenticado
 PermisoMiddleware->>PermisoService: usuario_tiene_permisos(user_id, [caps])
 PermisoService->>DB: Batch query (optimizado)
 DB-->>PermisoService: {cap1: True, cap2: False, ...}
 PermisoService-->>PermisoMiddleware: Resultado batch

 alt Sin algún permiso
 PermisoMiddleware->>PermisoService: registrar_acceso(DENEGADO)
 PermisoService->>DB: INSERT auditoria
 PermisoMiddleware-->>Client: 403 Forbidden
 else Con todos los permisos
 PermisoMiddleware->>View: Continue
 View->>DB: Business logic
 View-->>PermisoMiddleware: HttpResponse
 PermisoMiddleware->>PermisoService: registrar_acceso(PERMITIDO)
 PermisoService->>DB: INSERT auditoria
 PermisoMiddleware-->>Client: 200 OK + Data
 end
 end
 end
```

### 3.3 Diagrama de Componentes - Nueva Arquitectura

```mermaid
graph TB
 subgraph "Django Middleware Pipeline"
 direction TB
 M1[SecurityMiddleware]
 M2[CommonMiddleware]
 M3[CSRFMiddleware]
 M4[AuthenticationMiddleware]
 M5[PermisoMiddleware<br/>NUEVO]

 M1 --> M2 --> M3 --> M4 --> M5
 end

 subgraph "apps/permissions"
 Service[PermisoService]
 Mixin[PermisoMixin]
 Models[Models]
 end

 subgraph "ViewSets con PermisoMixin"
 V1[LlamadaViewSet<br/>required_permissions]
 V2[ReporteViewSet<br/>required_permissions]
 V3[NotificationViewSet<br/>required_permissions]
 V4[ETLViewSet<br/>required_permissions]
 end

 M5 -->|verifica| Mixin
 M5 -->|llama| Service
 Service -->|consulta| Models

 V1 -.->|hereda| Mixin
 V2 -.->|hereda| Mixin
 V3 -.->|hereda| Mixin
 V4 -.->|hereda| Mixin

 M5 --> V1
 M5 --> V2
 M5 --> V3
 M5 --> V4

 Models -->|ORM| DB[(Database)]

 style M5 fill:#ccffcc
 style V1 fill:#ccffcc
 style V2 fill:#ccffcc
 style V3 fill:#ccffcc
 style V4 fill:#ccffcc
```

---

## 4. Comparación Arquitecturas: Decorator vs Middleware

### 4.1 Tabla Comparativa

| Aspecto | Decorator Actual | Middleware Propuesto |
|---------|------------------|----------------------|
| **Aplicación** | Manual (`@verificar_permiso`) | Automática (pipeline Django) |
| **Cobertura** | Solo views decoradas | TODAS las views con `PermisoMixin` |
| **Consistencia** | [CRITICO] Inconsistente (3 módulos sin permisos) | [COMPLETADO] Consistente (automático) |
| **Centralización** | [NO] Cada view independiente | [OK] Centralizado en middleware |
| **Caché** | [NO] No tiene caché | [OK] Puede implementar caché de request |
| **Queries** | 3 queries por verificación | 3 queries batch (optimizado) |
| **Error humano** | [CRITICO] Alto (fácil olvidar decorator) | [COMPLETADO] Bajo (automático) |
| **Auditoría** | Manual (`auditar=True`) | Automática (configurable por view) |
| **Testing** | Decorar cada test | Middleware se prueba una vez |
| **Orden ejecución** | Después de routing | Antes de routing |

### 4.2 Diagrama de Actividad - Comparación de Flujos

```mermaid
graph TB
 subgraph "ACTUAL: Decorator"
 A1[Request] --> A2{Routing}
 A2 --> A3[View decorada]
 A3 --> A4{@verificar_permiso}
 A4 -->|Sin permiso| A5[403 Forbidden]
 A4 -->|Con permiso| A6[Execute View]
 A6 --> A7[Response]

 A2 -.-> A8[View SIN decorator]
 A8 -.-> A9[Execute sin verificar]
 A9 -.-> A10[Response]

 style A8 fill:#ffcccc
 style A9 fill:#ffcccc
 style A10 fill:#ffcccc
 end

 subgraph "PROPUESTO: Middleware"
 B1[Request] --> B2[PermisoMiddleware]
 B2 --> B3{Routing}
 B3 --> B4{Tiene PermisoMixin?}
 B4 -->|NO| B5[Execute View<br/>sin verificar]
 B4 -->|SÍ| B6{Verificar permisos}
 B6 -->|Sin permiso| B7[403 Forbidden]
 B6 -->|Con permiso| B8[Execute View]
 B5 --> B9[Response]
 B8 --> B9

 style B2 fill:#ccffcc
 style B6 fill:#ccffcc
 end
```

---

## 5. Implementación Propuesta

### 5.1 Código del Middleware Django

```python
# apps/permissions/middleware.py

from typing import Callable, List, Optional
from django.http import HttpRequest, HttpResponse, JsonResponse
from django.utils.functional import SimpleLazyObject

from .services import PermisoService

class PermisoMiddleware:
 """
 Middleware Django para verificación automática de permisos.

 Se ejecuta en el pipeline de Django ANTES de llamar a las views.
 Verifica permisos si la view implementa PermisoMixin.
 """

 def __init__(self, get_response: Callable):
 self.get_response = get_response

 def __call__(self, request: HttpRequest) -> HttpResponse:
 """
 Ejecuta el middleware.

 process_view() se llama automáticamente por Django.
 """
 return self.get_response(request)

 def process_view(
 self,
 request: HttpRequest,
 view_func: Callable,
 view_args: tuple,
 view_kwargs: dict
 ) -> Optional[HttpResponse]:
 """
 Se ejecuta ANTES de llamar a la view.

 Retorna:
 - None: Continuar al siguiente middleware/view
 - HttpResponse: Cortocircuito (401/403)
 """
 # 1. Obtener permisos requeridos
 required_permissions = self._get_required_permissions(view_func, view_kwargs)

 # 2. Si no requiere permisos, continuar
 if not required_permissions:
 return None

 # 3. Verificar autenticación
 if not request.user.is_authenticated:
 return JsonResponse({
 "error": "Autenticación requerida",
 "detalle": "Debe autenticarse para acceder a este recurso"
 }, status=401)

 # 4. Verificar permisos
 usuario_id = request.user.id
 tiene_permisos, permisos_faltantes = self._verificar_permisos(
 usuario_id,
 required_permissions
 )

 # 5. Denegar si falta algún permiso
 if not tiene_permisos:
 # Auditar acceso denegado
 if self._is_auditable(view_func, view_kwargs):
 PermisoService.registrar_acceso(
 usuario_id=usuario_id,
 capacidad=", ".join(permisos_faltantes),
 accion="ACCESO_DENEGADO",
 ip_address=self._get_client_ip(request),
 user_agent=request.META.get("HTTP_USER_AGENT"),
 metadata={
 "path": request.path,
 "method": request.method,
 "permisos_faltantes": permisos_faltantes
 }
 )

 return JsonResponse({
 "error": f"Permiso denegado. Requiere: {', '.join(permisos_faltantes)}",
 "capacidades_requeridas": permisos_faltantes
 }, status=403)

 # 6. Auditar acceso permitido
 if self._is_auditable(view_func, view_kwargs):
 PermisoService.registrar_acceso(
 usuario_id=usuario_id,
 capacidad=", ".join(required_permissions),
 accion="ACCESO_PERMITIDO",
 ip_address=self._get_client_ip(request),
 user_agent=request.META.get("HTTP_USER_AGENT"),
 metadata={
 "path": request.path,
 "method": request.method
 }
 )

 # 7. Continuar a la view
 return None

 def _get_required_permissions(
 self,
 view_func: Callable,
 view_kwargs: dict
 ) -> List[str]:
 """
 Extrae permisos requeridos de la view.

 Busca atributo `required_permissions` en:
 - ViewSet (si es DRF)
 - View function (si es FBV)
 """
 # Caso 1: DRF ViewSet
 if hasattr(view_func, 'cls'):
 view_class = view_func.cls
 if hasattr(view_class, 'required_permissions'):
 permisos = view_class.required_permissions
 return permisos if isinstance(permisos, list) else [permisos]

 # Caso 2: Function-based view
 if hasattr(view_func, 'required_permissions'):
 permisos = view_func.required_permissions
 return permisos if isinstance(permisos, list) else [permisos]

 return []

 def _verificar_permisos(
 self,
 usuario_id: int,
 capacidades: List[str]
 ) -> tuple[bool, List[str]]:
 """
 Verifica si usuario tiene TODAS las capacidades.

 Returns:
 (tiene_todos, lista_faltantes)
 """
 permisos_faltantes = []

 for capacidad in capacidades:
 if not PermisoService.usuario_tiene_permiso(usuario_id, capacidad):
 permisos_faltantes.append(capacidad)

 tiene_todos = len(permisos_faltantes) == 0
 return tiene_todos, permisos_faltantes

 def _is_auditable(self, view_func: Callable, view_kwargs: dict) -> bool:
 """Verifica si la view requiere auditoría."""
 if hasattr(view_func, 'cls'):
 return getattr(view_func.cls, 'permission_auditable', False)
 return getattr(view_func, 'permission_auditable', False)

 def _get_client_ip(self, request: HttpRequest) -> Optional[str]:
 """Extrae IP del cliente."""
 x_forwarded_for = request.META.get("HTTP_X_FORWARDED_FOR")
 if x_forwarded_for:
 return x_forwarded_for.split(",")[0].strip()
 return request.META.get("REMOTE_ADDR")
```

### 5.2 Mixin para ViewSets

```python
# apps/permissions/mixins.py

from typing import List

class PermisoMixin:
 """
 Mixin para ViewSets que requieren permisos granulares.

 Uso:
 class LlamadaViewSet(PermisoMixin, viewsets.ModelViewSet):
 required_permissions = [
 'sistema.operaciones.llamadas.realizar'
 ]
 permission_auditable = True
 """

 # Capacidades requeridas (sobreescribir en subclase)
 required_permissions: List[str] = []

 # Si True, auditará accesos
 permission_auditable: bool = False

 def get_required_permissions(self) -> List[str]:
 """Hook para permisos dinámicos basados en acción."""
 return self.required_permissions
```

### 5.3 Ejemplo de Uso en ViewSet

```python
# apps/llamadas/views.py

from rest_framework import viewsets
from apps.permissions.mixins import PermisoMixin

class LlamadaViewSet(PermisoMixin, viewsets.ModelViewSet):
 """
 ViewSet con permisos granulares verificados AUTOMÁTICAMENTE.
 """
 required_permissions = [
 'sistema.operaciones.llamadas.realizar'
 ]
 permission_auditable = True

 queryset = Llamada.objects.all()
 serializer_class = LlamadaSerializer

 # NO necesita @verificar_permiso decorator
 # El middleware lo verifica automáticamente
```

### 5.4 Configuración en settings.py

```python
# callcentersite/settings/base.py

MIDDLEWARE = [
 'django.middleware.security.SecurityMiddleware',
 'django.contrib.sessions.middleware.SessionMiddleware',
 'django.middleware.common.CommonMiddleware',
 'django.middleware.csrf.CsrfViewMiddleware',
 'django.contrib.auth.middleware.AuthenticationMiddleware',

 # [OK] AGREGAR: Middleware de permisos
 'callcentersite.apps.permissions.middleware.PermisoMiddleware',

 'django.contrib.messages.middleware.MessageMiddleware',
 'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

---

## 6. Diagrama de Deployment

### 6.1 Vista de Deployment con Ambas Arquitecturas

```mermaid
graph TB
 subgraph "Client Layer"
 C1[Browser/Mobile App]
 end

 subgraph "Django Application Server"
 subgraph "Middleware Pipeline"
 MW1[Security]
 MW2[CSRF]
 MW3[Authentication<br/>JWT]
 MW4[PermisoMiddleware<br/>NUEVO]
 end

 subgraph "View Layer"
 V1[LlamadaViewSet<br/>PermisoMixin]
 V2[ReporteViewSet<br/>PermisoMixin]
 V3[NotificationViewSet<br/>PermisoMixin]
 end

 subgraph "Service Layer"
 SVC[PermisoService]
 end

 subgraph "Model Layer"
 M1[Capacidad]
 M2[GrupoCapacidad]
 M3[PermisoExcepcional]
 M4[AuditoriaPermiso]
 end
 end

 subgraph "Database Layer"
 DB[(PostgreSQL<br/>Analytics)]
 end

 C1 -->|HTTP Request| MW1
 MW1 --> MW2 --> MW3 --> MW4

 MW4 -->|Verifica| V1
 MW4 -->|Verifica| V2
 MW4 -->|Verifica| V3

 MW4 -->|Llama| SVC
 V1 -->|Business Logic| M1
 V2 -->|Business Logic| M1
 V3 -->|Business Logic| M1

 SVC --> M1
 SVC --> M2
 SVC --> M3
 SVC --> M4

 M1 -->|ORM| DB
 M2 -->|ORM| DB
 M3 -->|ORM| DB
 M4 -->|ORM| DB
```

---

## 7. Ventajas y Desventajas

### 7.1 Ventajas del Middleware Django

| Ventaja | Descripción | Impacto |
|---------|-------------|---------|
| **Automático** | Se ejecuta en TODAS las requests sin intervención manual | [COMPLETADO] Alto |
| **Centralizado** | Lógica de permisos en UN solo lugar | [COMPLETADO] Alto |
| **Consistente** | Imposible olvidar verificar permisos (si usa PermisoMixin) | [COMPLETADO] Alto |
| **Caché request-scoped** | Puede cachear permisos durante la request | [COMPLETADO] Medio |
| **Auditoría** | Configurable por view, no requiere parametrizar decorator | [COMPLETADO] Medio |
| **Testing** | Probar middleware una vez vs decorar cada test | [COMPLETADO] Medio |
| **Pipeline Django** | Aprovecha orden de ejecución de middlewares | [COMPLETADO] Medio |

### 7.2 Desventajas del Middleware Django

| Desventaja | Descripción | Mitigación |
|------------|-------------|------------|
| **Complejidad inicial** | Más complejo que decorator simple | Documentación clara |
| **Refactoring** | Requiere cambiar views existentes | Migración gradual |
| **Debugging** | Middleware pipeline puede ser opaco | Logging detallado |
| **Overhead** | Se ejecuta en TODAS las requests | Solo verifica si tiene PermisoMixin |

---

## 8. Plan de Migración

### 8.1 Fases de Migración

```mermaid
gantt
 title Migración Decorator → Middleware
 dateFormat YYYY-MM-DD
 section Fase 1
 Implementar Middleware :2025-11-11, 2d
 Implementar PermisoMixin :2025-11-11, 1d
 Tests unitarios :2025-11-13, 2d
 section Fase 2
 Migrar módulo Llamadas :2025-11-15, 1d
 Validar tests :2025-11-16, 1d
 section Fase 3
 Migrar Reportes IVR :2025-11-17, 1d
 Migrar Notificaciones :2025-11-18, 1d
 Migrar ETL/Jobs :2025-11-19, 1d
 section Fase 4
 Validación integral :2025-11-20, 2d
 Performance testing :2025-11-22, 1d
 Deprecar decorator :2025-11-23, 1d
```

### 8.2 Pasos Detallados

1. **Fase 1: Implementación Base (3 días)**
 - [ ] Crear `PermisoMiddleware` en `middleware.py`
 - [ ] Crear `PermisoMixin` en `mixins.py`
 - [ ] Actualizar `settings.py` (agregar middleware)
 - [ ] Tests unitarios del middleware
 - [ ] Tests de integración

2. **Fase 2: Validación con Llamadas (2 días)**
 - [ ] Migrar `LlamadaViewSet` a usar `PermisoMixin`
 - [ ] Remover decorators `@verificar_permiso`
 - [ ] Ejecutar tests existentes (49 tests)
 - [ ] Validar que SIGUE funcionando

3. **Fase 3: Migración Módulos Restantes (3 días)**
 - [ ] `ReporteViewSet`: Agregar `required_permissions`
 - [ ] `NotificationViewSet`: Agregar `required_permissions`
 - [ ] `ETLViewSet`: Agregar `required_permissions`
 - [ ] Crear tests de permisos para estos módulos

4. **Fase 4: Validación y Cleanup (4 días)**
 - [ ] Tests de integración completos
 - [ ] Performance testing (comparar queries)
 - [ ] Validar auditoría funciona
 - [ ] Deprecar decorator antiguo
 - [ ] Actualizar documentación

---

## 9. Métricas de Éxito

### 9.1 KPIs Técnicos

| Métrica | Baseline (Decorator) | Target (Middleware) | Medición |
|---------|---------------------|---------------------|----------|
| **Cobertura de permisos** | 25% (1/4 módulos) | 100% (4/4 módulos) | Tests + code review |
| **Queries por verificación** | 3 queries | 3 queries (igual) | Django Debug Toolbar |
| **Latencia p50** | ~30ms | ≤30ms | Sampling logs |
| **Latencia p95** | ~60ms | ≤60ms | Sampling logs |
| **Tests passing** | 49/49 | 49/49 | CI/CD |
| **Error rate** | 0% | 0% | Monitoring |

### 9.2 Criterios de Aceptación

[OK] **Debe cumplir:**
- Todos los tests existentes pasan (49/49)
- TODOS los módulos usan permisos granulares (4/4)
- No aumenta queries ni latencia
- Auditoría funciona correctamente
- Sin errores en producción

---

## 10. Conclusiones

### 10.1 Recomendación: Migrar a Middleware Django

**Razones principales:**

1. **Consistencia:** TODOS los módulos usan permisos automáticamente
2. **Mantenibilidad:** Lógica centralizada, fácil de modificar
3. **Escalabilidad:** Agregar nuevos módulos es trivial (solo heredar PermisoMixin)
4. **Seguridad:** Imposible olvidar verificar permisos
5. **Cumple ADR_2025_017:** Sistema granular sin roles jerárquicos

### 10.2 Trade-offs Aceptados

- [ATENCION] Mayor complejidad inicial (compensado por consistencia)
- [ATENCION] Refactoring necesario (gradual, módulo por módulo)
- [ATENCION] Curva de aprendizaje (1-2 semanas para el equipo)

### 10.3 Próximos Pasos

1. **Validar con usuario:** Revisar diagramas y arquitectura propuesta
2. **Aprobar migración:** Confirmar plan de 4 fases
3. **Implementar Fase 1:** Crear middleware y mixin
4. **Iterar:** Migrar módulo por módulo con validación

---

## Referencias

- **ADR_2025_017:** Sistema de Permisos Granular SIN Roles Jerárquicos
- **Django Middleware:** https://docs.djangoproject.com/en/5.2/topics/http/middleware/
- **DRF Permissions:** https://www.django-rest-framework.org/api-guide/permissions/
- **Código actual:**
 - `apps/permissions/middleware.py` (decorator)
 - `apps/permissions/services.py` (PermisoService)
 - `apps/permissions/models.py` (modelos)

---

**Versión:** 1.0
**Estado:** Propuesto
**Fecha:** 2025-11-11
