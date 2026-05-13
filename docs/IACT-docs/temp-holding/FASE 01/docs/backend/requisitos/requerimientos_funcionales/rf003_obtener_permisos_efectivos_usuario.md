---
id: RF-003
tipo: funcional
titulo: Obtener todos los permisos efectivos de un usuario
dominio: backend
owner: equipo-backend
prioridad: alta
estado: implementado
fecha_creacion: 2025-11-04
modulo: users
categoria: security

trazabilidad_upward:
 - N-001 # Necesidad de control de acceso granular

trazabilidad_downward:
 - TEST-003 # Tests de permissions_for_user

dependencias:
 - RF-001 # Depende del sistema de evaluación de permisos

stakeholders:
 - administradores-sistema
 - desarrolladores-ui

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-003: Obtener todos los permisos efectivos de un usuario

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** retornar la lista completa de permisos efectivos de un usuario **consolidando** permisos directos, por roles y por segmentos **sin duplicados** cuando se solicite el conjunto total de permisos.

### 1.2 Descripción Detallada

**Contexto:**
Las interfaces administrativas y de usuario necesitan mostrar todos los permisos que un usuario tiene actualmente, sin evaluar permiso por permiso.

**Necesidad:**
Mostrar en UI administrativa qué puede hacer un usuario, generar reportes de acceso, auditar permisos otorgados.

**Comportamiento esperado:**
- Recolecta permisos de los 3 niveles (directo, rol, segmento)
- Elimina duplicados
- Retorna set/lista de codenames de permisos

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Usuario con permisos en los 3 niveles

```gherkin
Given un usuario "alice"
 And tiene permiso directo "analytics.view"
 And tiene rol "Analista" con permisos ["reports.view", "analytics.view"]
 And pertenece a segmento "Activos" con permisos ["dashboard.view", "reports.view"]
When el sistema ejecuta permissions_for_user(alice)
Then retorna ["analytics.view", "reports.view", "dashboard.view"]
 And NO incluye duplicados
```

#### Escenario 2: Usuario sin permisos

```gherkin
Given un usuario "bob"
 And NO tiene permisos directos
 And NO tiene roles asignados
 And NO pertenece a ningún segmento activo
When el sistema ejecuta permissions_for_user(bob)
Then retorna lista vacía []
```

#### Escenario 3: Usuario solo con permisos por segmento

```gherkin
Given un usuario "carol" con is_active=True
 And NO tiene permisos directos
 And NO tiene roles
 And pertenece a segmento "Activos" (criterio is_active=True)
 And el segmento tiene permisos ["dashboard.view", "reports.view"]
When el sistema ejecuta permissions_for_user(carol)
Then retorna ["dashboard.view", "reports.view"]
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target |
|---------|----------|--------|
| **Performance** | Tiempo de ejecución | < 50 ms |
| **Duplicados** | Sin duplicados en resultado | Obligatorio |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación |
|------------|-----------|
| PermissionService.permissions_for_user | `api/callcentersite/callcentersite/apps/users/services.py:48-68` |

### 3.2 Algoritmo

```python
def permissions_for_user(user: User) -> Iterable[str]:
 # 1. Recolectar permisos directos
 direct = {perm.codename for perm in UserPermission.objects.permissions_for_user(user)}

 # 2. Recolectar permisos por roles
 role_based = set()
 for role in RoleAssignment.objects.roles_for_user(user):
 role_based.update(role.permissions.values_list("codename", flat=True))

 # 3. Recolectar permisos por segmentos
 segment_permissions = set()
 for segment in Segment.objects.active_segments():
 if segment.matches(user):
 segment_permissions.update(segment.permissions.values_list("codename", flat=True))

 # 4. Unir sin duplicados
 return direct.union(role_based).union(segment_permissions)
```

## 4. Casos de Prueba

### 4.1 Tests Unitarios

- [ ] **TEST-003-001**: test_permissions_for_user_con_tres_niveles
 - Estado: pendiente

- [ ] **TEST-003-002**: test_permissions_for_user_sin_permisos
 - Estado: pendiente

- [ ] **TEST-003-003**: test_permissions_for_user_elimina_duplicados
 - Estado: pendiente

- [ ] **TEST-003-004**: test_permissions_for_user_solo_segmentos_activos
 - Estado: pendiente

## 5. Referencias

- Código: `api/callcentersite/callcentersite/apps/users/services.py:48-68`
