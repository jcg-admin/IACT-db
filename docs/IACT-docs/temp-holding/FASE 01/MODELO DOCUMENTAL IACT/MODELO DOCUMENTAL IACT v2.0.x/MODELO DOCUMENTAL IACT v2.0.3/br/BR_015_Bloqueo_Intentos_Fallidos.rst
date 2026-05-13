.. meta::
   :artefacto: BR_015
   :tipo: Business Rule
   :subtipo: Desencadenador
   :modalidad: Deontica (Obligacion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-015:

==============================================================================
BR_015: Bloqueo por Intentos Fallidos
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   SI un usuario falla 3 intentos consecutivos de inicio de sesion,
   ENTONCES el sistema DEBE bloquear la cuenta temporalmente por
   15 minutos y notificar al administrador de seguridad.

**Enunciado SBVR:**

   If a user fails 3 consecutive login attempts,
   then the system must temporarily lock the account for 15 minutes
   and notify the security administrator.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Desencadenador (Trigger)
   * - **Modalidad**
     - Deontica - Obligacion (Obligation)
   * - **Estatica/Dinamica**
     - Dinamica (parametros configurables)

**Nota:** Es DESENCADENADOR porque las acciones (bloqueo, notificacion)
son OBSERVABLES. Genera flujo alterno en UC de login.

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Seguridad - Proteccion contra Fuerza Bruta
   * - **Documento**
     - POL_002 Control de Acceso
   * - **Seccion**
     - 4.3 Proteccion de Credenciales
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Seguridad:** Prevenir ataques de fuerza bruta.

2. **Deteccion:** Alertar sobre posibles intentos de acceso no autorizado.

3. **Limitacion:** Reducir velocidad de ataques automatizados.

4. **Balance:** Bloqueo temporal permite recuperacion de error genuino.

----

Condicion y Accion
------------------

Condicion (SI)
^^^^^^^^^^^^^^

.. code-block:: text

   Condicion: intentos_fallidos_consecutivos >= 3

   Variables:
   - intentos_fallidos: Contador por usuario
   - Se resetea a 0 tras login exitoso
   - Ventana de conteo: ultimos 30 minutos

Acciones (ENTONCES)
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Accion 1: Bloquear cuenta
   - Estado usuario -> BLOQUEADO_TEMPORAL
   - Registrar locked_until = NOW() + 15 minutos
   - Rechazar intentos de login durante bloqueo

   Accion 2: Notificar administrador de seguridad
   - Mensaje al buzon de usuarios con rol R018 (SECURITY_ADMIN)
   - Contenido: usuario, IP, timestamp, intentos

   Accion 3: Registrar en auditoria
   - Evento ACCOUNT_LOCKED
   - Detalles: usuario, IP, intentos fallidos

----

Caso de Uso Afectado
--------------------

Esta BR genera flujo alterno en UC_001:

.. code-block:: text

   UC_001: Inicio de Sesion
   ...
   FLUJO ALTERNO 3: Bloqueo por Intentos Fallidos (BR_015)

   3a. Sistema detecta 3 intentos fallidos consecutivos
   3b. Sistema bloquea cuenta por 15 minutos
   3c. Sistema muestra mensaje "Cuenta bloqueada temporalmente"
   3d. Sistema notifica a administrador de seguridad
   3e. Sistema registra evento en auditoria
   3f. Caso de uso termina

----

Modelo de Datos
---------------

.. code-block:: sql

   -- Campos adicionales en users
   ALTER TABLE users ADD COLUMN failed_login_attempts INTEGER DEFAULT 0;
   ALTER TABLE users ADD COLUMN last_failed_login TIMESTAMP;
   ALTER TABLE users ADD COLUMN locked_until TIMESTAMP;

   -- Log de intentos fallidos
   CREATE TABLE login_attempts (
       id SERIAL PRIMARY KEY,
       username VARCHAR(100) NOT NULL,
       ip_address INET,
       user_agent TEXT,
       attempted_at TIMESTAMP DEFAULT NOW(),
       success BOOLEAN NOT NULL,
       failure_reason VARCHAR(50)  -- 'INVALID_PASSWORD', 'ACCOUNT_LOCKED', etc.
   );

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-001.20
     - Sistema DEBE registrar cada intento de login (exitoso o fallido)
   * - FR-001.21
     - Sistema DEBE incrementar contador de fallos tras password incorrecto
   * - FR-001.22
     - Sistema DEBE bloquear cuenta tras 3 intentos fallidos consecutivos
   * - FR-001.23
     - Sistema DEBE establecer tiempo de bloqueo de 15 minutos
   * - FR-001.24
     - Sistema DEBE notificar a SECURITY_ADMIN tras bloqueo
   * - FR-001.25
     - Sistema DEBE resetear contador tras login exitoso
   * - FR-001.26
     - Sistema DEBE rechazar login durante periodo de bloqueo

----

Implementacion Tecnica
----------------------

Servicio de Autenticacion
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/auth.py

   class AuthService:

       MAX_ATTEMPTS = 3
       LOCKOUT_MINUTES = 15

       def login(self, username, password, ip_address):
           """
           BR_015: Bloqueo por intentos fallidos
           """
           user = User.objects.filter(username=username).first()

           # Registrar intento
           self._log_attempt(username, ip_address)

           # Verificar si esta bloqueado
           if user and user.locked_until and user.locked_until > timezone.now():
               remaining = (user.locked_until - timezone.now()).seconds // 60
               raise AccountLockedError(
                   f"Cuenta bloqueada. Intente en {remaining} minutos"
               )

           # Validar credenciales
           if not user or not user.check_password(password):
               if user:
                   self._handle_failed_attempt(user, ip_address)
               raise InvalidCredentialsError("Usuario o contrasena incorrectos")

           # Login exitoso - resetear contador
           user.failed_login_attempts = 0
           user.save(update_fields=['failed_login_attempts'])

           return self._create_session(user, ip_address)

       def _handle_failed_attempt(self, user, ip_address):
           """Maneja intento fallido y bloquea si aplica"""
           user.failed_login_attempts += 1
           user.last_failed_login = timezone.now()

           if user.failed_login_attempts >= self.MAX_ATTEMPTS:
               # BR_015: Bloquear cuenta
               user.locked_until = timezone.now() + timedelta(
                   minutes=self.LOCKOUT_MINUTES
               )
               user.save()

               # Notificar a seguridad
               self._notify_security_admin(user, ip_address)

               # Auditar
               AuditService().log(
                   user_id=user.id,
                   action='ACCOUNT_LOCKED',
                   details={
                       'ip_address': str(ip_address),
                       'failed_attempts': user.failed_login_attempts
                   }
               )

               raise AccountLockedError(
                   f"Cuenta bloqueada por {self.LOCKOUT_MINUTES} minutos"
               )

           user.save(update_fields=['failed_login_attempts', 'last_failed_login'])

       def _notify_security_admin(self, user, ip_address):
           """Notifica a admins de seguridad (BR_004: solo buzon interno)"""
           security_admins = User.objects.filter(
               roles__codigo='R018'
           )

           for admin in security_admins:
               InternalMessage.objects.create(
                   recipient=admin,
                   sender_type='SYSTEM',
                   subject=f"Alerta: Cuenta bloqueada - {user.username}",
                   body=f"La cuenta {user.username} ha sido bloqueada "
                        f"por {self.MAX_ATTEMPTS} intentos fallidos.\n"
                        f"IP: {ip_address}\n"
                        f"Hora: {timezone.now()}",
                   priority='HIGH'
               )

----

Parametros Configurables
------------------------

.. list-table::
   :widths: 30 20 50

   * - Parametro
     - Default
     - Descripcion
   * - MAX_ATTEMPTS
     - 3
     - Intentos antes de bloqueo
   * - LOCKOUT_MINUTES
     - 15
     - Duracion del bloqueo
   * - ATTEMPT_WINDOW_MINUTES
     - 30
     - Ventana para contar intentos

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Tras 3 intentos fallidos, cuenta se bloquea
2. Durante bloqueo, login rechazado con mensaje claro
3. Administrador de seguridad recibe notificacion
4. Tras 15 minutos, cuenta se desbloquea automaticamente
5. Login exitoso resetea contador de intentos

Casos de Prueba
^^^^^^^^^^^^^^^

.. code-block:: text

   TEST_001: Bloqueo tras 3 intentos
   - 3 intentos con password incorrecto
   - Resultado: Cuenta bloqueada, mensaje apropiado

   TEST_002: Rechazo durante bloqueo
   - Cuenta bloqueada, intentar login con password correcto
   - Resultado: Rechazado hasta que expire bloqueo

   TEST_003: Desbloqueo automatico
   - Esperar 15 minutos tras bloqueo
   - Intentar login con password correcto
   - Resultado: Login exitoso

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-004` - BR_004 Comunicaciones Internas
- :ref:`br-005` - BR_005 Sesion Unica
- :ref:`br-010` - BR_010 Auditoria Inmutable
- :ref:`cnst-005` - CNST_005 Seguridad DRF
- UC_001 - Inicio de Sesion

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-03
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:**

- Origen: POL_002 Control de Acceso
- Tipo: Desencadenador (genera flujo alterno)
- Influye: UC_001 (flujo alterno 3)
- Deriva: FR-001.20 a FR-001.26
