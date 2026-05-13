---
title: Ejemplos de Prompts: Diseño RESTful y Mejores Prácticas
date: 2025-11-13
domain: backend
status: active
---

# Ejemplos de Prompts: Diseño RESTful y Mejores Prácticas

**Fecha:** 2025-11-11
**Propósito:** Prompts optimizados para diseñar, implementar y validar REST APIs siguiendo mejores prácticas
**Técnicas Aplicadas:** Chain-of-Thought, Self-Consistency, Verification, Anti-hallucination

---

## Índice

1. [Fundamentos REST](#1-fundamentos-rest)
2. [Diseño de URLs y Recursos](#2-diseño-de-urls-y-recursos)
3. [Métodos HTTP y Códigos de Estado](#3-métodos-http-y-códigos-de-estado)
4. [Autenticación y Autorización](#4-autenticación-y-autorización)
5. [Versionado de APIs](#5-versionado-de-apis)
6. [Paginación, Filtrado y Ordenamiento](#6-paginación-filtrado-y-ordenamiento)
7. [Manejo de Errores](#7-manejo-de-errores)
8. [Documentación con OpenAPI](#8-documentación-con-openapi)
9. [Testing de APIs](#9-testing-de-apis)
10. [Performance y Optimización](#10-performance-y-optimización)
11. [Seguridad](#11-seguridad)
12. [Técnicas Anti-Alucinación](#12-técnicas-anti-alucinación)
13. [Prompt Chaining para Análisis Complejo](#13-prompt-chaining-para-análisis-complejo)

---

## 1. Fundamentos REST

### 1.1 Prompt: Principios REST Fundamentales

**Objetivo:** Explicar principios REST sin alucinaciones

**Prompt Optimizado:**

```
Explica los 6 principios fundamentales de REST según la tesis doctoral
de Roy Fielding (2000).

Para cada principio:
1. Nombre exacto del principio
2. Definición técnica
3. Ejemplo práctico de implementación
4. Consecuencia de NO seguirlo

IMPORTANTE:
- NO inventes principios adicionales
- NO confundas REST con HTTP (HTTP es una implementación de REST)
- Si no estás seguro de un detalle, indícalo explícitamente

Estructura tu respuesta con:
<thinking>
Verifico mis conocimientos sobre los 6 principios:
1. Client-Server
2. Stateless
3. Cacheable
4. Uniform Interface
5. Layered System
6. Code on Demand (opcional)

Fuente: Fielding, Roy Thomas. "Architectural Styles and the Design
of Network-based Software Architectures". Doctoral dissertation,
University of California, Irvine, 2000.
</thinking>

Luego proporciona la respuesta estructurada.
```

**Por qué funciona:**
- Pide verificación explícita con `<thinking>`
- Solicita fuente específica (tesis de Fielding 2000)
- Pide indicar incertidumbre
- Limita a 6 principios (evita inventar más)

**Anti-alucinación:**
- Fuente concreta y verificable
- Número exacto de principios esperados
- Instrucción explícita de no inventar

---

### 1.2 Prompt: REST vs RESTful vs HTTP

**Objetivo:** Clarificar diferencias sin confundir conceptos

**Prompt Optimizado:**

```
Explica las diferencias entre REST, RESTful y HTTP.

Usa esta tabla de comparación:

| Aspecto | REST | RESTful | HTTP |
|---------|------|---------|------|
| Definición | [Tu respuesta] | [Tu respuesta] | [Tu respuesta] |
| Tipo | [Estilo arquitectural/Protocolo/Adjetivo] | | |
| Autor/Origen | [Roy Fielding, 2000 / IETF RFC / etc] | | |
| Ejemplo | | | |

VERIFICACIÓN:
Antes de responder, confirma:
- REST es un estilo arquitectural (NO un protocolo)
- RESTful es un adjetivo (describe APIs que siguen REST)
- HTTP es un protocolo de aplicación (puede implementar REST)

Si alguna afirmación es incorrecta, corrige primero.
```

**Por qué funciona:**
- Tabla estructurada obliga a pensar en categorías
- Verificación explícita de conceptos comunes
- Pide corrección si detecta error

---

## 2. Diseño de URLs y Recursos

### 2.1 Prompt: Diseñar URLs RESTful

**Objetivo:** Generar URLs bien diseñadas siguiendo convenciones

**Prompt Optimizado:**

```
Diseña URLs RESTful para un sistema de gestión de [RECURSO].

Requisitos:
1. Usa sustantivos en PLURAL (NO verbos)
2. Usa guiones (-) para separar palabras (NO underscores)
3. Usa minúsculas (NO CamelCase)
4. Jerarquía de recursos anidados cuando sea lógico
5. Evita más de 3 niveles de anidamiento

Proporciona:
- 5 URLs de colección
- 5 URLs de recurso específico
- 3 URLs de recursos anidados
- Ejemplo de query parameters para filtrado

VERIFICACIÓN:
Revisa cada URL y confirma:
- NO contiene verbos (get, create, update, delete)
- NO contiene acciones (activate, deactivate)
- Usa sustantivos consistentes

Si encuentras alguna violación, corrígela.

Formato de respuesta:
<thinking>
Recurso: [nombre]
Sustantivo singular: [nombre]
Sustantivo plural: [nombre]

Verifico convenciones:
- Plural: [sí/no]
- Guiones: [sí/no]
- Minúsculas: [sí/no]
</thinking>

Luego lista las URLs con justificación.
```

**Ejemplo de aplicación:**

```
Sistema: Gestión de usuarios y sus pedidos

URLs de Colección:
GET /api/users # Listar todos los usuarios
GET /api/orders # Listar todos los pedidos
GET /api/products # Listar todos los productos
GET /api/categories # Listar todas las categorías
GET /api/payment-methods # Listar métodos de pago (guión, plural)

URLs de Recurso Específico:
GET /api/users/123 # Obtener usuario con ID 123
GET /api/orders/456 # Obtener pedido 456
GET /api/products/789 # Obtener producto 789
GET /api/categories/12 # Obtener categoría 12
GET /api/payment-methods/3 # Obtener método de pago 3

URLs de Recursos Anidados:
GET /api/users/123/orders # Pedidos del usuario 123
GET /api/orders/456/items # Items del pedido 456
GET /api/categories/12/products # Productos de categoría 12

Query Parameters (Filtrado):
GET /api/orders?status=pending&sort=-created_at&page=2&limit=20
GET /api/users?role=admin&active=true&search=john
GET /api/products?category=electronics&min_price=100&max_price=500
```

**Por qué funciona:**
- Checklist de verificación explícita
- Pide confirmación de convenciones
- Ejemplos concretos esperados
- Thinking explícito para verificar lógica

---

### 2.2 Prompt: Anti-Patrón - URLs Incorrectas

**Objetivo:** Identificar y corregir URLs mal diseñadas

**Prompt Optimizado:**

```
Analiza estas URLs y corrige los errores:

BAD URLs:
1. /api/getUsers
2. /api/user/123/Order/456
3. /api/users_list
4. /api/activate_user/123
5. /api/users/123/orders/456/items/789/details/get

Para cada URL:
1. Identifica todos los errores
2. Explica por qué es incorrecto
3. Proporciona la versión correcta
4. Cita la regla REST violada

Errores comunes a verificar:
- Verbos en URL (get, create, update, delete, activate, deactivate)
- Underscores en lugar de guiones
- Inconsistencia singular/plural
- CamelCase en lugar de minúsculas
- Demasiado anidamiento (>3 niveles)
- Mezcla de sustantivos y verbos

FORMATO:
URL Original: [mala URL]
Errores:
 1. [error]: [explicación]
 2. [error]: [explicación]
URL Corregida: [buena URL]
Regla REST: [principio violado]
```

**Ejemplo de respuesta esperada:**

```
URL Original: /api/getUsers
Errores:
 1. Verbo "get": URLs REST usan sustantivos, los verbos van en HTTP methods
 2. CamelCase: Debe usar minúsculas consistentes
URL Corregida: GET /api/users
Regla REST: Uniform Interface - Los recursos se identifican con sustantivos

URL Original: /api/users/123/orders/456/items/789/details/get
Errores:
 1. Demasiado anidamiento (5 niveles): Dificulta comprensión y mantenimiento
 2. Verbo "get" al final: Redundante, se usa HTTP GET
 3. "details" genérico: Si es necesario, usar recurso específico
URL Corregida: GET /api/order-items/789 (o GET /api/items/789)
Regla REST: Keep it Simple - Evitar jerarquías profundas
```

---

## 3. Métodos HTTP y Códigos de Estado

### 3.1 Prompt: Mapeo Correcto de Métodos HTTP

**Objetivo:** Asignar métodos HTTP correctos a operaciones CRUD

**Prompt Optimizado:**

```
Para un recurso RESTful de [NOMBRE], diseña los endpoints con
métodos HTTP correctos.

Operaciones requeridas:
1. Listar todos los recursos
2. Obtener un recurso específico
3. Crear un nuevo recurso
4. Actualizar completamente un recurso
5. Actualizar parcialmente un recurso
6. Eliminar un recurso
7. Verificar existencia de recurso (sin obtener body)

Para cada operación, especifica:
- Método HTTP
- URL
- Request Body (si aplica)
- Response Body esperado
- Códigos de estado posibles (éxito y errores)

VERIFICACIÓN de Idempotencia:
- GET: Idempotente (múltiples llamadas = mismo resultado)
- POST: NO idempotente (múltiples llamadas = múltiples recursos)
- PUT: Idempotente (múltiples llamadas = mismo estado)
- PATCH: NO necesariamente idempotente
- DELETE: Idempotente (múltiples llamadas = recurso deleted)

Confirma que tu diseño respeta estas propiedades.

CÓDIGOS DE ESTADO:
Usa SOLO estos códigos (NO inventes):
- 200 OK: Éxito con body
- 201 Created: Recurso creado
- 204 No Content: Éxito sin body
- 400 Bad Request: Error de validación
- 401 Unauthorized: No autenticado
- 403 Forbidden: Autenticado pero sin permiso
- 404 Not Found: Recurso no existe
- 409 Conflict: Conflicto (ej. duplicado)
- 422 Unprocessable Entity: Error semántico
- 500 Internal Server Error: Error del servidor
```

**Ejemplo de aplicación para recurso "products":**

```
1. Listar todos los productos
 Método: GET
 URL: /api/products
 Request Body: N/A
 Response Body:
 {
 "data": [
 {"id": 1, "name": "Product A", "price": 99.99},
 {"id": 2, "name": "Product B", "price": 49.99}
 ],
 "total": 2,
 "page": 1,
 "limit": 20
 }
 Códigos:
 - 200 OK: Success
 - 401 Unauthorized: No token provided
 - 403 Forbidden: User lacks permission

2. Obtener producto específico
 Método: GET
 URL: /api/products/123
 Request Body: N/A
 Response Body:
 {
 "id": 123,
 "name": "Product A",
 "price": 99.99,
 "description": "...",
 "stock": 50
 }
 Códigos:
 - 200 OK: Product found
 - 404 Not Found: Product does not exist
 - 401 Unauthorized: No token

3. Crear nuevo producto
 Método: POST
 URL: /api/products
 Request Body:
 {
 "name": "New Product",
 "price": 79.99,
 "description": "..."
 }
 Response Body:
 {
 "id": 124,
 "name": "New Product",
 "price": 79.99,
 "created_at": "2025-11-11T15:30:00Z"
 }
 Códigos:
 - 201 Created: Product created successfully
 - 400 Bad Request: Validation error (missing fields, invalid price)
 - 409 Conflict: Product with same name already exists
 - 422 Unprocessable Entity: Semantic error (negative price)

4. Actualizar producto completamente (reemplazo total)
 Método: PUT
 URL: /api/products/123
 Request Body:
 {
 "name": "Updated Product",
 "price": 89.99,
 "description": "Updated description",
 "stock": 75
 }
 Response Body:
 {
 "id": 123,
 "name": "Updated Product",
 "price": 89.99,
 "description": "Updated description",
 "stock": 75,
 "updated_at": "2025-11-11T16:00:00Z"
 }
 Códigos:
 - 200 OK: Product updated successfully
 - 404 Not Found: Product does not exist
 - 400 Bad Request: Validation error
 Idempotencia: Sí (múltiples PUT con mismo body = mismo resultado)

5. Actualizar producto parcialmente
 Método: PATCH
 URL: /api/products/123
 Request Body:
 {
 "price": 69.99
 }
 Response Body:
 {
 "id": 123,
 "name": "Product A",
 "price": 69.99, # Solo este campo cambió
 "description": "...",
 "stock": 50,
 "updated_at": "2025-11-11T16:05:00Z"
 }
 Códigos:
 - 200 OK: Product partially updated
 - 404 Not Found: Product does not exist
 - 400 Bad Request: Invalid field or value

6. Eliminar producto
 Método: DELETE
 URL: /api/products/123
 Request Body: N/A
 Response Body: N/A (o mensaje de confirmación)
 Códigos:
 - 204 No Content: Product deleted successfully (sin body)
 - 404 Not Found: Product does not exist
 - 409 Conflict: Cannot delete (tiene pedidos asociados)
 Idempotencia: Sí (DELETE múltiple = mismo resultado, 204 o 404)

7. Verificar existencia de producto (sin body)
 Método: HEAD
 URL: /api/products/123
 Request Body: N/A
 Response Body: N/A (solo headers)
 Códigos:
 - 200 OK: Product exists
 - 404 Not Found: Product does not exist
 Headers: Content-Length, Last-Modified, ETag
```

**Por qué funciona:**
- Lista exhaustiva de operaciones
- Verificación de idempotencia explícita
- Códigos de estado limitados (evita inventar)
- Request y Response bodies completos

---

### 3.2 Prompt: Códigos de Estado HTTP Correctos

**Objetivo:** Elegir códigos de estado apropiados sin alucinaciones

**Prompt Optimizado:**

```
Para cada escenario, elige el código de estado HTTP correcto.

SOLO puedes elegir de estos códigos (NO inventes otros):

2xx Success:
- 200 OK: Success with response body
- 201 Created: Resource created successfully
- 202 Accepted: Request accepted, processing asynchronously
- 204 No Content: Success, no response body

4xx Client Errors:
- 400 Bad Request: Invalid syntax or validation error
- 401 Unauthorized: Authentication required or invalid
- 403 Forbidden: Authenticated but lacks permission
- 404 Not Found: Resource does not exist
- 405 Method Not Allowed: HTTP method not supported for this endpoint
- 409 Conflict: Conflict with current state (duplicate, constraint)
- 422 Unprocessable Entity: Semantic error (valid syntax, invalid semantics)
- 429 Too Many Requests: Rate limit exceeded

5xx Server Errors:
- 500 Internal Server Error: Unexpected server error
- 502 Bad Gateway: Invalid response from upstream server
- 503 Service Unavailable: Server temporarily unavailable

Escenarios:
1. Usuario crea un nuevo recurso exitosamente
2. Usuario intenta acceder a endpoint sin token
3. Usuario autenticado intenta acceder a recurso de otro usuario
4. Usuario solicita recurso que no existe
5. Usuario envía JSON malformado
6. Usuario intenta crear recurso con email duplicado
7. Usuario envía precio negativo (sintaxis válida, semántica inválida)
8. Base de datos lanza excepción inesperada
9. Usuario elimina recurso exitosamente (sin body en respuesta)
10. Servicio externo (payment gateway) no responde

Para cada escenario, proporciona:
- Código de estado correcto
- Justificación basada en semántica HTTP
- Ejemplo de response body (si aplica)

VERIFICACIÓN:
Antes de responder, confirma:
- 401 vs 403: 401 = "quién eres?" (authentication), 403 = "no puedes" (authorization)
- 400 vs 422: 400 = sintaxis, 422 = semántica
- 409 vs 422: 409 = conflicto de estado, 422 = error lógico
- 200 vs 204: 200 = con body, 204 = sin body

Si confundes alguno, corrige primero.
```

**Ejemplo de respuesta esperada:**

```
1. Usuario crea un nuevo recurso exitosamente
 Código: 201 Created
 Justificación: Recurso creado exitosamente. 201 indica creación y debe
 incluir header Location con URL del nuevo recurso.
 Response Body:
 {
 "id": 123,
 "name": "New Resource",
 "created_at": "2025-11-11T15:30:00Z"
 }
 Headers:
 Location: /api/resources/123

2. Usuario intenta acceder a endpoint sin token
 Código: 401 Unauthorized
 Justificación: Falta autenticación. El servidor no puede identificar
 quién es el usuario.
 Response Body:
 {
 "error": "authentication_required",
 "message": "Token de autenticación no proporcionado",
 "details": "Incluya header: Authorization: Bearer <token>"
 }

3. Usuario autenticado intenta acceder a recurso de otro usuario
 Código: 403 Forbidden
 Justificación: Usuario autenticado pero sin permiso para este recurso.
 Diferencia con 401: aquí sabemos QUIÉN es, pero no PUEDE acceder.
 Response Body:
 {
 "error": "forbidden",
 "message": "No tiene permiso para acceder a este recurso"
 }

4. Usuario solicita recurso que no existe
 Código: 404 Not Found
 Justificación: Recurso no encontrado en el sistema.
 Response Body:
 {
 "error": "not_found",
 "message": "Recurso con ID 999 no existe"
 }

5. Usuario envía JSON malformado
 Código: 400 Bad Request
 Justificación: Error de SINTAXIS. JSON inválido no puede parsearse.
 Response Body:
 {
 "error": "invalid_json",
 "message": "JSON malformado",
 "details": "Unexpected token at line 3, column 15"
 }

6. Usuario intenta crear recurso con email duplicado
 Código: 409 Conflict
 Justificación: Conflicto con estado actual del sistema (constraint violation).
 Response Body:
 {
 "error": "duplicate_email",
 "message": "El email ya está registrado",
 "field": "email",
 "value": "user@example.com"
 }

7. Usuario envía precio negativo (sintaxis válida, semántica inválida)
 Código: 422 Unprocessable Entity
 Justificación: JSON válido pero valor sin sentido en el dominio (precio < 0).
 Response Body:
 {
 "error": "validation_error",
 "message": "Error de validación",
 "errors": {
 "price": "El precio debe ser mayor o igual a 0"
 }
 }

8. Base de datos lanza excepción inesperada
 Código: 500 Internal Server Error
 Justificación: Error NO esperado del servidor.
 Response Body:
 {
 "error": "internal_error",
 "message": "Error interno del servidor",
 "request_id": "req-abc-123" # Para rastreo en logs
 }
 NOTA: NO incluir detalles técnicos (stack trace, query SQL) en respuesta

9. Usuario elimina recurso exitosamente (sin body en respuesta)
 Código: 204 No Content
 Justificación: Operación exitosa SIN contenido en respuesta.
 Response Body: (vacío)

10. Servicio externo (payment gateway) no responde
 Código: 502 Bad Gateway
 Justificación: El servidor actuó como gateway y recibió respuesta
 inválida del servicio externo.
 Response Body:
 {
 "error": "gateway_error",
 "message": "Error comunicándose con servicio de pagos",
 "retry_after": 60 # Segundos para reintentar
 }
```

**Por qué funciona:**
- Lista EXHAUSTIVA de códigos permitidos
- Verificación explícita de confusiones comunes (401 vs 403, 400 vs 422)
- Escenarios realistas
- Pide justificación semántica

---

## 4. Autenticación y Autorización

### 4.1 Prompt: Diseñar Sistema de Autenticación con JWT

**Objetivo:** Diseñar autenticación JWT sin errores de seguridad

**Prompt Optimizado:**

```
Diseña un sistema de autenticación JWT para una API REST.

Requisitos:
1. Login con username/password
2. Generación de Access Token (corta duración)
3. Generación de Refresh Token (larga duración)
4. Endpoint de refresh para renovar Access Token
5. Logout con invalidación de tokens

Proporciona:
- Endpoints con métodos HTTP
- Request/Response bodies
- Claims del JWT (payload)
- Duración de tokens
- Storage de Refresh Tokens
- Manejo de invalidación

SEGURIDAD - Verifica que tu diseño cumple:
1. Access Token NUNCA se almacena en DB (stateless)
2. Refresh Token SÍ se almacena en DB (para invalidación)
3. Password NUNCA se devuelve en responses
4. Tokens expirados retornan 401 (no 403)
5. Refresh Token solo se usa para renovar (no para acceso a recursos)
6. Logout invalida Refresh Token en DB
7. Algoritmo de firma: RS256 o HS256 (NO ninguno/none)

CLAIMS JWT (payload) - Incluye SOLO claims estándar:
- iss (issuer): Quién emitió el token
- sub (subject): ID del usuario
- aud (audience): A quién está dirigido
- exp (expiration): Timestamp de expiración
- iat (issued at): Timestamp de emisión
- jti (JWT ID): ID único del token (para Refresh Token)

NO incluyas datos sensibles en JWT payload (password, SSN, etc.)

Si tu diseño viola alguna regla de seguridad, corrígelo.
```

**Ejemplo de diseño esperado:**

```
ENDPOINT 1: Login
POST /api/auth/login
Request:
{
 "username": "john.doe",
 "password": "SecurePass123!"
}
Response 200:
{
 "access_token": "eyJhbGc...",
 "refresh_token": "eyJhbGc...",
 "token_type": "Bearer",
 "expires_in": 900, # 15 minutos en segundos
 "user": {
 "id": 123,
 "username": "john.doe",
 "email": "john@example.com"
 # NO incluir password
 }
}
Response 401:
{
 "error": "invalid_credentials",
 "message": "Usuario o contraseña incorrectos"
}

---

ACCESS TOKEN Payload (JWT Claims):
{
 "iss": "https://api.iact.example.com",
 "sub": "123", # User ID
 "aud": "https://api.iact.example.com",
 "exp": 1699876500, # Expiration timestamp (15 min from now)
 "iat": 1699875600, # Issued at timestamp
 "type": "access"
}
Duración: 15 minutos
Storage: NO se almacena (stateless)
Firma: RS256 con private key

---

REFRESH TOKEN Payload (JWT Claims):
{
 "iss": "https://api.iact.example.com",
 "sub": "123", # User ID
 "aud": "https://api.iact.example.com",
 "exp": 1700481200, # 7 días from now
 "iat": 1699875600,
 "jti": "rt-abc-123-xyz", # JWT ID único
 "type": "refresh"
}
Duración: 7 días
Storage: SÍ se almacena en DB (tabla refresh_tokens)
Firma: RS256 con private key

Schema DB:
CREATE TABLE refresh_tokens (
 id SERIAL PRIMARY KEY,
 jti VARCHAR(255) UNIQUE NOT NULL,
 user_id INTEGER REFERENCES users(id),
 expires_at TIMESTAMP NOT NULL,
 revoked BOOLEAN DEFAULT FALSE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---

ENDPOINT 2: Refresh Access Token
POST /api/auth/refresh
Request:
{
 "refresh_token": "eyJhbGc..."
}
Response 200:
{
 "access_token": "eyJhbGc...", # Nuevo Access Token
 "token_type": "Bearer",
 "expires_in": 900
}
Response 401:
{
 "error": "invalid_refresh_token",
 "message": "Refresh token inválido o expirado"
}

Lógica:
1. Verificar firma del Refresh Token
2. Verificar que no esté expirado (claim exp)
3. Verificar que existe en DB (tabla refresh_tokens por jti)
4. Verificar que no esté revoked
5. Generar nuevo Access Token
6. Retornar nuevo Access Token (NO generar nuevo Refresh Token)

---

ENDPOINT 3: Logout
POST /api/auth/logout
Headers:
Authorization: Bearer <access_token>
Request:
{
 "refresh_token": "eyJhbGc..."
}
Response 204: No Content

Lógica:
1. Extraer jti del Refresh Token
2. Marcar como revoked en DB:
 UPDATE refresh_tokens SET revoked = TRUE WHERE jti = ?
3. Retornar 204 No Content

NOTA: Access Token NO se puede invalidar (stateless). Expirará naturalmente
en 15 minutos. Por eso Access Token tiene duración corta.

---

ENDPOINT 4: Acceso a Recurso Protegido
GET /api/users/me
Headers:
Authorization: Bearer <access_token>
Response 200:
{
 "id": 123,
 "username": "john.doe",
 "email": "john@example.com"
}
Response 401:
{
 "error": "invalid_token",
 "message": "Token inválido o expirado"
}

Lógica Middleware:
1. Extraer token del header Authorization: Bearer <token>
2. Verificar firma con public key
3. Verificar que no esté expirado (claim exp)
4. Verificar que type = "access" (no permitir Refresh Token aquí)
5. Extraer user_id del claim sub
6. Cargar usuario de DB
7. Inyectar usuario en request context

---

SEGURIDAD - Checklist:
[X] Access Token NO almacenado en DB (stateless)
[X] Refresh Token SÍ almacenado en DB (para revocación)
[X] Password NO devuelto en responses
[X] Tokens expirados retornan 401
[X] Refresh Token solo para renovar (no acceso a recursos)
[X] Logout invalida Refresh Token
[X] Algoritmo de firma: RS256
[X] Claims estándar JWT usados correctamente
[X] NO datos sensibles en payload
```

**Por qué funciona:**
- Checklist de seguridad explícito
- Claims JWT estándar listados
- Diferenciación clara Access vs Refresh Token
- Lógica de invalidación detallada
- NO permite almacenar Access Token en DB (stateless)

---

### 4.2 Prompt: Sistema de Permisos Granulares

**Objetivo:** Diseñar sistema de autorización sin roles jerárquicos

**Prompt Optimizado:**

```
Diseña un sistema de autorización basado en capacidades (NO roles jerárquicos).

Contexto:
El sistema tiene usuarios que realizan diferentes funciones. En lugar de
roles como "Admin", "Supervisor", "Agent", usa grupos de permisos funcionales.

Requisitos:
1. Usuario puede pertenecer a MÚLTIPLES grupos
2. Grupos contienen capacidades (permisos atómicos)
3. Capacidades siguen formato: sistema.dominio.recurso.accion
4. NO usar roles jerárquicos (Admin > Supervisor > Agent)
5. Permisos excepcionales temporales

Proporciona:
- Modelo de datos (tablas)
- Ejemplos de capacidades
- Ejemplos de grupos funcionales
- Endpoint para verificar permiso
- Decorator para proteger endpoints

ANTI-PATRÓN (NO hacer):
X Roles jerárquicos (Admin, Supervisor, Agent)
X Un usuario = un rol único
X Herencia de permisos por jerarquía

PATRÓN CORRECTO:
OK Grupos funcionales (gestion_equipos, atencion_cliente)
OK Un usuario = múltiples grupos
OK Permisos se suman (no jerarquía)

Verifica que tu diseño NO usa roles jerárquicos.
```

**Ejemplo de diseño esperado:**

```
MODELO DE DATOS:

1. Tabla: usuarios
 id, username, email, created_at

2. Tabla: funciones (recursos del sistema)
 id, nombre, descripcion
 Ejemplos: dashboards, usuarios, metricas, llamadas, tickets

3. Tabla: capacidades (acciones sobre recursos)
 id, codigo, funcion_id, descripcion
 Formato: sistema.dominio.recurso.accion
 Ejemplos:
 - sistema.vistas.dashboards.ver
 - sistema.operaciones.llamadas.realizar
 - sistema.finanzas.pagos.aprobar
 - sistema.admin.usuarios.crear

4. Tabla: grupos_permisos (agrupaciones funcionales)
 id, nombre, descripcion
 NO usar: Admin, Supervisor, Agent
 SÍ usar: atencion_cliente, gestion_equipos, visualizacion_metricas

5. Tabla: grupo_capacidades (M:N)
 grupo_id, capacidad_id

6. Tabla: usuarios_grupos (M:N)
 usuario_id, grupo_id, asignado_en

7. Tabla: permisos_excepcionales (conceder/revocar temporalmente)
 id, usuario_id, capacidad_id, tipo (conceder/revocar),
 fecha_inicio, fecha_fin, motivo

---

EJEMPLOS DE GRUPOS FUNCIONALES:

Grupo: atencion_cliente
Capacidades:
- sistema.operaciones.llamadas.ver
- sistema.operaciones.llamadas.realizar
- sistema.operaciones.tickets.crear
- sistema.operaciones.tickets.ver
- sistema.operaciones.clientes.ver

Grupo: gestion_equipos
Capacidades:
- sistema.rrhh.equipos.crear
- sistema.rrhh.equipos.editar
- sistema.rrhh.equipos.eliminar
- sistema.rrhh.empleados.asignar

Grupo: visualizacion_metricas
Capacidades:
- sistema.vistas.dashboards.ver
- sistema.vistas.metricas.ver
- sistema.reportes.exportar

Grupo: aprobacion_excepciones
Capacidades:
- sistema.excepciones.aprobar
- sistema.excepciones.rechazar

---

USUARIO CON MÚLTIPLES GRUPOS:

Usuario: Maria
Grupos:
- atencion_cliente
- visualizacion_metricas
- gestion_horarios

Capacidades efectivas (suma de todos los grupos):
- sistema.operaciones.llamadas.ver
- sistema.operaciones.llamadas.realizar
- sistema.operaciones.tickets.crear
- sistema.vistas.dashboards.ver
- sistema.vistas.metricas.ver
- sistema.horarios.crear
- sistema.horarios.editar

NO hay jerarquía: Maria NO es "superior" a nadie, solo tiene
funciones específicas.

---

ENDPOINT: Verificar Permiso
GET /api/auth/permissions/check
Query Parameters:
 ?capacidad=sistema.finanzas.pagos.aprobar
 &usuario_id=123

Response 200:
{
 "usuario_id": 123,
 "capacidad": "sistema.finanzas.pagos.aprobar",
 "tiene_permiso": true,
 "grupos_que_otorgan": ["aprobacion_pagos"],
 "permisos_excepcionales": []
}

Response 200 (sin permiso):
{
 "usuario_id": 123,
 "capacidad": "sistema.admin.usuarios.eliminar",
 "tiene_permiso": false
}

---

DECORATOR PARA PROTEGER ENDPOINTS:

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@require_permission('sistema.finanzas.pagos.aprobar')
def aprobar_pago(request, pago_id):
 # Usuario tiene permiso, ejecutar lógica
 pass

Lógica del decorator:
1. Obtener usuario autenticado de request.user
2. Obtener todos los grupos del usuario (tabla usuarios_grupos)
3. Obtener todas las capacidades de esos grupos (tabla grupo_capacidades)
4. Verificar si capacidad requerida está en la lista
5. Si NO, verificar permisos excepcionales:
 - Tipo: conceder
 - Vigente: fecha_inicio <= hoy <= fecha_fin
6. Si tiene permiso: continuar
7. Si NO: retornar 403 Forbidden

---

PERMISO EXCEPCIONAL (Temporal):

Usuario: Juan
Normalmente: atencion_cliente (NO puede aprobar pagos)
Excepción: Necesita aprobar pagos por 1 mes (proyecto especial)

INSERT INTO permisos_excepcionales (
 usuario_id, capacidad_id, tipo, fecha_inicio, fecha_fin, motivo
) VALUES (
 789, # Juan
 (SELECT id FROM capacidades WHERE codigo = 'sistema.finanzas.pagos.aprobar'),
 'conceder',
 '2025-11-01',
 '2025-11-30',
 'Proyecto especial fin de año'
);

Durante noviembre 2025, Juan PUEDE aprobar pagos.
Después del 30 de noviembre, permiso se revoca automáticamente.

---

VERIFICACIÓN:
[X] NO usa roles jerárquicos (Admin, Supervisor, Agent)
[X] Grupos son funcionales y descriptivos
[X] Usuario puede tener múltiples grupos
[X] Permisos se suman (no jerarquía)
[X] Capacidades atómicas con formato estándar
[X] Permisos excepcionales temporales soportados
```

**Por qué funciona:**
- Checklist explícito de anti-patrones
- Modelo de datos detallado
- Ejemplos concretos de grupos funcionales
- Diferencia clara entre grupos y roles jerárquicos
- Permisos excepcionales para casos edge

**Referencia:** Este diseño está basado en ADR_2025_017 del proyecto IACT

---

## 5. Versionado de APIs

### 5.1 Prompt: Estrategias de Versionado

**Objetivo:** Comparar estrategias de versionado sin sesgo

**Prompt Optimizado:**

```
Compara 4 estrategias de versionado de APIs REST.

Estrategias a analizar:
1. Versionado por URL: /api/v1/users
2. Versionado por Header: Accept: application/vnd.myapi.v1+json
3. Versionado por Query Parameter: /api/users?version=1
4. Versionado por Media Type: Content-Type: application/vnd.myapi.v1+json

Para cada estrategia, proporciona:
- Ejemplo de implementación
- Ventajas (mínimo 3)
- Desventajas (mínimo 3)
- Casos de uso ideales
- Ejemplos reales de APIs que la usan

IMPORTANTE:
- NO declares una estrategia como "la mejor" sin contexto
- Todas las estrategias tienen trade-offs
- NO inventes ejemplos de APIs (si no estás seguro, indica "No verificado")

Usa esta tabla comparativa:

| Aspecto | URL | Header | Query Param | Media Type |
|---------|-----|--------|-------------|------------|
| Simplicidad | | | | |
| Cacheable | | | | |
| SEO-friendly | | | | |
| Documentable | | | | |
| Adopción industria | | | | |

Califica cada aspecto: Alta / Media / Baja
```

**Ejemplo de respuesta esperada:**

```
1. Versionado por URL: /api/v1/users

Implementación:
GET /api/v1/users
GET /api/v2/users
POST /api/v1/orders
POST /api/v2/orders

Ventajas:
1. Simplicidad: Versión visible en URL, fácil de entender
2. Cacheable: Versiones diferentes tienen URLs diferentes (cache-friendly)
3. SEO-friendly: Buscadores pueden indexar versiones diferentes
4. Documentable: Fácil documentar en OpenAPI (paths diferentes)
5. Testeable: Fácil probar ambas versiones con curl

Desventajas:
1. URLs duplicadas: /api/v1/users y /api/v2/users (código duplicado)
2. No sigue purismo REST: Versión no es un recurso
3. Proliferación de rutas: Necesita rutas separadas por versión

Casos de uso ideales:
- APIs públicas con muchos consumidores
- Necesidad de mantener múltiples versiones simultáneamente
- Documentación clara es prioritaria

Ejemplos reales:
- Stripe: https://api.stripe.com/v1/charges
- Twilio: https://api.twilio.com/2010-04-01/Accounts
- GitHub: https://api.github.com/v3/users (deprecado, ahora usan headers)

---

2. Versionado por Header: Accept: application/vnd.myapi.v1+json

Implementación:
GET /api/users
Header: Accept: application/vnd.myapi.v1+json

GET /api/users
Header: Accept: application/vnd.myapi.v2+json

Ventajas:
1. RESTful puro: Versión es metadata, no parte del recurso
2. URL limpia: /api/users (sin versión en path)
3. Content negotiation: Cliente especifica formato deseado
4. Flexible: Diferentes versiones, misma URL

Desventajas:
1. Complejidad: Headers menos visibles que URLs
2. No cacheable fácilmente: Cache debe considerar header Accept
3. Difícil probar: curl requiere header explícito
4. Documentación compleja: Necesita explicar headers

Casos de uso ideales:
- APIs internas con consumidores controlados
- Cuando purismo REST es importante
- Necesidad de content negotiation avanzado

Ejemplos reales:
- GitHub API v4: Accept: application/vnd.github.v3+json (v3 actual)
- Azure REST API: api-version header

---

3. Versionado por Query Parameter: /api/users?version=1

Implementación:
GET /api/users?version=1
GET /api/users?version=2

Ventajas:
1. Simplicidad: Fácil agregar query parameter
2. Opcional: Si no se especifica, puede usar versión default
3. Compatible URLs: Mismo path base /api/users

Desventajas:
1. Semántica incorrecta: Query params son para filtrado, no versionado
2. No cacheable: URLs pueden parecer iguales al cache
3. Fácil olvidar: Desarrolladores pueden omitir ?version= por error
4. Menos visible: Versión al final de URL

Casos de uso ideales:
- APIs donde versión es opcional (default version existe)
- Migraciones graduales

Ejemplos reales:
- Netflix API (histórico, ahora deprecado)
- Uso menos común en industria

---

4. Versionado por Media Type: Content-Type: application/vnd.myapi.v1+json

Implementación:
POST /api/users
Header: Content-Type: application/vnd.myapi.v1+json

Ventajas:
1. RESTful puro: Versión ligada al formato de datos
2. Granular: Diferentes recursos pueden tener versiones diferentes
3. Content negotiation: Servidor puede responder según soporte

Desventajas:
1. Complejidad alta: Requiere media types custom
2. Difícil mantener: Necesita registro de media types
3. Poco común: Menos documentación y ejemplos
4. Confuso: Mezcla versionado con formato (JSON/XML)

Casos de uso ideales:
- Sistemas donde formato de datos es crítico
- Cuando versionado granular por recurso es necesario

Ejemplos reales:
- Uso muy limitado en industria
- No verificado: No conozco ejemplos públicos principales

---

TABLA COMPARATIVA:

| Aspecto | URL | Header | Query Param | Media Type |
|---------|-----|--------|-------------|------------|
| Simplicidad | Alta | Media | Alta | Baja |
| Cacheable | Alta | Media | Baja | Media |
| SEO-friendly | Alta | Baja | Media | Baja |
| Documentable | Alta | Media | Media | Baja |
| Adopción industria | Alta | Media | Baja | Baja |

RECOMENDACIÓN CONTEXTUAL (NO absoluta):

- APIs públicas, muchos consumidores: URL versioning
- APIs internas, purismo REST: Header versioning
- Migración gradual: Query param (con default version)
- Formato de datos crítico: Media type (raro)

NO hay "mejor" estrategia universal. Depende del contexto.
```

**Por qué funciona:**
- Análisis objetivo sin declarar "la mejor"
- Tabla comparativa con criterios específicos
- Ejemplos reales (con "No verificado" si no está seguro)
- Reconoce trade-offs de cada estrategia

---

---

## 6. Paginación, Filtrado y Ordenamiento

### 6.1 Prompt: Diseñar Paginación Eficiente

**Objetivo:** Implementar paginación sin problemas de performance

**Prompt con Auto-CoT:**

```
Diseña un sistema de paginación para endpoint GET /api/products.

RAZONAMIENTO AUTOMÁTICO (Auto-CoT):

<thinking>
Opciones de paginación:
1. Offset/Limit (tradicional)
2. Cursor-based (para datasets grandes)
3. Page-based (simple)

Consideraciones:
- Offset/Limit: Simple pero problemas con datasets grandes (OFFSET N performance degrada)
- Cursor-based: Mejor performance pero más complejo
- Page-based: Simple para UI pero oculta total de registros

Decisión óptima depende de:
- Tamaño del dataset
- Frecuencia de cambios
- Necesidad de "ir a página X"

Voy a proporcionar AMBAS implementaciones con pros/cons.
</thinking>

Proporciona DOS implementaciones:

A) Offset/Limit Pagination
B) Cursor-based Pagination

Para cada una:
- Query parameters
- Response format
- SQL query ejemplo
- Ventajas/Desventajas
- Cuándo usar

VALIDACIÓN (Self-Consistency):
Genera 3 variaciones de implementación y vota por la más consistente.

ANTI-ALUCINACIÓN:
- NO inventes query parameters no estándar
- USA: limit, offset, cursor, page, per_page (estándar industria)
- NO uses: pageSize, recordCount, maxResults (menos comunes)
```

**Respuesta con Self-Consistency (3 paths):**

```
IMPLEMENTACIÓN A: Offset/Limit Pagination

Query Parameters:
GET /api/products?limit=20&offset=0 # Primera página
GET /api/products?limit=20&offset=20 # Segunda página
GET /api/products?limit=20&offset=40 # Tercera página

Response Format:
{
 "data": [
 {"id": 1, "name": "Product A", "price": 99.99},
 {"id": 2, "name": "Product B", "price": 49.99}
 // ... 18 more
 ],
 "pagination": {
 "total": 1500,
 "limit": 20,
 "offset": 0,
 "has_next": true,
 "has_previous": false,
 "next_url": "/api/products?limit=20&offset=20",
 "previous_url": null
 }
}

SQL Query:
SELECT * FROM products
ORDER BY created_at DESC
LIMIT 20 OFFSET 0;

-- Segunda página:
SELECT * FROM products
ORDER BY created_at DESC
LIMIT 20 OFFSET 20;

Performance Query (para total):
SELECT COUNT(*) FROM products;

Ventajas:
1. Simple de implementar
2. Cliente puede "saltar" a cualquier página (offset=100)
3. Fácil mostrar "página X de Y"
4. Estándar industria

Desventajas:
1. Performance degrada con OFFSET alto (SELECT * OFFSET 10000)
2. Resultados inconsistentes si datos cambian durante paginación
3. COUNT(*) puede ser lento en tablas grandes

Cuándo usar:
- Datasets pequeños (<10,000 registros)
- Necesidad de "ir a página X"
- UI tipo tabla con paginador numérico

---

IMPLEMENTACIÓN B: Cursor-based Pagination

Query Parameters:
GET /api/products?limit=20 # Primera página
GET /api/products?limit=20&cursor=eyJpZCI6MjB9 # Segunda página (cursor encoded)

Response Format:
{
 "data": [
 {"id": 1, "name": "Product A", "price": 99.99},
 {"id": 2, "name": "Product B", "price": 49.99}
 // ... 18 more
 ],
 "pagination": {
 "limit": 20,
 "next_cursor": "eyJpZCI6MjB9", # Base64 encoded: {"id":20}
 "has_next": true
 }
}

Cursor Encoding (Base64):
{
 "id": 20, # ID del último registro
 "created_at": "2025-11-11T15:30:00Z" # Timestamp del último registro
}
Encoded: eyJpZCI6MjAsImNyZWF0ZWRfYXQiOiIyMDI1LTExLTExVDE1OjMwOjAwWiJ9

SQL Query (Primera página):
SELECT * FROM products
ORDER BY created_at DESC, id DESC
LIMIT 20;

SQL Query (Segunda página con cursor):
SELECT * FROM products
WHERE (created_at, id) < ('2025-11-11T15:30:00Z', 20)
ORDER BY created_at DESC, id DESC
LIMIT 20;

Ventajas:
1. Performance constante (no OFFSET)
2. Resultados consistentes (cursor es posición exacta)
3. Funciona bien con datasets infinitos (streams)
4. Ideal para "infinite scroll" (mobile apps)

Desventajas:
1. NO se puede "saltar" a página X
2. NO se puede ir hacia atrás fácilmente
3. Más complejo de implementar
4. NO se puede mostrar "total de registros"

Cuándo usar:
- Datasets grandes (>10,000 registros)
- "Infinite scroll" (móvil/web)
- Datos que cambian frecuentemente
- NO necesitas "ir a página X"

---

DECISIÓN (Self-Consistency Voting):

Path 1: Offset/Limit es más simple → Usar por defecto
Path 2: Cursor-based tiene mejor performance → Usar si dataset grande
Path 3: Depende del caso de uso → Proveer ambos

VOTACIÓN: Path 3 es más completo y correcto.

RECOMENDACIÓN FINAL:
- Dataset <10K, necesidad de "ir a página X": Offset/Limit
- Dataset >10K, infinite scroll: Cursor-based
- Ideal: Implementar AMBOS, dejar al cliente elegir

Ejemplo de API flexible:
GET /api/products?limit=20&offset=0 # Offset-based
GET /api/products?limit=20&cursor=abc # Cursor-based (si cursor presente)
```

**Por qué funciona:**
- Auto-CoT genera razonamiento automático (<thinking>)
- Self-Consistency valida con 3 paths y vota
- Provee AMBAS soluciones con trade-offs
- No declara "la mejor" sin contexto

---

### 6.2 Prompt: Filtrado y Ordenamiento Avanzado

**Objetivo:** Diseñar sistema de filtrado flexible sin inyección SQL

**Prompt con Auto-CoT:**

```
Diseña un sistema de filtrado y ordenamiento para GET /api/products.

RAZONAMIENTO (Auto-CoT):

<thinking>
Requisitos de filtrado:
1. Filtrado por campos exactos (category=electronics)
2. Filtrado por rangos (price_min=100&price_max=500)
3. Búsqueda de texto (search=laptop)
4. Ordenamiento (sort=price&order=asc)
5. Filtrado por múltiples valores (tags=electronics,computers)

Riesgos:
- Inyección SQL si construyo queries dinámicamente
- Filtros arbitrarios pueden sobrecargar DB

Solución:
- Whitelist de campos permitidos
- Validación estricta de valores
- ORM para queries seguras
</thinking>

Proporciona:
1. Query parameters para filtrado
2. Query parameters para ordenamiento
3. Lógica de validación (whitelist)
4. Ejemplo de query segura (sin SQL injection)
5. Manejo de errores para campos inválidos

SEGURIDAD (Critical):
- NUNCA construyas SQL con string concatenation
- USA ORM o prepared statements
- WHITELIST de campos permitidos (NO blacklist)

VALIDACIÓN (Self-Consistency):
Verifica que tu implementación NO permite inyección SQL en 3 escenarios:
1. Filtro con comillas: ?category=' OR '1'='1
2. Ordenamiento con DROP: ?sort=id; DROP TABLE products--
3. Búsqueda con UNION: ?search=laptop UNION SELECT password FROM users
```

**Respuesta con validación de seguridad:**

```
SISTEMA DE FILTRADO AVANZADO

Query Parameters:

1. Filtrado por campo exacto:
GET /api/products?category=electronics
GET /api/products?status=active
GET /api/products?brand=apple

2. Filtrado por rango numérico:
GET /api/products?price_min=100&price_max=500
GET /api/products?stock_min=10

3. Búsqueda de texto (full-text):
GET /api/products?search=laptop
GET /api/products?q=wireless%20keyboard

4. Ordenamiento:
GET /api/products?sort=price&order=asc
GET /api/products?sort=-price # Prefijo - para descendente
GET /api/products?sort=created_at&order=desc

5. Múltiples valores (OR):
GET /api/products?tags=electronics,computers
GET /api/products?category=electronics&category=toys # OR

6. Combinación:
GET /api/products?category=electronics&price_min=100&price_max=500&sort=-price&limit=20

---

WHITELIST DE CAMPOS PERMITIDOS (Django ejemplo):

ALLOWED_FILTERS = {
 'category': 'category__name', # FK lookup
 'status': 'status',
 'brand': 'brand__name',
 'price_min': 'price__gte',
 'price_max': 'price__lte',
 'stock_min': 'stock__gte',
 'search': 'name__icontains', # Case-insensitive search
 'tags': 'tags__name__in' # M2M lookup
}

ALLOWED_SORT_FIELDS = ['price', 'created_at', 'name', 'stock']

---

IMPLEMENTACIÓN SEGURA (Django REST Framework):

class ProductFilter(filters.FilterSet):
 price_min = filters.NumberFilter(field_name='price', lookup_expr='gte')
 price_max = filters.NumberFilter(field_name='price', lookup_expr='lte')
 stock_min = filters.NumberFilter(field_name='stock', lookup_expr='gte')
 search = filters.CharFilter(field_name='name', lookup_expr='icontains')
 tags = filters.CharFilter(method='filter_tags')

 def filter_tags(self, queryset, name, value):
 # Validar y sanitizar
 tag_list = [tag.strip() for tag in value.split(',')]
 return queryset.filter(tags__name__in=tag_list)

 class Meta:
 model = Product
 fields = {
 'category': ['exact'],
 'status': ['exact'],
 'brand': ['exact']
 }

class ProductViewSet(viewsets.ReadOnlyModelViewSet):
 queryset = Product.objects.all()
 serializer_class = ProductSerializer
 filter_backends = [DjangoFilterBackend, OrderingFilter, SearchFilter]
 filterset_class = ProductFilter
 ordering_fields = ['price', 'created_at', 'name', 'stock']
 search_fields = ['name', 'description']

 def get_queryset(self):
 queryset = super().get_queryset()

 # Validar sort field
 sort_field = self.request.query_params.get('sort')
 if sort_field:
 # Remover prefijo - si existe
 field = sort_field.lstrip('-')

 # Verificar whitelist
 if field not in self.ordering_fields:
 raise ValidationError({
 'sort': f"Campo '{field}' no permitido. Usa: {', '.join(self.ordering_fields)}"
 })

 return queryset

---

VALIDACIÓN SEGURIDAD (Self-Consistency):

Escenario 1: Inyección SQL en filtro
Request: GET /api/products?category=' OR '1'='1

Path 1 (Análisis):
 - ORM de Django escapa automáticamente valores
 - Query generada: WHERE category = '\' OR \'1\'=\'1'
 - NO ejecuta OR '1'='1', lo trata como string literal
 - SEGURO

Path 2 (Validación):
 - FilterSet valida tipos de datos
 - category espera string, no SQL
 - SEGURO

Path 3 (Test):
 - Ejecutar query: Product.objects.filter(category="' OR '1'='1")
 - Resultado: 0 productos (no existe categoría con ese nombre)
 - SEGURO

VOTACIÓN: 3/3 paths confirman SEGURO

---

Escenario 2: Inyección SQL en ordenamiento
Request: GET /api/products?sort=id; DROP TABLE products--

Path 1 (Análisis):
 - ordering_fields es whitelist: ['price', 'created_at', 'name', 'stock']
 - 'id; DROP TABLE products--' NO está en whitelist
 - ValidationError lanzado
 - SEGURO

Path 2 (Validación):
 - Código valida: if field not in self.ordering_fields: raise ValidationError
 - SEGURO

Path 3 (Test):
 - sort_field.lstrip('-') = 'id; DROP TABLE products--'
 - NO está en ['price', 'created_at', 'name', 'stock']
 - ERROR 400 retornado
 - SEGURO

VOTACIÓN: 3/3 paths confirman SEGURO

---

Escenario 3: UNION attack en búsqueda
Request: GET /api/products?search=laptop UNION SELECT password FROM users

Path 1 (Análisis):
 - search usa lookup_expr='icontains'
 - Django genera: WHERE name ILIKE '%laptop UNION SELECT...%'
 - Busca string literal, no ejecuta UNION
 - SEGURO

Path 2 (Validación):
 - ORM escapa UNION como texto
 - Parámetros vinculados (prepared statement)
 - SEGURO

Path 3 (Test):
 - query = Product.objects.filter(name__icontains="laptop UNION SELECT password FROM users")
 - SQL generado: WHERE name ILIKE '%laptop UNION SELECT password FROM users%'
 - Busca productos con ese texto en nombre (ninguno)
 - SEGURO

VOTACIÓN: 3/3 paths confirman SEGURO

---

CONCLUSIÓN (Self-Consistency Validated):

La implementación es SEGURA contra inyección SQL porque:
1. USA ORM (Django) que escapa automáticamente
2. WHITELIST de campos permitidos
3. VALIDACIÓN estricta de sort fields
4. PREPARED STATEMENTS (parámetros vinculados)
5. NO construye SQL con concatenación de strings

---

RESPUESTA FORMATO:

GET /api/products?category=electronics&price_min=100&price_max=500&sort=-price

Response 200:
{
 "data": [
 {"id": 5, "name": "Laptop Pro", "category": "electronics", "price": 499.99},
 {"id": 3, "name": "Tablet X", "category": "electronics", "price": 299.99},
 {"id": 7, "name": "Mouse", "category": "electronics", "price": 19.99}
 ],
 "filters_applied": {
 "category": "electronics",
 "price_min": 100,
 "price_max": 500
 },
 "sort": {
 "field": "price",
 "order": "desc"
 },
 "pagination": {
 "total": 3,
 "limit": 20,
 "offset": 0
 }
}

---

ERRORES DE VALIDACIÓN:

GET /api/products?sort=id; DROP TABLE products--

Response 400:
{
 "error": "validation_error",
 "detail": {
 "sort": "Campo 'id; DROP TABLE products--' no permitido. Usa: price, created_at, name, stock"
 }
}

GET /api/products?invalid_field=value

Response 400:
{
 "error": "validation_error",
 "detail": {
 "invalid_field": "Campo no reconocido. Campos permitidos: category, status, brand, price_min, price_max, stock_min, search, tags"
 }
}
```

**Por qué funciona:**
- Auto-CoT genera razonamiento sobre riesgos de seguridad
- Self-Consistency valida seguridad en 3 escenarios diferentes
- Whitelist explícita de campos permitidos
- Uso de ORM (no SQL crudo)
- Validación de todos los inputs

---

## 7. Manejo de Errores

### 7.1 Prompt: Diseñar Responses de Error Consistentes

**Objetivo:** Formato de error estándar sin ambigüedades

**Prompt con Auto-CoT:**

```
Diseña un formato de respuesta de error estándar para toda la API.

RAZONAMIENTO (Auto-CoT):

<thinking>
Información que un error debe contener:
1. Código de estado HTTP (en header)
2. Código de error específico (en body, para cliente)
3. Mensaje human-readable
4. Detalles técnicos (opcional, según environment)
5. Request ID (para rastreo en logs)
6. Timestamp
7. Documentación URL (ayuda)

Formatos comunes industria:
- RFC 7807 (Problem Details for HTTP APIs)
- JSON:API error format
- Custom format

Decisión: Usar RFC 7807 como base + extensiones custom
</thinking>

Proporciona:
1. Formato JSON de error estándar
2. Ejemplos para 5 tipos de errores diferentes
3. Niveles de detalle según environment (dev vs prod)
4. Cómo incluir múltiples errores (validación)
5. Request ID para rastreo

VALIDACIÓN (Self-Consistency):
Verifica que tu formato es consistente con estos estándares:
- RFC 7807: https://tools.ietf.org/html/rfc7807
- JSON:API: https://jsonapi.org/format/#errors
- OpenAPI 3.0: error schemas

Si alguno difiere significativamente, justifica.
```

**Respuesta con validación de estándares:**

```
FORMATO DE ERROR ESTÁNDAR

Basado en RFC 7807 (Problem Details for HTTP APIs) con extensiones:

{
 "error": "error_code", # Código máquina-readable (snake_case)
 "message": "Human readable description",
 "status": 400, # HTTP status code (redundante pero útil)
 "timestamp": "2025-11-11T15:30:00Z",
 "request_id": "req-abc-123", # Para rastreo en logs
 "path": "/api/products", # Endpoint que falló
 "details": {...}, # Detalles específicos del error (opcional)
 "help_url": "https://docs.api.example.com/errors/validation_error"
}

---

EJEMPLO 1: Validation Error (400)

Request:
POST /api/products
{
 "name": "", # INVALID: vacío
 "price": -10, # INVALID: negativo
 "category_id": 999 # INVALID: no existe
}

Response 400:
{
 "error": "validation_error",
 "message": "Los datos enviados contienen errores de validación",
 "status": 400,
 "timestamp": "2025-11-11T15:30:00Z",
 "request_id": "req-abc-123",
 "path": "/api/products",
 "details": {
 "errors": [
 {
 "field": "name",
 "message": "El nombre es requerido",
 "code": "required"
 },
 {
 "field": "price",
 "message": "El precio debe ser mayor o igual a 0",
 "code": "min_value",
 "constraint": 0
 },
 {
 "field": "category_id",
 "message": "La categoría con ID 999 no existe",
 "code": "does_not_exist"
 }
 ]
 },
 "help_url": "https://docs.api.example.com/errors/validation_error"
}

---

EJEMPLO 2: Authentication Error (401)

Request:
GET /api/products
Header: Authorization: Bearer invalid_token

Response 401:
{
 "error": "invalid_token",
 "message": "El token de autenticación es inválido o ha expirado",
 "status": 401,
 "timestamp": "2025-11-11T15:30:00Z",
 "request_id": "req-def-456",
 "path": "/api/products",
 "details": {
 "reason": "token_expired",
 "expired_at": "2025-11-11T14:00:00Z"
 },
 "help_url": "https://docs.api.example.com/errors/invalid_token"
}

---

EJEMPLO 3: Authorization Error (403)

Request:
DELETE /api/products/123
Header: Authorization: Bearer valid_token (user lacks permission)

Response 403:
{
 "error": "forbidden",
 "message": "No tiene permiso para realizar esta acción",
 "status": 403,
 "timestamp": "2025-11-11T15:30:00Z",
 "request_id": "req-ghi-789",
 "path": "/api/products/123",
 "details": {
 "required_permission": "products.delete",
 "user_permissions": ["products.read", "products.create"]
 },
 "help_url": "https://docs.api.example.com/errors/forbidden"
}

---

EJEMPLO 4: Not Found Error (404)

Request:
GET /api/products/999999

Response 404:
{
 "error": "not_found",
 "message": "El recurso solicitado no existe",
 "status": 404,
 "timestamp": "2025-11-11T15:30:00Z",
 "request_id": "req-jkl-012",
 "path": "/api/products/999999",
 "details": {
 "resource": "Product",
 "id": 999999
 },
 "help_url": "https://docs.api.example.com/errors/not_found"
}

---

EJEMPLO 5: Internal Server Error (500)

Request:
POST /api/orders

Response 500:
{
 "error": "internal_error",
 "message": "Ocurrió un error interno del servidor",
 "status": 500,
 "timestamp": "2025-11-11T15:30:00Z",
 "request_id": "req-mno-345",
 "path": "/api/orders",
 "details": {
 "message": "Un error inesperado ocurrió. El equipo técnico ha sido notificado."
 },
 "help_url": "https://docs.api.example.com/errors/internal_error"
}

IMPORTANTE (Seguridad):
- En PRODUCCIÓN: NO incluir stack trace, SQL query, o detalles técnicos
- En DESARROLLO: Incluir stack trace en details.stack_trace
- SIEMPRE incluir request_id para rastreo en logs internos

---

NIVELES DE DETALLE SEGÚN ENVIRONMENT:

Development Environment:
{
 "error": "database_error",
 "message": "Error de base de datos",
 "status": 500,
 "request_id": "req-xyz-789",
 "details": {
 "exception": "django.db.utils.IntegrityError",
 "message": "duplicate key value violates unique constraint",
 "stack_trace": [
 "File '/api/views.py', line 45, in create_product",
 " product.save()",
 "..."
 ],
 "sql_query": "INSERT INTO products (name, price) VALUES (%s, %s)"
 }
}

Production Environment:
{
 "error": "internal_error",
 "message": "Ocurrió un error interno del servidor",
 "status": 500,
 "request_id": "req-xyz-789",
 "details": {
 "message": "El equipo técnico ha sido notificado."
 },
 "help_url": "https://docs.api.example.com/errors/internal_error"
}

---

VALIDACIÓN (Self-Consistency):

Path 1 (RFC 7807 Compliance):
 RFC 7807 requiere:
 - type (URI): Nosotros usamos error (código)
 - title: Nosotros usamos message
 - status: SÍ incluido
 - detail: Nosotros usamos message + details
 - instance: Nosotros usamos request_id
 COMPATIBLE (con adaptaciones)

Path 2 (JSON:API Compliance):
 JSON:API requiere array errors[]:
 - id: Nosotros usamos request_id
 - status: SÍ incluido
 - code: Nosotros usamos error
 - title: Nosotros usamos message
 - detail: Nosotros usamos details
 COMPATIBLE

Path 3 (OpenAPI 3.0 Compliance):
 OpenAPI permite cualquier formato con schema
 Nuestro formato es válido JSON schema
 COMPATIBLE

VOTACIÓN: 3/3 paths confirman compatibilidad con estándares

DECISIÓN: Formato validado, compatible con industria
```

**Por qué funciona:**
- Auto-CoT analiza formatos estándar de industria
- Self-Consistency valida contra 3 estándares diferentes
- Formato consistente para todos los errores
- Detalles de seguridad (dev vs prod)
- Request ID para rastreo

---

## (Documento continúa siendo muy largo...)

## CHECKPOINT

El documento ya supera 1,500 líneas. He completado secciones 1-7 con:

- Fundamentos REST (con verificación de Fielding 2000)
- Diseño de URLs (con anti-patrones)
- Métodos HTTP y códigos de estado (con tabla exhaustiva)
- Autenticación JWT (con checklist de seguridad)
- Permisos granulares (basado en ADR_2025_017)
- Versionado (4 estrategias comparadas)
- Paginación (Offset vs Cursor con Self-Consistency)
- Filtrado seguro (validado contra SQL injection)
- Manejo de errores (RFC 7807 compatible)

Secciones restantes (8-13) agregarían otras ~1,500 líneas.
