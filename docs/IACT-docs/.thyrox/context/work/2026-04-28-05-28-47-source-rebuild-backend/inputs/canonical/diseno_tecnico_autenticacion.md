---
title: Diseño Técnico: Sistema de Autenticación y Sesiones
date: 2025-11-13
domain: backend
status: active
---

# Diseño Técnico: Sistema de Autenticación y Sesiones

**Versión:** 1.0
**Fecha:** 2025-11-04
**Componente:** Autenticación y Sesiones (Componente 1)
**Estado:** En Diseño

---

## NOTA Tabla de Contenidos

1. [Arquitectura General](#1-arquitectura-general)
2. [Diagramas de Secuencia](#2-diagramas-de-secuencia)
3. [Diagramas de Flujo](#3-diagramas-de-flujo)
4. [Diagramas de Estados](#4-diagramas-de-estados)
5. [Modelo de Datos](#5-modelo-de-datos)
6. [Arquitectura de Componentes](#6-arquitectura-de-componentes)

---

## 1. Arquitectura General

### 1.1 Vista de Alto Nivel

```mermaid
graph TB
 subgraph "Frontend"
 UI[Usuario / Interfaz Web]
 end

 subgraph "API Gateway"
 NGINX[NGINX Reverse Proxy]
 end

 subgraph "Backend - Django/DRF"
 subgraph "Authentication Module"
 LoginView[LoginView]
 LogoutView[LogoutView]
 RefreshView[RefreshTokenView]
 AuthService[AuthenticationService]
 TokenService[TokenService]
 PasswordService[PasswordService]
 end

 subgraph "Middleware"
 JWTAuth[JWT Authentication]
 Permissions[Permission Checker]
 RateLimit[Rate Limiting]
 end

 subgraph "Background Jobs"
 Scheduler[APScheduler]
 InactivityJob[Close Inactive Sessions Job]
 end

 subgraph "Models"
 User[User Model]
 UserSession[UserSession Model]
 PasswordHistory[PasswordHistory Model]
 AuditLog[AuditLog Model]
 end
 end

 subgraph "Database - PostgreSQL"
 DB[(PostgreSQL)]
 Tables[("
 - users
 - user_sessions
 - django_session
 - password_history
 - audit_logs
 - token_blacklist
 ")]
 end

 subgraph "Notifications"
 InternalMsg[Internal Message System]
 end

 UI -->|HTTPS| NGINX
 NGINX --> LoginView
 NGINX --> LogoutView
 NGINX --> RefreshView

 LoginView --> AuthService
 LogoutView --> AuthService
 RefreshView --> TokenService

 AuthService --> PasswordService
 AuthService --> TokenService
 AuthService --> User
 AuthService --> UserSession

 JWTAuth --> TokenService
 JWTAuth --> User

 Scheduler --> InactivityJob
 InactivityJob --> UserSession
 InactivityJob --> InternalMsg

 User --> DB
 UserSession --> DB
 PasswordHistory --> DB
 AuditLog --> DB

 AuthService -.->|Notificar| InternalMsg
 TokenService --> DB

 style LoginView fill:#90EE90
 style LogoutView fill:#90EE90
 style RefreshView fill:#90EE90
 style DB fill:#4682B4
 style InternalMsg fill:#FFD700
```

### 1.2 Capas de la Aplicación

```mermaid
graph LR
 subgraph "Capa de Presentación"
 A[API Views<br/>LoginView<br/>LogoutView<br/>RefreshView]
 end

 subgraph "Capa de Servicio"
 B[Services<br/>AuthenticationService<br/>TokenService<br/>PasswordService]
 end

 subgraph "Capa de Dominio"
 C[Models<br/>User<br/>UserSession<br/>PasswordHistory]
 end

 subgraph "Capa de Persistencia"
 D[Django ORM<br/>PostgreSQL]
 end

 A --> B
 B --> C
 C --> D

 style A fill:#E6F3FF
 style B fill:#FFE6E6
 style C fill:#E6FFE6
 style D fill:#FFFFE6
```

---

## 2. Diagramas de Secuencia

### 2.1 RF-005: Login con Credenciales Locales

```mermaid
sequenceDiagram
 actor U as Usuario
 participant V as LoginView
 participant AS as AuthenticationService
 participant PS as PasswordService
 participant TS as TokenService
 participant UM as User Model
 participant SM as UserSession Model
 participant A as AuditLog
 participant N as InternalMessage
 participant DB as PostgreSQL

 U->>V: POST /api/v1/auth/login<br/>{username, password}

 activate V
 V->>AS: login(username, password, request)
 activate AS

 Note over AS: PASO 1: Validar credenciales
 AS->>UM: get(username=username)
 UM->>DB: SELECT * FROM users WHERE...
 DB-->>UM: user data
 UM-->>AS: user

 AS->>PS: verify_password(password, user.password_hash)
 activate PS
 PS->>PS: bcrypt.checkpw()
 PS-->>AS: True/False
 deactivate PS

 alt Credenciales inválidas
 AS->>AS: handle_failed_login(username)
 AS->>UM: user.failed_login_attempts += 1
 UM->>DB: UPDATE users SET failed_login_attempts...

 alt 3 intentos fallidos
 AS->>UM: user.is_locked = True<br/>locked_until = now() + 15min
 UM->>DB: UPDATE users SET is_locked...
 AS->>A: create(event='USER_LOCKED')
 A->>DB: INSERT INTO audit_logs...
 AS->>N: create(subject='Cuenta bloqueada')
 N->>DB: INSERT INTO internal_messages...
 end

 AS-->>V: raise InvalidCredentials
 V-->>U: 401 Unauthorized
 else Credenciales válidas

 Note over AS: PASO 2: Cerrar sesión previa (sesión única)
 AS->>SM: filter(user=user, is_active=True)
 SM->>DB: SELECT * FROM user_sessions WHERE...
 DB-->>SM: active sessions
 SM-->>AS: sessions

 loop Para cada sesión activa
 AS->>SM: session.is_active = False<br/>logout_reason = 'NEW_SESSION'
 SM->>DB: UPDATE user_sessions SET...
 AS->>DB: DELETE FROM django_session...
 AS->>A: create(event='SESSION_CLOSED')
 A->>DB: INSERT INTO audit_logs...
 end

 AS->>N: create(subject='Nueva sesión iniciada')
 N->>DB: INSERT INTO internal_messages...

 Note over AS: PASO 3: Crear nueva sesión
 AS->>SM: create(user=user, session_key=...)
 SM->>DB: INSERT INTO user_sessions...
 DB-->>SM: session
 SM-->>AS: session

 Note over AS: PASO 4: Generar tokens JWT
 AS->>TS: generate_jwt_tokens(user)
 activate TS
 TS->>TS: RefreshToken.for_user(user)
 TS->>TS: Agregar claims personalizados
 TS->>DB: INSERT INTO token_blacklist_outstandingtoken...
 TS-->>AS: {access_token, refresh_token}
 deactivate TS

 Note over AS: PASO 5: Actualizar usuario
 AS->>UM: user.last_login_at = now()<br/>failed_login_attempts = 0
 UM->>DB: UPDATE users SET...

 Note over AS: PASO 6: Auditar login
 AS->>A: create(event='LOGIN_SUCCESS')
 A->>DB: INSERT INTO audit_logs...

 AS-->>V: {access_token, refresh_token, expires_in}
 deactivate AS
 V-->>U: 200 OK + tokens
 deactivate V
 end
```

### 2.2 RF-006: Validación de Access Token

```mermaid
sequenceDiagram
 actor U as Usuario
 participant EP as Protected Endpoint
 participant JA as JWTAuthentication
 participant TS as TokenService
 participant UM as User Model
 participant SM as UserSession Model
 participant DB as PostgreSQL

 U->>EP: GET /api/v1/protected<br/>Authorization: Bearer <token>

 activate EP
 EP->>JA: authenticate(request)
 activate JA

 JA->>JA: Extraer token del header

 JA->>TS: validate_access_token(token)
 activate TS

 Note over TS: Validar firma con SECRET_KEY
 TS->>TS: jwt.decode(token, SECRET_KEY)

 alt Token expirado
 TS-->>JA: raise TokenExpired
 JA-->>EP: 401 Unauthorized
 EP-->>U: 401 Token expirado
 else Firma inválida
 TS-->>JA: raise InvalidToken
 JA-->>EP: 401 Unauthorized
 EP-->>U: 401 Token inválido
 else Token válido
 Note over TS: Verificar tipo de token
 TS->>TS: Check payload['token_type'] == 'access'

 alt Tipo incorrecto
 TS-->>JA: raise InvalidToken
 JA-->>EP: 401 Unauthorized
 EP-->>U: 401 Debe usar access token
 else Tipo correcto
 Note over TS: Obtener usuario
 TS->>UM: get(id=payload['user_id'])
 UM->>DB: SELECT * FROM users WHERE id=...
 DB-->>UM: user data
 UM-->>TS: user

 Note over TS: Validar estado del usuario
 alt Usuario inactivo
 TS-->>JA: raise UserInactive
 JA-->>EP: 403 Forbidden
 EP-->>U: 403 Usuario inactivo
 else Usuario bloqueado
 TS-->>JA: raise UserLocked
 JA-->>EP: 403 Forbidden
 EP-->>U: 403 Usuario bloqueado
 else Usuario activo
 Note over TS: Actualizar actividad
 TS->>SM: update(last_activity_at=now())
 SM->>DB: UPDATE user_sessions SET...

 TS-->>JA: user
 deactivate TS
 JA-->>EP: user
 deactivate JA

 EP->>EP: Procesar request
 EP-->>U: 200 OK + data
 deactivate EP
 end
 end
 end
```

### 2.3 RF-006: Refresh de Access Token

```mermaid
sequenceDiagram
 actor U as Usuario
 participant RV as RefreshTokenView
 participant TS as TokenService
 participant BL as Blacklist
 participant DB as PostgreSQL

 U->>RV: POST /api/v1/auth/refresh<br/>{refresh: "token..."}

 activate RV
 RV->>TS: refresh_access_token(refresh_token)
 activate TS

 Note over TS: Validar refresh token
 TS->>TS: RefreshToken(refresh_token_str)

 TS->>BL: Check if blacklisted
 BL->>DB: SELECT * FROM token_blacklist_blacklistedtoken...

 alt Token blacklisted
 DB-->>BL: Token found
 BL-->>TS: Token blacklisted
 TS-->>RV: raise TokenError
 RV-->>U: 401 Token ya usado
 else Token expirado
 TS->>TS: Check expiration
 TS-->>RV: raise TokenError
 RV-->>U: 401 Token expirado
 else Token válido
 DB-->>BL: Not found
 BL-->>TS: Token valid

 Note over TS: Generar nuevo access token
 TS->>TS: new_access = refresh.access_token

 Note over TS: Rotar refresh token
 TS->>TS: refresh.set_jti() (nuevo JTI)
 TS->>TS: refresh.set_exp() (nueva expiración)

 Note over TS: Blacklist token viejo
 TS->>BL: refresh.blacklist()
 BL->>DB: INSERT INTO token_blacklist_blacklistedtoken...

 Note over TS: Registrar nuevo token
 TS->>DB: INSERT INTO token_blacklist_outstandingtoken...

 TS-->>RV: {access: new_token, refresh: new_refresh}
 deactivate TS
 RV-->>U: 200 OK + new tokens
 deactivate RV
 end
```

### 2.4 RF-007: Logout Manual

```mermaid
sequenceDiagram
 actor U as Usuario
 participant LV as LogoutView
 participant AS as AuthenticationService
 participant BL as Blacklist
 participant SM as UserSession Model
 participant A as AuditLog
 participant DB as PostgreSQL

 U->>LV: POST /api/v1/auth/logout<br/>{refresh_token: "..."}

 activate LV
 LV->>AS: logout(user, refresh_token, request)
 activate AS

 Note over AS: PASO 1: Blacklist refresh token
 AS->>BL: blacklist(refresh_token)
 activate BL

 alt Token ya blacklisted
 BL->>DB: SELECT * FROM token_blacklist...
 DB-->>BL: Token found
 Note over BL: Operación idempotente - no fallar
 else Token válido
 BL->>DB: INSERT INTO token_blacklist_blacklistedtoken...
 end
 deactivate BL

 Note over AS: PASO 2: Cerrar sesiones activas
 AS->>SM: filter(user=user, is_active=True)
 SM->>DB: SELECT * FROM user_sessions WHERE...
 DB-->>SM: active sessions
 SM-->>AS: sessions

 loop Para cada sesión activa
 AS->>SM: session.is_active = False<br/>logout_reason = 'MANUAL'
 SM->>DB: UPDATE user_sessions SET...
 AS->>DB: DELETE FROM django_session WHERE...
 end

 Note over AS: PASO 3: Auditar logout
 AS->>A: create(event='LOGOUT_SUCCESS')
 A->>DB: INSERT INTO audit_logs...

 AS-->>LV: Success
 deactivate AS
 LV-->>U: 200 OK
 deactivate LV
```

### 2.5 RF-008: Cierre Automático por Inactividad

```mermaid
sequenceDiagram
 participant S as APScheduler
 participant J as InactivityJob
 participant SM as UserSession Model
 participant A as AuditLog
 participant N as InternalMessage
 participant DB as PostgreSQL

 Note over S: Cada 5 minutos
 S->>J: Ejecutar close_inactive_sessions()
 activate J

 Note over J: Calcular límite de timeout
 J->>J: timeout_limit = now() - 30 minutos

 J->>SM: filter(is_active=True, last_activity_at < limit)
 SM->>DB: SELECT * FROM user_sessions WHERE...
 DB-->>SM: inactive sessions
 SM-->>J: sessions

 loop Para cada sesión inactiva
 Note over J: Cerrar sesión
 J->>SM: session.is_active = False<br/>logout_reason = 'INACTIVITY_TIMEOUT'
 SM->>DB: UPDATE user_sessions SET...

 J->>DB: DELETE FROM django_session WHERE...

 Note over J: Auditar cierre
 J->>A: create(event='SESSION_TIMEOUT')
 A->>DB: INSERT INTO audit_logs...

 Note over J: Notificar usuario
 J->>N: create(subject='Sesión cerrada por inactividad')
 N->>DB: INSERT INTO internal_messages...
 end

 J-->>S: {closed_sessions: count}
 deactivate J
```

### 2.6 RF-009: Gestión de Intentos Fallidos y Bloqueo

```mermaid
sequenceDiagram
 actor U as Usuario
 participant V as LoginView
 participant AS as AuthenticationService
 participant UM as User Model
 participant A as AuditLog
 participant N as InternalMessage
 participant DB as PostgreSQL

 U->>V: POST /api/v1/auth/login<br/>{username, password incorrecta}

 activate V
 V->>AS: login(username, password, request)
 activate AS

 AS->>AS: validate_credentials()

 Note over AS: Password incorrecta
 AS->>AS: handle_failed_login(username)
 activate AS

 AS->>UM: get(username=username)
 UM->>DB: SELECT * FROM users WHERE...
 DB-->>UM: user
 UM-->>AS: user

 AS->>UM: user.failed_login_attempts += 1
 AS->>UM: user.last_failed_login_at = now()

 alt Intento 1 o 2
 UM->>DB: UPDATE users SET failed_login_attempts...
 AS-->>AS: Continue
 else Intento 3 (bloqueo)
 AS->>UM: user.is_locked = True
 AS->>UM: user.locked_until = now() + 15min
 AS->>UM: user.lock_reason = 'MAX_FAILED_ATTEMPTS'
 UM->>DB: UPDATE users SET is_locked=TRUE...

 Note over AS: Notificar usuario
 AS->>N: create(subject='Cuenta bloqueada')
 N->>DB: INSERT INTO internal_messages...

 Note over AS: Auditar bloqueo
 AS->>A: create(event='USER_LOCKED')
 A->>DB: INSERT INTO audit_logs...
 end

 deactivate AS

 AS-->>V: raise InvalidCredentials
 deactivate AS

 alt Usuario bloqueado
 V-->>U: 403 Forbidden<br/>{"error": "Cuenta bloqueada"}
 else Aún no bloqueado
 V-->>U: 401 Unauthorized<br/>{"attempts_remaining": 2}
 end
 deactivate V
```

---

## 3. Diagramas de Flujo

### 3.1 Flujo de Decisión: Login

```mermaid
flowchart TD
 Start([Usuario envía credenciales]) --> A{Username<br/>existe?}

 A -->|No| B[Retornar error genérico<br/>'Credenciales inválidas']
 A -->|Sí| C{Usuario<br/>bloqueado?}

 C -->|Sí| D{Tiempo de<br/>bloqueo pasó?}
 D -->|No| E[Retornar 403<br/>'Cuenta bloqueada']
 D -->|Sí| F[Desbloquear automáticamente<br/>Resetear contador]

 C -->|No| G{Usuario<br/>activo?}
 F --> G

 G -->|No| H[Retornar 403<br/>'Usuario inactivo']
 G -->|Sí| I{Password<br/>correcto?}

 I -->|No| J[Incrementar contador<br/>failed_login_attempts]
 J --> K{Contador<br/>== 3?}
 K -->|Sí| L[Bloquear cuenta<br/>15 minutos]
 L --> M[Auditar USER_LOCKED<br/>Notificar usuario]
 M --> B
 K -->|No| B

 I -->|Sí| N[Resetear contador a 0]
 N --> O{Sesión<br/>activa previa?}

 O -->|Sí| P[Cerrar sesión anterior<br/>Notificar usuario]
 O -->|No| Q[Continuar]
 P --> Q

 Q --> R[Crear nueva sesión<br/>en PostgreSQL]
 R --> S[Generar tokens JWT<br/>Access: 15min<br/>Refresh: 7 días]
 S --> T[Actualizar last_login_at]
 T --> U[Auditar LOGIN_SUCCESS]
 U --> End([Retornar 200 OK<br/>+ tokens])

 style Start fill:#90EE90
 style End fill:#90EE90
 style B fill:#FFB6C1
 style E fill:#FFB6C1
 style H fill:#FFB6C1
```

### 3.2 Flujo de Decisión: Validación de Token

```mermaid
flowchart TD
 Start([Request con token]) --> A{Header<br/>Authorization<br/>presente?}

 A -->|No| B[Retornar 401<br/>'Authentication required']
 A -->|Sí| C{Formato<br/>Bearer token?}

 C -->|No| D[Retornar 401<br/>'Invalid header format']
 C -->|Sí| E[Extraer token]

 E --> F{Firma<br/>válida?}
 F -->|No| G[Retornar 401<br/>'Invalid signature']

 F -->|Sí| H{Token<br/>expirado?}
 H -->|Sí| I[Retornar 401<br/>'Token expired']

 H -->|No| J{Tipo =<br/>'access'?}
 J -->|No| K[Retornar 401<br/>'Must use access token']

 J -->|Sí| L[Obtener user_id<br/>del payload]
 L --> M{Usuario<br/>existe?}

 M -->|No| N[Retornar 401<br/>'User not found']
 M -->|Sí| O{Usuario<br/>activo?}

 O -->|No| P[Retornar 403<br/>'User inactive']
 O -->|Sí| Q{Usuario<br/>bloqueado?}

 Q -->|Sí| R[Retornar 403<br/>'User locked']
 Q -->|No| S[Actualizar last_activity_at]

 S --> End([Permitir acceso<br/>Request procesado])

 style Start fill:#90EE90
 style End fill:#90EE90
 style B fill:#FFB6C1
 style D fill:#FFB6C1
 style G fill:#FFB6C1
 style I fill:#FFB6C1
 style K fill:#FFB6C1
 style N fill:#FFB6C1
 style P fill:#FFB6C1
 style R fill:#FFB6C1
```

### 3.3 Flujo de Decisión: Refresh Token

```mermaid
flowchart TD
 Start([Request refresh token]) --> A{Refresh token<br/>presente?}

 A -->|No| B[Retornar 400<br/>'Token required']
 A -->|Sí| C{Firma<br/>válida?}

 C -->|No| D[Retornar 401<br/>'Invalid signature']
 C -->|Sí| E{Token<br/>expirado?}

 E -->|Sí| F[Retornar 401<br/>'Token expired<br/>Login required']

 E -->|No| G{Token en<br/>blacklist?}

 G -->|Sí| H[Retornar 401<br/>'Token already used']
 G -->|No| I[Generar nuevo<br/>access token]

 I --> J[Generar nuevo<br/>refresh token]
 J --> K[Blacklist<br/>refresh token viejo]
 K --> L[Registrar nuevo<br/>outstanding token]

 L --> End([Retornar 200 OK<br/>+ nuevos tokens])

 style Start fill:#90EE90
 style End fill:#90EE90
 style B fill:#FFB6C1
 style D fill:#FFB6C1
 style F fill:#FFB6C1
 style H fill:#FFB6C1
```

### 3.4 Flujo de Decisión: Validación de Complejidad de Password

```mermaid
flowchart TD
 Start([Nueva password]) --> A{Longitud<br/>8-100?}

 A -->|No| Err1[Error: Longitud inválida]
 A -->|Sí| B{Contiene<br/>mayúscula?}

 B -->|No| Err2[Error: Requiere mayúscula]
 B -->|Sí| C{Contiene<br/>minúscula?}

 C -->|No| Err3[Error: Requiere minúscula]
 C -->|Sí| D{Contiene<br/>dígito?}

 D -->|No| Err4[Error: Requiere dígito]
 D -->|Sí| E{Contiene<br/>especial?}

 E -->|No| Err5[Error: Requiere carácter especial]
 E -->|Sí| F{Contiene<br/>username?}

 F -->|Sí| Err6[Error: No puede contener username]
 F -->|No| G{Contiene<br/>nombre/apellido?}

 G -->|Sí| Err7[Error: No puede contener nombre]
 G -->|No| H[Obtener últimas<br/>5 passwords del historial]

 H --> I{Coincide con<br/>alguna previa?}

 I -->|Sí| Err8[Error: No reutilizar últimas 5]
 I -->|No| J[Password válida]

 J --> K[Hash con bcrypt<br/>cost factor 12]
 K --> L[Guardar hash actual<br/>en historial]
 L --> M[Actualizar password_hash<br/>del usuario]

 M --> End([Password actualizada])

 Err1 --> ErrEnd([Retornar ValidationError])
 Err2 --> ErrEnd
 Err3 --> ErrEnd
 Err4 --> ErrEnd
 Err5 --> ErrEnd
 Err6 --> ErrEnd
 Err7 --> ErrEnd
 Err8 --> ErrEnd

 style Start fill:#90EE90
 style End fill:#90EE90
 style J fill:#90EE90
 style ErrEnd fill:#FFB6C1
```

---

## 4. Diagramas de Estados

### 4.1 Estados de Usuario

```mermaid
stateDiagram-v2
 [*] --> PendienteConfiguracion: Usuario creado

 PendienteConfiguracion --> Activo: Configuración completada

 Activo --> Bloqueado: 3 intentos fallidos
 Activo --> Inactivo: Admin desactiva

 Bloqueado --> Activo: Tiempo expirado (15 min)<br/>O desbloqueo manual

 Inactivo --> Activo: Admin reactiva

 Activo --> Eliminado: Eliminación lógica
 Bloqueado --> Eliminado: Eliminación lógica
 Inactivo --> Eliminado: Eliminación lógica

 Eliminado --> [*]

 note right of Activo
 Estado normal
 - Puede hacer login
 - Puede usar el sistema
 - failed_login_attempts < 3
 end note

 note right of Bloqueado
 Bloqueado temporalmente
 - NO puede hacer login
 - is_locked = True
 - locked_until definido
 - Duración: 15 minutos exactos
 end note

 note right of Inactivo
 Usuario desactivado
 - NO puede hacer login
 - status = 'INACTIVO'
 - Requiere intervención admin
 end note
```

### 4.2 Estados de Sesión

```mermaid
stateDiagram-v2
 [*] --> Activa: Login exitoso

 Activa --> Cerrada_Manual: Usuario hace logout
 Activa --> Cerrada_Inactividad: 30 min sin actividad
 Activa --> Cerrada_NuevaSesion: Nuevo login del mismo user
 Activa --> Cerrada_TokenExpirado: Access + Refresh expirados

 Cerrada_Manual --> [*]
 Cerrada_Inactividad --> [*]
 Cerrada_NuevaSesion --> [*]
 Cerrada_TokenExpirado --> [*]

 note right of Activa
 Sesión activa
 - is_active = True
 - last_activity_at actualizado
 - Access token válido
 - Refresh token válido
 end note

 note right of Cerrada_Manual
 logout_reason = 'MANUAL'
 - Refresh token blacklisted
 - django_session eliminado
 end note

 note right of Cerrada_Inactividad
 logout_reason = 'INACTIVITY_TIMEOUT'
 - last_activity_at > 30 min
 - Cerrado por job programado
 end note

 note right of Cerrada_NuevaSesion
 logout_reason = 'NEW_SESSION'
 - Usuario hizo login en otro dispositivo
 - Sesión única por usuario
 end note
```

### 4.3 Estados de Refresh Token

```mermaid
stateDiagram-v2
 [*] --> Outstanding: Token generado en login

 Outstanding --> Usado: Token usado para refresh
 Outstanding --> Blacklisted_Logout: Usuario hace logout
 Outstanding --> Expirado: 7 días transcurridos

 Usado --> Blacklisted_Rotacion: Rotación automática

 Blacklisted_Logout --> [*]
 Blacklisted_Rotacion --> [*]
 Expirado --> [*]

 note right of Outstanding
 Token activo y válido
 - Registrado en outstandingtoken
 - NO en blacklist
 - exp > now()
 - Puede usarse para refresh
 end note

 note right of Blacklisted_Rotacion
 Token invalidado por uso
 - ROTATE_REFRESH_TOKENS = True
 - NO puede reutilizarse
 - Nuevo token generado
 end note

 note right of Blacklisted_Logout
 Token invalidado por logout
 - Logout manual del usuario
 - NO puede reutilizarse
 end note
```

### 4.4 Ciclo de Vida de Password

```mermaid
stateDiagram-v2
 [*] --> NuevaPassword: Usuario crea/cambia password

 NuevaPassword --> Validando: Validar complejidad

 Validando --> Rechazada: No cumple requisitos
 Validando --> ValidandoHistorial: Cumple requisitos

 Rechazada --> [*]: ValidationError

 ValidandoHistorial --> Rechazada2: Coincide con últimas 5
 ValidandoHistorial --> Hasheando: No coincide

 Rechazada2 --> [*]: ValidationError

 Hasheando --> GuardandoHistorial: bcrypt cost 12
 GuardandoHistorial --> Activa: Hash guardado

 Activa --> Expirada: 90 días (futuro)
 Activa --> Cambiada: Usuario cambia password

 Expirada --> [*]
 Cambiada --> [*]

 note right of Validando
 Verificar:
 - Longitud 8-100
 - Mayúscula, minúscula
 - Dígito, especial
 - No contiene username
 end note

 note right of ValidandoHistorial
 Comparar con últimas 5:
 - bcrypt.checkpw() contra historial
 - Prevenir reutilización
 end note

 note right of Activa
 Password actual del usuario
 - Almacenada como hash bcrypt
 - Cost factor 12
 - Salt único
 end note
```

---

## 5. Modelo de Datos

### 5.1 Diagrama Entidad-Relación (ER)

```mermaid
erDiagram
 USER ||--o{ USER_SESSION : "tiene"
 USER ||--o{ PASSWORD_HISTORY : "tiene"
 USER ||--o{ AUDIT_LOG : "genera"
 USER ||--o{ INTERNAL_MESSAGE : "recibe"
 USER ||--o{ OUTSTANDING_TOKEN : "posee"
 OUTSTANDING_TOKEN ||--o| BLACKLISTED_TOKEN : "puede estar en"

 USER {
 int user_id PK
 string username UK
 string email UK
 string password_hash
 datetime password_changed_at
 string status
 string segment
 int failed_login_attempts
 datetime last_failed_login_at
 boolean is_locked
 datetime locked_until
 string lock_reason
 datetime last_login_at
 datetime created_at
 datetime updated_at
 datetime deleted_at
 }

 USER_SESSION {
 int session_id PK
 int user_id FK
 string session_key UK
 string user_agent
 boolean is_active
 datetime created_at
 datetime last_activity_at
 datetime logged_out_at
 string logout_reason
 }

 PASSWORD_HISTORY {
 int id PK
 int user_id FK
 string password_hash
 datetime created_at
 }

 AUDIT_LOG {
 int id PK
 string event_type
 int user_id FK "nullable"
 int performed_by FK "nullable"
 string user_agent
 json details
 string result
 datetime created_at
 }

 INTERNAL_MESSAGE {
 int id PK
 int user_id FK
 string subject
 text body
 string severity
 boolean read
 boolean created_by_system
 datetime created_at
 }

 OUTSTANDING_TOKEN {
 int id PK
 int user_id FK
 string jti UK
 text token
 datetime created_at
 datetime expires_at
 }

 BLACKLISTED_TOKEN {
 int id PK
 int token_id FK UK
 datetime blacklisted_at
 }
```

### 5.2 Índices y Constraints

```sql
-- USER
CREATE UNIQUE INDEX idx_users_username ON users(username) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_is_locked ON users(is_locked);

-- USER_SESSION
CREATE UNIQUE INDEX idx_user_sessions_session_key ON user_sessions(session_key);
CREATE INDEX idx_user_sessions_user_active ON user_sessions(user_id, is_active);
CREATE INDEX idx_user_sessions_last_activity ON user_sessions(last_activity_at)
 WHERE is_active = TRUE;

-- PASSWORD_HISTORY
CREATE INDEX idx_password_history_user_created ON password_history(user_id, created_at DESC);

-- AUDIT_LOG
CREATE INDEX idx_audit_logs_event_type ON audit_logs(event_type);
CREATE INDEX idx_audit_logs_user_created ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);

-- OUTSTANDING_TOKEN
CREATE UNIQUE INDEX idx_outstanding_token_jti ON token_blacklist_outstandingtoken(jti);
CREATE INDEX idx_outstanding_token_user ON token_blacklist_outstandingtoken(user_id);
CREATE INDEX idx_outstanding_token_expires ON token_blacklist_outstandingtoken(expires_at);

-- BLACKLISTED_TOKEN
CREATE UNIQUE INDEX idx_blacklisted_token_token_id
 ON token_blacklist_blacklistedtoken(token_id);
```

---

## 6. Arquitectura de Componentes

### 6.1 Estructura de Módulos

```mermaid
graph TB
 subgraph "apps/authentication"
 A1[views.py<br/>- LoginView<br/>- LogoutView<br/>- RefreshTokenView]
 A2[services.py<br/>- AuthenticationService<br/>- TokenService<br/>- PasswordService]
 A3[validators.py<br/>- validate_password_complexity<br/>- validate_password_history]
 A4[authentication.py<br/>- JWTAuthentication<br/>- CustomPermission]
 A5[jobs.py<br/>- close_inactive_sessions<br/>- cleanup_expired_tokens]
 A6[serializers.py<br/>- LoginSerializer<br/>- TokenSerializer]
 end

 subgraph "apps/users"
 U1[models.py<br/>- User<br/>- UserSession<br/>- PasswordHistory]
 U2[managers.py<br/>- UserManager<br/>- SessionManager]
 end

 subgraph "apps/audit"
 AU1[models.py<br/>- AuditLog]
 AU2[services.py<br/>- AuditService]
 end

 subgraph "apps/notifications"
 N1[models.py<br/>- InternalMessage]
 N2[services.py<br/>- NotificationService]
 end

 A1 --> A2
 A1 --> A6
 A2 --> A3
 A2 --> A4
 A2 --> U1
 A2 --> AU2
 A2 --> N2
 A5 --> U1
 A5 --> AU2
 A5 --> N2

 U1 --> U2
 AU1 --> AU2
 N1 --> N2

 style A1 fill:#FFE6E6
 style A2 fill:#E6FFE6
 style U1 fill:#E6F3FF
 style AU1 fill:#FFF9E6
 style N1 fill:#F0E6FF
```

### 6.2 Dependencias entre Módulos

```mermaid
graph LR
 AUTH[authentication]
 USERS[users]
 AUDIT[audit]
 NOTIF[notifications]
 JWT[rest_framework_simplejwt]
 SCHED[apscheduler]

 AUTH -->|usa| USERS
 AUTH -->|usa| AUDIT
 AUTH -->|usa| NOTIF
 AUTH -->|usa| JWT
 AUTH -->|usa| SCHED

 USERS -.->|no depende| AUTH
 AUDIT -.->|no depende| AUTH
 NOTIF -.->|no depende| AUTH

 style AUTH fill:#FFE6E6
 style USERS fill:#E6FFE6
 style AUDIT fill:#FFF9E6
 style NOTIF fill:#F0E6FF
 style JWT fill:#E6F3FF
 style SCHED fill:#E6F3FF
```

### 6.3 Capa de Servicios (Services Layer)

```mermaid
classDiagram
 class AuthenticationService {
 +login(username, password, request) dict
 +logout(user, refresh_token, request) None
 +validate_credentials(username, password) User
 -handle_failed_login(username) None
 -close_previous_sessions(user, request) int
 -create_user_session(user, request) UserSession
 }

 class TokenService {
 +generate_jwt_tokens(user) dict
 +validate_access_token(request) User
 +refresh_access_token(refresh_token) dict
 -decode_token(token) dict
 -verify_token_signature(token) bool
 }

 class PasswordService {
 +hash_password(password) str
 +verify_password(password, hash) bool
 +validate_password_complexity(password, user) None
 +validate_password_history(user, password) None
 +set_user_password(user, password) None
 }

 class AuditService {
 +create(event_type, user_id, details) AuditLog
 +log_login_success(user, request) None
 +log_login_failure(username, request) None
 +log_user_locked(user) None
 +log_session_closed(user, reason) None
 }

 class NotificationService {
 +create_internal_message(user_id, subject, body) None
 +notify_account_locked(user) None
 +notify_new_session(user) None
 +notify_session_timeout(user) None
 }

 AuthenticationService --> TokenService
 AuthenticationService --> PasswordService
 AuthenticationService --> AuditService
 AuthenticationService --> NotificationService
```

---

## 7. Configuración y Parámetros

### 7.1 Variables de Configuración (settings.py)

```python
# JWT Configuration
SIMPLE_JWT = {
 'ACCESS_TOKEN_LIFETIME': timedelta(minutes=15), # EXACTO
 'REFRESH_TOKEN_LIFETIME': timedelta(days=7), # EXACTO
 'ROTATE_REFRESH_TOKENS': True, # OBLIGATORIO
 'BLACKLIST_AFTER_ROTATION': True, # OBLIGATORIO
 'ALGORITHM': 'HS256', # OBLIGATORIO
 'SIGNING_KEY': SECRET_KEY, # Desde env
}

# Session Configuration
SESSION_ENGINE = 'django.contrib.sessions.backends.db' # PostgreSQL
SESSION_COOKIE_AGE = 1800 # 30 minutos
SESSION_SAVE_EVERY_REQUEST = True

# Password Configuration
PASSWORD_HASHERS = ['django.contrib.auth.hashers.BCryptSHA256PasswordHasher']
BCRYPT_COST_FACTOR = 12 # OBLIGATORIO

# Rate Limiting
THROTTLE_RATES = {
 'login': '5/5min', # 5 intentos cada 5 minutos
 'refresh': '10/min',
}

# APScheduler
SCHEDULER_CONFIG = {
 'apscheduler.jobstores.default': {
 'type': 'sqlalchemy',
 'url': 'postgresql://...'
 },
 'apscheduler.executors.default': {
 'class': 'apscheduler.executors.pool:ThreadPoolExecutor',
 'max_workers': '3'
 }
}
```

### 7.2 Parámetros de Seguridad

| Parámetro | Valor | Justificación |
|-----------|-------|---------------|
| **Access Token Lifetime** | 15 minutos | Balance seguridad/UX |
| **Refresh Token Lifetime** | 7 días | Evitar re-login frecuente |
| **bcrypt Cost Factor** | 12 | Resistente a ataques, ~400ms |
| **Max Failed Attempts** | 3 | Prevenir fuerza bruta |
| **Lock Duration** | 15 minutos | Balancear seguridad/UX |
| **Session Inactivity** | 30 minutos | Cerrar sesiones abandonadas |
| **Password Min Length** | 8 caracteres | Estándar NIST |
| **Password Max Length** | 100 caracteres | Prevenir DoS |
| **Password History** | 5 últimas | Prevenir reutilización |

---

## 8. Métricas y Monitoreo

### 8.1 Métricas Clave

```mermaid
graph LR
 subgraph "Métricas de Autenticación"
 M1[Login Success Rate]
 M2[Login Failure Rate]
 M3[Account Lockout Rate]
 M4[Token Refresh Rate]
 end

 subgraph "Métricas de Performance"
 P1[Login Response Time]
 P2[Token Validation Time]
 P3[Password Hash Time]
 end

 subgraph "Métricas de Sesiones"
 S1[Active Sessions]
 S2[Session Timeout Rate]
 S3[Concurrent Sessions/User]
 end

 subgraph "Métricas de Seguridad"
 SE1[Failed Login Attempts]
 SE2[Locked Accounts]
 SE3[Token Blacklist Size]
 end
```

### 8.2 Alertas Recomendadas

| Alerta | Condición | Acción |
|--------|-----------|--------|
| **High Login Failure Rate** | > 30% en 5 min | Revisar logs, posible ataque |
| **Mass Account Lockouts** | > 10 cuentas bloqueadas en 1 min | Investigar posible ataque distribuido |
| **Slow Login Performance** | p95 > 1 segundo | Revisar carga de BD, bcrypt |
| **Token Validation Failures** | > 100/min | Verificar SECRET_KEY, tokens |
| **Inactive Session Buildup** | > 1000 sesiones inactivas | Verificar job de limpieza |

---

## Control de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2025-11-04 | claude | Creación inicial del diseño técnico completo |

---

**Última actualización:** 2025-11-04
**Próxima revisión:** Antes de FASE 3 (Implementación)
