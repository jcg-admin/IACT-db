.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Auth
   :uc_id: UC_AUTH_01
   :normativa: CNST-002, CNST-009

==========================
UC_AUTH_01: Iniciar Sesion
==========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUTH_01
   * - **Nombre**
     - Iniciar Sesion
   * - **Actor Principal**
     - Usuario (cualquier usuario registrado)
   * - **Actor Secundario**
     - Sistema (validacion automatica)
   * - **Modulo**
     - MOD_Auth
   * - **Funcion RBAC**
     - (publico) - No requiere funcion previa
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUTH-001

2. Descripcion
--------------

Este caso de uso permite a un usuario registrado autenticarse en el sistema
IACT mediante sus credenciales (username y password). El sistema valida las
credenciales, verifica el estado del usuario, aplica las restricciones de
sesion unica (CNST-002) y genera los tokens JWT correspondientes.

**Caracteristicas principales:**

- Autenticacion mediante username y password
- Generacion de tokens JWT (access + refresh)
- Sesion unica por usuario (cierra sesiones anteriores)
- Throttling de intentos fallidos (5 intentos / 5 minutos)
- Bloqueo temporal tras exceder intentos
- Deteccion de primer login para cambio de password obligatorio
- Registro de auditoria de todos los intentos (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUTH_01

   @startuml

   left to right direction

   actor "Usuario" as USER
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Auth" {
     usecase "UC_AUTH_01\nIniciar Sesion" as UC01
     usecase "Validar\nCredenciales" as VAL
     usecase "Generar\nTokens JWT" as TOK
     usecase "Cerrar Sesiones\nAnteriores" as CLOSE
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC01
   UC01 --> VAL : <<include>>
   UC01 --> TOK : <<include>>
   UC01 --> CLOSE : <<include>>
   UC01 --> AUD : <<include>>
   SYS --> AUD

   note right of CLOSE
     CNST-002: Sesion unica
     Nueva sesion cierra anteriores
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
     - El usuario existe en el sistema con estado ACTIVO o PENDIENTE_CONFIGURACION
   * - PRE-02
     - El usuario no esta bloqueado temporalmente por exceso de intentos
   * - PRE-03
     - El usuario conoce sus credenciales (username y password)
   * - PRE-04
     - El sistema esta operativo y accesible

4.2 Trigger
^^^^^^^^^^^

El usuario accede a la pantalla de login e ingresa sus credenciales.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera un token de acceso JWT valido
   * - POST-02
     - Se genera un token de refresco JWT valido
   * - POST-03
     - Se crea un registro de sesion activa
   * - POST-04
     - Se cierran todas las sesiones anteriores del usuario (CNST-002)
   * - POST-05
     - Se registra el evento LOGIN_SUCCESS en auditoria (CNST-009)
   * - POST-06
     - Se reinicia el contador de intentos fallidos

**Fallo:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-F1
     - Se incrementa el contador de intentos fallidos
   * - POST-F2
     - Se registra el evento LOGIN_FAILURE en auditoria (CNST-009)
   * - POST-F3
     - Si se exceden 5 intentos, se bloquea temporalmente (15 min)

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
     - Accede a la pantalla de login del sistema
   * - 2
     - Sistema
     - Presenta formulario de login (username, password)
   * - 3
     - Usuario
     - Ingresa username y password
   * - 4
     - Usuario
     - Presiona boton "Iniciar Sesion"
   * - 5
     - Sistema
     - Valida formato de campos (no vacios, longitud minima)
   * - 6
     - Sistema
     - Verifica throttling: consulta intentos fallidos en ultimos 5 min
   * - 7
     - Sistema
     - Busca usuario por username en base de datos Analytics
   * - 8
     - Sistema
     - Verifica que el estado del usuario sea ACTIVO o PENDIENTE_CONFIGURACION
   * - 9
     - Sistema
     - Valida password contra hash almacenado (bcrypt)
   * - 10
     - Sistema
     - Cierra todas las sesiones activas anteriores del usuario (CNST-002)
   * - 11
     - Sistema
     - Genera token de acceso JWT (expiracion: 15 minutos)
   * - 12
     - Sistema
     - Genera token de refresco JWT (expiracion: 8 horas)
   * - 13
     - Sistema
     - Crea registro en tabla UserSession con datos de sesion
   * - 14
     - Sistema
     - Registra evento LOGIN_SUCCESS en UserActionLog (CNST-009)
   * - 15
     - Sistema
     - Reinicia contador de intentos fallidos
   * - 16
     - Sistema
     - Retorna tokens y datos basicos del usuario
   * - 17
     - Sistema
     - Si estado es PENDIENTE_CONFIGURACION, indica cambio de password requerido
   * - 18
     - Usuario
     - Recibe confirmacion y es redirigido al dashboard o cambio de password

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUTH_01

   @startuml

   actor "Usuario" as U
   participant "Frontend\nLogin" as FE <<Frontend>>
   participant "AuthController" as AC <<Backend>>
   participant "AuthService" as AS <<Service>>
   participant "ThrottleService" as TS <<Service>>
   participant "SessionService" as SS <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   U -> FE: Ingresa credenciales
   activate FE

   FE -> AC: POST /api/auth/login\n{username, password}
   activate AC

   AC -> AS: authenticate(username, password)
   activate AS

   == Verificar Throttling ==
   AS -> TS: check_attempts(username)
   activate TS
   TS -> DB: SELECT failed_attempts\nWHERE username AND last_5_min
   DB --> TS: count
   alt intentos >= 5
     TS --> AS: ThrottleError
     AS --> AC: 429 Too Many Requests
     AC --> FE: Error: cuenta bloqueada 15 min
     FE --> U: Muestra mensaje de bloqueo
   end
   TS --> AS: OK (intentos < 5)
   deactivate TS

   == Validar Usuario ==
   AS -> DB: SELECT * FROM users\nWHERE username = ?
   DB --> AS: user_data

   alt usuario no existe
     AS -> UAL: record(LOGIN_FAILURE, "user_not_found")
     AS --> AC: 401 Unauthorized
   end

   alt estado != ACTIVO && estado != PENDIENTE
     AS -> UAL: record(LOGIN_FAILURE, "invalid_status")
     AS --> AC: 401 Unauthorized
   end

   == Validar Password ==
   AS -> AS: bcrypt.verify(password, hash)

   alt password invalido
     AS -> TS: increment_attempts(username)
     AS -> UAL: record(LOGIN_FAILURE, "invalid_password")
     AS --> AC: 401 Unauthorized
   end

   == Cerrar Sesiones Anteriores (CNST-002) ==
   AS -> SS: close_all_sessions(user_id)
   activate SS
   note right of SS
     CNST-002: Sesion unica
     Cierra todas las sesiones
     activas del usuario
   end note
   SS -> DB: UPDATE user_sessions\nSET is_active = false\nWHERE user_id = ?
   SS --> AS: sessions_closed
   deactivate SS

   == Generar Tokens ==
   AS -> AS: generate_access_token(user, 15min)
   AS -> AS: generate_refresh_token(user, 8h)

   == Crear Nueva Sesion ==
   AS -> DB: INSERT INTO user_sessions\n(user_id, token, ip, user_agent)

   == Registrar Auditoria (CNST-009) ==
   AS -> UAL: record(LOGIN_SUCCESS, user_id, ip)
   activate UAL
   note right of UAL
     CNST-009: Auditoria inmutable
     Registro append-only
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> AS: logged
   deactivate UAL

   == Reset Intentos ==
   AS -> TS: reset_attempts(username)

   AS --> AC: {access_token, refresh_token,\nuser_info, requires_password_change}
   deactivate AS

   AC --> FE: 200 OK + tokens + user
   deactivate AC

   FE --> U: Redirige a dashboard\no cambio de password
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Primer Login (Cambio de Password Requerido)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 17a
     - Sistema
     - Detecta estado PENDIENTE_CONFIGURACION
   * - 17b
     - Sistema
     - Incluye flag requires_password_change=true en respuesta
   * - 17c
     - Sistema
     - Frontend redirige a UC_AUTH_04 (Cambiar Contrasena)

7.2 FA-02: Password Expirado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 9a
     - Sistema
     - Detecta que password_changed_at > 90 dias
   * - 9b
     - Sistema
     - Login exitoso pero con flag password_expired=true
   * - 9c
     - Sistema
     - Frontend redirige a UC_AUTH_04

8. Excepciones
--------------

8.1 EX-01: Usuario No Existe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Username no encontrado en base de datos
   * - **Accion Sistema**
     - Registra intento fallido, retorna error generico
   * - **Mensaje Usuario**
     - "Credenciales invalidas"
   * - **Codigo Error**
     - AUTH-001

8.2 EX-02: Password Incorrecto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Password no coincide con hash almacenado
   * - **Accion Sistema**
     - Incrementa contador, registra en auditoria
   * - **Mensaje Usuario**
     - "Credenciales invalidas"
   * - **Codigo Error**
     - AUTH-001

8.3 EX-03: Usuario Bloqueado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - Estado del usuario es BLOQUEADO
   * - **Accion Sistema**
     - Registra intento, retorna error especifico
   * - **Mensaje Usuario**
     - "Cuenta bloqueada. Contacte al administrador."
   * - **Codigo Error**
     - AUTH-002

8.4 EX-04: Usuario Inactivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - Estado del usuario es INACTIVO o ELIMINADO
   * - **Accion Sistema**
     - Registra intento, retorna error generico
   * - **Mensaje Usuario**
     - "Credenciales invalidas"
   * - **Codigo Error**
     - AUTH-001

8.5 EX-05: Throttling Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - 5 o mas intentos fallidos en ultimos 5 minutos
   * - **Accion Sistema**
     - Bloquea temporalmente, registra en auditoria
   * - **Mensaje Usuario**
     - "Demasiados intentos fallidos. Intente en 15 minutos."
   * - **Codigo Error**
     - AUTH-003

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUTH_01

   @startuml

   start

   :Usuario accede a pantalla de login;

   :Ingresa username y password;

   :Presiona "Iniciar Sesion";

   if (Campos validos?) then (no)
     :Mostrar errores de validacion;
     stop
   else (si)
   endif

   :Verificar throttling;

   if (Intentos >= 5 en 5 min?) then (si)
     :Registrar LOGIN_BLOCKED;
     :Mostrar "Cuenta bloqueada 15 min";
     stop
   else (no)
   endif

   :Buscar usuario por username;

   if (Usuario existe?) then (no)
     :Incrementar intentos;
     :Registrar LOGIN_FAILURE;
     :Mostrar "Credenciales invalidas";
     stop
   else (si)
   endif

   if (Estado valido?) then (no)
     :Registrar LOGIN_FAILURE;
     :Mostrar error apropiado;
     stop
   else (si)
   endif

   :Validar password con bcrypt;

   if (Password correcto?) then (no)
     :Incrementar intentos;
     :Registrar LOGIN_FAILURE;
     :Mostrar "Credenciales invalidas";
     stop
   else (si)
   endif

   :Cerrar sesiones anteriores;
   note right
     CNST-002
     Sesion unica
   end note

   :Generar access_token (15 min);

   :Generar refresh_token (8 h);

   :Crear registro de sesion;

   :Registrar LOGIN_SUCCESS;
   note right
     CNST-009
     Auditoria inmutable
   end note

   :Reiniciar contador de intentos;

   if (Requiere cambio password?) then (si)
     :Redirigir a UC_AUTH_04;
   else (no)
     :Redirigir a Dashboard;
   endif

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
   * - BR-AUTH-01
     - Sesion Unica
     - Un usuario solo puede tener una sesion activa a la vez. Al iniciar nueva sesion, las anteriores se invalidan automaticamente.
   * - BR-AUTH-02
     - Throttling de Login
     - Maximo 5 intentos fallidos en ventana de 5 minutos. Exceder genera bloqueo temporal de 15 minutos.
   * - BR-AUTH-03
     - Token de Acceso
     - Expiracion de 15 minutos. Debe renovarse via refresh token.
   * - BR-AUTH-04
     - Token de Refresco
     - Expiracion de 8 horas. Permite obtener nuevos access tokens sin re-login.
   * - BR-AUTH-05
     - Primer Login
     - Usuarios con estado PENDIENTE_CONFIGURACION deben cambiar password obligatoriamente.
   * - BR-AUTH-06
     - Password Expirado
     - Passwords mayores a 90 dias requieren cambio obligatorio.
   * - BR-AUTH-07
     - Mensaje Generico
     - Por seguridad, errores de usuario inexistente y password incorrecto muestran el mismo mensaje.

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
     - Al autenticar exitosamente, se cierran todas las sesiones activas anteriores del usuario mediante SessionService.close_all_sessions(). Timeout de inactividad: 15 minutos.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra en UserActionLog tanto intentos exitosos (LOGIN_SUCCESS) como fallidos (LOGIN_FAILURE, LOGIN_BLOCKED). Los registros son append-only y no pueden modificarse ni eliminarse.

**Implementacion CNST-002:**

.. code-block:: python

   # services/session_service.py
   def close_all_sessions(self, user_id: int) -> int:
       """Cierra todas las sesiones activas del usuario."""
       count = UserSession.objects.filter(
           user_id=user_id,
           is_active=True
       ).update(
           is_active=False,
           closed_at=timezone.now(),
           close_reason='NEW_LOGIN'
       )
       return count

**Implementacion CNST-009:**

.. code-block:: python

   # Registro de login exitoso
   UserActionLog.record(
       user=user,
       action='LOGIN_SUCCESS',
       resource=f'Session:{session.id}',
       result='SUCCESS',
       ip=request.META.get('REMOTE_ADDR'),
       user_agent=request.META.get('HTTP_USER_AGENT'),
       details={'method': 'password', 'mfa': False}
   )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUTH-001
     - El sistema debe validar credenciales contra base de datos Analytics
     - Login exitoso con credenciales validas en menos de 2 segundos
   * - FR-AUTH-002
     - El sistema debe generar tokens JWT firmados
     - Tokens validos verificables con clave publica
   * - FR-AUTH-003
     - El sistema debe implementar throttling de intentos
     - Bloqueo efectivo tras 5 intentos fallidos
   * - FR-AUTH-004
     - El sistema debe cerrar sesiones anteriores
     - Solo una sesion activa por usuario en cualquier momento
   * - FR-AUTH-005
     - El sistema debe registrar todos los intentos de login
     - Eventos LOGIN_SUCCESS y LOGIN_FAILURE en auditoria
   * - FR-AUTH-006
     - El sistema debe detectar primer login
     - Flag requires_password_change cuando estado=PENDIENTE_CONFIGURACION
   * - FR-AUTH-007
     - El sistema debe detectar password expirado
     - Flag password_expired cuando password_changed_at > 90 dias

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUTH-001: El sistema debe permitir autenticacion de usuarios
   * - **Reglas de Negocio**
     - BR-AUTH-01, BR-AUTH-02, BR-AUTH-03, BR-AUTH-04, BR-AUTH-05, BR-AUTH-06, BR-AUTH-07
   * - **Restricciones**
     - CNST-002 (Sesion Unica), CNST-009 (Auditoria Inmutable)
   * - **FR Derivados**
     - FR-AUTH-001 a FR-AUTH-007
   * - **UC Relacionados**
     - UC_AUTH_02 (Cerrar Sesion), UC_AUTH_03 (Recuperar Contrasena), UC_AUTH_04 (Cambiar Contrasena)
   * - **Actor Principal**
     - Usuario (cualquier usuario registrado)
   * - **Funcion RBAC**
     - (publico) - No requiere funcion previa

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
     - Version inicial v4.0 con nueva nomenclatura UC_AUTH_01


.. toctree::
   :hidden:
   :maxdepth: 1

   UC_AUTH_01_Iniciar_Sesion
   UC_AUTH_02_Cerrar_Sesion
   UC_AUTH_03_Recuperar_Contrasena
   UC_AUTH_04_Cambiar_Contrasena
   UC_AUTH_05_Gestionar_Sesiones
