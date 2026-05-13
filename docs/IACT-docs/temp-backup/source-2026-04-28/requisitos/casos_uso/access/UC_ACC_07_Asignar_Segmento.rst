.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_07
   :normativa: CNST-005, CNST-009

===========================
UC_ACC_07: Asignar Segmento
===========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_07
   * - **Nombre**
     - Asignar Segmento
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - USR-010: asigna_segmento
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-ACC-007

2. Descripcion
--------------

Este caso de uso permite asignar o cambiar el segmento de datos de un
usuario. El segmento determina que datos puede ver el usuario segun su
ubicacion o area de responsabilidad.

**Caracteristicas principales:**

- Asignar segmento a usuario nuevo
- Cambiar segmento de usuario existente
- Un usuario tiene exactamente un segmento
- El cambio tiene efecto inmediato

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_07

   @startuml
   left to right direction
   actor "AGR-007\nagr_admin_acceso" as ADMIN

   rectangle "MOD_Access" {
     usecase "UC_ACC_07\nAsignar Segmento" as UC07
     usecase "Seleccionar Usuario" as SEL
     usecase "Seleccionar Segmento" as SEG
   }

   ADMIN --> UC07
   UC07 --> SEL : include
   UC07 --> SEG : include
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
     - El administrador tiene sesion activa con funcion USR-010
   * - PRE-02
     - El usuario destino existe
   * - PRE-03
     - El segmento destino existe y esta activo

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona un usuario y elige cambiar su segmento.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - El usuario queda asignado al nuevo segmento
   * - POST-02
     - Se registra SEGMENT_ASSIGN en auditoria (CNST-009)

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
     - Selecciona usuario
   * - 2
     - Sistema
     - Valida funcion USR-010
   * - 3
     - Sistema
     - Muestra segmento actual del usuario
   * - 4
     - Sistema
     - Muestra lista de segmentos disponibles
   * - 5
     - Admin
     - Selecciona nuevo segmento
   * - 6
     - Admin
     - Confirma cambio
   * - 7
     - Sistema
     - Actualiza segmento_id del usuario
   * - 8
     - Sistema
     - Registra SEGMENT_ASSIGN en auditoria
   * - 9
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_07

   @startuml
   actor "AGR-007 Admin" as A
   participant "Frontend" as FE
   participant "AccessController" as AC
   participant "UserService" as US
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   A -> FE: Selecciona usuario
   FE -> AC: GET /api/users/{id}
   AC --> FE: user con segmento actual

   FE -> AC: GET /api/segmentos?active=true
   AC --> FE: segmentos disponibles
   FE --> A: Muestra formulario

   A -> FE: Selecciona segmento
   A -> FE: Confirma
   FE -> AC: PUT /api/users/{id}/segmento
   AC -> AC: verify_function(USR-010)
   AC -> US: assign_segmento(user_id, segmento_id)
   US -> DB: UPDATE users SET segmento_id = ?
   US -> UAL: record(SEGMENT_ASSIGN)
   UAL -> DB: INSERT audit
   US --> AC: success
   AC --> FE: 200 OK
   FE --> A: Confirmacion
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Mismo Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Admin
     - Selecciona el segmento actual
   * - 6a
     - Sistema
     - Muestra mensaje: Sin cambios

8. Excepciones
--------------

8.1 EX-01: Segmento Inactivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Segmento seleccionado esta inactivo
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - No se puede asignar segmento inactivo
   * - **Codigo Error**
     - ACC-060

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_07

   @startuml
   start
   :Admin selecciona usuario;
   if (Tiene USR-010?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Mostrar segmento actual;
   :Mostrar segmentos disponibles;
   :Admin selecciona nuevo segmento;
   if (Es mismo segmento?) then (si)
     :Mostrar Sin cambios;
     stop
   else (no)
   endif
   if (Segmento activo?) then (no)
     :Error segmento inactivo;
     stop
   else (si)
   endif
   :Actualizar segmento del usuario;
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
   * - BR-ACC-60
     - Un Segmento
     - Un usuario pertenece a exactamente un segmento
   * - BR-ACC-61
     - Segmento Activo
     - Solo se puede asignar segmentos activos
   * - BR-ACC-62
     - Efecto Inmediato
     - El cambio afecta inmediatamente la visibilidad de datos

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
     - El segmento es parte del modelo de permisos
   * - CNST-009
     - Auditoria Inmutable
     - Se registra SEGMENT_ASSIGN con segmento anterior y nuevo

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-060
     - El sistema debe permitir asignar segmento
     - Campo segmento_id actualizado
   * - FR-ACC-061
     - El sistema debe registrar cambio de segmento
     - Auditoria con old y new segmento

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-007: Permitir asignacion de segmentos
   * - **Reglas de Negocio**
     - BR-ACC-60 a BR-ACC-62
   * - **Restricciones**
     - CNST-005, CNST-009
   * - **UC Relacionados**
     - UC_ACC_06 (Gestionar Segmentos), UC_USR_01 (Crear Usuario)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - USR-010: asigna_segmento

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