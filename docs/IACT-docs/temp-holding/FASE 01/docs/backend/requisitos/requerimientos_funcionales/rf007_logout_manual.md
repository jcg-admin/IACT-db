---
id: RF-007
tipo: funcional
titulo: Logout manual y cierre de sesión
dominio: backend
owner: equipo-backend
prioridad: alta
estado: pendiente
fecha_creacion: 2025-11-04
modulo: authentication
categoria: security

trazabilidad_upward:
 - RN-C01-05 # Logout Manual
 - RN-C01-12 # Auditoría de Login

trazabilidad_downward:
 - TEST-007 # Tests de logout

stakeholders:
 - usuarios-finales
 - administradores-sistema

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-007: Logout Manual y Cierre de Sesión

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** permitir a los usuarios cerrar su sesión manualmente en cualquier momento **invalidando** el refresh token mediante blacklist **cerrando** la sesión en user_sessions (is_active=False) y django_session **auditando** el evento de logout **cuando** el usuario envíe una solicitud al endpoint de logout.

### 1.2 Descripción Detallada

**Contexto:**
Los usuarios necesitan poder cerrar su sesión de forma explícita cuando terminan de usar el sistema, especialmente en dispositivos compartidos o públicos.

**Necesidad:**
- Cerrar sesión de forma segura invalidando tokens
- Prevenir uso de tokens después del logout
- Auditar eventos de cierre de sesión para seguridad
- Limpiar sesiones de la base de datos

**Comportamiento esperado:**
1. Usuario autenticado envía POST /api/v1/auth/logout con refresh_token
2. Sistema blacklistea el refresh_token (no puede reutilizarse)
3. Sistema cierra sesión en user_sessions (is_active=False)
4. Sistema elimina sesión de django_session
5. Sistema audita evento LOGOUT_SUCCESS
6. Access token sigue válido hasta su expiración natural (stateless JWT)

**Nota importante:** Los access tokens NO se invalidan porque JWT es stateless. El access token seguirá siendo válido hasta su expiración (15 minutos). Solo el refresh token se invalida para prevenir generación de nuevos access tokens.

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Logout exitoso con sesión activa

```gherkin
Given un usuario "juan.perez" autenticado
 And el usuario tiene sesión activa con session_key="abc123"
 And el usuario tiene refresh_token válido
When el usuario envía POST /api/v1/auth/logout con:
 {
 "refresh_token": "<valid_refresh_token>"
 }
Then el sistema retorna HTTP 200 OK
 And el sistema retorna:
 {
 "message": "Sesión cerrada exitosamente"
 }
 And el sistema blacklistea el refresh_token
 And el sistema actualiza user_sessions:
 | is_active | False |
 | logged_out_at | <timestamp actual> |
 | logout_reason | MANUAL |
 And el sistema elimina django_session con session_key="abc123"
 And el sistema audita evento LOGOUT_SUCCESS con:
 | event_type | LOGOUT_SUCCESS |
 | user_id | <user_id> |
 | user_agent | <user_agent> |
 | details | {"method": "manual", "sessions_closed": 1} |
 | result | SUCCESS |
```

#### Escenario 2: Logout con refresh_token ya blacklisted

```gherkin
Given un usuario con refresh_token que ya fue blacklisted previamente
When el usuario envía POST /api/v1/auth/logout con ese token
Then el sistema retorna HTTP 200 OK (idempotente)
 And el sistema retorna:
 {
 "message": "Sesión cerrada exitosamente"
 }
 And el sistema NO falla (operación idempotente)
 And el sistema cierra sesiones activas del usuario (si existen)
 And el sistema audita evento LOGOUT_SUCCESS
```

#### Escenario 3: Logout sin refresh_token (opcional)

```gherkin
Given un usuario autenticado con access_token válido
 And el usuario NO proporciona refresh_token en el request
When el usuario envía POST /api/v1/auth/logout sin refresh_token
Then el sistema retorna HTTP 200 OK
 And el sistema cierra todas las sesiones activas del usuario
 And el sistema audita evento LOGOUT_SUCCESS
 And el sistema retorna:
 {
 "message": "Sesión cerrada exitosamente",
 "note": "Access token seguirá válido hasta expirar"
 }
```

#### Escenario 4: Logout con múltiples sesiones activas

```gherkin
Given un usuario con 2 sesiones activas (caso edge)
 And ambas sesiones tienen is_active=True
When el usuario envía POST /api/v1/auth/logout
Then el sistema cierra TODAS las sesiones activas
 And el sistema audita con sessions_closed=2
```

#### Escenario 5: Logout sin autenticación (no permitido)

```gherkin
Given un usuario NO autenticado
When el usuario envía POST /api/v1/auth/logout sin access_token
Then el sistema retorna HTTP 401 Unauthorized
 And el sistema retorna:
 {
 "error": "Autenticación requerida",
 "code": "authentication_required"
 }
 And el sistema NO realiza ningún cierre de sesión
```

#### Escenario 6: Access token sigue válido después de logout

```gherkin
Given un usuario que hizo logout hace 2 minutos
 And el access_token aún no ha expirado (válido por 15min)
 And el refresh_token fue blacklisted
When el usuario intenta acceder a un endpoint protegido con el access_token
Then el sistema PERMITE acceso (JWT stateless)
 And el request es procesado normalmente
 And el sistema NO rechaza por logout previo
 But si el usuario intenta refrescar el token:
 Then el sistema rechaza porque refresh_token está blacklisted
 And el usuario debe hacer login nuevamente
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Performance** | Tiempo de logout | < 100 ms | 95th percentile |
| **Idempotencia** | Logout múltiple | Permitido | Test |
| **Auditoría** | Registrar evento | Obligatorio | Test |
| **Disponibilidad** | Disponible 24/7 | 99.9% | Monitoreo mensual |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| LogoutView | `apps/authentication/views.py` | nuevo |
| AuthenticationService.logout | `apps/authentication/services.py` | nuevo |
| UserSession model | `apps/users/models.py` | existente |
| DjangoSession | django.contrib.sessions | existente |
| BlacklistedToken | rest_framework_simplejwt | existente |
| AuditLog model | `apps/audit/models.py` | existente |

### 3.2 Interfaces

#### 3.2.1 API REST

**Endpoint:** `POST /api/v1/auth/logout`

**Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

**Request:**
```json
{
 "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (Éxito - HTTP 200):**
```json
{
 "message": "Sesión cerrada exitosamente"
}
```

**Response (Error - HTTP 401 No Autenticado):**
```json
{
 "error": "Autenticación requerida",
 "code": "authentication_required"
}
```

#### 3.2.2 API Python (Service Layer)

```python
class AuthenticationService:
 @staticmethod
 def logout(user: User, refresh_token: str, request) -> None:
 """
 Cerrar sesión manualmente

 Args:
 user: Usuario autenticado
 refresh_token: Refresh token a invalidar (opcional)
 request: Request HTTP (para user_agent)

 Raises:
 None (operación idempotente)
 """
 pass
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-RN-C01-05-01 | Blacklist refresh token | Agregar a token_blacklist_blacklistedtoken |
| BR-RN-C01-05-02 | Cerrar sesión en user_sessions | is_active=False |
| BR-RN-C01-05-03 | Eliminar django_session | delete() en tabla django_session |
| BR-RN-C01-05-04 | Auditar logout | evento LOGOUT_SUCCESS |
| BR-RN-C01-05-05 | Access token sigue válido | JWT stateless - no se invalida |
| BR-RN-C01-05-06 | Operación idempotente | Permitir logout múltiple sin error |
| BR-RN-C01-05-07 | Cerrar todas las sesiones | Si user tiene múltiples sesiones activas |

### 3.4 Validaciones

#### Validaciones de Entrada
- Usuario debe estar autenticado (access_token válido)
- refresh_token es opcional (puede ser None)

#### Validaciones de Negocio
- Usuario debe existir en BD
- Si refresh_token proporcionado, debe ser válido (puede estar blacklisted)

### 3.5 Algoritmo Detallado

```python
from rest_framework_simplejwt.tokens import RefreshToken

def logout(user: User, refresh_token: str, request) -> None:
 """
 Cerrar sesión manualmente
 """
 # PASO 1: Blacklist refresh token si fue proporcionado
 if refresh_token:
 try:
 token = RefreshToken(refresh_token)
 token.blacklist()
 except Exception as e:
 # Token ya blacklisted o inválido, continuar
 # Operación idempotente - no fallar
 pass

 # PASO 2: Cerrar sesión en user_sessions
 sessions = UserSession.objects.filter(
 user=user,
 is_active=True
 )

 sessions_closed = 0
 for session in sessions:
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'MANUAL'
 session.save()
 sessions_closed += 1

 # Cerrar en django_session también
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 # Sesión ya eliminada, continuar
 pass

 # PASO 3: Auditar logout (RN-C01-12)
 AuditLog.create(
 event_type='LOGOUT_SUCCESS',
 user_id=user.id,
 user_agent=request.META.get('HTTP_USER_AGENT'),
 details={
 'method': 'manual',
 'sessions_closed': sessions_closed
 },
 result='SUCCESS'
 )
```

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- User model debe existir
- UserSession model debe existir
- djangorestframework-simplejwt instalado
- token_blacklist app instalada
- AuditLog model debe existir

### 4.2 Requisitos Relacionados

- **RF-005:** Login con Credenciales (crea tokens)
- **RF-006:** Tokens JWT (blacklist tokens)
- **RF-008:** Cierre por Inactividad (cierre automático)

### 4.3 Restricciones del Proyecto

Del documento `restricciones_y_lineamientos.md`:

- **RESTR-003:** Sesiones en PostgreSQL (cierre en BD)
- **RESTR-008:** Auditoría obligatoria (registrar logout)

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-007-001:** test_logout_exitoso_con_sesion_activa
 - Ubicación: `tests/authentication/test_logout.py`
 - Estado: pendiente

- [ ] **TEST-007-002:** test_logout_blacklistea_refresh_token
 - Estado: pendiente

- [ ] **TEST-007-003:** test_logout_cierra_sesion_en_user_sessions
 - Estado: pendiente

- [ ] **TEST-007-004:** test_logout_elimina_django_session
 - Estado: pendiente

- [ ] **TEST-007-005:** test_logout_audita_evento_logout_success
 - Estado: pendiente

- [ ] **TEST-007-006:** test_logout_idempotente_token_ya_blacklisted
 - Estado: pendiente

- [ ] **TEST-007-007:** test_logout_sin_refresh_token
 - Estado: pendiente

- [ ] **TEST-007-008:** test_logout_cierra_multiples_sesiones_activas
 - Estado: pendiente

- [ ] **TEST-007-009:** test_logout_sin_autenticacion_rechazado
 - Estado: pendiente

- [ ] **TEST-007-010:** test_access_token_sigue_valido_despues_logout
 - Estado: pendiente

- [ ] **TEST-007-011:** test_no_puede_refrescar_token_despues_logout
 - Estado: pendiente

### 5.2 Tests de Integración

- [ ] **TEST-007-INT-001:** test_flujo_completo_login_uso_logout
- [ ] **TEST-007-INT-002:** test_logout_en_dispositivo_a_no_afecta_dispositivo_b

### 5.3 Tests de Performance

- [ ] **TEST-007-PERF-001:** test_logout_menor_100ms

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado
- [ ] 11 tests unitarios implementados y pasando
- [ ] Tests de integración implementados y pasando
- [ ] Coverage >= 95% para AuthenticationService.logout
- [ ] Documentación técnica actualizada (este documento)
- [ ] Performance verificado (< 100ms por logout)
- [ ] Idempotencia verificada
- [ ] Auditoría verificada para evento LOGOUT_SUCCESS

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de las reglas de negocio:
- **RN-C01-05:** Logout Manual
- **RN-C01-12:** Auditoría de Login

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|--------|-----------|
| Test | TEST-007 | Tests de logout | `tests/authentication/test_logout.py` |
| Código | IMPL-007 | AuthenticationService.logout | `apps/authentication/services.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Reglas de negocio: `docs/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (líneas 918-1012)
- Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### 8.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018:** Clause 9.6 - Software Requirements Specification
- **OWASP ASVS:** Session Logout and Timeout Requirements

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial basada en RN-C01-05 |
