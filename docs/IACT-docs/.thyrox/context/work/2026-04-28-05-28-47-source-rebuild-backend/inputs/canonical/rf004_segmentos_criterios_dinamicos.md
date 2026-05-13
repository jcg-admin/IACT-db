---
id: RF-004
tipo: funcional
titulo: Segmentación de usuarios con criterios dinámicos
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
 - TEST-004 # Tests de Segment matching

stakeholders:
 - administradores-sistema

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-004: Segmentación de usuarios con criterios dinámicos

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** permitir crear segmentos de usuarios con criterios dinámicos (dict de campo:valor) **donde** un usuario pertenece al segmento si **todos** sus atributos coinciden con los criterios definidos **y** el segmento está activo.

### 1.2 Descripción Detallada

**Contexto:**
Los permisos por segmento permiten asignar permisos masivos a usuarios que cumplan ciertos criterios, sin necesidad de asignar permisos individualmente.

**Necesidad:**
Ejemplo: "Todos los usuarios activos pueden ver el dashboard" sin tener que asignar permiso a cada usuario activo.

**Comportamiento esperado:**
- Un segmento define criterios como `{"is_active": True}` o `{"is_active": True, "department": "sales"}`
- Un usuario "coincide" (matches) con el segmento si TODOS los criterios se cumplen (AND lógico)
- Solo segmentos con `is_active=True` son evaluados

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Usuario coincide con criterio simple

```gherkin
Given un segmento "Activos" con criterios {"is_active": True}
 And el segmento está activo (is_active=True)
 And un usuario "alice" con is_active=True
When el sistema evalúa segment.matches(alice)
Then retorna True
```

#### Escenario 2: Usuario NO coincide con criterio

```gherkin
Given un segmento "Activos" con criterios {"is_active": True}
 And un usuario "bob" con is_active=False
When el sistema evalúa segment.matches(bob)
Then retorna False
```

#### Escenario 3: Criterios múltiples (AND lógico)

```gherkin
Given un segmento "Gerentes Activos" con criterios:
 | is_active | True |
 | role_name | manager |
 And un usuario "carol" con is_active=True y role_name="manager"
When el sistema evalúa segment.matches(carol)
Then retorna True
```

#### Escenario 4: Criterios múltiples - uno NO coincide

```gherkin
Given un segmento "Gerentes Activos" con criterios:
 | is_active | True |
 | role_name | manager |
 And un usuario "dave" con is_active=True y role_name="analyst"
When el sistema evalúa segment.matches(dave)
Then retorna False
 And falla porque role_name no coincide
```

#### Escenario 5: Segmento inactivo no se evalúa

```gherkin
Given un segmento "Activos" con is_active=False
When SegmentManager.active_segments() es llamado
Then el segmento NO aparece en la lista
 And no será considerado para evaluación de permisos
```

#### Escenario 6: Campo no existe en usuario

```gherkin
Given un segmento con criterios {"campo_inexistente": "valor"}
 And un usuario "eve" que no tiene atributo "campo_inexistente"
When el sistema evalúa segment.matches(eve)
Then retorna False
 And getattr(user, campo, None) retorna None
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target |
|---------|----------|--------|
| **Performance** | Evaluación de matching | < 5 ms por segmento |
| **Criterios** | Lógica AND obligatoria | Todos deben cumplirse |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación |
|------------|-----------|
| Segment | `api/callcentersite/callcentersite/apps/users/models.py:156-176` |
| SegmentManager | `api/callcentersite/callcentersite/apps/users/models.py:78-87` |

### 3.2 Estructura de Datos

```python
@dataclass
class Segment:
 name: str
 description: str
 criteria: dict[str, Any] # {"campo": valor}
 is_active: bool = True
 permissions: PermissionCollection
```

### 3.3 Algoritmo de Matching

```python
def matches(self, user: User) -> bool:
 """Verifica si usuario cumple TODOS los criterios (AND)."""
 for field, expected in self.criteria.items():
 if getattr(user, field, None) != expected:
 return False # Un criterio falló
 return True # Todos los criterios pasaron
```

### 3.4 Reglas de Negocio

| ID | Regla |
|----|-------|
| BR-10 | Criterios son evaluados con AND lógico (todos deben cumplirse) |
| BR-11 | Segmentos con is_active=False son ignorados completamente |
| BR-12 | Si el campo no existe en el usuario, se considera None |

## 4. Casos de Prueba

### 4.1 Tests Unitarios

- [ ] **TEST-004-001**: test_segment_matches_con_criterio_simple
 - Estado: pendiente

- [ ] **TEST-004-002**: test_segment_no_matches_cuando_criterio_difiere
 - Estado: pendiente

- [ ] **TEST-004-003**: test_segment_matches_criterios_multiples_and
 - Estado: pendiente

- [ ] **TEST-004-004**: test_segment_matches_campo_inexistente_retorna_false
 - Estado: pendiente

- [ ] **TEST-004-005**: test_active_segments_filtra_inactivos
 - Estado: pendiente

- [ ] **TEST-004-006**: test_with_permission_retorna_solo_segmentos_con_codename
 - Estado: pendiente

## 5. Referencias

- Código: `api/callcentersite/callcentersite/apps/users/models.py:156-176`
