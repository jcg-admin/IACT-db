.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Alerts
   :uc_id: UC_ALR_01
   :normativa: CNST-004, CNST-009

==============================
UC_ALR_01: Configurar Umbrales
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ALR_01
   * - **Nombre**
     - Configurar Umbrales
   * - **Actor Principal**
     - AGR-005: agr_gestor_alertas
   * - **Modulo**
     - MOD_Alerts
   * - **Funcion RBAC**
     - ALR-001: configura_umbrales
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-ALR-001

2. Descripcion
--------------

Este caso de uso permite configurar los umbrales que disparan alertas
automaticas cuando las metricas operativas superan valores criticos.
Los umbrales se configuran por segmento (CNST-004) y los cambios
se registran en auditoria (CNST-009).

**Caracteristicas principales:**

- Definir umbrales por metrica (TMO, abandono, espera, etc.)
- Configurar niveles: advertencia y critico
- Asociar umbrales a segmentos especificos
- Activar/desactivar umbrales individualmente
- Registro de cambios en auditoria

**Metricas Configurables:**

- TMO (Tiempo Medio de Operacion)
- Tasa de Abandono
- Tiempo de Espera
- Nivel de Servicio
- Ocupacion de Agentes

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ALR_01

   @startuml
   left to right direction
   actor "AGR-005\nagr_gestor_alertas" as USER

   rectangle "MOD_Alerts" {
     usecase "UC_ALR_01\nConfigurar Umbrales" as UC01
     usecase "Definir Valor\nAdvertencia" as WARN
     usecase "Definir Valor\nCritico" as CRIT
     usecase "Asignar a\nSegmento" as SEG
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC01
   UC01 --> WARN : include
   UC01 --> CRIT : include
   UC01 --> SEG : include
   UC01 --> AUD : include
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
     - El usuario tiene sesion activa con funcion ALR-001
   * - PRE-02
     - Existen metricas definidas en el sistema
   * - PRE-03
     - El usuario tiene acceso al segmento destino

4.2 Trigger
^^^^^^^^^^^

El gestor de alertas accede a la configuracion de umbrales.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - El umbral queda configurado y activo
   * - POST-02
     - Se registra THRESHOLD_CONFIG en auditoria (CNST-009)
   * - POST-03
     - El motor de alertas usa los nuevos valores

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Gestor
     - Accede a configuracion de umbrales
   * - 2
     - Sistema
     - Valida funcion ALR-001
   * - 3
     - Sistema
     - Muestra umbrales existentes del segmento
   * - 4
     - Gestor
     - Selecciona metrica a configurar
   * - 5
     - Sistema
     - Muestra formulario de configuracion
   * - 6
     - Gestor
     - Define valor de advertencia (warning)
   * - 7
     - Gestor
     - Define valor critico (critical)
   * - 8
     - Gestor
     - Selecciona segmento destino
   * - 9
     - Gestor
     - Guarda configuracion
   * - 10
     - Sistema
     - Valida que critico > advertencia
   * - 11
     - Sistema
     - Guarda umbral en base de datos
   * - 12
     - Sistema
     - Registra THRESHOLD_CONFIG en auditoria
   * - 13
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ALR_01

   @startuml
   actor "AGR-005 Gestor" as G
   participant "Frontend" as FE
   participant "AlertController" as AC
   participant "ThresholdService" as TS
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   G -> FE: Accede a Umbrales
   FE -> AC: GET /api/alerts/thresholds
   AC -> AC: verify_function(ALR-001)
   AC -> TS: get_thresholds(segmento)
   TS -> DB: SELECT * FROM alert_thresholds\nWHERE segmento_id = ?
   DB --> TS: thresholds
   TS --> AC: thresholds
   AC --> FE: 200 OK
   FE --> G: Lista de umbrales

   G -> FE: Configura umbral
   G -> FE: metrica, warning, critical, segmento
   FE -> AC: POST /api/alerts/thresholds
   AC -> TS: configure_threshold(data)

   TS -> TS: validate_values()
   note right: critical > warning

   alt valores invalidos
     TS --> AC: ValidationError
     AC --> FE: 400 Bad Request
   end

   TS -> DB: INSERT/UPDATE alert_thresholds\nSET warning_value = ?,\ncritical_value = ?,\nsegmento_id = ?

   TS -> UAL: record(THRESHOLD_CONFIG)
   note right of UAL
     CNST-009: Registra
     metrica, valores old/new
     usuario, timestamp
   end note
   UAL -> DB: INSERT user_action_log

   TS --> AC: threshold_saved
   AC --> FE: 200 OK
   FE --> G: Confirmacion
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Modificar Umbral Existente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Gestor
     - Selecciona umbral existente de la lista
   * - 5a
     - Sistema
     - Carga valores actuales en formulario
   * - 11a
     - Sistema
     - Actualiza registro existente (UPDATE)

7.2 FA-02: Desactivar Umbral
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Gestor
     - Selecciona umbral y marca como inactivo
   * - 11a
     - Sistema
     - Actualiza estado a INACTIVE
   * - 12a
     - Sistema
     - Registra THRESHOLD_DISABLED en auditoria

7.3 FA-03: Copiar Umbral a Otro Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Gestor
     - Selecciona umbral y opcion Copiar
   * - 8a
     - Gestor
     - Selecciona segmento destino diferente
   * - 11a
     - Sistema
     - Crea nuevo umbral en segmento destino

8. Excepciones
--------------

8.1 EX-01: Valores Invalidos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Valor critico menor o igual a valor de advertencia
   * - **Accion Sistema**
     - Rechaza configuracion con mensaje de error
   * - **Mensaje Usuario**
     - El valor critico debe ser mayor que el valor de advertencia
   * - **Codigo Error**
     - ALR-001

8.2 EX-02: Sin Permiso ALR-001
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion ALR-001 asignada
   * - **Accion Sistema**
     - Rechaza acceso al modulo
   * - **Mensaje Usuario**
     - No tiene permisos para configurar umbrales de alertas
   * - **Codigo Error**
     - ALR-002

8.3 EX-03: Umbral Duplicado
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 11
   * - **Condicion**
     - Ya existe umbral activo para metrica y segmento
   * - **Accion Sistema**
     - Rechaza creacion
   * - **Mensaje Usuario**
     - Ya existe un umbral para esta metrica en el segmento
   * - **Codigo Error**
     - ALR-003

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ALR_01

   @startuml
   start
   :Gestor accede a Configuracion de Umbrales;

   if (Tiene funcion ALR-001?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar umbrales existentes del segmento;

   :Seleccionar metrica;

   :Definir valor de advertencia;

   :Definir valor critico;

   if (Critico > Advertencia?) then (no)
     :Mostrar error de validacion;
     stop
   else (si)
   endif

   :Seleccionar segmento destino;
   note right: CNST-004

   if (Existe umbral para metrica/segmento?) then (si)
     :Actualizar umbral existente;
   else (no)
     :Crear nuevo umbral;
   endif

   :Registrar en auditoria;
   note right: CNST-009

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
   * - BR-ALR-01
     - Jerarquia de Valores
     - El valor critico siempre debe ser mayor que el valor de advertencia
   * - BR-ALR-02
     - Umbral por Segmento
     - Cada segmento puede tener umbrales diferentes para la misma metrica
   * - BR-ALR-03
     - Unicidad
     - Solo puede existir un umbral activo por metrica por segmento
   * - BR-ALR-04
     - Valores Positivos
     - Los valores de umbral deben ser numeros positivos

**Metricas y Unidades:**

.. list-table::
   :widths: 25 25 50
   :header-rows: 1

   * - Metrica
     - Unidad
     - Descripcion
   * - TMO
     - Segundos
     - Tiempo Medio de Operacion por llamada
   * - ABANDONO
     - Porcentaje
     - Tasa de llamadas abandonadas (0-100)
   * - ESPERA
     - Segundos
     - Tiempo promedio de espera en cola
   * - NIVEL_SERVICIO
     - Porcentaje
     - Llamadas atendidas en tiempo objetivo
   * - OCUPACION
     - Porcentaje
     - Tiempo de agentes en llamada vs disponible

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-004
     - Segmentos de Datos
     - Umbrales se configuran por segmento. El gestor solo puede configurar umbrales para segmentos a los que tiene acceso.
   * - CNST-009
     - Auditoria Inmutable
     - Todo cambio de umbral se registra en UserActionLog con valores anteriores y nuevos.

**Estructura de Auditoria (CNST-009):**

.. code-block:: python

   UserActionLog.record(
       user=current_user,
       action='THRESHOLD_CONFIG',
       resource='alert_thresholds',
       result='SUCCESS',
       details={
           'metrica': metrica_id,
           'segmento': segmento_id,
           'old_warning': valor_anterior_warning,
           'new_warning': valor_nuevo_warning,
           'old_critical': valor_anterior_critical,
           'new_critical': valor_nuevo_critical,
           'operation': 'CREATE' | 'UPDATE' | 'DISABLE'
       }
   )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ALR-001
     - El sistema debe permitir configurar umbrales por metrica
     - Formulario funcional con validacion de valores
   * - FR-ALR-002
     - El sistema debe validar jerarquia de valores
     - Rechazo automatico si critico <= advertencia
   * - FR-ALR-003
     - El sistema debe auditar todos los cambios
     - Registro con valores anteriores y nuevos en auditoria
   * - FR-ALR-004
     - El sistema debe aplicar umbrales por segmento
     - Motor de alertas usa umbrales del segmento correspondiente

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ALR-001: Configurar umbrales de alertas por metrica
   * - **Reglas de Negocio**
     - BR-ALR-01 a BR-ALR-04
   * - **Restricciones**
     - CNST-004 (Segmentos), CNST-009 (Auditoria)
   * - **UC Relacionados**
     - UC_ALR_02 (Ver Alertas), UC_ALR_03 (Reconocer)
   * - **Actor Principal**
     - AGR-005: agr_gestor_alertas
   * - **Funcion RBAC**
     - ALR-001: configura_umbrales

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
     - Version inicial v4.0 con CNST-004 y CNST-009