.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_10
   :normativa: CNST-004

========================
UC_RPT_10: Guardar Vista
========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_10
   * - **Nombre**
     - Guardar Vista
   * - **Actor Principal**
     - AGR-002: agr_operador_reportes
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-010: guarda_vistas
   * - **Prioridad**
     - Baja
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-RPT-010

2. Descripcion
--------------

Permite guardar configuraciones de vistas personalizadas de reportes
para acceso rapido posterior. Las vistas son privadas del usuario.

**Caracteristicas principales:**

- Guardar estado actual del reporte como vista
- Nombre personalizado para la vista
- Vistas privadas del usuario
- Acceso rapido desde menu

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_10

   @startuml
   left to right direction
   actor "AGR-002\nagr_operador_reportes" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_10\nGuardar Vista" as UC10
     usecase "Cargar Vista" as LOAD
   }
   USER --> UC10
   USER --> LOAD
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
     - Usuario tiene funcion RPT-010
   * - PRE-02
     - Usuario esta visualizando un reporte

4.2 Trigger
^^^^^^^^^^^

Usuario hace clic en Guardar Vista.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Vista guardada y disponible en menu

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
     - Configura reporte con filtros deseados
   * - 2
     - Usuario
     - Hace clic en Guardar Vista
   * - 3
     - Sistema
     - Valida RPT-010
   * - 4
     - Sistema
     - Solicita nombre para la vista
   * - 5
     - Usuario
     - Ingresa nombre
   * - 6
     - Sistema
     - Guarda configuracion actual
   * - 7
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_10

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ViewController" as VC
   participant "ViewService" as VS
   database "Analytics" as DB

   U -> FE: Guardar Vista
   FE --> U: Solicitar nombre
   U -> FE: nombre_vista
   FE -> VC: POST /api/reports/views
   VC -> VC: verify_function(RPT-010)
   VC -> VS: save_view(user, config, nombre)
   VS -> DB: INSERT INTO user_views
   DB --> VS: view_id
   VS --> VC: view_saved
   VC --> FE: 201 Created
   FE --> U: Vista guardada
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Cargar Vista Guardada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Usuario
     - Selecciona vista guardada del menu
   * - 1b
     - Sistema
     - Carga configuracion de la vista
   * - 1c
     - Sistema
     - Aplica filtros y muestra reporte

7.2 FA-02: Eliminar Vista
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Usuario
     - Selecciona Eliminar en una vista
   * - 1b
     - Sistema
     - Elimina vista guardada

8. Excepciones
--------------

8.1 EX-01: Nombre Duplicado
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - Ya existe una vista con ese nombre
   * - **Mensaje**
     - Ya tiene una vista con ese nombre
   * - **Codigo Error**
     - RPT-090

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_10

   @startuml
   start
   if (Tiene RPT-010?) then (no)
     stop
   else (si)
   endif
   :Solicitar nombre;
   if (Nombre duplicado?) then (si)
     :Error duplicado;
     stop
   else (no)
   endif
   :Guardar configuracion;
   :Mostrar en menu;
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
   * - BR-RPT-90
     - Privadas
     - Vistas son privadas del usuario
   * - BR-RPT-91
     - Limite
     - Maximo 20 vistas por usuario
   * - BR-RPT-92
     - Nombre Unico
     - Nombre unico por usuario

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-004
     - Segmentos
     - Vista respeta segmento del usuario

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-090
     - Guardar vistas
     - Vista accesible desde menu
   * - FR-RPT-091
     - Cargar vistas
     - Configuracion restaurada

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-010
   * - **Restricciones**
     - CNST-004
   * - **Actor Principal**
     - AGR-002: agr_operador_reportes
   * - **Funcion RBAC**
     - RPT-010: guarda_vistas

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