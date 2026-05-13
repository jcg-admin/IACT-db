.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_05
   :normativa: CNST-005, CNST-009

========================
UC_ACC_05: Gestionar SoD
========================

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
y gestionar las reglas de Separacion de Funciones (SoD) del sistema. El
sistema tiene 3 reglas SoD predefinidas que no pueden eliminarse pero si
pueden consultarse y verificar su aplicacion.

**Caracteristicas principales:**

- Consultar reglas SoD existentes (3 predefinidas)
- Ver usuarios que violan actualmente las reglas
- Ejecutar validacion masiva de SoD
- Generar reporte de conflictos
- Las reglas son parte del nucleo del sistema (no modificables)

**Reglas SoD Predefinidas (CNST-005):**

.. warning::
   Las 3 reglas SoD son parte del nucleo de seguridad del sistema y
   NO pueden ser modificadas ni eliminadas. Solo pueden consultarse.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_05

   @startuml

   left to right direction

   actor "AGR-007\nagr_admin_acceso" as ADMIN <<AGR_ADMIN>>
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Access" {
     usecase "UC_ACC_05\nGestionar SoD" as UC05
     usecase "Consultar\nReglas SoD" as RULES
     usecase "Detectar\nViolaciones" as DETECT
     usecase "Generar\nReporte" as REPORT
   }

   ADMIN --> UC05
   UC05 --> RULES : <<include>>
   UC05 --> DETECT : <<extend>>
   UC05 --> REPORT : <<extend>>
   SYS --> DETECT

   note right of RULES
     3 reglas predefinidas
     No modificables
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
     - El administrador tiene sesion activa con funcion ACC-005
   * - PRE-02
     - El sistema tiene las 3 reglas SoD configuradas

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de gestion de SoD.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Consulta:**

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
     - Valida funcion ACC-005 (gestiona_sod)
   * - 3
     - Sistema
     - Consulta las 3 reglas SoD predefinidas
   * - 4
     - Sistema
     - Presenta tabla con reglas: ID, Grupo A, Grupo B, Descripcion
   * - 5
     - Admin
     - Selecciona "Verificar Cumplimiento"
   * - 6
     - Sistema
     - Ejecuta validacion de SoD en todos los usuarios
   * - 7
     - Sistema
     - Identifica usuarios con violaciones
   * - 8
     - Sistema
     - Muestra lista de violaciones: usuario, regla, funciones en conflicto
   * - 9
     - Admin
     - Opcionalmente genera reporte de violaciones
   * - 10
     - Sistema
     - Genera reporte en formato tabla/exportable

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_05

   @startuml

   actor "AGR-007\nAdmin" as A
   participant "Frontend\nAccess" as FE <<Frontend>>
   participant "AccessController" as AC <<Backend>>
   participant "SoDService" as SS <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Accede a Gestion SoD
   activate FE

   FE -> AC: GET /api/sod/rules
   activate AC

   AC -> AC: verify_function(ACC-005)

   AC -> SS: get_sod_rules()
   activate SS

   SS -> SS: return PREDEFINED_RULES
   note right of SS
     SOD-001: PIP-* vs AUD-*
     SOD-002: USR-* vs AUD-*
     SOD-003: ACC-* vs AUD-*
   end note

   SS --> AC: rules (3)
   deactivate SS

   AC --> FE: 200 OK + rules
   deactivate AC

   FE --> A: Muestra tabla de reglas SoD

   == Verificar Cumplimiento ==
   A -> FE: Click "Verificar Cumplimiento"

   FE -> AC: GET /api/sod/violations
   activate AC

   AC -> SS: detect_all_violations()
   activate SS

   SS -> DB: SELECT u.id, u.username,\n  array_agg(f.code) as functions\nFROM users u\nJOIN user_functions uf ON u.id = uf.user_id\nJOIN functions f ON uf.function_id = f.id\nWHERE u.status = 'ACTIVO'\nGROUP BY u.id
   DB --> SS: users_with_functions

   loop for each user
     SS -> SS: check_sod_rules(user.functions)
     alt has violation
       SS -> SS: add_to_violations(user, rule, conflicting)
     end
   end

   SS --> AC: violations[]
   deactivate SS

   AC --> FE: 200 OK + violations
   deactivate AC

   FE --> A: Lista de violaciones (si hay)

   == Generar Reporte (opcional) ==
   A -> FE: Click "Generar Reporte"

   FE -> AC: GET /api/sod/report
   AC --> FE: report_data

   FE --> A: Reporte descargable
   deactivate FE

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
     - Muestra mensaje: "No hay violaciones de SoD"
   * - 8c
     - Sistema
     - Muestra indicador verde de cumplimiento

7.2 FA-02: Resolver Violacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Admin
     - Selecciona una violacion de la lista
   * - 8b
     - Sistema
     - Muestra detalle: usuario, funciones en conflicto
   * - 8c
     - Sistema
     - Ofrece opciones: "Revocar Grupo A" o "Revocar Grupo B"
   * - 8d
     - Admin
     - Selecciona opcion (redirige a UC_ACC_02)

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
     - "No tiene permisos para gestionar SoD"
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
   note right
     SOD-001: PIP vs AUD
     SOD-002: USR vs AUD
     SOD-003: ACC vs AUD
   end note

   if (Verificar cumplimiento?) then (si)
     :Consultar todos los usuarios activos;
     :Obtener funciones de cada usuario;

     while (Mas usuarios?) is (si)
       :Validar SoD para usuario;
       if (Viola alguna regla?) then (si)
         :Agregar a lista de violaciones;
       else (no)
       endif
     endwhile (no)

     if (Hay violaciones?) then (si)
       :Mostrar lista de violaciones;
     else (no)
       :Mostrar "Sin violaciones";
     endif
   else (no)
   endif

   if (Generar reporte?) then (si)
     :Generar reporte de cumplimiento;
     :Permitir descarga;
   else (no)
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
     - Las 3 reglas SoD son parte del nucleo del sistema y no pueden modificarse ni eliminarse.
   * - BR-ACC-41
     - Enforcement Automatico
     - Las reglas se aplican automaticamente en UC_ACC_01 y UC_ACC_04 al asignar funciones.
   * - BR-ACC-42
     - Violaciones Historicas
     - Pueden existir usuarios con violaciones por datos migrados o errores anteriores.
   * - BR-ACC-43
     - Resolucion Manual
     - Las violaciones detectadas deben resolverse manualmente revocando funciones.

**Reglas SoD del Sistema:**

.. list-table::
   :widths: 12 20 20 48
   :header-rows: 1

   * - ID
     - Grupo A
     - Grupo B
     - Descripcion
   * - SOD-001
     - PIP-* (Pipeline)
     - AUD-* (Auditoria)
     - Quien administra el pipeline de datos NO puede auditar el sistema. Evita manipulacion de evidencia.
   * - SOD-002
     - USR-* (Usuarios)
     - AUD-* (Auditoria)
     - Quien gestiona usuarios NO puede auditar. Evita ocultar creacion de cuentas maliciosas.
   * - SOD-003
     - ACC-* (Acceso)
     - AUD-* (Auditoria)
     - Quien gestiona permisos NO puede auditar. Evita ocultar asignacion indebida de permisos.

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
     - Las reglas SoD estan hardcodeadas en el sistema. Este UC permite consultarlas y detectar violaciones pero no modificarlas.
   * - CNST-009
     - Auditoria Inmutable
     - Las verificaciones de SoD se registran en auditoria cuando se generan reportes.

**Implementacion de Reglas SoD:**

.. code-block:: python

   # services/sod_service.py
   class SoDService:
       # Reglas hardcodeadas - NO MODIFICAR
       SOD_RULES = [
           {
               'id': 'SOD-001',
               'name': 'Pipeline vs Auditoria',
               'group_a': {'prefix': 'PIP-', 'description': 'Funciones de Pipeline'},
               'group_b': {'prefix': 'AUD-', 'description': 'Funciones de Auditoria'},
               'severity': 'CRITICAL'
           },
           {
               'id': 'SOD-002',
               'name': 'Usuarios vs Auditoria',
               'group_a': {'prefix': 'USR-', 'description': 'Funciones de Usuarios'},
               'group_b': {'prefix': 'AUD-', 'description': 'Funciones de Auditoria'},
               'severity': 'CRITICAL'
           },
           {
               'id': 'SOD-003',
               'name': 'Acceso vs Auditoria',
               'group_a': {'prefix': 'ACC-', 'description': 'Funciones de Acceso'},
               'group_b': {'prefix': 'AUD-', 'description': 'Funciones de Auditoria'},
               'severity': 'CRITICAL'

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
