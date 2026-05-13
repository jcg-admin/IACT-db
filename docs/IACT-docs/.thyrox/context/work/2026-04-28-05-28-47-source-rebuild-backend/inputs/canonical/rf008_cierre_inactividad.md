---
id: RF-008
tipo: funcional
titulo: Cierre automático de sesiones por inactividad
dominio: backend
owner: equipo-backend
prioridad: alta
estado: pendiente
fecha_creacion: 2025-11-04
modulo: authentication
categoria: security

trazabilidad_upward:
 - RN-C01-06 # Cierre por Inactividad
 - RN-C01-12 # Auditoría de Login

trazabilidad_downward:
 - TEST-008 # Tests de cierre por inactividad

stakeholders:
 - usuarios-finales
 - administradores-sistema
 - gerentes-seguridad

iso29148_clause: "9.6.4"
verificacion_metodo: test
date: 2025-11-13
---

# RF-008: Cierre Automático de Sesiones por Inactividad

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** cerrar automáticamente las sesiones de usuario tras **30 minutos exactos de inactividad** (sin requests al backend) **mediante** un job programado que se ejecuta cada 5 minutos **cerrando** la sesión en user_sessions y django_session **auditando** el evento SESSION_TIMEOUT **y notificando** al usuario vía buzón interno **cuando** una sesión supere el tiempo de inactividad permitido.

### 1.2 Descripción Detallada

**Contexto:**
Las sesiones abandonadas representan un riesgo de seguridad, especialmente en dispositivos compartidos o cuando el usuario olvida cerrar sesión.

**Necesidad:**
- Cerrar automáticamente sesiones inactivas para seguridad
- Prevenir acceso no autorizado en dispositivos compartidos
- Liberar recursos de sesiones en la base de datos
- Notificar al usuario sobre el cierre automático

**Comportamiento esperado:**
1. Sistema actualiza `last_activity_at` en cada request válido
2. Job programado corre cada 5 minutos
3. Job identifica sesiones con `last_activity_at` > 30 minutos atrás
4. Job cierra sesiones inactivas automáticamente
5. Job audita evento SESSION_TIMEOUT
6. Job notifica usuario vía buzón interno (NO email)

**Tiempo de inactividad:** 30 minutos exactos desde el último request válido.

## 2. Criterios de Aceptación

### 2.1 Criterios Funcionales

#### Escenario 1: Actualización de last_activity_at en request válido

```gherkin
Given un usuario "juan.perez" autenticado
 And el usuario tiene sesión activa con last_activity_at=<10:00:00>
When el usuario envía request válido a las 10:05:00
Then el sistema actualiza last_activity_at=<10:05:00>
 And el sistema NO cierra la sesión
 And el contador de inactividad se resetea
```

#### Escenario 2: Sesión inactiva por 30 minutos - cierre automático

```gherkin
Given un usuario "alice" con sesión activa
 And la sesión tiene last_activity_at=<10:00:00>
 And la hora actual es 10:35:00 (35 minutos después)
 And el job de cierre corre cada 5 minutos
When el job de cierre se ejecuta a las 10:35:00
Then el job identifica la sesión como inactiva (> 30 minutos)
 And el job actualiza user_sessions:
 | is_active | False |
 | logged_out_at | 10:35:00 |
 | logout_reason | INACTIVITY_TIMEOUT |
 And el job elimina django_session correspondiente
 And el job audita evento SESSION_TIMEOUT con:
 | event_type | SESSION_TIMEOUT |
 | user_id | <user_id> |
 | details | {"reason": "inactivity", "inactive_minutes": 30} |
 And el job envía notificación a buzón interno:
 "Tu sesión ha sido cerrada automáticamente por inactividad
 de más de 30 minutos. Por seguridad, debes iniciar sesión nuevamente."
```

#### Escenario 3: Sesión activa - NO cierre

```gherkin
Given un usuario "bob" con sesión activa
 And la sesión tiene last_activity_at=<10:25:00>
 And la hora actual es 10:35:00 (10 minutos después)
When el job de cierre se ejecuta a las 10:35:00
Then el job NO identifica la sesión como inactiva (< 30 minutos)
 And el job NO cierra la sesión
 And la sesión permanece activa (is_active=True)
```

#### Escenario 4: Múltiples sesiones inactivas - cierre en lote

```gherkin
Given 10 usuarios con sesiones inactivas > 30 minutos
When el job de cierre se ejecuta
Then el job cierra las 10 sesiones simultáneamente
 And el job audita 10 eventos SESSION_TIMEOUT
 And el job envía 10 notificaciones a buzón interno
 And el job completa en < 5 segundos
```

#### Escenario 5: Job programado corre cada 5 minutos

```gherkin
Given el sistema está en ejecución
 And el scheduler está configurado
When el job de cierre se ejecuta a las 10:00:00
Then el próximo job se ejecuta a las 10:05:00
 And el próximo job después se ejecuta a las 10:10:00
 And el intervalo es exactamente 5 minutos
 And el job corre incluso si no hay sesiones inactivas
```

#### Escenario 6: Sesión cerrada por inactividad - access token sigue válido

```gherkin
Given un usuario cuya sesión fue cerrada por inactividad hace 2 minutos
 And el access_token aún no ha expirado (< 15 minutos)
When el usuario intenta acceder a un endpoint protegido con el access_token
Then el sistema PERMITE acceso (JWT stateless)
 And el request es procesado normalmente
 But el sistema NO recrea la sesión automáticamente
 And si el usuario intenta refrescar el token:
 Then el sistema puede rechazar si el refresh token fue blacklisted
```

#### Escenario 7: Usuario reactiva sesión antes de cierre automático

```gherkin
Given un usuario con sesión inactiva por 29 minutos
 And el job de cierre correrá en 1 minuto
When el usuario envía request válido
Then el sistema actualiza last_activity_at=<now>
 And el sistema resetea contador de inactividad
 And el sistema NO cierra la sesión
 And cuando el job corra, NO cerrará la sesión (< 30 minutos)
```

#### Escenario 8: Notificación al usuario vía buzón interno

```gherkin
Given una sesión cerrada por inactividad
When el job envía notificación
Then el sistema crea InternalMessage con:
 | user_id | <user_id> |
 | subject | "Sesión cerrada por inactividad" |
 | body | "Tu sesión ha sido cerrada automáticamente..." |
 | severity | INFO |
 | created_by_system| True |
 And el sistema NO envía email (prohibido por restricciones)
 And el sistema NO incluye IP address (prohibido por restricciones)
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Timeout** | Inactividad permitida | 30 minutos exactos | Test |
| **Frecuencia Job** | Ejecución del job | Cada 5 minutos | Config |
| **Performance** | Procesamiento de cierre en lote | < 5 segundos para 100 sesiones | Load test |
| **Notificación** | Buzón interno | Obligatorio | Test |
| **Disponibilidad** | Scheduler disponible | 99.9% | Monitoreo |

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| SessionInactivityJob | `apps/authentication/jobs.py` | nuevo |
| update_session_activity | `apps/authentication/services.py` | nuevo |
| UserSession model | `apps/users/models.py` | existente |
| DjangoSession | django.contrib.sessions | existente |
| AuditLog model | `apps/audit/models.py` | existente |
| InternalMessage model | `apps/notifications/models.py` | nuevo |
| APScheduler config | `apps/authentication/apps.py` | nuevo |

### 3.2 Interfaces

#### 3.2.1 Configuración del Job (APScheduler)

```python
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import timedelta

# En apps/authentication/apps.py
class AuthenticationConfig(AppConfig):
 name = 'authentication'

 def ready(self):
 from .jobs import close_inactive_sessions

 scheduler = BackgroundScheduler()
 scheduler.add_job(
 close_inactive_sessions,
 'interval',
 minutes=5, # Cada 5 minutos exactos
 id='close_inactive_sessions',
 replace_existing=True,
 max_instances=1 # Solo una instancia a la vez
 )
 scheduler.start()
```

#### 3.2.2 API Python - update_session_activity

```python
def update_session_activity(user: User, request) -> None:
 """
 Actualizar last_activity_at en cada request válido

 Args:
 user: Usuario autenticado
 request: Request HTTP

 Returns:
 None
 """
 session = UserSession.objects.filter(
 user=user,
 is_active=True
 ).first()

 if session:
 session.last_activity_at = now()
 session.save(update_fields=['last_activity_at'])
```

#### 3.2.3 API Python - close_inactive_sessions (Job)

```python
from datetime import timedelta
from django.utils.timezone import now

def close_inactive_sessions() -> dict:
 """
 Job que cierra sesiones inactivas > 30 minutos

 Returns:
 dict con estadísticas de ejecución
 """
 timeout_limit = now() - timedelta(minutes=30)

 inactive_sessions = UserSession.objects.filter(
 is_active=True,
 last_activity_at__lt=timeout_limit
 )

 closed_count = 0
 for session in inactive_sessions:
 # Cerrar sesión
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'INACTIVITY_TIMEOUT'
 session.save()

 # Eliminar django_session
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 pass

 # Auditar
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

 # Notificar usuario
 InternalMessage.create(
 user_id=session.user_id,
 subject='Sesión cerrada por inactividad',
 body='Tu sesión ha sido cerrada automáticamente por inactividad '
 'de más de 30 minutos.\n\n'
 'Por seguridad, debes iniciar sesión nuevamente.',
 severity='INFO',
 created_by_system=True
 )

 closed_count += 1

 return {
 'closed_sessions': closed_count,
 'executed_at': now().isoformat()
 }
```

### 3.3 Reglas de Negocio

| ID | Regla | Descripción |
|----|-------|-------------|
| BR-RN-C01-06-01 | Timeout: 30 minutos exactos | No negociable |
| BR-RN-C01-06-02 | Actualizar last_activity_at | En cada request válido |
| BR-RN-C01-06-03 | Job cada 5 minutos | Intervalo fijo |
| BR-RN-C01-06-04 | Cerrar sesión automáticamente | is_active=False, logout_reason=INACTIVITY_TIMEOUT |
| BR-RN-C01-06-05 | Auditar cierre | evento SESSION_TIMEOUT |
| BR-RN-C01-06-06 | Notificar buzón interno | NO email, SIN IP address |
| BR-RN-C01-06-07 | Eliminar django_session | Limpiar tabla |

### 3.4 Validaciones

#### Validaciones del Job
- Timeout limit: exactamente 30 minutos
- Solo procesar sesiones con is_active=True
- Solo procesar sesiones con last_activity_at definido

#### Validaciones de Negocio
- Usuario debe existir para notificación
- Sesión debe estar activa para cerrar
- Auditoría obligatoria para cada cierre

### 3.5 Algoritmo Detallado

```python
from datetime import timedelta
from django.utils.timezone import now
from django.contrib.sessions.models import Session as DjangoSession

def close_inactive_sessions():
 """
 Job programado que cierra sesiones inactivas
 """
 # PASO 1: Calcular límite de timeout (30 minutos atrás)
 timeout_limit = now() - timedelta(minutes=30)

 # PASO 2: Obtener sesiones inactivas
 inactive_sessions = UserSession.objects.filter(
 is_active=True,
 last_activity_at__lt=timeout_limit
 )

 closed_count = 0

 # PASO 3: Iterar y cerrar cada sesión
 for session in inactive_sessions:
 # 3.1: Actualizar user_sessions
 session.is_active = False
 session.logged_out_at = now()
 session.logout_reason = 'INACTIVITY_TIMEOUT'
 session.save()

 # 3.2: Eliminar de django_session
 try:
 DjangoSession.objects.get(
 session_key=session.session_key
 ).delete()
 except DjangoSession.DoesNotExist:
 # Ya eliminada, continuar
 pass

 # 3.3: Auditar cierre (RN-C01-12)
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

 # 3.4: Notificar usuario vía buzón interno (NO email)
 InternalMessage.create(
 user_id=session.user_id,
 subject='Sesión cerrada por inactividad',
 body='Tu sesión ha sido cerrada automáticamente por inactividad '
 'de más de 30 minutos.\n\n'
 'Por seguridad, debes iniciar sesión nuevamente.',
 severity='INFO',
 created_by_system=True
 )

 closed_count += 1

 # PASO 4: Retornar estadísticas
 return {
 'closed_sessions': closed_count,
 'executed_at': now().isoformat()
 }
```

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

- UserSession model debe existir con last_activity_at
- APScheduler instalado (`pip install apscheduler`)
- AuditLog model debe existir
- InternalMessage model debe existir

### 4.2 Requisitos Relacionados

- **RF-005:** Login (crea sesiones)
- **RF-006:** Validación de Tokens (actualiza last_activity_at)
- **RF-007:** Logout Manual (cierre manual)

### 4.3 Restricciones del Proyecto

Del documento `restricciones_y_lineamientos.md`:

- **RESTR-001:** NO email - solo buzón interno
- **RESTR-003:** Sesiones en PostgreSQL
- **RESTR-008:** Auditoría obligatoria

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-008-001:** test_update_session_activity_actualiza_last_activity_at
 - Ubicación: `tests/authentication/test_inactivity.py`
 - Estado: pendiente

- [ ] **TEST-008-002:** test_sesion_inactiva_30_minutos_es_cerrada
 - Estado: pendiente

- [ ] **TEST-008-003:** test_sesion_activa_menor_30_minutos_no_es_cerrada
 - Estado: pendiente

- [ ] **TEST-008-004:** test_job_cierra_multiples_sesiones_en_lote
 - Estado: pendiente

- [ ] **TEST-008-005:** test_job_audita_evento_session_timeout
 - Estado: pendiente

- [ ] **TEST-008-006:** test_job_notifica_usuario_via_buzon_interno
 - Estado: pendiente

- [ ] **TEST-008-007:** test_job_elimina_django_session
 - Estado: pendiente

- [ ] **TEST-008-008:** test_usuario_reactiva_sesion_antes_cierre
 - Estado: pendiente

- [ ] **TEST-008-009:** test_access_token_valido_despues_cierre_inactividad
 - Estado: pendiente

- [ ] **TEST-008-010:** test_job_programado_cada_5_minutos
 - Estado: pendiente

### 5.2 Tests de Integración

- [ ] **TEST-008-INT-001:** test_flujo_completo_inactividad_30min_cierre
- [ ] **TEST-008-INT-002:** test_notificacion_recibida_en_buzon_interno

### 5.3 Tests de Performance

- [ ] **TEST-008-PERF-001:** test_job_procesa_100_sesiones_menor_5_segundos

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado
- [ ] 10 tests unitarios implementados y pasando
- [ ] Tests de integración implementados y pasando
- [ ] Coverage >= 95% para close_inactive_sessions
- [ ] Documentación técnica actualizada (este documento)
- [ ] Performance verificado (< 5s para 100 sesiones)
- [ ] Job programado configurado en APScheduler
- [ ] Auditoría verificada para evento SESSION_TIMEOUT
- [ ] Notificación por buzón interno verificada

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de las reglas de negocio:
- **RN-C01-06:** Cierre por Inactividad
- **RN-C01-12:** Auditoría de Login

### 7.2 Trazabilidad Downward (Derivados)

| Tipo | ID | Título | Ubicación |
|------|----|--------|-----------|
| Test | TEST-008 | Tests de inactividad | `tests/authentication/test_inactivity.py` |
| Código | IMPL-008 | close_inactive_sessions | `apps/authentication/jobs.py` |

## 8. Referencias

### 8.1 Documentos Relacionados

- Reglas de negocio: `docs/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (líneas 1015-1131)
- Restricciones: `docs/backend/requisitos/restricciones_y_lineamientos.md`

### 8.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018:** Clause 9.6 - Software Requirements Specification
- **OWASP ASVS:** Session Timeout Requirements

### 8.3 Bibliotecas

- **APScheduler:** https://apscheduler.readthedocs.io/

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-04 | claude | Documentación inicial basada en RN-C01-06 |
