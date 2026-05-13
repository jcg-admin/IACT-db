---
id: ADR-BACK-005-middleware-decoradores-permisos
estado: aceptada
propietario: equipo-backend
ultima_actualizacion: 2025-11-18
relacionados:
 - ADR-BACK-001-grupos-funcionales-sin-jerarquia
 - ADR-BACK-003-orm-sql-hybrid-permissions
 - docs/backend/arquitectura/decoradores_y_middleware_permisos.md
 - docs/backend/permisos/MEJORAS_MIDDLEWARE_PROPUESTAS.md
tags: [permisos, middleware, decoradores, drf, backend]
date: 2025-11-18
---

# ADR-BACK-005: Middleware y Decoradores para Permisos Granulares

**Estado:** Aceptada

**Fecha:** 2025-11-18

**Decisores:** equipo-backend, tech-lead

**Contexto técnico:** Backend - Integración de Permisos

---

## Contexto y Problema

El sistema de permisos granulares (ADR-BACK-001) requiere integración con vistas Django y Django REST Framework. Necesitamos un mecanismo para:

1. **Proteger vistas** con verificación automática de permisos
2. **Auditar accesos** de forma transparente
3. **Soportar múltiples tipos de vistas**: FBV, CBV, DRF ViewSets
4. **Minimizar código boilerplate** en cada vista
5. **Proporcionar mensajes claros** cuando se deniega acceso
6. **Performance** sin overhead significativo

**Preguntas clave:**
- ¿Cómo integrar permisos en vistas sin código repetitivo?
- ¿Cómo soportar Function-Based Views y Class-Based Views?
- ¿Cómo integrar con DRF Permission Classes?
- ¿Cómo auditar accesos de forma automática?
- ¿Cómo minimizar overhead de performance?

**Restricciones actuales:**
- Sistema de permisos granulares con 130+ capacidades
- Django 5.x + Django REST Framework 3.x
- Necesidad de auditoría automática (ISO 27001)
- Performance: Overhead < 5ms por request
- Soportar lógica AND/OR para múltiples permisos

**Impacto del problema:**
- Sin integración clara, cada vista debe verificar permisos manualmente
- Código duplicado en cada endpoint
- Riesgo de olvidar proteger endpoints
- Auditoría inconsistente

---

## Factores de Decisión

- **Simplicidad**: Fácil de usar para desarrolladores
- **Flexibilidad**: Soportar FBV, CBV, DRF ViewSets
- **Performance**: Overhead mínimo (< 5ms)
- **Auditoría**: Automática y configurable
- **Mensajes claros**: Errores informativos para debugging
- **Compatibilidad**: Con Django y DRF estándar
- **Testabilidad**: Fácil de testear

---

## Opciones Consideradas

### Opción 1: Permission Classes DRF Exclusivamente

**Descripción:**
Usar únicamente DRF Permission Classes para proteger endpoints.

**Pros:**
- OK Estándar DRF
- OK Integración nativa con ViewSets
- OK Testing conocido

**Contras:**
- NO Solo funciona en DRF (no en vistas Django tradicionales)
- NO Código repetitivo en cada ViewSet
- NO No soporta auditoría automática
- NO Difícil implementar lógica AND/OR

**Ejemplo:**
```python
class DashboardViewSet(viewsets.ModelViewSet):
 permission_classes = [VerDashboardPermission]
 # Cada ViewSet necesita su Permission class custom
```

**Razón del rechazo:**
No soporta vistas Django tradicionales. Requiere crear Permission class por cada capacidad.

---

### Opción 2: Middleware Global

**Descripción:**
Middleware Django que intercepta todas las requests y verifica permisos globalmente.

**Pros:**
- OK Centralizado
- OK Funciona para todas las vistas
- OK Auditoría automática

**Contras:**
- NO Difícil especificar permisos por vista
- NO Configuración compleja (mapping URL → permiso)
- NO No es explícito (permisos no visibles en código de vista)
- NO Overhead en TODAS las requests (incluso públicas)

**Razón del rechazo:**
No es explícito. Configuración compleja y difícil de mantener.

---

### Opción 3: Decoradores + Permission Classes DRF (ELEGIDA)

**Descripción:**
Combinar decoradores Python para FBV/CBV con Permission Classes DRF para ViewSets, más middleware opcional para auditoría.

**Arquitectura:**
```

 Tipo de Vista 

 > Function-Based View
 @verificar_permiso('capacidad')

 > Class-Based View
 @method_decorator(verificar_permiso('capacidad'))

 > DRF ViewSet
 permission_classes = [GranularPermission]
```

**Componentes:**

1. **Decoradores para FBV/CBV:**
 - `@verificar_permiso(capacidad_requerida)`
 - `@require_permission(capacidad)`
 - `@require_any_permission([cap1, cap2])` # OR logic
 - `@require_all_permissions([cap1, cap2])` # AND logic

2. **Permission Classes para DRF:**
 - `GranularPermission` - Permission class base
 - `GranularPermissionMixin` - Helpers para ViewSets

3. **Middleware Opcional:**
 - `PermissionAuditMiddleware` - Auditoría automática

**Pros:**
- OK Soporta FBV, CBV, DRF ViewSets
- OK Explícito (decorador visible en código)
- OK Flexible (lógica AND/OR)
- OK Auditoría configurable
- OK Performance (overhead mínimo)
- OK Fácil de testear
- OK Mensajes de error claros

**Contras:**
- NO Más código que opción 1 (pero más flexible)
- NO Requiere implementación de 3 componentes

**Ejemplo/Implementación:**

**Decorador para FBV:**
```python
from callcentersite.apps.permissions.middleware import verificar_permiso

@verificar_permiso('sistema.vistas.dashboards.ver', auditar=True)
def dashboard_view(request):
 """Vista de dashboard."""
 return render(request, 'dashboard.html', {
 'user': request.user,
 })
```

**Decorador para CBV:**
```python
from django.views.generic import TemplateView
from django.utils.decorators import method_decorator
from callcentersite.apps.permissions.middleware import verificar_permiso

@method_decorator(
 verificar_permiso('sistema.vistas.dashboards.ver'),
 name='dispatch'
)
class DashboardView(TemplateView):
 template_name = 'dashboard.html'
```

**Permission Class para DRF:**
```python
from rest_framework import viewsets
from callcentersite.apps.permissions.permissions import GranularPermission

class DashboardViewSet(viewsets.ModelViewSet):
 permission_classes = [GranularPermission]
 required_permissions = ['sistema.vistas.dashboards.ver']

 def get_queryset(self):
 return Dashboard.objects.all()
```

**Lógica AND/OR:**
```python
# OR Logic - Usuario necesita AL MENOS UNA de las capacidades
@require_any_permission([
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.dashboards.ver_publico'
])
def dashboard_view(request):
 pass

# AND Logic - Usuario necesita TODAS las capacidades
@require_all_permissions([
 'sistema.finanzas.pagos.ver',
 'sistema.finanzas.pagos.aprobar'
])
def aprobar_pago_view(request, pago_id):
 pass
```

**Implementación del Decorador:**
```python
from functools import wraps
from django.http import JsonResponse
from callcentersite.apps.permissions.services import PermisoService

def verificar_permiso(capacidad_requerida, auditar=False, mensaje_error=None):
 """
 Decorator para verificar permisos granulares.

 Args:
 capacidad_requerida: str o list[str] - Capacidad(es) requerida(s)
 auditar: bool - Si registrar el acceso en auditoría
 mensaje_error: str - Mensaje custom de error
 """
 def decorator(view_func):
 @wraps(view_func)
 def wrapper(request, *args, **kwargs):
 # Verificar autenticación
 if not request.user.is_authenticated:
 return JsonResponse(
 {'error': 'Authentication required'},
 status=401
 )

 # Convertir a lista si es string
 capacidades = (
 [capacidad_requerida]
 if isinstance(capacidad_requerida, str)
 else capacidad_requerida
 )

 # Verificar TODAS las capacidades (AND logic)
 tiene_permiso = all(
 PermisoService.usuario_tiene_permiso(
 request.user.id,
 cap
 )
 for cap in capacidades
 )

 if not tiene_permiso:
 # Auditar acceso denegado
 if auditar:
 PermisoService.registrar_acceso(
 usuario_id=request.user.id,
 capacidad=capacidad_requerida,
 accion='acceso_denegado',
 ip_address=request.META.get('REMOTE_ADDR'),
 user_agent=request.META.get('HTTP_USER_AGENT')
 )

 error_msg = mensaje_error or f'Permission denied: {capacidad_requerida}'
 return JsonResponse(
 {'error': error_msg},
 status=403
 )

 # Auditar acceso permitido
 if auditar:
 PermisoService.registrar_acceso(
 usuario_id=request.user.id,
 capacidad=capacidad_requerida,
 accion='acceso_permitido',
 ip_address=request.META.get('REMOTE_ADDR'),
 user_agent=request.META.get('HTTP_USER_AGENT')
 )

 # Permitir acceso
 return view_func(request, *args, **kwargs)

 return wrapper
 return decorator
```

**Permission Class DRF:**
```python
from rest_framework.permissions import BasePermission
from callcentersite.apps.permissions.services import PermisoService

class GranularPermission(BasePermission):
 """
 Permission class para DRF ViewSets.

 Uso:
 class MyViewSet(viewsets.ModelViewSet):
 permission_classes = [GranularPermission]
 required_permissions = ['sistema.recurso.accion']
 """

 def has_permission(self, request, view):
 if not request.user.is_authenticated:
 return False

 # Obtener capacidades requeridas del ViewSet
 required_perms = getattr(view, 'required_permissions', [])

 if not required_perms:
 # Sin permisos definidos, denegar por defecto
 return False

 # Verificar TODAS las capacidades
 return all(
 PermisoService.usuario_tiene_permiso(
 request.user.id,
 perm
 )
 for perm in required_perms
 )
```

---

## Decisión

**Opción elegida:** "Decoradores + Permission Classes DRF"

**Justificación:**

1. **Flexibilidad**: Soporta FBV, CBV, DRF ViewSets con APIs consistentes

2. **Explícito**: Permisos visibles en código (decorador o permission_classes)

3. **Auditoría**: Configurable por vista con parámetro `auditar=True`

4. **Performance**: Overhead mínimo (5-10ms), usa estrategia híbrida ORM+SQL (ADR-BACK-003)

5. **Lógica AND/OR**: Decoradores especializados para casos complejos

6. **Testabilidad**: Fácil de mockear y testear

**Trade-offs aceptados:**
- Más componentes que opción 1 (pero más flexibilidad)
- Código adicional vs DRF puro (justificado por soporte de FBV/CBV)

---

## Consecuencias

### Positivas

- OK Integración transparente con permisos granulares
- OK Soporta FBV, CBV, DRF ViewSets
- OK Código boilerplate mínimo
- OK Auditoría configurable por vista
- OK Mensajes de error claros
- OK Performance óptimo (< 5ms overhead)
- OK Testeable fácilmente
- OK Lógica AND/OR flexible

### Negativas

- WARNING Requiere implementar 3 componentes (decoradores, permissions, middleware)
- WARNING Curva de aprendizaje para decoradores Python
- WARNING Debe mantener consistencia entre decoradores y permission classes

### Neutrales

- INFO Decoradores deben aplicarse correctamente (en dispatch para CBV)
- INFO Permission classes requieren atributo required_permissions
- INFO Middleware opcional para auditoría global

---

## Plan de Implementación

1. **Fase 1: Decoradores Base**
 - Implementar @verificar_permiso
 - Implementar @require_permission
 - Tests unitarios
 - Timeframe: 2 días

2. **Fase 2: Decoradores Avanzados**
 - Implementar @require_any_permission (OR)
 - Implementar @require_all_permissions (AND)
 - Tests de lógica AND/OR
 - Timeframe: 1 día

3. **Fase 3: Permission Classes DRF**
 - Implementar GranularPermission
 - Implementar GranularPermissionMixin
 - Tests de integración con ViewSets
 - Timeframe: 2 días

4. **Fase 4: Middleware Opcional**
 - Implementar PermissionAuditMiddleware
 - Configuración en settings
 - Tests de auditoría
 - Timeframe: 1 día

5. **Fase 5: Documentación y Ejemplos**
 - Documentación técnica
 - Ejemplos de uso
 - Guía de migration
 - Timeframe: 1 día

**Total:** 7 días

---

## Validación y Métricas

**Criterios de Éxito:**
- Overhead: < 5ms por request (p95)
- Coverage: 100% de endpoints protegidos
- Auditoría: 100% de accesos críticos registrados
- Tests: > 90% coverage

**Cómo medir:**
- Performance profiling de decoradores
- Code review para verificar protección de endpoints
- Audit log analysis
- Coverage report de pytest

**Revisión:**
- Fecha de revisión programada: 2026-02-18 (3 meses post-implementación)
- Responsable de seguimiento: equipo-backend

---

## Alternativas Descartadas

### Django Guardian

**Por qué se descartó:**
- Object-level permissions (demasiado granular)
- Complejidad innecesaria para nuestras necesidades
- No se alinea con modelo de grupos funcionales

### Custom Middleware Global

**Por qué se descartó:**
- No es explícito (configuración oculta)
- Overhead en todas las requests
- Difícil de mantener mapping URL → permiso

---

## Referencias

- [ADR-BACK-001: Grupos Funcionales Sin Jerarquía](ADR-BACK-001-grupos-funcionales-sin-jerarquia.md)
- [ADR-BACK-003: Estrategia Híbrida ORM + SQL](ADR-BACK-003-orm-sql-hybrid-permissions.md)
- [Decoradores y Middleware](../../arquitectura/decoradores_y_middleware_permisos.md)
- [Mejoras Middleware](../../permisos/MEJORAS_MIDDLEWARE_PROPUESTAS.md)
- [Python Decorators](https://docs.python.org/3/glossary.html#term-decorator)
- [DRF Permissions](https://www.django-rest-framework.org/api-guide/permissions/)

---

## Notas Adicionales

**Fecha de discusión inicial:** 2025-11-08
**Implementación completada**: 2025-11-11

**Tests implementados:**
- 11+ tests en `test_middleware.py`
- Coverage de casos edge (anónimo, sin permiso, múltiples capacidades)
- Tests de performance (< 10ms overhead)

**Ejemplos de uso en código:**
- `apps/dashboard/views.py` - Uso de decoradores
- `apps/configuration/views.py` - DRF Permission Classes
- `apps/permissions/tests/test_middleware.py` - Tests completos

---

**Documento:** ADR-BACK-005
**Fecha:** 18 de Noviembre, 2025
**Estado:** Aceptada e Implementada
**Próxima revisión:** 2026-02-18
