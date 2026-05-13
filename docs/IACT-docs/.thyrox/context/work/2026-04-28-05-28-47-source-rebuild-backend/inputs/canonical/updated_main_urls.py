"""
URL configuration for callcentersite project - UC-005
Call Center Dashboard - URLs principales con versionado v1 y sistema de módulos
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone


def api_root(request):
    """
    API Root endpoint - información del sistema UC-005
    """
    return JsonResponse({
        'message': 'Call Center Dashboard API - UC-005',
        'version': '1.0.0',
        'api_version': 'v1',
        'endpoints': {
            'authentication': '/api/v1/auth/',
            'modules': '/api/v1/modules/',
            'health': '/health/',
            'admin': '/admin/',
        },
        'status': 'active',
        'features': [
            'JWT Authentication',
            'Role-based permissions',
            'Dynamic module system',
            'Advanced security validation',
            'Audit logging'
        ],
        'timestamp': timezone.now().isoformat()
    })


@csrf_exempt
def health_check(request):
    """
    Health check mejorado para UC-005 con validación de BD
    """
    from django.db import connection
    
    checks = {
        'status': 'healthy',
        'service': 'callcenter-dashboard',
        'version': '1.0.0',
        'database': 'unknown',
        'timestamp': timezone.now().isoformat()
    }
    
    # Verificar conexión a base de datos
    try:
        connection.ensure_connection()
        checks['database'] = 'connected'
    except Exception as e:
        checks['status'] = 'unhealthy'
        checks['database'] = 'disconnected'
        checks['error'] = str(e)
    
    status_code = 200 if checks['status'] == 'healthy' else 503
    return JsonResponse(checks, status=status_code)


urlpatterns = [
    # Admin panel
    path('admin/', admin.site.urls),

    # API Root
    path('api/', api_root, name='api_root'),

    # Authentication API v1
    path('api/v1/auth/', include('authentication.urls')),
    
    # Module System API v1
    path('api/v1/modules/', include('authentication.module_urls')),

    # Health check
    path('health/', health_check, name='health_check'),

    # Root redirect
    path('', api_root, name='root'),
]

# Static files en desarrollo
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# Admin site customization
admin.site.site_header = 'Call Center Dashboard - Administración'
admin.site.site_title = 'Call Center Admin'
admin.site.index_title = 'Panel de Administración UC-005'
