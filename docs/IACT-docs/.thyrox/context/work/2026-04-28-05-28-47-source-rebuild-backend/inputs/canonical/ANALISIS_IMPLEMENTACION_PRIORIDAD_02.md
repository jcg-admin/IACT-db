---
id: ANALISIS-IMPLEMENTACION-PRIORIDAD-02
tipo: reporte_tecnico
fecha: 2025-11-07
estado: analisis_completado
---

# Analisis de Implementacion: PRIORIDAD 2 - Funciones Core

## Resumen Ejecutivo

**Estado General: PARCIALMENTE IMPLEMENTADO (35%)**

De las 3 funciones core requeridas:
- Usuarios: 15% implementado (solo infraestructura de permisos)
- Dashboards: 20% implementado (solo endpoint basico)
- Configuracion: 0% implementado

---

## Analisis Detallado por Funcion

### 1. FUNCION: USUARIOS (sistema.administracion.usuarios)

**Estado: 15% IMPLEMENTADO**

#### QUE ESTA IMPLEMENTADO:

**A. Infraestructura de Base de Datos:**
```
COMPLETADO:
- Tabla funciones (tiene entrada para 'usuarios')
- Tabla capacidades (tiene capacidades para usuarios)
- Tabla grupos_permisos (puede tener grupo 'administracion_usuarios')
- Migracion: 0001_initial_permisos_granular.py

UBICACION: api/callcentersite/callcentersite/apps/users/migrations/
```

**B. Seed Data:**
```
PARCIALMENTE IMPLEMENTADO:
- Script de seed incluye funcion 'usuarios'
- Script incluye 6 capacidades de usuarios:
 * sistema.administracion.usuarios.ver
 * sistema.administracion.usuarios.crear
 * sistema.administracion.usuarios.editar
 * sistema.administracion.usuarios.suspender
 * sistema.administracion.usuarios.reactivar
 * sistema.administracion.usuarios.asignar_grupos

FALTA:
 * sistema.administracion.usuarios.eliminar
 * sistema.administracion.usuarios.exportar

UBICACION: api/callcentersite/callcentersite/apps/users/management/commands/seed_permisos_granular.py
```

**C. Servicios:**
```
IMPLEMENTADO (pero NO para CRUD de usuarios):
- UserManagementService: Gestion de PERMISOS y GRUPOS
 * asignar_grupo_a_usuario()
 * revocar_grupo_de_usuario()
 * obtener_grupos_de_usuario()
 * obtener_capacidades_de_usuario()
 * usuario_tiene_permiso()
 * otorgar_permiso_excepcional()

UBICACION: api/callcentersite/callcentersite/apps/users/services_permisos_granular.py

NOTA CRITICA: Este servicio es para PERMISOS, NO para operaciones CRUD de usuarios.
```

#### QUE FALTA IMPLEMENTAR:

**A. Servicio de Usuarios (CRUD):**
```
FALTA COMPLETAMENTE:
- UsuarioService con metodos:
 * listarUsuarios(filtros, paginacion)
 * crearUsuario(datos)
 * editarUsuario(usuario_id, datos)
 * eliminarUsuario(usuario_id)
 * suspenderUsuario(usuario_id, motivo)
 * reactivarUsuario(usuario_id)
 * exportarUsuarios(filtros, formato)

DEBE CREARSE EN: api/callcentersite/callcentersite/apps/users/services_usuarios.py
```

**B. API REST Endpoints:**
```
FALTA COMPLETAMENTE:
- GET /api/usuarios (listar con filtros)
- POST /api/usuarios (crear)
- GET /api/usuarios/:id (detalle)
- PUT /api/usuarios/:id (editar)
- DELETE /api/usuarios/:id (eliminar)
- POST /api/usuarios/:id/suspender (suspender)
- POST /api/usuarios/:id/reactivar (reactivar)
- GET /api/usuarios/exportar (exportar)

ARCHIVOS A CREAR:
- api/callcentersite/callcentersite/apps/users/serializers_usuarios.py
- api/callcentersite/callcentersite/apps/users/views_usuarios.py
- api/callcentersite/callcentersite/apps/users/urls.py
```

**C. Tests:**
```
FALTA COMPLETAMENTE:
- tests/permissions/test_services_usuarios.py
- tests/permissions/test_views_usuarios.py
- tests/permissions/test_serializers_usuarios.py
```

---

### 2. FUNCION: DASHBOARDS (sistema.vistas.dashboards)

**Estado: 20% IMPLEMENTADO**

#### QUE ESTA IMPLEMENTADO:

**A. Infraestructura Basica:**
```
COMPLETADO:
- App dashboard existe: api/callcentersite/callcentersite/apps/dashboard/
- Archivos existentes:
 * views.py (con DashboardOverviewView)
 * services.py (con DashboardService.overview())
 * urls.py (con ruta /overview/)
 * widgets.py (registro de widgets)
```

**B. Endpoint Basico:**
```
IMPLEMENTADO:
- GET /api/dashboard/overview/
 * Retorna widgets disponibles
 * Usa DashboardService.overview()
 * Sin verificacion de permisos

UBICACION: api/callcentersite/callcentersite/apps/dashboard/views.py:11
```

**C. Seed Data:**
```
PARCIALMENTE IMPLEMENTADO:
- Funcion 'dashboards' en seed data
- Capacidades basicas:
 * sistema.vistas.dashboards.ver
 * sistema.vistas.dashboards.personalizar

FALTA:
 * sistema.vistas.dashboards.exportar
 * sistema.vistas.dashboards.solicitar
```

#### QUE FALTA IMPLEMENTAR:

**A. Verificacion de Permisos:**
```
FALTA:
- DashboardOverviewView NO verifica permisos
- Debe verificar: sistema.vistas.dashboards.ver
```

**B. Funcionalidad Completa:**
```
FALTA COMPLETAMENTE:
- POST /api/dashboards/exportar
 * Exportar dashboard a PDF/Excel
 * Permiso: sistema.vistas.dashboards.exportar

- PUT /api/dashboards/personalizar
 * Guardar configuracion de widgets
 * Permiso: sistema.vistas.dashboards.personalizar

- POST /api/dashboards/solicitar-acceso
 * Solicitar acceso a dashboards adicionales
 * Permiso: sistema.vistas.dashboards.solicitar
```

**C. Personalizacion de Usuario:**
```
FALTA COMPLETAMENTE:
- Tabla: dashboard_configuracion (usuario_id, configuracion JSON)
- Logica para guardar/cargar configuracion por usuario
- Logica para aplicar permisos a widgets
```

**D. Tests:**
```
FALTA COMPLETAMENTE:
- tests/dashboard/test_services.py
- tests/dashboard/test_views.py
- tests/dashboard/test_permissions.py
```

---

### 3. FUNCION: CONFIGURACION (sistema.tecnico.configuracion)

**Estado: 0% IMPLEMENTADO**

#### QUE ESTA IMPLEMENTADO:

**A. Seed Data:**
```
PARCIALMENTE IMPLEMENTADO:
- Funcion 'configuracion' en seed data
- NO se crean capacidades en seed actual

UBICACION: api/callcentersite/callcentersite/apps/users/management/commands/seed_permisos_granular.py:67-75
```

#### QUE FALTA IMPLEMENTAR:

**A. Base de Datos:**
```
FALTA COMPLETAMENTE:
- Tabla: configuracion
 * id, categoria, clave, valor, tipo_dato, valor_default, descripcion, activa
- Tabla: configuracion_historial
 * id, clave, valor_anterior, valor_nuevo, modificado_por, timestamp
```

**B. Capacidades en Seed:**
```
FALTA:
- sistema.tecnico.configuracion.ver
- sistema.tecnico.configuracion.editar
- sistema.tecnico.configuracion.exportar
- sistema.tecnico.configuracion.importar
- sistema.tecnico.configuracion.resetear
```

**C. Servicio:**
```
FALTA COMPLETAMENTE:
- ConfiguracionService con metodos:
 * obtenerConfiguracion(categoria)
 * editarConfiguracion(clave, nuevo_valor)
 * exportarConfiguracion()
 * importarConfiguracion(archivo)
 * resetearConfiguracion()

DEBE CREARSE EN: api/callcentersite/callcentersite/apps/*/services_configuracion.py
```

**D. API REST:**
```
FALTA COMPLETAMENTE:
- GET /api/configuracion
- PUT /api/configuracion/:clave
- GET /api/configuracion/exportar
- POST /api/configuracion/importar
- POST /api/configuracion/resetear
```

**E. Tests:**
```
FALTA COMPLETAMENTE:
- Todos los tests
```

---

## Grupos de Permisos

### Estado de Grupos

**IMPLEMENTADO EN SEED (parcial):**
```
- administracion_usuarios (creado, con capacidades)
- visualizacion_basica (creado, con capacidades)
- configuracion_sistema (FALTA crear y asignar capacidades)
```

---

## Checklist de Implementacion

### Usuarios
```
COMPLETADO:
[X] Tabla funciones con entrada 'usuarios'
[X] Migracion de base de datos
[X] Seed data basico (6 capacidades)
[X] Servicio de permisos (UserManagementService)

PENDIENTE:
[ ] Completar seed con capacidades faltantes (eliminar, exportar)
[ ] Crear UsuarioService (CRUD)
[ ] Crear serializers
[ ] Crear views/viewsets REST
[ ] Crear URLs
[ ] Implementar verificacion de permisos en endpoints
[ ] Crear tests unitarios
[ ] Crear tests de integracion
[ ] Crear tests de API
```

### Dashboards
```
COMPLETADO:
[X] App dashboard creada
[X] Vista basica (DashboardOverviewView)
[X] Servicio basico (DashboardService.overview)
[X] URL configurada (/overview/)
[X] Seed data basico (2 capacidades)

PENDIENTE:
[ ] Completar seed con capacidades faltantes
[ ] Agregar verificacion de permisos a vista existente
[ ] Crear tabla dashboard_configuracion
[ ] Implementar endpoints faltantes (exportar, personalizar, solicitar)
[ ] Implementar logica de personalizacion por usuario
[ ] Implementar exportacion (PDF/Excel)
[ ] Crear tests
```

### Configuracion
```
COMPLETADO:
[X] Seed data minimo (funcion registrada)

PENDIENTE:
[ ] Crear migracion para tablas (configuracion, configuracion_historial)
[ ] Completar seed con todas las capacidades
[ ] Poblar tabla configuracion con valores por defecto
[ ] Crear ConfiguracionService
[ ] Crear serializers
[ ] Crear views/viewsets REST
[ ] Crear URLs
[ ] Implementar verificacion de permisos
[ ] Crear tests
```

---

## Estimacion de Trabajo Pendiente

### Por Funcion

**Usuarios:**
- Tiempo estimado: 16-20 horas
- Prioridad: CRITICA
- Complejidad: MEDIA

**Dashboards:**
- Tiempo estimado: 12-16 horas
- Prioridad: ALTA
- Complejidad: MEDIA

**Configuracion:**
- Tiempo estimado: 16-20 horas
- Prioridad: ALTA
- Complejidad: MEDIA-ALTA

**TOTAL: 44-56 horas (1-1.5 semanas con equipo completo)**

---

## Recomendaciones

### Orden de Implementacion Sugerido:

1. **USUARIOS** (Prioridad 1)
 - Es la base para todo el sistema
 - Necesario para gestionar quienes usan el sistema
 - 16-20 horas

2. **DASHBOARDS** (Prioridad 2)
 - Ya tiene base implementada
 - Necesario para navegacion de usuarios
 - 12-16 horas

3. **CONFIGURACION** (Prioridad 3)
 - Menos critico para MVP
 - Puede usar valores hardcoded inicialmente
 - 16-20 horas

### Acciones Inmediatas:

1. Completar seed_permisos_granular.py con TODAS las capacidades
2. Crear UsuarioService siguiendo el pseudocodigo de prioridad_02_funciones_core.md
3. Implementar API REST de usuarios siguiendo guia TDD
4. Agregar verificacion de permisos a DashboardOverviewView

---

## Archivos Clave

### Existentes:
```
api/callcentersite/callcentersite/apps/users/
 migrations/
 0001_initial_permisos_granular.py [CREADO]
 management/commands/
 seed_permisos_granular.py [CREADO - PARCIAL]
 models_permisos_granular.py [CREADO]
 services_permisos_granular.py [CREADO]
 services.py [EXISTENTE]

api/callcentersite/callcentersite/apps/dashboard/
 views.py [EXISTENTE - BASICO]
 services.py [EXISTENTE - BASICO]
 urls.py [EXISTENTE]
 widgets.py [EXISTENTE]
```

### Faltantes (a crear):
```
api/callcentersite/callcentersite/apps/users/
 services_usuarios.py [FALTA]
 serializers_usuarios.py [FALTA]
 views_usuarios.py [FALTA]
 urls.py [FALTA]

api/callcentersite/callcentersite/apps/dashboard/
 serializers.py [FALTA]
 migrations/
 0001_dashboard_configuracion.py [FALTA]

api/callcentersite/callcentersite/apps/configuration/ [APP COMPLETA FALTA]
 models.py [FALTA]
 services.py [FALTA]
 serializers.py [FALTA]
 views.py [FALTA]
 urls.py [FALTA]
 migrations/
 0001_initial.py [FALTA]

api/callcentersite/tests/
 permissions/ [FALTA]
 dashboard/ [FALTA]
 configuration/ [FALTA]
```

---

## Conclusion

**El sistema tiene la INFRAESTRUCTURA base (modelos de permisos, migraciones) pero le falta el 65% de la FUNCIONALIDAD de negocio para las 3 funciones core.**

La base de permisos granular esta bien implementada, pero:
- NO hay servicios CRUD para usuarios
- NO hay endpoints REST completos
- NO hay verificacion de permisos en endpoints existentes
- NO hay tests
- Falta completamente la funcion de configuracion

**El equipo debe seguir las guias TDD creadas (deployment_004 y deployment_005) para implementar la funcionalidad faltante.**

---

**Version:** 1.0.0
**Fecha analisis:** 2025-11-07
**Analista:** Sistema automatizado
**Proxima revision:** Despues de implementar usuarios completo
