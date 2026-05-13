.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Auth
   :uc_id: UC_AUTH_04
   :normativa: CNST-002, CNST-009

==============================
UC_AUTH_04: Cambiar Contrasena
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUTH_04
   * - **Nombre**
     - Cambiar Contrasena
   * - **Actor Principal**
     - Usuario (cualquier usuario autenticado)
   * - **Actor Secundario**
     - Sistema (validacion automatica)
   * - **Modulo**
     - MOD_Auth
   * - **Funcion RBAC**
     - (publico) - Cualquier usuario autenticado
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUTH-004

2. Descripcion
--------------

Este caso de uso permite a cualquier usuario autenticado cambiar su propia
contrasena. Se requiere conocer la contrasena actual para poder establecer
una nueva. Este UC se invoca obligatoriamente cuando:

- El usuario tiene estado PENDIENTE_CONFIGURACION (primer login o post-reset)
- La contrasena ha expirado (mas de 90 dias sin cambiar)

**Caracteristicas principales:**

- Validacion de contrasena actual
- Politica de complejidad de contrasena
- Verificacion de historial (no reutilizar ultimas 5)
- Actualizacion de estado a ACTIVO si era PENDIENTE
- Cierre opcional de otras sesiones
- Registro en auditoria (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUTH_04

   @startuml

   left to right direction

   actor "Usuario" as USER
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Auth" {
     usecase "UC_AUTH_04\nCambiar Contrasena" as UC04
     usecase "Validar Password\nActual" as VAL
     usecase "Verificar\nComplejidad" as COMP
     usecase "Verificar\nHistorial" as HIST
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC04
   UC04 --> VAL : <<include>>
   UC04 --> COMP : <<include>>
   UC04 --> HIST : <<include>>
   UC04 --> AUD : <<include>>
   SYS --> AUD

   note right of HIST
     No reutilizar
     ultimas 5 contrasenas
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
     - El usuario conoce su contrasena actual
   * - PRE-03
     - El sistema esta operativo

4.2 Trigger
^^^^^^^^^^^

- Usuario accede voluntariamente a "Cambiar Contrasena" desde su perfil
- Sistema redirige automaticamente tras login con estado PENDIENTE_CONFIGURACION
- Sistema redirige automaticamente tras login con contrasena expirada

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - La nueva contrasena se almacena hasheada (bcrypt)
   * - POST-02
     - La contrasena anterior se guarda en historial
   * - POST-03
     - password_changed_at se actualiza a timestamp actual
   * - POST-04
     - Si estado era PENDIENTE, cambia a ACTIVO
   * - POST-05
     - Se registra PASSWORD_CHANGE en auditoria (CNST-009)
   * - POST-06
     - Opcionalmente se cierran otras sesiones

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
     - Accede a la pantalla de cambio de contrasena
   * - 2
     - Sistema
     - Presenta formulario (contrasena actual, nueva, confirmacion)
   * - 3
     - Usuario
     - Ingresa contrasena actual
   * - 4
     - Usuario
     - Ingresa nueva contrasena
   * - 5
     - Usuario
     - Confirma nueva contrasena
   * - 6
     - Usuario
     - Presiona "Cambiar Contrasena"
   * - 7
     - Sistema
     - Valida que nueva y confirmacion coincidan
   * - 8
     - Sistema
     - Verifica contrasena actual contra hash almacenado
   * - 9
     - Sistema
     - Valida complejidad de nueva contrasena (politica)
   * - 10
     - Sistema
     - Verifica que nueva contrasena no este en historial
   * - 11
     - Sistema
     - Guarda contrasena actual en historial (max 5)
   * - 12
     - Sistema
     - Hashea nueva contrasena con bcrypt
   * - 13
     - Sistema
     - Actualiza password_hash en base de datos
   * - 14
     - Sistema
     - Actualiza password_changed_at a timestamp actual
   * - 15
     - Sistema
     - Si estado=PENDIENTE, actualiza a ACTIVO
   * - 16
     - Sistema
     - Registra PASSWORD_CHANGE en UserActionLog (CNST-009)
   * - 17
     - Sistema
     - Muestra confirmacion exitosa
   * - 18
     - Sistema
     - Redirige al dashboard (o login si era obligatorio)

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUTH_04

   @startuml

   actor "Usuario" as U
   participant "Frontend\nProfile" as FE <<Frontend>>
   participant "AuthController" as AC <<Backend>>
   participant "PasswordService" as PS <<Service>>
   participant "PasswordValidator" as PV <<Service>>
   participant "PasswordHistory" as PH <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   U -> FE: Accede a cambio de contrasena
   activate FE

   FE -> FE: Muestra formulario
   U -> FE: Ingresa actual, nueva, confirmacion
   U -> FE: Click "Cambiar"

   FE -> FE: Valida coincidencia nueva == confirmacion

   FE -> AC: POST /api/auth/change-password\n{current, new_password}
   activate AC

   AC -> PS: change_password(user, current, new)
   activate PS

   == Validar Password Actual ==
   PS -> DB: SELECT password_hash FROM users
   DB --> PS: hash
   PS -> PS: bcrypt.verify(current, hash)

   alt password actual incorrecto
     PS --> AC: InvalidCurrentPasswordError
     AC --> FE: 401 Unauthorized
     FE --> U: Error: Contrasena actual incorrecta
   end

   == Validar Complejidad ==
   PS -> PV: validate(new_password)
   activate PV
   PV -> PV: check_length(min=8)
   PV -> PV: check_uppercase()
   PV -> PV: check_lowercase()
   PV -> PV: check_digit()
   PV -> PV: check_special()

   alt no cumple politica
     PV --> PS: PolicyViolationError
     PS --> AC: 400 Bad Request
     AC --> FE: Error: Requisitos no cumplidos
   end

   PV --> PS: valid
   deactivate PV

   == Verificar Historial ==
   PS -> PH: check_not_reused(user_id, new_password)
   activate PH
   PH -> DB: SELECT hash FROM password_history\nWHERE user_id = ?\nORDER BY created_at DESC LIMIT 5
   DB --> PH: previous_hashes
   PH -> PH: bcrypt.verify(new, each_hash)

   alt password en historial
     PH --> PS: PasswordReusedError
     PS --> AC: 400 Bad Request
     AC --> FE: Error: No reutilizar ultimas 5
   end

   PH --> PS: not_reused
   deactivate PH

   == Guardar en Historial ==
   PS -> PH: save_current(user_id, current_hash)
   PH -> DB: INSERT INTO password_history\nDELETE old if > 5

   == Actualizar Password ==
   PS -> PS: bcrypt.hash(new_password)
   PS -> DB: UPDATE users SET\npassword_hash = ?,\npassword_changed_at = now()

   == Actualizar Estado si PENDIENTE ==
   PS -> DB: UPDATE users SET status = 'ACTIVO'\nWHERE status = 'PENDIENTE_CONFIGURACION'

   == Registrar Auditoria (CNST-009) ==
   PS -> UAL: record(PASSWORD_CHANGE, user_id)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Solo registra el evento,
     NUNCA el password
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> PS: logged
   deactivate UAL

   PS --> AC: {success: true, status_updated: true/false}
   deactivate PS

   AC --> FE: 200 OK
   deactivate AC

   FE --> U: Confirmacion: Contrasena actualizada
   FE -> FE: Redirige a dashboard
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Cambio Obligatorio (Post-Reset)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Sistema
     - Detecta flag requires_password_change=true del login
   * - 1b
     - Sistema
     - Redirige automaticamente a pantalla de cambio
   * - 1c
     - Sistema
     - Bloquea navegacion hasta completar cambio

7.2 FA-02: Password Expirado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Sistema
     - Detecta flag password_expired=true del login
   * - 1b
     - Sistema
     - Muestra mensaje: "Su contrasena ha expirado"
   * - 1c
     - Sistema
     - Requiere cambio antes de continuar

7.3 FA-03: Cerrar Otras Sesiones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Usuario
     - Marca checkbox "Cerrar otras sesiones"
   * - 17a
     - Sistema
     - Cierra todas las sesiones excepto la actual
   * - 17b
     - Sistema
     - Incluye en auditoria: close_other_sessions=true

8. Excepciones
--------------

8.1 EX-01: Contrasena Actual Incorrecta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - Contrasena actual no coincide con hash almacenado
   * - **Accion Sistema**
     - Rechaza cambio, registra intento fallido
   * - **Mensaje Usuario**
     - "Contrasena actual incorrecta"
   * - **Codigo Error**
     - AUTH-030

8.2 EX-02: No Cumple Politica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Nueva contrasena no cumple requisitos de complejidad
   * - **Accion Sistema**
     - Muestra requisitos faltantes
   * - **Mensaje Usuario**
     - "La contrasena debe tener: [requisitos]"
   * - **Codigo Error**
     - AUTH-031

8.3 EX-03: Contrasena Reutilizada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Nueva contrasena coincide con alguna de las ultimas 5
   * - **Accion Sistema**
     - Rechaza cambio
   * - **Mensaje Usuario**
     - "No puede reutilizar las ultimas 5 contrasenas"
   * - **Codigo Error**
     - AUTH-032

8.4 EX-04: Confirmacion No Coincide
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Campo nueva != campo confirmacion
   * - **Accion Sistema**
     - Validacion en frontend, no llega al backend
   * - **Mensaje Usuario**
     - "Las contrasenas no coinciden"
   * - **Codigo Error**
     - AUTH-033 (frontend)

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUTH_04

   @startuml

   start

   if (Cambio obligatorio?) then (si)
     :Mostrar mensaje de requerimiento;
   else (no)
     :Usuario accede voluntariamente;
   endif

   :Mostrar formulario de cambio;

   :Usuario ingresa: actual, nueva, confirmacion;

   if (Nueva == Confirmacion?) then (no)
     :Error: No coinciden;
     stop
   else (si)
   endif

   :Verificar password actual;

   if (Actual correcto?) then (no)
     :Error: Password actual incorrecto;
     stop
   else (si)
   endif

   :Validar complejidad nueva;

   if (Cumple politica?) then (no)
     :Mostrar requisitos faltantes;
     stop
   else (si)
   endif

   :Verificar historial (ultimas 5);

   if (Esta en historial?) then (si)
     :Error: No reutilizar;
     stop
   else (no)
   endif

   :Guardar actual en historial;

   :Hashear nueva contrasena;

   :Actualizar password_hash;

   :Actualizar password_changed_at;

   if (Estado = PENDIENTE?) then (si)
     :Cambiar estado a ACTIVO;
   else (no)
   endif

   :Registrar PASSWORD_CHANGE;
   note right
     CNST-009
     Sin passwords
   end note

   :Mostrar confirmacion;

   :Redirigir a dashboard;

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
   * - BR-AUTH-30
     - Verificar Actual
     - Se debe verificar la contrasena actual antes de permitir el cambio.
   * - BR-AUTH-31
     - Politica de Complejidad
     - Minimo 8 caracteres, al menos: 1 mayuscula, 1 minuscula, 1 numero, 1 caracter especial.
   * - BR-AUTH-32
     - Sin Reutilizacion
     - No se pueden reutilizar las ultimas 5 contrasenas.
   * - BR-AUTH-33
     - Expiracion
     - Las contrasenas expiran a los 90 dias de creadas.
   * - BR-AUTH-34
     - Activacion
     - Usuarios en PENDIENTE_CONFIGURACION pasan a ACTIVO al cambiar contrasena.
   * - BR-AUTH-35
     - Sin Log Password
     - NUNCA se registra el password en logs o auditoria.

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
     - Si el usuario elige "Cerrar otras sesiones", se aplica SessionService.close_other_sessions(). La sesion actual permanece activa.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra evento PASSWORD_CHANGE en UserActionLog. NUNCA se incluye el password ni nuevo ni anterior en el registro.

**Implementacion CNST-009:**

.. code-block:: python

   # CORRECTO: Solo registrar evento, sin passwords
   UserActionLog.record(
       user=user,
       action='PASSWORD_CHANGE',
       resource=f'User:{user.id}',
       result='SUCCESS',
       ip=request.META.get('REMOTE_ADDR'),
       details={
           'trigger': 'voluntary|mandatory|expired',
           'status_changed': True/False,
           'other_sessions_closed': True/False
       }
       # PROHIBIDO: 'old_password', 'new_password'
   )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUTH-030
     - El sistema debe validar contrasena actual antes de cambio
     - Rechazo con 401 si actual es incorrecta
   * - FR-AUTH-031
     - El sistema debe aplicar politica de complejidad
     - Rechazo con lista de requisitos faltantes
   * - FR-AUTH-032
     - El sistema debe mantener historial de 5 contrasenas
     - Rechazo si nueva coincide con alguna
   * - FR-AUTH-033
     - El sistema debe actualizar estado PENDIENTE a ACTIVO
     - Usuario puede operar normalmente post-cambio
   * - FR-AUTH-034
     - El sistema debe registrar cambio sin incluir passwords
     - Auditoria visible, sin datos sensibles

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUTH-004: Permitir cambio de contrasena por usuario
   * - **Reglas de Negocio**
     - BR-AUTH-30 a BR-AUTH-35
   * - **Restricciones**
     - CNST-002 (Sesion Unica), CNST-009 (Auditoria sin PII)
   * - **FR Derivados**
     - FR-AUTH-030 a FR-AUTH-034
   * - **UC Relacionados**
     - UC_AUTH_01 (Iniciar Sesion), UC_AUTH_03 (Recuperar Contrasena)
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
     - Version inicial v4.0 con politica de historial