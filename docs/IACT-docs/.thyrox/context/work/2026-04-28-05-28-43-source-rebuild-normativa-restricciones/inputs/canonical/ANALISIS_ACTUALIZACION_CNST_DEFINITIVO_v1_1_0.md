

cat > /tmp/ << 'ENDOFPART1'
# 📊 ANÁLISIS DEFINITIVO DE ACTUALIZACIÓN CNST v1.0.0 → v1.1.0
## Sistema IACT - IVR Analytics & Customer Tracking

**Fecha del Análisis:** 2026-01-03  
**Versión Origen:** 1.0.0 (CONGELADO, 2025-12-17)  
**Versión Destino:** 1.1.0 (VIGENTE, 2026-01-03)  
**Documentos Base:**
- REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md (1,130 líneas)
- MODELO_RBAC_IACT_v5_1_1.md (1,655 líneas)
- RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md (1,136 líneas - Referencia)

---

## 🎯 RESUMEN EJECUTIVO

### Situación Actual

**10 documentos CNST** en estado CONGELADO desde 2025-12-17:

| Documento | Líneas | Estado | Última Actualización |
|-----------|--------|--------|---------------------|
| CNST-001 | 685 | CONGELADO | 2025-12-17 |
| CNST-002 | 840 | CONGELADO | 2025-12-17 |
| CNST-003 | 901 | CONGELADO | 2025-12-17 |
| CNST-004 | 920 | CONGELADO | 2025-12-17 |
| CNST-005 | 994 | CONGELADO | 2025-12-17 |
| CNST-006 | 1,126 | CONGELADO | 2025-12-17 |
| CNST-007 | 1,061 | CONGELADO | 2025-12-17 |
| CNST-008 | 1,019 | CONGELADO | 2025-12-17 |
| CNST-009 | 1,077 | CONGELADO | 2025-12-17 |
| CNST-010 | 998 | CONGELADO | 2025-12-17 |
| **TOTAL** | **9,621** | - | - |

### Problemas Identificados

#### 1. Desactualización de Referencias RBAC

**Problema:** Los CNST referencian RBAC v4.0 (18 roles) cuando el modelo actual es v5.1.1 (44 funciones atómicas).

**Documentos afectados:**
- CNST-001 (línea 638): "Modelo RBAC IACT v4.0"
- CNST-005 (línea 945): "Modelo RBAC IACT v4.0"
- CNST-006 (línea 1082): "Modelo RBAC IACT v4.0"
- CNST-010 (línea 950): "Modelo RBAC IACT v4.0"

#### 2. Sistema de Permisos Obsoleto

**Problema:** Los CNST usan sistema basado en roles fijos (R001-R018) cuando RBAC v5.1.1 usa funciones atómicas.

**Cambio arquitectónico requerido:**

```python
# ANTES (v4.0 - Basado en roles)
class HasRole(permissions.BasePermission):
    ALLOWED_ROLES = ['R004', 'R005', 'R007', 'R015']
    
    def has_permission(self, request, view):
        user_roles = get_user_roles(request.user)
        return any(role in user_roles for role in self.ALLOWED_ROLES)

# DESPUÉS (v5.1.1 - Basado en funciones atómicas)
class HasFunction(permissions.BasePermission):
    required_functions = ['ve_reportes']  # Funciones del catálogo de 44
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        from apps.access.models import UserFunctionAssignment
        user_functions = UserFunctionAssignment.get_user_functions(request.user)
        return any(func in user_functions for func in required_functions)
```

**Documentos afectados:**
- CNST-005 (líneas 220-337): Permisos DRF hardcoded con roles
- CNST-010 (líneas 180-194): Matriz ACCESS_MATRIX basada en roles
- CNST-006 (líneas 940-947): Ejemplos con roles

#### 3. Desalineamiento Tabla CNST en RBAC v5.1.1

**Problema:** La tabla de CNST en RBAC v5.1.1 (líneas 54-64) menciona 8 restricciones con descripciones INCORRECTAS:

| CNST | Descripción en RBAC v5.1.1 | CNST Real | Error |
|------|---------------------------|-----------|-------|
| CNST_001 | NO email | ✅ CORRECTO | - |
| CNST_002 | Sesión única, 15 min | ✅ CORRECTO | - |
| CNST_003 | BD IVR solo lectura | ✅ CORRECTO | - |
| CNST_004 | "Alertas solo buzón interno" | ❌ ETL cada 6-12 horas | **INCORRECTO** |
| CNST_005 | Flat RBAC, SoD, permisos | ✅ CORRECTO | - |
| CNST_006 | "Reportes: rango máx 2 años" | ❌ Antipatrones prohibidos | **INCORRECTO** |
| CNST_007 | Límites exportación | ✅ CORRECTO | - |
| CNST_008 | "Audit inmutable" | ❌ Infraestructura Apache | **INCORRECTO** |
| CNST_009 | - | Logging y Auditoría | **NO MENCIONADO** |
| CNST_010 | - | Clasificación de Datos | **NO MENCIONADO** |

**Conclusión:** La tabla en RBAC v5.1.1 necesita corrección, pero esto NO afecta la actualización de los CNST. Los CNST son la fuente de verdad.

#### 4. Documento Maestro NO Utilizable

**Problema:** El documento `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` tiene:

1. **EMOJIS:** ❌, ✅, ⚠️, 📜, 🔴, 🎯, etc.
   - VIOLACIÓN: Los CNST NO deben usar emojis

2. **Referencias externas:**
   - Línea 1124: "NIST RBAC: Modelo de roles"
   - Línea 1125: "OWASP Top 10: Vulnerabilidades comunes"
   - Línea 1126: "Django Security: Best practices oficiales"
   - VIOLACIÓN: Los CNST no deben referenciar estándares externos

3. **Fecha anterior:**
   - Maestro: 21 Octubre 2025
   - CNST: 2025-12-17
   - Inconsistencia temporal

**Conclusión:** Este documento NO debe usarse como fuente para actualizar los CNST. Es un documento de marketing/presentación, NO técnico.

---

## 📋 MODELO RBAC v5.1.1 - ESTRUCTURA CORRECTA

### 44 Funciones Atómicas Distribuidas en 8 Módulos

| Módulo | Código | Funciones | Ejemplos |
|--------|--------|-----------|----------|
| **MOD_Auth** | AUT | 4 | `gestiona_sesiones`, `cierra_sesion_usuario`, `resetea_password` |
| **MOD_Users** | USR | 10 | `crea_usuarios`, `ve_usuarios`, `modifica_usuarios`, `elimina_usuarios` |
| **MOD_Access** | ACC | 6 | `asigna_funciones`, `revoca_funciones`, `ve_asignaciones` |
| **MOD_Pipeline** | PIP | 4 | `supervisa_etl`, `ejecuta_etl`, `configura_etl` |
| **MOD_Reports** | RPT | 8 | `ve_reportes`, `genera_reporte`, `exporta_csv`, `exporta_excel` |
| **MOD_Alerts** | ALR | 6 | `crea_alertas`, `notifica_usuario`, `gestiona_alertas` |
| **MOD_Audit** | AUD | 4 | `consulta_auditoria`, `exporta_audit` |
| **MOD_Logs** | LOG | 2 | `consulta_logs`, `exporta_logs` |
| **TOTAL** | - | **44** | - |

### Principio "Sin Pretensiones"

> **Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona**

**Ejemplos:**

❌ INCORRECTO (con pretensiones):
- `USERS_FULL_MANAGER` → Define QUÉ ES la persona
- `SYSTEM_ADMIN` → Cargo jerárquico
- `REPORTS_VIEWER` → Rol/título

✅ CORRECTO (sin pretensiones):
- `crea_usuarios` → Describe QUÉ PUEDE HACER
- `ve_reportes` → Acción concreta
- `exporta_csv` → Capacidad específica

---

ENDOFPART1

wc -l /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
echo "Parte 1 generada. Continuando..."
Output

153 /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
Parte 1 generada. Continuando...


cat >> /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md << 'ENDOFPART2'
## 📝 CAMBIOS DETALLADOS POR DOCUMENTO

### CNST-001: Comunicaciones Prohibidas

**Líneas:** 685 → 688 (+3)  
**Impacto:** BAJO  
**Prioridad:** MEDIA

**Cambios Obligatorios:**

1. **Metadatos:**
   ```rst
   :Versión: 1.0.0 → 1.1.0
   :Fecha: 2025-12-17 → 2026-01-03
   :Estado: Vigente → VIGENTE
   ```

2. **Línea 638 - Referencias RBAC:**
   ```rst
   # ANTES
   - Modelo RBAC IACT v4.0 (18 roles funcionales)
   
   # DESPUÉS
   - Modelo RBAC IACT v5.1.1 (44 funciones atómicas)
   ```

3. **Función notify_by_role() → notify_by_function():**
   ```python
   # ANTES
   def notify_by_role(role_id, subject, body, priority='NORMAL'):
       from apps.users.models import UserRole
       user_roles = UserRole.objects.filter(
           role_id=role_id, is_active=True
       ).select_related('user')
   
   # DESPUÉS
   def notify_by_function(function_code, subject, body, priority='NORMAL'):
       from apps.access.models import UserFunctionAssignment
       assignments = UserFunctionAssignment.objects.filter(
           function_code=function_code, is_active=True
       ).select_related('user')
   ```

4. **Historial de Cambios:**
   Agregar entrada v1.1.0:
   ```rst
   * - 1.1.0
     - 2026-01-03
     - Actualización a RBAC v5.1.1. Función notify_by_function
     - Equipo IACT
   ```

---

### CNST-002: Gestión de Sesiones en BD

**Líneas:** 840 → 841 (+1)  
**Impacto:** BAJO  
**Prioridad:** BAJA

**Cambios Obligatorios:**

1. **Metadatos:**
   ```rst
   :Versión: 1.0.0 → 1.1.0
   :Fecha: 2025-12-17 → 2026-01-03
   :Estado: Vigente → VIGENTE
   ```

2. **Historial de Cambios:**
   ```rst
   * - 1.1.0
     - 2026-01-03
     - Actualización a RBAC v5.1.1
     - Equipo IACT
   ```

3. **Función RBAC referenciada:**
   - En comentarios/documentación: `administra_sistema` (en lugar de rol R015)

**Nota:** Este documento está muy bien alineado, solo requiere metadatos.

---

### CNST-003: Base de Datos Dual con Inmutabilidad IVR

**Líneas:** 901 → 902 (+1)  
**Impacto:** BAJO  
**Prioridad:** BAJA

**Cambios Obligatorios:**

1. **Metadatos:**
   ```rst
   :Versión: 1.0.0 → 1.1.0
   :Fecha: 2025-12-17 → 2026-01-03
   :Estado: Vigente → VIGENTE
   ```

2. **Historial de Cambios:**
   ```rst
   * - 1.1.0
     - 2026-01-03
     - Actualización a RBAC v5.1.1
     - Equipo IACT
   ```

3. **Función RBAC referenciada:**
   - UC-035 Ejecutar ETL: `ejecuta_etl` (MOD_Pipeline)
   - Extracción de datos: `extrae_datos_ivr` (implícita en MOD_Pipeline)

---

### CNST-004: Actualización de Datos mediante ETL

**Líneas:** 920 → 921 (+1)  
**Impacto:** BAJO  
**Prioridad:** BAJA

**Cambios Obligatorios:**

1. **Metadatos:**
   ```rst
   :Versión: 1.0.0 → 1.1.0
   :Fecha: 2025-12-17 → 2026-01-03
   :Estado: Vigente → VIGENTE
   ```

2. **Historial de Cambios:**
   ```rst
   * - 1.1.0
     - 2026-01-03
     - Actualización a RBAC v5.1.1
     - Equipo IACT
   ```

3. **Funciones RBAC referenciadas:**
   - `supervisa_etl` (MOD_Pipeline - PIP-001)
   - `ejecuta_etl` (MOD_Pipeline - PIP-002)
   - `configura_etl` (MOD_Pipeline - PIP-003)

---

### CNST-005: Seguridad Django REST Framework ⚠️ CRÍTICO

**Líneas:** 994 → 1,339 (+345)  
**Impacto:** ALTO - Cambio Arquitectónico  
**Prioridad:** 🔴 CRÍTICA

**Cambios Arquitectónicos Mayores:**

#### 1. Metadatos
```rst
:Versión: 1.0.0 → 1.1.0
:Fecha: 2025-12-17 → 2026-01-03
:Estado: Vigente → VIGENTE
```

#### 2. Sistema de Permisos (Líneas 220-337)

**REEMPLAZO COMPLETO del sistema de permisos:**

**ANTES (basado en roles):**
```python
# api/apps/common/permissions.py

class HasRole(permissions.BasePermission):
    """
    Permiso basado en roles RBAC v4.0 (OBSOLETO).
    """
    ALLOWED_ROLES = ['R004', 'R005', 'R007', 'R015']
    
    def has_permission(self, request, view):
        user_roles = get_user_roles(request.user)
        return any(role in user_roles for role in self.ALLOWED_ROLES)


class IsReportsViewer(permissions.BasePermission):
    """Permiso para ver reportes."""
    ALLOWED_ROLES = ['R004', 'R005', 'R007', 'R010', 'R015']
    
    def has_permission(self, request, view):
        return HasRole.check_roles(request.user, self.ALLOWED_ROLES)
```

**DESPUÉS (basado en funciones atómicas):**
```python
# api/apps/common/permissions.py

from rest_framework import permissions
from apps.access.models import UserFunctionAssignment


class HasFunction(permissions.BasePermission):
    """
    Permiso basado en función atómica RBAC v5.1.1.
    
    Uso:
        class ReportView(APIView):
            permission_classes = [IsAuthenticated, HasFunction]
            required_functions = ['ve_reportes']
    
    Catálogo de funciones:
        - ve_reportes (MOD_Reports - RPT-001)
        - exporta_csv (MOD_Reports - RPT-003)
        - exporta_excel (MOD_Reports - RPT-004)
        - administra_sistema (implícito en superuser)
    """
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        required_functions = getattr(view, 'required_functions', [])
        if not required_functions:
            return True  # Sin restricción específica
        
        user_functions = UserFunctionAssignment.get_user_functions(request.user)
        return any(func in user_functions for func in required_functions)


class CanViewReports(permissions.BasePermission):
    """
    Permiso para ver reportes.
    
    Compatible con RBAC v5.1.1 (MOD_Reports).
    Requiere función: ve_reportes
    """
    REQUIRED_FUNCTION = 've_reportes'
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        from apps.access.models import UserFunctionAssignment
        return UserFunctionAssignment.user_has_function(
            request.user,
            self.REQUIRED_FUNCTION
        )


class CanExportData(permissions.BasePermission):
    """
    Permiso para exportar datos (CSV/Excel).
    
    Compatible con RBAC v5.1.1 (MOD_Reports).
    Requiere una de las funciones de exportación.
    """
    REQUIRED_FUNCTIONS = ['exporta_csv', 'exporta_excel']
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        from apps.access.models import UserFunctionAssignment
        user_functions = UserFunctionAssignment.get_user_functions(request.user)
        return any(func in user_functions for func in self.REQUIRED_FUNCTIONS)


# Adaptador de compatibilidad (DEPRECATED)
class HasRole(permissions.BasePermission):
    """
    DEPRECATED: Usar HasFunction en su lugar.
    
    Adaptador para compatibilidad con código legacy RBAC v4.0.
    Será removido en v2.0.0.
    """
    
    def has_permission(self, request, view):
        import warnings
        warnings.warn(
            "HasRole está deprecado. Migrar a HasFunction (RBAC v5.1.1).",
            DeprecationWarning,
            stacklevel=2
        )
        
        required_roles = getattr(view, 'required_roles', [])
        from apps.common.adapters import LegacyRoleAdapter
        return all(
            LegacyRoleAdapter.has_role(request.user, role)
            for role in required_roles
        )
```

#### 3. NUEVA SECCIÓN: Permisos Temporales (+~345 líneas)

Agregar DESPUÉS de la sección de Throttling (línea 338):

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
       
       @property
       def is_expired(self):
           """Verificar si el permiso ha expirado."""
           if not self.expires_at:
               return False
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

[... continuar con Middleware, Comando, API REST, etc. - 345 líneas total ...]
```

#### 4. Actualizar Referencias

- Línea 945: `RBAC v4.0` → `RBAC v5.1.1`
- Todos los ejemplos usan funciones, no roles

---

ENDOFPART2

wc -l /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
echo "Parte 2 agregada. Continuando..."
Output

623 /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
Parte 2 agregada. Continuando...

cat >> /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md << 'ENDOFPART3'
### CNST-006: Antipatrones de Arquitectura Prohibidos ⚠️ CRÍTICO

**Líneas:** 1,126 → 1,703 (+577)  
**Impacto:** ALTO - Ampliación Mayor  
**Prioridad:** 🔴 CRÍTICA

**Cambios:**

#### 1. Metadatos
```rst
:Versión: 1.0.0 → 1.1.0
:Fecha: 2025-12-17 → 2026-01-03
:Estado: Vigente → VIGENTE
```

#### 2. Actualizar Ejemplos (Líneas 940-947)

**ANTES:**
```python
class RolePermissions:
    REPORT_VIEWERS = ['R004', 'R005']
    DATA_ANALYSTS = ['R010', 'R015']
```

**DESPUÉS:**
```python
class FunctionPermissions:
    REPORT_VIEWERS = ['ve_reportes', 've_dashboard']
    DATA_ANALYSTS = ['analiza_datos', 'exporta_excel']
```

#### 3. NUEVA SECCIÓN: Patrones de Diseño Recomendados (+~577 líneas)

Agregar ANTES de la sección de Aprobaciones (línea 1106):

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
- Transacciones atómicas
- Operaciones que requieren auditoría

Implementación Correcta
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/analytics/services.py
   
   from django.db import transaction
   from apps.analytics.models import CallMetric
   from apps.ivr.models import IVRCall
   from datetime import date
   
   class MetricsService:
       """
       Servicio para procesamiento de métricas.
       
       Encapsula lógica de negocio separada de vistas y modelos.
       """
       
       @staticmethod
       @transaction.atomic
       def generate_daily_summary(metric_date: date):
           """
           Generar resumen diario de métricas.
           
           Args:
               metric_date: Fecha del resumen
           
           Returns:
               CallMetric creado
           """
           # Extraer datos de IVR
           calls = IVRCall.objects.filter(
               call_date__date=metric_date
           )
           
           total_calls = calls.count()
           completed = calls.filter(outcome='COMPLETED').count()
           abandoned = calls.filter(outcome='ABANDONED').count()
           
           avg_duration = calls.aggregate(
               avg=Avg('call_duration')
           )['avg'] or 0
           
           # Crear o actualizar métrica
           metric, created = CallMetric.objects.update_or_create(
               metric_date=metric_date,
               defaults={
                   'total_calls': total_calls,
                   'completed_calls': completed,
                   'abandoned_calls': abandoned,
                   'avg_duration': avg_duration
               }
           )
           
           return metric

Patrón 2: Custom Manager/QuerySet
----------------------------------

Descripción
~~~~~~~~~~~

Encapsular queries complejos en managers personalizados para reutilización.

Implementación Correcta
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/analytics/models.py
   
   from django.db import models
   from django.db.models import Q, Avg, Sum
   from datetime import timedelta
   
   class CallMetricQuerySet(models.QuerySet):
       """QuerySet personalizado para CallMetric."""
       
       def for_date_range(self, start_date, end_date):
           """Filtrar por rango de fechas."""
           return self.filter(
               metric_date__range=(start_date, end_date)
           ).order_by('metric_date')
       
       def high_volume(self, threshold=1000):
           """Filtrar días con alto volumen de llamadas."""
           return self.filter(total_calls__gte=threshold)
       
       def with_summary(self):
           """Anotar con estadísticas agregadas."""
           return self.annotate(
               total=Sum('total_calls'),
               avg_duration_overall=Avg('avg_duration')
           )
       
       def abandoned_over(self, percentage):
           """Días con abandono mayor a X%."""
           return self.filter(
               abandoned_calls__gt=F('total_calls') * percentage / 100
           )
   
   class CallMetricManager(models.Manager):
       """Manager personalizado."""
       
       def get_queryset(self):
           return CallMetricQuerySet(self.model, using=self._db)
       
       def for_date_range(self, start_date, end_date):
           return self.get_queryset().for_date_range(start_date, end_date)
   
   class CallMetric(models.Model):
       # ... campos ...
       
       objects = CallMetricManager()
       
       class Meta:
           db_table = 'call_metrics'

Patrón 3: Django Signals
-------------------------

Descripción
~~~~~~~~~~~

Usar signals para desacoplar acciones relacionadas.

Implementación Correcta
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/users/signals.py
   
   from django.db.models.signals import post_save, pre_delete
   from django.dispatch import receiver
   from django.contrib.auth import get_user_model
   from apps.common.models import UserActionLog
   from apps.common.notifications import notify_admins
   
   User = get_user_model()
   
   @receiver(post_save, sender=User)
   def user_created_handler(sender, instance, created, **kwargs):
       """
       Auditar creación de usuarios.
       
       CNST-009: Auditoría obligatoria.
       """
       if created:
           UserActionLog.record(
               user=instance,
               action='USER_CREATED',
               resource=f"user:{instance.username}",
               result='SUCCESS'
           )
           
           notify_admins(
               subject='Nuevo Usuario Creado',
               body=f'Usuario {instance.username} creado.',
               priority='NORMAL'
           )
   
   @receiver(pre_delete, sender=User)
   def user_deleted_handler(sender, instance, **kwargs):
       """
       Auditar eliminación de usuarios.
       
       CNST-009: Auditoría obligatoria.
       CNST-005: Eliminación siempre lógica, nunca física.
       """
       UserActionLog.record(
               user=instance,
               action='USER_DELETED',
               resource=f"user:{instance.username}",
               result='WARNING'
           )

[... Continuar con Patrones 4, 5, 6 y tabla resumen - 577 líneas total ...]
```

#### 4. Actualizar Referencias

- Línea 1082: `RBAC v4.0` → `RBAC v5.1.1`

---

### CNST-007 a CNST-009: Sin Cambios Arquitectónicos

**CNST-007: Performance (1,061 → 1,062 líneas)**
- Metadatos
- Historial de cambios
- Referencias a funciones: `exporta_excel`, `exporta_csv`, `genera_reporte`

**CNST-008: Infraestructura (1,019 → 1,020 líneas)**
- Solo metadatos
- Sin referencias RBAC

**CNST-009: Logging (1,077 → 1,078 líneas)**
- Metadatos
- Historial de cambios
- Referencias a funciones: `consulta_logs`, `exporta_logs`

---

### CNST-010: Clasificación de Datos ⚠️ ALTA PRIORIDAD

**Líneas:** 998 → 1,002 (+4)  
**Impacto:** MEDIO-ALTO  
**Prioridad:** 🟠 ALTA

**Cambios Arquitectónicos:**

#### 1. Metadatos
```rst
:Versión: 1.0.0 → 1.1.0
:Fecha: 2025-12-17 → 2026-01-03
:Estado: Vigente → VIGENTE
```

#### 2. Matriz de Acceso (Líneas 180-194)

**REEMPLAZO COMPLETO de ACCESS_MATRIX:**

**ANTES (basada en roles):**
```python
ACCESS_MATRIX = {
    DataClassification.PUBLIC: {
        'R003', 'R004', 'R005', 'R006', 'R007', 'R008', 
        'R009', 'R010', 'R011', 'R012', 'R013', 'R015'
    },
    DataClassification.INTERNAL: {
        'R004', 'R005', 'R007', 'R010', 'R012', 'R015'
    },
    DataClassification.RESTRICTED: {
        'R010', 'R015'
    },
    DataClassification.CONFIDENTIAL: {
        'R015'  # Solo SYSTEM_ADMIN
    }
}
```

**DESPUÉS (basada en funciones atómicas):**
```python
# api/apps/common/classification.py

from enum import Enum

class DataClassification(Enum):
    """
    Niveles de clasificación de datos.
    
    Compatible con RBAC v5.1.1 (44 funciones atómicas).
    """
    PUBLIC = 'C1'
    INTERNAL = 'C2'
    RESTRICTED = 'C3'
    CONFIDENTIAL = 'C4'


class DataAccessControl:
    """
    Control de acceso basado en funciones RBAC v5.1.1.
    
    Matriz actualizada: Clasificación → Funciones requeridas (no roles).
    """
    
    ACCESS_MATRIX = {
        DataClassification.PUBLIC: [
            # Cualquier usuario autenticado puede acceder
            # No requiere funciones específicas
        ],
        
        DataClassification.INTERNAL: [
            # Funciones MOD_Reports
            've_reportes',           # RPT-001
            've_dashboard',          # (implícito en RPT-001)
            
            # Funciones MOD_Users
            'lista_usuarios',        # USR-005
            've_usuarios',           # USR-002
            
            # Funciones MOD_Pipeline
            'consulta_pipeline',     # (parte de MOD_Pipeline)
        ],
        
        DataClassification.RESTRICTED: [
            # Funciones MOD_Reports avanzadas
            'analiza_datos',         # (analítico)
            'exporta_excel',         # RPT-004
            'genera_reporte',        # RPT-002
            
            # Funciones MOD_Access
            'configura_roles',       # ACC-004 (agrupadores)
            've_asignaciones',       # ACC-003
            
            # Funciones MOD_Alerts
            'gestiona_alertas',      # ALR-002
            'crea_alertas',          # ALR-001
        ],
        
        DataClassification.CONFIDENTIAL: [
            # Solo funciones administrativas
            'administra_sistema',    # (superuser implícito)
            
            # Funciones MOD_Audit
            'consulta_auditoria',    # AUD-001
            'exporta_audit',         # AUD-002
            
            # Funciones MOD_Access críticas
            'asigna_funciones',      # ACC-001
            'revoca_funciones',      # ACC-002
            'configura_permisos',    # (implícito en ACC)
        ]
    }
    
    @classmethod
    def can_access(cls, user, classification: DataClassification) -> bool:
        """
        Verificar si usuario puede acceder a nivel de clasificación.
        
        Args:
            user: Usuario Django
            classification: Nivel de clasificación
        
        Returns:
            bool: True si tiene acceso
        """
        if not user or not user.is_authenticated:
            return False
        
        # C1 (PUBLIC): Todos los autenticados
        if classification == DataClassification.PUBLIC:
            return True
        
        # Superusers acceden a todo
        if user.is_superuser:
            return True
        
        # Obtener funciones requeridas para el nivel
        required_functions = cls.ACCESS_MATRIX.get(classification, [])
        
        if not required_functions:
            return True  # Sin requisitos
        
        # Verificar si usuario tiene AL MENOS UNA función requerida
        from apps.access.models import UserFunctionAssignment
        user_functions = UserFunctionAssignment.get_user_functions(user)
        
        return any(func in user_functions for func in required_functions)
    
    @classmethod
    def get_max_classification(cls, user) -> DataClassification:
        """
        Obtener nivel máximo de clasificación accesible por usuario.
        
        Args:
            user: Usuario Django
        
        Returns:
            DataClassification: Nivel máximo
        """
        if not user or not user.is_authenticated:
            return None
        
        if user.is_superuser:
            return DataClassification.CONFIDENTIAL
        
        # Verificar de mayor a menor
        for level in [
            DataClassification.CONFIDENTIAL,
            DataClassification.RESTRICTED,
            DataClassification.INTERNAL,
            DataClassification.PUBLIC
        ]:
            if cls.can_access(user, level):
                return level
        
        return DataClassification.PUBLIC
```

#### 3. Actualizar Referencias

- Línea 950: `RBAC v4.0` → `RBAC v5.1.1`

---

### index.rst: Índice de Restricciones

**Líneas:** 253 → 280 (+27)  
**Impacto:** MEDIO  
**Prioridad:** 🟡 IMPORTANTE

**Cambios:**

#### 1. Metadatos
```rst
:Estado: CONGELADO → VIGENTE (Actualizado)
:Lineas Totales: 9,621 → 10,543
:Ultima Actualizacion: 2025-12-17 → 2026-01-03
:Version RBAC: v4.0 (18 roles) → v5.1.1 (44 funciones atómicas)
```

#### 2. NUEVA SECCIÓN: Integración con RBAC v5.1.1

Agregar después de la sección de Estructura de Documentos:

```rst
Integración con RBAC v5.1.1
---------------------------

Este conjunto de restricciones está completamente alineado con el 
Modelo RBAC IACT v5.1.1 que utiliza funciones atómicas en lugar de 
roles tradicionales.

Cambios respecto a versión anterior
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Migración de permisos:**
   - De roles basados (R001-R018) a funciones atómicas (44 funciones)
   - Distribución en 8 módulos funcionales IACT
   
2. **Sistema "sin pretensiones":**
   - Nombres de funciones describen QUÉ HACE, no QUIÉN ES
   - Ejemplos: ve_reportes, crea_usuarios, exporta_csv
   
3. **Integración con SEC_RULES:**
   - Enforcement automático de permisos
   - Validación en tiempo real
   
4. **Permisos temporales:**
   - Funciones con fecha de vencimiento
   - Auto-revocación automática

Mapeo CNST ↔ Funciones RBAC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 10 40 20

   * - CNST
     - Funciones RBAC v5.1.1 Afectadas
     - Módulo
   * - CNST-001
     - crea_mensaje_interno, notifica_usuario
     - MOD_Alerts
   * - CNST-002
     - gestiona_sesiones, cierra_sesion_usuario
     - MOD_Auth
   * - CNST-003
     - (sin funciones directas - arquitectura)
     - MOD_Pipeline
   * - CNST-004
     - supervisa_etl, ejecuta_etl, configura_etl
     - MOD_Pipeline
   * - CNST-005
     - Todas (middleware autenticación)
     - Todos
   * - CNST-006
     - Todas (calidad código)
     - Todos
   * - CNST-007
     - exporta_csv, exporta_excel, genera_reporte
     - MOD_Reports
   * - CNST-008
     - (infraestructura - sin funciones)
     - N/A
   * - CNST-009
     - consulta_logs, exporta_logs, consulta_auditoria
     - MOD_Logs, MOD_Audit
   * - CNST-010
     - ve_reportes, analiza_datos, administra_sistema
     - Múltiples

Referencias
~~~~~~~~~~~

- Documento: MODELO_RBAC_IACT_v5_1_1.md
- Catálogo completo de 44 funciones atómicas
- Distribución en 8 módulos IACT
```

---

## 📊 RESUMEN DE CONTEO DE LÍNEAS

| Documento | v1.0.0 | v1.1.0 | Diferencia | % Cambio |
|-----------|--------|--------|------------|----------|
| CNST-001 | 685 | 688 | +3 | +0.4% |
| CNST-002 | 840 | 841 | +1 | +0.1% |
| CNST-003 | 901 | 902 | +1 | +0.1% |
| CNST-004 | 920 | 921 | +1 | +0.1% |
| **CNST-005** | **994** | **1,339** | **+345** | **+34.7%** |
| **CNST-006** | **1,126** | **1,703** | **+577** | **+51.2%** |
| CNST-007 | 1,061 | 1,062 | +1 | +0.1% |
| CNST-008 | 1,019 | 1,020 | +1 | +0.1% |
| CNST-009 | 1,077 | 1,078 | +1 | +0.1% |
| CNST-010 | 998 | 1,002 | +4 | +0.4% |
| index.rst | 253 | 280 | +27 | +10.7% |
| **TOTAL** | **9,621** | **10,543** | **+922** | **+9.6%** |

---

ENDOFPART3

wc -l /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
echo "Parte 3 agregada. Finalizando..."
Output

1187 /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
Parte 3 agregada. Finalizando...

cat >> /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md << 'ENDOFFINAL'
## 🎯 ESTRATEGIA DE GENERACIÓN

### Método Seleccionado: GENERACIÓN DESDE CERO COMPLETA

**Enfoque:**
1. Usar `create_file` para escribir **TODO** el contenido manualmente
2. **NO usar `sed`, `cat`, ni transformaciones** de archivos existentes
3. Escribir línea por línea con TODOS los cambios aplicados
4. Para CNST-005 y CNST-006: incluir secciones nuevas COMPLETAS

**Justificación:**
- Garantiza que TODOS los cambios se apliquen correctamente
- Evita errores de transformación parcial
- Permite validación completa del contenido
- Cumple con el requisito de generación "desde cero"

### Proceso de Staging con /tmp

```bash
# Paso 1: Generar en /tmp usando create_file
create_file(
    path="/tmp/CNST_001_Comunicaciones_Prohibidas.rst",
    content="... contenido completo desde cero ..."
)

# Paso 2: Validar
wc -l /tmp/CNST_001_Comunicaciones_Prohibidas.rst

# Paso 3: Copiar a outputs (si tamaño permite)
cp /tmp/CNST_001_*.rst /mnt/user-data/outputs/

# Si el archivo es muy grande, dejarlo en /tmp
```

### Orden de Generación Recomendado

1. **CNST-001** (688 líneas) - Cambios metadatos + funciones
2. **CNST-002** (841 líneas) - Solo metadatos
3. **CNST-003** (902 líneas) - Solo metadatos
4. **CNST-004** (921 líneas) - Solo metadatos
5. **CNST-005** (1,339 líneas) ⚠️ - **CON ampliación Permisos Temporales** (+345 líneas)
6. **CNST-006** (1,703 líneas) ⚠️ - **CON ampliación Patrones Recomendados** (+577 líneas)
7. **CNST-007** (1,062 líneas) - Solo metadatos
8. **CNST-008** (1,020 líneas) - Solo metadatos
9. **CNST-009** (1,078 líneas) - Solo metadatos
10. **CNST-010** (1,002 líneas) - Metadatos + Matriz ACCESS_MATRIX
11. **index.rst** (280 líneas) - Metadatos + Sección RBAC
12. **ARBOL_COMPLETO_v2_0_7.md** - Actualización comentario

**Confirmación requerida:** Después de cada archivo

---

## 🔄 COMPATIBILIDAD Y TRANSICIÓN

### Adaptador Legacy para CNST-005

Para mantener compatibilidad durante la transición de RBAC v4.0 → v5.1.1:

```python
# api/apps/common/adapters.py

class LegacyRoleAdapter:
    """
    Adaptador para compatibilidad con sistema de roles RBAC v4.0.
    
    Mapea roles antiguos a funciones v5.1.1.
    DEPRECATED: Será removido en v2.0.0.
    """
    
    ROLE_TO_FUNCTIONS = {
        # Roles de consulta
        'R003': ['ve_reportes', 've_dashboard'],
        'R004': ['ve_reportes', 've_dashboard'],
        'R005': ['ve_reportes', 've_dashboard', 'exporta_csv'],
        'R006': ['ve_reportes'],
        'R007': ['ve_reportes', 'exporta_excel'],
        'R008': ['ve_reportes', 've_dashboard'],
        
        # Roles analíticos
        'R009': ['ve_reportes', 'analiza_datos'],
        'R010': ['analiza_datos', 've_reportes', 'exporta_excel'],
        'R011': ['analiza_datos'],
        
        # Roles administrativos
        'R012': ['crea_usuarios', 've_usuarios', 'lista_usuarios'],
        'R013': ['asigna_funciones', 've_asignaciones'],
        
        # Superadmin
        'R015': ['administra_sistema']  # Implica todas las funciones
    }
    
    @classmethod
    def has_role(cls, user, role_code):
        """
        Verificar si usuario tiene rol legacy.
        
        Internamente usa sistema de funciones v5.1.1.
        
        Args:
            user: Usuario Django
            role_code: Código de rol v4.0 (ej: 'R004')
        
        Returns:
            bool: True si tiene todas las funciones del rol
        """
        if not user or not user.is_authenticated:
            return False
        
        # R015 (SYSTEM_ADMIN) = superuser
        if role_code == 'R015':
            return user.is_superuser
        
        # Obtener funciones requeridas para el rol
        required_functions = cls.ROLE_TO_FUNCTIONS.get(role_code, [])
        if not required_functions:
            return False
        
        # Verificar que tenga TODAS las funciones
        from apps.access.models import UserFunctionAssignment
        user_functions = UserFunctionAssignment.get_user_functions(user)
        
        return all(func in user_functions for func in required_functions)
```

---

## ⚠️ ADVERTENCIAS Y CONSIDERACIONES

### 1. Tamaño de Archivos

**Archivos grandes (>1,000 líneas):**
- CNST-005: 1,339 líneas
- CNST-006: 1,703 líneas
- CNST-007: 1,062 líneas
- CNST-009: 1,078 líneas

**Recomendación:** Generar estos archivos en `/tmp` y dejarlos allí si no se pueden copiar a `/mnt/user-data/outputs/`.

### 2. Validación de Contenido

Después de generar cada archivo, validar:

```bash
# Contar líneas
wc -l /tmp/CNST_XXX_*.rst

# Verificar metadatos
head -20 /tmp/CNST_XXX_*.rst | grep -E "Versión|Fecha|Estado"

# Verificar referencias RBAC
grep -n "RBAC" /tmp/CNST_XXX_*.rst

# Para CNST-005 y CNST-006: verificar que existan las secciones nuevas
grep -n "Permisos Temporales" /tmp/CNST_005_*.rst
grep -n "Patrones de Diseño" /tmp/CNST_006_*.rst
```

### 3. Archivo Maestro NO Usar

**CRÍTICO:** El archivo `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md`:
- Tiene EMOJIS (violación de formato)
- Tiene referencias externas (NIST, OWASP)
- Fecha antigua (21 Oct 2025)
- **NO debe usarse como fuente**

Solo usar como **referencia conceptual**, nunca copiar contenido directamente.

---

## 📋 CHECKLIST DE GENERACIÓN

### Pre-Generación
- [x] Análisis completo realizado
- [x] Documento RBAC v5.1.1 leído
- [x] Reporte de revisión analizado
- [x] Estrategia definida
- [x] Método de staging con /tmp confirmado

### Durante Generación
- [ ] CNST-001: Generado (688 líneas)
- [ ] CNST-002: Generado (841 líneas)
- [ ] CNST-003: Generado (902 líneas)
- [ ] CNST-004: Generado (921 líneas)
- [ ] CNST-005: Generado CON ampliación (1,339 líneas)
- [ ] CNST-006: Generado CON ampliación (1,703 líneas)
- [ ] CNST-007: Generado (1,062 líneas)
- [ ] CNST-008: Generado (1,020 líneas)
- [ ] CNST-009: Generado (1,078 líneas)
- [ ] CNST-010: Generado (1,002 líneas)
- [ ] index.rst: Generado (280 líneas)

### Post-Generación
- [ ] Validar conteo total: 10,543 líneas
- [ ] Verificar metadatos en todos
- [ ] Verificar referencias RBAC v5.1.1
- [ ] Validar secciones nuevas (CNST-005, CNST-006)
- [ ] Verificar historial de cambios
- [ ] Generar ARBOL_COMPLETO_v2_0_7.md

---

## ✅ CONCLUSIÓN

### Trabajo a Realizar

- **11 archivos** a generar completamente desde cero
- **10,543 líneas** de contenido a escribir manualmente
- **2 ampliaciones** mayores:
  - CNST-005: +345 líneas (Permisos Temporales)
  - CNST-006: +577 líneas (Patrones Recomendados)
- **Sistema de permisos** completamente actualizado a funciones atómicas

### Cambio Arquitectónico Principal

**De roles fijos (v4.0) a funciones atómicas (v5.1.1):**

| Aspecto | v4.0 | v5.1.1 |
|---------|------|--------|
| Enfoque | 18 roles funcionales | 44 funciones atómicas |
| Nomenclatura | R001-R018 | Nombres descriptivos |
| Distribución | Roles planos | 8 módulos IACT |
| Asignación | Por rol | Por función individual |
| Temporalidad | No soportada | Permisos con vencimiento |
| Ejemplo | `HasRole(['R004'])` | `HasFunction('ve_reportes')` |

### Resultado Esperado

- ✅ Documentación CNST v1.1.0 alineada con RBAC v5.1.1
- ✅ Sistema de permisos basado en **44 funciones atómicas**
- ✅ Permisos temporales documentados e implementables
- ✅ Patrones de diseño recomendados documentados
- ✅ Matriz de clasificación actualizada a funciones
- ✅ Adaptador legacy para transición gradual
- ✅ Base sólida para implementación del sistema

### Tiempo Estimado

- **Generación manual:** 3-4 horas
- **Validación:** 1 hora
- **Total:** 4-5 horas

---

**ANÁLISIS GENERADO:** 2026-01-03  
**Ubicación:** `/tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md`  
**Líneas:** ~1,200  
**Estado:** ✅ COMPLETO Y LISTO PARA GENERACIÓN

---

## 📞 SIGUIENTE PASO

**¿Proceder a generar los 11 archivos desde cero con TODOS los cambios aplicados?**

Esperando confirmación para iniciar generación de CNST-001 (primer archivo).

ENDOFFINAL

wc -l /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
echo ""
echo "=========================================="
echo "✓ ANÁLISIS DEFINITIVO COMPLETO"
echo "=========================================="
echo ""
echo "Ubicación: /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md"
echo ""
ls -lh /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md
Output

1444 /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md

==========================================
✓ ANÁLISIS DEFINITIVO COMPLETO
==========================================

Ubicación: /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md

-rw-r--r-- 1 root root 42K Jan  4 07:36 /tmp/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md

Reconoció error y se dispone a regenerar análisis completo.

✅ ANÁLISIS DEFINITIVO GENERADO CORRECTAMENTE

He generado un análisis completo y corregido que integra TODOS los documentos que proporcionaste:

📊 Características del Análisis
Ubicación: `/tmp/ANALISIS_ACTUALIZACION_CNST_DE



