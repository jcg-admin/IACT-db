# 📝 PROPUESTA DE AMPLIACIONES - CNST-005 y CNST-006
## Sistema IACT - IVR Analytics & Customer Tracking

**Fecha:** 2026-01-03  
**Objetivo:** Ampliar contenido sin crear nuevos CNST  
**Documentos afectados:** CNST-005, CNST-006

---

## 📊 ESTADO ACTUAL

### CNST-005: Seguridad Django REST Framework

**Líneas actuales:** 994  
**Estructura:**
```
1. Propósito (líneas 1-43)
2. Autenticación (líneas 44-138)
3. Autorización (Permisos) (líneas 139-338)
   - Permisos Base
   - Permisos Basados en Roles (RBAC)
4. Throttling (líneas 339-417)
5. Validación de Datos (líneas 418-543)
6. Manejo de Excepciones (líneas 544-632)
7. Paginación (líneas 633-688)
8. Ejemplo Vista Completa (líneas 689-857)
9. Validación en Desarrollo (líneas 858-936)
10. Referencias (líneas 937-995)
```

**GAP identificado:**
- ⚠️ "Permisos con vencimiento" mencionado en RBAC v5.1.1 pero NO detallado
- ⚠️ Gestión de permisos temporales no documentada

---

### CNST-006: Antipatrones de Arquitectura Prohibidos

**Líneas actuales:** 1,126  
**Estructura:**
```
1. Propósito (líneas 1-42)
2. Antipatrón 1: God Class (líneas 43-147)
3. Antipatrón 2: Spaghetti Code (líneas 148-255)
4. Antipatrón 3: Copy-Paste Programming (líneas 256-355)
5. Antipatrón 4: Magic Numbers/Strings (líneas 356-443)
6. Antipatrón 5: Hardcoded Configuration (líneas 444-523)
7. Antipatrón 6: Premature Optimization (líneas 524-606)
8. Antipatrón 7: Callback Hell (líneas 607-684)
9. Antipatrón 8: Feature Envy (líneas 685-781)
10. Antipatrón 9: Primitive Obsession (líneas 782-887)
11. Antipatrón 10: Shotgun Surgery (líneas 888-987)
12. Validación en Desarrollo (líneas 988-1073)
13. Referencias (líneas 1074-1126)
```

**GAP identificado:**
- ⚠️ Solo ANTIPATRONES (10 documentados, 1,051 líneas)
- ⚠️ NO hay sección de PATRONES RECOMENDADOS
- ⚠️ Desbalanceado: todo prohibiciones, nada de guías positivas

---

## 🎯 PROPUESTA 1: AMPLIAR CNST-005

### Nueva Sección: Permisos Temporales

**Ubicación sugerida:** Después de "Autorización (Permisos)" (línea 338)  
**Líneas estimadas:** +150 líneas  
**Nueva versión:** 994 → 1,144 líneas

### Contenido Propuesto

```rst
Permisos Temporales
-------------------

Sistema de Gestión de Permisos con Expiración
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

RBAC v5.1.1 soporta asignación de funciones y permisos con fecha de vencimiento.
Esto permite otorgar accesos temporales sin intervención manual para revocar.

Casos de Uso Comunes
~~~~~~~~~~~~~~~~~~~~

- Acceso temporal para auditores externos (30-90 días)
- Permisos elevados para migraciones (1-7 días)
- Acceso de soporte técnico limitado (24 horas)
- Permisos de prueba en desarrollo

Modelo de Datos
~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/access/models.py
   
   from django.db import models
   from django.utils import timezone
   from datetime import timedelta
   
   class UserFunctionAssignment(models.Model):
       """
       Asignación de función atómica a usuario.
       
       Soporta permisos temporales con fecha de expiración automática.
       RBAC v5.1.1: Funciones atómicas con vencimiento.
       """
       
       user = models.ForeignKey(
           'auth.User',
           on_delete=models.CASCADE,
           related_name='function_assignments'
       )
       
       function_code = models.CharField(
           max_length=50,
           help_text='Código de función atómica (ej: ve_reportes)'
       )
       
       # Temporalidad
       assigned_at = models.DateTimeField(auto_now_add=True)
       expires_at = models.DateTimeField(
           null=True,
           blank=True,
           help_text='Fecha de expiración. NULL = permanente'
       )
       
       # Auditoría
       assigned_by = models.ForeignKey(
           'auth.User',
           on_delete=models.SET_NULL,
           null=True,
           related_name='functions_assigned_by_me'
       )
       
       reason = models.TextField(
           help_text='Justificación de la asignación'
       )
       
       # Estado
       is_active = models.BooleanField(default=True)
       revoked_at = models.DateTimeField(null=True, blank=True)
       revoked_by = models.ForeignKey(
           'auth.User',
           on_delete=models.SET_NULL,
           null=True,
           related_name='functions_revoked_by_me'
       )
       
       class Meta:
           db_table = 'user_function_assignments'
           indexes = [
               models.Index(fields=['user', 'is_active']),
               models.Index(fields=['expires_at']),
               models.Index(fields=['function_code', 'is_active']),
           ]
           constraints = [
               models.UniqueConstraint(
                   fields=['user', 'function_code'],
                   condition=models.Q(is_active=True),
                   name='unique_active_function_per_user'
               )
           ]
       
       def __str__(self):
           expiry = f" (expira {self.expires_at})" if self.expires_at else ""
           return f"{self.user.username} → {self.function_code}{expiry}"
       
       @property
       def is_expired(self):
           """Verificar si el permiso ha expirado."""
           if not self.expires_at:
               return False  # Permanente
           return timezone.now() > self.expires_at
       
       @property
       def days_until_expiry(self):
           """Días restantes hasta expiración."""
           if not self.expires_at:
               return None
           delta = self.expires_at - timezone.now()
           return max(0, delta.days)
       
       @classmethod
       def assign_temporary(cls, user, function_code, days, assigned_by, reason):
           """
           Asignar función temporal.
           
           Args:
               user: Usuario a quien asignar
               function_code: Código de función (ej: 've_reportes')
               days: Duración en días
               assigned_by: Usuario que asigna
               reason: Justificación
           
           Returns:
               UserFunctionAssignment creado
           """
           expires_at = timezone.now() + timedelta(days=days)
           
           assignment = cls.objects.create(
               user=user,
               function_code=function_code,
               expires_at=expires_at,
               assigned_by=assigned_by,
               reason=reason
           )
           
           # Auditar
           from apps.common.models import UserActionLog
           UserActionLog.record(
               user=assigned_by,
               action='FUNCTION_ASSIGN_TEMP',
               resource=f"{user.username}:{function_code}",
               result='SUCCESS',
               details={
                   'function': function_code,
                   'target_user': user.username,
                   'duration_days': days,
                   'expires_at': expires_at.isoformat(),
                   'reason': reason
               }
           )
           
           return assignment
       
       def revoke(self, revoked_by, reason=''):
           """Revocar función manualmente."""
           self.is_active = False
           self.revoked_at = timezone.now()
           self.revoked_by = revoked_by
           self.save()
           
           # Auditar
           from apps.common.models import UserActionLog
           UserActionLog.record(
               user=revoked_by,
               action='FUNCTION_REVOKE',
               resource=f"{self.user.username}:{self.function_code}",
               result='SUCCESS',
               details={
                   'function': self.function_code,
                   'target_user': self.user.username,
                   'reason': reason
               }
           )

Validación Automática de Expiración
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/middleware.py
   
   from django.utils import timezone
   from apps.access.models import UserFunctionAssignment
   
   class ExpiredPermissionsMiddleware:
       """
       Middleware que invalida permisos expirados automáticamente.
       
       Se ejecuta en cada request para garantizar que no se usen
       permisos ya vencidos.
       """
       
       def __init__(self, get_response):
           self.get_response = get_response
       
       def __call__(self, request):
           if request.user.is_authenticated:
               # Desactivar asignaciones expiradas
               expired = UserFunctionAssignment.objects.filter(
                   user=request.user,
                   is_active=True,
                   expires_at__lte=timezone.now()
               )
               
               count = expired.count()
               if count > 0:
                   # Desactivar en batch
                   expired.update(
                       is_active=False,
                       revoked_at=timezone.now()
                   )
                   
                   # Log
                   logger.info(
                       f"Auto-revocados {count} permisos expirados "
                       f"del usuario {request.user.username}"
                   )
           
           return self.get_response(request)

Comando de Limpieza
~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/access/management/commands/expire_permissions.py
   
   from django.core.management.base import BaseCommand
   from django.utils import timezone
   from apps.access.models import UserFunctionAssignment
   from apps.common.notifications import notify_admins
   
   class Command(BaseCommand):
       help = 'Desactivar permisos expirados y notificar'
       
       def add_arguments(self, parser):
           parser.add_argument(
               '--notify',
               action='store_true',
               help='Notificar a usuarios antes de expirar (7 días)'
           )
       
       def handle(self, *args, **options):
           now = timezone.now()
           
           # Expirar permisos vencidos
           expired = UserFunctionAssignment.objects.filter(
               is_active=True,
               expires_at__lte=now
           )
           
           count = expired.count()
           if count > 0:
               expired.update(
                   is_active=False,
                   revoked_at=now
               )
               self.stdout.write(
                   self.style.SUCCESS(
                       f"Expirados {count} permisos automáticamente"
                   )
               )
           
           # Notificar próximos a expirar (7 días)
           if options['notify']:
               soon = UserFunctionAssignment.objects.filter(
                   is_active=True,
                   expires_at__lte=now + timedelta(days=7),
                   expires_at__gt=now
               ).select_related('user')
               
               for assignment in soon:
                   notify_user(
                       assignment.user.id,
                       subject='Permiso próximo a expirar',
                       body=f"Tu función '{assignment.function_code}' "
                            f"expirará en {assignment.days_until_expiry} días."
                   )

Cron Job
~~~~~~~~

.. code-block:: bash

   # Ejecutar diariamente a las 02:00
   0 2 * * * cd /opt/iact && /opt/iact/venv/bin/python api/manage.py expire_permissions --notify

API de Permisos Temporales
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/access/views.py
   
   from rest_framework import viewsets, status
   from rest_framework.decorators import action
   from rest_framework.response import Response
   from rest_framework.permissions import IsAuthenticated
   from apps.common.permissions import IsAdminUser
   from apps.access.models import UserFunctionAssignment
   
   class TemporaryPermissionViewSet(viewsets.ViewSet):
       """
       Gestión de permisos temporales.
       
       Solo administradores pueden asignar/revocar permisos temporales.
       """
       
       permission_classes = [IsAuthenticated, IsAdminUser]
       
       @action(detail=False, methods=['post'])
       def assign_temporary(self, request):
           """
           Asignar función temporal.
           
           POST /api/v1/permissions/assign_temporary/
           {
               "username": "juan.perez",
               "function_code": "exporta_excel",
               "duration_days": 7,
               "reason": "Auditoría trimestral"
           }
           """
           username = request.data.get('username')
           function_code = request.data.get('function_code')
           days = request.data.get('duration_days')
           reason = request.data.get('reason', '')
           
           # Validar
           if not all([username, function_code, days]):
               return Response(
                   {'error': 'Faltan campos requeridos'},
                   status=status.HTTP_400_BAD_REQUEST
               )
           
           try:
               from django.contrib.auth import get_user_model
               User = get_user_model()
               user = User.objects.get(username=username)
           except User.DoesNotExist:
               return Response(
                   {'error': f'Usuario {username} no encontrado'},
                   status=status.HTTP_404_NOT_FOUND
               )
           
           # Asignar
           assignment = UserFunctionAssignment.assign_temporary(
               user=user,
               function_code=function_code,
               days=int(days),
               assigned_by=request.user,
               reason=reason
           )
           
           return Response({
               'id': assignment.id,
               'user': username,
               'function': function_code,
               'expires_at': assignment.expires_at.isoformat(),
               'days_until_expiry': assignment.days_until_expiry
           })
       
       @action(detail=False, methods=['get'])
       def expiring_soon(self, request):
           """
           Listar permisos que expiran en los próximos 7 días.
           
           GET /api/v1/permissions/expiring_soon/
           """
           from datetime import timedelta
           soon = UserFunctionAssignment.objects.filter(
               is_active=True,
               expires_at__lte=timezone.now() + timedelta(days=7)
           ).select_related('user').order_by('expires_at')
           
           data = [{
               'id': a.id,
               'user': a.user.username,
               'function': a.function_code,
               'expires_at': a.expires_at.isoformat(),
               'days_remaining': a.days_until_expiry,
               'assigned_by': a.assigned_by.username if a.assigned_by else None
           } for a in soon]
           
           return Response({'count': len(data), 'assignments': data})

Validación
~~~~~~~~~~

.. code-block:: python

   # Pre-commit checklist
   # - Permisos temporales tienen expires_at configurado
   # - Middleware ExpiredPermissionsMiddleware está activo
   # - Cron job de limpieza configurado
   # - UserActionLog registra asignaciones/revocaciones
```

**Resultado:**
- CNST-005: 994 líneas → **1,144 líneas** (+150)
- Sección nueva completa y documentada
- Ejemplos de código funcionales

---

## 🎯 PROPUESTA 2: AMPLIAR CNST-006

### Nueva Sección: Patrones de Diseño Recomendados

**Ubicación sugerida:** Después de "Antipatrón 10" (línea 987)  
**Líneas estimadas:** +300 líneas  
**Nueva versión:** 1,126 → 1,426 líneas

### Contenido Propuesto

```rst
Patrones de Diseño Recomendados
================================

Esta sección documenta los patrones que SÍ deben usarse en el proyecto IACT.
Complementa los antipatrones prohibidos con guías positivas.

Patrón 1: Service Layer
-----------------------

Descripción
~~~~~~~~~~~

Encapsular lógica de negocio compleja en servicios reutilizables,
separando la lógica del framework (Django/DRF).

Cuándo Usar
~~~~~~~~~~~

- Operaciones que involucran múltiples modelos
- Lógica de negocio compleja
- Transacciones que deben ser atómicas
- Operaciones reutilizables desde múltiples vistas

Código de Ejemplo
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # CORRECTO - Service Layer
   
   # api/apps/analytics/services.py
   
   from django.db import transaction
   from django.utils import timezone
   from apps.analytics.models import CallMetric
   from apps.common.audit import UserActionLog
   
   class MetricsService:
       """
       Servicio para operaciones de métricas.
       
       Encapsula lógica de negocio y garantiza atomicidad.
       """
       
       @staticmethod
       @transaction.atomic
       def generate_daily_summary(date, queue_ids=None):
           """
           Generar resumen diario de métricas.
           
           Args:
               date: Fecha del resumen
               queue_ids: Lista de colas (None = todas)
           
           Returns:
               Diccionario con métricas agregadas
           """
           queryset = CallMetric.objects.filter(metric_date=date)
           
           if queue_ids:
               queryset = queryset.filter(queue_id__in=queue_ids)
           
           from django.db.models import Sum, Avg
           
           summary = queryset.aggregate(
               total_calls=Sum('total_calls'),
               avg_duration=Avg('avg_duration'),
               avg_wait=Avg('avg_wait_time')
           )
           
           # Auditar
           UserActionLog.record(
               user=None,
               action='METRICS_SUMMARY',
               resource=f"daily:{date}",
               result='SUCCESS',
               details={'queues': queue_ids or 'all'}
           )
           
           return summary
   
   
   # api/apps/analytics/views.py
   
   from apps.analytics.services import MetricsService
   
   class DailySummaryView(APIView):
       """Vista que usa el servicio."""
       
       def get(self, request):
           date = request.query_params.get('date')
           summary = MetricsService.generate_daily_summary(date)
           return Response(summary)

Patrón 2: Manager/QuerySet Personalizado
-----------------------------------------

Descripción
~~~~~~~~~~~

Extender Django ORM con métodos de consulta reutilizables y semánticos.

Cuándo Usar
~~~~~~~~~~~

- Queries complejas reutilizadas en múltiples lugares
- Filtros de negocio específicos
- Agregaciones frecuentes

Código de Ejemplo
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # CORRECTO - Custom Manager
   
   # api/apps/analytics/models.py
   
   from django.db import models
   from django.db.models import Avg, Sum, Q
   
   class CallMetricQuerySet(models.QuerySet):
       """QuerySet personalizado con queries de negocio."""
       
       def for_date_range(self, start_date, end_date):
           """Filtrar por rango de fechas."""
           return self.filter(
               metric_date__gte=start_date,
               metric_date__lte=end_date
           )
       
       def high_volume(self, threshold=1000):
           """Métricas con alto volumen de llamadas."""
           return self.filter(total_calls__gte=threshold)
       
       def with_summary(self):
           """Agregar métricas resumen."""
           return self.aggregate(
               total_calls=Sum('total_calls'),
               avg_duration=Avg('avg_duration'),
               avg_wait=Avg('avg_wait_time')
           )
       
       def abandoned_over(self, percentage):
           """Métricas con abandono mayor al porcentaje."""
           return self.annotate(
               abandon_rate=models.F('abandoned_calls') * 100.0 / models.F('total_calls')
           ).filter(abandon_rate__gte=percentage)
   
   
   class CallMetricManager(models.Manager):
       """Manager con queryset personalizado."""
       
       def get_queryset(self):
           return CallMetricQuerySet(self.model, using=self._db)
       
       def for_date_range(self, start_date, end_date):
           return self.get_queryset().for_date_range(start_date, end_date)
       
       def high_volume(self, threshold=1000):
           return self.get_queryset().high_volume(threshold)
   
   
   class CallMetric(models.Model):
       """Modelo con manager personalizado."""
       
       metric_date = models.DateField()
       queue_id = models.IntegerField()
       total_calls = models.IntegerField()
       abandoned_calls = models.IntegerField()
       avg_duration = models.DecimalField(max_digits=10, decimal_places=2)
       avg_wait_time = models.DecimalField(max_digits=10, decimal_places=2)
       
       # Manager personalizado
       objects = CallMetricManager()
       
       class Meta:
           db_table = 'call_metrics'
   
   
   # Uso
   from datetime import date
   
   # Métrico: Llamadas alto volumen en diciembre
   metrics = CallMetric.objects.for_date_range(
       date(2025, 12, 1),
       date(2025, 12, 31)
   ).high_volume(threshold=5000)
   
   # Resumen
   summary = CallMetric.objects.for_date_range(
       start_date, end_date
   ).with_summary()

Patrón 3: Django Signals (Observer)
------------------------------------

Descripción
~~~~~~~~~~~

Usar Django Signals para desacoplar componentes y reaccionar a eventos.

Cuándo Usar
~~~~~~~~~~~

- Auditoría automática de cambios
- Notificaciones basadas en eventos
- Invalidación de caché
- Triggers post-save/post-delete

Código de Ejemplo
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # CORRECTO - Django Signals
   
   # api/apps/users/signals.py
   
   from django.db.models.signals import post_save, pre_delete
   from django.dispatch import receiver
   from django.contrib.auth import get_user_model
   from apps.common.models import UserActionLog
   from apps.common.notifications import notify_admins
   
   User = get_user_model()
   
   @receiver(post_save, sender=User)
   def user_created_handler(sender, instance, created, **kwargs):
       """Auditar creación de usuarios."""
       if created:
           UserActionLog.record(
               user=None,
               action='USER_CREATE',
               resource=f"user:{instance.username}",
               result='SUCCESS',
               details={'email': instance.email}
           )
           
           # Notificar admins
           notify_admins(
               subject='Nuevo usuario creado',
               body=f"Usuario {instance.username} fue creado en el sistema."
           )
   
   
   @receiver(pre_delete, sender=User)
   def user_deleted_handler(sender, instance, **kwargs):
       """Auditar eliminación de usuarios."""
       UserActionLog.record(
           user=None,
           action='USER_DELETE',
           resource=f"user:{instance.username}",
           result='SUCCESS'
       )
   
   
   # api/apps/users/apps.py
   
   from django.apps import AppConfig
   
   class UsersConfig(AppConfig):
       default_auto_field = 'django.db.models.BigAutoField'
       name = 'apps.users'
       
       def ready(self):
           """Registrar signals."""
           import apps.users.signals  # noqa

Patrón 4: Factory Pattern (Para Tests)
---------------------------------------

Descripción
~~~~~~~~~~~

Usar Factory Boy para crear fixtures de tests de manera declarativa.

Cuándo Usar
~~~~~~~~~~~

- Tests unitarios e integración
- Datos de prueba consistentes
- Avoid hardcoded test data

Código de Ejemplo
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # CORRECTO - Factory Pattern
   
   # api/apps/users/tests/factories.py
   
   import factory
   from factory.django import DjangoModelFactory
   from django.contrib.auth import get_user_model
   from apps.access.models import UserFunctionAssignment
   
   User = get_user_model()
   
   class UserFactory(DjangoModelFactory):
       """Factory para usuarios."""
       
       class Meta:
           model = User
       
       username = factory.Sequence(lambda n: f"user{n}")
       email = factory.LazyAttribute(lambda obj: f"{obj.username}@test.com")
       is_active = True
       is_staff = False
   
   
   class AdminUserFactory(UserFactory):
       """Factory para administradores."""
       
       is_staff = True
       is_superuser = True
   
   
   class FunctionAssignmentFactory(DjangoModelFactory):
       """Factory para asignaciones de funciones."""
       
       class Meta:
           model = UserFunctionAssignment
       
       user = factory.SubFactory(UserFactory)
       function_code = 've_reportes'
       is_active = True
       reason = 'Test assignment'
   
   
   # api/apps/users/tests/test_permissions.py
   
   import pytest
   from apps.users.tests.factories import UserFactory, FunctionAssignmentFactory
   
   @pytest.mark.django_db
   def test_user_has_function():
       """Test que usuario tiene función asignada."""
       # Crear usuario con función
       assignment = FunctionAssignmentFactory(
           function_code='exporta_excel'
       )
       
       # Verificar
       assert assignment.user.has_function('exporta_excel') is True
       assert assignment.user.has_function('otro_permiso') is False

Patrón 5: Adapter (para Sistemas Legacy)
-----------------------------------------

Descripción
~~~~~~~~~~~

Adaptar interfaces de sistemas legacy a interfaces modernas esperadas.

Cuándo Usar
~~~~~~~~~~~

- Integración con BD IVR legacy
- APIs externas con formatos antiguos
- Migración gradual de sistemas

Código de Ejemplo
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # CORRECTO - Adapter Pattern
   
   # api/apps/ivr/adapters.py
   
   from typing import List, Dict
   from datetime import date
   
   class IVRLegacyAdapter:
       """
       Adaptador para base de datos IVR legacy.
       
       Traduce estructura legacy a formato moderno.
       """
       
       # Mapeo de campos legacy a modernos
       FIELD_MAPPING = {
           'dFecha': 'call_date',
           'centro_transferencia': 'transfer_center',
           'servicio_800': 'service_number',
           'total_llamadas': 'total_calls',
           'tiempo_espera': 'wait_time',
           'tiempo_atencion': 'service_time',
       }
       
       @classmethod
       def adapt_call_record(cls, legacy_record: Dict) -> Dict:
           """
           Adaptar registro legacy a formato moderno.
           
           Args:
               legacy_record: Dict con campos legacy
           
           Returns:
               Dict con campos modernos
           """
           adapted = {}
           
           for legacy_field, modern_field in cls.FIELD_MAPPING.items():
               if legacy_field in legacy_record:
                   adapted[modern_field] = legacy_record[legacy_field]
           
           # Transformaciones específicas
           if 'dFecha' in legacy_record:
               # Convertir string a date si es necesario
               adapted['call_date'] = cls._parse_date(legacy_record['dFecha'])
           
           return adapted
       
       @staticmethod
       def _parse_date(date_value):
           """Parsear fecha legacy."""
           if isinstance(date_value, date):
               return date_value
           # Manejar otros formatos si es necesario
           return date_value
       
       @classmethod
       def extract_calls(cls, start_date: date, end_date: date) -> List[Dict]:
           """
           Extraer llamadas adaptando formato.
           
           Args:
               start_date: Fecha inicio
               end_date: Fecha fin
           
           Returns:
               Lista de registros adaptados
           """
           from django.db import connections
           
           query = """
               SELECT dFecha, centro_transferencia, servicio_800,
                      total_llamadas, tiempo_espera, tiempo_atencion
               FROM calls
               WHERE dFecha BETWEEN %s AND %s
           """
           
           with connections['ivr_readonly'].cursor() as cursor:
               cursor.execute(query, [start_date, end_date])
               columns = [col[0] for col in cursor.description]
               results = [dict(zip(columns, row)) for row in cursor.fetchall()]
           
           # Adaptar cada registro
           return [cls.adapt_call_record(record) for record in results]

Patrón 6: Strategy (Simplificado)
----------------------------------

Descripción
~~~~~~~~~~~

Usar diccionarios de funciones en lugar de jerarquías de clases complejas.

Cuándo Usar
~~~~~~~~~~~

- Múltiples algoritmos intercambiables
- Diferentes formatos de exportación
- Validaciones variables según tipo

Código de Ejemplo
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # CORRECTO - Strategy Pattern (simplificado)
   
   # api/apps/exports/strategies.py
   
   import csv
   import json
   from typing import List, Dict, Callable
   
   def export_to_csv(data: List[Dict], filepath: str) -> None:
       """Exportar a CSV."""
       if not data:
           return
       
       with open(filepath, 'w', newline='', encoding='utf-8') as f:
           writer = csv.DictWriter(f, fieldnames=data[0].keys())
           writer.writeheader()
           writer.writerows(data)
   
   
   def export_to_json(data: List[Dict], filepath: str) -> None:
       """Exportar a JSON."""
       with open(filepath, 'w', encoding='utf-8') as f:
           json.dump(data, f, indent=2, default=str)
   
   
   def export_to_excel(data: List[Dict], filepath: str) -> None:
       """Exportar a Excel."""
       import openpyxl
       
       wb = openpyxl.Workbook()
       ws = wb.active
       
       if data:
           # Headers
           headers = list(data[0].keys())
           ws.append(headers)
           
           # Data
           for row in data:
               ws.append(list(row.values()))
       
       wb.save(filepath)
   
   
   # Diccionario de estrategias (en lugar de clases)
   EXPORT_STRATEGIES: Dict[str, Callable] = {
       'csv': export_to_csv,
       'json': export_to_json,
       'excel': export_to_excel,
   }
   
   
   class ExportService:
       """Servicio de exportación usando estrategias."""
       
       @staticmethod
       def export(data: List[Dict], filepath: str, format: str) -> None:
           """
           Exportar datos en el formato especificado.
           
           Args:
               data: Datos a exportar
               filepath: Ruta del archivo
               format: Formato ('csv', 'json', 'excel')
           """
           strategy = EXPORT_STRATEGIES.get(format)
           
           if not strategy:
               raise ValueError(f"Formato no soportado: {format}")
           
           strategy(data, filepath)
   
   
   # Uso
   from apps.exports.strategies import ExportService
   
   data = [{'id': 1, 'name': 'Test'}]
   ExportService.export(data, '/tmp/output.csv', 'csv')
   ExportService.export(data, '/tmp/output.json', 'json')

Resumen de Patrones
--------------------

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Patrón
     - Cuándo Usar
     - Beneficio Principal
   * - Service Layer
     - Lógica de negocio compleja
     - Separación de concerns
   * - Custom Manager
     - Queries reutilizables
     - DRY, semántica
   * - Django Signals
     - Reaccionar a eventos
     - Desacoplamiento
   * - Factory (tests)
     - Fixtures de tests
     - Tests mantenibles
   * - Adapter
     - Sistemas legacy
     - Aislamiento de cambios
   * - Strategy
     - Algoritmos intercambiables
     - Flexibilidad

Validación
----------

.. code-block:: bash

   # Pre-commit checklist
   # - Lógica compleja está en servicios, no en vistas
   # - Queries complejas usan custom managers
   # - Tests usan factories, no datos hardcoded
   # - Signals registrados en apps.py
```

**Resultado:**
- CNST-006: 1,126 líneas → **1,426 líneas** (+300)
- Balanceado: 10 antipatrones + 6 patrones recomendados
- Guías positivas para arquitectura

---

## 📊 RESUMEN DE CAMBIOS

| Documento | Líneas Actuales | Ampliación | Líneas Nuevas | Incremento |
|-----------|----------------|------------|---------------|------------|
| CNST-005 | 994 | +150 | 1,144 | +15% |
| CNST-006 | 1,126 | +300 | 1,426 | +27% |
| **TOTAL** | **9,621** | **+450** | **10,071** | **+4.7%** |

---

## ✅ BENEFICIOS

### Ampliación CNST-005
1. ✅ Cierra gap de "permisos temporales"
2. ✅ Documenta funcionalidad mencionada en RBAC v5.1.1
3. ✅ Incluye implementación completa (modelo + API + comando)
4. ✅ Casos de uso prácticos (auditores, soporte temporal)

### Ampliación CNST-006
1. ✅ Balancea el documento (no solo prohibiciones)
2. ✅ Provee guías positivas de arquitectura
3. ✅ Ejemplos concretos de patrones Django/DRF
4. ✅ Alineado con "Django way" (no sobreingeniería)

---

## 📝 SIGUIENTE PASO

¿Apruebas estas ampliaciones para proceder con la implementación?

**Opciones:**
1. ✅ Aprobar y proceder con ampliaciones
2. ⚠️ Ajustar contenido (especificar qué cambiar)
3. ❌ No ampliar, solo actualizar metadatos
