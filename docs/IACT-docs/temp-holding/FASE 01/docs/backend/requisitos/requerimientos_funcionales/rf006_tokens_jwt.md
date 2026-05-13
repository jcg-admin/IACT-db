---
id: RF-006
tipo: funcional
titulo: Generación y validación de tokens JWT
dominio: backend
owner: equipo-backend
prioridad: critica
estado: pendiente
fecha_creacion: 2025-11-04
modulo: authentication
categoria: security

trazabilidad_upward:
 - RN-C01-03 # Generación de Tokens JWT
 - RN-C01-04 # Validación de Tokens JWT
 - RN-C01-11 # Refresh Token

trazabilidad_downward:
 - TEST-006 # Tests de tokens JWT

stakeholders:
 - usuarios-finales
 - desarrolladores-frontend
 - gerentes-seguridad

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-006: Generación y Validación de Tokens JWT

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** generar tokens JWT (access y refresh) usando djangorestframework-simplejwt con **duración exacta de 15 minutos para access token y 7 días para refresh token** **incluyendo** claims personalizados (username, email, segment, roles) **y DEBERÁ** validar tokens en cada request a endpoints protegidos **verificando** firma, expiración, tipo de token y estado del usuario **permitiendo** refrescar access tokens mediante refresh tokens con rotación automática.

### 1.2 Descripción Detallada

**Contexto:**
El sistema usa JWT (JSON Web Tokens) como mecanismo stateless de autenticación, permitiendo que los usuarios accedan a recursos protegidos sin necesidad de consultar la base de datos en cada request.

**Necesidad:**
- Frontend necesita tokens para autenticar requests
- Tokens deben tener expiración corta (15min) por seguridad
- Refresh tokens permiten renovar access tokens sin pedir credenciales nuevamente
- Claims personalizados permiten autorización sin consultar BD

**Comportamiento esperado:**
1. **Generación:** Al hacer login exitoso, generar access token (15min) y refresh token (7días)
2. **Validación:** En cada request protegido, validar access token (firma, expiración, tipo)
3. **Refresh:** Cuando access token expira, usar refresh token para obtener nuevo par de tokens
4. **Rotación:** Al refrescar, invalidar (blacklist) el refresh token viejo y generar uno nuevo
5. **Blacklist:** Mantener lista de refresh tokens invalidados (logout, refresh)

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Generación de tokens en login exitoso

```gherkin
Given un usuario "juan.perez" autenticado exitosamente
 And el usuario tiene segment="GE"
 And el usuario tiene roles=["ANALISTA_DATOS", "VIEWER_BASICO"]
When el sistema genera tokens JWT
Then el sistema retorna access_token válido por 15 minutos exactos
 And el sistema retorna refresh_token válido por 7 días exactos
 And el access_token contiene claims:
 | user_id | 123 |
 | username | juan.perez |
 | email | juan.perez@company.com |
 | segment | GE |
 | roles | ["ANALISTA_DATOS", "VIEWER_BASICO"] |
 | exp | <timestamp 15min futuro> |
 | iat | <timestamp actual> |
 | jti | <unique id> |
 | token_type | access |
 And el refresh_token contiene los mismos claims con token_type="refresh"
 And ambos tokens están firmados con SECRET_KEY usando algoritmo HS256
```

#### Escenario 2: Validación exitosa de access token

```gherkin
Given un usuario con access_token válido
 And el token NO ha expirado (< 15 minutos desde emisión)
 And el token tiene firma válida
 And el usuario asociado está activo (is_active=True)
 And el usuario NO está bloqueado (is_locked=False)
When el usuario envía request con header "Authorization: Bearer <access_token>"
Then el sistema valida el token exitosamente
 And el sistema extrae user_id del claim
 And el sistema carga el usuario desde la BD
 And el sistema permite acceso al endpoint protegido
 And el sistema actualiza last_activity_at de la sesión
```

#### Escenario 3: Validación fallida - token expirado

```gherkin
Given un usuario con access_token emitido hace 16 minutos
 And el token tiene firma válida
When el usuario envía request con ese token
Then el sistema rechaza el token
 And el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Token expirado",
 "code": "token_expired"
 }
 And el sistema NO permite acceso al endpoint
 And el usuario debe refrescar el token usando refresh_token
```

#### Escenario 4: Validación fallida - firma inválida

```gherkin
Given un token JWT manipulado o firmado con otra SECRET_KEY
When el usuario envía request con ese token
Then el sistema rechaza el token
 And el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Token inválido",
 "code": "invalid_signature"
 }
 And el sistema NO permite acceso
```

#### Escenario 5: Validación fallida - tipo de token incorrecto

```gherkin
Given un usuario con refresh_token (NO access_token)
When el usuario intenta usar el refresh_token para acceder a endpoint protegido
Then el sistema rechaza el token
 And el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Debe usar access token",
 "code": "invalid_token_type"
 }
```

#### Escenario 6: Refresh token - generar nuevo access token

```gherkin
Given un usuario con refresh_token válido
 And el refresh_token NO ha expirado (< 7 días)
 And el refresh_token NO está en blacklist
When el usuario envía POST /api/v1/auth/refresh con:
 {
 "refresh": "<refresh_token>"
 }
Then el sistema valida el refresh_token
 And el sistema genera nuevo access_token (válido 15min)
 And el sistema genera nuevo refresh_token (válido 7 días)
 And el sistema blacklistea el refresh_token viejo
 And el sistema retorna HTTP 200 OK con:
 {
 "access": "<new_access_token>",
 "refresh": "<new_refresh_token>"
 }
```

#### Escenario 7: Refresh token - token blacklisted

```gherkin
Given un refresh_token que ya fue usado previamente
 And el token fue blacklisted al usarse (rotación)
When el usuario intenta usar ese refresh_token nuevamente
Then el sistema rechaza el token
 And el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Token inválido o ya usado",
 "code": "token_blacklisted"
 }
```

#### Escenario 8: Refresh token - token expirado

```gherkin
Given un refresh_token emitido hace 8 días (> 7 días)
When el usuario intenta refrescar el access_token
Then el sistema rechaza el refresh_token
 And el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Refresh token expirado",
 "code": "token_expired",
 "message": "Debe iniciar sesión nuevamente"
 }
 And el usuario debe hacer login nuevamente con credenciales
```

#### Escenario 9: Validación fallida - usuario inactivo

```gherkin
Given un access_token válido (firma y expiración correctos)
 And el usuario asociado tiene is_active=False
When el usuario envía request con ese token
Then el sistema rechaza el request
 And el sistema retorna HTTP 403 Forbidden
 And el sistema retorna:
 {
 "error": "Usuario inactivo",
 "code": "user_inactive"
 }
```

#### Escenario 10: Validación fallida - usuario bloqueado

```gherkin
Given un access_token válido
 And el usuario asociado tiene is_locked=True
When el usuario envía request con ese token
Then el sistema rechaza el request
 And el sistema retorna HTTP 403 Forbidden
 And el sistema retorna:
 {
 "error": "Usuario bloqueado",
 "code": "user_locked"
 }
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Performance** | Validación de token | < 10 ms | 95th percentile |
| **Seguridad** | Algoritmo de firma | HS256 | Code review |
| **Seguridad** | Longitud de SECRET_KEY | >= 256 bits (32 chars) | Config review |
| **Expiración** | Access token | 15 minutos exactos | Test |
| **Expiración** | Refresh token | 7 días exactos | Test |
| **Rotación** | Refresh tokens | Obligatoria | Test |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| TokenService | `apps/authentication/services.py` | nuevo |
| JWTAuthentication | `apps/authentication/authentication.py` | nuevo |
| RefreshTokenView | `apps/authentication/views.py` | nuevo |
| OutstandingToken | djangorestframework-simplejwt | existente |
| BlacklistedToken | djangorestframework-simplejwt | existente |

### 3.2 Interfaces

#### 3.2.1 API REST - Refresh Token

**Endpoint:** `POST /api/v1/auth/refresh`

**Request:**
```json
{
 "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (Éxito - HTTP 200):**
```json
{
 "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
 "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (Error - HTTP 401):**
```json
{
 "error": "Refresh token expirado",
 "code": "token_expired",
 "message": "Debe iniciar sesión nuevamente"
}
```

#### 3.2.2 Configuración - settings.py

```python
from datetime import timedelta

SIMPLE_JWT = {
 # Duración de tokens (OBLIGATORIO - RESTRICCIONES)
 'ACCESS_TOKEN_LIFETIME': timedelta(minutes=15), # 15 min EXACTOS
 'REFRESH_TOKEN_LIFETIME': timedelta(days=7), # 7 días EXACTOS

 # Seguridad
 'ROTATE_REFRESH_TOKENS': True, # Generar nuevo refresh al usar
 'BLACKLIST_AFTER_ROTATION': True, # Blacklist refresh viejo
 'UPDATE_LAST_LOGIN': False, # Lo manejamos manualmente

 # Algoritmo
 'ALGORITHM': 'HS256',
 'SIGNING_KEY': SECRET_KEY, # Desde variable de entorno
 'VERIFYING_KEY': None,

 # Headers
 'AUTH_HEADER_TYPES': ('Bearer',),
 'AUTH_HEADER_NAME': 'HTTP_AUTHORIZATION',

 # Claims
 'USER_ID_FIELD': 'user_id',
 'USER_ID_CLAIM': 'user_id',
 'TOKEN_TYPE_CLAIM': 'token_type',
 'JTI_CLAIM': 'jti',

 # Token classes
 'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
}

# Instalar apps
INSTALLED_APPS = [
 ...
 'rest_framework_simplejwt.token_blacklist',
]
```

#### 3.2.3 Estructura del Access Token

```json
{
 "header": {
 "alg": "HS256",
 "typ": "JWT"
 },
 "payload": {
 "user_id": 123,
 "username": "juan.perez",
 "email": "juan.perez@company.com",
 "segment": "GE",
 "roles": ["ANALISTA_DATOS", "VIEWER_BASICO"],
 "iat": 1730707200,
 "exp": 1730708100,
 "jti": "unique-jwt-id-abc123",
 "token_type": "access"
 },
 "signature": "..."
}
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-RN-C01-03-01 | Access token: 15 minutos exactos | No negociable |
| BR-RN-C01-03-02 | Refresh token: 7 días exactos | No negociable |
| BR-RN-C01-03-03 | Algoritmo: HS256 | PROHIBIDO: None, HS1 |
| BR-RN-C01-03-04 | Claims personalizados obligatorios | username, email, segment, roles |
| BR-RN-C01-04-01 | Validar firma siempre | Con SECRET_KEY |
| BR-RN-C01-04-02 | Validar expiración siempre | exp claim |
| BR-RN-C01-04-03 | Validar tipo de token | access vs refresh |
| BR-RN-C01-04-04 | Validar estado del usuario | is_active, is_locked |
| BR-RN-C01-11-01 | Rotar refresh tokens obligatorio | Blacklist viejo |
| BR-RN-C01-11-02 | No reutilizar refresh tokens | Detectar con blacklist |

### 3.4 Validaciones

#### Validaciones de Token (Entrada)
- Token debe estar presente en header `Authorization`
- Header debe tener formato `Bearer <token>`
- Token debe ser JWT válido (3 partes separadas por `.`)
- Token debe estar firmado con SECRET_KEY correcto

#### Validaciones de Negocio
- Token NO debe haber expirado (exp > now)
- Token NO debe estar en blacklist (para refresh tokens)
- Token type debe coincidir con el uso (access para endpoints, refresh para /refresh)
- Usuario asociado debe existir
- Usuario debe estar activo (is_active=True)
- Usuario NO debe estar bloqueado (is_locked=False)

### 3.5 Algoritmo Detallado

#### Generación de Tokens

```python
from rest_framework_simplejwt.tokens import RefreshToken

def generate_jwt_tokens(user) -> dict:
 """
 Generar access y refresh tokens para un usuario

 Returns:
 dict con 'access' y 'refresh' tokens
 """
 # 1. Crear refresh token
 refresh = RefreshToken.for_user(user)

 # 2. Agregar claims personalizados
 refresh['username'] = user.username
 refresh['email'] = user.email
 refresh['segment'] = user.segment
 refresh['roles'] = list(user.roles.values_list('code', flat=True))

 # 3. Access token se genera automáticamente del refresh
 access = refresh.access_token

 # 4. Retornar ambos tokens
 return {
 'access': str(access),
 'refresh': str(refresh)
 }
```

#### Validación de Access Token

```python
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError

def validate_access_token(request) -> User:
 """
 Validar access token del request

 Returns:
 User: Usuario autenticado

 Raises:
 InvalidToken: Si token inválido
 TokenExpired: Si token expirado
 UserInactive: Si usuario inactivo
 UserLocked: Si usuario bloqueado
 """
 # PASO 1: Extraer token del header
 auth_header = request.headers.get('Authorization', '')

 if not auth_header.startswith('Bearer '):
 raise InvalidToken('Header Authorization inválido')

 token = auth_header.split(' ')[1]

 # PASO 2: Validar token con simplejwt
 jwt_auth = JWTAuthentication()

 try:
 validated_token = jwt_auth.get_validated_token(token)
 user = jwt_auth.get_user(validated_token)
 except TokenError as e:
 raise InvalidToken(f'Token inválido: {str(e)}')

 # PASO 3: Validar tipo de token
 if validated_token.get('token_type') != 'access':
 raise InvalidToken('Debe usar access token')

 # PASO 4: Validaciones adicionales del usuario
 if not user.is_active:
 raise UserInactive('Usuario inactivo')

 if user.is_locked:
 raise UserLocked('Usuario bloqueado')

 # PASO 5: Actualizar last_activity_at en sesión
 update_session_activity(user, request)

 return user
```

#### Refresh de Access Token

```python
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import TokenError

def refresh_access_token(refresh_token_str: str) -> dict:
 """
 Generar nuevo access token usando refresh token

 Returns:
 dict con nuevo access y refresh token

 Raises:
 TokenError: Si refresh token inválido/expirado/blacklisted
 """
 try:
 # Validar refresh token
 refresh = RefreshToken(refresh_token_str)

 # Generar nuevo access token
 new_access = str(refresh.access_token)

 # Rotar refresh token (genera nuevo y blacklist el viejo)
 # Esto es automático con ROTATE_REFRESH_TOKENS = True
 refresh.set_jti() # Nuevo JTI
 refresh.set_exp() # Nueva expiración

 # Blacklist el viejo
 refresh.blacklist()

 # Retornar nuevos tokens
 return {
 'access': new_access,
 'refresh': str(refresh)
 }

 except TokenError as e:
 raise InvalidToken(f'Refresh token inválido: {str(e)}')
```

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- djangorestframework-simplejwt instalado
- SECRET_KEY configurado (>= 256 bits)
- User model existente
- Migraciones de token_blacklist ejecutadas

### 4.2 Requisitos Relacionados

- **RF-005:** Login con Credenciales (genera tokens)
- **RF-007:** Logout Manual (blacklist tokens)
- **RF-008:** Cierre por Inactividad (invalidar tokens)

### 4.3 Restricciones del Proyecto

Del documento `restricciones_y_lineamientos.md`:

- **RESTR-006:** JWT + Permissions - autenticación robusta obligatoria
- **RESTR-005:** DEBUG=False siempre - no exponer SECRET_KEY

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-006-001:** test_generacion_tokens_con_claims_personalizados
- [ ] **TEST-006-002:** test_access_token_expira_exactamente_15_minutos
- [ ] **TEST-006-003:** test_refresh_token_expira_exactamente_7_dias
- [ ] **TEST-006-004:** test_validacion_exitosa_access_token
- [ ] **TEST-006-005:** test_validacion_falla_token_expirado
- [ ] **TEST-006-006:** test_validacion_falla_firma_invalida
- [ ] **TEST-006-007:** test_validacion_falla_tipo_token_incorrecto
- [ ] **TEST-006-008:** test_validacion_falla_usuario_inactivo
- [ ] **TEST-006-009:** test_validacion_falla_usuario_bloqueado
- [ ] **TEST-006-010:** test_refresh_token_genera_nuevo_par
- [ ] **TEST-006-011:** test_refresh_token_blacklistea_viejo
- [ ] **TEST-006-012:** test_refresh_token_falla_token_blacklisted
- [ ] **TEST-006-013:** test_refresh_token_falla_token_expirado
- [ ] **TEST-006-014:** test_algoritmo_firma_es_hs256
- [ ] **TEST-006-015:** test_secret_key_longitud_minima_256_bits

### 5.2 Tests de Integración

- [ ] **TEST-006-INT-001:** test_flujo_completo_login_validacion_refresh
- [ ] **TEST-006-INT-002:** test_rotacion_refresh_tokens_en_multiple_refresh

### 5.3 Tests de Seguridad

- [ ] **TEST-006-SEC-001:** test_no_acepta_algoritmo_none
- [ ] **TEST-006-SEC-002:** test_no_acepta_firma_con_otro_secret
- [ ] **TEST-006-SEC-003:** test_claims_no_contienen_password

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado
- [ ] 15 tests unitarios implementados y pasando
- [ ] Tests de integración implementados y pasando
- [ ] Tests de seguridad implementados y pasando
- [ ] Coverage >= 95% para TokenService
- [ ] Documentación técnica actualizada (este documento)
- [ ] Performance verificado (< 10ms por validación)
- [ ] SECRET_KEY en variable de entorno (NO hardcoded)
- [ ] Migraciones de token_blacklist aplicadas

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de las reglas de negocio:
- **RN-C01-03:** Generación de Tokens JWT
- **RN-C01-04:** Validación de Tokens JWT
- **RN-C01-11:** Refresh Token

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|--------|-----------|
| Test | TEST-006 | Tests de tokens JWT | `tests/authentication/test_tokens.py` |
| Código | IMPL-006 | TokenService | `apps/authentication/services.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Reglas de negocio: `docs/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (líneas 548-828)
- Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### 8.2 Estándares Aplicados

- **RFC 7519:** JSON Web Token (JWT)
- **ISO/IEC/IEEE 29148:2018:** Clause 9.6 - Software Requirements Specification
- **OWASP ASVS:** Token-Based Session Management

### 8.3 Bibliotecas

- **djangorestframework-simplejwt:** https://django-rest-framework-simplejwt.readthedocs.io/

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial basada en RN-C01-03, RN-C01-04, RN-C01-11 |
