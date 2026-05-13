---
id: RF-002
tipo: funcional
titulo: Gestión de permisos granulares basados en recurso y acción
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
 - TEST-002 # Tests de Permission model

stakeholders:
 - administradores-sistema

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-002: Gestión de permisos granulares basados en recurso y acción

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** permitir la creación de permisos granulares con estructura (codename, resource, action, name, description) **donde** codename es único y sigue el formato "recurso.accion".

### 1.2 Descripción Detallada

**Contexto:**
Los permisos deben ser granulares para permitir control fino de acceso a recursos específicos con acciones específicas.

**Necesidad:**
Administradores necesitan definir permisos específicos como "analytics.view", "reports.create", "audit.delete" en lugar de permisos genéricos.

**Comportamiento esperado:**
- Cada permiso tiene un codename único en formato "recurso.accion"
- El permiso almacena el recurso y acción por separado para consultas
- Incluye nombre legible y descripción para UI administrativa

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Crear permiso válido

```gherkin
Given un administrador del sistema
When crea un permiso con:
 | codename | analytics.view |
 | name | Puede ver analítica |
 | resource | analytics |
 | action | view |
 | description | Permite ver reportes de analítica |
Then el sistema crea el permiso exitosamente
 And el permiso recibe un ID único
 And el codename es único en el sistema
```

#### Escenario 2: Codename debe seguir formato recurso.accion

```gherkin
Given un administrador intenta crear un permiso
When el codename no contiene punto (ej: "analytics")
Then el sistema debería validar el formato
 And mostrar error "Codename debe seguir formato recurso.accion"
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target |
|---------|----------|--------|
| **Unicidad** | Codename único | Obligatorio |
| **Performance** | Creación de permiso | < 5 ms |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación |
|------------|-----------|
| Permission | `api/callcentersite/callcentersite/apps/users/models.py:98-112` |
| PermissionManager | `api/callcentersite/callcentersite/apps/users/models.py:48-49` |

### 3.2 Estructura de Datos

```python
@dataclass
class Permission:
 codename: str # Formato: "recurso.accion"
 name: str # Nombre legible
 resource: str # Recurso protegido
 action: str # Acción permitida
 description: str # Descripción del permiso
 id: int # Generado automáticamente
```

**Ejemplos válidos:**
- codename="analytics.view", resource="analytics", action="view"
- codename="reports.create", resource="reports", action="create"
- codename="audit.delete", resource="audit", action="delete"

## 4. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-002-001**: test_crear_permiso_valido
 - Estado: pendiente

- [ ] **TEST-002-002**: test_codename_es_unico_en_hash
 - Estado: pendiente

- [ ] **TEST-002-003**: test_permission_manager_create
 - Estado: pendiente

## 5. Referencias

- Código: `api/callcentersite/callcentersite/apps/users/models.py:98-112`
