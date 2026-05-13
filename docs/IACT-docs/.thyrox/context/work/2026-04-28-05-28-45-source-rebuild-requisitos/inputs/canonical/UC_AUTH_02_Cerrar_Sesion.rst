.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Auth
   :uc_id: UC_AUTH_02
   :normativa: CNST-009

=========================
UC_AUTH_02: Cerrar Sesion
=========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUTH_02
   * - **Nombre**
     - Cerrar Sesion
   * - **Actor Principal**
     - Usuario (cualquier usuario autenticado)
   * - **Actor Secundario**
     - Sistema (invalidacion automatica)
   * - **Modulo**
     - MOD_Auth
   * - **Funcion RBAC**
     - (publico) - Cualquier usuario autenticado
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-AUTH-002

2. Descripcion
--------------

Este caso de uso permite a un usuario autenticado cerrar su sesion activa
de forma voluntaria. El sistema invalida los tokens JWT, marca la sesion
como cerrada y registra el evento en auditoria.

**Caracteristicas principales:**

- Invalidacion del token de acceso actual
- Invalidacion del token de refresco
- Cierre de la sesion activa en base de datos
- Registro de auditoria del cierre (CNST-009)
- Limpieza de datos de sesion en cliente

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUTH_02

   @startuml

   left to right direction

   actor "Usuario" as USER
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Auth" {
     usecase "UC_AUTH_02\nCerrar Sesion" as UC02
     usecase "Invalidar\nTokens" as INV
     usecase "Cerrar\nSesion DB" as CLOSE
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC02
   UC02 --> INV : <<include>>
   UC02 --> CLOSE : <<include>>
   UC02 --> AUD : <<include>>
   SYS --> AUD

   note right of AUD
     CNST-009: Registro inmutable
     de cierre de sesion
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
     - El usuario tiene una sesion activa valida
   * - PRE-02
     - El token de acceso es valido (no expirado)
   * - PRE-03
     - El usuario esta autenticado en el sistema

4.2 Trigger
^^^^^^^^^^^

El usuario hace clic en el boton "Cerrar Sesion" o "Logout" en la interfaz.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - El token de acceso queda invalidado
   * - POST-02
     - El token de refresco queda invalidado
   * - POST-03
     - La sesion se marca como cerrada en base de datos
   * - POST-04
     - Se registra evento LOGOUT en auditoria (CNST-009)
   * - POST-05
     - El usuario es redirigido a la pantalla de login

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Usuario
     - Hace clic en boton "Cerrar Sesion"
   * - 2
     - Sistema
     - Extrae token de acceso del header Authorization
   * - 3
     - Sistema
     - Valida que el token sea valido y no este expirado
   * - 4
     - Sistema
     - Identifica la sesion activa asociada al token
   * - 5
     - Sistema
     - Agrega token de acceso a lista negra (blacklist)
   * - 6
     - Sistema
     - Agrega token de refresco a lista negra
   * - 7
     - Sistema
     - Actualiza registro de sesion: is_active=false, closed_at=now()
   * - 8
     - Sistema
     - Registra evento LOGOUT en UserActionLog (CNST-009)
   * - 9
     - Sistema
     - Retorna respuesta exitosa (204 No Content)
   * - 10
     - Frontend
     - Limpia tokens almacenados localmente
   * - 11
     - Frontend
     - Redirige usuario a pantalla de login

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUTH_02

   @startuml

   actor "Usuario" as U
   participant "Frontend" as FE <<Frontend>>
   participant "AuthController" as AC <<Backend>>
   participant "AuthService" as AS <<Service>>
   participant "TokenBlacklist" as TB <<Service>>
   participant "SessionService" as SS <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   U -> FE: Click "Cerrar Sesion"
   activate FE

   FE -> AC: POST /api/auth/logout\nAuthorization: Bearer {token}
   activate AC

   AC -> AS: logout(token)
   activate AS

   == Validar Token ==
   AS -> AS: decode_token(token)
   AS -> DB: SELECT * FROM user_sessions\nWHERE token_hash = ?
   DB --> AS: session_data

   alt sesion no encontrada o inactiva
     AS --> AC: 401 Unauthorized
     AC --> FE: Error: sesion invalida
   end

   == Invalidar Tokens ==
   AS -> TB: blacklist_access_token(token)
   activate TB
   TB -> DB: INSERT INTO token_blacklist\n(token_hash, expires_at)
   TB --> AS: blacklisted
   deactivate TB

   AS -> TB: blacklist_refresh_token(refresh_token)
   activate TB
   TB -> DB: INSERT INTO token_blacklist
   TB --> AS: blacklisted
   deactivate TB

   == Cerrar Sesion ==
   AS -> SS: close_session(session_id)
   activate SS
   SS -> DB: UPDATE user_sessions\nSET is_active = false,\nclosed_at = now(),\nclose_reason = 'USER_LOGOUT'
   SS --> AS: session_closed
   deactivate SS

   == Registrar Auditoria (CNST-009) ==
   AS -> UAL: record(LOGOUT, user_id, ip)
   activate UAL
   note right of UAL
     CNST-009: Auditoria inmutable
     Registro de cierre voluntario
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> AS: logged
   deactivate UAL

   AS --> AC: success
   deactivate AS

   AC --> FE: 204 No Content
   deactivate AC

   FE -> FE: localStorage.clear()
   FE --> U: Redirige a /login
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Logout desde Otro Dispositivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Sistema
     - Detecta que el token ya fue invalidado (otra sesion lo cerro)
   * - 1b
     - Sistema
     - Retorna 401 con mensaje "Sesion ya cerrada"
   * - 1c
     - Frontend
     - Limpia datos locales y redirige a login

7.2 FA-02: Token Expirado Durante Logout
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 3a
     - Sistema
     - Detecta token expirado
   * - 3b
     - Sistema
     - Cierra sesion igualmente (cleanup)
   * - 3c
     - Sistema
     - Retorna 204 (logout exitoso de todas formas)

8. Excepciones
--------------

8.1 EX-01: Token Invalido o Malformado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Token no puede ser decodificado o esta corrupto
   * - **Accion Sistema**
     - Rechaza peticion, no registra logout
   * - **Mensaje Usuario**
     - "Token invalido"
   * - **Codigo Error**
     - AUTH-010

8.2 EX-02: Sesion No Encontrada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - No existe sesion asociada al token en base de datos
   * - **Accion Sistema**
     - Retorna error, posible token de sesion ya cerrada
   * - **Mensaje Usuario**
     - "Sesion no encontrada o ya cerrada"
   * - **Codigo Error**
     - AUTH-011

8.3 EX-03: Error de Base de Datos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Error al actualizar sesion en base de datos
   * - **Accion Sistema**
     - Rollback, reintento automatico, log de error
   * - **Mensaje Usuario**
     - "Error al cerrar sesion. Intente nuevamente."
   * - **Codigo Error**
     - AUTH-012

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUTH_02

   @startuml

   start

   :Usuario hace clic en "Cerrar Sesion";

   :Extraer token del header Authorization;

   if (Token presente?) then (no)
     :Retornar 401 Unauthorized;
     stop
   else (si)
   endif

   :Decodificar y validar token;

   if (Token valido?) then (no)
     :Retornar 401 Invalid Token;
     stop
   else (si)
   endif

   :Buscar sesion en base de datos;

   if (Sesion activa?) then (no)
     :Retornar 401 Session Not Found;
     stop
   else (si)
   endif

   :Agregar access_token a blacklist;

   :Agregar refresh_token a blacklist;

   :Marcar sesion como cerrada;
   note right
     is_active = false
     closed_at = now()
     close_reason = USER_LOGOUT
   end note

   :Registrar LOGOUT en auditoria;
   note right
     CNST-009
     Registro inmutable
   end note

   :Retornar 204 No Content;

   :Frontend limpia localStorage;

   :Redirigir a pantalla de login;

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
   * - BR-AUTH-10
     - Invalidacion Inmediata
     - Los tokens deben quedar invalidos inmediatamente despues del logout. No deben poder usarse para ninguna operacion posterior.
   * - BR-AUTH-11
     - Blacklist de Tokens
     - Los tokens invalidados se almacenan en blacklist hasta su fecha de expiracion original para evitar reutilizacion.
   * - BR-AUTH-12
     - Cierre Graceful
     - Si el token ya expiro, el logout debe completarse igualmente para limpiar la sesion en base de datos.
   * - BR-AUTH-13
     - Registro Obligatorio
     - Todo cierre de sesion debe registrarse en auditoria, incluyendo IP y timestamp.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-009
     - Auditoria Inmutable
     - Se registra evento LOGOUT en UserActionLog con user_id, IP, user_agent y timestamp. El registro es append-only y no puede modificarse.

**Implementacion CNST-009:**

.. code-block:: python

   # services/auth_service.py
   def logout(self, token: str, request) -> bool:
       # ... invalidar tokens y cerrar sesion ...

       UserActionLog.record(
           user=session.user,
           action='LOGOUT',
           resource=f'Session:{session.id}',
           result='SUCCESS',
           ip=request.META.get('REMOTE_ADDR'),
           user_agent=request.META.get('HTTP_USER_AGENT'),
           details={
               'logout_type': 'voluntary',
               'session_duration_minutes': session.duration_minutes
           }
       )
       return True

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUTH-010
     - El sistema debe invalidar tokens al cerrar sesion
     - Token en blacklist no permite acceso a endpoints protegidos
   * - FR-AUTH-011
     - El sistema debe marcar sesion como cerrada
     - Campo is_active=false y closed_at con timestamp
   * - FR-AUTH-012
     - El sistema debe registrar logout en auditoria
     - Evento LOGOUT visible en consulta de auditoria
   * - FR-AUTH-013
     - El sistema debe retornar 204 en logout exitoso
     - Respuesta sin contenido, status 204

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUTH-002: El sistema debe permitir cierre de sesion voluntario
   * - **Reglas de Negocio**
     - BR-AUTH-10, BR-AUTH-11, BR-AUTH-12, BR-AUTH-13
   * - **Restricciones**
     - CNST-009 (Auditoria Inmutable)
   * - **FR Derivados**
     - FR-AUTH-010 a FR-AUTH-013
   * - **UC Relacionados**
     - UC_AUTH_01 (Iniciar Sesion), UC_AUTH_05 (Gestionar Sesiones)
   * - **Actor Principal**
     - Usuario (cualquier usuario autenticado)
   * - **Funcion RBAC**
     - (publico) - Cualquier usuario autenticado

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
     - Version inicial v4.0 con nueva nomenclatura UC_AUTH_02