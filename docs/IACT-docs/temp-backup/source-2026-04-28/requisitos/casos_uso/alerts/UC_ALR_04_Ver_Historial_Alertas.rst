.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Alerts
   :uc_id: UC_ALR_04
   :normativa: CNST-003, CNST-004, CNST-006

================================
UC_ALR_04: Ver Historial Alertas
================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ALR_04
   * - **Nombre**
     - Ver Historial Alertas
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Alerts
   * - **Funcion RBAC**
     - ALR-004: ve_historial_alertas
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-ALR-004

2. Descripcion
--------------

Este caso de uso permite consultar el historial de alertas pasadas,
incluyendo alertas resueltas y reconocidas. Util para analisis de
tendencias y patrones de problemas operativos.

**Caracteristicas principales:**

- Consultar alertas historicas por rango de fechas
- Maximo 2 anios de historial (CNST-006)
- Filtrar por estado, severidad, metrica
- Filtrado automatico por segmento (CNST-004)
- Ver detalle completo de cada alerta
- Exportar historial para analisis

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ALR_04

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER

   rectangle "MOD_Alerts" {
     usecase "UC_ALR_04\nVer Historial" as UC04
     usecase "Filtrar\nAlertas" as FILT
     usecase "Ver Detalle" as DET
     usecase "Exportar\nHistorial" as EXP
   }

   USER --> UC04
   UC04 --> FILT : include
   UC04 --> DET : extend
   UC04 --> EXP : extend
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
     - El usuario tiene sesion activa con funcion ALR-004
   * - PRE-02
     - Existen alertas historicas en el sistema
   * - PRE-03
     - El rango de fechas no excede 2 anios

4.2 Trigger
^^^^^^^^^^^

El supervisor accede a la seccion de historial de alertas.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra historial de alertas filtrado por segmento
   * - POST-02
     - La consulta no modifica ningun dato (solo lectura)

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Supervisor
     - Accede a historial de alertas
   * - 2
     - Sistema
     - Valida funcion ALR-004
   * - 3
     - Sistema
     - Muestra alertas de ultimos 30 dias por defecto
   * - 4
     - Supervisor
     - Opcionalmente aplica filtros adicionales
   * - 5
     - Sistema
     - Valida rango no excede 2 anios (CNST-006)
   * - 6
     - Sistema
     - Consulta alertas con filtro de segmento automatico
   * - 7
     - Sistema
     - Presenta lista paginada ordenada por fecha
   * - 8
     - Supervisor
     - Opcionalmente selecciona alerta para ver detalle

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ALR_04

   @startuml
   actor "AGR-003 Supervisor" as S
   participant "Frontend" as FE
   participant "AlertController" as AC
   participant "AlertHistoryService" as AHS
   database "Analytics" as DB

   S -> FE: Accede a Historial de Alertas
   FE -> AC: GET /api/alerts/history?days=30
   AC -> AC: verify_function(ALR-004)
   AC -> AC: get_user_segment()

   AC -> AHS: get_history(filters, segmento)
   AHS -> DB: SELECT * FROM alerts\nWHERE segmento_id = ?\nAND created_at >= NOW() - INTERVAL '30 days'\nORDER BY created_at DESC
   note right of DB: CNST-003 BD Analytics
   DB --> AHS: alerts
   AHS --> AC: paginated_alerts
   AC --> FE: 200 OK
   FE --> S: Lista de alertas historicas

   S -> FE: Aplica filtros (fecha, estado, severidad)
   FE -> AC: GET /api/alerts/history?start=X&end=Y&status=Z

   AC -> AHS: validate_date_range(start, end)
   note right: CNST-006 max 2 anios

   alt rango > 2 anios
     AHS --> AC: DateRangeExceededError
     AC --> FE: 400 Bad Request
     FE --> S: Error: Rango maximo 2 anios
   end

   AHS -> DB: SELECT con filtros y segmento
   DB --> AHS: filtered_alerts
   AHS --> AC: alerts
   AC --> FE: 200 OK
   FE --> S: Lista filtrada

   S -> FE: Click en alerta
   FE -> AC: GET /api/alerts/{id}
   AC -> AHS: get_alert_detail(id)
   AHS -> DB: SELECT con historial de estados
   DB --> AHS: alert_detail
   AHS --> AC: detail
   AC --> FE: 200 OK
   FE --> S: Detalle completo de alerta
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Exportar Historial
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Supervisor
     - Hace clic en Exportar
   * - 8b
     - Sistema
     - Genera CSV con alertas filtradas
   * - 8c
     - Sistema
     - Registra exportacion en auditoria
   * - 8d
     - Sistema
     - Descarga archivo

7.2 FA-02: Filtrar por Metrica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Supervisor
     - Selecciona metrica especifica (TMO, abandono, etc.)
   * - 6a
     - Sistema
     - Filtra solo alertas de esa metrica

7.3 FA-03: Ver Tendencia de Alertas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Supervisor
     - Hace clic en Ver Tendencia
   * - 8b
     - Sistema
     - Muestra grafico de alertas por periodo

8. Excepciones
--------------

8.1 EX-01: Rango Excede 2 Anios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Rango de fechas seleccionado mayor a 730 dias
   * - **Accion Sistema**
     - Rechaza consulta
   * - **Mensaje Usuario**
     - Rango maximo de consulta es 2 anios. Ajuste las fechas.
   * - **Codigo Error**
     - ALR-030

8.2 EX-02: Sin Alertas en Periodo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - No hay alertas para el rango y filtros
   * - **Accion Sistema**
     - Muestra lista vacia
   * - **Mensaje Usuario**
     - No se encontraron alertas para el periodo seleccionado

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ALR_04

   @startuml
   start
   :Supervisor accede a Historial de Alertas;

   if (Tiene funcion ALR-004?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar alertas ultimos 30 dias;

   if (Aplica filtros adicionales?) then (si)
     :Validar rango de fechas;
     if (Rango > 2 anios?) then (si)
       :Mostrar error rango excedido;
       note right: CNST-006
       stop
     else (no)
     endif
   endif

   :Consultar alertas con filtro de segmento;
   note right: CNST-004

   :Mostrar lista paginada;

   if (Ver detalle?) then (si)
     :Mostrar detalle de alerta;
   endif

   if (Exportar?) then (si)
     :Generar y descargar CSV;
     :Registrar en auditoria;
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
   * - BR-ALR-30
     - Retencion 2 Anios
     - Solo se pueden consultar alertas de los ultimos 2 anios (CNST-006)
   * - BR-ALR-31
     - Filtro Segmento
     - Solo alertas del segmento del usuario visibles (CNST-004)
   * - BR-ALR-32
     - Paginacion
     - Maximo 100 alertas por pagina
   * - BR-ALR-33
     - Solo Lectura
     - El historial es de solo lectura, no se puede modificar

**Filtros Disponibles:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Filtro
     - Descripcion
   * - Fecha Inicio
     - Fecha minima de creacion de alerta
   * - Fecha Fin
     - Fecha maxima de creacion de alerta
   * - Estado
     - ACTIVE, ACKNOWLEDGED, RESOLVED
   * - Severidad
     - CRITICAL, WARNING, INFO
   * - Metrica
     - TMO, ABANDONO, ESPERA, etc.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-003
     - BD Dual
     - Datos historicos de BD Analytics
   * - CNST-004
     - Segmentos
     - Filtro automatico por segmento del usuario
   * - CNST-006
     - Retencion
     - Maximo 2 anios de historial consultable

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ALR-030
     - El sistema debe mostrar historial de alertas
     - Lista paginada con filtros
   * - FR-ALR-031
     - El sistema debe validar rango maximo 2 anios
     - Rechazo si excede limite
   * - FR-ALR-032
     - El sistema debe permitir filtros multiples
     - Filtros por fecha, estado, severidad, metrica
   * - FR-ALR-033
     - El sistema debe permitir exportar
     - CSV descargable con alertas filtradas

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ALR-004: Consultar historial de alertas
   * - **Reglas de Negocio**
     - BR-ALR-30 a BR-ALR-33
   * - **Restricciones**
     - CNST-003, CNST-004, CNST-006
   * - **UC Relacionados**
     - UC_ALR_02 (Ver Activas), UC_ALR_03 (Reconocer)
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - ALR-004: ve_historial_alertas

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
     - Version inicial v4.0 con CNST-006