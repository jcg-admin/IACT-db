.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Users
   :uc_id: UC_USR_04
   :normativa: CNST-005, CNST-009

===========================
UC_USR_04: Eliminar Usuario
===========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_USR_04
   * - **Nombre**
     - Eliminar Usuario (Baja Logica)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Actor Secundario**
     - Sistema (validacion automatica)
   * - **Modulo**
     - MOD_Users
   * - **Funcion RBAC**
     - USR-004: elimina_usuarios
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-USR-004

2. Descripcion
--------------

Este caso de uso permite a un administrador de usuarios (AGR-006) dar de
baja a un usuario del sistema. La eliminacion es SIEMPRE LOGICA (CNST-005),
nunca fisica, para mantener la integridad referencial y el historial de
auditoria.

**Caracteristicas principales:**

- Baja LOGICA, nunca fisica (CNST-005)
- Estado cambia a ELIMINADO
- Cierre de todas las sesiones activas
- Revocacion de todas las funciones asignadas
- El registro permanece para auditoria
- No se puede eliminar al propio administrador
- Registro completo en auditoria (CNST-009)

**Restriccion critica CNST-005:**

.. warning::
   La eliminacion de usuarios es SIEMPRE LOGICA. El registro permanece
   en la base de datos con estado ELIMINADO. NUNCA se ejecuta DELETE
   fisico sobre la tabla de usuarios.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_USR_04

   @startuml

   left to right direction

   actor "AGR-006\nagr_admin_usuarios" as ADMIN <<AGR_ADMIN>>
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Users" {
     usecase "UC_USR_04\nEliminar Usuario" as UC04
     usecase "Cambiar Estado\na ELIMINADO" as DEL
     usecase "Cerrar\nSesiones" as CLOSE
     usecase "Revocar\nFunciones" as REV
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC04
   UC04 --> DEL : <<include>>
   UC04 --> CLOSE : <<include>>
   UC04 --> REV : <<include>>
   UC04 --> AUD : <<include>>
   SYS --> AUD

   note right of DEL
     CNST-005: Baja LOGICA
     Nunca DELETE fisico
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
     - El administrador tiene sesion activa con funcion USR-004
   * - PRE-02
     - El usuario a eliminar existe en el sistema
   * - PRE-03
     - El usuario a eliminar no es el mismo administrador
   * - PRE-04
     - El usuario no tiene estado ELIMINADO actualmente

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona un usuario y hace clic en "Eliminar Usuario".

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - El estado del usuario cambia a ELIMINADO
   * - POST-02
     - Todas las sesiones activas del usuario se cierran
   * - POST-03
     - Todas las funciones asignadas se revocan
   * - POST-04
     - El registro permanece en base de datos (baja logica)
   * - POST-05
     - Se registra USER_DELETE en auditoria (CNST-009)
   * - POST-06
     - El usuario no puede iniciar sesion

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
     - Selecciona usuario de la lista (UC_USR_02)
   * - 2
     - Admin
     - Hace clic en "Eliminar Usuario"
   * - 3
     - Sistema
     - Valida funcion USR-004 (elimina_usuarios)
   * - 4
     - Sistema
     - Verifica que no sea auto-eliminacion
   * - 5
     - Sistema
     - Verifica que estado actual no sea ELIMINADO
   * - 6
     - Sistema
     - Muestra dialogo de confirmacion con advertencias
   * - 7
     - Admin
     - Ingresa motivo de eliminacion (obligatorio)
   * - 8
     - Admin
     - Confirma eliminacion
   * - 9
     - Sistema
     - Cierra todas las sesiones activas del usuario
   * - 10
     - Sistema
     - Revoca todas las funciones asignadas al usuario
   * - 11
     - Sistema
     - Cambia estado a ELIMINADO (no DELETE fisico)
   * - 12
     - Sistema
     - Registra deleted_at, deleted_by, deleted_reason
   * - 13
     - Sistema
     - Registra USER_DELETE en UserActionLog (CNST-009)
   * - 14
     - Sistema
     - Muestra confirmacion de eliminacion
   * - 15
     - Sistema
     - Actualiza lista de usuarios

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_USR_04

   @startuml

   actor "AGR-006\nAdmin" as A
   participant "Frontend\nUsers" as FE <<Frontend>>
   participant "UserController" as UC <<Backend>>
   participant "UserService" as US <<Service>>
   participant "SessionService" as SS <<Service>>
   participant "AccessService" as AS <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Click "Eliminar Usuario"
   activate FE

   FE -> FE: Muestra dialogo confirmacion
   FE -> FE: Solicita motivo (obligatorio)
   A -> FE: Ingresa motivo
   A -> FE: Confirma eliminacion

   FE -> UC: DELETE /api/users/{id}\n{reason: "motivo"}
   activate UC

   == Validar Permisos ==
   UC -> UC: verify_function(USR-004)
   note right
     Requiere funcion
     USR-004: elimina_usuarios
   end note

   alt sin permiso USR-004
     UC --> FE: 403 Forbidden
     FE --> A: Error: Sin permisos
   end

   UC -> US: delete_user(id, admin, reason)
   activate US

   == Validar Usuario ==
   US -> DB: SELECT * FROM users WHERE id = ?
   DB --> US: user

   alt usuario no existe
     US --> UC: UserNotFoundError
     UC --> FE: 404 Not Found
   end

   alt admin == user (auto-eliminacion)
     US --> UC: SelfDeleteError
     UC --> FE: 400 Bad Request
   end

   alt estado == ELIMINADO
     US --> UC: AlreadyDeletedError
     UC --> FE: 400 Bad Request
   end

   == Cerrar Sesiones ==
   US -> SS: close_all_sessions(user_id)
   activate SS
   SS -> DB: UPDATE user_sessions\nSET is_active = false
   SS --> US: sessions_closed
   deactivate SS

   == Revocar Funciones ==
   US -> AS: revoke_all_functions(user_id)
   activate AS
   AS -> DB: DELETE FROM user_functions\nWHERE user_id = ?
   note right of AS
     Las funciones se eliminan
     pero queda registro en
     auditoria
   end note
   AS --> US: functions_revoked
   deactivate AS

   == Baja Logica (CNST-005) ==
   US -> DB: UPDATE users SET\nstatus = 'ELIMINADO',\ndeleted_at = now(),\ndeleted_by = admin_id,\ndeleted_reason = reason
   note right of DB
     CNST-005: Baja LOGICA
     NO se ejecuta DELETE
     El registro permanece
   end note

   == Registrar Auditoria (CNST-009) ==
   US -> UAL: record(USER_DELETE, admin, user, reason)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Incluye motivo y admin
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> US: logged
   deactivate UAL

   US --> UC: {success: true, deleted_at: timestamp}
   deactivate US

   UC --> FE: 200 OK
   deactivate UC

   FE -> FE: Actualiza lista (usuario desaparece)
   FE --> A: Confirmacion: Usuario eliminado
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Cancelar Eliminacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Admin
     - Cancela el dialogo de confirmacion
   * - 8b
     - Sistema
     - No realiza ninguna accion
   * - 8c
     - Sistema
     - Permanece en detalle del usuario

7.2 FA-02: Usuario con Dependencias Criticas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Sistema
     - Detecta que usuario tiene alertas activas
   * - 6b
     - Sistema
     - Muestra advertencia adicional en dialogo
   * - 6c
     - Sistema
     - Las alertas del usuario se pausan automaticamente

8. Excepciones
--------------

8.1 EX-01: Sin Permiso USR-004
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Administrador no tiene funcion USR-004
   * - **Accion Sistema**
     - Rechaza eliminacion
   * - **Mensaje Usuario**
     - "No tiene permisos para eliminar usuarios"
   * - **Codigo Error**
     - USR-030

8.2 EX-02: Usuario No Encontrado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - ID de usuario no existe
   * - **Accion Sistema**
     - Retorna error 404
   * - **Mensaje Usuario**
     - "Usuario no encontrado"
   * - **Codigo Error**
     - USR-031

8.3 EX-03: Auto-Eliminacion No Permitida
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - Admin intenta eliminarse a si mismo
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "No puede eliminar su propia cuenta"
   * - **Codigo Error**
     - USR-032

8.4 EX-04: Usuario Ya Eliminado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Usuario ya tiene estado ELIMINADO
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "El usuario ya fue eliminado anteriormente"
   * - **Codigo Error**
     - USR-033

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_USR_04

   @startuml

   start

   :Admin selecciona usuario;

   :Admin hace clic en "Eliminar";

   if (Tiene funcion USR-004?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   if (Es auto-eliminacion?) then (si)
     :Error: No puede eliminarse;
     stop
   else (no)
   endif

   if (Estado == ELIMINADO?) then (si)
     :Error: Ya eliminado;
     stop
   else (no)
   endif

   :Mostrar dialogo confirmacion;
   :Solicitar motivo (obligatorio);

   if (Admin confirma?) then (no)
     :Cancelar operacion;
     stop
   else (si)
   endif

   :Cerrar todas las sesiones activas;

   :Revocar todas las funciones;

   :Cambiar estado a ELIMINADO;
   note right
     CNST-005
     Baja LOGICA
     NO DELETE fisico
   end note

   :Registrar deleted_at, deleted_by, reason;

   :Registrar USER_DELETE en auditoria;
   note right
     CNST-009
     Registro inmutable
   end note

   :Actualizar lista de usuarios;

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
   * - BR-USR-30
     - Baja Logica Obligatoria
     - La eliminacion de usuarios SIEMPRE es logica. El registro permanece en base de datos con estado ELIMINADO.
   * - BR-USR-31
     - Motivo Obligatorio
     - La eliminacion requiere un motivo que se registra en auditoria y en el campo deleted_reason.
   * - BR-USR-32
     - Sin Auto-Eliminacion
     - Un administrador no puede eliminar su propia cuenta.
   * - BR-USR-33
     - Cierre de Sesiones
     - Al eliminar, todas las sesiones activas del usuario se cierran automaticamente.
   * - BR-USR-34
     - Revocacion de Funciones
     - Al eliminar, todas las funciones asignadas se revocan automaticamente.
   * - BR-USR-35
     - Sin Recuperacion
     - Un usuario ELIMINADO no puede ser reactivado. Se debe crear nuevo usuario si es necesario.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-005
     - RBAC Flat / Baja Logica
     - La eliminacion es SIEMPRE logica. Se ejecuta UPDATE SET status='ELIMINADO', NUNCA DELETE FROM users. El registro permanece para integridad referencial y auditoria.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra USER_DELETE en UserActionLog con: admin ejecutor, usuario eliminado, motivo, timestamp. El registro de auditoria permanece aunque el usuario este eliminado.

**Implementacion CNST-005:**

.. code-block:: python

   # services/user_service.py
   def delete_user(self, user_id: int, admin: User, reason: str) -> dict:
       user = User.objects.get(id=user_id)

       # Cerrar sesiones
       SessionService.close_all_sessions(user_id)

       # Revocar funciones
       UserFunction.objects.filter(user_id=user_id).delete()

       # CNST-005: Baja LOGICA, nunca DELETE fisico
       user.status = UserStatus.ELIMINADO
       user.deleted_at = timezone.now()
       user.deleted_by = admin
       user.deleted_reason = reason
       user.save()

       # PROHIBIDO:
       # user.delete()  # NUNCA ejecutar delete fisico
       # User.objects.filter(id=user_id).delete()  # PROHIBIDO

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-USR-030
     - El sistema debe implementar baja logica
     - Estado cambia a ELIMINADO, registro permanece
   * - FR-USR-031
     - El sistema debe requerir motivo de eliminacion
     - Campo reason obligatorio, registrado en BD
   * - FR-USR-032
     - El sistema debe cerrar sesiones al eliminar
     - Todas las sesiones marcadas inactivas
   * - FR-USR-033
     - El sistema debe revocar funciones al eliminar
     - user_functions vacio para ese usuario
   * - FR-USR-034
     - El sistema debe impedir auto-eliminacion
     - Error 400 si admin == user

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-USR-004: Permitir eliminacion de usuarios del sistema
   * - **Reglas de Negocio**
     - BR-USR-30 a BR-USR-35
   * - **Restricciones**
     - CNST-005 (Baja Logica), CNST-009 (Auditoria Inmutable)
   * - **FR Derivados**
     - FR-USR-030 a FR-USR-034
   * - **UC Relacionados**
     - UC_USR_02 (Consultar Usuarios), UC_USR_03 (Modificar Usuario), UC_AUTH_05 (Gestionar Sesiones)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Funcion RBAC**
     - USR-004: elimina_usuarios

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
     - Version inicial v4.0 con CNST-005 baja logica