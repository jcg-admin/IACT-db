.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Logs
   :uc_id: UC_LOG_03
   :normativa: CNST-008

======================
UC_LOG_03: Buscar Logs
======================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_LOG_03
   * - **Nombre**
     - Buscar Logs
   * - **Actor Principal**
     - AGR-007: agr_operador_logs
   * - **Modulo**
     - MOD_Logs
   * - **Funcion RBAC**
     - LOG-003: busca_logs
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-LOG-003

2. Descripcion
--------------

Este caso de uso permite realizar busquedas avanzadas en los logs
del sistema utilizando texto libre o expresiones regulares.
Los logs estan en formato JSON (CNST-008).

**Caracteristicas principales:**

- Busqueda por texto libre en mensaje y contexto
- Busqueda por expresion regular (regex)
- Busqueda por correlation_id para trazar flujos
- Combinacion de filtros multiples
- Resultados ordenados por relevancia o fecha

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_LOG_03

   @startuml
   left to right direction
   actor "AGR-007\nagr_operador_logs" as USER

   rectangle "MOD_Logs" {
     usecase "UC_LOG_03\nBuscar Logs" as UC03
     usecase "Busqueda\nTexto" as TXT
     usecase "Busqueda\nRegex" as REG
     usecase "Trazar por\nCorrelation ID" as COR
   }

   USER --> UC03
   UC03 --> TXT : extend
   UC03 --> REG : extend
   UC03 --> COR : extend
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
     - El usuario tiene sesion activa con funcion LOG-003
   * - PRE-02
     - Existen logs en el sistema

4.2 Trigger
^^^^^^^^^^^

El operador accede a la busqueda de logs.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran resultados de busqueda
   * - POST-02
     - La consulta es de solo lectura

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Operador
     - Accede a busqueda de logs
   * - 2
     - Sistema
     - Valida funcion LOG-003
   * - 3
     - Sistema
     - Muestra formulario de busqueda
   * - 4
     - Operador
     - Ingresa terminos de busqueda
   * - 5
     - Operador
     - Opcionalmente configura filtros adicionales
   * - 6
     - Operador
     - Ejecuta busqueda
   * - 7
     - Sistema
     - Procesa busqueda en logs JSON
   * - 8
     - Sistema
     - Presenta resultados paginados
   * - 9
     - Operador
     - Navega por resultados

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_LOG_03

   @startuml
   actor "AGR-007 Operador" as O
   participant "Frontend" as FE
   participant "LogController" as LC
   participant "SearchService" as SS
   database "LogStore" as DB

   O -> FE: Accede a Busqueda
   FE -> LC: GET /api/logs/search/form
   LC -> LC: verify_function(LOG-003)
   LC --> FE: search_options
   FE --> O: Formulario de busqueda

   O -> FE: query, filtros
   FE -> LC: POST /api/logs/search
   LC -> SS: search_logs(query, filters)

   alt busqueda texto
     SS -> DB: SELECT * FROM logs\nWHERE message ILIKE '%query%'\nOR context::text ILIKE '%query%'
   else busqueda regex
     SS -> DB: SELECT * FROM logs\nWHERE message ~ 'regex_pattern'
   else busqueda correlation_id
     SS -> DB: SELECT * FROM logs\nWHERE correlation_id = ?\nORDER BY timestamp
   end

   DB --> SS: results
   SS --> LC: paginated_results
   LC --> FE: 200 OK
   FE --> O: Resultados con resaltado

   note right of FE
     CNST-008: Busqueda en
     estructura JSON:
     - message
     - context.*
     - correlation_id
   end note
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
   * - 4a
     - Operador
     - Ingresa texto libre (ej: "login failed")
   * - 7a
     - Sistema
     - Busca en message y context

7.2 FA-02: Busqueda por Regex
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Operador
     - Ingresa patron regex (ej: ^ERROR.*timeout)
   * - 7a
     - Sistema
     - Ejecuta busqueda con expresion regular

7.3 FA-03: Trazar por Correlation ID
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Operador
     - Ingresa correlation_id especifico
   * - 7a
     - Sistema
     - Retorna todos los logs de ese flujo ordenados

8. Excepciones
--------------

8.1 EX-01: Regex Invalido
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Expresion regular mal formada
   * - **Accion Sistema**
     - Rechaza busqueda
   * - **Mensaje Usuario**
     - Expresion regular invalida
   * - **Codigo Error**
     - LOG-020

8.2 EX-02: Sin Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - No hay logs que coincidan
   * - **Accion Sistema**
     - Muestra mensaje informativo
   * - **Mensaje Usuario**
     - No se encontraron logs para la busqueda

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_LOG_03

   @startuml
   start
   :Operador accede a Busqueda;

   if (Tiene LOG-003?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Mostrar formulario;
   :Ingresar terminos de busqueda;

   switch (Tipo de busqueda?)
   case (Texto libre)
     :Buscar en message y context;
   case (Regex)
     if (Regex valido?) then (no)
       :Error regex invalido;
       stop
     else (si)
       :Ejecutar busqueda regex;
     endif
   case (Correlation ID)
     :Buscar todos los logs del flujo;
   endswitch

   :Procesar resultados;
   :Paginar y resaltar coincidencias;
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
   * - BR-LOG-20
     - Busqueda Case-Insensitive
     - Texto libre busca sin distincion mayusculas/minusculas
   * - BR-LOG-21
     - Limite Resultados
     - Maximo 10,000 resultados por busqueda
   * - BR-LOG-22
     - Resaltado
     - Terminos encontrados se resaltan en resultados
   * - BR-LOG-23
     - Correlation ID
     - Permite trazar un request completo a traves del sistema

**Campos Buscables (CNST-008):**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Campo
     - Descripcion
   * - message
     - Mensaje principal del log
   * - context
     - Objeto JSON con datos adicionales
   * - correlation_id
     - ID unico para trazar flujos
   * - component
     - Componente que genero el log
   * - level
     - Nivel de severidad

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-008
     - Logs JSON
     - Busqueda optimizada para estructura JSON

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-LOG-020
     - Busqueda por texto
     - Resultados relevantes mostrados
   * - FR-LOG-021
     - Busqueda regex
     - Patrones regex funcionales
   * - FR-LOG-022
     - Traza por correlation_id
     - Flujo completo visible

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-LOG-003
   * - **Restricciones**
     - CNST-008
   * - **UC Relacionados**
     - UC_LOG_01, UC_LOG_04
   * - **Funcion RBAC**
     - LOG-003: busca_logs

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