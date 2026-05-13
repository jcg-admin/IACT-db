---
id: RF-005
tipo: funcional
titulo: Login con credenciales locales y validación
dominio: backend
owner: equipo-backend
prioridad: critica
estado: pendiente
fecha_creacion: 2025-11-04
modulo: authentication
categoria: security

trazabilidad_upward:
 - RN-C01-01 # Login con Credenciales Locales
 - RN-C01-02 # Validación de Credenciales

trazabilidad_downward:
 - TEST-005 # Tests de login

stakeholders:
 - usuarios-finales
 - administradores-sistema
 - gerentes-seguridad

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-005: Login con Credenciales Locales y Validación

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** permitir a los usuarios autenticarse **únicamente** mediante credenciales locales (username/password) almacenadas en PostgreSQL **validando** las credenciales con bcrypt cost factor 12 **y retornando** tokens JWT (access + refresh) al autenticarse exitosamente **cuando** un usuario envíe sus credenciales al endpoint de login.

### 1.2 Descripción Detallada

**Contexto:**
El sistema necesita un mecanismo de autenticación local robusto que permita a los usuarios acceder al sistema con credenciales almacenadas de forma segura.

**Necesidad:**
Los usuarios necesitan iniciar sesión de forma segura sin depender de sistemas externos (LDAP, OAuth, SAML), cumpliendo con las restricciones críticas del proyecto que prohíben métodos de autenticación externos.

**Comportamiento esperado:**
1. Usuario envía username/password al endpoint POST /api/v1/auth/login
2. Sistema valida las credenciales contra la base de datos PostgreSQL
3. Sistema verifica el hash bcrypt (cost factor 12)
4. Si es válido, genera tokens JWT (access 15min, refresh 7días)
5. Si es inválido, incrementa contador de intentos fallidos
6. Si llega a 3 intentos fallidos, bloquea la cuenta por 15 minutos
7. Cierra sesión anterior si existe (sesión única)
8. Audita el evento de login (exitoso o fallido)

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Login exitoso con credenciales válidas

```gherkin
Given un usuario registrado "juan.perez" con contraseña "SecureP@ss123"
 And el usuario tiene status='ACTIVO'
 And el usuario NO está bloqueado (is_locked=False)
 And la contraseña coincide con el hash bcrypt almacenado
When el usuario envía POST /api/v1/auth/login con:
 | username | juan.perez |
 | password | SecureP@ss123 |
Then el sistema retorna HTTP 200 OK
 And el sistema retorna access_token (válido 15 minutos)
 And el sistema retorna refresh_token (válido 7 días)
 And el sistema retorna token_type: "Bearer"
 And el sistema retorna expires_in: 900 (segundos)
 And el sistema resetea failed_login_attempts a 0
 And el sistema actualiza last_login_at
 And el sistema audita evento LOGIN_SUCCESS
```

#### Escenario 2: Login fallido - credenciales inválidas

```gherkin
Given un usuario registrado "juan.perez"
 And el usuario tiene password_hash válido
When el usuario envía POST /api/v1/auth/login con password incorrecta
Then el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Credenciales inválidas",
 "attempts_remaining": 2
 }
 And el sistema incrementa failed_login_attempts de 0 a 1
 And el sistema NO revela si el username existe
 And el sistema audita evento LOGIN_FAILURE
```

#### Escenario 3: Login fallido - usuario no existe

```gherkin
Given un username "usuario.inexistente" que NO existe en la BD
When el usuario envía POST /api/v1/auth/login con ese username
Then el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna "Credenciales inválidas" (mismo mensaje)
 And el sistema NO revela que el usuario no existe
 And el sistema NO incrementa contador (usuario no existe)
 And el sistema audita evento LOGIN_FAILURE con username (NO user_id)
```

#### Escenario 4: Login fallido - cuenta bloqueada

```gherkin
Given un usuario "bob" con failed_login_attempts=3
 And el usuario tiene is_locked=True
 And el usuario tiene locked_until=<timestamp futuro>
When el usuario envía POST /api/v1/auth/login con credenciales válidas
Then el sistema retorna HTTP 403 Forbidden
 And el sistema retorna:
 {
 "error": "Cuenta bloqueada",
 "locked_until": "2025-11-04T11:15:00Z",
 "minutes_remaining": 14
 }
 And el sistema NO permite login hasta que pase locked_until
 And el sistema NO resetea el contador de intentos
```

#### Escenario 5: Login con usuario inactivo

```gherkin
Given un usuario "alice" con status='INACTIVO'
 And el usuario tiene credenciales válidas
When el usuario envía POST /api/v1/auth/login
Then el sistema retorna HTTP 403 Forbidden
 And el sistema retorna:
 {
 "error": "Usuario inactivo",
 "message": "Contacta al administrador"
 }
 And el sistema NO genera tokens
```

#### Escenario 6: Desbloqueo automático tras 15 minutos

```gherkin
Given un usuario "carol" con is_locked=True
 And el usuario tiene locked_until=<timestamp pasado>
When el usuario envía POST /api/v1/auth/login con credenciales válidas
Then el sistema desbloquea automáticamente la cuenta
 And el sistema establece is_locked=False
 And el sistema resetea failed_login_attempts a 0
 And el sistema establece locked_until=NULL
 And el sistema permite el login exitoso
 And el sistema audita evento USER_UNLOCKED con reason='automatic_timeout'
 And el sistema retorna tokens JWT normalmente
```

#### Escenario 7: Tercer intento fallido - bloqueo automático

```gherkin
Given un usuario "dave" con failed_login_attempts=2
 And el usuario NO está bloqueado aún
When el usuario envía POST /api/v1/auth/login con password incorrecta (3er intento)
Then el sistema incrementa failed_login_attempts a 3
 And el sistema establece is_locked=True
 And el sistema establece locked_until=<now + 15 minutos>
 And el sistema establece lock_reason='MAX_FAILED_ATTEMPTS'
 And el sistema retorna HTTP 403 Forbidden con "Cuenta bloqueada"
 And el sistema audita evento USER_LOCKED
 And el sistema envía notificación a buzón interno (NO email)
```

#### Escenario 8: Cierre de sesión anterior (sesión única)

```gherkin
Given un usuario "eve" con sesión activa en dispositivo A
 And la sesión tiene session_key="abc123" y is_active=True
When el usuario hace login desde dispositivo B
Then el sistema cierra la sesión anterior (dispositivo A)
 And el sistema establece session(abc123).is_active=False
 And el sistema establece session(abc123).logged_out_at=<now>
 And el sistema establece session(abc123).logout_reason='NEW_SESSION'
 And el sistema elimina django_session con session_key="abc123"
 And el sistema audita evento SESSION_CLOSED
 And el sistema envía notificación a buzón interno:
 "Se ha iniciado una nueva sesión en tu cuenta.
 Tu sesión anterior ha sido cerrada automáticamente."
 And el sistema crea nueva sesión para dispositivo B
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Performance** | Tiempo de login | < 500 ms | 95th percentile |
| **Seguridad** | Hash bcrypt | cost factor 12 | Code review |
| **Seguridad** | No revelar existencia de username | Obligatorio | Test |
| **Rate Limiting** | Máximo intentos por IP | 5 requests/5min | Throttling |
| **Disponibilidad** | Disponible 24/7 | 99.9% | Monitoreo mensual |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| LoginView | `api/callcentersite/callcentersite/apps/authentication/views.py` | nuevo |
| AuthenticationService | `api/callcentersite/callcentersite/apps/authentication/services.py` | nuevo |
| User model | `api/callcentersite/callcentersite/apps/users/models.py` | existente |
| UserSession model | `api/callcentersite/callcentersite/apps/users/models.py` | nuevo |
| AuditLog model | `api/callcentersite/callcentersite/apps/audit/models.py` | nuevo |

### 3.2 Interfaces

#### 3.2.1 API REST

**Endpoint:** `POST /api/v1/auth/login`

**Request:**
```json
POST /api/v1/auth/login
Content-Type: application/json

{
 "username": "juan.perez",
 "password": "SecureP@ss123"
}
```

**Response (Éxito - HTTP 200):**
```json
{
 "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
 "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
 "token_type": "Bearer",
 "expires_in": 900
}
```

**Response (Error - HTTP 401):**
```json
{
 "error": "Credenciales inválidas",
 "attempts_remaining": 2
}
```

**Response (Error - HTTP 403 Usuario Bloqueado):**
```json
{
 "error": "Cuenta bloqueada",
 "locked_until": "2025-11-04T11:15:00Z",
 "minutes_remaining": 14
}
```

**Response (Error - HTTP 403 Usuario Inactivo):**
```json
{
 "error": "Usuario inactivo",
 "message": "Contacta al administrador"
}
```

**Response (Error - HTTP 429 Throttling):**
```json
{
 "error": "Demasiados intentos",
 "retry_after": 300
}
```

#### 3.2.2 API Python (Service Layer)

```python
from typing import Dict
from django.contrib.auth import get_user_model

class AuthenticationService:
 @staticmethod
 def login(username: str, password: str, request) -> Dict[str, str]:
 """
 Autenticar usuario con credenciales locales

 Args:
 username: Nombre de usuario o email
 password: Contraseña en texto plano
 request: Request HTTP (para user_agent)

 Returns:
 dict con access_token, refresh_token, token_type, expires_in

 Raises:
 InvalidCredentials: Si credenciales inválidas
 UserInactive: Si usuario no está activo
 UserLocked: Si cuenta está bloqueada
 """
 pass

 @staticmethod
 def validate_credentials(username: str, password: str) -> User:
 """
 Validar credenciales contra base de datos

 Args:
 username: Username o email
 password: Password en texto plano

 Returns:
 User: Usuario si validación exitosa

 Raises:
 InvalidCredentials: Si username no existe o password incorrecto
 UserInactive: Si usuario no está activo
 UserLocked: Si cuenta está bloqueada
 """
 pass
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-RN-C01-01 | Solo autenticación local | PROHIBIDO: LDAP, OAuth, SAML, biométrica |
| BR-RN-C01-02 | Validación con bcrypt | Cost factor 12, salt automático |
| BR-RN-C01-03 | No revelar username | Mismo mensaje para username inexistente o password incorrecta |
| BR-RN-C01-04 | Usuario debe estar activo | status='ACTIVO' obligatorio |
| BR-RN-C01-05 | Usuario NO debe estar bloqueado | is_locked=False obligatorio |
| BR-RN-C01-06 | Resetear contador en login exitoso | failed_login_attempts=0 |
| BR-RN-C01-07 | Incrementar contador en login fallido | +1 en cada fallo |
| BR-RN-C01-08 | Bloquear tras 3 intentos | Automático, 15 minutos |
| BR-RN-C01-09 | Desbloqueo automático | Si locked_until pasó |
| BR-RN-C01-10 | Sesión única | Cerrar sesión anterior automáticamente |
| BR-RN-C01-11 | Auditar todos los eventos | Login exitoso, fallido, bloqueo, desbloqueo |

### 3.4 Validaciones

#### Validaciones de Entrada
- `username` no puede ser vacío
- `username` debe tener entre 3 y 50 caracteres
- `password` no puede ser vacío
- `password` debe tener entre 8 y 100 caracteres

#### Validaciones de Negocio
- Username debe existir en tabla users
- auth_source debe ser 'local'
- deleted_at debe ser NULL
- Password hash debe existir
- Password debe coincidir con hash bcrypt
- Usuario debe tener status='ACTIVO'
- Usuario NO debe estar bloqueado (is_locked=False)
- Si está bloqueado, verificar si locked_until ya pasó

### 3.5 Algoritmo Detallado

```python
def login(username: str, password: str, request) -> dict:
 # PASO 1: Validar credenciales (RN-C01-02)
 try:
 user = validate_credentials(username, password)
 except (InvalidCredentials, UserInactive, UserLocked) as e:
 # Incrementar intentos fallidos
 handle_failed_login(username)
 raise e

 # PASO 2: Cerrar sesión previa si existe (sesión única - RN-C01-14)
 close_previous_sessions(user, request)

 # PASO 3: Crear nueva sesión en PostgreSQL (RN-C01-13)
 session = create_user_session(user, request)

 # PASO 4: Generar tokens JWT (RN-C01-03)
 tokens = generate_jwt_tokens(user)

 # PASO 5: Actualizar datos del usuario
 user.last_login_at = now()
 user.failed_login_attempts = 0
 user.last_failed_login_at = None
 user.save()

 # PASO 6: Auditar login exitoso (RN-C01-12)
 audit_login_success(user, request, session)

 # PASO 7: Retornar tokens
 return {
 'access_token': tokens['access'],
 'refresh_token': tokens['refresh'],
 'token_type': 'Bearer',
 'expires_in': 900
 }
```

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- User model debe existir
- bcrypt library instalada
- djangorestframework-simplejwt instalada
- PostgreSQL configurado como SESSION_ENGINE
- SECRET_KEY configurado en settings

### 4.2 Requisitos Relacionados

- **RF-006:** Generación y Validación de Tokens JWT
- **RF-009:** Gestión de Intentos Fallidos y Bloqueo
- **RF-010:** Sesión Única por Usuario

### 4.3 Restricciones del Proyecto

Del documento `restricciones_y_lineamientos.md`:

- **RESTR-001:** NO email - notificaciones solo por buzón interno
- **RESTR-003:** Sesiones en PostgreSQL (NO Redis)
- **RESTR-006:** JWT + Permissions - autenticación robusta
- **RESTR-010:** Eliminación lógica - NO borrar usuarios físicamente

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-005-001:** test_login_exitoso_con_credenciales_validas
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-002:** test_login_fallido_credenciales_invalidas
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-003:** test_login_fallido_usuario_inexistente
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-004:** test_login_fallido_cuenta_bloqueada
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-005:** test_login_fallido_usuario_inactivo
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-006:** test_desbloqueo_automatico_tras_15_minutos
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-007:** test_bloqueo_automatico_tercer_intento
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-008:** test_cierre_sesion_anterior_sesion_unica
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-009:** test_resetea_contador_intentos_en_login_exitoso
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-010:** test_no_revela_existencia_username
 - Ubicación: `tests/authentication/test_login.py`
 - Estado: pendiente

- [ ] **TEST-005-011:** test_performance_login_menor_500ms
 - Ubicación: `tests/authentication/test_login_performance.py`
 - Estado: pendiente

### 5.2 Tests de Integración

- [ ] **TEST-005-INT-001:** test_flujo_completo_login_con_auditoria
- [ ] **TEST-005-INT-002:** test_login_con_cierre_sesion_previa_y_notificacion

### 5.3 Tests de Seguridad

- [ ] **TEST-005-SEC-001:** test_bcrypt_cost_factor_es_12
- [ ] **TEST-005-SEC-002:** test_no_revela_informacion_sensible
- [ ] **TEST-005-SEC-003:** test_rate_limiting_5_por_5min

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado
- [ ] 11 tests unitarios implementados y pasando
- [ ] Tests de integración implementados y pasando
- [ ] Tests de seguridad implementados y pasando
- [ ] Coverage >= 95% para AuthenticationService.login
- [ ] Documentación técnica actualizada (este documento)
- [ ] Performance verificado (< 500ms por login)
- [ ] Rate limiting configurado y testeado
- [ ] Auditoría verificada para todos los eventos

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de las reglas de negocio:
- **RN-C01-01:** Login con Credenciales Locales
- **RN-C01-02:** Validación de Credenciales

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|--------|-----------|
| Test | TEST-005 | Tests de login | `tests/authentication/test_login.py` |
| Código | IMPL-005 | AuthenticationService | `apps/authentication/services.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Reglas de negocio: `docs/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`
- Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### 8.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018:** Clause 9.6 - Software Requirements Specification
- **OWASP ASVS:** Authentication Verification Requirements
- **NIST SP 800-63B:** Digital Identity Guidelines - Authentication

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial basada en RN-C01-01 y RN-C01-02 |
