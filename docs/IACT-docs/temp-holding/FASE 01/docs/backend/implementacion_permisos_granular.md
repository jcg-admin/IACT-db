---
id: IMPLEMENTACION-PERMISOS-GRANULAR
tipo: documento_tecnico
categoria: implementacion
version: 1.0.0
fecha: 2025-11-07
estado: en_progreso
---

# Implementacion del Sistema de Permisos Granular

Este documento describe el estado actual de la implementacion del sistema de permisos granular basado en Grupos Funcionales.

## Estado de Implementacion

**Fecha de inicio:** 2025-11-07
**Estado:** Base implementada - Continuacion pendiente
**Cobertura de tests:** 0% (pendiente)
**Enfoque:** TDD (Test-Driven Development)

## Archivos Creados

### Backend (Django)

#### 1. Migraciones de Base de Datos

**Archivo:** `api/callcentersite/callcentersite/apps/users/migrations/0001_initial_permisos_granular.py`

Crea 8 tablas:
1. funciones - Recursos del sistema
2. capacidades - Acciones granulares
3. funcion_capacidades - Relacion N:M funciones-capacidades
4. grupos_permisos - Grupos funcionales sin jerarquia
5. grupo_capacidades - Relacion N:M grupos-capacidades
6. usuarios_grupos - Relacion N:M usuarios-grupos
7. permisos_excepcionales - Permisos temporales o permanentes
8. auditoria_permisos - Log de accesos

**Comando para aplicar:**
```bash
cd api/callcentersite
python manage.py migrate users
```

#### 2. Modelos Django

**Archivo:** `api/callcentersite/callcentersite/apps/users/models_permisos_granular.py`

Define 8 modelos Django ORM:
- Funcion
- Capacidad
- FuncionCapacidad
- GrupoPermiso
- GrupoCapacidad
- UsuarioGrupo
- PermisoExcepcional
- AuditoriaPermiso

**Importar en models.py:**
```python
from .models_permisos_granular import (
 Funcion,
 Capacidad,
 GrupoPermiso,
 UsuarioGrupo,
 PermisoExcepcional,
 AuditoriaPermiso,
)
```

#### 3. Servicios Core

**Archivo:** `api/callcentersite/callcentersite/apps/users/services_permisos_granular.py`

Implementa `UserManagementService` con metodos:
- asignar_grupo_a_usuario
- revocar_grupo_de_usuario
- obtener_grupos_de_usuario
- obtener_capacidades_de_usuario
- usuario_tiene_permiso
- otorgar_permiso_excepcional

**Uso:**
```python
from callcentersite.apps.users.services_permisos_granular import UserManagementService

# Asignar grupo a usuario
UserManagementService.asignar_grupo_a_usuario(
 usuario_id=123,
 grupo_codigo='atencion_cliente',
 asignado_por_id=1,
)

# Verificar permiso
tiene = UserManagementService.usuario_tiene_permiso(
 usuario_id=123,
 capacidad_codigo='sistema.operaciones.llamadas.realizar',
)
```

#### 4. Seed Data

**Archivo:** `api/callcentersite/callcentersite/apps/users/management/commands/seed_permisos_granular.py`

Comando Django para poblar base de datos con:
- 13 funciones del sistema
- 78 capacidades granulares (parcial en ejemplo)
- 10 grupos funcionales
- Relaciones grupo-capacidades

**Comando para ejecutar:**
```bash
cd api/callcentersite
python manage.py seed_permisos_granular
```

### Documentacion

#### 1. Guias Operativas

**Ubicacion:** `docs/guias/`

Guias creadas:
- onboarding_008: Operaciones basicas para agentes (10 min)
- workflows_005: Administracion de usuarios y grupos (15 min)
- workflows_006: Gestion de equipos coordinador (12 min)
- deployment_003: Implementacion tecnica permisos (25 min)
- deployment_004: Implementacion TDD Backend (30 min)
- deployment_005: Implementacion TDD Frontend (25 min)

#### 2. CODEOWNERS

**Archivo:** `CODEOWNERS`

Define ownership de documentacion de permisos:
```
/docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md @equipo-backend @equipo-ba
/docs/backend/requisitos/prioridad_01_estructura_base_datos.md @equipo-backend @equipo-dba
```

## Proximos Pasos

### Fase 1: Completar Tests Backend (Semana 1-2)

Siguiendo `deployment_004_tdd_backend_permisos_granular.md`:

1. Crear fixtures de tests en `tests/permissions/conftest.py`
2. Crear tests de modelos:
 - test_models_funciones.py
 - test_models_capacidades.py
 - test_models_grupos_permisos.py
3. Crear tests de servicios:
 - test_services_user_management.py
4. Ejecutar tests:
 ```bash
 pytest -m permissions
 ```

### Fase 2: Implementar API REST (Semana 2-3)

1. Crear serializers en `serializers_permisos_granular.py`
2. Crear viewsets en `views_permisos_granular.py`
3. Crear URLs en `urls_permisos_granular.py`
4. Crear tests de API:
 - test_views_funciones.py
 - test_views_grupos.py

### Fase 3: Frontend React (Semana 3-4)

Siguiendo `deployment_005_tdd_frontend_permisos_granular.md`:

1. Crear utilidades en `ui/src/utils/permissionHelpers.js`
2. Crear hooks en `ui/src/hooks/usePermissions.js`
3. Crear Redux slice en `ui/src/store/permissions/permissionsSlice.js`
4. Crear componentes:
 - PermissionChecker
 - UserGroupsManager
 - CapabilitiesViewer

### Fase 4: Tests End-to-End (Semana 4)

1. Implementar UC-001: Ana Lopez - Agente
2. Implementar UC-002: Carlos Ruiz - Coordinador
3. Implementar UC-003: Maria Fernandez - Analista
4. Implementar UC-004: Roberto Diaz - Responsable Financiero
5. Implementar UC-005: Laura Martinez - Administrador Tecnico

## Metricas Esperadas

### Backend
- Tests totales: 250-300
- Cobertura lineas: >= 90%
- Cobertura ramas: >= 85%
- Tiempo ejecucion: < 2 minutos

### Frontend
- Tests totales: 150-200
- Cobertura lineas: >= 80%
- Cobertura ramas: >= 75%
- Tiempo ejecucion: < 30 segundos

## Validacion de Implementacion

### Checklist Backend

- [ ] Migraciones aplicadas sin errores
- [ ] Seed data carga correctamente
- [ ] Modelos funcionan correctamente
- [ ] Servicios implementados
- [ ] Tests de modelos pasando
- [ ] Tests de servicios pasando
- [ ] API REST implementada
- [ ] Tests de API pasando
- [ ] Cobertura >= 90%

### Checklist Frontend

- [ ] Utilidades implementadas
- [ ] Hooks implementados
- [ ] Redux slice implementado
- [ ] Componentes implementados
- [ ] Tests unitarios pasando
- [ ] Tests de integracion pasando
- [ ] Cobertura >= 80%

### Checklist Integracion

- [ ] UC-001 completo
- [ ] UC-002 completo
- [ ] UC-003 completo
- [ ] UC-004 completo
- [ ] UC-005 completo
- [ ] Tests E2E pasando

## Comandos Utiles

### Backend

```bash
# Crear y aplicar migraciones
python manage.py makemigrations users
python manage.py migrate users

# Poblar base de datos
python manage.py seed_permisos_granular

# Ejecutar tests
pytest -m permissions
pytest -m permissions --cov

# Ejecutar tests especificos
pytest tests/permissions/test_models_funciones.py
pytest tests/permissions/test_services_user_management.py
```

### Frontend

```bash
# Instalar dependencias
cd ui
npm install

# Ejecutar tests
npm test

# Ejecutar tests con cobertura
npm run test:coverage

# Ejecutar tests en watch mode (TDD)
npm run test:watch
```

## Referencias

- Indice maestro: `docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md`
- Base de datos: `docs/backend/requisitos/prioridad_01_estructura_base_datos.md`
- Grupos funcionales: `docs/backend/requisitos/CATALOGO_GRUPOS_FUNCIONALES.md`
- Casos de uso: `docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md`
- Guia TDD Backend: `docs/guias/deployment/deployment_004_tdd_backend_permisos_granular.md`
- Guia TDD Frontend: `docs/guias/deployment/deployment_005_tdd_backend_permisos_granular.md`

## Equipo

- Backend: @equipo-backend
- Frontend: @equipo-frontend
- QA: @equipo-qa
- BA: @equipo-ba
- DBA: @equipo-dba

## Notas

Este es un **esqueleto base** de implementacion siguiendo TDD. El equipo debe continuar implementando:
1. Tests siguiendo las guias
2. Codigo para hacer pasar los tests
3. Refactorizacion manteniendo tests verdes

La filosofia es **RED-GREEN-REFACTOR**:
1. RED: Escribir test que falle
2. GREEN: Escribir codigo minimo para pasar
3. REFACTOR: Mejorar codigo manteniendo tests pasando

---

**Version**: 1.0.0
**Ultima actualizacion**: 2025-11-07
**Proxima revision**: 2025-11-14
