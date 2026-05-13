.. meta::
   :artefacto: BR_005
   :tipo: Business Rule
   :subtipo: Restriccion
   :modalidad: Deontica (Obligacion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-005:

==============================================================================
BR_005: Sesion Unica por Usuario
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   Cada usuario DEBE tener como maximo una sesion activa a la vez.
   Si un usuario inicia sesion desde un nuevo dispositivo o navegador,
   la sesion anterior DEBE invalidarse automaticamente.

**Enunciado SBVR:**

   It is obligatory that each user has at most one active session.
   A new login invalidates any existing active session for the same user.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Obligacion (Obligation)
   * - **Estatica/Dinamica**
     - Estatica (politica de seguridad)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Seguridad - Control de Acceso
   * - **Documento**
     - POL_002 Control de Acceso
   * - **Seccion**
     - 4.1 Gestion de Sesiones
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Seguridad:** Prevenir uso simultaneo de credenciales robadas
   mientras el usuario legitimo esta activo.

2. **Control de acceso:** Garantizar que solo una instancia del
   usuario esta interactuando con el sistema.

3. **Auditoria:** Simplificar rastreo de acciones (una sesion = un
   contexto de actividad).

4. **Licenciamiento:** En contextos donde aplique, controlar
   usuarios concurrentes.

5. **Consistencia:** Evitar conflictos de estado por acciones
   simultaneas del mismo usuario.

----

Comportamiento
--------------

Escenario Normal
^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Usuario A inicia sesion en Navegador 1
      -> Sesion S1 creada, activa

   2. Usuario A continua trabajando en Navegador 1
      -> Sesion S1 permanece activa

   3. Usuario A cierra sesion
      -> Sesion S1 invalidada

Escenario de Sesion Duplicada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Usuario A inicia sesion en Navegador 1
      -> Sesion S1 creada, activa

   2. Usuario A (o atacante) inicia sesion en Navegador 2
      -> Sesion S1 INVALIDADA automaticamente
      -> Sesion S2 creada, activa

   3. Usuario A en Navegador 1 intenta accion
      -> Error: "Sesion expirada, inicie sesion nuevamente"

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_005
   * - UC_001
     - Inicio de Sesion
     - Invalida sesion previa si existe
   * - UC_002
     - Cierre de Sesion
     - Invalida sesion actual
   * - UC_005
     - Gestionar Sesiones
     - Admin puede ver/cerrar sesiones

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-001.10
     - Sistema DEBE verificar si usuario tiene sesion activa al login
   * - FR-001.11
     - Sistema DEBE invalidar sesion previa si existe al crear nueva
   * - FR-001.12
     - Sistema DEBE registrar invalidacion en tabla sessions
   * - FR-001.13
     - Sistema DEBE rechazar requests con token de sesion invalidada
   * - FR-005.01
     - Sistema DEBE permitir a admin listar sesiones activas
   * - FR-005.02
     - Sistema DEBE permitir a admin cerrar sesion de usuario

----

Modelo de Datos
---------------

Tabla de Sesiones
^^^^^^^^^^^^^^^^^

.. code-block:: sql

   CREATE TABLE sessions (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
       user_id INTEGER NOT NULL REFERENCES users(id),
       token_hash VARCHAR(255) NOT NULL,
       ip_address INET,
       user_agent TEXT,
       created_at TIMESTAMP DEFAULT NOW(),
       last_activity_at TIMESTAMP DEFAULT NOW(),
       expires_at TIMESTAMP NOT NULL,
       is_active BOOLEAN DEFAULT TRUE,
       invalidated_by VARCHAR(50),  -- 'NEW_LOGIN', 'LOGOUT', 'ADMIN', 'TIMEOUT'
       invalidated_at TIMESTAMP
   );

   -- Constraint: Solo una sesion activa por usuario
   CREATE UNIQUE INDEX idx_one_active_session
   ON sessions (user_id)
   WHERE is_active = TRUE;

----

Implementacion Tecnica
----------------------

Login con Invalidacion
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/auth.py

   class AuthService:

       def login(self, username, password, ip_address, user_agent):
           """
           BR_005: Sesion unica por usuario
           """
           user = self._validate_credentials(username, password)

           # Invalidar sesion existente si hay
           self._invalidate_existing_session(user.id)

           # Crear nueva sesion
           session = self._create_session(user, ip_address, user_agent)

           return session

       def _invalidate_existing_session(self, user_id):
           """Invalida cualquier sesion activa del usuario"""
           Session.objects.filter(
               user_id=user_id,
               is_active=True
           ).update(
               is_active=False,
               invalidated_by='NEW_LOGIN',
               invalidated_at=timezone.now()
           )

       def _create_session(self, user, ip_address, user_agent):
           """Crea nueva sesion (sera la unica activa)"""
           return Session.objects.create(
               user=user,
               token_hash=self._generate_token_hash(),
               ip_address=ip_address,
               user_agent=user_agent,
               expires_at=timezone.now() + timedelta(minutes=30)
           )

Middleware de Validacion
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # middleware/session.py

   class SessionValidationMiddleware:

       def __call__(self, request):
           token = self._extract_token(request)

           if token:
               session = Session.objects.filter(
                   token_hash=hash(token),
                   is_active=True,
                   expires_at__gt=timezone.now()
               ).first()

               if not session:
                   return JsonResponse(
                       {'error': 'Sesion invalida o expirada'},
                       status=401
                   )

               # Actualizar ultima actividad
               session.last_activity_at = timezone.now()
               session.save(update_fields=['last_activity_at'])

               request.session_obj = session

           return self.get_response(request)

----

Timeout de Sesion
-----------------

Adicionalmente, las sesiones tienen timeout por inactividad:

.. list-table::
   :widths: 30 70

   * - **Timeout**
     - 30 minutos de inactividad
   * - **Renovacion**
     - Cada request renueva el timeout
   * - **Expiracion**
     - Sesion se marca como inactiva

.. code-block:: python

   # Job de limpieza de sesiones expiradas
   def cleanup_expired_sessions():
       Session.objects.filter(
           is_active=True,
           last_activity_at__lt=timezone.now() - timedelta(minutes=30)
       ).update(
           is_active=False,
           invalidated_by='TIMEOUT',
           invalidated_at=timezone.now()
       )

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_002
     - Gestion Sesiones BD
     - Implementa esta BR

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Login invalida sesion previa del mismo usuario
2. Solo una sesion activa por usuario en tabla sessions
3. Request con token invalidado retorna 401
4. Admin puede ver sesiones activas de usuarios
5. Admin puede cerrar sesion de cualquier usuario

Casos de Prueba
^^^^^^^^^^^^^^^

.. code-block:: text

   TEST_001: Login unico
   - Usuario A login -> sesion S1 activa
   - Verificar: solo S1 en tabla con is_active=True

   TEST_002: Login duplicado invalida anterior
   - Usuario A login -> sesion S1
   - Usuario A login de nuevo -> S1 invalidada, S2 activa
   - Verificar: S1.is_active=False, S1.invalidated_by='NEW_LOGIN'

   TEST_003: Request con sesion invalidada
   - Usuario A login -> S1
   - Usuario A login de nuevo -> S2
   - Request con token S1 -> 401 Unauthorized

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`cnst-002` - CNST_002 Gestion Sesiones BD
- :ref:`br-015` - BR_015 Bloqueo Intentos Fallidos
- UC_001 - Inicio de Sesion
- UC_005 - Gestionar Sesiones
- MOD_Auth - Modulo responsable

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
- Implementa: CNST_002
- Influye: UC_001, UC_002, UC_005
- Deriva: FR-001.10 a FR-001.13, FR-005.01, FR-005.02
