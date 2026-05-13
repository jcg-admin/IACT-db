---
id: APP-USERS
tipo: django_app
dominio: backend
estado: documentado
fecha: 2025-11-06
auto_generado: true
ultima_actualizacion: 2025-11-06
version: 1.1
relacionados: [APP-AUTHENTICATION, APP-AUDIT, RF-001, RF-002, RF-003, RF-004]
---

# Django App: users

## Descripción

App core para gestión de **usuarios, roles y permisos** en IACT. Implementa un sistema de permisos granulares con 3 niveles de evaluación y segmentación dinámica de usuarios.

**Características principales**:
- Sistema de permisos granulares (recurso + acción)
- Roles y asignación de roles a usuarios
- Segmentos dinámicos con criterios configurables
- Modelos in-memory (dataclasses) para alta performance
- Integración con Django auth

## Estructura

```
api/callcentersite/callcentersite/apps/users/
 __init__.py
 apps.py
 models.py # Modelos in-memory (User, Role, Permission, Segment)
 services.py # Lógica de negocio (PermissionService)
 migrations/ # Migraciones
```

## Arquitectura: Modelos In-Memory

[ATENCION] **IMPORTANTE**: Esta app usa **dataclasses in-memory** en lugar de modelos Django tradicionales.

**Razón**: Performance crítica para evaluación de permisos en cada request.

**Managers disponibles**:
- `UserManager`: CRUD de usuarios
- `PermissionManager`: CRUD de permisos
- `RoleManager`: CRUD de roles
- `RoleAssignmentManager`: Asignación rol-usuario
- `UserPermissionManager`: Permisos directos de usuario
- `SegmentManager`: Segmentos dinámicos

## Modelos

### User (dataclass)
Usuario del sistema con autenticación y permisos.

**Campos principales**:
- `id` (int): ID único
- `username` (str): Nombre de usuario único
- `email` (str): Email
- `password` (str): Password hasheado
- `is_active` (bool): Usuario activo
- `is_authenticated` (bool): Estado de autenticación

### Permission (dataclass)
Permiso granular (recurso + acción).

**Campos**:
- `id` (int)
- `codename` (str): Ejemplo: "campaigns.create", "reports.view"
- `resource` (str): Recurso (campaigns, reports, etc.)
- `action` (str): Acción (create, read, update, delete, execute)

**Requisitos**: RF-002 (Gestión permisos granulares)

### Role (dataclass)
Rol agrupador de permisos.

**Campos**:
- `id` (int)
- `name` (str): Nombre del rol
- `permissions` (List[Permission]): Permisos del rol

### Segment (dataclass)
Segmento dinámico de usuarios con criterios.

**Campos**:
- `id` (int)
- `name` (str): Nombre del segmento
- `criteria` (dict): Criterios de membresía
- `permissions` (List[Permission]): Permisos del segmento
- `is_active` (bool): Segmento activo

**Requisitos**: RF-004 (Segmentos criterios dinámicos)

## Servicios

### PermissionService

**Propósito**: Evaluar permisos de usuario en 3 niveles.

**Método principal**: `evaluate_permissions(user: User) -> List[Permission]`

Evalúa permisos en este orden:
1. **Permisos directos** del usuario
2. **Permisos por roles** asignados
3. **Permisos por segmentos** a los que pertenece

**Requisitos**: RF-001 (Evaluación permisos 3 niveles)

**Ubicación**: `api/callcentersite/callcentersite/apps/users/services.py`

## Endpoints REST

**Estado**: Endpoints manejados por app o vistas custom (no auto-descubierto por agente).

**Endpoints esperados**:
- `POST /api/users/login/` - Login de usuario
- `POST /api/users/logout/` - Logout
- `GET /api/users/me/` - Perfil usuario actual
- `GET /api/users/me/permissions/` - Permisos efectivos
- `POST /api/users/` - Crear usuario (admin)
- `GET /api/users/` - Listar usuarios (admin)

## Tests

[ATENCION] **WARNING**: No se detectaron tests automáticos.

**Tests requeridos (prioridad ALTA)**:
1. `test_permission_evaluation_three_levels()` - 3 niveles de permisos
2. `test_user_manager_create_user()` - Creación de usuarios
3. `test_role_assignment()` - Asignación de roles
4. `test_segment_dynamic_criteria()` - Evaluación de segmentos
5. `test_has_permission()` - Verificación de permisos
6. `test_registry_reset()` - Limpieza entre tests
7. `test_in_memory_persistence()` - Persistencia in-memory

## Dependencias

### Dependencias Internas
- **`authentication`**: Login/logout usan LoginAttemptService
- **`audit`**: Cambios en usuarios/permisos se auditan

### Dependencias Externas
- `django.contrib.auth`: AUTH_USER_MODEL base
- `dataclasses`: Modelos in-memory

## Cumplimiento de Requisitos

| Requisito | Descripción | Estado |
|-----------|-------------|--------|
| RF-001 | Evaluación 3 niveles | [OK] PermissionService |
| RF-002 | Permisos granulares | [OK] Permission(resource, action) |
| RF-003 | Obtener permisos efectivos | [OK] evaluate_permissions() |
| RF-004 | Segmentos dinámicos | [OK] Segment con criteria |
| RF-010 | Sesión única | [ATENCION] Implementar |

## Notas

- Modelos in-memory requieren reset en tests: `reset_registry()`
- No persisten en BD por default (performance trade-off)
- Evaluar migrar a Django models tradicionales si se requiere persistencia
- Considerar caché distribuido (Redis) para clusters multi-nodo

**Última actualización**: 2025-11-06
**Estado**: [OK] Documentación completa
