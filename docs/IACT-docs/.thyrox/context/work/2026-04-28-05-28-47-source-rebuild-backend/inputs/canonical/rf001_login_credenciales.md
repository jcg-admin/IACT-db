---
id: RF-001
tipo: funcional
titulo: Login con credenciales username/password
dominio: backend
owner: equipo-backend
prioridad: critica
estado: aprobado
fecha_creacion: 2025-11-06
fecha_aprobacion: 2025-11-06
sprint_target: SPRINT-01
estimacion_esfuerzo: 8 story-points

# Trazabilidad Upward
trazabilidad_upward:
 - N-001 # Prevenir accesos fraudulentos mediante autenticacion robusta
 - RN-001 # Sistema de autenticacion seguro con prevencion de fraude
 - RS-001 # Auditoria requiere trazabilidad completa
 - RS-002 # Usuarios requieren acceso rapido

# Trazabilidad Downward
trazabilidad_downward:
 - TEST-RF-001 # Suite de tests para RF-001
 - CODE-authentication-services # apps/authentication/services.py
 - CODE-authentication-views # apps/authentication/views.py

# Stakeholders interesados
stakeholders:
 - usuarios-finales-agentes
 - auditoria-interna
 - gerente-seguridad

# Conformidad ISO 29148
iso29148_clause: "9.6.4" # Software Requirements Specification
verificacion_metodo: test

# Categorizacion adicional
categoria: security
modulo: authentication
subsistema: auth

# Dependencias
dependencias:
 - User model existente
 - djangorestframework-simplejwt

# Impacto
impacto_usuarios: alto
impacto_sistema: alto
breaking_change: no
date: 2025-11-13
---

# RF-001: Login con credenciales username/password

## 1. Descripcion del Requisito

### 1.1 Declaracion del Requisito (ISO 29148 Format)

**El sistema DEBERA** autenticar usuarios mediante credenciales locales (username/password) **validando** las credenciales contra base de datos MySQL **y retornando** tokens JWT (access 15min + refresh 7dias) al autenticarse exitosamente **cuando** un usuario envie sus credenciales al endpoint POST /api/v1/auth/login.

### 1.2 Descripcion Detallada

**Contexto:**
El sistema IACT requiere mecanismo de autenticacion local robusto que permita acceso seguro sin dependencia de sistemas externos.

**Necesidad:**
Usuarios (agentes de call center, supervisores, gerentes) necesitan iniciar sesion de forma segura en menos de 2 segundos para acceder a dashboard y reportes.

**Comportamiento esperado:**
1. Usuario envia username/password a POST /api/v1/auth/login
2. Sistema valida credenciales contra tabla users en MySQL
3. Sistema verifica hash bcrypt (cost factor 12)
4. Si valido: genera tokens JWT y retorna HTTP 200
5. Si invalido: incrementa contador failed_login_attempts y retorna HTTP 401
6. Sistema audita evento (login_success o login_failure)

---

## 2. Criterios de Aceptacion

### 2.1 Criterios Funcionales

#### Escenario 1: Login exitoso con credenciales validas

```gherkin
Given un usuario registrado "juan.perez" con password correcta
 And el usuario tiene status='ACTIVO'
 And el usuario NO esta bloqueado (is_locked=False)
When el usuario envia POST /api/v1/auth/login con credenciales validas
Then el sistema retorna HTTP 200 OK
 And el sistema retorna access_token (valido 15 minutos)
 And el sistema retorna refresh_token (valido 7 dias)
 And el sistema resetea failed_login_attempts a 0
 And el sistema actualiza last_login_at
 And el sistema audita evento LOGIN_SUCCESS
```

#### Escenario 2: Login fallido - credenciales invalidas

```gherkin
Given un usuario registrado "juan.perez"
When el usuario envia POST /api/v1/auth/login con password incorrecta
Then el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna mensaje: "Credenciales invalidas"
 And el sistema incrementa failed_login_attempts
 And el sistema NO revela si el username existe
 And el sistema audita evento LOGIN_FAILURE
```

#### Escenario 3: Login fallido - cuenta bloqueada

```gherkin
Given un usuario con is_locked=True
 And el usuario tiene locked_until=<timestamp futuro>
When el usuario envia POST /api/v1/auth/login con credenciales validas
Then el sistema retorna HTTP 403 Forbidden
 And el sistema retorna mensaje: "Cuenta bloqueada hasta <timestamp>"
 And el sistema NO permite login hasta que pase locked_until
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medicion |
|---------|----------|--------|----------|
| **Performance** | Tiempo de login | menor 2 segundos | 95th percentile |
| **Seguridad** | Hash bcrypt | cost factor 12 | Code review |
| **Disponibilidad** | Uptime endpoint | 99.9% | Monitoreo mensual |

---

## 3. Especificacion Tecnica

### 3.1 Componentes Afectados

| Componente | Ubicacion | Tipo de Cambio |
|------------|-----------|----------------|
| LoginView | api/callcentersite/callcentersite/apps/authentication/views.py | nuevo |
| AuthenticationService | api/callcentersite/callcentersite/apps/authentication/services.py | extension |
| User model | api/callcentersite/callcentersite/apps/users/models.py | existente |

### 3.2 Interfaces

#### 3.2.1 API REST

**Endpoint:** `POST /api/v1/auth/login`

**Request:**
```json
{
 "username": "juan.perez",
 "password": "SecureP@ss123"
}
```

**Response (Exito - HTTP 200):**
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
 "error": "Credenciales invalidas",
 "attempts_remaining": 4
}
```

---

## 4. Trazabilidad

### 4.1 Trazabilidad Upward (Origen)

Este requisito deriva de:

| Tipo | ID | Titulo | Vinculo |
|------|----|--------|---------|
| Necesidad | N-001 | Prevenir accesos fraudulentos mediante autenticacion robusta | [link](../necesidades/n001_autenticacion_robusta_prevenir_fraude.md) |
| Req. Negocio | RN-001 | Sistema de autenticacion seguro con prevencion de fraude | [link](../negocio/rn001_sistema_autenticacion_seguro_prevencion_fraude.md) |
| Req. Stakeholder | RS-001 | Auditoria requiere trazabilidad completa | [link](../stakeholders/rs001_auditoria_requiere_trazabilidad_completa.md) |
| Req. Stakeholder | RS-002 | Usuarios requieren acceso rapido menor 2 segundos | [link](../stakeholders/rs002_usuarios_requieren_acceso_rapido.md) |

**Justificacion:**
RF-001 satisface N-001 proporcionando mecanismo de autenticacion robusta. Cumple RN-001 validando credenciales de forma segura. Satisface RS-001 generando eventos de auditoria. Cumple RS-002 optimizando performance para menos de 2 segundos.

### 4.2 Trazabilidad Downward (Derivados)

Este requisito genera:

| Tipo | ID | Titulo | Ubicacion |
|------|----|--------|-----------|
| Test | TEST-RF-001-001 | test_login_exitoso_credenciales_validas | tests/authentication/test_login.py |
| Test | TEST-RF-001-002 | test_login_fallido_credenciales_invalidas | tests/authentication/test_login.py |
| Test | TEST-RF-001-003 | test_login_fallido_cuenta_bloqueada | tests/authentication/test_login.py |
| Codigo | CODE-auth-service | AuthenticationService.login() | apps/authentication/services.py |

---

## 5. Referencias

### 5.1 Documentos Relacionados

- Codigo existente: api/callcentersite/callcentersite/apps/authentication/
- Restricciones IACT: restricciones_y_lineamientos.md

### 5.2 Estandares Aplicados

- ISO/IEC/IEEE 29148:2018: Clause 9.6 - Software Requirements Specification
- OWASP ASVS v4.0: Authentication Verification Requirements

---

## Control de Cambios

| Version | Fecha | Autor | Descripcion del Cambio | Aprobado Por |
|---------|-------|-------|------------------------|--------------|
| 1.0 | 2025-11-06 | BA Team | Creacion inicial derivada de N-001, RN-001, RS-001, RS-002 | Product Owner |
