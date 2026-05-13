---
id: RF-001
tipo: funcional
titulo: Sistema de evaluación de permisos con tres niveles de precedencia
dominio: backend
owner: equipo-backend
prioridad: critica
estado: implementado
fecha_creacion: 2025-11-04
modulo: users
categoria: security

trazabilidad_upward:
 - N-001 # Necesidad de control de acceso granular

trazabilidad_downward:
 - TEST-001 # test_permission_precedence.py

stakeholders:
 - administradores-sistema
 - gerentes-seguridad

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-001: Sistema de evaluación de permisos con tres niveles de precedencia

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** evaluar permisos de usuario en tres niveles con precedencia definida (directo > rol > segmento) **retornando** true si encuentra el permiso en cualquier nivel **cuando** un usuario autenticado solicite acceso a un recurso protegido.

### 1.2 Descripción Detallada

**Contexto:**
El sistema necesita un mecanismo flexible de control de acceso que permita asignar permisos de tres formas diferentes: directamente al usuario, a través de roles, o mediante segmentos dinámicos de usuarios.

**Necesidad:**
Los administradores necesitan poder otorgar permisos de manera granular (directos), agrupada (roles), o masiva (segmentos) según el caso de uso, con una precedencia clara para resolver conflictos.

**Comportamiento esperado:**
El sistema evalúa permisos en orden estricto:
1. Primero verifica permisos directos (máxima prioridad)
2. Si no encuentra permiso directo, verifica permisos por roles asignados
3. Si no encuentra en roles, verifica permisos por segmentos que coincidan con criterios del usuario
4. Retorna false solo si no encuentra el permiso en ningún nivel

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Permiso directo tiene máxima prioridad

```gherkin
Given un usuario autenticado "alice"
 And el usuario tiene el permiso directo "analytics.view"
 And el usuario también tiene un rol con ese permiso
 And el usuario también pertenece a un segmento con ese permiso
When el sistema evalúa has_permission(alice, "analytics.view")
Then el sistema retorna true
 And el sistema NO consulta roles ni segmentos (short-circuit)
```

#### Escenario 2: Permiso por rol cuando no hay permiso directo

```gherkin
Given un usuario autenticado "carol"
 And el usuario NO tiene permisos directos
 And el usuario tiene asignado el rol "Auditor"
 And el rol "Auditor" tiene el permiso "audit.view"
When el sistema evalúa has_permission(carol, "audit.view")
Then el sistema retorna true
```

#### Escenario 3: Permiso por segmento cuando no hay directo ni rol

```gherkin
Given un usuario autenticado "dave"
 And el usuario tiene is_active=True
 And el usuario NO tiene permisos directos
 And el usuario NO tiene roles asignados
 And existe un segmento "Activos" con criterio is_active=True
 And el segmento "Activos" tiene el permiso "reports.generate"
When el sistema evalúa has_permission(dave, "reports.generate")
Then el sistema retorna true
```

#### Escenario 4: Usuario no autenticado siempre retorna false

```gherkin
Given un usuario NO autenticado
When el sistema evalúa has_permission(usuario, "cualquier.permiso")
Then el sistema retorna false
 And NO evalúa permisos directos, roles ni segmentos
```

#### Escenario 5: Segmento no coincide con criterios del usuario

```gherkin
Given un usuario autenticado "bob"
 And el usuario tiene is_active=False
 And existe un segmento "Activos" con criterio is_active=True
 And el segmento tiene el permiso "reports.generate"
When el sistema evalúa has_permission(bob, "reports.generate")
Then el sistema retorna false
 And el segmento no aplica porque el usuario no coincide con criterios
```

#### Escenario 6: Permiso no existe en ningún nivel

```gherkin
Given un usuario autenticado "eve"
When el sistema evalúa has_permission(eve, "permiso.inexistente")
Then el sistema retorna false
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Performance** | Tiempo de evaluación | < 10 ms | 95th percentile |
| **Short-circuit** | No consultar niveles inferiores si encuentra en superior | Obligatorio | Code review + test |
| **Disponibilidad** | Disponible 24/7 | 99.9% | Monitoreo mensual |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| PermissionService | `api/callcentersite/callcentersite/apps/users/services.py` | existente |
| UserPermissionManager | `api/callcentersite/callcentersite/apps/users/models.py` | existente |
| RoleAssignmentManager | `api/callcentersite/callcentersite/apps/users/models.py` | existente |
| SegmentManager | `api/callcentersite/callcentersite/apps/users/models.py` | existente |

### 3.2 Interfaces

#### 3.2.1 API Python

**Método:** `PermissionService.has_permission(user: User, permission_codename: str) -> bool`

**Parámetros:**
- `user`: Instancia de User (debe estar autenticado)
- `permission_codename`: String con formato "recurso.accion" (ej: "analytics.view")

**Retorno:**
- `bool`: True si el usuario tiene el permiso, False en caso contrario

**Algoritmo de evaluación:**
```python
def has_permission(user, permission_codename):
 # Nivel 0: Verificar autenticación
 if not user.is_authenticated:
 return False

 # Nivel 1: Permisos directos (máxima prioridad)
 if _has_direct_permission(user, permission_codename):
 return True # Short-circuit

 # Nivel 2: Permisos por rol
 if _has_role_permission(user, permission_codename):
 return True # Short-circuit

 # Nivel 3: Permisos por segmento
 return _has_segment_permission(user, permission_codename)
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-01 | Precedencia de permisos | Directo > Rol > Segmento (no negociable) |
| BR-02 | Short-circuit obligatorio | Si encuentra en nivel superior, NO evaluar niveles inferiores |
| BR-03 | Usuario no autenticado | Siempre retorna false sin evaluar permisos |
| BR-04 | Segmentos inactivos | Segmentos con is_active=False son ignorados |
| BR-05 | Matching de segmentos | Todos los criterios del segmento deben coincidir (AND lógico) |

### 3.4 Validaciones

#### Validaciones de Entrada
- `user` no puede ser None
- `permission_codename` debe ser string no vacío
- `permission_codename` debe seguir formato "recurso.accion"

#### Validaciones de Negocio
- Usuario debe estar autenticado (is_authenticated=True)
- Usuario debe estar activo (is_active=True)
- Usuario NO debe estar eliminado (is_deleted=False)

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- User.is_authenticated debe estar implementado
- UserPermission, RoleAssignment, Segment deben existir

### 4.2 Permisos/Roles Requeridos

Este método NO requiere permisos para ejecutarse (es usado por el sistema de autorización mismo).

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [x] **TEST-001-001**: test_permiso_directo_tiene_maxima_prioridad
 - Ubicación: `tests/users/test_permission_precedence.py::test_permiso_directo_tiene_maxima_prioridad`
 - Estado: implementado, pasando

- [x] **TEST-001-002**: test_permiso_por_rol_sin_permiso_directo
 - Ubicación: `tests/users/test_permission_precedence.py::test_permiso_por_rol_sin_permiso_directo`
 - Estado: implementado, pasando

- [x] **TEST-001-003**: test_permiso_por_segmento_sin_coincidencia_no_habilita
 - Ubicación: `tests/users/test_permission_precedence.py::test_permiso_por_segmento_sin_coincidencia_no_habilita`
 - Estado: implementado, pasando

- [ ] **TEST-001-004**: test_usuario_no_autenticado_siempre_retorna_false
 - Ubicación: `tests/users/test_permission_service.py::test_usuario_no_autenticado_siempre_retorna_false`
 - Estado: pendiente

- [ ] **TEST-001-005**: test_permiso_por_segmento_cuando_coincide_criterio
 - Ubicación: `tests/users/test_permission_service.py::test_permiso_por_segmento_cuando_coincide_criterio`
 - Estado: pendiente

- [ ] **TEST-001-006**: test_permiso_inexistente_retorna_false
 - Ubicación: `tests/users/test_permission_service.py::test_permiso_inexistente_retorna_false`
 - Estado: pendiente

- [ ] **TEST-001-007**: test_segmento_inactivo_es_ignorado
 - Ubicación: `tests/users/test_permission_service.py::test_segmento_inactivo_es_ignorado`
 - Estado: pendiente

- [ ] **TEST-001-008**: test_short_circuit_no_evalua_roles_si_tiene_directo
 - Ubicación: `tests/users/test_permission_service.py::test_short_circuit_no_evalua_roles_si_tiene_directo`
 - Estado: pendiente

## 6. Definición de Hecho (Definition of Done)

- [x] Código implementado y revisado
- [x] 3 tests implementados y pasando
- [ ] Tests adicionales para casos edge (4 pendientes)
- [ ] Coverage >= 95% para PermissionService.has_permission
- [ ] Documentación técnica actualizada (este documento)
- [ ] Performance verificado (< 10ms por evaluación)

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de la necesidad de control de acceso granular del sistema.

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|----|-----------|
| Test | TEST-001 | Tests de precedencia de permisos | `tests/users/test_permission_precedence.py` |
| Código | IMPL-001 | PermissionService | `callcentersite/apps/users/services.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Código fuente: `api/callcentersite/callcentersite/apps/users/services.py:12-46`
- Tests existentes: `api/callcentersite/tests/users/test_permission_precedence.py`

### 8.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018**: Clause 9.6 - Software Requirements Specification
- **OWASP ASVS**: Access Control Verification Requirements

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial (ingeniería reversa) |
