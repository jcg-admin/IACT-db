.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Audit
   :uc_id: UC_AUD_02
   :normativa: CNST-009, CNST-010

===========================
UC_AUD_02: Buscar Auditoria
===========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUD_02
   * - **Nombre**
     - Buscar Auditoria
   * - **Actor Principal**
     - AGR-006: agr_auditor
   * - **Modulo**
     - MOD_Audit
   * - **Funcion RBAC**
     - AUD-002: busca_auditoria
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUD-002

2. Descripcion
--------------

Este caso de uso permite realizar busquedas avanzadas en el log de
auditoria con criterios multiples y operadores logicos. Complementa
UC_AUD_01 con capacidades de busqueda mas sofisticadas.

**Caracteristicas principales:**

- Busqueda por texto libre en detalles
- Busqueda con operadores AND/OR
- Busqueda por patron (regex) en campos especificos
- Maximo 10,000 resultados por busqueda
- Solo lectura (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUD_02

   @startuml
   left to right direction
   actor "AGR-006\nagr_auditor" as USER

   rectangle "MOD_Audit" {
     usecase "UC_AUD_02\nBuscar Auditoria" as UC02
     usecase "Busqueda\nTexto Libre" as TXT
     usecase "Busqueda\nAvanzada" as ADV
     usecase "Validar\nSoD" as SOD
   }

   USER --> UC02
   UC02 --> TXT : extend
   UC02 --> ADV : extend
   UC02 --> SOD : include
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
     - El usuario tiene sesion activa con funcion AUD-002
   * - PRE-02
     - El usuario cumple con SoD-003 (no es administrador)

4.2 Trigger
^^^^^^^^^^^

El auditor accede a la busqueda avanzada de auditoria.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran resultados de busqueda (max 10,000)
   * - POST-02
     - No se modifica ningun registro

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
     - Accede a busqueda avanzada de auditoria
   * - 2
     - Sistema
     - Valida funcion AUD-002
   * - 3
     - Sistema
     - Valida cumplimiento SoD-003
   * - 4
     - Sistema
     - Muestra formulario de busqueda avanzada
   * - 5
     - Auditor
     - Ingresa criterios de busqueda
   * - 6
     - Auditor
     - Ejecuta busqueda
   * - 7
     - Sistema
     - Valida criterios y construye query
   * - 8
     - Sistema
     - Ejecuta busqueda con limite 10,000
   * - 9
     - Sistema
     - Presenta resultados paginados
   * - 10
     - Auditor
     - Navega por resultados

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUD_02

   @startuml
   actor "AGR-006 Auditor" as A
   participant "Frontend" as FE
   participant "AuditController" as AC
   participant "SoDValidator" as SOD
   participant "SearchService" as SS
   database "Analytics" as DB

   A -> FE: Accede a Busqueda Avanzada
   FE -> AC: GET /api/audit/search/form
   AC -> AC: verify_function(AUD-002)
   AC -> SOD: validate_sod(user, 'SoD-003')
   SOD --> AC: sod_valid
   AC --> FE: search_form_config
   FE --> A: Formulario de busqueda

   A -> FE: Ingresa criterios
   A -> FE: texto, usuario, accion, fecha_inicio, fecha_fin
   FE -> AC: POST /api/audit/search

   AC -> SS: search_audit(criteria)
   SS -> SS: build_query(criteria)
   SS -> SS: validate_criteria()

   SS -> DB: SELECT * FROM user_action_log\nWHERE (criterios)\nORDER BY created_at DESC\nLIMIT 10000
   note right of DB
     CNST-009: Solo SELECT
     Max 10,000 resultados
   end note
   DB --> SS: results

   SS --> AC: search_results
   AC --> FE: 200 OK
   FE --> A: Resultados paginados
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Busqueda por Texto Libre
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Ingresa texto libre en campo de busqueda
   * - 7a
     - Sistema
     - Busca en campos: action, resource, details

7.2 FA-02: Busqueda con Operadores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Construye query con AND/OR
   * - 7a
     - Sistema
     - Parsea y construye query compuesto

7.3 FA-03: Busqueda por Patron Regex
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Ingresa patron regex (ej: ^LOGIN.*)
   * - 7a
     - Sistema
     - Ejecuta busqueda con SIMILAR TO o regex

8. Excepciones
--------------

8.1 EX-01: Limite de Resultados Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - Busqueda retornaria mas de 10,000 registros
   * - **Accion Sistema**
     - Retorna primeros 10,000 con advertencia
   * - **Mensaje Usuario**
     - Resultados limitados a 10,000. Refine su busqueda.
   * - **Codigo Error**
     - AUD-010

8.2 EX-02: Regex Invalido
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Patron regex mal formado
   * - **Accion Sistema**
     - Rechaza busqueda
   * - **Mensaje Usuario**
     - Patron de busqueda invalido
   * - **Codigo Error**
     - AUD-011

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUD_02

   @startuml
   start
   :Auditor accede a Busqueda Avanzada;

   if (Tiene AUD-002?) then (no)
     stop
   else (si)
   endif

   if (Cumple SoD-003?) then (no)
     :Error conflicto SoD;
     stop
   else (si)
   endif

   :Mostrar formulario;
   :Ingresar criterios;

   if (Criterios validos?) then (no)
     :Error validacion;
     stop
   else (si)
   endif

   :Construir query;
   :Ejecutar busqueda (max 10k);

   if (Resultados > 10,000?) then (si)
     :Advertencia limite;
   endif

   :Mostrar resultados;

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
   * - BR-AUD-10
     - Limite Resultados
     - Maximo 10,000 resultados por busqueda
   * - BR-AUD-11
     - Solo Lectura
     - Busqueda no modifica datos (CNST-009)
   * - BR-AUD-12
     - SoD
     - Solo auditores pueden buscar (CNST-010)

**Operadores de Busqueda:**

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - Operador
     - Ejemplo
   * - AND
     - action:LOGIN AND result:FAILURE
   * - OR
     - user:admin OR user:root
   * - NOT
     - NOT action:SELECT
   * - LIKE
     - resource LIKE 'user%'

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-009
     - Inmutable
     - Solo SELECT permitido
   * - CNST-010
     - SoD
     - Validar SoD-003 antes de busqueda

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUD-010
     - Busqueda avanzada
     - Operadores AND/OR/NOT funcionales
   * - FR-AUD-011
     - Limite 10k
     - No mas de 10,000 resultados
   * - FR-AUD-012
     - Busqueda regex
     - Patrones regex funcionales

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUD-002
   * - **Restricciones**
     - CNST-009, CNST-010
   * - **UC Relacionados**
     - UC_AUD_01, UC_AUD_03
   * - **Funcion RBAC**
     - AUD-002: busca_auditoria

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Version inicial v4.0