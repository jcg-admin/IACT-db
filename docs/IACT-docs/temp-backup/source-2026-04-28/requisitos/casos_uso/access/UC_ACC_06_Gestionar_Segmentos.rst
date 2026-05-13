.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_06
   :normativa: CNST-005, CNST-009

==============================
UC_ACC_06: Gestionar Segmentos
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_06
   * - **Nombre**
     - Gestionar Segmentos
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-006: gestiona_segmentos
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-ACC-006

2. Descripcion
--------------

Este caso de uso permite gestionar el catalogo de segmentos de datos del
sistema. Los segmentos definen particiones de datos que limitan la
visibilidad de los usuarios.

**Caracteristicas principales:**

- Crear nuevos segmentos
- Modificar segmentos existentes
- Desactivar segmentos (no eliminar)
- Cada usuario pertenece a exactamente un segmento

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_06

   @startuml
   left to right direction
   actor "AGR-007\nagr_admin_acceso" as ADMIN

   rectangle "MOD_Access" {
     usecase "UC_ACC_06\nGestionar Segmentos" as UC06
     usecase "Crear Segmento" as CREATE
     usecase "Modificar Segmento" as EDIT
     usecase "Desactivar Segmento" as DEACT
     usecase "Listar Segmentos" as LIST
   }

   ADMIN --> UC06
   UC06 --> CREATE : extend
   UC06 --> EDIT : extend
   UC06 --> DEACT : extend
   UC06 --> LIST : include
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
     - El administrador tiene sesion activa con funcion ACC-006

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de gestion de segmentos.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - El catalogo de segmentos se actualiza segun la operacion
   * - POST-02
     - Se registra en auditoria (CNST-009)

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
     - Accede a gestion de segmentos
   * - 2
     - Sistema
     - Valida funcion ACC-006
   * - 3
     - Sistema
     - Muestra lista de segmentos existentes
   * - 4
     - Admin
     - Selecciona Crear Segmento
   * - 5
     - Sistema
     - Muestra formulario
   * - 6
     - Admin
     - Ingresa nombre y descripcion
   * - 7
     - Admin
     - Presiona Guardar
   * - 8
     - Sistema
     - Valida unicidad de nombre
   * - 9
     - Sistema
     - Crea registro de segmento
   * - 10
     - Sistema
     - Registra en auditoria
   * - 11
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_06

   @startuml
   actor "AGR-007 Admin" as A
   participant "Frontend" as FE
   participant "AccessController" as AC
   participant "SegmentService" as SS
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   A -> FE: Accede a Segmentos
   FE -> AC: GET /api/segmentos
   AC -> SS: list_segmentos()
   SS -> DB: SELECT * FROM segmentos
   DB --> SS: segmentos
   SS --> AC: segmentos
   AC --> FE: 200 OK
   FE --> A: Lista de segmentos

   A -> FE: Crear Segmento
   A -> FE: Ingresa datos
   FE -> AC: POST /api/segmentos
   AC -> SS: create_segmento(data)
   SS -> DB: INSERT INTO segmentos
   SS -> UAL: record(SEGMENT_CREATE)
   UAL -> DB: INSERT audit
   SS --> AC: segmento_created
   AC --> FE: 201 Created
   FE --> A: Confirmacion
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Modificar Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Admin
     - Selecciona un segmento existente
   * - 5a
     - Sistema
     - Muestra formulario con datos actuales
   * - 6a
     - Admin
     - Modifica campos
   * - 7a
     - Sistema
     - Actualiza registro

7.2 FA-02: Desactivar Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Admin
     - Selecciona Desactivar
   * - 5a
     - Sistema
     - Verifica que no haya usuarios asignados
   * - 6a
     - Sistema
     - Cambia estado a INACTIVO

8. Excepciones
--------------

8.1 EX-01: Segmento con Usuarios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - FA-02, paso 5a
   * - **Condicion**
     - Segmento tiene usuarios asignados
   * - **Accion Sistema**
     - Rechaza desactivacion
   * - **Mensaje Usuario**
     - No se puede desactivar segmento con usuarios asignados
   * - **Codigo Error**
     - ACC-050

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_06

   @startuml
   start
   :Admin accede a Segmentos;
   if (Tiene ACC-006?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Mostrar lista de segmentos;
   switch (Accion?)
   case (Crear)
     :Mostrar formulario;
     :Validar unicidad nombre;
     :Crear segmento;
   case (Modificar)
     :Cargar datos actuales;
     :Actualizar segmento;
   case (Desactivar)
     if (Tiene usuarios?) then (si)
       :Error: tiene usuarios;
       stop
     else (no)
       :Desactivar segmento;
     endif
   endswitch
   :Registrar en auditoria;
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
   * - BR-ACC-50
     - Usuario Un Segmento
     - Cada usuario pertenece a exactamente un segmento
   * - BR-ACC-51
     - Nombre Unico
     - El nombre de segmento debe ser unico
   * - BR-ACC-52
     - Sin Eliminar
     - Los segmentos se desactivan, no se eliminan

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
     - Los segmentos son parte del modelo de permisos
   * - CNST-009
     - Auditoria Inmutable
     - Se registran operaciones sobre segmentos

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-050
     - El sistema debe permitir crear segmentos
     - Segmento creado con nombre unico
   * - FR-ACC-051
     - El sistema debe impedir desactivar con usuarios
     - Error si segmento tiene usuarios

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-006: Gestionar catalogo de segmentos
   * - **Reglas de Negocio**
     - BR-ACC-50 a BR-ACC-52
   * - **Restricciones**
     - CNST-005, CNST-009
   * - **UC Relacionados**
     - UC_ACC_07 (Asignar Segmento)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-006: gestiona_segmentos

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