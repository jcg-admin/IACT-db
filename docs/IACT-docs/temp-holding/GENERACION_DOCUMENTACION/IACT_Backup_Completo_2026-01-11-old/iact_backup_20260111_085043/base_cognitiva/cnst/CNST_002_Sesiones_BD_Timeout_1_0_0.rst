.. _CNST_002:

============================================================
CNST_002 - Sesiones en BD, Única, Timeout 15 Minutos
============================================================

:Restricción: CNST_002
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: CRÍTICA
:Ámbito: MOD_Auth - Gestión de sesiones
:Fundamento: Seguridad y control de acceso
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_005 (RBAC), CNST_008 (Auditoría)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **El Sistema IACT gestiona sesiones de usuario con las siguientes 
   características obligatorias:**
   
   1. **Almacenamiento en Base de Datos:** Las sesiones se almacenan en 
      MySQL (NO en Redis, Memcached u otros sistemas de caché)
   
   2. **Sesión Única:** Un usuario solo puede tener UNA sesión activa 
      simultáneamente. Al iniciar sesión, cualquier sesión previa se 
      invalida automáticamente.
   
   3. **Timeout de Inactividad:** Las sesiones expiran automáticamente 
      después de 15 minutos de inactividad.
   
   4. **Persistencia:** Las sesiones persisten en BD para auditoría y 
      trazabilidad completa.

1.2 Justificación
------------------

**Seguridad:**

- Prevención de acceso concurrente no autorizado
- Forzar cierre de sesiones antiguas/olvidadas
- Trazabilidad completa de accesos (auditoría)
- Reducción de superficie de ataque (menos sesiones = menos vectores)

**Cumplimiento:**

- Facilita auditorías de seguridad
- Registro inmutable de todas las sesiones (CNST_008)
- Control de acceso estricto

**Simplicidad:**

- No requiere infraestructura adicional (Redis)
- Modelo de datos simple y predecible
- Fácil debugging y troubleshooting

1.3 Impacto General
--------------------

.. list-table:: Impacto de CNST_002
   :header-rows: 1
   :widths: 30 70

   * - Aspecto
     - Impacto
   * - **Usuario Final**
     - • Solo 1 sesión activa a la vez
       • Auto-logout a los 15 min de inactividad
       • Sesión anterior cerrada al hacer login nuevo
   * - **Módulo Afectado**
     - MOD_Auth (gestión de sesiones)
   * - **Funciones RBAC**
     - • AUT-001: gestiona_sesiones
       • AUT-002: cierra_sesion_usuario
       • AUT-004: ve_sesiones_activas
   * - **Infraestructura**
     - • NO requiere Redis/Memcached
       • Tabla sessions en MySQL
       • Cron job para limpieza de sesiones expiradas
   * - **Performance**
     - • Overhead mínimo (BD ya usada)
       • No latencia de red adicional
       • Cache de sesión en memoria de aplicación (opcional)

============================================================
2. ESPECIFICACIÓN TÉCNICA
============================================================

2.1 Características de Sesión
-------------------------------

**2.1.1 Almacenamiento en Base de Datos**

.. code-block:: yaml

   Motor: MySQL 8.0+
   Tabla: sessions
   Engine: InnoDB
   Transaccional: Sí
   
   Razón:
     - Persistencia garantizada
     - Transacciones ACID
     - Auditoría completa
     - No dependencia de servicios externos

**2.1.2 Sesión Única por Usuario**

.. code-block:: yaml

   Regla: 1 usuario = 1 sesión activa máximo
   
   Comportamiento:
     - Al iniciar sesión:
       1. Validar credenciales
       2. Invalidar TODAS las sesiones previas del usuario
       3. Crear nueva sesión
       4. Registrar en auditoría
     
     - Al detectar sesión concurrente:
       1. Mantener solo la MÁS RECIENTE
       2. Invalidar sesiones antiguas
       3. Notificar en buzón interno (opcional)
   
   Excepciones: NINGUNA
   
   Justificación:
     - Prevenir compartir credenciales
     - Detectar accesos no autorizados
     - Simplificar gestión de sesiones
     - Facilitar auditoría

**2.1.3 Timeout de Inactividad: 15 Minutos**

.. code-block:: yaml

   Timeout: 15 minutos (900 segundos)
   Medición: Desde última actividad del usuario
   
   Actividad definida como:
     - Cualquier petición HTTP autenticada
     - Click en interfaz
     - Llamada a API
     - Refresh de página
   
   NO cuenta como actividad:
     - Polling de WebSocket (si existiera)
     - Heartbeat automático del navegador
     - Requests de assets estáticos (CSS, JS, imágenes)
   
   Comportamiento al expirar:
     - Estado sesión = EXPIRED
     - Usuario redirigido a /login
     - Mensaje: "Sesión expirada por inactividad"
     - Registro en audit_logs
   
   Cálculo:
     ultima_actividad + 15 min < ahora → EXPIRED

**2.1.4 Persistencia para Auditoría**

.. code-block:: yaml

   Retención:
     - Sesiones activas: Indefinido (hasta logout/expire)
     - Sesiones cerradas: Mínimo 2 años (CNST_008)
     - Sesiones expiradas: Mínimo 2 años (CNST_008)
   
   Datos registrados:
     - session_id (UUID)
     - usuario_id
     - fecha_inicio
     - fecha_ultima_actividad
     - fecha_fin (logout/expire/invalidacion)
     - estado (ACTIVE, EXPIRED, LOGGED_OUT, INVALIDATED)
     - ip_address
     - user_agent
     - motivo_fin (user_logout, timeout, concurrent_login, admin_close)
   
   Uso:
     - Auditorías de seguridad
     - Investigación de incidentes
     - Análisis de patrones de uso
     - Compliance SOX

2.2 Estados de Sesión
-----------------------

.. code-block:: text

   ┌─────────────────────────────────────────────────────────┐
   │               DIAGRAMA DE ESTADOS DE SESIÓN              │
   └─────────────────────────────────────────────────────────┘
   
                    [LOGIN EXITOSO]
                           │
                           ▼
                    ┌──────────────┐
              ┌────►│   ACTIVE     │◄────┐
              │     └──────────────┘     │
              │            │              │
              │            │              │
   [ACTIVIDAD │            │ [15 min     │ [LOGOUT
    DEL USER] │            │  inactividad│  MANUAL]
              │            │  o CONCUR-   │
              │            │  RENT LOGIN] │
              │            ▼              │
              │     ┌──────────────┐     │
              │     │   EXPIRED /  │     │
              │     │ INVALIDATED  │     │
              │     └──────────────┘     │
              │            │              │
              │            ▼              │
              │     ┌──────────────┐     │
              └─────┤ LOGGED_OUT   │◄────┘
                    └──────────────┘
                           │
                           ▼
                    [FIN - Auditoría]

**Descripción de estados:**

.. list-table:: Estados de Sesión
   :header-rows: 1
   :widths: 20 80

   * - Estado
     - Descripción
   * - **ACTIVE**
     - Sesión válida y activa. Usuario autenticado y dentro del timeout.
   * - **EXPIRED**
     - Sesión expirada por inactividad (>15 min sin actividad).
   * - **INVALIDATED**
     - Sesión invalidada por login concurrent o cierre administrativo.
   * - **LOGGED_OUT**
     - Sesión cerrada normalmente por el usuario (logout manual).

2.3 Flujo de Autenticación
----------------------------

.. code-block:: text

   FLUJO DE LOGIN (con sesión única)
   ═════════════════════════════════════════════════════════
   
   1. Usuario envía credenciales
      POST /auth/login
      { username, password }
   
   2. Validar credenciales
      ├─ Hash password vs BD
      └─ Si válido: continuar
         Si inválido: return 401 Unauthorized
   
   3. Invalidar sesiones previas (SESIÓN ÚNICA)
      UPDATE sessions
      SET estado = 'INVALIDATED',
          fecha_fin = NOW(),
          motivo_fin = 'concurrent_login'
      WHERE usuario_id = :user_id
        AND estado = 'ACTIVE'
   
   4. Crear nueva sesión
      INSERT INTO sessions (
          session_id,
          usuario_id,
          fecha_inicio,
          fecha_ultima_actividad,
          estado,
          ip_address,
          user_agent
      ) VALUES (
          UUID(),
          :user_id,
          NOW(),
          NOW(),
          'ACTIVE',
          :ip,
          :user_agent
      )
   
   5. Generar token JWT
      {
        "sub": user_id,
        "session_id": session_id,
        "iat": timestamp,
        "exp": timestamp + 15*60  # 15 minutos
      }
   
   6. Registrar en auditoría
      INSERT INTO audit_logs (
          usuario_id,
          accion = 'LOGIN',
          resultado = 'SUCCESS',
          ip_address,
          metadata = { session_id, previous_sessions_closed }
      )
   
   7. Retornar token al cliente
      {
        "access_token": jwt_token,
        "token_type": "Bearer",
        "expires_in": 900  # 15 min en segundos
      }

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 AUT-001: gestiona_sesiones
--------------------------------

.. code-block:: yaml

   Función: gestiona_sesiones
   Capacidad: auth:sesiones
   Módulo: MOD_Auth
   
   Acciones permitidas:
     - Ver todas las sesiones activas del sistema
     - Ver detalles de cada sesión:
       * Usuario
       * Fecha inicio
       * Última actividad
       * IP address
       * User agent
       * Estado
     - Cerrar sesión de usuario específico
     - Cerrar todas las sesiones (emergencia)
   
   Restricción CNST_002:
     ✓ Solo muestra sesiones en BD (no cache)
     ✓ Puede invalidar sesiones manualmente
     ✓ Respeta límite de 1 sesión por usuario
   
   Caso de Uso: UC-005
   Código de ejemplo: Ver sección 6.1

3.2 AUT-002: cierra_sesion_usuario
------------------------------------

.. code-block:: yaml

   Función: cierra_sesion_usuario
   Capacidad: auth:cerrar_sesion
   Módulo: MOD_Auth
   
   Acciones permitidas:
     - Cerrar sesión de otro usuario (admin)
     - Invalidar sesión específica por session_id
     - Registrar motivo del cierre
   
   Proceso:
     1. Validar que usuario admin tiene función AUT-002
     2. Validar que sesión objetivo existe y está ACTIVE
     3. Actualizar sesión:
        - estado = INVALIDATED
        - fecha_fin = NOW()
        - motivo_fin = 'admin_close'
        - cerrada_por = admin_user_id
     4. Registrar en auditoría (nivel WARNING)
     5. Notificar usuario afectado en buzón interno
   
   Restricción CNST_002:
     ✓ Afecta sesión en BD inmediatamente
     ✓ Usuario afectado no puede continuar
   
   Caso de Uso: UC-005

3.3 AUT-004: ve_sesiones_activas
----------------------------------

.. code-block:: yaml

   Función: ve_sesiones_activas
   Capacidad: auth:ver_sesiones
   Módulo: MOD_Auth
   
   Acciones permitidas:
     - Ver listado de sesiones activas
     - Filtrar por:
       * Usuario
       * Fecha de inicio
       * IP address
       * Estado
     - Exportar listado (CSV)
   
   Información mostrada:
     - session_id
     - Usuario (username)
     - Fecha inicio
     - Última actividad
     - Tiempo restante antes de timeout
     - IP address
     - User agent (navegador)
     - Estado
   
   Restricción CNST_002:
     ✓ Solo 1 sesión por usuario visible
     ✓ Timeout calculado dinámicamente
   
   Caso de Uso: UC-005

============================================================
4. MODELO DE DATOS
============================================================

4.1 Tabla: sessions
--------------------

.. code-block:: sql

   CREATE TABLE sessions (
       session_id CHAR(36) PRIMARY KEY,  -- UUID
       usuario_id INT NOT NULL,
       fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       fecha_ultima_actividad DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       fecha_fin DATETIME,
       estado ENUM('ACTIVE', 'EXPIRED', 'INVALIDATED', 'LOGGED_OUT') 
           NOT NULL DEFAULT 'ACTIVE',
       ip_address VARCHAR(45) NOT NULL,  -- IPv6 support
       user_agent VARCHAR(500),
       motivo_fin ENUM(
           'user_logout', 
           'timeout', 
           'concurrent_login', 
           'admin_close'
       ),
       cerrada_por INT,  -- usuario_id del admin si admin_close
       metadata JSON,  -- Datos adicionales
       
       CONSTRAINT fk_session_usuario FOREIGN KEY (usuario_id) 
           REFERENCES usuarios(usuario_id),
       CONSTRAINT fk_session_cerrada_por FOREIGN KEY (cerrada_por) 
           REFERENCES usuarios(usuario_id),
       
       -- Índices para performance
       INDEX idx_session_usuario (usuario_id),
       INDEX idx_session_estado (estado),
       INDEX idx_session_fecha_inicio (fecha_inicio DESC),
       INDEX idx_session_ultima_actividad (fecha_ultima_actividad DESC),
       
       -- Índice único para sesión única activa
       UNIQUE INDEX uk_usuario_activo (usuario_id, estado)
           WHERE estado = 'ACTIVE',
       
       -- Validación de timeout
       CONSTRAINT chk_timeout CHECK (
           fecha_ultima_actividad >= fecha_inicio
       ),
       CONSTRAINT chk_fecha_fin CHECK (
           fecha_fin IS NULL OR fecha_fin >= fecha_inicio
       )
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.2 Trigger: Validación Sesión Única
--------------------------------------

.. code-block:: sql

   -- Trigger para garantizar sesión única
   -- Invalida automáticamente sesiones previas al crear una nueva
   
   DELIMITER $$
   
   CREATE TRIGGER trg_sessions_before_insert
   BEFORE INSERT ON sessions
   FOR EACH ROW
   BEGIN
       -- Si se está creando una sesión ACTIVE
       IF NEW.estado = 'ACTIVE' THEN
           -- Invalidar todas las sesiones activas previas del mismo usuario
           UPDATE sessions
           SET estado = 'INVALIDATED',
               fecha_fin = NOW(),
               motivo_fin = 'concurrent_login'
           WHERE usuario_id = NEW.usuario_id
             AND estado = 'ACTIVE'
             AND session_id != NEW.session_id;
       END IF;
   END$$
   
   DELIMITER ;

4.3 Vista: Sesiones Activas con Timeout
-----------------------------------------

.. code-block:: sql

   CREATE VIEW vw_sesiones_activas AS
   SELECT 
       s.session_id,
       s.usuario_id,
       u.username,
       u.email,
       s.fecha_inicio,
       s.fecha_ultima_actividad,
       s.ip_address,
       s.user_agent,
       s.estado,
       
       -- Tiempo de inactividad en minutos
       TIMESTAMPDIFF(MINUTE, s.fecha_ultima_actividad, NOW()) 
           AS minutos_inactivo,
       
       -- Tiempo restante antes de timeout (en minutos)
       GREATEST(
           0,
           15 - TIMESTAMPDIFF(MINUTE, s.fecha_ultima_actividad, NOW())
       ) AS minutos_restantes,
       
       -- Indicador de sesión a punto de expirar (< 5 min)
       CASE 
           WHEN TIMESTAMPDIFF(MINUTE, s.fecha_ultima_actividad, NOW()) > 10
           THEN TRUE
           ELSE FALSE
       END AS proxima_a_expirar,
       
       -- Indicador de sesión expirada pero no marcada aún
       CASE 
           WHEN TIMESTAMPDIFF(MINUTE, s.fecha_ultima_actividad, NOW()) > 15
           THEN TRUE
           ELSE FALSE
       END AS deberia_expirar
       
   FROM sessions s
   INNER JOIN usuarios u ON s.usuario_id = u.usuario_id
   WHERE s.estado = 'ACTIVE'
   ORDER BY s.fecha_ultima_actividad DESC;

============================================================
5. IMPLEMENTACIÓN DJANGO
============================================================

5.1 Modelo de Sesión
----------------------

.. code-block:: python

   # file: auth/models.py
   from django.db import models
   from django.utils import timezone
   from datetime import timedelta
   import uuid
   
   class Session(models.Model):
       """
       Modelo de sesión de usuario.
       
       Implementa CNST_002: Sesión única, timeout 15 min, en BD.
       """
       
       ESTADOS = [
           ('ACTIVE', 'Activa'),
           ('EXPIRED', 'Expirada'),
           ('INVALIDATED', 'Invalidada'),
           ('LOGGED_OUT', 'Cerrada por usuario'),
       ]
       
       MOTIVOS_FIN = [
           ('user_logout', 'Logout manual del usuario'),
           ('timeout', 'Timeout por inactividad'),
           ('concurrent_login', 'Login concurrente'),
           ('admin_close', 'Cerrada por administrador'),
       ]
       
       session_id = models.UUIDField(
           primary_key=True, 
           default=uuid.uuid4, 
           editable=False
       )
       usuario = models.ForeignKey(
           'users.Usuario', 
           on_delete=models.CASCADE,
           related_name='sesiones'
       )
       fecha_inicio = models.DateTimeField(auto_now_add=True)
       fecha_ultima_actividad = models.DateTimeField(auto_now_add=True)
       fecha_fin = models.DateTimeField(null=True, blank=True)
       estado = models.CharField(
           max_length=20, 
           choices=ESTADOS, 
           default='ACTIVE'
       )
       ip_address = models.GenericIPAddressField()
       user_agent = models.CharField(max_length=500, blank=True)
       motivo_fin = models.CharField(
           max_length=50, 
           choices=MOTIVOS_FIN, 
           null=True, 
           blank=True
       )
       cerrada_por = models.ForeignKey(
           'users.Usuario',
           on_delete=models.SET_NULL,
           null=True,
           blank=True,
           related_name='sesiones_cerradas_por_mi'
       )
       metadata = models.JSONField(default=dict, blank=True)
       
       class Meta:
           db_table = 'sessions'
           ordering = ['-fecha_inicio']
           indexes = [
               models.Index(fields=['usuario', 'estado']),
               models.Index(fields=['fecha_ultima_actividad']),
           ]
       
       def __str__(self):
           return f"Sesión {self.session_id} - {self.usuario.username}"
       
       @property
       def minutos_inactivo(self):
           """Minutos desde última actividad."""
           delta = timezone.now() - self.fecha_ultima_actividad
           return int(delta.total_seconds() / 60)
       
       @property
       def minutos_restantes(self):
           """Minutos restantes antes de timeout (15 min)."""
           return max(0, 15 - self.minutos_inactivo)
       
       @property
       def esta_expirada(self):
           """True si ha pasado más de 15 minutos de inactividad."""
           return self.minutos_inactivo > 15
       
       @property
       def proxima_a_expirar(self):
           """True si quedan menos de 5 minutos."""
           return 10 <= self.minutos_inactivo < 15
       
       def actualizar_actividad(self):
           """Actualiza fecha de última actividad (reset del timeout)."""
           self.fecha_ultima_actividad = timezone.now()
           self.save(update_fields=['fecha_ultima_actividad'])
       
       def invalidar(self, motivo='concurrent_login', cerrada_por=None):
           """
           Invalida la sesión.
           
           Args:
               motivo: Razón de invalidación
               cerrada_por: Usuario que cerró (si es admin_close)
           """
           self.estado = 'INVALIDATED'
           self.fecha_fin = timezone.now()
           self.motivo_fin = motivo
           self.cerrada_por = cerrada_por
           self.save(update_fields=[
               'estado', 'fecha_fin', 'motivo_fin', 'cerrada_por'
           ])
       
       def logout(self):
           """Cierre normal de sesión por el usuario."""
           self.estado = 'LOGGED_OUT'
           self.fecha_fin = timezone.now()
           self.motivo_fin = 'user_logout'
           self.save(update_fields=['estado', 'fecha_fin', 'motivo_fin'])
       
       def expirar(self):
           """Marca la sesión como expirada por timeout."""
           self.estado = 'EXPIRED'
           self.fecha_fin = timezone.now()
           self.motivo_fin = 'timeout'
           self.save(update_fields=['estado', 'fecha_fin', 'motivo_fin'])
       
       @classmethod
       def crear_sesion(cls, usuario, ip_address, user_agent=''):
           """
           Crea una nueva sesión, invalidando sesiones previas.
           
           Implementa CNST_002: Sesión única.
           
           Args:
               usuario: Instancia de Usuario
               ip_address: IP del cliente
               user_agent: User-Agent del navegador
           
           Returns:
               Session: Nueva sesión creada
           """
           # 1. Invalidar sesiones activas previas (SESIÓN ÚNICA)
           sesiones_previas = cls.objects.filter(
               usuario=usuario,
               estado='ACTIVE'
           )
           
           count_invalidadas = 0
           for sesion in sesiones_previas:
               sesion.invalidar(motivo='concurrent_login')
               count_invalidadas += 1
           
           # 2. Crear nueva sesión
           nueva_sesion = cls.objects.create(
               usuario=usuario,
               ip_address=ip_address,
               user_agent=user_agent,
               metadata={
                   'sesiones_previas_invalidadas': count_invalidadas
               }
           )
           
           # 3. Registrar en auditoría
           from core.models import AuditLog
           AuditLog.objects.create(
               usuario=usuario,
               accion='LOGIN',
               modulo='MOD_Auth',
               resultado='SUCCESS',
               ip_address=ip_address,
               detalles={
                   'session_id': str(nueva_sesion.session_id),
                   'sesiones_previas_invalidadas': count_invalidadas
               }
           )
           
           return nueva_sesion
       
       @classmethod
       def limpiar_sesiones_expiradas(cls):
           """
           Marca como EXPIRED las sesiones con >15 min de inactividad.
           
           Ejecutar via cron cada 5 minutos.
           
           Returns:
               int: Cantidad de sesiones expiradas
           """
           limite = timezone.now() - timedelta(minutes=15)
           
           sesiones_a_expirar = cls.objects.filter(
               estado='ACTIVE',
               fecha_ultima_actividad__lt=limite
           )
           
           count = 0
           for sesion in sesiones_a_expirar:
               sesion.expirar()
               count += 1
           
           return count

5.2 Middleware de Sesión
--------------------------

.. code-block:: python

   # file: auth/middleware.py
   from django.utils.deprecation import MiddlewareMixin
   from django.http import JsonResponse
   from django.shortcuts import redirect
   from .models import Session
   
   class SessionTimeoutMiddleware(MiddlewareMixin):
       """
       Middleware que valida timeout de sesión (15 min).
       
       Implementa CNST_002.
       """
       
       def process_request(self, request):
           if request.user.is_authenticated:
               # Obtener session_id del JWT o cookie
               session_id = request.META.get('HTTP_X_SESSION_ID') or \
                           request.COOKIES.get('session_id')
               
               if not session_id:
                   return self._session_invalida(request, 'No session ID')
               
               try:
                   sesion = Session.objects.get(
                       session_id=session_id,
                       usuario=request.user
                   )
               except Session.DoesNotExist:
                   return self._session_invalida(request, 'Session not found')
               
               # Verificar estado
               if sesion.estado != 'ACTIVE':
                   return self._session_invalida(
                       request, 
                       f'Session {sesion.estado.lower()}'
                   )
               
               # Verificar timeout (15 min)
               if sesion.esta_expirada:
                   sesion.expirar()
                   return self._session_invalida(
                       request, 
                       'Session expired (15 min timeout)'
                   )
               
               # Actualizar última actividad
               sesion.actualizar_actividad()
               
               # Inyectar sesión en request
               request.session_obj = sesion
       
       def _session_invalida(self, request, razon):
           """Retorna respuesta de sesión inválida."""
           if request.path.startswith('/api/'):
               # API: retornar JSON
               return JsonResponse({
                   'error': 'session_invalid',
                   'message': razon,
                   'redirect': '/login'
               }, status=401)
           else:
               # Web: redirigir a login
               return redirect(f'/login?reason={razon}')

5.3 Gestor de Sesiones
------------------------

.. code-block:: python

   # file: auth/session_manager.py
   from .models import Session
   from core.buzon_interno import BuzonInterno
   
   class SessionManager:
       """
       Gestor centralizado de sesiones.
       
       Implementa funciones RBAC AUT-001, AUT-002, AUT-004.
       """
       
       @staticmethod
       def obtener_sesiones_activas(usuario_filter=None):
           """
           Obtiene sesiones activas del sistema.
           
           Implementa AUT-004: ve_sesiones_activas
           
           Args:
               usuario_filter: Filtrar por usuario (opcional)
           
           Returns:
               QuerySet de Session
           """
           qs = Session.objects.filter(estado='ACTIVE')
           
           if usuario_filter:
               qs = qs.filter(usuario=usuario_filter)
           
           return qs.select_related('usuario').order_by(
               '-fecha_ultima_actividad'
           )
       
       @staticmethod
       def cerrar_sesion_usuario(session_id, admin_user):
           """
           Cierra sesión de otro usuario (admin).
           
           Implementa AUT-002: cierra_sesion_usuario
           
           Args:
               session_id: ID de la sesión a cerrar
               admin_user: Usuario administrador que cierra
           
           Raises:
               PermissionError: Si admin no tiene función AUT-002
               Session.DoesNotExist: Si sesión no existe
           """
           from core.rbac import RBACManager
           
           # Validar permiso
           rbac = RBACManager()
           if not rbac.user_has_function(admin_user, 'cierra_sesion_usuario'):
               raise PermissionError(
                   "Requiere función AUT-002: cierra_sesion_usuario"
               )
           
           # Obtener sesión
           sesion = Session.objects.get(session_id=session_id)
           
           if sesion.estado != 'ACTIVE':
               raise ValueError(f"Sesión ya está {sesion.estado}")
           
           # Invalidar sesión
           sesion.invalidar(
               motivo='admin_close',
               cerrada_por=admin_user
           )
           
           # Notificar al usuario afectado
           BuzonInterno.enviar_notificacion(
               usuario_id=sesion.usuario.usuario_id,
               tipo='SEGURIDAD',
               severidad='WARNING',
               titulo='Tu sesión fue cerrada por un administrador',
               mensaje=(
                   f"El administrador {admin_user.username} cerró tu sesión "
                   f"el {sesion.fecha_fin.strftime('%Y-%m-%d %H:%M:%S')}.\n\n"
                   f"Si no reconoces esta acción, contacta al equipo de seguridad."
               )
           )
           
           # Registrar en auditoría
           from core.models import AuditLog
           AuditLog.objects.create(
               usuario=admin_user,
               accion='SESSION_CLOSE',
               modulo='MOD_Auth',
               resultado='SUCCESS',
               detalles={
                   'session_id': str(session_id),
                   'usuario_afectado': sesion.usuario.username
               }
           )
       
       @staticmethod
       def limpiar_sesiones_expiradas():
           """
           Limpia sesiones expiradas (cron job).
           
           Implementa AUT-001: gestiona_sesiones
           
           Returns:
               dict: Estadísticas de limpieza
           """
           count = Session.limpiar_sesiones_expiradas()
           
           return {
               'sesiones_expiradas': count,
               'timestamp': timezone.now().isoformat()
           }

============================================================
6. EJEMPLOS DE IMPLEMENTACIÓN
============================================================

6.1 Ejemplo: Login con Sesión Única
-------------------------------------

.. code-block:: python

   # file: auth/views.py
   from django.contrib.auth import authenticate
   from django.contrib.auth.hashers import check_password
   from rest_framework.decorators import api_view
   from rest_framework.response import Response
   from .models import Session
   import jwt
   from datetime import datetime, timedelta
   
   @api_view(['POST'])
   def login(request):
       """
       Login de usuario con sesión única (CNST_002).
       
       POST /api/auth/login
       {
           "username": "usuario",
           "password": "password"
       }
       """
       username = request.data.get('username')
       password = request.data.get('password')
       
       # 1. Validar credenciales
       try:
           from users.models import Usuario
           usuario = Usuario.objects.get(username=username, activo=True)
       except Usuario.DoesNotExist:
           return Response({
               'error': 'invalid_credentials',
               'message': 'Usuario o contraseña incorrectos'
           }, status=401)
       
       if not check_password(password, usuario.password):
           return Response({
               'error': 'invalid_credentials',
               'message': 'Usuario o contraseña incorrectos'
           }, status=401)
       
       # 2. Crear sesión (invalida sesiones previas - SESIÓN ÚNICA)
       ip_address = request.META.get('REMOTE_ADDR')
       user_agent = request.META.get('HTTP_USER_AGENT', '')
       
       sesion = Session.crear_sesion(
           usuario=usuario,
           ip_address=ip_address,
           user_agent=user_agent
       )
       
       # 3. Generar JWT con session_id
       payload = {
           'sub': usuario.usuario_id,
           'username': usuario.username,
           'session_id': str(sesion.session_id),
           'iat': datetime.utcnow(),
           'exp': datetime.utcnow() + timedelta(minutes=15)  # 15 min
       }
       
       token = jwt.encode(
           payload, 
           settings.SECRET_KEY, 
           algorithm='HS256'
       )
       
       # 4. Retornar respuesta
       return Response({
           'access_token': token,
           'token_type': 'Bearer',
           'expires_in': 900,  # 15 min en segundos
           'session_id': str(sesion.session_id),
           'user': {
               'id': usuario.usuario_id,
               'username': usuario.username,
               'email': usuario.email
           }
       })

6.2 Ejemplo: Logout Manual
----------------------------

.. code-block:: python

   # file: auth/views.py
   from rest_framework.decorators import api_view, permission_classes
   from rest_framework.permissions import IsAuthenticated
   
   @api_view(['POST'])
   @permission_classes([IsAuthenticated])
   def logout(request):
       """
       Logout manual del usuario.
       
       POST /api/auth/logout
       """
       # Obtener sesión del request (inyectada por middleware)
       sesion = getattr(request, 'session_obj', None)
       
       if not sesion:
           return Response({
               'error': 'no_session',
               'message': 'No hay sesión activa'
           }, status=400)
       
       # Cerrar sesión
       sesion.logout()
       
       # Registrar en auditoría
       from core.models import AuditLog
       AuditLog.objects.create(
           usuario=request.user,
           accion='LOGOUT',
           modulo='MOD_Auth',
           resultado='SUCCESS',
           detalles={
               'session_id': str(sesion.session_id)
           }
       )
       
       return Response({
           'success': True,
           'message': 'Sesión cerrada exitosamente'
       })

6.3 Ejemplo: Cron Job de Limpieza
-----------------------------------

.. code-block:: python

   # file: auth/management/commands/limpiar_sesiones.py
   from django.core.management.base import BaseCommand
   from auth.session_manager import SessionManager
   
   class Command(BaseCommand):
       help = 'Limpia sesiones expiradas (CNST_002: timeout 15 min)'
       
       def handle(self, *args, **options):
           """
           Ejecutar cada 5 minutos via cron:
           */5 * * * * python manage.py limpiar_sesiones
           """
           resultado = SessionManager.limpiar_sesiones_expiradas()
           
           self.stdout.write(
               self.style.SUCCESS(
                   f"✓ Sesiones expiradas: {resultado['sesiones_expiradas']}"
               )
           )

============================================================
7. VALIDACIÓN Y TESTING
============================================================

7.1 Tests Unitarios
--------------------

.. code-block:: python

   # file: tests/test_cnst_002.py
   from django.test import TestCase
   from django.utils import timezone
   from datetime import timedelta
   from auth.models import Session
   from users.models import Usuario
   
   class TestCNST002(TestCase):
       """
       Tests para validar CNST_002: Sesiones en BD, única, timeout 15 min
       """
       
       def setUp(self):
           self.usuario = Usuario.objects.create(
               username='test_user',
               email='test@example.com',
               password='hashed_password'
           )
       
       def test_sesion_unica(self):
           """Validar que solo puede haber 1 sesión activa por usuario."""
           # Crear primera sesión
           sesion1 = Session.crear_sesion(
               usuario=self.usuario,
               ip_address='192.168.1.1'
           )
           
           self.assertEqual(sesion1.estado, 'ACTIVE')
           
           # Crear segunda sesión (debe invalidar la primera)
           sesion2 = Session.crear_sesion(
               usuario=self.usuario,
               ip_address='192.168.1.2'
           )
           
           # Verificar que sesión 1 fue invalidada
           sesion1.refresh_from_db()
           self.assertEqual(sesion1.estado, 'INVALIDATED')
           self.assertEqual(sesion1.motivo_fin, 'concurrent_login')
           
           # Verificar que sesión 2 está activa
           self.assertEqual(sesion2.estado, 'ACTIVE')
           
           # Verificar que solo hay 1 sesión activa
           activas = Session.objects.filter(
               usuario=self.usuario,
               estado='ACTIVE'
           )
           self.assertEqual(activas.count(), 1)
       
       def test_timeout_15_minutos(self):
           """Validar que sesión expira a los 15 minutos."""
           # Crear sesión
           sesion = Session.crear_sesion(
               usuario=self.usuario,
               ip_address='192.168.1.1'
           )
           
           # Simular 15 minutos de inactividad
           sesion.fecha_ultima_actividad = timezone.now() - timedelta(minutes=16)
           sesion.save()
           
           # Verificar que está expirada
           self.assertTrue(sesion.esta_expirada)
           self.assertEqual(sesion.minutos_inactivo, 16)
           self.assertEqual(sesion.minutos_restantes, 0)
           
           # Marcar como expirada
           sesion.expirar()
           
           # Verificar estado
           self.assertEqual(sesion.estado, 'EXPIRED')
           self.assertEqual(sesion.motivo_fin, 'timeout')
           self.assertIsNotNone(sesion.fecha_fin)
       
       def test_actualizacion_actividad(self):
           """Validar que actualizar actividad resetea el timeout."""
           # Crear sesión
           sesion = Session.crear_sesion(
               usuario=self.usuario,
               ip_address='192.168.1.1'
           )
           
           # Simular 10 minutos de inactividad
           sesion.fecha_ultima_actividad = timezone.now() - timedelta(minutes=10)
           sesion.save()
           
           self.assertEqual(sesion.minutos_inactivo, 10)
           self.assertEqual(sesion.minutos_restantes, 5)
           
           # Actualizar actividad (reset timeout)
           sesion.actualizar_actividad()
           
           # Verificar que timeout se reseteó
           self.assertEqual(sesion.minutos_inactivo, 0)
           self.assertEqual(sesion.minutos_restantes, 15)
       
       def test_almacenamiento_bd(self):
           """Validar que sesiones se almacenan en BD (no cache)."""
           # Crear sesión
           sesion = Session.crear_sesion(
               usuario=self.usuario,
               ip_address='192.168.1.1',
               user_agent='Mozilla/5.0'
           )
           
           # Verificar que existe en BD
           sesion_bd = Session.objects.get(session_id=sesion.session_id)
           
           self.assertEqual(sesion_bd.usuario, self.usuario)
           self.assertEqual(sesion_bd.ip_address, '192.168.1.1')
           self.assertEqual(sesion_bd.user_agent, 'Mozilla/5.0')
           self.assertEqual(sesion_bd.estado, 'ACTIVE')
       
       def test_cierre_administrativo(self):
           """Validar cierre de sesión por administrador."""
           admin = Usuario.objects.create(
               username='admin_user',
               email='admin@example.com'
           )
           
           # Crear sesión de usuario
           sesion = Session.crear_sesion(
               usuario=self.usuario,
               ip_address='192.168.1.1'
           )
           
           # Admin cierra sesión
           sesion.invalidar(
               motivo='admin_close',
               cerrada_por=admin
           )
           
           # Verificar estado
           self.assertEqual(sesion.estado, 'INVALIDATED')
           self.assertEqual(sesion.motivo_fin, 'admin_close')
           self.assertEqual(sesion.cerrada_por, admin)
           self.assertIsNotNone(sesion.fecha_fin)

7.2 Tests de Integración
--------------------------

.. code-block:: python

   # file: tests/test_session_integration.py
   from django.test import TestCase, Client
   from users.models import Usuario
   import json
   
   class TestSessionIntegration(TestCase):
       def setUp(self):
           self.client = Client()
           self.usuario = Usuario.objects.create_user(
               username='testuser',
               email='test@example.com',
               password='testpass123'
           )
       
       def test_login_logout_flow(self):
           """Test flujo completo de login y logout."""
           # Login
           response = self.client.post('/api/auth/login', {
               'username': 'testuser',
               'password': 'testpass123'
           }, content_type='application/json')
           
           self.assertEqual(response.status_code, 200)
           data = response.json()
           
           self.assertIn('access_token', data)
           self.assertIn('session_id', data)
           self.assertEqual(data['expires_in'], 900)  # 15 min
           
           # Guardar token
           token = data['access_token']
           
           # Logout
           response = self.client.post(
               '/api/auth/logout',
               HTTP_AUTHORIZATION=f'Bearer {token}'
           )
           
           self.assertEqual(response.status_code, 200)
           
           # Verificar sesión cerrada en BD
           from auth.models import Session
           sesion = Session.objects.get(session_id=data['session_id'])
           self.assertEqual(sesion.estado, 'LOGGED_OUT')
       
       def test_concurrent_login_invalida_sesion_anterior(self):
           """Test que login concurrent invalida sesión anterior."""
           # Login 1
           response1 = self.client.post('/api/auth/login', {
               'username': 'testuser',
               'password': 'testpass123'
           }, content_type='application/json')
           
           session_id_1 = response1.json()['session_id']
           
           # Login 2 (debe invalidar sesión 1)
           response2 = self.client.post('/api/auth/login', {
               'username': 'testuser',
               'password': 'testpass123'
           }, content_type='application/json')
           
           session_id_2 = response2.json()['session_id']
           
           # Verificar que sesión 1 fue invalidada
           from auth.models import Session
           sesion1 = Session.objects.get(session_id=session_id_1)
           self.assertEqual(sesion1.estado, 'INVALIDATED')
           self.assertEqual(sesion1.motivo_fin, 'concurrent_login')
           
           # Verificar que sesión 2 está activa
           sesion2 = Session.objects.get(session_id=session_id_2)
           self.assertEqual(sesion2.estado, 'ACTIVE')

============================================================
8. MONITOREO Y ALERTAS
============================================================

8.1 Métricas a Monitorear
---------------------------

.. code-block:: yaml

   Métricas de Sesiones:
     
     1. sesiones_activas_count:
        - Descripción: Cantidad de sesiones activas
        - Umbral crítico: > 1000
        - Acción: Investigar posible ataque
     
     2. sesiones_concurrentes_por_usuario:
        - Descripción: Usuarios con >1 login en <1 min
        - Umbral warning: > 5 usuarios/hora
        - Acción: Posible compartición de credenciales
     
     3. sesiones_expiradas_por_timeout:
        - Descripción: Sesiones que expiran por timeout
        - Umbral normal: 60-80%
        - Acción: Informativo, patrón normal
     
     4. tiempo_promedio_sesion:
        - Descripción: Duración promedio de sesiones
        - Esperado: 5-30 minutos
        - Acción: Si <5 min, investigar usabilidad
     
     5. sesiones_cerradas_por_admin:
        - Descripción: Cierres administrativos
        - Umbral warning: > 10/día
        - Acción: Investigar razones

8.2 Dashboard de Sesiones
---------------------------

.. code-block:: sql

   -- Query para dashboard de sesiones activas
   SELECT 
       COUNT(*) as total_activas,
       COUNT(DISTINCT usuario_id) as usuarios_unicos,
       MAX(fecha_inicio) as sesion_mas_reciente,
       MIN(fecha_inicio) as sesion_mas_antigua,
       AVG(TIMESTAMPDIFF(MINUTE, fecha_inicio, NOW())) 
           as duracion_promedio_min,
       COUNT(CASE WHEN minutos_restantes < 5 THEN 1 END) 
           as proximas_a_expirar
   FROM vw_sesiones_activas;
   
   -- Query para sesiones por estado (últimas 24h)
   SELECT 
       estado,
       motivo_fin,
       COUNT(*) as cantidad,
       AVG(TIMESTAMPDIFF(MINUTE, fecha_inicio, fecha_fin)) 
           as duracion_promedio
   FROM sessions
   WHERE fecha_inicio >= NOW() - INTERVAL 24 HOUR
   GROUP BY estado, motivo_fin
   ORDER BY cantidad DESC;

============================================================
9. REFERENCIAS
============================================================

9.1 Documentos Relacionados
-----------------------------

:CNST_001: NO Email bajo ninguna circunstancia
:CNST_005: RBAC Flat, SoD, permisos
:CNST_008: Audit inmutable, logs sin PII
:UC_005: Gestionar sesiones de usuarios

9.2 Funciones RBAC Relacionadas
---------------------------------

:AUT_001: gestiona_sesiones
:AUT_002: cierra_sesion_usuario
:AUT_004: ve_sesiones_activas

9.3 Referencias Técnicas
--------------------------

- Django Sessions Documentation
- OWASP Session Management Cheat Sheet
- JWT Best Practices

============================================================
10. HISTORIAL DE CAMBIOS
============================================================

.. list-table:: Historial de Versiones
   :header-rows: 1
   :widths: 15 15 70

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-11
     - Versión inicial. Documentación completa de CNST_002:
       Sesiones en BD, única por usuario, timeout 15 minutos.
       Incluye: modelo de datos, implementación Django,
       middleware, tests, ejemplos completos.

============================================================

.. note::
   **RECORDATORIO:**
   
   CNST_002 define comportamiento CRÍTICO de sesiones:
   - Almacenamiento: SOLO en BD (MySQL)
   - Cantidad: 1 sesión activa por usuario
   - Timeout: 15 minutos de inactividad
   - Persistencia: Mínimo 2 años para auditoría
   
   NO usar Redis, Memcached u otros sistemas de caché
   para sesiones principales.

**FIN DEL DOCUMENTO CNST_002**
