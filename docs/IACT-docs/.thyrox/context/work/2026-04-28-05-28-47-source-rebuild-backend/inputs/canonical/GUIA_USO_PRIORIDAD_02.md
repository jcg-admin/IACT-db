---
title: Guia de Uso - Sistema de Permisos Granular (PRIORIDAD 2)
date: 2025-11-13
domain: general
status: active
---

# Guia de Uso - Sistema de Permisos Granular (PRIORIDAD 2)

**Fecha:** 2025-11-08
**Version:** 1.0.0
**Estado:** Completado (FASE 1, 2, 3)
**Cobertura:** Funciones Core (Usuarios, Dashboards, Configuracion)

---

## Estado de Implementacion

### [OK] COMPLETADO

#### FASE 1: Seed Data & Database (100%)
- Migraciones de base de datos creadas
- Modelos Django implementados
- Seed data completo con 16 capacidades
- 3 grupos funcionales configurados
- App de configuracion creada y registrada

#### FASE 2: Servicios Backend (100%)
- **UsuarioService**: CRUD completo de usuarios
- **DashboardService**: Exportar, personalizar, compartir
- **ConfiguracionService**: CRUD con historial de cambios
- Verificacion de permisos en cada operacion
- Auditoria completa de acciones

#### FASE 3: API REST (100%)
- 9 endpoints de usuarios
- 4 endpoints de dashboards
- 5 endpoints de configuracion
- Documentacion OpenAPI/Swagger
- Validaciones y manejo de errores

### PENDIENTE (Requiere entorno Django)

#### FASE 4: Tests de Integracion
- Tests E2E creados (5 archivos)
- Requiere ejecutar con pytest

#### FASE 5: Validacion
- Scripts de validacion SQL creados
- Script Python de validacion creado
- Requiere base de datos poblada

---

## Instalacion y Configuracion

### 1. Aplicar Migraciones

```bash
cd api/callcentersite

# Aplicar migraciones de usuarios (permisos granular)
python manage.py migrate users

# Aplicar migraciones de configuracion
python manage.py migrate configuration

# Aplicar migraciones de dashboard
python manage.py migrate dashboard
```

### 2. Poblar Datos Iniciales

```bash
# Seed de permisos granular (funciones, capacidades, grupos)
python manage.py seed_permisos_granular

# Seed de configuraciones por defecto
python manage.py seed_configuraciones_default
```

**Salida esperada:**
- 3 funciones creadas (usuarios, dashboards, configuracion)
- 16 capacidades creadas
- 10 grupos funcionales creados
- 27 configuraciones por defecto

### 3. Verificar Instalacion

```bash
# Verificar tablas creadas
python manage.py dbshell
> \dt auditoria_permisos
> \dt configuracion
> \dt dashboard_configuracion

# Verificar datos
> SELECT COUNT(*) FROM capacidades;
> SELECT COUNT(*) FROM grupos_permisos;
> SELECT COUNT(*) FROM configuracion;
```

---

## API REST - Guia de Uso

### Autenticacion

Todas las peticiones requieren JWT token:

```bash
# Obtener token
curl -X POST http://localhost:8000/api/auth/token/ \
 -H "Content-Type: application/json" \
 -d '{"email":"admin@test.com","password":"admin123"}'

# Usar token en peticiones
curl -X GET http://localhost:8000/api/v1/usuarios/ \
 -H "Authorization: Bearer <TOKEN>"
```

### Usuarios API

#### 1. Listar Usuarios
```bash
# GET /api/v1/usuarios/
# Permiso: sistema.administracion.usuarios.ver

curl -X GET http://localhost:8000/api/v1/usuarios/ \
 -H "Authorization: Bearer <TOKEN>"

# Con filtros
curl -X GET "http://localhost:8000/api/v1/usuarios/?activo=true&page=1&page_size=20" \
 -H "Authorization: Bearer <TOKEN>"
```

**Respuesta:**
```json
{
 "resultados": [
 {
 "id": 1,
 "email": "usuario@test.com",
 "first_name": "Usuario",
 "last_name": "Test",
 "is_active": true,
 "is_staff": false,
 "grupos": [
 {
 "codigo": "visualizacion_basica",
 "nombre": "Visualización Básica",
 "asignado_en": "2025-11-08T10:00:00Z"
 }
 ]
 }
 ],
 "total": 1,
 "pagina": 1,
 "paginas_totales": 1
}
```

#### 2. Crear Usuario
```bash
# POST /api/v1/usuarios/
# Permiso: sistema.administracion.usuarios.crear

curl -X POST http://localhost:8000/api/v1/usuarios/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "email": "nuevo@test.com",
 "first_name": "Nuevo",
 "last_name": "Usuario",
 "password": "password123"
 }'
```

#### 3. Asignar Grupos
```bash
# POST /api/v1/usuarios/{id}/asignar_grupos/
# Permiso: sistema.administracion.usuarios.asignar_grupos

curl -X POST http://localhost:8000/api/v1/usuarios/1/asignar_grupos/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "grupos_codigos": ["visualizacion_basica", "reportes_analitica"]
 }'
```

#### 4. Suspender Usuario
```bash
# POST /api/v1/usuarios/{id}/suspender/
# Permiso: sistema.administracion.usuarios.suspender

curl -X POST http://localhost:8000/api/v1/usuarios/1/suspender/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "motivo": "Violación de políticas"
 }'
```

#### 5. Reactivar Usuario
```bash
# POST /api/v1/usuarios/{id}/reactivar/
# Permiso: sistema.administracion.usuarios.reactivar

curl -X POST http://localhost:8000/api/v1/usuarios/1/reactivar/ \
 -H "Authorization: Bearer <TOKEN>"
```

### Dashboard API

#### 1. Ver Dashboard
```bash
# GET /api/v1/dashboard/overview/
# Permiso: sistema.vistas.dashboards.ver

curl -X GET http://localhost:8000/api/v1/dashboard/overview/ \
 -H "Authorization: Bearer <TOKEN>"
```

#### 2. Exportar Dashboard
```bash
# POST /api/v1/dashboard/exportar/
# Permiso: sistema.vistas.dashboards.exportar

curl -X POST http://localhost:8000/api/v1/dashboard/exportar/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "formato": "pdf"
 }'
```

#### 3. Personalizar Dashboard
```bash
# PUT /api/v1/dashboard/personalizar/
# Permiso: sistema.vistas.dashboards.personalizar

curl -X PUT http://localhost:8000/api/v1/dashboard/personalizar/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "configuracion": {
 "widgets": [
 {"tipo": "llamadas", "posicion": {"x": 0, "y": 0}},
 {"tipo": "tickets", "posicion": {"x": 1, "y": 0}}
 ],
 "tema": "oscuro"
 }
 }'
```

#### 4. Compartir Dashboard
```bash
# POST /api/v1/dashboard/compartir/
# Permiso: sistema.vistas.dashboards.compartir

curl -X POST http://localhost:8000/api/v1/dashboard/compartir/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "compartir_con_usuario_id": 2
 }'
```

### Configuracion API

#### 1. Listar Configuraciones
```bash
# GET /api/v1/configuracion/
# Permiso: sistema.tecnico.configuracion.ver

curl -X GET http://localhost:8000/api/v1/configuracion/ \
 -H "Authorization: Bearer <TOKEN>"

# Filtrar por categoria
curl -X GET "http://localhost:8000/api/v1/configuracion/?categoria=seguridad" \
 -H "Authorization: Bearer <TOKEN>"
```

#### 2. Editar Configuracion
```bash
# PUT /api/v1/configuracion/{clave}/
# Permiso: sistema.tecnico.configuracion.editar

curl -X PUT http://localhost:8000/api/v1/configuracion/seguridad.session_timeout/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d '{
 "nuevo_valor": "1800"
 }'
```

#### 3. Exportar Configuraciones
```bash
# GET /api/v1/configuracion/exportar/
# Permiso: sistema.tecnico.configuracion.exportar

curl -X GET http://localhost:8000/api/v1/configuracion/exportar/ \
 -H "Authorization: Bearer <TOKEN>" \
 > backup_config.json
```

#### 4. Importar Configuraciones
```bash
# POST /api/v1/configuracion/importar/
# Permiso: sistema.tecnico.configuracion.importar

curl -X POST http://localhost:8000/api/v1/configuracion/importar/ \
 -H "Authorization: Bearer <TOKEN>" \
 -H "Content-Type: application/json" \
 -d @backup_config.json
```

#### 5. Restaurar Configuracion
```bash
# POST /api/v1/configuracion/{clave}/restaurar/
# Permiso: sistema.tecnico.configuracion.restaurar

curl -X POST http://localhost:8000/api/v1/configuracion/seguridad.session_timeout/restaurar/ \
 -H "Authorization: Bearer <TOKEN>"
```

---

## Grupos Funcionales

### Grupos Implementados

| Codigo | Nombre | Capacidades | Descripcion |
|--------|--------|-------------|-------------|
| `administracion_usuarios` | Administración de Usuarios | 7 | Crear, editar, eliminar, suspender usuarios |
| `visualizacion_basica` | Visualización Básica | 4 | Ver dashboards, compartir, exportar |
| `configuracion_sistema` | Configuración Sistema | 5 | Ver, editar, exportar, importar configuraciones |

### Capacidades por Grupo

#### administracion_usuarios (7 capacidades)
- `sistema.administracion.usuarios.ver`
- `sistema.administracion.usuarios.crear`
- `sistema.administracion.usuarios.editar`
- `sistema.administracion.usuarios.eliminar`
- `sistema.administracion.usuarios.suspender`
- `sistema.administracion.usuarios.reactivar`
- `sistema.administracion.usuarios.asignar_grupos`

#### visualizacion_basica (4 capacidades)
- `sistema.vistas.dashboards.ver`
- `sistema.vistas.dashboards.personalizar`
- `sistema.vistas.dashboards.exportar`
- `sistema.vistas.dashboards.compartir`

#### configuracion_sistema (5 capacidades)
- `sistema.tecnico.configuracion.ver`
- `sistema.tecnico.configuracion.editar`
- `sistema.tecnico.configuracion.exportar`
- `sistema.tecnico.configuracion.importar`
- `sistema.tecnico.configuracion.restaurar`

---

## Validacion del Sistema

### 1. Validar Funciones y Capacidades

```bash
cd scripts/validacion
psql -d iact_analytics -f validar_funciones.sql
```

**Salida esperada:**
- usuarios: 7 capacidades OK
- dashboards: 4 capacidades OK
- configuracion: 5 capacidades OK

### 2. Validar Grupos

```bash
psql -d iact_analytics -f validar_grupos.sql
```

**Salida esperada:**
- administracion_usuarios: 7 capacidades OK
- visualizacion_basica: 4 capacidades OK
- configuracion_sistema: 5 capacidades OK

### 3. Validar Permisos

```bash
cd api/callcentersite
python manage.py shell < ../../scripts/validacion/test_permisos.py
```

**Salida esperada:**
```
Test 1: Usuario con visualizacion_basica PUEDE ver dashboards: OK OK
Test 2: Usuario con visualizacion_basica NO PUEDE crear usuarios: OK OK
Test 3: Usuario con admin_usuarios PUEDE crear usuarios: OK OK
```

### 4. Validar Auditoria

```bash
psql -d iact_analytics -f validar_auditoria.sql
```

**Verifica que:**
- Acciones de creacion se auditan
- Acciones de suspension se auditan
- Acciones denegadas se auditan

---

## Tests de Integracion

### Ejecutar Tests

```bash
cd api/callcentersite

# Ejecutar todos los tests de integracion
pytest tests/integration/ -v

# Ejecutar test especifico
pytest tests/integration/test_usuario_completo.py -v

# Con cobertura
pytest tests/integration/ --cov=callcentersite.apps.users --cov-report=html
```

### Tests Disponibles

1. **test_usuario_completo.py**: Flujo completo de creacion y asignacion de grupos
2. **test_usuario_suspension.py**: Suspension y reactivacion de usuarios
3. **test_dashboard_personalizado.py**: Personalizacion de dashboards por usuario
4. **test_configuracion_backup.py**: Exportacion e importacion de configuraciones
5. **test_administrador_completo.py**: Flujo completo de administrador

---

## Documentacion API

### Swagger UI

Acceder a la documentacion interactiva:

```
http://localhost:8000/api/docs/
```

### OpenAPI Schema

Descargar el schema:

```bash
curl http://localhost:8000/api/schema/ > schema.yaml
```

O usar el archivo generado:

```
docs/api/openapi_prioridad_02.yaml
```

---

## Auditoria y Seguridad

### Ver Auditoria

```sql
-- Ultimas 20 acciones
SELECT
 timestamp,
 usuario_id,
 capacidad_codigo,
 accion,
 resultado,
 detalles
FROM auditoria_permisos
ORDER BY timestamp DESC
LIMIT 20;

-- Acciones de un usuario especifico
SELECT * FROM auditoria_permisos
WHERE usuario_id = 1
ORDER BY timestamp DESC;

-- Acciones denegadas
SELECT * FROM auditoria_permisos
WHERE resultado = 'denegado'
ORDER BY timestamp DESC;
```

### Historial de Configuraciones

```sql
-- Historial de cambios de una configuracion
SELECT
 timestamp,
 valor_anterior,
 valor_nuevo,
 modificado_por
FROM configuracion_historial
WHERE clave = 'seguridad.session_timeout'
ORDER BY timestamp DESC;
```

---

## Troubleshooting

### Error: "No module named 'callcentersite.apps.configuration'"

**Solucion:** Verificar que la app este registrada en INSTALLED_APPS

```python
# settings/base.py
INSTALLED_APPS = [
 ...
 "callcentersite.apps.configuration",
 ...
]
```

### Error: "PermissionDenied: No tiene permiso para..."

**Solucion:** Verificar que el usuario tenga el grupo correcto asignado

```python
from callcentersite.apps.users.services_permisos_granular import UserManagementService

# Verificar grupos del usuario
grupos = UserManagementService.obtener_grupos_de_usuario(usuario_id=1)
print(grupos)

# Verificar capacidades
capacidades = UserManagementService.obtener_capacidades_usuario(usuario_id=1)
print(capacidades)

# Asignar grupo si es necesario
UserManagementService.asignar_grupo_a_usuario(
 usuario_id=1,
 grupo_codigo='administracion_usuarios',
 asignado_por_id=1
)
```

### Error: "Tabla no existe"

**Solucion:** Aplicar migraciones

```bash
python manage.py migrate users
python manage.py migrate configuration
python manage.py migrate dashboard
```

---

## Proximos Pasos

### PRIORIDAD 3: Funciones Operativas
- Implementar gestion de llamadas
- Implementar gestion de tickets
- Implementar configuracion de IVR

### PRIORIDAD 4: Funciones de Soporte
- Implementar gestión de equipos
- Implementar reportes y analitica avanzada
- Implementar notificaciones

---

## Contacto y Soporte

Para consultas sobre la implementacion:
- Email: dev@callcenter.com
- Documentacion: docs/
- Issues: GitHub Issues

---

**Ultima actualizacion:** 2025-11-08
**Version:** 1.0.0
**Autor:** Sistema de Desarrollo Automatizado
