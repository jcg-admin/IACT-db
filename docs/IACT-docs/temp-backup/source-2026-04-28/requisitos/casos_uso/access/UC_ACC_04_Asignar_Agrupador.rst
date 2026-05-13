.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_04
   :normativa: CNST-005, CNST-009

============================
UC_ACC_04: Asignar Agrupador
============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_04
   * - **Nombre**
     - Asignar Agrupador
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Actor Secundario**
     - Sistema (validacion SoD)
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-004: asigna_agrupadores
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-ACC-004

2. Descripcion
--------------

Este caso de uso permite a un administrador de acceso (AGR-007) asignar
un agrupador completo a un usuario. Un agrupador es un mecanismo de
asignacion masiva que contiene un conjunto predefinido de funciones.

**Caracteristicas principales:**

- Asignacion de agrupadores del catalogo (10 disponibles)
- Validacion automatica de SoD considerando todas las funciones del agrupador
- Un usuario puede tener multiples agrupadores
- Las funciones se heredan automaticamente
- Registro detallado en auditoria (CNST-009)

**Concepto de Agrupador (CNST-005):**

.. note::
   Un agrupador NO es un rol. Es un mecanismo de asignacion masiva que
   internamente crea N asignaciones individuales de funciones. Facilita
   la administracion pero no introduce jerarquia.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_04

   @startuml

   left to right direction

   actor "AGR-007\nagr_admin_acceso" as ADMIN <<AGR_ADMIN>>
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Access" {
     usecase "UC_ACC_04\nAsignar Agrupador" as UC04
     usecase "Seleccionar\nUsuario" as SEL
     usecase "Seleccionar\nAgrupador" as AGR
     usecase "Validar\nSoD" as SOD
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC04
   UC04 --> SEL : <<include>>
   UC04 --> AGR : <<include>>
   UC04 --> SOD : <<include>>
   UC04 --> AUD : <<include>>
   SYS --> SOD
   SYS --> AUD

   note right of AGR
     10 agrupadores disponibles
     AGR-001 a AGR-010
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
     - El administrador tiene sesion activa con funcion ACC-004
   * - PRE-02
     - El usuario destino existe y tiene estado ACTIVO
   * - PRE-03
     - El agrupador a asignar existe en el catalogo
   * - PRE-04
     - El usuario no tiene el agrupador ya asignado

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona un usuario y elige "Asignar Agrupador".

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - El agrupador queda asignado al usuario
   * - POST-02
     - Las funciones del agrupador se agregan a los permisos efectivos
   * - POST-03
     - Se registra AGRUPADOR_ASSIGN en auditoria (CNST-009)

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
     - Valida funcion ACC-004 (asigna_agrupadores)
   * - 3
     - Admin
     - Busca y selecciona usuario destino
   * - 4
     - Sistema
     - Muestra agrupadores actuales del usuario
   * - 5
     - Sistema
     - Muestra catalogo de agrupadores disponibles (10)
   * - 6
     - Admin
     - Selecciona agrupador a asignar
   * - 7
     - Sistema
     - Muestra preview de funciones que se asignaran
   * - 8
     - Admin
     - Presiona "Asignar Agrupador"
   * - 9
     - Sistema
     - Valida que usuario tenga estado ACTIVO
   * - 10
     - Sistema
     - Valida restricciones SoD (CNST-005)
   * - 11
     - Sistema
     - Crea registro en user_agrupadores
   * - 12
     - Sistema
     - Registra AGRUPADOR_ASSIGN en UserActionLog (CNST-009)
   * - 13
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_04

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

   FE -> AC: GET /api/users/{id}/agrupadores
   AC --> FE: current_agrupadores

   FE -> AC: GET /api/agrupadores
   AC --> FE: all_agrupadores (10)

   FE --> A: Muestra agrupadores actuales y disponibles

   A -> FE: Selecciona agrupador

   FE -> AC: GET /api/agrupadores/{id}/functions
   AC --> FE: agrupador_functions

   FE --> A: Preview de funciones del agrupador

   A -> FE: Click "Asignar"

   FE -> AC: POST /api/users/{id}/agrupadores\n{agrupador_id: 3}
   activate AC

   == Validar Permisos ==
   AC -> AC: verify_function(ACC-004)

   AC -> AS: assign_agrupador(user_id, agrupador_id, admin)
   activate AS

   == Validar Usuario ==
   AS -> DB: SELECT * FROM users WHERE id = ?
   DB --> AS: user

   alt estado != ACTIVO
     AS --> AC: InvalidUserStateError
     AC --> FE: 400 Bad Request
   end

   == Obtener Funciones del Agrupador ==
   AS -> DB: SELECT function_id FROM agrupador_functions\nWHERE agrupador_id = ?
   DB --> AS: agrupador_functions

   == Validar SoD (CNST-005) ==
   AS -> SOD: validate(user_id, agrupador_functions)
   activate SOD

   SOD -> DB: SELECT function_id FROM user_functions\nWHERE user_id = ?
   DB --> SOD: current_functions

   SOD -> DB: SELECT function_id FROM user_agrupadores ua\nJOIN agrupador_functions af ON ua.agrupador_id = af.agrupador_id\nWHERE ua.user_id = ?
   DB --> SOD: other_agrupador_functions

   SOD -> SOD: check_sod_rules(\ncurrent + other + new)

   alt SoD violation
     note right of SOD
       CNST-005: Separacion
       de Funciones
     end note
     SOD --> AS: SoDViolationError
     AS --> AC: 409 Conflict
     AC --> FE: Error: Agrupador viola SoD
   end

   SOD --> AS: valid
   deactivate SOD

   == Asignar Agrupador ==
   AS -> DB: INSERT INTO user_agrupadores\n(user_id, agrupador_id, assigned_by, assigned_at)

   == Registrar Auditoria (CNST-009) ==
   AS -> UAL: record(AGRUPADOR_ASSIGN, admin, user, agrupador)
   activate UAL
   UAL -> DB: INSERT INTO user_action_log
   UAL --> AS: logged
   deactivate UAL

   AS --> AC: {assigned: agrupador, functions_count: N}
   deactivate AS

   AC --> FE: 200 OK
   deactivate AC

   FE --> A: Confirmacion: Agrupador asignado (N funciones)
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Agrupador Ya Asignado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Sistema
     - Muestra agrupador como ya asignado (deshabilitado)
   * - 5b
     - Admin
     - No puede seleccionar agrupadores ya asignados

7.2 FA-02: Multiples Agrupadores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Admin
     - Selecciona varios agrupadores
   * - 10a
     - Sistema
     - Valida SoD considerando funciones de todos
   * - 11a
     - Sistema
     - Asigna todos o ninguno (atomico)

8. Excepciones
--------------

8.1 EX-01: Violacion SoD por Agrupador
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Funciones del agrupador violan SoD con permisos actuales
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - "El agrupador [nombre] contiene funciones incompatibles con los permisos actuales"
   * - **Codigo Error**
     - ACC-030

8.2 EX-02: Agrupador No Existe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - ID de agrupador no existe
   * - **Accion Sistema**
     - Retorna error 404
   * - **Mensaje Usuario**
     - "Agrupador no encontrado"
   * - **Codigo Error**
     - ACC-031

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_04

   @startuml

   start

   :Admin selecciona usuario;

   if (Tiene ACC-004?) then (no)
     :Error de permisos;
     stop
   else (si)
   endif

   :Mostrar catalogo de agrupadores;

   :Admin selecciona agrupador;

   :Mostrar preview de funciones;

   if (Usuario ACTIVO?) then (no)
     :Error: Usuario no activo;
     stop
   else (si)
   endif

   :Obtener funciones del agrupador;

   :Validar SoD con todas las funciones;
   note right
     CNST-005
     Considerar funciones actuales
     + funciones del agrupador
   end note

   if (Viola SoD?) then (si)
     :Mostrar conflicto;
     stop
   else (no)
   endif

   :Crear registro en user_agrupadores;

   :Registrar AGRUPADOR_ASSIGN;
   note right: CNST-009

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
   * - BR-ACC-30
     - Agrupador No Es Rol
     - Un agrupador es un mecanismo de asignacion masiva, no un rol jerarquico. Internamente expande a funciones individuales.
   * - BR-ACC-31
     - Multiples Agrupadores
     - Un usuario puede tener multiples agrupadores asignados simultaneamente.
   * - BR-ACC-32
     - SoD Agregado
     - La validacion SoD considera TODAS las funciones de TODOS los agrupadores mas las funciones directas.
   * - BR-ACC-33
     - Sin Duplicados
     - Un agrupador solo puede estar asignado una vez por usuario.

**Catalogo de Agrupadores:**

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - ID
     - Nombre
     - Funciones Incluidas
   * - AGR-001
     - agr_operador_basico
     - RPT-001, RPT-002, RPT-003, ALR-001, ALR-006
   * - AGR-002
     - agr_operador_reportes
     - RPT-001 a RPT-003, RPT-007, RPT-008, ALR-001, ALR-002, ALR-006
   * - AGR-003
     - agr_supervisor
     - RPT-001 a RPT-005, RPT-007, RPT-008, ALR-001 a ALR-004, ALR-006
   * - AGR-004
     - agr_exportador
     - RPT-004, RPT-005, RPT-006
   * - AGR-005
     - agr_gestor_alertas
     - ALR-001 a ALR-006
   * - AGR-006
     - agr_admin_usuarios
     - USR-001 a USR-010, ACC-001, ACC-002
   * - AGR-007
     - agr_admin_acceso
     - ACC-001 a ACC-006
   * - AGR-008
     - agr_auditor
     - AUD-001 a AUD-004
   * - AGR-009
     - agr_admin_pipeline
     - PIP-001 a PIP-004
   * - AGR-010
     - agr_admin_logs
     - LOG-001, LOG-002

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
     - Antes de asignar agrupador, se valida SoD considerando todas las funciones que contiene mas las que ya tiene el usuario.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra AGRUPADOR_ASSIGN con: admin, usuario, agrupador asignado y lista de funciones incluidas.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-030
     - El sistema debe mostrar catalogo de 10 agrupadores
     - Lista con nombre, descripcion y funciones
   * - FR-ACC-031
     - El sistema debe mostrar preview de funciones
     - Antes de asignar, ver que funciones incluye
   * - FR-ACC-032
     - El sistema debe validar SoD agregado
     - Considerar todas las fuentes de funciones
   * - FR-ACC-033
     - El sistema debe registrar asignacion en auditoria
     - Evento AGRUPADOR_ASSIGN con detalle

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-004: Permitir asignacion de agrupadores
   * - **Reglas de Negocio**
     - BR-ACC-30 a BR-ACC-33
   * - **Restricciones**
     - CNST-005 (RBAC Flat, SoD), CNST-009 (Auditoria)
   * - **FR Derivados**
     - FR-ACC-030 a FR-ACC-033
   * - **UC Relacionados**
     - UC_ACC_01 (Asignar Funciones), UC_ACC_03 (Consultar)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-004: asigna_agrupadores

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
     - Version inicial v4.0 con catalogo 10 agrupadores