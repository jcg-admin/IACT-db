.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_01
   :normativa: CNST-005, CNST-009

============================
UC_ACC_01: Asignar Funciones
============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_01
   * - **Nombre**
     - Asignar Funciones
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Actor Secundario**
     - Sistema (validacion SoD)
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-001: asigna_funciones
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-ACC-001

2. Descripcion
--------------

Este caso de uso permite a un administrador de acceso (AGR-007) asignar
funciones atomicas del catalogo RBAC a un usuario especifico. El sistema
valida las restricciones de Separacion de Funciones (SoD) antes de
confirmar la asignacion.

**Caracteristicas principales:**

- Asignacion de funciones atomicas individuales (44 disponibles)
- Validacion automatica de restricciones SoD (CNST-005)
- Verificacion de estado del usuario (debe ser ACTIVO)
- Registro detallado en auditoria (CNST-009)
- Las funciones se asignan directamente, sin jerarquia de roles

**Modelo RBAC Flat (CNST-005):**

.. note::
   IACT implementa RBAC Flat: las funciones se asignan directamente a
   usuarios. No existen roles jerarquicos. Los agrupadores son solo
   mecanismos de asignacion masiva, no roles.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_01

   @startuml

   left to right direction

   actor "AGR-007\nagr_admin_acceso" as ADMIN <<AGR_ADMIN>>
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Access" {
     usecase "UC_ACC_01\nAsignar Funciones" as UC01
     usecase "Seleccionar\nUsuario" as SEL
     usecase "Seleccionar\nFunciones" as FUNC
     usecase "Validar\nSoD" as SOD
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC01
   UC01 --> SEL : <<include>>
   UC01 --> FUNC : <<include>>
   UC01 --> SOD : <<include>>
   UC01 --> AUD : <<include>>
   SYS --> SOD
   SYS --> AUD

   note right of SOD
     CNST-005: Validar
     Separacion de Funciones
     antes de asignar
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
     - El administrador tiene sesion activa con funcion ACC-001
   * - PRE-02
     - El usuario destino existe y tiene estado ACTIVO
   * - PRE-03
     - Las funciones a asignar existen en el catalogo
   * - PRE-04
     - El usuario destino no tiene las funciones ya asignadas

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de control de acceso y selecciona
"Asignar Funciones" para un usuario.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Las funciones seleccionadas quedan asignadas al usuario
   * - POST-02
     - Se crean registros en tabla user_functions
   * - POST-03
     - Se registra FUNCTION_ASSIGN en auditoria (CNST-009)
   * - POST-04
     - Los permisos efectivos del usuario se actualizan

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
     - Valida funcion ACC-001 (asigna_funciones)
   * - 3
     - Admin
     - Busca y selecciona usuario destino
   * - 4
     - Sistema
     - Muestra funciones actuales del usuario
   * - 5
     - Sistema
     - Muestra catalogo de funciones disponibles (44)
   * - 6
     - Admin
     - Selecciona funciones a asignar
   * - 7
     - Admin
     - Presiona "Asignar Funciones"
   * - 8
     - Sistema
     - Valida que usuario tenga estado ACTIVO
   * - 9
     - Sistema
     - Valida restricciones SoD (CNST-005)
   * - 10
     - Sistema
     - Crea registros en user_functions
   * - 11
     - Sistema
     - Registra FUNCTION_ASSIGN en UserActionLog (CNST-009)
   * - 12
     - Sistema
     - Muestra confirmacion con funciones asignadas
   * - 13
     - Sistema
     - Actualiza vista de permisos del usuario

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_01

   @startuml

   actor "AGR-007\nAdmin" as A
   participant "Frontend\nAccess" as FE <<Frontend>>
   participant "AccessController" as AC <<Backend>>
   participant "AccessService" as AS <<Service>>
   participant "SoDValidator" as SOD <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Selecciona usuario
   activate FE

   FE -> AC: GET /api/users/{id}/functions
   AC --> FE: current_functions

   FE -> AC: GET /api/functions
   AC --> FE: all_functions (44)

   FE --> A: Muestra funciones actuales y disponibles

   A -> FE: Selecciona funciones a asignar
   A -> FE: Click "Asignar"

   FE -> AC: POST /api/users/{id}/functions\n{function_ids: [1, 5, 12]}
   activate AC

   == Validar Permisos ==
   AC -> AC: verify_function(ACC-001)

   AC -> AS: assign_functions(user_id, function_ids, admin)
   activate AS

   == Validar Usuario ==
   AS -> DB: SELECT * FROM users WHERE id = ?
   DB --> AS: user

   alt usuario no existe
     AS --> AC: UserNotFoundError
     AC --> FE: 404 Not Found
   end

   alt estado != ACTIVO
     AS --> AC: InvalidUserStateError
     AC --> FE: 400 Bad Request
   end

   == Validar SoD (CNST-005) ==
   AS -> SOD: validate(user_id, new_function_ids)
   activate SOD

   SOD -> DB: SELECT function_id FROM user_functions\nWHERE user_id = ?
   DB --> SOD: current_functions

   SOD -> DB: SELECT * FROM sod_rules
   DB --> SOD: sod_rules

   SOD -> SOD: check_conflicts(\ncurrent + new, sod_rules)

   alt SoD violation
     note right of SOD
       CNST-005: Separacion
       de Funciones
     end note
     SOD --> AS: SoDViolationError\n{conflicting_functions, rule}
     AS --> AC: 409 Conflict
     AC --> FE: Error: Viola SoD
     FE --> A: "Conflicto: [funcion1] incompatible con [funcion2]"
   end

   SOD --> AS: valid
   deactivate SOD

   == Asignar Funciones ==
   loop for each function_id
     AS -> DB: INSERT INTO user_functions\n(user_id, function_id, assigned_by, assigned_at)
   end

   == Registrar Auditoria (CNST-009) ==
   AS -> UAL: record(FUNCTION_ASSIGN, admin, user, functions)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Detalla cada funcion asignada
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> AS: logged
   deactivate UAL

   AS --> AC: {assigned: [...], user_id, count}
   deactivate AS

   AC --> FE: 200 OK + assigned_functions
   deactivate AC

   FE --> A: Confirmacion: N funciones asignadas
   FE -> FE: Actualiza vista de permisos
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Funcion Ya Asignada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Sistema
     - Detecta que algunas funciones ya estan asignadas
   * - 6b
     - Sistema
     - Las muestra deshabilitadas o marcadas
   * - 6c
     - Admin
     - Solo puede seleccionar funciones no asignadas

7.2 FA-02: Asignacion Masiva via Agrupador
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Admin
     - En lugar de funciones individuales, selecciona un agrupador
   * - 6b
     - Sistema
     - Obtiene funciones del agrupador
   * - 6c
     - Sistema
     - Redirige a UC_ACC_04 (Asignar Agrupador)

8. Excepciones
--------------

8.1 EX-01: Violacion de SoD
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Funciones seleccionadas violan restriccion SoD
   * - **Accion Sistema**
     - Rechaza asignacion, muestra conflicto
   * - **Mensaje Usuario**
     - "Conflicto SoD: [funcion1] es incompatible con [funcion2] (Regla: SOD-00X)"
   * - **Codigo Error**
     - ACC-001

8.2 EX-02: Usuario Inactivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - Usuario destino no tiene estado ACTIVO
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - "Solo se pueden asignar funciones a usuarios activos"
   * - **Codigo Error**
     - ACC-002

8.3 EX-03: Funcion No Existe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - ID de funcion no existe en catalogo
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - "Funcion no encontrada: [id]"
   * - **Codigo Error**
     - ACC-003

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_01

   @startuml

   start

   :Admin accede a Control de Acceso;

   if (Tiene funcion ACC-001?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Buscar y seleccionar usuario;

   :Mostrar funciones actuales;

   :Mostrar catalogo de funciones (44);

   :Admin selecciona funciones;

   if (Usuario estado ACTIVO?) then (no)
     :Error: Usuario no activo;
     stop
   else (si)
   endif

   :Validar restricciones SoD;
   note right
     CNST-005
     Separacion de Funciones
   end note

   if (Viola SoD?) then (si)
     :Mostrar conflicto SoD;
     :Indicar funciones incompatibles;
     stop
   else (no)
   endif

   :Crear registros en user_functions;

   :Registrar FUNCTION_ASSIGN;
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
   * - BR-ACC-01
     - RBAC Flat
     - Las funciones se asignan directamente a usuarios, sin roles intermedios ni jerarquia.
   * - BR-ACC-02
     - SoD Obligatorio
     - Toda asignacion debe validar las 3 restricciones SoD definidas antes de confirmar.
   * - BR-ACC-03
     - Usuario Activo
     - Solo se pueden asignar funciones a usuarios con estado ACTIVO.
   * - BR-ACC-04
     - Sin Duplicados
     - Una funcion solo puede estar asignada una vez por usuario.
   * - BR-ACC-05
     - Efecto Inmediato
     - La asignacion tiene efecto inmediato en los permisos del usuario.

**Restricciones SoD Definidas:**

.. list-table::
   :widths: 15 30 30 25
   :header-rows: 1

   * - ID
     - Grupo A
     - Grupo B
     - Descripcion
   * - SOD-001
     - PIP-* (Pipeline)
     - AUD-* (Auditoria)
     - Quien opera no audita
   * - SOD-002
     - USR-* (Usuarios)
     - AUD-* (Auditoria)
     - Quien gestiona no audita
   * - SOD-003
     - ACC-* (Acceso)
     - AUD-* (Auditoria)
     - Quien asigna no audita

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-005
     - RBAC Flat / SoD
     - Antes de asignar, se validan las 3 restricciones SoD. Si la combinacion de funciones actuales + nuevas viola alguna regla, se rechaza la operacion.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra FUNCTION_ASSIGN en UserActionLog con: admin ejecutor, usuario destino, lista de funciones asignadas, timestamp.

**Implementacion CNST-005 (Validacion SoD):**

.. code-block:: python

   # services/sod_validator.py
   class SoDValidator:
       SOD_RULES = [
           {'id': 'SOD-001', 'group_a': 'PIP-', 'group_b': 'AUD-'},
           {'id': 'SOD-002', 'group_a': 'USR-', 'group_b': 'AUD-'},
           {'id': 'SOD-003', 'group_a': 'ACC-', 'group_b': 'AUD-'},
       ]

       def validate(self, user_id: int, new_functions: list) -> bool:
           current = self.get_current_functions(user_id)
           all_functions = current + new_functions

           for rule in self.SOD_RULES:
               has_a = any(f.startswith(rule['group_a']) for f in all_functions)
               has_b = any(f.startswith(rule['group_b']) for f in all_functions)

               if has_a and has_b:
                   raise SoDViolationError(
                       rule=rule['id'],
                       message=f"Conflicto: {rule['group_a']}* incompatible con {rule['group_b']}*"
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
   * - FR-ACC-001
     - El sistema debe permitir asignar funciones individuales
     - Funciones aparecen en user_functions
   * - FR-ACC-002
     - El sistema debe validar SoD antes de asignar
     - Rechazo con mensaje si viola SoD
   * - FR-ACC-003
     - El sistema debe mostrar catalogo de 44 funciones
     - Lista completa con descripcion y modulo
   * - FR-ACC-004
     - El sistema debe mostrar funciones actuales del usuario
     - Vista clara de permisos existentes
   * - FR-ACC-005
     - El sistema debe registrar asignacion en auditoria
     - Evento FUNCTION_ASSIGN con detalle

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-001: Permitir asignacion de funciones a usuarios
   * - **Reglas de Negocio**
     - BR-ACC-01 a BR-ACC-05
   * - **Restricciones**
     - CNST-005 (RBAC Flat, SoD), CNST-009 (Auditoria)
   * - **FR Derivados**
     - FR-ACC-001 a FR-ACC-005
   * - **UC Relacionados**
     - UC_ACC_02 (Revocar), UC_ACC_03 (Consultar), UC_ACC_04 (Agrupador)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-001: asigna_funciones

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
     - Version inicial v4.0 con validacion SoD