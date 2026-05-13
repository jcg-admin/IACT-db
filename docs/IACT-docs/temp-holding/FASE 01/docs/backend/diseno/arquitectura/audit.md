---
id: APP-AUDIT
tipo: django_app
dominio: backend
estado: documentado
fecha: 2025-11-06
auto_generado: true
ultima_actualizacion: 2025-11-06
version: 1.1
relacionados: [APP-AUTHENTICATION, APP-USERS, RN-001, RS-001, RS-002]
---

# Django App: audit

## Descripción

App crítica para **auditoría y compliance** ISO 27001. Registra todas las acciones relevantes del sistema de forma **inmutable** para trazabilidad completa.

**Características principales**:
- Registros **inmutables** (no se pueden modificar después de creados)
- Captura completa: acción, recurso, usuario, IP, user-agent, timestamp
- Soporte para valores before/after (old_values, new_values)
- Metadata extensible (JSON)
- Compliance con ISO 27001 y SOC 2

## Estructura

```
api/callcentersite/callcentersite/apps/audit/
 __init__.py
 apps.py
 models.py # AuditLog (modelo inmutable)
 services.py # AuditService
 decorators.py # @audit_action decorator
 migrations/
```

## Modelo: AuditLog

### AuditLog

**Propósito**: Registro inmutable de acciones para auditoría y compliance.

**Campos principales**:
- `user` (ForeignKey, nullable): Usuario que ejecutó la acción
- `action` (CharField): Acción ejecutada (ej: "login", "create_campaign", "delete_user")
- `resource` (CharField): Tipo de recurso afectado (ej: "User", "Campaign", "Permission")
- `resource_id` (CharField, nullable): ID del recurso específico
- `ip_address` (GenericIPAddressField, nullable): IP del cliente
- `user_agent` (TextField, nullable): User-Agent del navegador
- `timestamp` (DateTimeField, indexed): Momento de la acción
- `old_values` (JSONField, nullable): Valores antes del cambio
- `new_values` (JSONField, nullable): Valores después del cambio
- `result` (CharField): Resultado ("success", "failure", "error")
- `error_message` (TextField, nullable): Mensaje de error si falla
- `metadata` (JSONField): Metadata adicional extensible

**Restricción CRÍTICA**:
```python
def save(self, *args, **kwargs):
 if self.pk:
 raise RuntimeError("Los registros de auditoría son inmutables")
 super().save(*args, **kwargs)
```

[ATENCION] Los registros NUNCA se pueden actualizar después de creados.

**Permisos**:
- Solo lectura: `view_auditlog`
- NO tiene permisos de create/update/delete en Meta

**Requisitos**: RN-001 (ISO 27001), RS-001 (Trazabilidad), RS-002 (Reportes compliance)

**Ubicación**: `api/callcentersite/callcentersite/apps/audit/models.py`

## Servicios

### AuditService

**Propósito**: Facilitar creación de registros de auditoría.

**Método principal**: `log(action, resource, user, result, **kwargs)`

**Ubicación**: `api/callcentersite/callcentersite/apps/audit/services.py`

### Decorador @audit_action

**Propósito**: Decorador para auditar automáticamente funciones/métodos.

**Uso típico**:
```python
from apps.audit.decorators import audit_action

@audit_action(action="delete_user", resource="User")
def delete_user(user_id):
 # ... lógica ...
 pass
```

**Ubicación**: `api/callcentersite/callcentersite/apps/audit/decorators.py`

## Endpoints REST

**Estado**: Endpoints de solo lectura para visualización de logs.

**Endpoints esperados**:
- `GET /api/audit/` - Listar registros de auditoría (admin/auditor)
- `GET /api/audit/{id}/` - Detalle de registro específico
- `GET /api/audit/export/` - Exportar logs para compliance
- `GET /api/audit/user/{user_id}/` - Logs de usuario específico
- `GET /api/audit/resource/{resource}/{resource_id}/` - Logs de recurso específico

[ATENCION] NO hay endpoints POST/PUT/DELETE (inmutabilidad).

## Tests

[ATENCION] **WARNING**: No se detectaron tests automáticos.

**Tests requeridos (prioridad ALTA - COMPLIANCE)**:
1. `test_audit_log_immutability()` - Verificar que no se puede actualizar
2. `test_audit_log_creation()` - Crear registro correctamente
3. `test_audit_decorator()` - Decorador registra acciones automáticamente
4. `test_audit_service()` - AuditService crea logs correctamente
5. `test_audit_log_indexing()` - Performance de queries por timestamp
6. `test_audit_log_retention()` - Política de retención de logs
7. `test_audit_log_export()` - Exportar logs para auditoría externa

## Dependencias

### Dependencias Internas
- **`authentication`**: Audita todos los intentos de login
- **`users`**: Audita cambios en usuarios, roles, permisos
- **Todas las apps**: Cualquier acción crítica debe auditarse

### Dependencias Externas
- `django.db.models`: ORM, JSONField
- `django.conf.settings`: AUTH_USER_MODEL

## Casos de Uso

### 1. Auditar Login Exitoso
```python
from apps.audit.services import AuditService

AuditService.log(
 action="login",
 resource="User",
 resource_id=str(user.id),
 user=user,
 ip_address="192.168.1.100",
 user_agent="Mozilla/5.0...",
 result="success"
)
```

### 2. Auditar Cambio de Permisos
```python
AuditService.log(
 action="update_permissions",
 resource="User",
 resource_id=str(user.id),
 user=admin_user,
 old_values={"permissions": ["view", "create"]},
 new_values={"permissions": ["view", "create", "delete"]},
 result="success"
)
```

### 3. Auditar Fallo de Autenticación
```python
AuditService.log(
 action="login",
 resource="User",
 resource_id=username,
 user=None, # Usuario no autenticado
 ip_address=request.META.get('REMOTE_ADDR'),
 result="failure",
 error_message="Invalid credentials"
)
```

## Cumplimiento de Requisitos

| Requisito | Descripción | Estado |
|-----------|-------------|--------|
| RN-001 | ISO 27001 compliance | [OK] Auditoría completa e inmutable |
| RS-001 | Trazabilidad completa | [OK] Todos los campos necesarios |
| RS-002 | Reportes automáticos | [ATENCION] Implementar exports |

## Retención y Archivado

**Políticas recomendadas**:
- **Hot storage**: Últimos 90 días (BD principal)
- **Warm storage**: 90 días - 1 año (BD archivado)
- **Cold storage**: 1-7 años (S3/archivo para compliance)

**Implementar**:
```python
# Management command: archive_old_audit_logs
# Ejecutar diariamente via cron
python manage.py archive_old_audit_logs --days=90
```

## Seguridad

### Protecciones Implementadas
1. [OK] **Inmutabilidad**: RuntimeError si se intenta modificar
2. [OK] **Sin permisos de escritura**: No está en default_permissions
3. [OK] **Timestamp indexado**: Queries rápidos por fecha
4. [ATENCION] **Encriptación en reposo**: Configurar a nivel de BD
5. [ATENCION] **Exportación segura**: Implementar firma digital para exports

## Notas

- Crítico para compliance ISO 27001 y SOC 2
- Inmutabilidad garantizada por modelo
- Considerar particionamiento por fecha en BD para performance
- Implementar alertas sobre patrones anormales de acciones
- Integrar con SIEM (Security Information and Event Management) si existe

**Última actualización**: 2025-11-06
**Estado**: [OK] Documentación completa
