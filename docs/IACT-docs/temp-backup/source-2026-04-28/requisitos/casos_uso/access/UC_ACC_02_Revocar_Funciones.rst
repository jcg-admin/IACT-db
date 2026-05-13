.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_02
   :normativa: CNST-005, CNST-009

============================
UC_ACC_02: Revocar Funciones
============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_02
   * - **Nombre**
     - Revocar Funciones
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Actor Secundario**
     - Sistema (validacion automatica)
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-002: revoca_funciones
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-ACC-002

2. Descripcion
--------------

Este caso de uso permite a un administrador de acceso (AGR-007) revocar
funciones previamente asignadas a un usuario. La revocacion tiene efecto
inmediato y se registra en auditoria.

**Caracteristicas principales:**

- Revocacion de funciones individuales o multiples
- Efecto inmediato en permisos del usuario
- Validacion de permisos minimos (no dejar sin acceso basico)
- Registro detallado en auditoria (CNST-009)
- Opcion de revocar todas las funciones

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_02

   @startuml

   left to right direction

   actor "AGR-007\nagr_admin_acceso" as ADMIN <<AGR_ADMIN>>
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Access" {
     usecase "UC_ACC_02\nRevocar Funciones" as UC02
     usecase "Seleccionar\nUsuario" as SEL
     usecase "Seleccionar\nFunciones" as FUNC
     usecase "Confirmar\nRevocacion" as CONF
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC02
   UC02 --> SEL : <<include>>
   UC02 --> FUNC : <<include>>
   UC02 --> CONF : <<include>>
   UC02 --> AUD : <<include>>
   SYS --> AUD

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
     - El administrador tiene sesion activa con funcion ACC-002
   * - PRE-02
     - El usuario destino existe en el sistema
   * - PRE-03
     - El usuario tiene al menos una funcion asignada

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona un usuario y elige "Revocar Funciones".

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Las funciones seleccionadas se eliminan de user_functions
   * - POST-02
     - Los permisos efectivos del usuario se actualizan inmediatamente
   * - POST-03
     - Se registra FUNCTION_REVOKE en auditoria (CNST-009)

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
     - Accede al modulo de control de acceso
   * - 2
     - Sistema
     - Valida funcion ACC-002 (revoca_funciones)
   * - 3
     - Admin
     - Busca y selecciona usuario destino
   * - 4
     - Sistema
     - Muestra funciones actuales del usuario
   * - 5
     - Admin
     - Selecciona funciones a revocar
   * - 6
     - Admin
     - Presiona "Revocar Funciones"
   * - 7
     - Sistema
     - Muestra dialogo de confirmacion
   * - 8
     - Admin
     - Confirma revocacion
   * - 9
     - Sistema
     - Elimina registros de user_functions
   * - 10
     - Sistema
     - Registra FUNCTION_REVOKE en UserActionLog (CNST-009)
   * - 11
     - Sistema
     - Actualiza vista de permisos del usuario
   * - 12
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_02

   @startuml

   actor "AGR-007\nAdmin" as A
   participant "Frontend\nAccess" as FE <<Frontend>>
   participant "AccessController" as AC <<Backend>>
   participant "AccessService" as AS <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Selecciona usuario
   activate FE

   FE -> AC: GET /api/users/{id}/functions
   AC --> FE: current_functions

   FE --> A: Muestra funciones asignadas

   A -> FE: Selecciona funciones a revocar
   A -> FE: Click "Revocar"

   FE -> FE: Dialogo confirmacion
   A -> FE: Confirma

   FE -> AC: DELETE /api/users/{id}/functions\n{function_ids: [1, 5, 12]}
   activate AC

   == Validar Permisos ==
   AC -> AC: verify_function(ACC-002)

   AC -> AS: revoke_functions(user_id, function_ids, admin)
   activate AS

   == Validar Usuario ==
   AS -> DB: SELECT * FROM users WHERE id = ?
   DB --> AS: user

   alt usuario no existe
     AS --> AC: UserNotFoundError
     AC --> FE: 404 Not Found
   end

   == Verificar Funciones Asignadas ==
   AS -> DB: SELECT function_id FROM user_functions\nWHERE user_id = ? AND function_id IN (...)
   DB --> AS: assigned_functions

   alt alguna funcion no esta asignada
     AS --> AC: FunctionNotAssignedError
     AC --> FE: 400 Bad Request
   end

   == Revocar Funciones ==
   AS -> DB: DELETE FROM user_functions\nWHERE user_id = ? AND function_id IN (...)

   == Registrar Auditoria (CNST-009) ==
   AS -> UAL: record(FUNCTION_REVOKE, admin, user, functions)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Detalla cada funcion revocada
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> AS: logged
   deactivate UAL

   AS --> AC: {revoked: [...], user_id, count}
   deactivate AS

   AC --> FE: 200 OK
   deactivate AC

   FE --> A: Confirmacion: N funciones revocadas
   FE -> FE: Actualiza vista de permisos
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Revocar Todas las Funciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Admin
     - Hace clic en "Revocar Todas"
   * - 6a
     - Sistema
     - Selecciona automaticamente todas las funciones
   * - 7a
     - Sistema
     - Muestra advertencia: "El usuario quedara sin permisos"
   * - 8a
     - Admin
     - Confirma accion

7.2 FA-02: Cancelar Revocacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
     - Permanece en vista de permisos

8. Excepciones
--------------

8.1 EX-01: Sin Permiso ACC-002
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion ACC-002
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "No tiene permisos para revocar funciones"
   * - **Codigo Error**
     - ACC-010

8.2 EX-02: Funcion No Asignada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Alguna funcion seleccionada no esta asignada al usuario
   * - **Accion Sistema**
     - Rechaza operacion parcial
   * - **Mensaje Usuario**
     - "La funcion [nombre] no esta asignada a este usuario"
   * - **Codigo Error**
     - ACC-011

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_02

   @startuml

   start

   :Admin accede a Control de Acceso;

   if (Tiene funcion ACC-002?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Seleccionar usuario;

   :Mostrar funciones asignadas;

   if (Usuario tiene funciones?) then (no)
     :Mostrar "Sin funciones asignadas";
     stop
   else (si)
   endif

   :Admin selecciona funciones a revocar;

   :Mostrar dialogo confirmacion;

   if (Admin confirma?) then (no)
     :Cancelar operacion;
     stop
   else (si)
   endif

   :Eliminar de user_functions;

   :Registrar FUNCTION_REVOKE;
   note right
     CNST-009
     Auditoria inmutable
   end note

   :Actualizar permisos efectivos;

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
   * - BR-ACC-10
     - Efecto Inmediato
     - La revocacion tiene efecto inmediato. El usuario pierde el permiso al instante.
   * - BR-ACC-11
     - Confirmacion Obligatoria
     - Toda revocacion requiere confirmacion explicita del administrador.
   * - BR-ACC-12
     - Sin Funciones Valido
     - Es valido que un usuario quede sin funciones asignadas.
   * - BR-ACC-13
     - Revocacion Atomica
     - La revocacion es atomica: se revocan todas las seleccionadas o ninguna.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-005
     - RBAC Flat
     - La revocacion elimina registros directos de user_functions. No hay efectos en cascada porque no hay jerarquia de roles.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra FUNCTION_REVOKE en UserActionLog con: admin ejecutor, usuario afectado, lista de funciones revocadas.

**Implementacion CNST-009:**

.. code-block:: python

   UserActionLog.record(
       user=admin,
       action='FUNCTION_REVOKE',
       resource=f'User:{target_user.id}',
       result='SUCCESS',
       ip=request.META.get('REMOTE_ADDR'),
       details={
           'target_user': target_user.username,
           'revoked_functions': [f.code for f in revoked],
           'remaining_count': remaining_count
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
   * - FR-ACC-010
     - El sistema debe permitir revocar funciones individuales
     - Registros eliminados de user_functions
   * - FR-ACC-011
     - El sistema debe permitir revocar todas las funciones
     - Opcion "Revocar Todas" funcional
   * - FR-ACC-012
     - El sistema debe requerir confirmacion
     - Dialogo de confirmacion antes de ejecutar
   * - FR-ACC-013
     - El sistema debe registrar revocacion en auditoria
     - Evento FUNCTION_REVOKE con detalle

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-002: Permitir revocacion de funciones
   * - **Reglas de Negocio**
     - BR-ACC-10 a BR-ACC-13
   * - **Restricciones**
     - CNST-005 (RBAC Flat), CNST-009 (Auditoria)
   * - **FR Derivados**
     - FR-ACC-010 a FR-ACC-013
   * - **UC Relacionados**
     - UC_ACC_01 (Asignar), UC_ACC_03 (Consultar)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-002: revoca_funciones

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
     - Version inicial v4.0
