.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Access
   :uc_id: UC_ACC_08
   :normativa: CNST-005, CNST-009

===========================
UC_ACC_08: Permiso Temporal
===========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ACC_08
   * - **Nombre**
     - Permiso Temporal
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Modulo**
     - MOD_Access
   * - **Funcion RBAC**
     - ACC-001: asigna_funciones
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-ACC-008

2. Descripcion
--------------

Este caso de uso permite asignar funciones temporales a un usuario con
fecha de vencimiento automatico. Util para permisos de cobertura,
proyectos especiales o accesos limitados en tiempo.

**Caracteristicas principales:**

- Asignar funciones con fecha de inicio y fin
- Maximo 6 meses de duracion (CNST-005)
- Justificacion obligatoria
- Validacion SoD igual que permisos permanentes
- Expiracion automatica por el sistema

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ACC_08

   @startuml
   left to right direction
   actor "AGR-007\nagr_admin_acceso" as ADMIN
   actor "Sistema" as SYS

   rectangle "MOD_Access" {
     usecase "UC_ACC_08\nPermiso Temporal" as UC08
     usecase "Definir Periodo" as PER
     usecase "Validar SoD" as SOD
     usecase "Expirar Automatico" as EXP
   }

   ADMIN --> UC08
   UC08 --> PER : include
   UC08 --> SOD : include
   SYS --> EXP
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
     - El administrador tiene sesion activa con funcion ACC-001
   * - PRE-02
     - El usuario destino existe y esta ACTIVO
   * - PRE-03
     - La funcion a asignar existe en el catalogo

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona asignar permiso temporal a un usuario.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se crea registro en permisos_temporales
   * - POST-02
     - El permiso queda activo durante el periodo definido
   * - POST-03
     - Se registra TEMP_PERMISSION_GRANT en auditoria

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
     - Accede a asignar permiso temporal
   * - 2
     - Sistema
     - Valida funcion ACC-001
   * - 3
     - Admin
     - Selecciona usuario destino
   * - 4
     - Admin
     - Selecciona funcion a asignar
   * - 5
     - Admin
     - Define fecha de inicio
   * - 6
     - Admin
     - Define fecha de fin (max 6 meses)
   * - 7
     - Admin
     - Ingresa justificacion obligatoria
   * - 8
     - Admin
     - Confirma asignacion
   * - 9
     - Sistema
     - Valida duracion maxima 6 meses
   * - 10
     - Sistema
     - Valida SoD incluyendo permiso temporal
   * - 11
     - Sistema
     - Crea registro de permiso temporal
   * - 12
     - Sistema
     - Registra en auditoria
   * - 13
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ACC_08

   @startuml
   actor "AGR-007 Admin" as A
   participant "Frontend" as FE
   participant "AccessController" as AC
   participant "TempPermService" as TPS
   participant "SoDValidator" as SOD
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   A -> FE: Asignar permiso temporal
   FE --> A: Formulario
   A -> FE: user, function, inicio, fin, justificacion
   A -> FE: Confirma

   FE -> AC: POST /api/users/{id}/temp-permissions
   AC -> AC: verify_function(ACC-001)
   AC -> TPS: grant_temp_permission(data)

   TPS -> TPS: validate_duration(inicio, fin)
   note right: Max 6 meses CNST-005

   TPS -> SOD: validate(user_id, [function])
   SOD --> TPS: valid o SoDViolation

   TPS -> DB: INSERT INTO permisos_temporales
   TPS -> UAL: record(TEMP_PERMISSION_GRANT)
   UAL -> DB: INSERT audit

   TPS --> AC: temp_permission_created
   AC --> FE: 201 Created
   FE --> A: Confirmacion con fecha expiracion
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Extender Permiso Existente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Sistema
     - Detecta permiso temporal existente
   * - 4b
     - Sistema
     - Ofrece extender en lugar de crear nuevo
   * - 6a
     - Admin
     - Define nueva fecha de fin
   * - 9a
     - Sistema
     - Valida que total no exceda 6 meses desde inicio original

7.2 FA-02: Revocar Permiso Temporal
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Admin
     - Selecciona revocar permiso temporal activo
   * - 2a
     - Sistema
     - Cambia fecha_fin a ahora
   * - 3a
     - Sistema
     - Registra TEMP_PERMISSION_REVOKE

8. Excepciones
--------------

8.1 EX-01: Duracion Excede 6 Meses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Diferencia entre inicio y fin mayor a 6 meses
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - Duracion maxima de permiso temporal es 6 meses
   * - **Codigo Error**
     - ACC-070

8.2 EX-02: Viola SoD
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Permiso temporal viola restriccion SoD
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - Conflicto SoD: funcion incompatible
   * - **Codigo Error**
     - ACC-071

8.3 EX-03: Sin Justificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Campo justificacion vacio
   * - **Accion Sistema**
     - Rechaza asignacion
   * - **Mensaje Usuario**
     - Justificacion es obligatoria para permisos temporales
   * - **Codigo Error**
     - ACC-072

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ACC_08

   @startuml
   start
   :Admin accede a permisos temporales;
   if (Tiene ACC-001?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Seleccionar usuario y funcion;
   :Definir fecha inicio y fin;
   :Ingresar justificacion;
   if (Justificacion vacia?) then (si)
     :Error justificacion requerida;
     stop
   else (no)
   endif
   if (Duracion > 6 meses?) then (si)
     :Error duracion maxima;
     stop
   else (no)
   endif
   :Validar SoD;
   if (Viola SoD?) then (si)
     :Error conflicto SoD;
     stop
   else (no)
   endif
   :Crear permiso temporal;
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
   * - BR-ACC-70
     - Duracion Maxima
     - Un permiso temporal no puede exceder 6 meses
   * - BR-ACC-71
     - Justificacion Obligatoria
     - Todo permiso temporal requiere justificacion escrita
   * - BR-ACC-72
     - SoD Aplica
     - Los permisos temporales se validan contra SoD
   * - BR-ACC-73
     - Expiracion Automatica
     - El sistema invalida automaticamente al llegar fecha_fin
   * - BR-ACC-74
     - Precedencia Alta
     - Permisos temporales tienen precedencia sobre agrupadores

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
     - Permisos temporales max 6 meses, con justificacion obligatoria
   * - CNST-009
     - Auditoria Inmutable
     - Se registra TEMP_PERMISSION_GRANT con justificacion y fechas

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ACC-070
     - El sistema debe validar duracion maxima 6 meses
     - Rechazo si excede limite
   * - FR-ACC-071
     - El sistema debe requerir justificacion
     - Campo obligatorio no vacio
   * - FR-ACC-072
     - El sistema debe expirar automaticamente
     - Permiso inactivo al pasar fecha_fin

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ACC-008: Permitir asignacion de permisos temporales
   * - **Reglas de Negocio**
     - BR-ACC-70 a BR-ACC-74
   * - **Restricciones**
     - CNST-005, CNST-009
   * - **UC Relacionados**
     - UC_ACC_01, UC_ACC_03
   * - **Actor Principal**
     - AGR-007: agr_admin_acceso
   * - **Funcion RBAC**
     - ACC-001: asigna_funciones

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