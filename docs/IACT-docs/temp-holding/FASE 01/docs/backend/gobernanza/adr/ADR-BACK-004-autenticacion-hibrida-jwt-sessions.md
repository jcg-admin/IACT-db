---
id: ADR-BACK-004-autenticacion-hibrida-jwt-sessions
estado: aceptada
propietario: equipo-backend
ultima_actualizacion: 2025-11-18
relacionados:
 - docs/backend/diseno_detallado/diseno_tecnico_autenticacion.md
 - docs/backend/arquitectura/authentication.md
 - ADR-BACK-001-grupos-funcionales-sin-jerarquia
tags: [autenticacion, seguridad, jwt, sessions, backend]
date: 2025-11-18
---

# ADR-BACK-004: Sistema de Autenticación Híbrido JWT + Sessions

**Estado:** Aceptada

**Fecha:** 2025-11-18

**Decisores:** equipo-backend, equipo-seguridad, arquitecto-principal

**Contexto técnico:** Backend - Autenticación y Seguridad

---

## Contexto y Problema

El sistema IACT requiere un mecanismo de autenticación robusto que soporte:

1. **API REST stateless** para integraciones y SPA frontend
2. **Control de sesiones activas** para auditoría y seguridad
3. **Cierre remoto de sesiones** por administradores
4. **Prevención de ataques** (fuerza bruta, concurrencia)
5. **Recuperación de cuenta** sin dependencia de email
6. **Auditoría completa** de intentos de login (ISO 27001)

**Preguntas clave:**
- ¿Cómo balancear API stateless con control de sesiones?
- ¿Cómo prevenir ataques de fuerza bruta?
- ¿Cómo permitir cierre remoto de sesiones en API stateless?
- ¿Cómo recuperar cuentas sin email (call center interno)?
- ¿Cómo auditar todos los intentos de login?

**Restricciones actuales:**
- API REST con Django REST Framework
- PostgreSQL para persistencia
- Requisitos ISO 27001 de auditoría
- NO usar Redis (requisito RNF-002)
- Usuarios internos sin email corporativo

**Impacto del problema:**
- **Seguridad**: Ataques de fuerza bruta pueden comprometer cuentas
- **Compliance**: ISO 27001 requiere trazabilidad de accesos
- **Operaciones**: Necesidad de cerrar sesiones remotamente en caso de incidentes
- **UX**: Recuperación de cuenta sin email debe ser segura

---

## Factores de Decisión

- **Seguridad**: Prevención de ataques, tokens seguros
- **Auditoría**: Trazabilidad completa (ISO 27001)
- **Performance**: Autenticación rápida (< 100ms)
- **Control de sesiones**: Cierre remoto, límite de concurrencia
- **Recuperación**: Mecanismo sin email
- **Simplicidad**: Fácil de implementar y mantener
- **Escalabilidad**: Soporte 100-500 usuarios concurrentes
- **Stateless**: API debe ser stateless para escalabilidad

---

## Opciones Consideradas

### Opción 1: Django Sessions Exclusivamente

**Descripción:**
Usar únicamente Django sessions con cookies de sesión tradicionales.

**Pros:**
- OK Integración nativa con Django
- OK Control total de sesiones
- OK Fácil cierre remoto
- OK Auditoría integrada

**Contras:**
- NO NO es stateless (problemas para API)
- NO Dificulta integraciones externas
- NO Cookies no funcionan bien en apps móviles
- NO Menos flexible para SPA

**Ejemplo:**
```python
# Login tradicional con sessions
def login_view(request):
 user = authenticate(username=username, password=password)
 if user:
 login(request, user) # Crea sesión
 return redirect('dashboard')
```

**Razón del rechazo:**
No es stateless, dificulta integraciones API y SPA.

---

### Opción 2: JWT Tokens Exclusivamente

**Descripción:**
Usar únicamente JWT (JSON Web Tokens) para autenticación stateless pura.

**Pros:**
- OK Stateless puro
- OK Escalabilidad horizontal fácil
- OK Funciona en cualquier cliente (web, mobile, desktop)
- OK No requiere storage en servidor

**Contras:**
- NO Difícil cierre remoto de sesiones (token sigue válido)
- NO No hay control de concurrencia
- NO Auditoría limitada (solo en login)
- NO Token revocation complejo (requiere blacklist)

**Ejemplo:**
```python
# JWT puro
from rest_framework_simplejwt.tokens import RefreshToken

def login_view(request):
 user = authenticate(username=username, password=password)
 if user:
 refresh = RefreshToken.for_user(user)
 return Response({
 'access': str(refresh.access_token),
 'refresh': str(refresh)
 })
```

**Razón del rechazo:**
No permite cierre remoto de sesiones ni control de concurrencia requerido por seguridad.

---

### Opción 3: OAuth2 / OpenID Connect

**Descripción:**
Implementar OAuth2 con servidor de autorización dedicado.

**Pros:**
- OK Estándar de industria
- OK Soporte para integraciones externas
- OK Separación de concerns

**Contras:**
- NO Complejidad extrema para call center interno
- NO Overkill para necesidades actuales
- NO Requiere servidor de autorización adicional
- NO Curva de aprendizaje alta

**Razón del rechazo:**
Complejidad injustificada para sistema interno de call center.

---

### Opción 4: Sistema Híbrido JWT + Sessions (ELEGIDA)

**Descripción:**
Combinar JWT para autenticación API stateless con Django Sessions para control de sesiones y auditoría.

**Arquitectura:**
```

 Usuario / Cliente 

 v

 API Endpoint 

 v

 JWT Authentication Middleware 
 - Valida access token 
 - Extrae usuario del token 

 v

 UserSession Model 
 - Registro de sesión activa 
 - Metadata (IP, user agent) 
 - Control de concurrencia 

 v

 Django Session (DB-backed) 
 - Control de sesiones 
 - Cierre remoto 

```

**Componentes:**

1. **JWT Tokens** (Autenticación API):
 - Access token (corta duración: 15-30 min)
 - Refresh token (larga duración: 7-30 días)
 - Token blacklist para invalidación

2. **Django Sessions** (Control):
 - Tracking de sesiones activas
 - Cierre remoto
 - Límite de sesiones concurrentes

3. **UserSession Model** (Auditoría):
 - Registro de todas las sesiones
 - Metadata: IP, user agent, dispositivo
 - Timestamp de login/logout

4. **LoginAttempt Model** (Seguridad):
 - Todos los intentos de login
 - Detección de ataques de fuerza bruta
 - Rate limiting por IP

5. **SecurityQuestion Model** (Recuperación):
 - Preguntas de seguridad
 - Respuestas hasheadas
 - Recuperación sin email

**Pros:**
- OK Stateless API (JWT)
- OK Control de sesiones (Django Sessions)
- OK Cierre remoto posible
- OK Auditoría completa
- OK Prevención fuerza bruta
- OK Recuperación sin email
- OK Balance flexibilidad/control

**Contras:**
- NO Mayor complejidad (2 sistemas)
- NO Más tablas en BD
- NO Requiere sincronización JWT <-> Sessions

**Ejemplo/Implementación:**
```python
# Login endpoint
class LoginView(APIView):
 def post(self, request):
 username = request.data.get('username')
 password = request.data.get('password')

 # Validar rate limiting
 if LoginAttemptService.is_blocked(request.META['REMOTE_ADDR']):
 return Response({'error': 'Too many attempts'}, status=429)

 # Autenticar
 user = authenticate(username=username, password=password)

 if user:
 # Generar JWT
 refresh = RefreshToken.for_user(user)
 access_token = str(refresh.access_token)

 # Crear sesión Django
 login(request, user)

 # Registrar UserSession
 UserSession.objects.create(
 user=user,
 session_key=request.session.session_key,
 ip_address=request.META['REMOTE_ADDR'],
 user_agent=request.META.get('HTTP_USER_AGENT', ''),
 last_activity=timezone.now()
 )

 # Auditar intento exitoso
 LoginAttemptService.register_attempt(
 username=username,
 ip_address=request.META['REMOTE_ADDR'],
 user_agent=request.META.get('HTTP_USER_AGENT', ''),
 success=True
 )

 return Response({
 'access': access_token,
 'refresh': str(refresh),
 'user': UserSerializer(user).data
 })
 else:
 # Auditar intento fallido
 LoginAttemptService.register_attempt(
 username=username,
 ip_address=request.META['REMOTE_ADDR'],
 user_agent=request.META.get('HTTP_USER_AGENT', ''),
 success=False,
 reason='Invalid credentials'
 )

 return Response({'error': 'Invalid credentials'}, status=401)

# Cierre remoto de sesión
class ForceLogoutView(APIView):
 permission_classes = [IsAdmin]

 def post(self, request, user_id):
 # Invalidar todas las sesiones del usuario
 UserSession.objects.filter(user_id=user_id, active=True).update(
 active=False,
 logout_timestamp=timezone.now()
 )

 # Agregar tokens a blacklist
 # (tokens existentes dejarán de funcionar)

 return Response({'status': 'User logged out remotely'})

# Job de cierre automático de sesiones inactivas
@scheduled_job('interval', hours=1)
def close_inactive_sessions():
 timeout = timedelta(hours=8)
 threshold = timezone.now() - timeout

 inactive_sessions = UserSession.objects.filter(
 active=True,
 last_activity__lt=threshold
 )

 for session in inactive_sessions:
 session.active = False
 session.logout_timestamp = timezone.now()
 session.save()

 # Notificar usuario
 InternalMessage.objects.create(
 user=session.user,
 subject='Sesión cerrada por inactividad',
 body=f'Tu sesión fue cerrada después de {timeout.hours} horas de inactividad.'
 )
```

---

## Decisión

**Opción elegida:** "Sistema Híbrido JWT + Sessions"

**Justificación:**

1. **Stateless + Control**: JWT para API stateless, Sessions para control de sesiones

2. **Cierre remoto**: Posible gracias a UserSession model y token blacklist

3. **Auditoría completa**: LoginAttempt registra todos los intentos, UserSession todas las sesiones

4. **Seguridad**: Rate limiting, detección fuerza bruta, límite concurrencia

5. **Recuperación**: SecurityQuestion permite recuperación sin email

6. **Flexibilidad**: Soporta web, mobile, integraciones externas

**Trade-offs aceptados:**
- Mayor complejidad vs sistemas puros
- Más tablas en BD (pero necesarias para requisitos)
- Sincronización JWT <-> Sessions (mitigado con service layer)

---

## Consecuencias

### Positivas

- OK API stateless escalable horizontalmente
- OK Control total de sesiones activas
- OK Cierre remoto de sesiones posible
- OK Auditoría completa (ISO 27001)
- OK Prevención de ataques de fuerza bruta
- OK Recuperación de cuenta sin email
- OK Rate limiting por IP
- OK Límite de sesiones concurrentes

### Negativas

- WARNING Mayor complejidad de implementación
- WARNING Más tablas en BD (UserSession, LoginAttempt, SecurityQuestion)
- WARNING Requiere sincronización JWT <-> Sessions
- WARNING Testing más complejo (2 sistemas)

### Neutrales

- INFO APScheduler para jobs de limpieza
- INFO Token blacklist crece con tiempo (requiere limpieza periódica)
- INFO Notificaciones internas para cierre de sesiones

---

## Plan de Implementación

1. **Fase 1: Modelos y Migrations**
 - UserSession model
 - LoginAttempt model
 - SecurityQuestion model
 - Migrations
 - Timeframe: 2 días

2. **Fase 2: JWT Integration**
 - django-rest-framework-simplejwt
 - Token blacklist
 - Access + Refresh tokens
 - Timeframe: 2 días

3. **Fase 3: Service Layer**
 - AuthenticationService
 - LoginAttemptService
 - TokenService
 - Timeframe: 3 días

4. **Fase 4: Endpoints**
 - LoginView
 - LogoutView
 - RefreshTokenView
 - ForceLogoutView
 - Timeframe: 2 días

5. **Fase 5: Jobs y Limpieza**
 - APScheduler setup
 - close_inactive_sessions job
 - clean_old_login_attempts job
 - Timeframe: 1 día

6. **Fase 6: Testing y Documentación**
 - Tests unitarios
 - Tests de integración
 - Documentación técnica
 - Timeframe: 3 días

**Total:** ~13 días (2.5 semanas)

---

## Validación y Métricas

**Criterios de Éxito:**
- Autenticación: < 100ms (p95)
- Login attempts bloqueados: > 95% de ataques detectados
- Auditoría: 100% de intentos registrados
- Cierre remoto: < 5 segundos efectivo
- Tests coverage: > 90%

**Cómo medir:**
- Performance monitoring de endpoints
- Análisis de LoginAttempt para detectar patterns
- Audit log review mensual
- Tests de penetración periódicos

**Revisión:**
- Fecha de revisión programada: 2026-02-18 (3 meses post-implementación)
- Responsable de seguimiento: equipo-backend

---

## Alternativas Descartadas

### Session-based Authentication con API Keys

**Por qué se descartó:**
- API keys no son adecuados para usuarios finales
- Dificulta integraciones modernas (SPA, mobile)

### SAML / LDAP Integration

**Por qué se descartó:**
- Overkill para call center interno
- No hay infraestructura AD/LDAP existente

---

## Referencias

- [Diseño Técnico Autenticación](../../diseno_detallado/diseno_tecnico_autenticacion.md)
- [App Authentication](../../arquitectura/authentication.md)
- [ADR-BACK-001: Grupos Funcionales](ADR-BACK-001-grupos-funcionales-sin-jerarquia.md)
- [django-rest-framework-simplejwt](https://django-rest-framework-simplejwt.readthedocs.io/)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

---

## Notas Adicionales

**Fecha de discusión inicial:** 2025-11-04
**Implementación completada**: 2025-11-09

**Configuraciones de seguridad:**
- Access token lifetime: 30 minutos
- Refresh token lifetime: 7 días
- Max login attempts: 5
- Lockout duration: 15 minutos
- Session timeout: 8 horas
- Max concurrent sessions: 3

**Jobs programados:**
- `close_inactive_sessions`: Cada 1 hora
- `clean_old_login_attempts`: Cada 24 horas
- `clean_token_blacklist`: Cada semana

---

**Documento:** ADR-BACK-004
**Fecha:** 18 de Noviembre, 2025
**Estado:** Aceptada e Implementada
**Próxima revisión:** 2026-02-18
