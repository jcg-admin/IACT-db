---
id: DOC-PERM-004
tipo: documentacion_tecnica
nombre: Decoradores, Middleware y Mixins de Permisos Granulares
version: 1.0.0
fecha: 2025-01-09
autor: Sistema
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01, permisos-granular.md]
trazabilidad_downward: [decorators_permisos.py, middleware_permisos.py, mixins_permisos.py]
---

# Decoradores, Middleware y Mixins de Permisos Granulares

## Resumen Ejecutivo

Este documento describe los **decoradores**, **middleware** y **mixins** que simplifican la integración del sistema de permisos granulares en vistas Django y Django REST Framework (DRF).

### Componentes Principales

1. **Decoradores** (decorators_permisos.py)
 - `@require_permission` - Verificar permiso único
 - `@require_any_permission` - Verificar AL MENOS UNO de varios permisos
 - `@require_all_permissions` - Verificar TODOS los permisos

2. **Middleware** (middleware_permisos.py)
 - `PermissionAuditMiddleware` - Auditoría automática de requests

3. **Mixins y Permission Classes** (mixins_permisos.py)
 - `GranularPermission` - Permission class para DRF ViewSets
 - `GranularPermissionMixin` - Mixin con helpers para ViewSets

### Performance

- **Decoradores**: 5-10ms por verificación (SQL functions)
- **Middleware**: < 1ms overhead con auditoría asíncrona, 5-10ms con auditoría síncrona
- **Mixins**: 5-10ms por verificación + cache en request (< 1ms para verificaciones subsecuentes)

---

## 1. Decoradores

### 1.1 `@require_permission`

Verifica si el usuario tiene **UNA** capacidad específica.

#### Sintaxis

```python
from callcentersite.apps.users.decorators_permisos import require_permission

@require_permission(capacidad_codigo, raise_exception=True, audit=True)
def mi_vista(request):
 # ...
```

#### Parámetros

| Parámetro | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `capacidad_codigo` | str | REQUERIDO | Código de la capacidad (ej: 'sistema.vistas.dashboards.ver') |
| `raise_exception` | bool | True | Si True, lanza PermissionDenied (403). Si False, retorna JSON con error |
| `audit` | bool | True | Si True, registra la verificación en auditoría |

#### Ejemplos

##### Ejemplo 1: Vista Basada en Función (Function-Based View)

```python
from django.shortcuts import render
from callcentersite.apps.users.decorators_permisos import require_permission

@require_permission('sistema.vistas.dashboards.ver')
def dashboard_view(request):
 """
 Vista de dashboard.

 Requiere: sistema.vistas.dashboards.ver
 """
 return render(request, 'dashboard.html', {
 'user': request.user,
 })
```

##### Ejemplo 2: Vista Basada en Clase (Class-Based View)

```python
from django.views.generic import TemplateView
from django.utils.decorators import method_decorator
from callcentersite.apps.users.decorators_permisos import require_permission

@method_decorator(
 require_permission('sistema.vistas.dashboards.ver'),
 name='dispatch'
)
class DashboardView(TemplateView):
 """
 Vista de dashboard (CBV).

 Requiere: sistema.vistas.dashboards.ver
 """
 template_name = 'dashboard.html'
```

##### Ejemplo 3: Sin Lanzar Exception (Retornar JSON)

```python
@require_permission('sistema.vistas.reportes.ver', raise_exception=False)
def reportes_api(request):
 """
 API de reportes.

 Si no tiene permiso, retorna JSON 403:
 {
 "error": "Permiso denegado",
 "required_permission": "sistema.vistas.reportes.ver"
 }
 """
 reportes = Reporte.objects.all()
 return JsonResponse({'reportes': list(reportes.values())})
```

##### Ejemplo 4: Sin Auditoría

```python
@require_permission('sistema.vistas.pruebas.ver', audit=False)
def pruebas_view(request):
 """
 Vista de pruebas sin auditoría.

 Útil para endpoints que no requieren auditoría (ej: health checks internos)
 """
 return JsonResponse({'status': 'OK'})
```

#### Comportamiento

1. Extrae el usuario del `request`
2. Si no está autenticado, denegar (401)
3. Marca el request para auditoría en middleware
4. Verifica permiso usando SQL function `usuario_tiene_permiso()` (5-10ms)
5. Si `audit=True`, registra en auditoría usando `verificar_permiso_y_auditar()`
6. Si no tiene permiso:
 - `raise_exception=True`: Lanza `PermissionDenied` (403)
 - `raise_exception=False`: Retorna `JsonResponse` con error (403)
7. Si tiene permiso, ejecuta la vista normalmente

---

### 1.2 `@require_any_permission`

Verifica si el usuario tiene **AL MENOS UNA** de varias capacidades.

#### Sintaxis

```python
@require_any_permission(capacidades, raise_exception=True, audit=True)
def mi_vista(request):
 # ...
```

#### Parámetros

| Parámetro | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `capacidades` | List[str] | REQUERIDO | Lista de códigos de capacidades |
| `raise_exception` | bool | True | Si True, lanza PermissionDenied |
| `audit` | bool | True | Si True, audita |

#### Ejemplos

##### Ejemplo 1: Acceso a Vista de Análisis (Dashboard O Reportes)

```python
@require_any_permission([
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.reportes.ver',
])
def analytics_view(request):
 """
 Vista de análisis.

 Requiere AL MENOS UNA de:
 - sistema.vistas.dashboards.ver
 - sistema.vistas.reportes.ver
 """
 return render(request, 'analytics.html')
```

##### Ejemplo 2: Acceso a Exportación (PDF O Excel O CSV)

```python
@require_any_permission([
 'sistema.exportacion.pdf.generar',
 'sistema.exportacion.excel.generar',
 'sistema.exportacion.csv.generar',
])
def export_data_view(request):
 """
 Vista de exportación.

 Usuario debe poder exportar en AL MENOS UN formato.
 """
 formato = request.GET.get('formato', 'pdf')
 # ... lógica de exportación
 return HttpResponse(content, content_type=...)
```

#### Performance

- **Optimización**: Obtiene todas las capacidades del usuario **UNA SOLA VEZ** (10-20ms)
- Verificaciones subsecuentes son **in-memory** (< 1ms)
- Más eficiente que múltiples llamadas a `@require_permission`

---

### 1.3 `@require_all_permissions`

Verifica si el usuario tiene **TODAS** las capacidades especificadas.

#### Sintaxis

```python
@require_all_permissions(capacidades, raise_exception=True, audit=True)
def mi_vista(request):
 # ...
```

#### Parámetros

| Parámetro | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `capacidades` | List[str] | REQUERIDO | Lista de códigos de capacidades (TODAS requeridas) |
| `raise_exception` | bool | True | Si True, lanza PermissionDenied |
| `audit` | bool | True | Si True, audita |

#### Ejemplos

##### Ejemplo 1: Edición de Reportes (Ver Y Editar)

```python
@require_all_permissions([
 'sistema.vistas.reportes.ver',
 'sistema.vistas.reportes.editar',
])
def edit_report_view(request, report_id):
 """
 Vista de edición de reportes.

 Requiere AMBAS capacidades:
 - sistema.vistas.reportes.ver (para ver el reporte)
 - sistema.vistas.reportes.editar (para editarlo)
 """
 report = get_object_or_404(Report, pk=report_id)

 if request.method == 'POST':
 # ... guardar cambios
 pass

 return render(request, 'edit_report.html', {'report': report})
```

##### Ejemplo 2: Panel de Administración Completo

```python
@require_all_permissions([
 'sistema.administracion.usuarios.ver',
 'sistema.administracion.permisos.ver',
 'sistema.administracion.grupos.ver',
 'sistema.administracion.auditoria.ver',
])
def admin_panel_view(request):
 """
 Panel completo de administración.

 Requiere TODAS las capacidades de administración.
 """
 return render(request, 'admin_panel.html')
```

#### Comportamiento Especial

Si el usuario **NO** tiene todos los permisos, el JSON de error incluye las capacidades **faltantes**:

```json
{
 "error": "Permiso denegado",
 "required_permissions_all": [
 "sistema.vistas.reportes.ver",
 "sistema.vistas.reportes.editar",
 "sistema.vistas.reportes.eliminar"
 ],
 "missing_permissions": [
 "sistema.vistas.reportes.eliminar"
 ]
}
```

---

## 2. Middleware

### 2.1 `PermissionAuditMiddleware`

Middleware que audita automáticamente todas las verificaciones de permisos.

#### Configuración

##### Paso 1: Agregar a `settings.py`

```python
MIDDLEWARE = [
 'django.middleware.security.SecurityMiddleware',
 'django.contrib.sessions.middleware.SessionMiddleware',
 'django.middleware.common.CommonMiddleware',
 'django.middleware.csrf.CsrfViewMiddleware',
 'django.contrib.auth.middleware.AuthenticationMiddleware',
 'django.contrib.messages.middleware.MessageMiddleware',
 'django.middleware.clickjacking.XFrameOptionsMiddleware',

 # AGREGAR AQUÍ (después de AuthenticationMiddleware)
 'callcentersite.apps.users.middleware_permisos.PermissionAuditMiddleware',
]
```

##### Paso 2: Configuración Personalizada (Opcional)

```python
# settings.py

PERMISSION_AUDIT_CONFIG = {
 # Habilitar/deshabilitar auditoría global
 'enabled': True,

 # Auditar TODOS los requests (cuidado con volumen)
 # Si False, solo audita requests donde se verificó permiso con decoradores
 'audit_all_requests': False,

 # Solo auditar usuarios autenticados
 'audit_only_authenticated': True,

 # Excluir estos paths de auditoría (regex)
 'exclude_paths': [
 '/api/health/',
 '/api/metrics/',
 '/static/',
 '/media/',
 '/admin/jsi18n/',
 ],

 # Incluir query parameters en metadata de auditoría
 'include_query_params': True,

 # Usar Celery para auditoría asíncrona (RECOMENDADO en producción)
 # Requiere: Celery configurado y task creada
 'async_audit': True,
}
```

#### Funcionalidad

1. **process_request**: Marca timestamp de inicio del request
2. **process_response**:
 - Verifica si el request debe ser auditado
 - Obtiene información del usuario, IP, User-Agent
 - Calcula latencia del request
 - Audita usando SQL function o Celery task
3. **process_exception**:
 - Si hay `PermissionDenied`, audita el acceso denegado

#### Performance

| Configuración | Overhead | Descripción |
|---------------|----------|-------------|
| `async_audit=True` | < 1ms | Encola task de Celery (RECOMENDADO) |
| `async_audit=False` | 5-10ms | INSERT directo a DB |
| `enabled=False` | 0ms | Sin auditoría |

#### Metadata Auditada

El middleware registra:

- **Usuario**: ID del usuario autenticado
- **Capacidad**: Código de la capacidad verificada
- **Resultado**: True (concedido) o False (denegado)
- **IP**: IP del cliente (soporta proxies via X-Forwarded-For)
- **User-Agent**: Navegador/cliente
- **Timestamp**: Fecha y hora exacta
- **Latencia**: Tiempo de procesamiento del request (ms)
- **Method**: GET, POST, PUT, DELETE, etc
- **Path**: URL del request
- **Query Params**: Parámetros de la URL (opcional)

#### Integración con Decoradores

Los decoradores **automáticamente marcan** el request para que el middleware lo audite:

```python
# El decorador marca el request
@require_permission('sistema.vistas.dashboards.ver')
def dashboard_view(request):
 return render(request, 'dashboard.html')

# El middleware detecta la marca y audita automáticamente
# NO necesitas hacer nada adicional
```

---

## 3. Mixins y Permission Classes (DRF)

### 3.1 `GranularPermission`

Permission class para Django REST Framework que integra el sistema de permisos granulares.

#### Configuración Básica

```python
from rest_framework import viewsets
from callcentersite.apps.users.mixins_permisos import GranularPermission

class ArticleViewSet(viewsets.ModelViewSet):
 queryset = Article.objects.all()
 serializer_class = ArticleSerializer
 permission_classes = [GranularPermission]

 # Mapear acciones a capacidades
 permission_map = {
 'list': 'sistema.vistas.articulos.ver',
 'retrieve': 'sistema.vistas.articulos.ver',
 'create': 'sistema.vistas.articulos.crear',
 'update': 'sistema.vistas.articulos.editar',
 'partial_update': 'sistema.vistas.articulos.editar',
 'destroy': 'sistema.vistas.articulos.eliminar',
 }
```

#### Configuraciones Avanzadas

##### Opción 1: Permiso Único por Acción

```python
permission_map = {
 'list': 'sistema.vistas.articulos.ver',
 'create': 'sistema.vistas.articulos.crear',
}
```

##### Opción 2: Lista de Permisos (ANY - al menos uno)

```python
permission_map = {
 'list': [
 'sistema.vistas.articulos.ver',
 'sistema.vistas.reportes.ver',
 ], # Requiere AL MENOS UNO
}
```

##### Opción 3: Dict con 'all' (ALL - todos requeridos)

```python
permission_map = {
 'destroy': {
 'all': [
 'sistema.vistas.articulos.ver',
 'sistema.vistas.articulos.eliminar',
 ]
 }, # Requiere AMBOS
}
```

##### Opción 4: Custom Actions

```python
class ReportViewSet(viewsets.ModelViewSet):
 permission_classes = [GranularPermission]
 permission_map = {
 'list': 'sistema.vistas.reportes.ver',
 'export_pdf': 'sistema.vistas.reportes.exportar', # Custom action
 'share': 'sistema.vistas.reportes.compartir', # Custom action
 }

 @action(detail=True, methods=['post'])
 def export_pdf(self, request, pk=None):
 # ... lógica de exportación
 pass

 @action(detail=True, methods=['post'])
 def share(self, request, pk=None):
 # ... lógica de compartir
 pass
```

#### Performance

- **Primera verificación en request**: 5-10ms (SQL function)
- **Verificaciones subsecuentes en mismo request**: < 1ms (cache automático)
- **Cache scope**: Por request (no persiste entre requests)

---

### 3.2 `GranularPermissionMixin`

Mixin que simplifica el uso de `GranularPermission` y agrega helper methods.

#### Uso Básico

```python
from rest_framework import viewsets
from callcentersite.apps.users.mixins_permisos import GranularPermissionMixin

class ReportViewSet(GranularPermissionMixin, viewsets.ModelViewSet):
 queryset = Report.objects.all()
 serializer_class = ReportSerializer

 permission_map = {
 'list': 'sistema.vistas.reportes.ver',
 'create': 'sistema.vistas.reportes.crear',
 'export_pdf': 'sistema.vistas.reportes.exportar',
 }
```

**NOTA**: El mixin automáticamente configura `GranularPermission` en `permission_classes`.

#### Helper Methods

##### `check_permission(capacidad_codigo: str) -> bool`

Verifica un permiso dentro del código del ViewSet.

```python
class ReportViewSet(GranularPermissionMixin, viewsets.ModelViewSet):
 permission_map = {'list': 'sistema.vistas.reportes.ver'}

 def list(self, request):
 # Verificar permiso adicional dentro del método
 if self.check_permission('sistema.vistas.reportes.exportar'):
 # Usuario puede exportar, incluir botón en respuesta
 can_export = True
 else:
 can_export = False

 queryset = self.get_queryset()
 serializer = self.get_serializer(queryset, many=True)

 return Response({
 'results': serializer.data,
 'can_export': can_export,
 })
```

##### `check_any_permission(capacidades: List[str]) -> bool`

Verifica si el usuario tiene AL MENOS UNA capacidad.

```python
@action(detail=False, methods=['get'])
def analytics(self, request):
 # Usuario necesita dashboards O reportes
 if not self.check_any_permission([
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.reportes.ver',
 ]):
 return Response({'error': 'Sin permiso'}, status=403)

 # ... lógica de analytics
```

##### `check_all_permissions(capacidades: List[str]) -> bool`

Verifica si el usuario tiene TODAS las capacidades.

```python
@action(detail=True, methods=['delete'])
def force_delete(self, request, pk=None):
 # Requiere ver Y eliminar Y permisos especiales
 if not self.check_all_permissions([
 'sistema.vistas.reportes.ver',
 'sistema.vistas.reportes.eliminar',
 'sistema.administracion.force_delete',
 ]):
 return Response({'error': 'Permisos insuficientes'}, status=403)

 # ... lógica de force delete
```

##### `get_user_capacidades() -> List[str]`

Obtiene todas las capacidades del usuario.

```python
@action(detail=False, methods=['get'])
def my_permissions(self, request):
 """Endpoint que retorna todas las capacidades del usuario."""
 capacidades = self.get_user_capacidades()

 return Response({
 'usuario_id': request.user.id,
 'capacidades': capacidades,
 'total': len(capacidades),
 })
```

---

## 4. Patrones de Uso Comunes

### Patrón 1: Vista Completa (Django FBV + Decorador)

```python
from django.shortcuts import render, get_object_or_404
from callcentersite.apps.users.decorators_permisos import (
 require_permission,
 require_all_permissions,
)
from .models import Report

@require_permission('sistema.vistas.reportes.ver')
def list_reports(request):
 """Lista todos los reportes."""
 reports = Report.objects.filter(activo=True)
 return render(request, 'reports/list.html', {'reports': reports})

@require_all_permissions([
 'sistema.vistas.reportes.ver',
 'sistema.vistas.reportes.editar',
])
def edit_report(request, report_id):
 """Edita un reporte."""
 report = get_object_or_404(Report, pk=report_id)

 if request.method == 'POST':
 # ... validar y guardar
 pass

 return render(request, 'reports/edit.html', {'report': report})
```

### Patrón 2: ViewSet Completo (DRF + Mixin)

```python
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from callcentersite.apps.users.mixins_permisos import GranularPermissionMixin
from .models import Report
from .serializers import ReportSerializer

class ReportViewSet(GranularPermissionMixin, viewsets.ModelViewSet):
 """
 ViewSet completo de reportes con permisos granulares.
 """
 queryset = Report.objects.all()
 serializer_class = ReportSerializer

 permission_map = {
 # CRUD básico
 'list': 'sistema.vistas.reportes.ver',
 'retrieve': 'sistema.vistas.reportes.ver',
 'create': 'sistema.vistas.reportes.crear',
 'update': 'sistema.vistas.reportes.editar',
 'partial_update': 'sistema.vistas.reportes.editar',
 'destroy': 'sistema.vistas.reportes.eliminar',

 # Custom actions
 'export_pdf': 'sistema.vistas.reportes.exportar',
 'share': 'sistema.vistas.reportes.compartir',
 }

 @action(detail=True, methods=['post'])
 def export_pdf(self, request, pk=None):
 """Exporta reporte a PDF."""
 report = self.get_object()

 # Lógica de exportación
 pdf_content = generate_pdf(report)

 return Response({
 'url': f'/media/reports/{report.id}.pdf',
 'size_bytes': len(pdf_content),
 })

 @action(detail=True, methods=['post'])
 def share(self, request, pk=None):
 """Comparte reporte con otros usuarios."""
 report = self.get_object()
 user_ids = request.data.get('user_ids', [])

 # Verificar permiso adicional si se comparte con externos
 if request.data.get('external', False):
 if not self.check_permission('sistema.vistas.reportes.compartir_externo'):
 return Response(
 {'error': 'Sin permiso para compartir con externos'},
 status=status.HTTP_403_FORBIDDEN
 )

 # Lógica de compartir
 # ...

 return Response({'shared_with': user_ids})
```

### Patrón 3: Middleware + Decoradores (Auditoría Automática)

```python
# settings.py
MIDDLEWARE = [
 # ...
 'callcentersite.apps.users.middleware_permisos.PermissionAuditMiddleware',
]

PERMISSION_AUDIT_CONFIG = {
 'enabled': True,
 'async_audit': True, # Celery
 'audit_only_authenticated': True,
}

# views.py
from callcentersite.apps.users.decorators_permisos import require_permission

@require_permission('sistema.vistas.dashboards.ver')
def dashboard(request):
 """
 Vista de dashboard.

 El middleware AUTOMÁTICAMENTE auditará:
 - Usuario: request.user.id
 - Capacidad: 'sistema.vistas.dashboards.ver'
 - Resultado: True/False
 - IP: request IP
 - Timestamp: hora exacta
 - Latency: tiempo de procesamiento
 """
 return render(request, 'dashboard.html')
```

---

## 5. Migración desde Django Permissions

### Desde `@permission_required` (Django)

**ANTES (Django estándar)**:

```python
from django.contrib.auth.decorators import permission_required

@permission_required('app.view_report', raise_exception=True)
def view_report(request, report_id):
 # ...
```

**DESPUÉS (Permisos granulares)**:

```python
from callcentersite.apps.users.decorators_permisos import require_permission

@require_permission('sistema.vistas.reportes.ver', raise_exception=True)
def view_report(request, report_id):
 # ...
```

### Desde DRF Permissions

**ANTES (DRF estándar)**:

```python
from rest_framework.permissions import IsAuthenticated, DjangoModelPermissions

class ReportViewSet(viewsets.ModelViewSet):
 permission_classes = [IsAuthenticated, DjangoModelPermissions]
 queryset = Report.objects.all()
```

**DESPUÉS (Permisos granulares)**:

```python
from callcentersite.apps.users.mixins_permisos import GranularPermission

class ReportViewSet(viewsets.ModelViewSet):
 permission_classes = [GranularPermission]
 queryset = Report.objects.all()

 permission_map = {
 'list': 'sistema.vistas.reportes.ver',
 'create': 'sistema.vistas.reportes.crear',
 # ...
 }
```

---

## 6. Testing

### Test de Decorador

```python
import pytest
from django.test import RequestFactory
from callcentersite.apps.users.decorators_permisos import require_permission

@pytest.mark.django_db
def test_decorador_permite_acceso_con_permiso():
 """Usuario con permiso debe acceder."""

 @require_permission('sistema.vistas.test.ver')
 def test_view(request):
 return HttpResponse("OK")

 factory = RequestFactory()
 request = factory.get('/test/')
 request.user = user_with_permission # fixture

 response = test_view(request)

 assert response.status_code == 200
```

### Test de Permission Class (DRF)

```python
import pytest
from rest_framework.test import APIRequestFactory, force_authenticate
from callcentersite.apps.users.mixins_permisos import GranularPermission

@pytest.mark.django_db
def test_permission_class_verifica_correctamente():
 """Permission class debe verificar permisos."""

 class TestViewSet(viewsets.ViewSet):
 permission_classes = [GranularPermission]
 permission_map = {'list': 'sistema.vistas.test.ver'}

 def list(self, request):
 return Response({'data': 'OK'})

 factory = APIRequestFactory()
 view = TestViewSet.as_view({'get': 'list'})
 request = factory.get('/test/')
 force_authenticate(request, user=user_with_permission)

 response = view(request)

 assert response.status_code == 200
```

---

## 7. Troubleshooting

### Error: "AttributeError: 'WSGIRequest' object has no attribute 'user'"

**Causa**: Request no tiene usuario autenticado.

**Solución**: Verificar que `AuthenticationMiddleware` está configurado ANTES del `PermissionAuditMiddleware`.

### Error: "ImproperlyConfigured: ViewSet debe definir 'permission_map'"

**Causa**: ViewSet con `GranularPermission` no tiene `permission_map`.

**Solución**: Agregar `permission_map` al ViewSet:

```python
class MyViewSet(viewsets.ModelViewSet):
 permission_classes = [GranularPermission]

 # AGREGAR ESTO
 permission_map = {
 'list': 'sistema.vistas.mi_modelo.ver',
 }
```

### Performance: Middleware muy lento

**Causa**: Auditoría síncrona (`async_audit=False`) en alto tráfico.

**Solución**: Configurar Celery y habilitar `async_audit=True`:

```python
# settings.py
PERMISSION_AUDIT_CONFIG = {
 'async_audit': True, # < 1ms overhead
}
```

---

## 8. Referencias

- [permisos-granular.md](./permisos-granular.md) - Arquitectura del sistema
- [UC-PERM-001](../../casos_de_uso/UC-PERM-001_asignar_grupo_a_usuario.md) - Caso de uso de asignación
- [integracion_permisos.md](../../frontend/integracion_permisos.md) - Integración frontend
- [decorators_permisos.py](../../../api/callcentersite/callcentersite/apps/users/decorators_permisos.py) - Código fuente
- [middleware_permisos.py](../../../api/callcentersite/callcentersite/apps/users/middleware_permisos.py) - Código fuente
- [mixins_permisos.py](../../../api/callcentersite/callcentersite/apps/users/mixins_permisos.py) - Código fuente

---

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
