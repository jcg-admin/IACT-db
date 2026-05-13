.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Auth
   :uc_id: UC_AUTH_05
   :normativa: CNST-002, CNST-009

==============================
UC_AUTH_05: Gestionar Sesiones
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUTH_05
   * - **Nombre**
     - Gestionar Sesiones
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Actor Secundario**
     - Sistema (limpieza automatica)
   * - **Modulo**
     - MOD_Auth
   * - **Funcion RBAC**
     - AUT-001: gestiona_sesiones, AUT-002: cierra_sesion_usuario, AUT-004: ve_sesiones_activas
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUTH-005

2. Descripcion
--------------

Este caso de uso permite a un administrador de usuarios (AGR-006) visualizar
y gestionar las sesiones activas de todos los usuarios del sistema. Incluye
la capacidad de ver detalles de sesiones, cerrar sesiones individuales o
cerrar todas las sesiones de un usuario especifico.

**Caracteristicas principales:**

- Listar todas las sesiones activas del sistema
- Ver detalles de sesion (IP, user-agent, duracion, ultima actividad)
- Cerrar sesion individual de cualquier usuario
- Cerrar todas las sesiones de un usuario especifico
- Filtrar sesiones por usuario, fecha, estado
- Aplicacion de CNST-002 (sesion unica por usuario)
- Registro de todas las acciones en auditoria (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUTH_05

   @startuml

   left to right direction

   actor "AGR-006\nagr_admin_usuarios" as ADMIN <<AGR_ADMIN>>
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Auth" {
     usecase "UC_AUTH_05\nGestionar Sesiones" as UC05
     usecase "Ver Sesiones\nActivas" as VER
     usecase "Cerrar Sesion\nIndividual" as CLOSE1
     usecase "Cerrar Todas\nSesiones Usuario" as CLOSEALL
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC05
   UC05 --> VER : <<include>>
   UC05 --> CLOSE1 : <<extend>>
   UC05 --> CLOSEALL : <<extend>>
   UC05 --> AUD : <<include>>
   SYS --> AUD

   note right of CLOSEALL
     CNST-002: Solo 1 sesion
     por usuario permitida
   end note

   @enduml

4. Contexto de Ejecucion
------------------------

4.1 Precondiciones
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Precondicion
   * - PRE-01
     - El administrador tiene sesion activa valida
   * - PRE-02
     - El administrador tiene funcion AUT-004 (ve_sesiones_activas)
   * - PRE-03
     - Para cerrar sesiones, requiere AUT-001 o AUT-002

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de gestion de sesiones desde el panel de
administracion.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Consulta:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra lista de sesiones activas con detalles

**Cierre de Sesion:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-02
     - La sesion seleccionada queda marcada como inactiva
   * - POST-03
     - Los tokens asociados quedan invalidados
   * - POST-04
     - Se registra SESSION_CLOSED en auditoria (CNST-009)

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Admin
     - Accede al modulo "Gestion de Sesiones"
   * - 2
     - Sistema
     - Valida funcion AUT-004 (ve_sesiones_activas)
   * - 3
     - Sistema
     - Consulta sesiones activas en base de datos
   * - 4
     - Sistema
     - Presenta tabla con sesiones: usuario, IP, user-agent, inicio, ultima actividad
   * - 5
     - Admin
     - Aplica filtros opcionales (usuario, fecha, estado)
   * - 6
     - Sistema
     - Actualiza lista segun filtros
   * - 7
     - Admin
     - Selecciona una sesion especifica
   * - 8
     - Sistema
     - Muestra detalle completo de la sesion
   * - 9
     - Admin
     - Hace clic en "Cerrar Sesion"
   * - 10
     - Sistema
     - Valida funcion AUT-002 (cierra_sesion_usuario)
   * - 11
     - Sistema
     - Muestra dialogo de confirmacion
   * - 12
     - Admin
     - Confirma cierre
   * - 13
     - Sistema
     - Marca sesion como inactiva (is_active=false)
   * - 14
     - Sistema
     - Agrega token a blacklist
   * - 15
     - Sistema
     - Registra SESSION_CLOSED en UserActionLog (CNST-009)
   * - 16
     - Sistema
     - Actualiza lista de sesiones
   * - 17
     - Sistema
     - Muestra confirmacion de cierre

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUTH_05

   @startuml

   actor "AGR-006\nAdmin" as A
   participant "Frontend\nSessions" as FE <<Frontend>>
   participant "SessionController" as SC <<Backend>>
   participant "SessionService" as SS <<Service>>
   participant "TokenBlacklist" as TB <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   == Ver Sesiones Activas ==
   A -> FE: Accede a Gestion de Sesiones
   activate FE

   FE -> SC: GET /api/admin/sessions\nAuthorization: Bearer {token}
   activate SC

   SC -> SC: verify_function(AUT-004)

   SC -> SS: get_active_sessions(filters)
   activate SS

   SS -> DB: SELECT * FROM user_sessions\nWHERE is_active = true\nORDER BY last_activity DESC
   DB --> SS: sessions_list

   SS -> SS: enrich_with_user_info()

   SS --> SC: sessions_data
   deactivate SS

   SC --> FE: 200 OK + sessions
   deactivate SC

   FE --> A: Muestra tabla de sesiones

   == Cerrar Sesion Individual ==
   A -> FE: Click "Cerrar" en sesion
   FE -> FE: Dialogo confirmacion
   A -> FE: Confirma

   FE -> SC: DELETE /api/admin/sessions/{id}
   activate SC

   SC -> SC: verify_function(AUT-002)
   note right
     Requiere AUT-002:
     cierra_sesion_usuario
   end note

   SC -> SS: close_session(session_id, admin)
   activate SS

   SS -> DB: SELECT * FROM user_sessions\nWHERE id = ?
   DB --> SS: session

   alt sesion no encontrada o inactiva
     SS --> SC: SessionNotFoundError
     SC --> FE: 404 Not Found
   end

   SS -> DB: UPDATE user_sessions\nSET is_active = false,\nclosed_at = now(),\nclose_reason = 'ADMIN_CLOSE',\nclosed_by = admin_id

   SS -> TB: blacklist_token(session.token)
   activate TB
   TB -> DB: INSERT INTO token_blacklist
   TB --> SS: blacklisted
   deactivate TB

   == Registrar Auditoria (CNST-009) ==
   SS -> UAL: record(SESSION_CLOSED, admin, target_user)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Incluye admin y usuario afectado
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> SS: logged
   deactivate UAL

   SS --> SC: {success: true}
   deactivate SS

   SC --> FE: 200 OK
   deactivate SC

   FE -> FE: Actualiza lista
   FE --> A: Confirmacion: Sesion cerrada
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Cerrar Todas las Sesiones de un Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 9a
     - Admin
     - Selecciona "Cerrar todas las sesiones" de un usuario
   * - 10a
     - Sistema
     - Valida funcion AUT-001 (gestiona_sesiones)
   * - 11a
     - Sistema
     - Muestra advertencia: "Cerrara N sesiones activas"
   * - 12a
     - Admin
     - Confirma accion
   * - 13a
     - Sistema
     - Cierra todas las sesiones del usuario
   * - 14a
     - Sistema
     - Registra SESSION_CLOSED_ALL en auditoria

7.2 FA-02: Filtrar por Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Admin
     - Ingresa username en filtro
   * - 6a
     - Sistema
     - Muestra solo sesiones de ese usuario
   * - 6b
     - Sistema
     - Muestra opcion "Cerrar todas" habilitada

7.3 FA-03: Sesion Propia del Admin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 9a
     - Admin
     - Intenta cerrar su propia sesion actual
   * - 10a
     - Sistema
     - Muestra advertencia: "Cerrara su sesion actual"
   * - 12a
     - Admin
     - Confirma (sera desconectado)
   * - 17a
     - Sistema
     - Redirige a pantalla de login

8. Excepciones
--------------

8.1 EX-01: Sin Permiso para Ver Sesiones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion AUT-004
   * - **Accion Sistema**
     - Rechaza acceso al modulo
   * - **Mensaje Usuario**
     - "No tiene permisos para ver sesiones activas"
   * - **Codigo Error**
     - AUTH-040

8.2 EX-02: Sin Permiso para Cerrar Sesiones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Administrador no tiene funcion AUT-002
   * - **Accion Sistema**
     - Permite ver pero no cerrar
   * - **Mensaje Usuario**
     - "No tiene permisos para cerrar sesiones"
   * - **Codigo Error**
     - AUTH-041

8.3 EX-03: Sesion Ya Cerrada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 13
   * - **Condicion**
     - Sesion ya fue cerrada por otro proceso
   * - **Accion Sistema**
     - Actualiza lista, muestra mensaje
   * - **Mensaje Usuario**
     - "La sesion ya no esta activa"
   * - **Codigo Error**
     - AUTH-042

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUTH_05

   @startuml

   start

   :Admin accede a Gestion de Sesiones;

   if (Tiene funcion AUT-004?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Consultar sesiones activas;

   :Mostrar lista de sesiones;

   :Admin aplica filtros opcionales;

   :Actualizar lista;

   if (Accion requerida?) then (ver detalle)
     :Mostrar detalle de sesion;
   else (cerrar sesion)
   endif

   if (Cerrar sesion?) then (no)
     stop
   else (si)
   endif

   if (Tiene funcion AUT-002?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar dialogo confirmacion;

   if (Confirma?) then (no)
     stop
   else (si)
   endif

   :Marcar sesion como inactiva;

   :Agregar token a blacklist;

   :Registrar SESSION_CLOSED;
   note right
     CNST-009
     Incluye admin y usuario
   end note

   :Actualizar lista de sesiones;

   :Mostrar confirmacion;

   stop

   @enduml

10. Reglas de Negocio
---------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - ID
     - Regla
     - Descripcion
   * - BR-AUTH-40
     - Separacion de Funciones
     - Ver sesiones (AUT-004) y cerrar sesiones (AUT-002) son funciones separadas que pueden asignarse independientemente.
   * - BR-AUTH-41
     - Cierre Propio
     - Un admin puede cerrar su propia sesion, resultando en desconexion inmediata.
   * - BR-AUTH-42
     - Registro Completo
     - Todo cierre de sesion por admin debe registrar: admin ejecutor, usuario afectado, razon y timestamp.
   * - BR-AUTH-43
     - Invalidacion Inmediata
     - Al cerrar una sesion, el token debe quedar invalido inmediatamente (blacklist).
   * - BR-AUTH-44
     - Sesion Unica
     - Coherente con CNST-002, cada usuario solo puede tener una sesion activa.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-002
     - Sesion Unica
     - El listado de sesiones deberia mostrar maximo 1 sesion activa por usuario. Si hay multiples (estado inconsistente), se debe alertar y permitir limpiar.
   * - CNST-009
     - Auditoria Inmutable
     - Todo cierre de sesion administrativa se registra en UserActionLog con: admin ejecutor, usuario afectado, session_id, IP de ambos y razon.

**Implementacion CNST-009:**

.. code-block:: python

   # services/session_service.py
   def close_session(self, session_id: int, admin: User) -> dict:
       session = UserSession.objects.get(id=session_id)

       # Cerrar sesion
       session.is_active = False
       session.closed_at = timezone.now()
       session.close_reason = 'ADMIN_CLOSE'
       session.closed_by = admin
       session.save()

       # Blacklist token
       TokenBlacklist.add(session.token_hash)

       # CNST-009: Auditoria
       UserActionLog.record(
           user=admin,
           action='SESSION_CLOSED',
           resource=f'Session:{session.id}',
           result='SUCCESS',
           ip=request.META.get('REMOTE_ADDR'),
           details={
               'target_user': session.user.username,
               'target_user_id': session.user.id,
               'session_ip': session.ip_address,
               'session_duration_min': session.duration_minutes,
               'close_reason': 'admin_action'
           }
       )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUTH-040
     - El sistema debe listar sesiones activas con filtros
     - Lista con usuario, IP, user-agent, timestamps
   * - FR-AUTH-041
     - El sistema debe permitir cerrar sesiones individuales
     - Sesion marcada inactiva, token en blacklist
   * - FR-AUTH-042
     - El sistema debe permitir cerrar todas las sesiones de un usuario
     - Todas las sesiones del usuario cerradas en una accion
   * - FR-AUTH-043
     - El sistema debe validar funciones antes de cada accion
     - AUT-004 para ver, AUT-002 para cerrar
   * - FR-AUTH-044
     - El sistema debe registrar cierres en auditoria
     - Evento SESSION_CLOSED con admin y usuario afectado

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUTH-005: Permitir administracion de sesiones activas
   * - **Reglas de Negocio**
     - BR-AUTH-40 a BR-AUTH-44
   * - **Restricciones**
     - CNST-002 (Sesion Unica), CNST-009 (Auditoria Inmutable)
   * - **FR Derivados**
     - FR-AUTH-040 a FR-AUTH-044
   * - **UC Relacionados**
     - UC_AUTH_01 (Iniciar Sesion), UC_AUTH_02 (Cerrar Sesion)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Funcion RBAC**
     - AUT-001, AUT-002, AUT-004

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial v4.0 con funciones RBAC separadas