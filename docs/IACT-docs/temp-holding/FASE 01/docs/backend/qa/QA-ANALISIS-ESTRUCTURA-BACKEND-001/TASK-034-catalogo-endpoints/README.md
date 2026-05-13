# TASK-034: Crear CATALOGO-ENDPOINTS.md

## Información General
- **Fase**: FASE 3 - Catalogos
- **Duración Estimada**: 25 minutos
- **Prioridad**: MEDIA
- **Tipo**: Catalogación
- **Metodología**: Auto-CoT + Self-Consistency + Tabular CoT

## Objetivo
Crear un catálogo completo de todos los endpoints REST del backend, documentando rutas, métodos HTTP, autenticación y respuestas.

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Identificación de Endpoints
**Pregunta**: ¿Dónde están definidos los endpoints?
**Razonamiento**:
- Buscar archivos urls.py
- Identificar routers de DRF (si aplica)
- Revisar decoradores @route
- Examinar ViewSets y APIViews

### Paso 2: Análisis de Métodos
**Pregunta**: ¿Qué operaciones realiza cada endpoint?
**Razonamiento**:
- Métodos HTTP (GET, POST, PUT, DELETE, PATCH)
- Parámetros requeridos
- Autenticación necesaria
- Permisos requeridos

### Paso 3: Documentación de Respuestas
**Pregunta**: ¿Qué responde cada endpoint?
**Razonamiento**:
- Status codes posibles
- Estructura de respuesta
- Errores comunes
- Paginación (si aplica)

## Tabular CoT: Estructura de Análisis

| Etapa | Acción | Herramienta | Salida Esperada |
|-------|--------|-------------|-----------------|
| 1. Búsqueda | Localizar urls.py y routers | Glob | Lista de archivos routing |
| 2. Extracción | Extraer definiciones de rutas | Grep | Lista de endpoints |
| 3. Análisis | Determinar métodos y permisos | Read | Detalles de cada endpoint |
| 4. Agrupación | Organizar por recurso | Clasificación | Endpoints agrupados |
| 5. Documentación | Crear catálogo tabular | Tabular CoT | CATALOGO-ENDPOINTS.md |

## Self-Consistency: Validación Cruzada

### Verificación 1: Completitud
- ¿Se documentaron todos los urls.py?
- ¿Se incluyeron routers de DRF?
- ¿Se consideraron endpoints heredados?

### Verificación 2: Consistencia REST
- ¿Los endpoints siguen convenciones REST?
- ¿Los métodos HTTP son apropiados?
- ¿Las rutas son coherentes?

### Verificación 3: Seguridad
- ¿Todos los endpoints tienen autenticación?
- ¿Los permisos están correctamente documentados?
- ¿Se identificaron endpoints públicos?

## Estructura del Entregable: CATALOGO-ENDPOINTS.md

```markdown
# Catálogo de Endpoints - Backend IACT

## API v1 - Usuarios

### Autenticación

| Método | Ruta | Autenticación | Permisos | Descripción |
|--------|------|---------------|----------|-------------|
| POST | /api/v1/auth/login | [ERROR] Public | AllowAny | Login de usuario |
| POST | /api/v1/auth/logout | [OK] Token | IsAuthenticated | Logout de usuario |
| POST | /api/v1/auth/register | [ERROR] Public | AllowAny | Registro de usuario |
| POST | /api/v1/auth/refresh | [OK] Refresh Token | AllowAny | Renovar token |

**Detalles: POST /api/v1/auth/login**
```json
// Request
{
 "email": "user@example.com",
 "password": "password123"
}

// Response 200
{
 "access_token": "eyJ0eXAi...",
 "refresh_token": "eyJ0eXAi...",
 "user": {
 "id": 1,
 "username": "johndoe",
 "email": "user@example.com"
 }
}

// Response 401
{
 "error": "Invalid credentials"
}
```

### Gestión de Usuarios

| Método | Ruta | Autenticación | Permisos | Descripción |
|--------|------|---------------|----------|-------------|
| GET | /api/v1/users | [OK] Token | IsAdmin | Listar usuarios |
| GET | /api/v1/users/:id | [OK] Token | IsAuthenticated | Obtener usuario |
| POST | /api/v1/users | [OK] Token | IsAdmin | Crear usuario |
| PUT | /api/v1/users/:id | [OK] Token | IsOwnerOrAdmin | Actualizar usuario |
| DELETE | /api/v1/users/:id | [OK] Token | IsAdmin | Eliminar usuario |
| GET | /api/v1/users/me | [OK] Token | IsAuthenticated | Perfil actual |

**Parámetros de Query: GET /api/v1/users**
| Parámetro | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| page | int | [ERROR] | 1 | Número de página |
| page_size | int | [ERROR] | 20 | Items por página |
| search | string | [ERROR] | - | Buscar por username/email |
| is_active | bool | [ERROR] | - | Filtrar por estado |
| ordering | string | [ERROR] | -created_at | Ordenar por campo |

## API v1 - Productos

### Catálogo

| Método | Ruta | Autenticación | Permisos | Descripción |
|--------|------|---------------|----------|-------------|
| GET | /api/v1/products | [ERROR] Public | AllowAny | Listar productos |
| GET | /api/v1/products/:id | [ERROR] Public | AllowAny | Detalle de producto |
| POST | /api/v1/products | [OK] Token | IsStaff | Crear producto |
| PUT | /api/v1/products/:id | [OK] Token | IsStaff | Actualizar producto |
| DELETE | /api/v1/products/:id | [OK] Token | IsAdmin | Eliminar producto |
| GET | /api/v1/products/:id/reviews | [ERROR] Public | AllowAny | Reviews del producto |

### Categorías

| Método | Ruta | Autenticación | Permisos | Descripción |
|--------|------|---------------|----------|-------------|
| GET | /api/v1/categories | [ERROR] Public | AllowAny | Listar categorías |
| GET | /api/v1/categories/:id | [ERROR] Public | AllowAny | Detalle categoría |
| POST | /api/v1/categories | [OK] Token | IsStaff | Crear categoría |
| PUT | /api/v1/categories/:id | [OK] Token | IsStaff | Actualizar categoría |
| DELETE | /api/v1/categories/:id | [OK] Token | IsAdmin | Eliminar categoría |

## API v1 - Pedidos

| Método | Ruta | Autenticación | Permisos | Descripción |
|--------|------|---------------|----------|-------------|
| GET | /api/v1/orders | [OK] Token | IsAuthenticated | Mis pedidos |
| GET | /api/v1/orders/:id | [OK] Token | IsOwnerOrStaff | Detalle pedido |
| POST | /api/v1/orders | [OK] Token | IsAuthenticated | Crear pedido |
| PUT | /api/v1/orders/:id | [OK] Token | IsStaff | Actualizar pedido |
| DELETE | /api/v1/orders/:id | [OK] Token | IsOwner | Cancelar pedido |
| POST | /api/v1/orders/:id/pay | [OK] Token | IsOwner | Pagar pedido |

## Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Request exitoso |
| 201 | Created | Recurso creado |
| 204 | No Content | Eliminación exitosa |
| 400 | Bad Request | Datos inválidos |
| 401 | Unauthorized | No autenticado |
| 403 | Forbidden | Sin permisos |
| 404 | Not Found | Recurso no existe |
| 500 | Server Error | Error interno |

## Estructura de Respuesta Estándar

### Éxito
```json
{
 "status": "success",
 "data": { ... },
 "meta": {
 "timestamp": "2025-11-18T10:00:00Z"
 }
}
```

### Error
```json
{
 "status": "error",
 "error": {
 "code": "VALIDATION_ERROR",
 "message": "Invalid input data",
 "details": {
 "field": ["Error message"]
 }
 },
 "meta": {
 "timestamp": "2025-11-18T10:00:00Z"
 }
}
```

### Paginación
```json
{
 "status": "success",
 "data": [...],
 "meta": {
 "pagination": {
 "page": 1,
 "page_size": 20,
 "total_pages": 5,
 "total_items": 98
 }
 }
}
```

## Autenticación

### JWT Token
```http
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

### API Key (para integraciones)
```http
X-API-Key: your-api-key-here
```

## Rate Limiting

| Tipo de Usuario | Límite | Ventana |
|------------------|--------|---------|
| Anónimo | 100 req | 1 hora |
| Autenticado | 1000 req | 1 hora |
| Premium | 5000 req | 1 hora |

## Estadísticas de Endpoints

| Categoría | Endpoints | GET | POST | PUT | DELETE |
|-----------|-----------|-----|------|-----|--------|
| Auth | 4 | 0 | 4 | 0 | 0 |
| Users | 6 | 3 | 1 | 1 | 1 |
| Products | 6 | 3 | 1 | 1 | 1 |
| Categories | 5 | 2 | 1 | 1 | 1 |
| Orders | 6 | 2 | 2 | 1 | 1 |
| **TOTAL** | **27** | **10** | **9** | **4** | **4** |

## Versionado de API

| Versión | Estado | Deprecación | Soporte |
|---------|--------|-------------|---------|
| v1 | [OK] Actual | - | Completo |
| v2 | Beta | - | Parcial |
| v0 | [ERROR] Deprecada | 2024-12-31 | Ninguno |

## Referencias
- backend/*/urls.py
- backend/api/routers.py
- docs/api/swagger.json
- backend/*/views.py
```

## Entregables
- [ ] CATALOGO-ENDPOINTS.md creado
- [ ] Todos los endpoints documentados con Tabular CoT
- [ ] Ejemplos de request/response incluidos
- [ ] Códigos de estado documentados
- [ ] Validación Self-Consistency completada

## Criterios de Aceptación
1. [OK] Todos los endpoints identificados y catalogados
2. [OK] Métodos HTTP documentados
3. [OK] Autenticación y permisos especificados
4. [OK] Formato tabular utilizado
5. [OK] Ejemplos de request/response incluidos
6. [OK] Códigos de estado HTTP documentados
7. [OK] Estadísticas generales incluidas

## Notas
- Buscar en: backend/*/urls.py, backend/api/
- Incluir ejemplos de curl/requests
- Documentar rate limiting si existe
- Incluir información de versionado
- Documentar estructura de paginación
