---
id: RF-010
tipo: funcional
titulo: Sesión única por usuario en PostgreSQL
dominio: backend
owner: equipo-backend
prioridad: critica
estado: pendiente
fecha_creacion: 2025-11-04
modulo: authentication
categoria: security

trazabilidad_upward:
 - RN-C01-13 # Sesiones en PostgreSQL
 - RN-C01-14 # Sesión Única por Usuario

trazabilidad_downward:
 - TEST-010 # Tests de sesión única

stakeholders:
 - usuarios-finales
 - administradores-sistema
 - gerentes-seguridad

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-010: Sesión Única por Usuario en PostgreSQL

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** mantener **máximo una sesión activa por usuario** **almacenando** sesiones en PostgreSQL mediante django_session (nativo) y user_sessions (custom) **cerrando** automáticamente la sesión anterior al iniciar nueva sesión **notificando** al usuario vía buzón interno sobre el cierre de sesión anterior **auditando** el evento SESSION_CLOSED **cuando** un usuario autenticado inicie sesión en un nuevo dispositivo o navegador.

### 1.2 Descripción Detallada

**Contexto:**
Permitir múltiples sesiones simultáneas por usuario incrementa el riesgo de seguridad y complica el tracking de actividad. El sistema necesita garantizar que cada usuario tenga máximo una sesión activa.

**Necesidad:**
- Prevenir acceso simultáneo desde múltiples dispositivos no autorizados
- Simplificar auditoría de actividad por usuario
- Facilitar cierre rápido de sesión comprometida
- Almacenar sesiones en base de datos (NO Redis) por restricción del proyecto

**Comportamiento esperado:**
1. **Al hacer login:** Si usuario ya tiene sesión activa, cerrarla automáticamente
2. **Cierre de sesión anterior:** Marcar is_active=False en user_sessions
3. **Eliminación de django_session:** Eliminar sesión anterior de tabla Django
4. **Notificación:** Informar usuario sobre nueva sesión vía buzón interno
5. **Auditoría:** Registrar evento SESSION_CLOSED
6. **Nueva sesión:** Crear nueva sesión en ambas tablas (django_session + user_sessions)
7. **Almacenamiento:** SOLO en PostgreSQL (NO Redis, NO cache, NO archivos)

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Primer login - sin sesión previa

```gherkin
Given un usuario "juan.perez" sin sesiones activas
When el usuario hace login exitoso
Then el sistema crea nueva sesión en django_session
 And el sistema crea nueva sesión en user_sessions con:
 | user_id | <user_id> |
 | session_key | <django_session_key> |
 | user_agent | <request_user_agent> |
 | is_active | True |
 | created_at | <now> |
 | last_activity_at | <now> |
 | logged_out_at | NULL |
 | logout_reason | NULL |
 And el sistema NO cierra ninguna sesión anterior (no existe)
 And el sistema NO envía notificación de cierre
```

#### Escenario 2: Login con sesión activa previa - cierre automático

```gherkin
Given un usuario "alice" con sesión activa en dispositivo A
 And la sesión tiene session_key="session_abc123"
 And la sesión tiene is_active=True
When el usuario hace login desde dispositivo B
Then el sistema detecta sesión activa previa
 And el sistema cierra sesión anterior:
 | is_active | False |
 | logged_out_at | <now> |
 | logout_reason | NEW_SESSION |
 And el sistema elimina django_session con session_key="session_abc123"
 And el sistema audita evento SESSION_CLOSED con:
 | event_type | SESSION_CLOSED |
 | user_id | <user_id> |
 | details | {"reason": "new_session", "old_session_id": "..."} |
 And el sistema envía notificación a buzón interno:
 "Se ha iniciado una nueva sesión en tu cuenta.
 Tu sesión anterior ha sido cerrada automáticamente.
 Si no fuiste tú quien inició esta sesión, cambia tu contraseña inmediatamente."
 And el sistema crea nueva sesión en ambas tablas para dispositivo B
 And el usuario en dispositivo A pierde acceso (sesión cerrada)
```

#### Escenario 3: Múltiples sesiones activas (caso edge) - cerrar todas

```gherkin
Given un usuario "bob" con 2 sesiones activas (caso anómalo)
 And ambas sesiones tienen is_active=True
When el usuario hace login desde dispositivo C
Then el sistema cierra TODAS las sesiones activas previas
 And el sistema audita 2 eventos SESSION_CLOSED
 And el sistema envía 1 notificación al usuario
 And el sistema crea solo 1 nueva sesión activa
```

#### Escenario 4: Verificación de sesión única - solo 1 activa

```gherkin
Given un usuario "carol" después de hacer login
When el sistema consulta sesiones activas del usuario
Then el sistema encuentra exactamente 1 sesión con is_active=True
 And NO existen múltiples sesiones activas simultáneas
```

#### Escenario 5: Sesiones almacenadas en PostgreSQL - NO Redis

```gherkin
Given la configuración de Django
Then settings.SESSION_ENGINE es "django.contrib.sessions.backends.db"
 And settings.SESSION_ENGINE NO es "django.contrib.sessions.backends.cache"
 And settings.SESSION_ENGINE NO es "django.contrib.sessions.backends.cached_db"
 And settings.SESSION_ENGINE NO es "django.contrib.sessions.backends.file"
 And las sesiones se almacenan en tabla "django_session" en PostgreSQL
 And NO se usa Redis como backend de sesiones
```

#### Escenario 6: Estructura de user_sessions - tracking adicional

```gherkin
Given una sesión activa en user_sessions
Then la tabla contiene columnas:
 | session_id | SERIAL PRIMARY KEY |
 | user_id | INTEGER REFERENCES users |
 | session_key | VARCHAR(40) UNIQUE |
 | user_agent | TEXT |
 | is_active | BOOLEAN DEFAULT TRUE |
 | created_at | TIMESTAMP DEFAULT CURRENT_TS |
 | last_activity_at | TIMESTAMP DEFAULT CURRENT_TS |
 | logged_out_at | TIMESTAMP |
 | logout_reason | VARCHAR(50) |
 And la tabla permite tracking avanzado de sesiones
```

#### Escenario 7: Notificación NO incluye IP address

```gherkin
Given un usuario cuya sesión anterior fue cerrada
When el sistema envía notificación vía buzón interno
Then el mensaje contiene:
 "Se ha iniciado una nueva sesión en tu cuenta.
 Tu sesión anterior ha sido cerrada automáticamente."
 And el mensaje NO contiene IP address (prohibido por restricciones)
 And el mensaje NO contiene ubicación geográfica
 And el mensaje solo informa sobre el cierre de sesión
```

#### Escenario 8: User_agent almacenado pero NO validado

```gherkin
Given un usuario haciendo login con user_agent="Chrome/100.0"
When el sistema crea la sesión
Then el sistema almacena user_agent en user_sessions
 And el sistema NO valida el user_agent
 And el sistema NO rechaza por cambio de user_agent
 And el user_agent es solo para auditoría
```

#### Escenario 9: Sesión única por usuario - independiente por usuario

```gherkin
Given usuario "dave" con sesión activa en dispositivo A
 And usuario "eve" con sesión activa en dispositivo B
When usuario "dave" hace login en dispositivo C
Then el sistema cierra solo la sesión de "dave" en dispositivo A
 And el sistema NO afecta la sesión de "eve" en dispositivo B
 And cada usuario tiene máximo 1 sesión activa
 And usuarios diferentes son independientes
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Límite de sesiones** | Máximo por usuario | 1 sesión activa | Test |
| **Almacenamiento** | Backend | PostgreSQL (NO Redis) | Config |
| **Performance** | Cierre de sesión anterior | < 100 ms | Test |
| **Notificación** | Buzón interno | Obligatorio | Test |
| **Auditoría** | Registro de cierre | Obligatorio | Test |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| close_previous_sessions | `apps/authentication/services.py` | nuevo |
| create_user_session | `apps/authentication/services.py` | nuevo |
| UserSession model | `apps/users/models.py` | nuevo |
| DjangoSession | django.contrib.sessions | existente |
| AuditLog model | `apps/audit/models.py` | existente |
| InternalMessage model | `apps/notifications/models.py` | existente |
| settings.py | `callcentersite/settings.py` | modificar |

### 3.2 Interfaces

#### 3.2.1 Configuración - settings.py

```python
# Configuración de sesiones (OBLIGATORIO - PostgreSQL)
SESSION_ENGINE = 'django.contrib.sessions.backends.db' # PostgreSQL
SESSION_COOKIE_AGE = 1800 # 30 minutos (para inactividad)
SESSION_SAVE_EVERY_REQUEST = True # Actualizar en cada request
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True # HTTPS only
SESSION_COOKIE_SAMESITE = 'Lax'

# PROHIBIDO usar estas configuraciones:
# SESSION_ENGINE = 'django.contrib.sessions.backends.cache' # NO NO Redis
# SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db' # NO NO Redis
# SESSION_ENGINE = 'django.contrib.sessions.backends.file' # NO NO archivos
```

#### 3.2.2 Modelo UserSession

```python
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class UserSession(models.Model):
 """
 Modelo custom para tracking avanzado de sesiones
 Complementa django_session con metadatos adicionales
 """
 session_id = models.AutoField(primary_key=True)
 user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sessions')
 session_key = models.CharField(max_length=40, unique=True)
 user_agent = models.TextField(null=True, blank=True)
 is_active = models.BooleanField(default=True)
 created_at = models.DateTimeField(auto_now_add=True)
 last_activity_at = models.DateTimeField(auto_now_add=True)
 logged_out_at = models.DateTimeField(null=True, blank=True)
 logout_reason = models.CharField(max_length=50, null=True, blank=True)

 class Meta:
 db_table = 'user_sessions'
 indexes = [
 models.Index(fields=['user', 'is_active']),
 models.Index(fields=['session_key']),
 ]

 def __str__(self):
 return f"Session {self.session_key} for {self.user.username}"
```

#### 3.2.3 API Python - close_previous_sessions

```python
from django.utils.timezone import now
from django.contrib.sessions.models import Session as DjangoSession

def close_previous_sessions(user: User, request) -> int:
 """
 Cerrar sesiones activas previas del usuario (sesión única)

 Args:
 user: Usuario autenticado
 request: Request HTTP (para auditoría)

 Returns:
 int: Número de sesiones cerradas
 """
 # PASO 1: Buscar sesiones activas previas
 active_sessions = UserSession.objects.filter(
 user=user,
 is_active=True
 )

 if not active_sessions.exists():
 return 0 # No hay sesiones previas

 closed_count = 0

 # PASO 2: Cerrar cada sesión activa
 for session in active_sessions:
 # Actualizar user_sessions
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'NEW_SESSION'
 session.save()

 # Eliminar de django_session
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 # Ya eliminada, continuar
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

 closed_count += 1

 # PASO 3: Notificar al usuario (una sola notificación)
 if closed_count > 0:
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

 return closed_count
```

#### 3.2.4 API Python - create_user_session

```python
def create_user_session(user: User, request) -> UserSession:
 """
 Crear nueva sesión en user_sessions

 Args:
 user: Usuario autenticado
 request: Request HTTP

 Returns:
 UserSession: Sesión creada
 """
 session = UserSession.objects.create(
 user=user,
 session_key=request.session.session_key,
 user_agent=request.META.get('HTTP_USER_AGENT', 'Unknown'),
 is_active=True,
 created_at=now(),
 last_activity_at=now()
 )

 return session
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-RN-C01-13-01 | Backend: PostgreSQL | SESSION_ENGINE = 'db' |
| BR-RN-C01-13-02 | PROHIBIDO: Redis | NO usar cache o cached_db |
| BR-RN-C01-13-03 | Dos tablas | django_session + user_sessions |
| BR-RN-C01-14-01 | Máximo 1 sesión activa | Por usuario |
| BR-RN-C01-14-02 | Cerrar sesión anterior | Automático en login |
| BR-RN-C01-14-03 | Cerrar en ambas tablas | django_session + user_sessions |
| BR-RN-C01-14-04 | Notificar buzón interno | NO email, SIN IP |
| BR-RN-C01-14-05 | Auditar cierre | evento SESSION_CLOSED |
| BR-RN-C01-14-06 | Almacenar user_agent | NO validar |

### 3.4 Validaciones

#### Validaciones de Entrada
- Usuario debe estar autenticado
- Request debe tener session_key válido

#### Validaciones de Negocio
- Usuario debe tener máximo 1 sesión activa después del login
- SESSION_ENGINE debe ser 'django.contrib.sessions.backends.db'
- Sesión anterior debe cerrarse en ambas tablas

### 3.5 Algoritmo Detallado (Integrado en Login - RF-005)

```python
def login(username: str, password: str, request) -> dict:
 # ... (PASO 1: Validar credenciales) ...

 # PASO 2: Cerrar sesión previa si existe (sesión única - RN-C01-14)
 closed_sessions = close_previous_sessions(user, request)

 # PASO 3: Crear nueva sesión en PostgreSQL (RN-C01-13)
 session = create_user_session(user, request)

 # ... (PASO 4-7: Generar tokens, actualizar usuario, auditar, retornar) ...
```

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- User model debe existir
- Django sessions habilitado
- PostgreSQL configurado como base de datos principal
- AuditLog model debe existir
- InternalMessage model debe existir

### 4.2 Requisitos Relacionados

- **RF-005:** Login (implementa cierre de sesión única)
- **RF-007:** Logout Manual (cierra sesión en ambas tablas)
- **RF-008:** Cierre por Inactividad (cierra sesión en ambas tablas)

### 4.3 Restricciones del Proyecto

Del documento `restricciones_y_lineamientos.md`:

- **RESTR-001:** NO email - notificaciones solo por buzón interno
- **RESTR-003:** Sesiones en PostgreSQL (NO Redis) - restricción crítica
- **RESTR-008:** Auditoría obligatoria (cierre de sesiones)

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-010-001:** test_primer_login_sin_sesion_previa
 - Ubicación: `tests/authentication/test_single_session.py`
 - Estado: pendiente

- [ ] **TEST-010-002:** test_login_con_sesion_activa_cierra_anterior
 - Estado: pendiente

- [ ] **TEST-010-003:** test_multiples_sesiones_activas_cierra_todas
 - Estado: pendiente

- [ ] **TEST-010-004:** test_usuario_tiene_maximo_1_sesion_activa
 - Estado: pendiente

- [ ] **TEST-010-005:** test_sesiones_almacenadas_en_postgresql
 - Estado: pendiente

- [ ] **TEST-010-006:** test_session_engine_es_db_no_redis
 - Estado: pendiente

- [ ] **TEST-010-007:** test_cierre_sesion_anterior_en_ambas_tablas
 - Estado: pendiente

- [ ] **TEST-010-008:** test_notificacion_buzon_interno_sin_ip
 - Estado: pendiente

- [ ] **TEST-010-009:** test_auditoria_session_closed
 - Estado: pendiente

- [ ] **TEST-010-010:** test_user_agent_almacenado_no_validado
 - Estado: pendiente

- [ ] **TEST-010-011:** test_sesion_unica_independiente_por_usuario
 - Estado: pendiente

### 5.2 Tests de Integración

- [ ] **TEST-010-INT-001:** test_flujo_completo_login_cierre_sesion_anterior
- [ ] **TEST-010-INT-002:** test_usuario_dispositivo_a_pierde_acceso_tras_login_dispositivo_b

### 5.3 Tests de Configuración

- [ ] **TEST-010-CONF-001:** test_session_engine_configurado_correctamente
- [ ] **TEST-010-CONF-002:** test_no_usa_redis_como_backend

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado
- [ ] 11 tests unitarios implementados y pasando
- [ ] Tests de integración implementados y pasando
- [ ] Coverage >= 95% para close_previous_sessions
- [ ] SESSION_ENGINE configurado como 'db' en settings.py
- [ ] UserSession model creado y migrado
- [ ] Tabla user_sessions creada en PostgreSQL
- [ ] Cierre de sesión anterior implementado
- [ ] Notificación por buzón interno implementada
- [ ] Auditoría verificada para SESSION_CLOSED
- [ ] Verificado que NO se usa Redis

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de las reglas de negocio:
- **RN-C01-13:** Sesiones en PostgreSQL
- **RN-C01-14:** Sesión Única por Usuario

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|--------|-----------|
| Test | TEST-010 | Tests de sesión única | `tests/authentication/test_single_session.py` |
| Código | IMPL-010 | close_previous_sessions | `apps/authentication/services.py` |
| Modelo | UserSession | Modelo de sesiones | `apps/users/models.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Reglas de negocio: `docs/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (líneas 1688-1833)
- Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### 8.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018:** Clause 9.6 - Software Requirements Specification
- **OWASP ASVS:** Session Management Verification Requirements

### 8.3 Documentación Django

- **Django Sessions:** https://docs.djangoproject.com/en/stable/topics/http/sessions/

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial basada en RN-C01-13 y RN-C01-14 |
