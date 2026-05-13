---
id: RN-C01-COMPONENTE-1
tipo: reglas_negocio
titulo: Reglas de Negocio - Componente 1 - Autenticación y Sesiones
version: 6.0.0
fecha_creacion: 2025-11-04
dominio: backend
componente: autenticacion_sesiones
owner: equipo-backend
estado: completo_definitivo
date: 2025-11-13
---

# COMPONENTE 1 - PARTE 1: REGLAS DE NEGOCIO

**Sistema:** IACT
**Componente:** 1 de 12 - Autenticación y Sesiones
**Documento:** Reglas de Negocio Detalladas (14 reglas)
**Versión:** 6.0.0 - COMPLETO Y DEFINITIVO
**Fecha:** 4 de noviembre de 2025

---

## NOTA ÍNDICE DE REGLAS

### Reglas MUST (14 reglas - 100%)

| # | Código | Nombre | Tipo | Sprint |
|---|--------|--------|------|--------|
| 1 | RN-C01-01 | Login con Credenciales Locales | ACTIVADOR | 1 |
| 2 | RN-C01-02 | Validación de Credenciales | RESTRICCIÓN | 1 |
| 3 | RN-C01-03 | Generación de Tokens JWT | ACTIVADOR | 1 |
| 4 | RN-C01-04 | Validación de Tokens JWT | RESTRICCIÓN | 1 |
| 5 | RN-C01-05 | Logout Manual | ACTIVADOR | 1 |
| 6 | RN-C01-06 | Cierre por Inactividad | ACTIVADOR | 1 |
| 7 | RN-C01-07 | Complejidad de Contraseñas | RESTRICCIÓN | 1 |
| 8 | RN-C01-08 | Intentos Fallidos Limitados | RESTRICCIÓN | 1 |
| 9 | RN-C01-09 | Bloqueo Temporal de Cuenta | ACTIVADOR | 1 |
| 10 | RN-C01-10 | Hash Seguro de Passwords | HECHO | 1 |
| 11 | RN-C01-11 | Refresh Token | ACTIVADOR | 2 |
| 12 | RN-C01-12 | Auditoría de Login | ACTIVADOR | 2 |
| 13 | RN-C01-13 | Sesiones en PostgreSQL | HECHO | 1 |
| 14 | RN-C01-14 | Sesión Única por Usuario | RESTRICCIÓN | 1 |

---

## INFO REGLAS DETALLADAS

---

### **RN-C01-01: Login con Credenciales Locales** CRITICO MUST

**Código:** RN-C01-01
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1
**UC Relacionado:** UC-001 (Iniciar Sesión)

#### **Descripción**

El sistema debe permitir a los usuarios autenticarse **únicamente** mediante credenciales locales (username/password) almacenadas en la base de datos PostgreSQL del sistema. No se soporta ningún otro método de autenticación.

#### **Restricciones Aplicables**

```yaml
NO PROHIBIDO:
 - LDAP/Active Directory
 - OAuth2 (Google, Microsoft, GitHub, etc.)
 - SAML
 - Autenticación biométrica
 - Passwordless (Magic links)
 - Validación de IP address
 - Bloqueo por cambio de IP

OK OBLIGATORIO:
 - Solo autenticación local
 - Credenciales en PostgreSQL
 - Almacenar user_agent (NO validar)
 - Sesión única por usuario
 - Bloqueo tras 3 intentos
```

#### **Disparador**

```
CUANDO usuario envía POST /api/v1/auth/login con credenciales
```

#### **Condiciones de Entrada**

- Username NO debe estar vacío
- Password NO debe estar vacío
- Username debe existir en tabla `users` (PostgreSQL)
- Password debe coincidir con el hash bcrypt almacenado
- Usuario debe estar en estado "ACTIVO" (`status = 'ACTIVO'`)
- Usuario NO debe estar bloqueado (`is_locked = False`)
- Si tiene sesión activa previa, debe cerrarse primero (sesión única)

#### **Lógica de Negocio**

```python
def login(username: str, password: str, request) -> dict:
 """
 Autenticar usuario con credenciales locales

 Args:
 username: Nombre de usuario o email
 password: Contraseña en texto plano
 request: Request HTTP (para user_agent)

 Returns:
 dict con access_token, refresh_token, expires_in

 Raises:
 AuthenticationFailed: Si credenciales inválidas
 UserInactive: Si usuario no está activo
 UserLocked: Si cuenta está bloqueada
 """

 # PASO 1: Validar credenciales (RN-C01-02)
 try:
 user = validate_credentials(username, password)
 except (InvalidCredentials, UserInactive, UserLocked) as e:
 # Incrementar intentos fallidos
 handle_failed_login(username)
 raise e

 # PASO 2: Cerrar sesión previa si existe (sesión única - RN-C01-14)
 active_sessions = UserSession.objects.filter(
 user=user,
 is_active=True
 )

 if active_sessions.exists():
 for session in active_sessions:
 # Cerrar sesión anterior
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'NEW_SESSION'
 session.save()

 # Cerrar en django_session también
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 pass

 # Auditar cierre
 AuditLog.create(
 event_type='SESSION_CLOSED',
 user_id=user.id,
 user_agent=request.META.get('HTTP_USER_AGENT'),
 details={
 'reason': 'new_session',
 'old_session_id': session.session_id
 }
 )

 # Notificar al usuario vía buzón interno (NO email, SIN IP)
 InternalMessage.create(
 user_id=user.id,
 subject='Nueva sesión iniciada',
 body='Se ha iniciado una nueva sesión en tu cuenta.\n\n'
 'Tu sesión anterior ha sido cerrada automáticamente.\n\n'
 'Si no fuiste tú quien inició esta sesión, '
 'por favor cambia tu contraseña inmediatamente.',
 severity='INFO',
 created_by_system=True
 )

 # PASO 3: Crear nueva sesión en PostgreSQL
 session = UserSession.objects.create(
 user=user,
 session_key=request.session.session_key,
 user_agent=request.META.get('HTTP_USER_AGENT', 'Unknown'), # OK Almacenar
 is_active=True,
 created_at=now(),
 last_activity_at=now()
 )

 # PASO 4: Generar tokens JWT (RN-C01-03)
 from rest_framework_simplejwt.tokens import RefreshToken

 refresh = RefreshToken.for_user(user)

 # Agregar claims personalizados
 refresh['username'] = user.username
 refresh['email'] = user.email
 refresh['segment'] = user.segment
 refresh['roles'] = list(user.roles.values_list('code', flat=True))

 access_token = str(refresh.access_token)
 refresh_token = str(refresh)

 # PASO 5: Actualizar datos del usuario
 user.last_login_at = now()
 user.failed_login_attempts = 0 # Resetear contador
 user.last_failed_login_at = None
 user.save()

 # PASO 6: Auditar login exitoso (RN-C01-12)
 AuditLog.create(
 event_type='LOGIN_SUCCESS',
 user_id=user.id,
 user_agent=request.META.get('HTTP_USER_AGENT'), # OK Para auditoría
 details={
 'username': user.username,
 'method': 'local',
 'session_id': session.session_id
 },
 result='SUCCESS'
 )

 # PASO 7: Retornar tokens
 return {
 'access_token': access_token,
 'refresh_token': refresh_token,
 'token_type': 'Bearer',
 'expires_in': 900 # 15 minutos en segundos
 }
```

#### **Manejo de Errores**

```python
def handle_failed_login(username: str):
 """
 Incrementar intentos fallidos y bloquear si es necesario
 """
 try:
 user = User.objects.get(username=username)
 except User.DoesNotExist:
 # Usuario no existe, no hacemos nada
 return

 # Incrementar contador (NO se resetea por tiempo)
 user.failed_login_attempts += 1
 user.last_failed_login_at = now()

 # Bloquear si llegó a 3 intentos (RN-C01-08, RN-C01-09)
 if user.failed_login_attempts >= 3:
 user.is_locked = True
 user.locked_until = now() + timedelta(minutes=15)
 user.lock_reason = 'MAX_FAILED_ATTEMPTS'

 # Notificar vía buzón interno (NO email, SIN IP)
 InternalMessage.create(
 user_id=user.id,
 subject='Cuenta bloqueada temporalmente',
 body=f'Tu cuenta ha sido bloqueada por 15 minutos debido a '
 f'múltiples intentos fallidos de login.\n\n'
 f'Será desbloqueada automáticamente a las '
 f'{user.locked_until.strftime("%H:%M:%S")}.\n\n'
 f'Si no fuiste tú quien intentó acceder, por favor '
 f'contacta al administrador del sistema inmediatamente.',
 severity='WARNING',
 created_by_system=True
 )

 # Auditar bloqueo
 AuditLog.create(
 event_type='USER_LOCKED',
 user_id=user.id,
 details={
 'reason': 'max_failed_attempts',
 'failed_attempts': 3,
 'locked_until': user.locked_until.isoformat()
 },
 result='FAILURE'
 )

 user.save()
```

#### **Datos de Entrada**

```json
POST /api/v1/auth/login
Content-Type: application/json

{
 "username": "juan.perez",
 "password": "SecureP@ss123"
}
```

#### **Datos de Salida (Éxito)**

```json
HTTP 200 OK
Content-Type: application/json

{
 "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMjMsInVzZXJuYW1lIjoianVhbi5wZXJleiIsImVtYWlsIjoianVhbi5wZXJlekBjb21wYW55LmNvbSIsInNlZ21lbnQiOiJHRSIsInJvbGVzIjpbIkFOQUxJU1RBX0RBVE9TIiwiVklFV0VSX0JBU0lDTyJdLCJpYXQiOjE3MzA3MDcyMDAsImV4cCI6MTczMDcwODEwMCwianRpIjoidW5pcXVlLWp3dC1pZCIsInRva2VuX3R5cGUiOiJhY2Nlc3MifQ.signature",
 "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMjMsInVzZXJuYW1lIjoianVhbi5wZXJleiIsImVtYWlsIjoianVhbi5wZXJlekBjb21wYW55LmNvbSIsInNlZ21lbnQiOiJHRSIsInJvbGVzIjpbIkFOQUxJU1RBX0RBVE9TIiwiVklFV0VSX0JBU0lDTyJdLCJpYXQiOjE3MzA3MDcyMDAsImV4cCI6MTczMTMxMjAwMCwianRpIjoidW5pcXVlLXJlZnJlc2gtaWQiLCJ0b2tlbl90eXBlIjoicmVmcmVzaCJ9.signature",
 "token_type": "Bearer",
 "expires_in": 900
}
```

#### **Datos de Salida (Error)**

```json
// Credenciales inválidas
HTTP 401 Unauthorized
{
 "error": "Credenciales inválidas",
 "attempts_remaining": 2
}

// Usuario bloqueado
HTTP 403 Forbidden
{
 "error": "Cuenta bloqueada",
 "locked_until": "2025-11-04T11:15:00Z",
 "minutes_remaining": 14
}

// Usuario inactivo
HTTP 403 Forbidden
{
 "error": "Usuario inactivo",
 "message": "Contacta al administrador"
}

// Throttling
HTTP 429 Too Many Requests
{
 "error": "Demasiados intentos",
 "retry_after": 300
}
```

#### **Reglas Relacionadas**

- **RN-C01-02:** Validación de Credenciales
- **RN-C01-03:** Generación de Tokens JWT
- **RN-C01-08:** Intentos Fallidos Limitados
- **RN-C01-09:** Bloqueo Temporal
- **RN-C01-12:** Auditoría de Login
- **RN-C01-14:** Sesión Única

#### **Casos de Prueba**

- **TC-AUTH-001:** Login exitoso con credenciales válidas
- **TC-AUTH-002:** Login con credenciales inválidas
- **TC-AUTH-003:** Bloqueo tras 3 intentos fallidos
- **TC-AUTH-009:** Sesión única (cierre de sesión previa)

---

### **RN-C01-02: Validación de Credenciales** CRITICO MUST

**Código:** RN-C01-02
**Tipo:** RESTRICCIÓN
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Las credenciales proporcionadas deben ser validadas contra los valores almacenados de forma segura usando **bcrypt**. Solo se validan credenciales locales almacenadas en PostgreSQL.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - bcrypt con cost factor 12
 - Solo base de datos local (PostgreSQL)
 - Validar estado del usuario (ACTIVO)
 - Verificar bloqueo de cuenta
 - Desbloqueo automático si tiempo expiró

NO PROHIBIDO:
 - Validar contra LDAP/AD
 - Validar contra OAuth2
 - Validar contra servicios externos
```

#### **Regla de Negocio**

```
Username debe:
- Existir en tabla users (auth_source='local')
- Estar en formato válido (lowercase, sin espacios)
- NO estar eliminado lógicamente (deleted_at IS NULL)

Password debe:
- Coincidir con hash bcrypt almacenado en password_hash
- Verificarse mediante bcrypt.checkpw()
- Tener longitud entre 8-100 caracteres (validado en RN-C01-07)
```

#### **Algoritmo de Validación**

```python
import bcrypt
from django.utils.timezone import now
from datetime import timedelta

def validate_credentials(username: str, password: str) -> User:
 """
 Validar credenciales locales únicamente

 Args:
 username: Username o email del usuario
 password: Password en texto plano

 Returns:
 User: Objeto usuario si validación exitosa

 Raises:
 InvalidCredentials: Si username no existe o password incorrecto
 UserInactive: Si usuario no está activo
 UserLocked: Si cuenta está bloqueada
 """

 # PASO 1: Buscar usuario por username (o email)
 try:
 user = User.objects.get(
 username=username.lower().strip(),
 auth_source='local', # SOLO autenticación local
 deleted_at__isnull=True # No eliminados lógicamente
 )
 except User.DoesNotExist:
 # No revelar si el usuario existe o no (seguridad)
 raise InvalidCredentials('Credenciales inválidas')

 # PASO 2: Verificar que el password_hash existe
 if not user.password_hash:
 raise InvalidCredentials('Usuario sin contraseña configurada')

 # PASO 3: Verificar password con bcrypt
 try:
 password_bytes = password.encode('utf-8')
 hash_bytes = user.password_hash.encode('utf-8')

 if not bcrypt.checkpw(password_bytes, hash_bytes):
 raise InvalidCredentials('Contraseña incorrecta')
 except (ValueError, AttributeError) as e:
 # Hash corrupto o inválido
 raise InvalidCredentials('Error al validar contraseña')

 # PASO 4: Verificar estado del usuario
 if user.status != 'ACTIVO':
 if user.status == 'PENDIENTE_CONFIGURACION':
 raise UserInactive(
 'Usuario pendiente de configuración inicial'
 )
 else:
 raise UserInactive(
 'Usuario inactivo. Contacta al administrador.'
 )

 # PASO 5: Verificar bloqueo de cuenta
 if user.is_locked:
 # Verificar si ya pasó el tiempo de bloqueo
 if user.locked_until and now() < user.locked_until:
 # Aún está bloqueado
 tiempo_restante = (user.locked_until - now()).seconds // 60
 raise UserLocked(
 f'Cuenta bloqueada. Tiempo restante: {tiempo_restante} minutos'
 )
 else:
 # Ya pasó el tiempo, desbloquear automáticamente
 user.is_locked = False
 user.locked_until = None
 user.failed_login_attempts = 0
 user.lock_reason = None
 user.save()

 # Auditar desbloqueo automático
 AuditLog.create(
 event_type='USER_UNLOCKED',
 user_id=user.id,
 details={
 'reason': 'automatic_timeout',
 'unlocked_at': now().isoformat()
 },
 result='SUCCESS'
 )

 # PASO 6: Validaciones adicionales (opcional)
 # Verificar que la contraseña no esté expirada (futuro)
 # if user.password_expires_at and now() > user.password_expires_at:
 # raise PasswordExpired('Contraseña expirada')

 # Validación exitosa
 return user
```

#### **Excepciones Personalizadas**

```python
class InvalidCredentials(Exception):
 """Username no existe o password incorrecto"""
 pass

class UserInactive(Exception):
 """Usuario no está en estado ACTIVO"""
 pass

class UserLocked(Exception):
 """Cuenta bloqueada temporalmente"""
 pass
```

#### **Performance**

```yaml
Objetivo: < 500ms por validación
Factores:
 - bcrypt es intencionalmente lento (cost 12)
 - Query a PostgreSQL: ~10-50ms
 - bcrypt.checkpw(): ~300-400ms
 - Total típico: ~350-450ms

Optimizaciones:
 - NO cachear passwords (seguridad)
 - SÍ usar índice en username
 - Cost factor configurable (ajustar en producción si necesario)
```

#### **Seguridad**

```yaml
Fortalezas:
 OK bcrypt resistente a rainbow tables
 OK Salt único por password
 OK Cost factor ajustable (futureproof)
 OK Timing attack mitigation (bcrypt constante)
 OK No revela si username existe

Consideraciones:
 WARNING Mismo mensaje de error para username y password
 WARNING No especificar cuál campo es incorrecto
 WARNING Rate limiting en endpoint de login (5/5min)
```

#### **Reglas Relacionadas**

- **RN-C01-01:** Login con Credenciales
- **RN-C01-10:** Hash Seguro de Passwords
- **RN-C01-07:** Complejidad de Contraseñas

---

### **RN-C01-03: Generación de Tokens JWT** CRITICO MUST

**Código:** RN-C01-03
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Al autenticarse exitosamente, el sistema genera tokens JWT (JSON Web Tokens) usando **djangorestframework-simplejwt** con las configuraciones específicas del proyecto.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Access token: 15 minutos exactos
 - Refresh token: 7 días exactos
 - Rotate refresh tokens: True
 - Blacklist after rotation: True
 - Algoritmo: HS256
 - Claims personalizados: username, email, segment, roles

NO PROHIBIDO:
 - Tokens de larga duración
 - Tokens sin expiración
 - Algoritmos inseguros (None, HS1)
 - Secrets hardcodeados
```

#### **Estructura del Access Token**

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

#### **Estructura del Refresh Token**

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
 "exp": 1731312000,
 "jti": "unique-refresh-id-xyz789",
 "token_type": "refresh"
 },
 "signature": "..."
}
```

#### **Configuración (settings.py)**

```python
from datetime import timedelta

SIMPLE_JWT = {
 # Duración de tokens (RESTRICCIONES)
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

 # Sliding tokens (NO usamos)
 'SLIDING_TOKEN_REFRESH_EXP_CLAIM': 'refresh_exp',
 'SLIDING_TOKEN_LIFETIME': timedelta(minutes=5),
 'SLIDING_TOKEN_REFRESH_LIFETIME': timedelta(days=1),
}
```

#### **Proceso de Generación**

```python
from rest_framework_simplejwt.tokens import RefreshToken

def generate_tokens_for_user(user) -> dict:
 """
 Generar access y refresh tokens para un usuario

 Args:
 user: Objeto User

 Returns:
 dict con 'access' y 'refresh' tokens
 """
 # 1. Crear refresh token
 refresh = RefreshToken.for_user(user)

 # 2. Agregar claims personalizados
 refresh['username'] = user.username
 refresh['email'] = user.email
 refresh['segment'] = user.segment

 # Obtener roles del usuario (M2M relationship)
 roles = list(user.roles.values_list('code', flat=True))
 refresh['roles'] = roles

 # 3. Access token se genera automáticamente del refresh
 access = refresh.access_token

 # 4. Retornar ambos tokens
 return {
 'access': str(access),
 'refresh': str(refresh)
 }
```

#### **Claims Personalizados**

| Claim | Tipo | Descripción | Ejemplo |
|-------|------|-------------|---------|
| `user_id` | int | ID del usuario | 123 |
| `username` | string | Nombre de usuario | "juan.perez" |
| `email` | string | Email del usuario | "juan@company.com" |
| `segment` | string | Segmento de datos | "GE", "OP", "FI" |
| `roles` | array | Códigos de roles | ["R009", "R010"] |
| `iat` | int | Issued at (timestamp) | 1730707200 |
| `exp` | int | Expiration (timestamp) | 1730708100 |
| `jti` | string | JWT ID (único) | "abc123..." |
| `token_type` | string | Tipo de token | "access" o "refresh" |

#### **Decodificación (Backend)**

```python
import jwt
from django.conf import settings

def decode_access_token(token: str) -> dict:
 """
 Decodificar y validar access token
 """
 try:
 payload = jwt.decode(
 token,
 settings.SECRET_KEY,
 algorithms=['HS256']
 )

 # Validar tipo de token
 if payload.get('token_type') != 'access':
 raise InvalidToken('No es un access token')

 return payload

 except jwt.ExpiredSignatureError:
 raise TokenExpired('Token expirado')
 except jwt.InvalidTokenError as e:
 raise InvalidToken(f'Token inválido: {str(e)}')
```

#### **Validación (Frontend)**

```javascript
// Validar token en frontend (NO verificar firma, solo estructura)
function isTokenExpired(token) {
 try:
 const payload = JSON.parse(atob(token.split('.')[1]));
 const exp = payload.exp * 1000; // Convertir a ms
 return Date.now() >= exp;
 } catch (e) {
 return true; // Si hay error, asumir expirado
 }
}

// Refrescar token si está por expirar
if (isTokenExpired(accessToken)) {
 const newTokens = await refreshAccessToken(refreshToken);
 localStorage.setItem('access_token', newTokens.access);
 localStorage.setItem('refresh_token', newTokens.refresh);
}
```

#### **Seguridad del Secret**

```yaml
Secret Key:
 OK Mínimo 256 bits (32 caracteres)
 OK Desde variable de entorno
 OK Nunca en código fuente
 OK Único por ambiente (dev/staging/prod)
 OK Rotación cada 90 días

Generación segura:
 python -c "import secrets; print(secrets.token_urlsafe(32))"

Variable de entorno:
 export DJANGO_SECRET_KEY="tu-secret-key-super-seguro-aqui"
```

#### **Blacklist de Tokens**

```python
# Al hacer logout o refresh
from rest_framework_simplejwt.tokens import RefreshToken

def blacklist_token(refresh_token_str: str):
 """
 Agregar refresh token a blacklist
 """
 try:
 token = RefreshToken(refresh_token_str)
 token.blacklist() # Método de simplejwt
 except Exception as e:
 # Token ya blacklisted o inválido
 pass
```

#### **Tablas de Blacklist (simplejwt)**

```sql
-- Tokens emitidos (outstanding)
CREATE TABLE token_blacklist_outstandingtoken (
 id SERIAL PRIMARY KEY,
 user_id INTEGER REFERENCES users(user_id),
 jti VARCHAR(255) UNIQUE NOT NULL,
 token TEXT NOT NULL,
 created_at TIMESTAMP,
 expires_at TIMESTAMP
);

-- Tokens blacklisted
CREATE TABLE token_blacklist_blacklistedtoken (
 id SERIAL PRIMARY KEY,
 token_id INTEGER UNIQUE NOT NULL
 REFERENCES token_blacklist_outstandingtoken(id),
 blacklisted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **Reglas Relacionadas**

- **RN-C01-01:** Login (genera tokens)
- **RN-C01-04:** Validación de Tokens
- **RN-C01-05:** Logout (blacklist)
- **RN-C01-11:** Refresh Token

---

### **RN-C01-04: Validación de Tokens JWT** CRITICO MUST

**Código:** RN-C01-04
**Tipo:** RESTRICCIÓN
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Cada request a endpoints protegidos debe validar el JWT access token enviado en el header `Authorization: Bearer <token>`.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Verificar firma con SECRET_KEY
 - Validar expiración (exp claim)
 - Validar estructura del token
 - Verificar que no esté blacklisted
 - Validar tipo de token (access vs refresh)

NO PROHIBIDO:
 - Aceptar tokens sin firma
 - Aceptar tokens expirados
 - Permitir algoritmo "None"
 - Aceptar tokens de otros sistemas
```

#### **Algoritmo de Validación**

```python
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError

def validate_access_token(request):
 """
 Validar access token del request

 Returns:
 User: Usuario autenticado

 Raises:
 InvalidToken: Si token inválido
 TokenExpired: Si token expirado
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

#### **Reglas Relacionadas**

- **RN-C01-03:** Generación de Tokens JWT
- **RN-C01-06:** Cierre por Inactividad
- **RN-C01-11:** Refresh Token

---

### **RN-C01-05: Logout Manual** CRITICO MUST

**Código:** RN-C01-05
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

El usuario puede cerrar su sesión manualmente en cualquier momento mediante el endpoint de logout.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Invalidar refresh token (blacklist)
 - Cerrar sesión en user_sessions (is_active=False)
 - Cerrar sesión en django_session (delete)
 - Auditar logout
 - Access token sigue válido hasta expirar (stateless JWT)

NO PROHIBIDO:
 - Invalidar access tokens (no hay blacklist para access)
 - Mantener sesión activa después de logout
```

#### **Algoritmo de Logout**

```python
def logout(user, refresh_token: str, request):
 """
 Cerrar sesión manualmente

 Args:
 user: Usuario autenticado
 refresh_token: Refresh token a invalidar
 request: Request HTTP
 """
 # PASO 1: Blacklist refresh token
 try:
 token = RefreshToken(refresh_token)
 token.blacklist()
 except Exception as e:
 # Token ya blacklisted o inválido, continuar
 pass

 # PASO 2: Cerrar sesión en user_sessions
 sessions = UserSession.objects.filter(
 user=user,
 is_active=True
 )

 for session in sessions:
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'MANUAL'
 session.save()

 # Cerrar en django_session también
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 pass

 # PASO 3: Auditar logout
 AuditLog.create(
 event_type='LOGOUT_SUCCESS',
 user_id=user.id,
 user_agent=request.META.get('HTTP_USER_AGENT'),
 details={
 'method': 'manual',
 'sessions_closed': sessions.count()
 },
 result='SUCCESS'
 )
```

#### **Endpoint**

```python
POST /api/v1/auth/logout
Authorization: Bearer <access_token>

{
 "refresh_token": "eyJhbGci..."
}
```

#### **Reglas Relacionadas**

- **RN-C01-03:** Generación de Tokens
- **RN-C01-12:** Auditoría de Login

---

### **RN-C01-06: Cierre por Inactividad** CRITICO MUST

**Código:** RN-C01-06
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Las sesiones se cierran automáticamente tras **30 minutos de inactividad** (sin requests al backend).

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Timeout: 30 minutos exactos
 - Actualizar last_activity_at en cada request válido
 - Job programado cada 5 minutos verifica sesiones inactivas
 - Cerrar sesión automáticamente
 - Auditar cierre por inactividad

NO PROHIBIDO:
 - Extender sesiones indefinidamente
 - No registrar actividad
```

#### **Actualización de Actividad**

```python
def update_session_activity(user, request):
 """
 Actualizar last_activity_at en cada request
 """
 session = UserSession.objects.filter(
 user=user,
 is_active=True
 ).first()

 if session:
 session.last_activity_at = now()
 session.save(update_fields=['last_activity_at'])
```

#### **Job de Cierre Automático**

```python
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import timedelta

def close_inactive_sessions():
 """
 Job que corre cada 5 minutos para cerrar sesiones inactivas
 """
 timeout_limit = now() - timedelta(minutes=30)

 inactive_sessions = UserSession.objects.filter(
 is_active=True,
 last_activity_at__lt=timeout_limit
 )

 for session in inactive_sessions:
 # Cerrar sesión
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'INACTIVITY_TIMEOUT'
 session.save()

 # Cerrar en django_session
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 pass

 # Blacklist refresh token si existe
 # (requiere buscar token asociado al session_key)

 # Auditar cierre
 AuditLog.create(
 event_type='SESSION_TIMEOUT',
 user_id=session.user_id,
 details={
 'reason': 'inactivity',
 'inactive_minutes': 30,
 'session_id': session.session_id
 },
 result='SUCCESS'
 )

 # Notificar usuario vía buzón interno (NO email)
 InternalMessage.create(
 user_id=session.user_id,
 subject='Sesión cerrada por inactividad',
 body='Tu sesión ha sido cerrada automáticamente por inactividad '
 'de más de 30 minutos.\n\n'
 'Por seguridad, debes iniciar sesión nuevamente.',
 severity='INFO',
 created_by_system=True
 )

# Configurar scheduler
scheduler = BackgroundScheduler()
scheduler.add_job(
 close_inactive_sessions,
 'interval',
 minutes=5,
 id='close_inactive_sessions'
)
scheduler.start()
```

#### **Reglas Relacionadas**

- **RN-C01-04:** Validación de Tokens
- **RN-C01-12:** Auditoría de Login

---

### **RN-C01-07: Complejidad de Contraseñas** CRITICO MUST

**Código:** RN-C01-07
**Tipo:** RESTRICCIÓN
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Las contraseñas deben cumplir requisitos mínimos de complejidad para garantizar seguridad.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Longitud mínima: 8 caracteres
 - Longitud máxima: 100 caracteres
 - Al menos 1 letra mayúscula
 - Al menos 1 letra minúscula
 - Al menos 1 dígito
 - Al menos 1 carácter especial (!@#$%^&*()_+-=[]{}|;:,.<>?)
 - NO puede contener el username
 - NO puede contener nombre o apellido del usuario
 - NO puede ser igual a las últimas 5 contraseñas

NO PROHIBIDO:
 - Contraseñas débiles (123456, password, etc.)
 - Reutilizar contraseñas recientes
```

#### **Validador de Complejidad**

```python
import re
from django.core.exceptions import ValidationError

def validate_password_complexity(password: str, user=None) -> None:
 """
 Validar complejidad de contraseña

 Args:
 password: Contraseña a validar
 user: Usuario (para validar username/nombre)

 Raises:
 ValidationError: Si no cumple complejidad
 """
 errors = []

 # Longitud
 if len(password) < 8:
 errors.append('La contraseña debe tener al menos 8 caracteres')

 if len(password) > 100:
 errors.append('La contraseña no puede tener más de 100 caracteres')

 # Mayúsculas
 if not re.search(r'[A-Z]', password):
 errors.append('Debe contener al menos una letra mayúscula')

 # Minúsculas
 if not re.search(r'[a-z]', password):
 errors.append('Debe contener al menos una letra minúscula')

 # Dígitos
 if not re.search(r'\d', password):
 errors.append('Debe contener al menos un dígito')

 # Caracteres especiales
 if not re.search(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]', password):
 errors.append('Debe contener al menos un carácter especial')

 # Validar contra datos del usuario
 if user:
 password_lower = password.lower()

 if user.username.lower() in password_lower:
 errors.append('La contraseña no puede contener el username')

 if user.first_name and user.first_name.lower() in password_lower:
 errors.append('La contraseña no puede contener tu nombre')

 if user.last_name and user.last_name.lower() in password_lower:
 errors.append('La contraseña no puede contener tu apellido')

 if errors:
 raise ValidationError(errors)
```

#### **Historial de Contraseñas**

```python
def validate_password_history(user, new_password: str) -> None:
 """
 Validar que no reutilice últimas 5 contraseñas
 """
 # Obtener últimas 5 contraseñas
 history = PasswordHistory.objects.filter(
 user=user
 ).order_by('-created_at')[:5]

 for old_password_entry in history:
 if bcrypt.checkpw(
 new_password.encode('utf-8'),
 old_password_entry.password_hash.encode('utf-8')
 ):
 raise ValidationError(
 'No puedes reutilizar ninguna de tus últimas 5 contraseñas'
 )
```

#### **Reglas Relacionadas**

- **RN-C01-02:** Validación de Credenciales
- **RN-C01-10:** Hash Seguro de Passwords

---

### **RN-C01-08: Intentos Fallidos Limitados** CRITICO MUST

**Código:** RN-C01-08
**Tipo:** RESTRICCIÓN
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

El sistema limita los intentos de login a **3 intentos fallidos**. Al tercer intento fallido, la cuenta se bloquea automáticamente.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Máximo 3 intentos fallidos
 - Contador NO se resetea por tiempo
 - Contador solo se resetea con login exitoso
 - Bloqueo automático al 3er intento
 - Notificar vía buzón interno (NO email)

NO PROHIBIDO:
 - Permitir intentos ilimitados
 - Resetear contador automáticamente por tiempo
```

#### **Implementación**

```python
def handle_failed_login(username: str):
 """
 Incrementar intentos fallidos y bloquear si es necesario
 """
 try:
 user = User.objects.get(username=username)
 except User.DoesNotExist:
 # No revelar si el usuario existe
 return

 # Incrementar contador
 user.failed_login_attempts += 1
 user.last_failed_login_at = now()

 # Bloquear al 3er intento
 if user.failed_login_attempts >= 3:
 user.is_locked = True
 user.locked_until = now() + timedelta(minutes=15)
 user.lock_reason = 'MAX_FAILED_ATTEMPTS'

 # Notificar vía buzón interno
 InternalMessage.create(
 user_id=user.id,
 subject='Cuenta bloqueada',
 body=f'Tu cuenta ha sido bloqueada por 15 minutos.\n\n'
 f'Será desbloqueada automáticamente a las '
 f'{user.locked_until.strftime("%H:%M:%S")}.',
 severity='WARNING',
 created_by_system=True
 )

 # Auditar bloqueo
 AuditLog.create(
 event_type='USER_LOCKED',
 user_id=user.id,
 details={
 'reason': 'max_failed_attempts',
 'attempts': 3
 }
 )

 user.save()
```

#### **Reglas Relacionadas**

- **RN-C01-01:** Login
- **RN-C01-09:** Bloqueo Temporal

---

### **RN-C01-09: Bloqueo Temporal de Cuenta** CRITICO MUST

**Código:** RN-C01-09
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Cuando una cuenta es bloqueada por intentos fallidos, permanece bloqueada exactamente **15 minutos**.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Duración: 15 minutos exactos
 - Desbloqueo automático al cumplirse el tiempo
 - Desbloqueo manual por administrador (role R016)
 - Notificar vía buzón interno (NO email)
 - Auditar desbloqueo

NO PROHIBIDO:
 - Bloqueos permanentes sin intervención admin
 - No notificar al usuario
```

#### **Desbloqueo Automático**

El desbloqueo automático ocurre en `RN-C01-02: Validación de Credenciales` cuando se detecta que `locked_until` ya pasó:

```python
# En validate_credentials()
if user.is_locked:
 if user.locked_until and now() < user.locked_until:
 # Aún bloqueado
 raise UserLocked('Cuenta bloqueada')
 else:
 # Tiempo cumplido, desbloquear
 user.is_locked = False
 user.locked_until = None
 user.failed_login_attempts = 0
 user.lock_reason = None
 user.save()

 AuditLog.create(
 event_type='USER_UNLOCKED',
 user_id=user.id,
 details={'reason': 'automatic_timeout'}
 )
```

#### **Desbloqueo Manual**

```python
def unlock_user_manual(admin_user, target_user):
 """
 Desbloquear usuario manualmente (requiere role R016)
 """
 if not admin_user.has_role('R016'):
 raise PermissionDenied('No tienes permiso para desbloquear usuarios')

 target_user.is_locked = False
 target_user.locked_until = None
 target_user.failed_login_attempts = 0
 target_user.lock_reason = None
 target_user.save()

 # Auditar
 AuditLog.create(
 event_type='USER_UNLOCKED',
 user_id=target_user.id,
 performed_by=admin_user.id,
 details={'reason': 'manual_unlock_by_admin'}
 )

 # Notificar usuario
 InternalMessage.create(
 user_id=target_user.id,
 subject='Cuenta desbloqueada',
 body='Tu cuenta ha sido desbloqueada por un administrador.',
 severity='INFO',
 created_by_system=True
 )
```

#### **Reglas Relacionadas**

- **RN-C01-08:** Intentos Fallidos
- **RN-C01-02:** Validación de Credenciales

---

### **RN-C01-10: Hash Seguro de Passwords** CRITICO MUST

**Código:** RN-C01-10
**Tipo:** HECHO
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Las contraseñas NUNCA se almacenan en texto plano. Se usa **bcrypt** con **cost factor 12** y salt automático por contraseña.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Algoritmo: bcrypt
 - Cost factor: 12
 - Salt automático por password
 - Guardar historial (últimas 5 passwords)

NO PROHIBIDO:
 - MD5
 - SHA1
 - Texto plano
 - Salt compartido
```

#### **Implementación**

```python
import bcrypt

def hash_password(password: str) -> str:
 """
 Hashear contraseña con bcrypt cost 12

 Args:
 password: Contraseña en texto plano

 Returns:
 str: Hash bcrypt
 """
 password_bytes = password.encode('utf-8')
 salt = bcrypt.gensalt(rounds=12) # Cost factor 12
 hashed = bcrypt.hashpw(password_bytes, salt)
 return hashed.decode('utf-8')

def set_user_password(user, new_password: str):
 """
 Establecer nueva contraseña para usuario
 """
 # Validar complejidad (RN-C01-07)
 validate_password_complexity(new_password, user)

 # Validar historial (RN-C01-07)
 validate_password_history(user, new_password)

 # Hashear
 hashed = hash_password(new_password)

 # Guardar en historial ANTES de cambiar
 if user.password_hash:
 PasswordHistory.objects.create(
 user=user,
 password_hash=user.password_hash,
 created_at=now()
 )

 # Mantener solo últimas 5
 history_count = PasswordHistory.objects.filter(user=user).count()
 if history_count > 5:
 oldest = PasswordHistory.objects.filter(
 user=user
 ).order_by('created_at').first()
 oldest.delete()

 # Actualizar password
 user.password_hash = hashed
 user.password_changed_at = now()
 user.save()
```

#### **Modelo PasswordHistory**

```python
class PasswordHistory(models.Model):
 user = models.ForeignKey(User, on_delete=models.CASCADE)
 password_hash = models.CharField(max_length=255)
 created_at = models.DateTimeField(auto_now_add=True)

 class Meta:
 db_table = 'password_history'
 ordering = ['-created_at']
```

#### **Reglas Relacionadas**

- **RN-C01-02:** Validación de Credenciales
- **RN-C01-07:** Complejidad de Contraseñas

---

### **RN-C01-11: Refresh Token** CRITICO MUST

**Código:** RN-C01-11
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 2

#### **Descripción**

Los refresh tokens permiten obtener nuevos access tokens sin requerir credenciales nuevamente. Duración: **7 días exactos**.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Duración: 7 días exactos
 - Rotar refresh token al usarlo (generar nuevo)
 - Blacklist refresh token viejo
 - Validar que no esté blacklisted
 - Validar que no haya expirado

NO PROHIBIDO:
 - Reutilizar refresh tokens
 - Refresh tokens sin expiración
```

#### **Endpoint Refresh**

```python
POST /api/v1/auth/refresh

{
 "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### **Implementación**

```python
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import TokenError

def refresh_access_token(refresh_token_str: str) -> dict:
 """
 Generar nuevo access token usando refresh token

 Args:
 refresh_token_str: Refresh token como string

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

#### **Configuración (ya incluida en RN-C01-03)**

```python
SIMPLE_JWT = {
 'REFRESH_TOKEN_LIFETIME': timedelta(days=7), # 7 días EXACTOS
 'ROTATE_REFRESH_TOKENS': True, # Rotar al usar
 'BLACKLIST_AFTER_ROTATION': True, # Blacklist viejo
}
```

#### **Reglas Relacionadas**

- **RN-C01-03:** Generación de Tokens
- **RN-C01-04:** Validación de Tokens

---

### **RN-C01-12: Auditoría de Login** CRITICO MUST

**Código:** RN-C01-12
**Tipo:** ACTIVADOR
**Prioridad:** MUST - CRÍTICO
**Sprint:** 2

#### **Descripción**

Todos los eventos de autenticación (login exitoso, fallido, logout, bloqueo) deben ser auditados.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Auditar login exitoso
 - Auditar login fallido
 - Auditar logout (manual, inactividad, nueva sesión)
 - Auditar bloqueo/desbloqueo
 - Almacenar user_agent (NO IP address)
 - Timestamp UTC

NO PROHIBIDO:
 - NO almacenar IP address
 - NO auditar acciones triviales
```

#### **Eventos Auditados**

| Evento | Código | Campos |
|--------|--------|--------|
| Login exitoso | LOGIN_SUCCESS | user_id, user_agent, session_id |
| Login fallido | LOGIN_FAILURE | username (NOT user_id), user_agent |
| Logout manual | LOGOUT_SUCCESS | user_id, user_agent, method='manual' |
| Logout por inactividad | SESSION_TIMEOUT | user_id, inactive_minutes=30 |
| Logout por nueva sesión | SESSION_CLOSED | user_id, reason='new_session' |
| Usuario bloqueado | USER_LOCKED | user_id, reason, failed_attempts |
| Usuario desbloqueado | USER_UNLOCKED | user_id, reason, performed_by |

#### **Modelo AuditLog**

```python
class AuditLog(models.Model):
 event_type = models.CharField(max_length=50)
 user_id = models.IntegerField(null=True) # Null para eventos sin user
 performed_by = models.IntegerField(null=True) # Admin que realizó acción
 user_agent = models.TextField(null=True)
 details = models.JSONField(default=dict)
 result = models.CharField(max_length=20) # SUCCESS, FAILURE
 created_at = models.DateTimeField(auto_now_add=True)

 class Meta:
 db_table = 'audit_logs'
 ordering = ['-created_at']
```

#### **Reglas Relacionadas**

- **RN-C01-01:** Login
- **RN-C01-05:** Logout
- **RN-C01-08:** Intentos Fallidos

---

### **RN-C01-13: Sesiones en PostgreSQL** CRITICO MUST

**Código:** RN-C01-13
**Tipo:** HECHO
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Las sesiones se almacenan en **PostgreSQL** usando las tablas `django_session` (Django nativo) y `user_sessions` (custom).

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Backend: django.contrib.sessions.backends.db
 - Base de datos: PostgreSQL
 - NO Redis
 - NO Memcached
 - NO file-based sessions

NO PROHIBIDO:
 - Redis como session store
 - Cached sessions
 - Cookie-only sessions
```

#### **Configuración**

```python
# settings.py
SESSION_ENGINE = 'django.contrib.sessions.backends.db'
SESSION_COOKIE_AGE = 1800 # 30 minutos
SESSION_SAVE_EVERY_REQUEST = True # Actualizar en cada request
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True # HTTPS only
SESSION_COOKIE_SAMESITE = 'Lax'
```

#### **Tablas**

```sql
-- Tabla Django nativa
CREATE TABLE django_session (
 session_key VARCHAR(40) PRIMARY KEY,
 session_data TEXT NOT NULL,
 expire_date TIMESTAMP NOT NULL
);

-- Tabla custom para tracking
CREATE TABLE user_sessions (
 session_id SERIAL PRIMARY KEY,
 user_id INTEGER NOT NULL REFERENCES users(user_id),
 session_key VARCHAR(40) UNIQUE NOT NULL,
 user_agent TEXT,
 is_active BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 logged_out_at TIMESTAMP,
 logout_reason VARCHAR(50)
);
```

#### **Reglas Relacionadas**

- **RN-C01-01:** Login
- **RN-C01-06:** Cierre por Inactividad

---

### **RN-C01-14: Sesión Única por Usuario** CRITICO MUST

**Código:** RN-C01-14
**Tipo:** RESTRICCIÓN
**Prioridad:** MUST - CRÍTICO
**Sprint:** 1

#### **Descripción**

Cada usuario puede tener **solo UNA sesión activa** a la vez. Si inicia sesión en un nuevo dispositivo/navegador, la sesión anterior se cierra automáticamente.

#### **Restricciones Aplicables**

```yaml
OK OBLIGATORIO:
 - Máximo 1 sesión activa por usuario
 - Cerrar sesión anterior automáticamente
 - Cerrar en django_session Y user_sessions
 - Notificar vía buzón interno (NO email, SIN IP)
 - Auditar cierre de sesión anterior

NO PROHIBIDO:
 - Múltiples sesiones simultáneas
 - NO notificar al usuario
```

#### **Implementación**

Ya implementado en `RN-C01-01: Login con Credenciales Locales` (PASO 2):

```python
# PASO 2: Cerrar sesión previa si existe (sesión única - RN-C01-14)
active_sessions = UserSession.objects.filter(
 user=user,
 is_active=True
)

if active_sessions.exists():
 for session in active_sessions:
 # Cerrar sesión anterior
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'NEW_SESSION'
 session.save()

 # Cerrar en django_session también
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 pass

 # Auditar
 AuditLog.create(
 event_type='SESSION_CLOSED',
 user_id=user.id,
 details={'reason': 'new_session'}
 )

 # Notificar vía buzón interno (NO email, SIN IP)
 InternalMessage.create(
 user_id=user.id,
 subject='Nueva sesión iniciada',
 body='Se ha iniciado una nueva sesión en tu cuenta.\n\n'
 'Tu sesión anterior ha sido cerrada automáticamente.',
 severity='INFO',
 created_by_system=True
 )
```

#### **Reglas Relacionadas**

- **RN-C01-01:** Login
- **RN-C01-12:** Auditoría

---

## STATS RESUMEN Y PRÓXIMOS PASOS

### **Estado de Completitud**

| Categoría | Total | Documentadas | Pendientes | % |
|-----------|-------|--------------|------------|---|
| MUST | 14 | 14 | 0 | 100% |
| SHOULD | 0 | 0 | 0 | N/A |
| COULD | 0 | 0 | 0 | N/A |
| WON'T | 0 | 0 | 0 | N/A |

**OK COMPONENTE 1 COMPLETO - 14/14 reglas documentadas**

### **Próximos Pasos**

1. **Crear Requisitos Funcionales** (RF-005 a RF-010) basados en estas reglas
2. **Crear Tests TDD** para cada requisito funcional
3. **Implementar código** que pase los tests
4. **Validar** contra estas reglas de negocio

---

**Fin del documento - Versión 6.0.0 COMPLETA Y DEFINITIVA**
