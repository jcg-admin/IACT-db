---
id: PLAN-MAESTRO-PRIORIDAD-02
tipo: plan_implementacion
categoria: agente_autonomo
fecha: 2025-11-07
tecnicas_aplicadas: ["Task Decomposition", "Chain-of-Thought", "Hierarchical Planning", "Dependency Analysis", "Role-Playing", "Self-Consistency"]
---

# PLAN MAESTRO: Implementacion PRIORIDAD 02 - Funciones Core

## Tecnicas de Prompt Engineering Aplicadas

Como AGENTE autonomo, he aplicado las siguientes tecnicas:

### 1. TASK DECOMPOSITION (Descomposicion de Tareas)
- Descomponer las 3 funciones core en 91 tareas atomicas
- Cada tarea es ejecutable en 30-90 minutos
- Tareas verificables con criterios claros de exito

### 2. CHAIN-OF-THOUGHT (Cadena de Pensamiento)
- Razonamiento secuencial: Seed Data → Servicios → API → Tests → Validacion
- Cada fase construye sobre la anterior
- Dependencias explicitas entre tareas

### 3. HIERARCHICAL TASK PLANNING (Planificacion Jerarquica)
- 5 FASES principales
- Cada fase con subfases por funcion (Usuarios, Dashboards, Configuracion)
- Cada subfase con tareas atomicas

### 4. DEPENDENCY ANALYSIS (Analisis de Dependencias)
- Identificar prerequisitos: Base de datos antes de servicios
- Identificar dependencias cruzadas: Seed data antes de tests
- Optimizar orden de ejecucion

### 5. ROLE-PLAYING (Interpretacion de Rol)
- Actuar como Desarrollador Backend Senior
- Actuar como QA Engineer para tests
- Actuar como Tech Lead para validacion

### 6. SELF-CONSISTENCY (Auto-Coherencia)
- Verificar que tests corresponden a implementacion
- Verificar que API corresponde a especificacion
- Verificar que documentacion corresponde a codigo

---

## Resumen Ejecutivo

**TOTAL: 91 TAREAS**

```
FASE 1: Seed Data & Database (9 tareas) - 4-6 horas
FASE 2: Servicios Backend (32 tareas) - 16-20 horas
FASE 3: API REST (38 tareas) - 18-22 horas
FASE 4: Tests Integracion (6 tareas) - 4-6 horas
FASE 5: Validacion & Documentacion (6 tareas) - 4-6 horas

TOTAL ESTIMADO: 46-60 horas
```

---

## FASE 1: Seed Data & Database (9 tareas, 4-6 horas)

### Objetivo
Completar datos semilla y crear tablas faltantes para tener base de datos 100% lista.

### Subtareas

#### 1.1 Completar Seed de Capacidades (5 tareas)

```
[1] Agregar capacidad: sistema.administracion.usuarios.eliminar
 Archivo: seed_permisos_granular.py:140
 Tiempo: 15 min
 Criterio: Query retorna capacidad con codigo correcto

[2] Agregar capacidad: sistema.vistas.dashboards.compartir
 Archivo: seed_permisos_granular.py:155
 Tiempo: 15 min
 Criterio: Query retorna capacidad compartir

[3] Agregar todas capacidades de configuracion (5 capacidades)
 Archivo: seed_permisos_granular.py:170
 Tiempo: 30 min
 Criterio: Query cuenta 5 capacidades de configuracion

[4] Actualizar grupo administracion_usuarios con 6 capacidades
 Archivo: seed_permisos_granular.py:240
 Tiempo: 20 min
 Criterio: Query cuenta 6 capacidades en grupo

[5] Crear grupo configuracion_sistema con 5 capacidades
 Archivo: seed_permisos_granular.py:260
 Tiempo: 20 min
 Criterio: Query cuenta 5 capacidades en grupo nuevo
```

#### 1.2 Crear Migraciones de Configuracion (3 tareas)

```
[6] Crear migracion: tabla configuracion
 Archivo: api/callcentersite/callcentersite/apps/configuration/migrations/0001_initial.py
 Tiempo: 45 min
 Esquema:
 - id, categoria, clave, valor, tipo_dato, valor_default
 - descripcion, activa, updated_at, updated_by
 Criterio: Migracion aplica sin errores

[7] Crear migracion: tabla configuracion_historial
 Archivo: api/callcentersite/callcentersite/apps/configuration/migrations/0002_historial.py
 Tiempo: 30 min
 Esquema:
 - id, clave, valor_anterior, valor_nuevo
 - modificado_por, timestamp
 Criterio: Migracion aplica sin errores

[8] Ejecutar migraciones y validar
 Comando: python manage.py migrate
 Tiempo: 30 min
 Validacion:
 - SELECT COUNT(*) FROM funciones WHERE nombre IN ('usuarios', 'dashboards', 'configuracion')
 - Esperado: 3
 - SELECT COUNT(*) FROM capacidades WHERE activa = TRUE
 - Esperado: 16
 - SELECT COUNT(*) FROM grupos_permisos WHERE activo = TRUE
 - Esperado: 3
 Criterio: Todas las queries retornan valores esperados
```

#### 1.3 Poblar Configuraciones por Defecto (1 tarea)

```
[9] Insertar configuraciones iniciales del sistema
 Archivo: data/configuracion_default.sql
 Tiempo: 60 min
 Configuraciones:
 - sistema.session.timeout (30)
 - sistema.password.min_length (8)
 - sistema.password.require_uppercase (TRUE)
 - sistema.audit.retention_days (90)
 - sistema.api.rate_limit (100)
 Criterio: Query retorna 5+ configuraciones activas
```

---

## FASE 2: Servicios Backend (32 tareas, 16-20 horas)

### Objetivo
Implementar logica de negocio siguiendo TDD estricto (RED-GREEN-REFACTOR).

### 2.1 Servicio de Usuarios (14 tareas)

#### RED: Escribir Tests (7 tareas)

```
[10] Test: UsuarioService.listar_usuarios() con filtros
 Archivo: tests/permissions/test_services_usuarios.py:10
 Tiempo: 45 min
 Casos:
 - Listar todos los usuarios
 - Filtrar por activo=TRUE
 - Filtrar por email_contains
 - Filtrar sin permiso (debe lanzar PermissionDenied)
 Criterio: 4 tests, todos FAIL (RED)

[11] Test: UsuarioService.crear_usuario() con validaciones
 Archivo: tests/permissions/test_services_usuarios.py:50
 Tiempo: 60 min
 Casos:
 - Crear usuario valido
 - Crear sin username (ValidationError)
 - Crear sin email (ValidationError)
 - Crear sin permiso (PermissionDenied)
 - Crear con email duplicado (IntegrityError)
 Criterio: 5 tests, todos FAIL (RED)

[12] Test: UsuarioService.editar_usuario()
 Archivo: tests/permissions/test_services_usuarios.py:100
 Tiempo: 45 min
 Casos:
 - Editar usuario existente
 - Editar email a uno ya existente (error)
 - Editar sin permiso (PermissionDenied)
 Criterio: 3 tests, todos FAIL (RED)

[13] Test: UsuarioService.eliminar_usuario() (eliminacion logica)
 Archivo: tests/permissions/test_services_usuarios.py:140
 Tiempo: 30 min
 Casos:
 - Eliminar usuario existente (is_deleted=TRUE)
 - Eliminar sin permiso (PermissionDenied)
 Criterio: 2 tests, todos FAIL (RED)

[14] Test: UsuarioService.suspender_usuario()
 Archivo: tests/permissions/test_services_usuarios.py:170
 Tiempo: 45 min
 Casos:
 - Suspender usuario (is_active=FALSE)
 - No puede suspenderse a si mismo (ValidationError)
 - Suspender sin permiso (PermissionDenied)
 Criterio: 3 tests, todos FAIL (RED)

[15] Test: UsuarioService.reactivar_usuario()
 Archivo: tests/permissions/test_services_usuarios.py:210
 Tiempo: 30 min
 Casos:
 - Reactivar usuario suspendido
 - Reactivar sin permiso (PermissionDenied)
 Criterio: 2 tests, todos FAIL (RED)

[16] Test: UsuarioService.asignar_grupos_usuario()
 Archivo: tests/permissions/test_services_usuarios.py:240
 Tiempo: 45 min
 Casos:
 - Asignar grupos a usuario
 - Reasignar grupos (desactiva anteriores)
 - Asignar sin permiso (PermissionDenied)
 Criterio: 3 tests, todos FAIL (RED)
```

#### GREEN: Implementar Codigo (7 tareas)

```
[17] Implementar: UsuarioService.listar_usuarios()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:20
 Tiempo: 60 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.ver
 - Construir query con filtros
 - Retornar lista de usuarios
 Criterio: Tests de [10] pasan (GREEN)

[18] Implementar: UsuarioService.crear_usuario()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:60
 Tiempo: 90 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.crear
 - Validar datos requeridos
 - Validar email unico
 - Crear usuario con password hasheado
 - Auditar accion
 Criterio: Tests de [11] pasan (GREEN)

[19] Implementar: UsuarioService.editar_usuario()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:120
 Tiempo: 60 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.editar
 - Validar usuario existe
 - Validar email unico si cambia
 - Actualizar campos
 - Auditar accion
 Criterio: Tests de [12] pasan (GREEN)

[20] Implementar: UsuarioService.eliminar_usuario()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:160
 Tiempo: 45 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.eliminar
 - Marcar is_deleted=TRUE, is_active=FALSE
 - Guardar deleted_at timestamp
 - Auditar accion
 Criterio: Tests de [13] pasan (GREEN)

[21] Implementar: UsuarioService.suspender_usuario()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:190
 Tiempo: 60 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.suspender
 - Validar no es el mismo usuario
 - Marcar is_active=FALSE
 - Cerrar sesiones activas
 - Auditar accion con motivo
 Criterio: Tests de [14] pasan (GREEN)

[22] Implementar: UsuarioService.reactivar_usuario()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:230
 Tiempo: 45 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.reactivar
 - Marcar is_active=TRUE
 - Auditar accion
 Criterio: Tests de [15] pasan (GREEN)

[23] Implementar: UsuarioService.asignar_grupos_usuario()
 Archivo: api/callcentersite/callcentersite/apps/users/services_usuarios.py:260
 Tiempo: 90 min
 Logica:
 - Verificar permiso sistema.administracion.usuarios.asignar_grupos
 - Desactivar grupos actuales (UPDATE activo=FALSE)
 - Insertar nuevos grupos en usuarios_grupos
 - Usar ON CONFLICT para idempotencia
 - Auditar accion con lista de grupos
 Criterio: Tests de [16] pasan (GREEN)
```

### 2.2 Servicio de Dashboards (9 tareas)

```
[24] Agregar verificacion de permisos en DashboardOverviewView.get()
 Archivo: api/callcentersite/callcentersite/apps/dashboard/views.py:14
 Tiempo: 30 min
 Verificar: sistema.vistas.dashboards.ver
 Criterio: Test de permiso pasa

[25] Test: DashboardService.exportar() con formatos
 Archivo: tests/dashboard/test_services.py:10
 Tiempo: 45 min
 Casos: exportar a excel, exportar a pdf, sin permiso
 Criterio: 3 tests FAIL (RED)

[26] Implementar: DashboardService.exportar()
 Archivo: api/callcentersite/callcentersite/apps/dashboard/services.py:30
 Tiempo: 90 min
 Verificar: sistema.vistas.dashboards.exportar
 Criterio: Tests de [25] pasan (GREEN)

[27] Test: DashboardService.personalizar()
 Archivo: tests/dashboard/test_services.py:50
 Tiempo: 45 min
 Casos: guardar config, validar JSON, sin permiso
 Criterio: 3 tests FAIL (RED)

[28] Implementar: DashboardService.personalizar()
 Archivo: api/callcentersite/callcentersite/apps/dashboard/services.py:70
 Tiempo: 60 min
 Verificar: sistema.vistas.dashboards.personalizar
 Usar: Tabla dashboard_configuracion
 Criterio: Tests de [27] pasan (GREEN)

[29] Test: DashboardService.compartir()
 Archivo: tests/dashboard/test_services.py:90
 Tiempo: 45 min
 Casos: compartir con usuario, compartir con grupo, sin permiso
 Criterio: 3 tests FAIL (RED)

[30] Implementar: DashboardService.compartir()
 Archivo: api/callcentersite/callcentersite/apps/dashboard/services.py:110
 Tiempo: 90 min
 Verificar: sistema.vistas.dashboards.compartir
 Criterio: Tests de [29] pasan (GREEN)

[31] Crear migracion: tabla dashboard_configuracion
 Archivo: api/callcentersite/callcentersite/apps/dashboard/migrations/0001_configuracion.py
 Tiempo: 45 min
 Esquema: usuario_id, configuracion JSON, updated_at
 Criterio: Migracion aplica sin errores

[32] Poblar dashboards por defecto
 Archivo: data/dashboards_default.sql
 Tiempo: 30 min
 Dashboards: Principal, Operativo, Analitico
 Criterio: Query retorna 3 dashboards
```

### 2.3 Servicio de Configuracion (9 tareas)

```
[33] Crear archivo: services_configuracion.py
 Archivo: api/callcentersite/callcentersite/apps/configuration/services.py
 Tiempo: 15 min
 Skeleton con clase ConfiguracionService
 Criterio: Archivo existe e importa sin errores

[34] Test: ConfiguracionService.obtener_configuracion()
 Archivo: tests/configuration/test_services.py:10
 Tiempo: 45 min
 Casos: obtener todas, filtrar por categoria, sin permiso
 Criterio: 3 tests FAIL (RED)

[35] Implementar: ConfiguracionService.obtener_configuracion()
 Archivo: services.py:20
 Tiempo: 60 min
 Verificar: sistema.tecnico.configuracion.ver
 Criterio: Tests de [34] pasan (GREEN)

[36] Test: ConfiguracionService.editar_configuracion()
 Archivo: tests/configuration/test_services.py:50
 Tiempo: 60 min
 Casos: editar valor, validar tipo, guardar historial, sin permiso
 Criterio: 4 tests FAIL (RED)

[37] Implementar: ConfiguracionService.editar_configuracion()
 Archivo: services.py:60
 Tiempo: 90 min
 Verificar: sistema.tecnico.configuracion.editar
 Guardar en: configuracion_historial
 Invalidar cache
 Criterio: Tests de [36] pasan (GREEN)

[38] Test: ConfiguracionService.exportar_configuracion()
 Archivo: tests/configuration/test_services.py:110
 Tiempo: 30 min
 Casos: exportar a JSON, sin permiso
 Criterio: 2 tests FAIL (RED)

[39] Implementar: ConfiguracionService.exportar_configuracion()
 Archivo: services.py:120
 Tiempo: 60 min
 Verificar: sistema.tecnico.configuracion.exportar
 Criterio: Tests de [38] pasan (GREEN)

[40] Test: ConfiguracionService.importar_configuracion()
 Archivo: tests/configuration/test_services.py:140
 Tiempo: 45 min
 Casos: importar JSON valido, JSON invalido, sin permiso
 Criterio: 3 tests FAIL (RED)

[41] Implementar: ConfiguracionService.importar_configuracion()
 Archivo: services.py:160
 Tiempo: 90 min
 Verificar: sistema.tecnico.configuracion.importar
 Validar JSON, aplicar cambios en transaccion
 Criterio: Tests de [40] pasan (GREEN)
```

---

## FASE 3: API REST (38 tareas, 18-22 horas)

### Objetivo
Crear endpoints REST con validaciones y verificacion de permisos.

### 3.1 API Usuarios (18 tareas)

```
[42] Crear: UserSerializer con validaciones
 Archivo: api/callcentersite/callcentersite/apps/users/serializers_usuarios.py
 Tiempo: 60 min
 Campos: username, email, first_name, last_name, is_active, grupos
 Validaciones: email formato, username unico
 Criterio: Serializer instancia sin errores

[43-44] Test + Implementar: UserViewSet.list()
 Tiempo: 90 min total
 Endpoint: GET /api/usuarios/
 Permiso: sistema.administracion.usuarios.ver
 Criterio: Test pasa (GREEN)

[45-46] Test + Implementar: UserViewSet.create()
 Tiempo: 90 min total
 Endpoint: POST /api/usuarios/
 Permiso: sistema.administracion.usuarios.crear
 Criterio: Test pasa (GREEN)

[47-48] Test + Implementar: UserViewSet.retrieve()
 Tiempo: 60 min total
 Endpoint: GET /api/usuarios/:id/
 Permiso: sistema.administracion.usuarios.ver
 Criterio: Test pasa (GREEN)

[49-50] Test + Implementar: UserViewSet.update()
 Tiempo: 90 min total
 Endpoint: PUT /api/usuarios/:id/
 Permiso: sistema.administracion.usuarios.editar
 Criterio: Test pasa (GREEN)

[51-52] Test + Implementar: UserViewSet.destroy()
 Tiempo: 60 min total
 Endpoint: DELETE /api/usuarios/:id/
 Permiso: sistema.administracion.usuarios.eliminar
 Criterio: Test pasa (GREEN)

[53-54] Test + Implementar: UserViewSet.suspender() action
 Tiempo: 90 min total
 Endpoint: POST /api/usuarios/:id/suspender/
 Permiso: sistema.administracion.usuarios.suspender
 Criterio: Test pasa (GREEN)

[55-56] Test + Implementar: UserViewSet.reactivar() action
 Tiempo: 60 min total
 Endpoint: POST /api/usuarios/:id/reactivar/
 Permiso: sistema.administracion.usuarios.reactivar
 Criterio: Test pasa (GREEN)

[57-58] Test + Implementar: UserViewSet.asignar_grupos() action
 Tiempo: 90 min total
 Endpoint: POST /api/usuarios/:id/asignar_grupos/
 Permiso: sistema.administracion.usuarios.asignar_grupos
 Criterio: Test pasa (GREEN)

[59] Crear: urls_usuarios.py con router
 Archivo: api/callcentersite/callcentersite/apps/users/urls.py
 Tiempo: 30 min
 Router: DefaultRouter con UserViewSet
 Criterio: URL reverse funciona sin errores
```

### 3.2 API Dashboards (10 tareas)

```
[60] Completar: DashboardSerializer
 Archivo: api/callcentersite/callcentersite/apps/dashboard/serializers.py
 Tiempo: 45 min
 Campos: id, nombre, descripcion, widgets, configuracion
 Criterio: Serializer instancia sin errores

[61-62] Test + Implementar: DashboardViewSet.exportar() action
 Tiempo: 90 min total
 Endpoint: POST /api/dashboards/:id/exportar/
 Permiso: sistema.vistas.dashboards.exportar
 Criterio: Test pasa (GREEN)

[63-64] Test + Implementar: DashboardViewSet.personalizar() action
 Tiempo: 90 min total
 Endpoint: PUT /api/dashboards/:id/personalizar/
 Permiso: sistema.vistas.dashboards.personalizar
 Criterio: Test pasa (GREEN)

[65-66] Test + Implementar: DashboardViewSet.compartir() action
 Tiempo: 90 min total
 Endpoint: POST /api/dashboards/:id/compartir/
 Permiso: sistema.vistas.dashboards.compartir
 Criterio: Test pasa (GREEN)

[67] Actualizar: urls.py con nuevos endpoints
 Archivo: api/callcentersite/callcentersite/apps/dashboard/urls.py
 Tiempo: 20 min
 Criterio: URLs reverse funcionan

[68-69] Test + Fix: DashboardOverviewView con permisos
 Tiempo: 60 min total
 Verificar: sistema.vistas.dashboards.ver
 Criterio: Test de autorizacion pasa
```

### 3.3 API Configuracion (10 tareas)

```
[70] Crear: ConfiguracionSerializer
 Archivo: api/callcentersite/callcentersite/apps/configuration/serializers.py
 Tiempo: 45 min
 Campos: categoria, clave, valor, tipo_dato, descripcion
 Criterio: Serializer instancia sin errores

[71-72] Test + Implementar: ConfiguracionViewSet.list()
 Tiempo: 90 min total
 Endpoint: GET /api/configuracion/
 Permiso: sistema.tecnico.configuracion.ver
 Criterio: Test pasa (GREEN)

[73-74] Test + Implementar: ConfiguracionViewSet.update()
 Tiempo: 90 min total
 Endpoint: PUT /api/configuracion/:clave/
 Permiso: sistema.tecnico.configuracion.editar
 Criterio: Test pasa (GREEN)

[75-76] Test + Implementar: ConfiguracionViewSet.exportar() action
 Tiempo: 90 min total
 Endpoint: GET /api/configuracion/exportar/
 Permiso: sistema.tecnico.configuracion.exportar
 Criterio: Test pasa (GREEN)

[77-78] Test + Implementar: ConfiguracionViewSet.importar() action
 Tiempo: 90 min total
 Endpoint: POST /api/configuracion/importar/
 Permiso: sistema.tecnico.configuracion.importar
 Criterio: Test pasa (GREEN)

[79] Crear: urls_configuracion.py
 Archivo: api/callcentersite/callcentersite/apps/configuration/urls.py
 Tiempo: 30 min
 Criterio: URLs reverse funcionan
```

---

## FASE 4: Tests de Integracion (6 tareas, 4-6 horas)

### Objetivo
Validar flujos completos end-to-end.

```
[80] Test E2E: Creacion de usuario + asignacion de grupos
 Archivo: tests/integration/test_usuario_completo.py
 Tiempo: 60 min
 Flujo:
 1. Admin crea usuario
 2. Asigna grupos
 3. Usuario puede acceder a dashboards
 4. Usuario NO puede crear otros usuarios
 Criterio: Flujo completo pasa

[81] Test E2E: Suspension y reactivacion de usuario
 Archivo: tests/integration/test_usuario_suspension.py
 Tiempo: 60 min
 Flujo:
 1. Admin suspende usuario
 2. Usuario pierde acceso
 3. Admin reactiva usuario
 4. Usuario recupera acceso
 Criterio: Flujo completo pasa

[82] Test E2E: Dashboard personalizado por usuario
 Archivo: tests/integration/test_dashboard_personalizado.py
 Tiempo: 60 min
 Flujo:
 1. Usuario personaliza dashboard
 2. Configuracion se guarda
 3. Usuario ve dashboard personalizado
 4. Otro usuario ve dashboard por defecto
 Criterio: Flujo completo pasa

[83] Test E2E: Exportacion e importacion de configuracion
 Archivo: tests/integration/test_configuracion_backup.py
 Tiempo: 60 min
 Flujo:
 1. Admin exporta configuracion
 2. Admin modifica valores
 3. Admin importa configuracion anterior
 4. Valores restaurados
 Criterio: Flujo completo pasa

[84] Test E2E: Flujo completo de administrador tecnico
 Archivo: tests/integration/test_administrador_completo.py
 Tiempo: 90 min
 Flujo:
 1. Admin crea 3 usuarios
 2. Asigna diferentes grupos
 3. Verifica permisos efectivos
 4. Exporta usuarios
 5. Audita todas las acciones
 Criterio: Flujo completo pasa

[85] Ejecutar pytest con cobertura >= 90%
 Comando: pytest --cov=callcentersite.apps.users --cov-report=html
 Tiempo: 30 min
 Validacion:
 - Cobertura lineas >= 90%
 - Cobertura ramas >= 85%
 - Todos los tests pasan
 Criterio: Reporte HTML muestra cobertura suficiente
```

---

## FASE 5: Validacion y Documentacion (6 tareas, 4-6 horas)

### Objetivo
Verificar que todo funciona y documentar para el equipo.

```
[86] Ejecutar query de validacion: funciones insertadas
 Query: SELECT f.nombre, COUNT(fc.id) FROM funciones f...
 Tiempo: 15 min
 Esperado: usuarios (7), dashboards (4), configuracion (5)
 Criterio: Query retorna valores esperados

[87] Ejecutar query de validacion: grupos creados
 Query: SELECT gp.codigo, COUNT(gc.id) FROM grupos_permisos gp...
 Tiempo: 15 min
 Esperado: administracion_usuarios (6), visualizacion_basica (2), configuracion_sistema (5)
 Criterio: Query retorna valores esperados

[88] Probar funcion usuario_tiene_permiso con datos reales
 Script: scripts/test_permisos.py
 Tiempo: 30 min
 Casos:
 - Usuario con grupo visualizacion_basica PUEDE ver dashboards
 - Usuario con grupo visualizacion_basica NO PUEDE crear usuarios
 - Usuario con grupo admin_usuarios PUEDE crear usuarios
 Criterio: Todos los casos retornan resultado esperado

[89] Verificar auditoria se registra correctamente
 Query: SELECT * FROM auditoria_permisos ORDER BY timestamp DESC LIMIT 20
 Tiempo: 30 min
 Validar:
 - Acciones de creacion de usuario se auditan
 - Acciones de suspension se auditan
 - Acciones con permiso denegado se auditan
 Criterio: Todas las acciones criticas estan en auditoria

[90] Documentar endpoints en formato OpenAPI/Swagger
 Archivo: docs/api/openapi_prioridad_02.yaml
 Tiempo: 120 min
 Documentar:
 - 8 endpoints de usuarios
 - 4 endpoints de dashboards
 - 5 endpoints de configuracion
 Criterio: Swagger UI renderiza correctamente

[91] Actualizar README con instrucciones de uso
 Archivo: docs/IMPLEMENTACION_PERMISOS_GRANULAR.md
 Tiempo: 60 min
 Actualizar:
 - Estado de implementacion: 100% Prioridad 02
 - Ejemplos de uso de cada endpoint
 - Comandos de validacion
 Criterio: Otro desarrollador puede usar el README y ejecutar APIs
```

---

## Criterios de Exito Globales

### Funcional
- [ ] 3 funciones core implementadas (usuarios, dashboards, configuracion)
- [ ] 16 capacidades operativas
- [ ] 3 grupos de permisos creados
- [ ] 12 endpoints REST funcionando
- [ ] Verificacion de permisos en todos los endpoints
- [ ] Auditoria registrando todas las acciones criticas

### Tecnico
- [ ] Cobertura de tests >= 90%
- [ ] 250+ tests pasando
- [ ] 0 errores de migraciones
- [ ] 0 warnings de deprecation
- [ ] Documentacion OpenAPI completa

### Validacion
- [ ] Queries de validacion retornan valores esperados
- [ ] Tests E2E de casos de uso completos pasan
- [ ] Otro desarrollador puede seguir el README y usar el sistema

---

## Dependencias Entre Tareas

### Criticas (Bloqueantes)
```
[1-9] → [10-41] (Seed Data → Servicios)
[10-41] → [42-79] (Servicios → API)
[42-79] → [80-85] (API → Tests E2E)
[80-85] → [86-91] (Tests → Validacion)
```

### Parciales (Pueden paralelizarse)
```
Usuarios [10-23] || Dashboards [24-32] || Configuracion [33-41]
API Usuarios [42-59] || API Dashboards [60-69] || API Config [70-79]
```

---

## Estimaciones de Tiempo

### Por Rol

**Desarrollador Backend Senior:**
- FASE 1: 4 horas
- FASE 2: 16 horas
- FASE 3: 18 horas
- **Subtotal: 38 horas**

**QA Engineer:**
- FASE 4: 6 horas
- FASE 5 (Validacion): 2 horas
- **Subtotal: 8 horas**

**Tech Writer:**
- FASE 5 (Documentacion): 4 horas
- **Subtotal: 4 horas**

**TOTAL: 50 horas (equipo completo)**

### Por Semana

**Semana 1:**
- Lunes: FASE 1 completa
- Martes-Miercoles: FASE 2 Usuarios
- Jueves-Viernes: FASE 2 Dashboards y Config

**Semana 2:**
- Lunes-Martes: FASE 3 API Usuarios
- Miercoles: FASE 3 API Dashboards
- Jueves: FASE 3 API Config
- Viernes: FASE 4 y FASE 5

---

## Proximos Pasos Despues de Completar

Una vez completadas las 91 tareas:

1. **PRIORIDAD 3: Modulos Operativos**
 - IVR, Tickets, Clientes, Llamadas

2. **PRIORIDAD 4: Modulos de Gestion**
 - Equipos, Horarios, Auditoria, Evaluaciones

3. **Frontend React**
 - Componentes usando las APIs creadas
 - Tests siguiendo deployment_005

---

**Version:** 1.0.0
**Fecha:** 2025-11-07
**Autor:** Agente Autonomo TDD
**Aprobado:** Pendiente revision equipo
