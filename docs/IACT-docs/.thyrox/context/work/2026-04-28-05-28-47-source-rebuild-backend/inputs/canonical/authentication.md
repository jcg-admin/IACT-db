---
id: APP-AUTHENTICATION
tipo: django_app
dominio: backend
estado: documentado
fecha: 2025-11-06
auto_generado: true
ultima_actualizacion: 2025-11-06
version: 1.1
relacionados: [APP-USERS, APP-AUDIT, RF-003, RF-004, RF-009, RNF-001]
---

# Django App: authentication

## Descripción

App de Django dedicada a la **autenticación y seguridad** del sistema IACT. Proporciona funcionalidades para:
- Preguntas de seguridad para recuperación de contraseña
- Auditoría de intentos de inicio de sesión
- Prevención de ataques de fuerza bruta
- Cumplimiento con requisitos de seguridad ISO 27001

Esta app complementa el sistema de autenticación de Django con capas adicionales de seguridad requeridas para call centers.

## Estructura

```
api/callcentersite/callcentersite/apps/authentication/
 __init__.py
 apps.py
 models.py # Modelos de datos (SecurityQuestion, LoginAttempt)
 services.py # Lógica de negocio (LoginAttemptService)
 migrations/ # Migraciones de base de datos
```

## Modelos

### SecurityQuestion

**Propósito**: Preguntas de seguridad asociadas a usuarios para recuperación de cuenta sin email.

**Campos principales**:
- `user` (ForeignKey): Usuario asociado
- `question` (TextField): Pregunta de seguridad en texto libre
- `answer_hash` (CharField): Respuesta cifrada usando Django password hashing
- `created_at` (DateTimeField): Fecha de creación
- `updated_at` (DateTimeField): Última actualización

**Restricciones**:
- `unique_together`: (user, question) - Un usuario no puede tener la misma pregunta duplicada

**Métodos**:
- `set_answer(answer: str)`: Cifra y guarda la respuesta
- `verify_answer(answer: str) -> bool`: Verifica respuesta sin almacenarla en texto plano

**Ubicación**: `api/callcentersite/callcentersite/apps/authentication/models.py:11-38`

**Requisitos relacionados**: RF-006 (Recuperación sin email)

### LoginAttempt

**Propósito**: Registro de intentos de inicio de sesión para auditoría y prevención de ataques de fuerza bruta.

**Campos principales**:
- `ip_address` (GenericIPAddressField): IP desde donde se intentó el login
- `username` (CharField): Nombre de usuario que intentó login
- `success` (BooleanField): Si el intento fue exitoso
- `timestamp` (DateTimeField): Momento del intento
- `user_agent` (TextField): User-Agent del navegador/cliente
- `reason` (CharField, nullable): Razón de fallo si aplica

**Ordenamiento**: Descendente por timestamp (más recientes primero)

**Ubicación**: `api/callcentersite/callcentersite/apps/authentication/models.py:41-54`

**Requisitos relacionados**: RF-003 (Bloqueo intentos fallidos), RN-001 (Auditoría ISO 27001)

## Servicios

### LoginAttemptService

**Propósito**: Capa de servicio para gestionar intentos de login y detección de ataques.

**Métodos**:

#### `register_attempt(username, ip_address, user_agent, success, reason=None)`
Registra un intento de inicio de sesión para auditoría.

**Parámetros**:
- `username` (str): Usuario que intenta login
- `ip_address` (str): IP del cliente
- `user_agent` (str): User-Agent del navegador
- `success` (bool): Si fue exitoso
- `reason` (str, opcional): Razón de fallo

**Uso típico**:
```python
from apps.authentication.services import LoginAttemptService

LoginAttemptService.register_attempt(
 username="john.doe",
 ip_address="192.168.1.100",
 user_agent="Mozilla/5.0...",
 success=False,
 reason="Invalid credentials"
)
```

#### `count_recent_failures(username, window)`
Cuenta intentos fallidos recientes dentro de una ventana de tiempo.

**Parámetros**:
- `username` (str): Usuario a verificar
- `window` (timedelta): Ventana de tiempo a analizar

**Retorna**: int - Número de intentos fallidos

**Uso típico**:
```python
from datetime import timedelta
from apps.authentication.services import LoginAttemptService

failures = LoginAttemptService.count_recent_failures(
 username="john.doe",
 window=timedelta(minutes=15)
)

if failures >= 5:
 # Bloquear usuario temporalmente
 pass
```

**Ubicación**: `api/callcentersite/callcentersite/apps/authentication/services.py:11-35`

**Requisitos relacionados**: RF-003 (Bloqueo intentos fallidos)

## Endpoints REST

**Estado actual**: Esta app NO expone endpoints REST directamente.

Los modelos y servicios de esta app son utilizados por:
- **App `users`**: Para login/logout y gestión de sesiones
- **Middleware de autenticación**: Para registrar intentos automáticamente
- **Views de recuperación de contraseña**: Para validar preguntas de seguridad

**Integración típica**:
```python
# En users/views.py o authentication middleware
from apps.authentication.services import LoginAttemptService

class LoginView(APIView):
 def post(self, request):
 # ... lógica de autenticación ...

 LoginAttemptService.register_attempt(
 username=request.data.get('username'),
 ip_address=get_client_ip(request),
 user_agent=request.META.get('HTTP_USER_AGENT'),
 success=auth_successful,
 reason="Invalid password" if not auth_successful else None
 )
```

## Tests

[ATENCION] **WARNING**: No se detectaron tests automáticos.

**Tests requeridos (prioridad ALTA)**:
1. `test_security_question_set_answer()` - Verificar cifrado de respuestas
2. `test_security_question_verify_answer()` - Verificar validación correcta/incorrecta
3. `test_security_question_unique_constraint()` - Usuario no puede tener preguntas duplicadas
4. `test_login_attempt_registration()` - Registrar intento correctamente
5. `test_count_recent_failures()` - Contar solo dentro de ventana de tiempo
6. `test_count_recent_failures_boundary()` - Límites de ventana temporal
7. `test_password_hashing_security()` - Respuestas nunca almacenadas en texto plano

**Ver**: Plan de testing en DECISION #2

## Dependencias

### Dependencias Internas (Apps)
- **`users`**: Utiliza SecurityQuestion y LoginAttempt en flujos de autenticación
- **`audit`**: Puede leer LoginAttempt para reportes de seguridad

### Dependencias Externas (Django)
- `django.contrib.auth`: AUTH_USER_MODEL, password hashing
- `django.utils.timezone`: Manejo de timestamps
- `django.db.models`: ORM

### Configuración Requerida
```python
# settings.py
INSTALLED_APPS = [
 ...
 'apps.authentication',
]

# Configuración de seguridad (relacionada)
LOGIN_ATTEMPT_THRESHOLD = 5
LOGIN_ATTEMPT_WINDOW_MINUTES = 15
ACCOUNT_LOCKOUT_DURATION_MINUTES = 30
```

## Diagramas

### Flujo de Bloqueo por Intentos Fallidos

```

 Usuario 
 intenta 
 login 

 LoginAttemptService 
 .count_recent_failures() 

 ¿Más de 5 fallos en 15 min? 

 NO SÍ

 Permitir Bloquear cuenta 
 intento 30 minutos 

 LoginAttemptService 
 .register_attempt() 

 Guardar en LoginAttempt 

```

### Flujo de Recuperación con Preguntas de Seguridad

```

 Usuario 
 olvidó 
 password 

 1. Solicitar username 

 2. Mostrar preguntas de 
 SecurityQuestion del usuario 

 3. Usuario responde 

 4. SecurityQuestion 
 .verify_answer() 

 ¿Respuesta correcta? 

 SÍ NO

 Permitir Rechazar 
 reset de registrar intento
 password fallido 

```

## Cumplimiento de Requisitos

| Requisito | Descripción | Implementación |
|-----------|-------------|----------------|
| RF-003 | Bloqueo intentos fallidos | [OK] LoginAttemptService.count_recent_failures() |
| RF-006 | Recuperación sin email | [OK] SecurityQuestion con verify_answer() |
| RF-009 | Gestión passwords | [OK] Hashing seguro con Django password hashers |
| RN-001 | Auditoría ISO 27001 | [OK] LoginAttempt registra todos los intentos |
| RNF-001 | Tiempo respuesta login | [ATENCION] Requiere tests de performance |

## Métricas y Monitoreo

### Métricas Recomendadas

1. **Intentos de login fallidos por IP**: Detectar ataques distribuidos
2. **Usuarios con más de 3 intentos fallidos**: Alertar posibles cuentas comprometidas
3. **Tiempo promedio de verificación de respuestas**: Performance
4. **Preguntas de seguridad más utilizadas**: Mejorar UX

### Queries Útiles

```python
# Top 10 IPs con más intentos fallidos (último mes)
from django.utils import timezone
from datetime import timedelta
from apps.authentication.models import LoginAttempt

one_month_ago = timezone.now() - timedelta(days=30)

top_ips = (
 LoginAttempt.objects
 .filter(success=False, timestamp__gte=one_month_ago)
 .values('ip_address')
 .annotate(count=Count('id'))
 .order_by('-count')[:10]
)
```

## Seguridad

### Consideraciones de Seguridad

1. [OK] **Hashing de respuestas**: Usa `make_password()` de Django (bcrypt/PBKDF2)
2. [OK] **Protección contra timing attacks**: `check_password()` usa tiempo constante
3. [OK] **Auditoría completa**: Todos los intentos se registran con IP y user-agent
4. [ATENCION] **Rate limiting**: Implementar a nivel de middleware/nginx
5. [ATENCION] **CAPTCHA**: Considerar después de 3 intentos fallidos

### Vectores de Ataque Mitigados

- **Fuerza bruta**: Conteo de intentos + bloqueo temporal
- **Password cracking**: Respuestas hasheadas, nunca en texto plano
- **Session hijacking**: LoginAttempt permite detección de IPs sospechosas
- **Credential stuffing**: Detección de patrones anormales de login

## Notas

- Documentación generada automáticamente y completada manualmente
- Esta app es crítica para seguridad del sistema
- Requiere tests unitarios urgentemente (ver DECISION #2)
- Considerar migrar a django-axes o django-defender para rate limiting más robusto
- Evaluar implementar 2FA en futuro (TOTP, SMS)

## Referencias

- Requisitos: `docs/backend/requisitos/funcionales/rf003_bloqueo_intentos_fallidos.md`
- Requisitos: `docs/backend/requisitos/funcionales/rf006_recuperacion_sin_email.md`
- Requisitos: `docs/backend/requisitos/negocio/rn001_sistema_seguridad_auditoria_conforme_iso27001.md`
- ADR: `docs/adr/` (buscar ADRs relacionados con autenticación)

**Última actualización**: 2025-11-06
**Autor**: DocumentationSyncAgent + Revisión Manual
**Estado**: [OK] Documentación completa
