.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_05
   :normativa: CNST-005, CNST-009

==================================================
UC_ACC_05: Gestionar SoD
==================================================

.. contents:: Contenido
   :depth: 3
   :local:

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_05
   * - **Nombre**
     - Gestionar SoD (Separacion de Funciones)
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Actor Secundario**
     - Sistema (enforcement automatico)
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-005: gestiona_sod
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-ACC-005

2. Descripcion
--------------

Este caso de uso permite a un administrador de acceso (AGR-007) consultar
y gestionar las reglas de Separacion de Funciones (SoD) del sistema.

**Caracteristicas principales:**

- Consultar reglas SoD existentes (3 predefinidas)
- Ver usuarios que violan actualmente las reglas
- Ejecutar validacion masiva de SoD
- Generar reporte de conflictos
- Las reglas son parte del nucleo del sistema (no modificables)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_05

   @startuml
   left to right direction
   
   actor "AGR-007\nagr_admin_acceso" as ADMIN
   actor "Sistema" as SYS
   
   rectangle "MOD_Access" {
     usecase "UC_ACC_05\nGestionar SoD" as UC05
     usecase "Consultar Reglas" as RULES
     usecase "Detectar Violaciones" as DETECT
     usecase "Generar Reporte" as REPORT
   }
   
   ADMIN --> UC05
   UC05 --> RULES : include
   UC05 --> DETECT : extend
   UC05 --> REPORT : extend
   SYS --> DETECT
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
     - El administrador tiene sesion activa con funcion ACC-005
   * - PRE-02
     - El sistema tiene las 3 reglas SoD configuradas

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de gestion de SoD.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran las reglas SoD y su estado
   * - POST-02
     - Se identifican usuarios con violaciones actuales

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
     - Accede al modulo de gestion de SoD
   * - 2
     - Sistema
     - Valida funcion ACC-005
   * - 3
     - Sistema
     - Consulta las 3 reglas SoD predefinidas
   * - 4
     - Sistema
     - Presenta tabla con reglas
   * - 5
     - Admin
     - Selecciona Verificar Cumplimiento
   * - 6
     - Sistema
     - Ejecuta validacion en todos los usuarios
   * - 7
     - Sistema
     - Identifica usuarios con violaciones
   * - 8
     - Sistema
     - Muestra lista de violaciones
   * - 9
     - Admin
     - Opcionalmente genera reporte
   * - 10
     - Sistema
     - Genera reporte exportable

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_05

   @startuml
   actor "AGR-007 Admin" as A
   participant "Frontend" as FE
   participant "AccessController" as AC
   participant "SoDService" as SS
   database "Analytics" as DB
   
   A -> FE: Accede a Gestion SoD
   FE -> AC: GET /api/sod/rules
   AC -> SS: get_sod_rules()
   SS --> AC: rules (3)
   AC --> FE: 200 OK + rules
   FE --> A: Muestra reglas
   
   A -> FE: Verificar Cumplimiento
   FE -> AC: GET /api/sod/violations
   AC -> SS: detect_all_violations()
   SS -> DB: SELECT users con funciones
   DB --> SS: users_data
   SS -> SS: check_sod_rules()
   SS --> AC: violations[]
   AC --> FE: 200 OK + violations
   FE --> A: Lista de violaciones
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Sin Violaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Sistema
     - No detecta violaciones
   * - 8b
     - Sistema
     - Muestra mensaje Sin violaciones de SoD

8. Excepciones
--------------

8.1 EX-01: Sin Permiso ACC-005
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion ACC-005
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para gestionar SoD
   * - **Codigo Error**
     - ACC-040

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_05

   @startuml
   start
   :Admin accede a Gestion SoD;
   if (Tiene ACC-005?) then (no)
     :Error de permisos;
     stop
   else (si)
   endif
   :Cargar reglas SoD predefinidas;
   :Mostrar tabla de reglas;
   if (Verificar cumplimiento?) then (si)
     :Consultar usuarios activos;
     :Validar SoD para cada usuario;
     if (Hay violaciones?) then (si)
       :Mostrar lista de violaciones;
     else (no)
       :Mostrar Sin violaciones;
     endif
   endif
   if (Generar reporte?) then (si)
     :Generar reporte;
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
   * - BR-ACC-40
     - Reglas Inmutables
     - Las 3 reglas SoD no pueden modificarse ni eliminarse
   * - BR-ACC-41
     - Enforcement Automatico
     - Se aplican automaticamente al asignar funciones
   * - BR-ACC-42
     - Violaciones Historicas
     - Pueden existir usuarios con violaciones por migracion

**Reglas SoD del Sistema:**

.. list-table::
   :widths: 12 22 22 44
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
     - Quien gestiona usuarios no audita
   * - SOD-003
     - ACC-* (Acceso)
     - AUD-* (Auditoria)
     - Quien gestiona permisos no audita

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
     - Reglas hardcodeadas. Este UC permite consultarlas y detectar violaciones.
   * - CNST-009
     - Auditoria Inmutable
     - Las verificaciones se registran en auditoria.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-040
     - El sistema debe mostrar las 3 reglas SoD
     - Lista con ID, grupos y descripcion
   * - FR-ACC-041
     - El sistema debe detectar violaciones existentes
     - Lista de usuarios con conflictos
   * - FR-ACC-042
     - El sistema debe generar reporte
     - Reporte exportable

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-005: Gestionar reglas de Separacion de Funciones
   * - **Reglas de Negocio**
     - BR-ACC-40 a BR-ACC-42
   * - **Restricciones**
     - CNST-005 (SoD), CNST-009 (Auditoria)
   * - **FR Derivados**
     - FR-ACC-040 a FR-ACC-042
   * - **UC Relacionados**
     - UC_ACC_01, UC_ACC_02, UC_ACC_04
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-005: gestiona_sod

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
     - Version inicial v4.0 con 3 reglas predefinidas
