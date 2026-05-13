.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_09
   :normativa: CNST-009

=================================
UC_ACC_09: Auditar Cambios Acceso
=================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_09
   * - **Nombre**
     - Auditar Cambios Acceso
   * - **Actor Principal**
     - AGR-008: agr_auditor
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - AUD-001: ve_auditoria, AUD-002: busca_auditoria
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-ACC-009

2. Descripcion
--------------

Este caso de uso permite a un auditor (AGR-008) consultar el historial
de cambios en el modelo de acceso: asignaciones, revocaciones, cambios
de segmento y permisos temporales.

**Caracteristicas principales:**

- Consultar historial de cambios de permisos
- Filtrar por usuario, fecha, tipo de accion
- Ver detalle de cada cambio (quien, cuando, que)
- Exportar historial para compliance
- Solo lectura (CNST-009)

**Restriccion SoD:**

.. warning::
   AGR-008 (auditor) es INCOMPATIBLE con AGR-006, AGR-007, AGR-009.
   Quien audita NO puede operar ni gestionar permisos.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_09

   @startuml
   left to right direction
   actor "AGR-008\nagr_auditor" as AUDITOR

   rectangle "MOD_Access" {
     usecase "UC_ACC_09\nAuditar Cambios" as UC09
     usecase "Consultar Historial" as HIST
     usecase "Filtrar Registros" as FILT
     usecase "Exportar Auditoria" as EXP
   }

   AUDITOR --> UC09
   UC09 --> HIST : include
   UC09 --> FILT : extend
   UC09 --> EXP : extend
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
     - El auditor tiene sesion activa con funcion AUD-001 o AUD-002
   * - PRE-02
     - Existen registros de auditoria de acceso

4.2 Trigger
^^^^^^^^^^^

El auditor accede al modulo de auditoria de acceso.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra historial de cambios de acceso
   * - POST-02
     - La consulta no modifica ningun dato (solo lectura)

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
     - Accede a auditoria de acceso
   * - 2
     - Sistema
     - Valida funcion AUD-001
   * - 3
     - Sistema
     - Consulta registros de auditoria de acceso
   * - 4
     - Sistema
     - Muestra lista con filtros por defecto (ultimos 30 dias)
   * - 5
     - Auditor
     - Aplica filtros opcionales
   * - 6
     - Sistema
     - Actualiza lista segun filtros
   * - 7
     - Auditor
     - Selecciona un registro para ver detalle
   * - 8
     - Sistema
     - Muestra detalle completo del cambio

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_09

   @startuml
   actor "AGR-008 Auditor" as A
   participant "Frontend" as FE
   participant "AuditController" as AC
   participant "AuditService" as AS
   database "Analytics" as DB

   A -> FE: Accede a Auditoria Acceso
   FE -> AC: GET /api/audit/access?days=30
   AC -> AC: verify_function(AUD-001)
   AC -> AS: get_access_audit(filters)
   AS -> DB: SELECT * FROM user_action_log\nWHERE action IN (\n  'FUNCTION_ASSIGN',\n  'FUNCTION_REVOKE',\n  'AGRUPADOR_ASSIGN',\n  'SEGMENT_ASSIGN',\n  'TEMP_PERMISSION_GRANT'\n)\nORDER BY created_at DESC
   DB --> AS: audit_records
   AS --> AC: records
   AC --> FE: 200 OK + records
   FE --> A: Tabla de auditoria

   A -> FE: Aplica filtros
   FE -> AC: GET /api/audit/access?user=X&action=Y
   AC -> AS: get_access_audit(filters)
   AS -> DB: SELECT con filtros
   DB --> AS: filtered_records
   AS --> AC: records
   AC --> FE: 200 OK
   FE --> A: Lista filtrada

   A -> FE: Click en registro
   FE -> AC: GET /api/audit/access/{id}
   AC --> FE: record_detail
   FE --> A: Detalle completo
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Exportar Historial
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Hace clic en Exportar
   * - 6a
     - Sistema
     - Valida funcion AUD-003
   * - 7a
     - Sistema
     - Genera archivo CSV con registros filtrados
   * - 8a
     - Sistema
     - Descarga archivo

7.2 FA-02: Busqueda Avanzada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Accede a busqueda avanzada
   * - 5b
     - Sistema
     - Valida funcion AUD-002
   * - 5c
     - Auditor
     - Define criterios complejos
   * - 6a
     - Sistema
     - Ejecuta busqueda

8. Excepciones
--------------

8.1 EX-01: Sin Permiso Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion AUD-001 ni AUD-002
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para ver auditoria
   * - **Codigo Error**
     - ACC-080

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_09

   @startuml
   start
   :Auditor accede a Auditoria Acceso;
   if (Tiene AUD-001?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Consultar registros ultimos 30 dias;
   :Mostrar tabla de auditoria;
   if (Aplicar filtros?) then (si)
     :Auditor define filtros;
     :Actualizar consulta;
   endif
   if (Ver detalle?) then (si)
     :Mostrar detalle de registro;
   endif
   if (Exportar?) then (si)
     if (Tiene AUD-003?) then (si)
       :Generar CSV;
       :Descargar archivo;
     else (no)
       :Sin permiso exportar;
     endif
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
   * - BR-ACC-80
     - Solo Lectura
     - El auditor solo puede consultar, nunca modificar registros
   * - BR-ACC-81
     - SoD Auditor
     - El auditor no puede tener funciones de gestion de permisos
   * - BR-ACC-82
     - Registros Inmutables
     - Los registros de auditoria no pueden modificarse ni eliminarse

**Tipos de Acciones Auditadas:**

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Accion
     - Descripcion
   * - FUNCTION_ASSIGN
     - Asignacion de funcion a usuario
   * - FUNCTION_REVOKE
     - Revocacion de funcion
   * - AGRUPADOR_ASSIGN
     - Asignacion de agrupador
   * - AGRUPADOR_REVOKE
     - Revocacion de agrupador
   * - SEGMENT_ASSIGN
     - Cambio de segmento
   * - TEMP_PERMISSION_GRANT
     - Otorgar permiso temporal
   * - TEMP_PERMISSION_REVOKE
     - Revocar permiso temporal

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
     - Los registros son solo lectura. No existen operaciones de UPDATE ni DELETE sobre user_action_log.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-080
     - El sistema debe mostrar historial de cambios de acceso
     - Lista paginada con filtros
   * - FR-ACC-081
     - El sistema debe permitir filtrar por tipo de accion
     - Filtro funcional por FUNCTION_ASSIGN, etc
   * - FR-ACC-082
     - El sistema debe mostrar detalle completo
     - Quien, cuando, que, valores anteriores y nuevos

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-009: Permitir auditoria de cambios de acceso
   * - **Reglas de Negocio**
     - BR-ACC-80 a BR-ACC-82
   * - **Restricciones**
     - CNST-009 (Auditoria Inmutable)
   * - **UC Relacionados**
     - UC_AUD_01, UC_AUD_02, UC_AUD_03
   * - **Actor Principal**
     - AGR-008: agr_auditor
   * - **Funcion RBAC**
     - AUD-001, AUD-002

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