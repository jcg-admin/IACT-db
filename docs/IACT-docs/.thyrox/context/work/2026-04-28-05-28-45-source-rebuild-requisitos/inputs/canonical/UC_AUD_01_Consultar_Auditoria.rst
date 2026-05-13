.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Audit
   :uc_id: UC_AUD_01
   :normativa: CNST-009, CNST-010

==============================
UC_AUD_01: Consultar Auditoria
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUD_01
   * - **Nombre**
     - Consultar Auditoria
   * - **Actor Principal**
     - AGR-006: agr_auditor
   * - **Modulo**
     - MOD_Audit
   * - **Funcion RBAC**
     - AUD-001: consulta_auditoria
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUD-001

2. Descripcion
--------------

Este caso de uso permite consultar el log de auditoria del sistema
(user_action_log). Los registros de auditoria son INMUTABLES (CNST-009)
y el acceso esta restringido por Segregacion de Funciones (CNST-010).

**Caracteristicas principales:**

- Consultar acciones de usuarios en el sistema
- Filtrar por usuario, accion, fecha, recurso
- Registros inmutables (solo lectura)
- Acceso restringido a rol auditor (SoD)
- Visualizacion de detalles completos

**Restriccion Critica CNST-009:**

.. warning::
   Los registros de auditoria son INMUTABLES. No existe operacion
   de UPDATE o DELETE sobre user_action_log. Solo INSERT permitido.

**Segregacion de Funciones CNST-010:**

.. warning::
   El rol auditor NO puede tener funciones administrativas.
   SoD-003: auditor vs administrador_usuarios.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUD_01

   @startuml
   left to right direction
   actor "AGR-006\nagr_auditor" as USER

   rectangle "MOD_Audit" {
     usecase "UC_AUD_01\nConsultar Auditoria" as UC01
     usecase "Filtrar\nRegistros" as FILT
     usecase "Ver Detalle\nAccion" as DET
     usecase "Validar SoD\nAuditor" as SOD
   }

   USER --> UC01
   UC01 --> FILT : include
   UC01 --> DET : extend
   UC01 --> SOD : include
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
     - El usuario tiene sesion activa con funcion AUD-001
   * - PRE-02
     - El usuario cumple con SoD-003 (no es administrador)
   * - PRE-03
     - Existen registros de auditoria en el sistema

4.2 Trigger
^^^^^^^^^^^

El auditor accede al modulo de auditoria.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran registros de auditoria (solo lectura)
   * - POST-02
     - No se modifica ningun registro (CNST-009)

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Auditor
     - Accede al modulo de auditoria
   * - 2
     - Sistema
     - Valida funcion AUD-001
   * - 3
     - Sistema
     - Valida cumplimiento SoD-003
   * - 4
     - Sistema
     - Muestra registros de ultimas 24 horas por defecto
   * - 5
     - Auditor
     - Opcionalmente aplica filtros
   * - 6
     - Sistema
     - Ejecuta consulta con filtros aplicados
   * - 7
     - Sistema
     - Presenta lista paginada de registros
   * - 8
     - Auditor
     - Selecciona registro para ver detalle
   * - 9
     - Sistema
     - Muestra detalle completo del registro

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUD_01

   @startuml
   actor "AGR-006 Auditor" as A
   participant "Frontend" as FE
   participant "AuditController" as AC
   participant "SoDValidator" as SOD
   participant "AuditService" as AS
   database "Analytics" as DB

   A -> FE: Accede a Auditoria
   FE -> AC: GET /api/audit/logs
   AC -> AC: verify_function(AUD-001)

   AC -> SOD: validate_sod(user, 'SoD-003')
   SOD -> DB: SELECT roles FROM user_roles\nWHERE user_id = ?
   DB --> SOD: roles
   SOD -> SOD: check_no_admin_roles()

   alt usuario tiene rol admin
     SOD --> AC: SoDViolationError
     AC --> FE: 403 Forbidden
     FE --> A: Error: Conflicto SoD
   end

   SOD --> AC: sod_valid

   AC -> AS: get_audit_logs(filters)
   AS -> DB: SELECT * FROM user_action_log\nWHERE created_at >= NOW() - INTERVAL '24h'\nORDER BY created_at DESC\nLIMIT 100
   note right of DB
     CNST-009: Solo SELECT
     No UPDATE, No DELETE
   end note
   DB --> AS: logs
   AS --> AC: paginated_logs
   AC --> FE: 200 OK
   FE --> A: Lista de registros

   A -> FE: Click en registro
   FE -> AC: GET /api/audit/logs/{id}
   AC -> AS: get_log_detail(id)
   AS -> DB: SELECT * FROM user_action_log WHERE id = ?
   DB --> AS: log_detail
   AS --> AC: detail
   AC --> FE: 200 OK
   FE --> A: Detalle completo
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Filtrar por Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Ingresa username o user_id en filtro
   * - 6a
     - Sistema
     - Filtra registros por usuario especificado

7.2 FA-02: Filtrar por Accion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Selecciona tipo de accion (LOGIN, CREATE, UPDATE, etc.)
   * - 6a
     - Sistema
     - Filtra registros por accion especificada

7.3 FA-03: Filtrar por Rango de Fechas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Selecciona fecha inicio y fecha fin
   * - 6a
     - Sistema
     - Valida rango no exceda 2 anios (CNST-006)
   * - 6b
     - Sistema
     - Filtra registros en el rango especificado

8. Excepciones
--------------

8.1 EX-01: Violacion SoD-003
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Usuario tiene rol auditor y rol administrativo simultaneamente
   * - **Accion Sistema**
     - Rechaza acceso al modulo de auditoria
   * - **Mensaje Usuario**
     - Conflicto de segregacion de funciones. Rol auditor incompatible con roles administrativos.
   * - **Codigo Error**
     - AUD-001

8.2 EX-02: Sin Permiso AUD-001
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion AUD-001 asignada
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para consultar auditoria
   * - **Codigo Error**
     - AUD-002

8.3 EX-03: Rango Excede 2 Anios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6a
   * - **Condicion**
     - Rango de fechas mayor a 730 dias
   * - **Accion Sistema**
     - Rechaza consulta
   * - **Mensaje Usuario**
     - Rango maximo de consulta es 2 anios
   * - **Codigo Error**
     - AUD-003

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUD_01

   @startuml
   start
   :Auditor accede a Modulo de Auditoria;

   if (Tiene funcion AUD-001?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   if (Cumple SoD-003?) then (no)
     :Mostrar error conflicto SoD;
     note right: CNST-010
     stop
   else (si)
   endif

   :Mostrar registros ultimas 24h;

   if (Aplica filtros?) then (si)
     :Validar filtros;
     if (Rango > 2 anios?) then (si)
       :Error rango excedido;
       stop
     else (no)
     endif
   endif

   :Ejecutar consulta SELECT;
   note right: CNST-009 Solo lectura

   :Mostrar lista paginada;

   if (Ver detalle?) then (si)
     :Mostrar registro completo;
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
   * - BR-AUD-01
     - Inmutabilidad
     - Los registros de auditoria NO pueden modificarse ni eliminarse (CNST-009)
   * - BR-AUD-02
     - SoD Auditor
     - El auditor no puede tener roles administrativos (CNST-010)
   * - BR-AUD-03
     - Solo Lectura
     - La consulta de auditoria es exclusivamente de lectura
   * - BR-AUD-04
     - Retencion
     - Datos disponibles por 2 anios (CNST-006)

**Estructura de Registro de Auditoria:**

.. list-table::
   :widths: 20 20 60
   :header-rows: 1

   * - Campo
     - Tipo
     - Descripcion
   * - id
     - UUID
     - Identificador unico del registro
   * - user_id
     - UUID
     - Usuario que realizo la accion
   * - action
     - VARCHAR
     - Tipo de accion (LOGIN, CREATE, UPDATE, DELETE, etc.)
   * - resource
     - VARCHAR
     - Recurso afectado
   * - result
     - VARCHAR
     - SUCCESS o FAILURE
   * - ip_address
     - VARCHAR
     - IP desde donde se realizo
   * - details
     - JSONB
     - Detalles adicionales de la accion
   * - created_at
     - TIMESTAMP
     - Fecha y hora de la accion

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
     - Solo operaciones SELECT permitidas. PROHIBIDO UPDATE y DELETE sobre user_action_log.
   * - CNST-010
     - Segregacion de Funciones
     - SoD-003: El rol auditor no puede coexistir con roles administrativos en el mismo usuario.

**Implementacion CNST-009:**

.. code-block:: sql

   -- Trigger para prevenir UPDATE/DELETE
   CREATE OR REPLACE FUNCTION prevent_audit_modification()
   RETURNS TRIGGER AS $$
   BEGIN
     RAISE EXCEPTION 'CNST-009: Registros de auditoria son inmutables';
   END;
   $$ LANGUAGE plpgsql;

   CREATE TRIGGER audit_immutable
   BEFORE UPDATE OR DELETE ON user_action_log
   FOR EACH ROW EXECUTE FUNCTION prevent_audit_modification();

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUD-001
     - El sistema debe permitir consultar auditoria
     - Lista paginada de registros visible
   * - FR-AUD-002
     - El sistema debe validar SoD
     - Rechazo si auditor tiene roles admin
   * - FR-AUD-003
     - El sistema debe ser solo lectura
     - No existe opcion de modificar/eliminar
   * - FR-AUD-004
     - El sistema debe permitir filtros
     - Filtros por usuario, accion, fecha funcionales

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUD-001: Consultar registros de auditoria
   * - **Reglas de Negocio**
     - BR-AUD-01 a BR-AUD-04
   * - **Restricciones**
     - CNST-009 (Inmutable), CNST-010 (SoD)
   * - **UC Relacionados**
     - UC_AUD_02 (Buscar), UC_AUD_03 (Exportar)
   * - **Actor Principal**
     - AGR-006: agr_auditor
   * - **Funcion RBAC**
     - AUD-001: consulta_auditoria

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
     - Version inicial v4.0 con CNST-009 y CNST-010