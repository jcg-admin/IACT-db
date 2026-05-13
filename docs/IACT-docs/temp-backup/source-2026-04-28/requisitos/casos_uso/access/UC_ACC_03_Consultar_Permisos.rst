.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_03
   :normativa: CNST-005

=============================
UC_ACC_03: Consultar Permisos
=============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_03
   * - **Nombre**
     - Consultar Permisos
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Actor Secundario**
     - N/A
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-003: ve_asignaciones
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-ACC-003

2. Descripcion
--------------

Este caso de uso permite a un administrador de acceso (AGR-007) consultar
los permisos efectivos de un usuario, incluyendo funciones asignadas
directamente, funciones de agrupadores y permisos temporales.

**Caracteristicas principales:**

- Ver funciones asignadas directamente
- Ver funciones heredadas de agrupadores
- Ver permisos temporales activos
- Ver segmento asignado
- Calcular permisos efectivos (union de todas las fuentes)
- Detectar conflictos SoD potenciales

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_03

   @startuml

   left to right direction

   actor "AGR-007\nagr_admin_acceso" as ADMIN <<AGR_ADMIN>>

   rectangle "MOD_Access" {
     usecase "UC_ACC_03\nConsultar Permisos" as UC03
     usecase "Ver Funciones\nDirectas" as DIR
     usecase "Ver Funciones\nAgrupador" as AGR
     usecase "Ver Permisos\nTemporales" as TEMP
     usecase "Calcular\nEfectivos" as CALC
   }

   ADMIN --> UC03
   UC03 --> DIR : <<include>>
   UC03 --> AGR : <<include>>
   UC03 --> TEMP : <<include>>
   UC03 --> CALC : <<include>>

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
     - El administrador tiene sesion activa con funcion ACC-003
   * - PRE-02
     - El usuario consultado existe en el sistema

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona un usuario y accede a "Ver Permisos".

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra la informacion de permisos del usuario
   * - POST-02
     - La consulta no modifica ningun dato

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
     - Valida funcion ACC-003 (ve_asignaciones)
   * - 3
     - Admin
     - Busca y selecciona usuario
   * - 4
     - Sistema
     - Consulta funciones directas del usuario
   * - 5
     - Sistema
     - Consulta agrupadores asignados
   * - 6
     - Sistema
     - Consulta permisos temporales activos
   * - 7
     - Sistema
     - Consulta segmento asignado
   * - 8
     - Sistema
     - Calcula permisos efectivos (union)
   * - 9
     - Sistema
     - Detecta posibles conflictos SoD
   * - 10
     - Sistema
     - Presenta panel con toda la informacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_03

   @startuml

   actor "AGR-007\nAdmin" as A
   participant "Frontend\nAccess" as FE <<Frontend>>
   participant "AccessController" as AC <<Backend>>
   participant "PermissionService" as PS <<Service>>
   participant "SoDValidator" as SOD <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Selecciona usuario
   activate FE

   FE -> AC: GET /api/users/{id}/permissions
   activate AC

   AC -> AC: verify_function(ACC-003)

   AC -> PS: get_effective_permissions(user_id)
   activate PS

   == Funciones Directas ==
   PS -> DB: SELECT f.* FROM user_functions uf\nJOIN functions f ON uf.function_id = f.id\nWHERE uf.user_id = ?
   DB --> PS: direct_functions

   == Funciones de Agrupadores ==
   PS -> DB: SELECT a.*, f.* FROM user_agrupadores ua\nJOIN agrupadores a ON ua.agrupador_id = a.id\nJOIN agrupador_functions af ON a.id = af.agrupador_id\nJOIN functions f ON af.function_id = f.id\nWHERE ua.user_id = ?
   DB --> PS: agrupador_functions

   == Permisos Temporales ==
   PS -> DB: SELECT * FROM permisos_temporales\nWHERE user_id = ?\nAND fecha_inicio <= now()\nAND fecha_fin >= now()
   DB --> PS: temp_permissions

   == Segmento ==
   PS -> DB: SELECT s.* FROM users u\nJOIN segmentos s ON u.segmento_id = s.id\nWHERE u.id = ?
   DB --> PS: segmento

   == Calcular Efectivos ==
   PS -> PS: merge_permissions(\ndirect, agrupador, temp)
   note right of PS
     CNST-005: Precedencia
     Temporal > Directo > Agrupador
   end note

   == Detectar SoD ==
   PS -> SOD: check_potential_conflicts(effective_permissions)
   SOD --> PS: sod_warnings (if any)

   PS --> AC: {direct, agrupadores, temp,\nsegmento, effective, sod_warnings}
   deactivate PS

   AC --> FE: 200 OK + permissions_detail
   deactivate AC

   FE --> A: Panel de permisos completo
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Usuario Sin Permisos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 10a
     - Sistema
     - Detecta que usuario no tiene ninguna funcion
   * - 10b
     - Sistema
     - Muestra mensaje: "Usuario sin permisos asignados"
   * - 10c
     - Sistema
     - Ofrece opcion de asignar funciones (UC_ACC_01)

7.2 FA-02: Conflicto SoD Detectado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 9a
     - Sistema
     - Detecta conflicto SoD en permisos actuales
   * - 9b
     - Sistema
     - Muestra alerta visual en el panel
   * - 9c
     - Sistema
     - Indica funciones en conflicto y regla violada

8. Excepciones
--------------

8.1 EX-01: Sin Permiso ACC-003
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion ACC-003
   * - **Accion Sistema**
     - Rechaza consulta
   * - **Mensaje Usuario**
     - "No tiene permisos para ver asignaciones"
   * - **Codigo Error**
     - ACC-020

8.2 EX-02: Usuario No Encontrado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - ID de usuario no existe
   * - **Accion Sistema**
     - Retorna error 404
   * - **Mensaje Usuario**
     - "Usuario no encontrado"
   * - **Codigo Error**
     - ACC-021

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_03

   @startuml

   start

   :Admin selecciona usuario;

   if (Tiene funcion ACC-003?) then (no)
     :Error de permisos;
     stop
   else (si)
   endif

   fork
     :Consultar funciones directas;
   fork again
     :Consultar agrupadores;
   fork again
     :Consultar permisos temporales;
   fork again
     :Consultar segmento;
   end fork

   :Calcular permisos efectivos;
   note right
     CNST-005
     Union de todas las fuentes
   end note

   :Detectar conflictos SoD;

   if (Hay conflictos SoD?) then (si)
     :Agregar alertas visuales;
   else (no)
   endif

   :Mostrar panel de permisos;

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
   * - BR-ACC-20
     - Permisos Efectivos
     - Los permisos efectivos son la union de: funciones directas + funciones de agrupadores + permisos temporales activos.
   * - BR-ACC-21
     - Precedencia
     - En caso de conflicto: Permiso Temporal > Funcion Directa > Agrupador.
   * - BR-ACC-22
     - Solo Lectura
     - Esta operacion es de solo lectura, no modifica datos.
   * - BR-ACC-23
     - Deteccion SoD
     - Se detectan y alertan conflictos SoD aunque ya existan (para limpieza).

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
     - Se muestran las tres fuentes de permisos separadas y su union. Se respeta precedencia para calculo de efectivos.

**Estructura de Permisos Efectivos:**

.. code-block:: python

   {
       "direct_functions": [
           {"code": "RPT-001", "name": "ve_reportes", "source": "direct"}
       ],
       "agrupador_functions": [
           {"code": "RPT-002", "name": "ve_dashboard",
            "source": "agrupador", "agrupador": "AGR-001"}
       ],
       "temp_permissions": [
           {"code": "RPT-004", "name": "exporta_csv",
            "source": "temp", "expires": "2026-02-01"}
       ],
       "segmento": {
           "id": 1, "nombre": "Centro Norte"
       },
       "effective": ["RPT-001", "RPT-002", "RPT-004"],
       "sod_warnings": []
   }

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-020
     - El sistema debe mostrar funciones directas
     - Lista con codigo, nombre y fecha asignacion
   * - FR-ACC-021
     - El sistema debe mostrar funciones de agrupadores
     - Lista indicando agrupador de origen
   * - FR-ACC-022
     - El sistema debe mostrar permisos temporales
     - Lista con fecha de expiracion
   * - FR-ACC-023
     - El sistema debe calcular permisos efectivos
     - Union de todas las fuentes sin duplicados
   * - FR-ACC-024
     - El sistema debe alertar conflictos SoD
     - Indicador visual cuando hay conflicto

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-003: Permitir consulta de permisos de usuarios
   * - **Reglas de Negocio**
     - BR-ACC-20 a BR-ACC-23
   * - **Restricciones**
     - CNST-005 (RBAC Flat)
   * - **FR Derivados**
     - FR-ACC-020 a FR-ACC-024
   * - **UC Relacionados**
     - UC_ACC_01 (Asignar), UC_ACC_02 (Revocar), UC_ACC_08 (Temporal)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-003: ve_asignaciones

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
     - Version inicial v4.0 con deteccion SoD