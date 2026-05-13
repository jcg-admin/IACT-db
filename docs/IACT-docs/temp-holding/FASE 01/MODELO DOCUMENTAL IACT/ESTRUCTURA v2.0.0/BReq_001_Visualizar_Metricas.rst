.. meta::
   :artefacto: BReq_001
   :tipo: Requisito de Negocio
   :dominio: requisitos
   :subdominio: requisitos_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _breq-001:

==============================================================================
BReq_001: Visualizar Metricas del Dashboard
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Identificacion
--------------

.. list-table::
   :widths: 25 75
   :stub-columns: 1

   * - ID
     - BReq_001
   * - Nombre
     - Visualizar Metricas del Dashboard
   * - Categoria
     - Funcional
   * - Prioridad
     - **Alta**
   * - Stakeholder
     - Usuarios del Call Center (Supervisores, Analistas)
   * - Deriva de
     - BR_001 (Inmutabilidad Fuente), BR_002 (ETL Programado)

----

1. Declaracion del Requisito
----------------------------

1.1 Enunciado
^^^^^^^^^^^^^

.. admonition:: BReq_001 - Requisito de Negocio
   :class: important

   **"El negocio NECESITA que los usuarios autorizados puedan visualizar 
   metricas de rendimiento del call center a traves de dashboards interactivos,
   mostrando datos historicos actualizados periodicamente segun el ciclo ETL."**

1.2 Contexto de Negocio
^^^^^^^^^^^^^^^^^^^^^^^

El call center genera miles de llamadas diarias. Los supervisores y analistas
necesitan una forma rapida de entender el rendimiento operativo sin acceder
directamente a los sistemas legacy. El dashboard proporciona esta visibilidad.

1.3 Problema que Resuelve
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   SITUACION ACTUAL (sin IACT):
   
   - Supervisores solicitan reportes manuales a TI
   - Tiempo de espera: 24-48 horas para obtener datos
   - No hay vision consolidada de metricas
   - Decisiones basadas en informacion desactualizada
   
   SITUACION DESEADA (con IACT):
   
   - Supervisores acceden al dashboard autonomamente
   - Datos disponibles en segundos
   - Vision consolidada en una sola pantalla
   - Decisiones basadas en datos actualizados (max 6 horas)

----

2. Restricciones Aplicables
---------------------------

Este requisito opera bajo las siguientes restricciones derivadas de BR_:

2.1 De BR_001 (Inmutabilidad)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Los datos mostrados son de SOLO LECTURA
   
   - El dashboard NO modifica datos fuente
   - Las metricas se calculan a partir de datos inmutables
   - No existe opcion de "corregir" datos desde la UI
   
   IMPLICACION PARA UI:
   - No hay botones de edicion de datos
   - Los valores son informativos, no editables

2.2 De BR_002 (ETL Programado)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Los datos tienen latencia de 6-12 horas
   
   - Dashboard muestra datos del ultimo ETL
   - No hay actualizacion en tiempo real
   - Timestamp de ultima actualizacion siempre visible
   
   IMPLICACION PARA UI:
   - Mostrar "Datos actualizados: DD/MM/YYYY HH:MM"
   - No hay boton de "actualizar ahora" para usuarios normales
   - Expectativa clara de frescura de datos

2.3 De BR_003 (RBAC)
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Acceso controlado por roles
   
   - Solo usuarios con R008 o R009 pueden ver dashboard
   - Usuarios sin rol apropiado reciben error 403
   
   IMPLICACION PARA UI:
   - Menu de dashboard solo visible para roles autorizados
   - Mensaje claro si acceso denegado

----

3. Criterios de Exito
---------------------

3.1 Criterios Medibles
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Criterio
     - Meta
     - Medicion
   * - Tiempo de carga del dashboard
     - < 3 segundos
     - Performance testing
   * - Disponibilidad del dashboard
     - 99.5%
     - Monitoreo de uptime
   * - Usuarios que acceden al dashboard
     - > 80% de usuarios activos
     - Analytics de uso
   * - Satisfaccion de usuarios
     - > 4.0/5.0
     - Encuesta trimestral

3.2 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: gherkin

   Escenario: Usuario visualiza dashboard principal
     Dado que el usuario tiene rol R008 (DASHBOARD_VIEWER)
     Y el usuario esta autenticado
     Cuando el usuario accede a /dashboard/
     Entonces el sistema DEBE mostrar el dashboard principal
     Y el dashboard DEBE cargar en menos de 3 segundos
     Y el dashboard DEBE mostrar el timestamp de ultima actualizacion

   Escenario: Dashboard muestra metricas correctas
     Dado que el ETL se ejecuto a las 08:00
     Y el usuario accede al dashboard a las 10:00
     Cuando el dashboard carga
     Entonces las metricas DEBEN reflejar datos hasta las 08:00
     Y el timestamp DEBE mostrar "08:00"

   Escenario: Usuario sin rol no puede acceder
     Dado que el usuario NO tiene rol R008 ni R009
     Cuando el usuario intenta acceder a /dashboard/
     Entonces el sistema DEBE denegar acceso
     Y el sistema DEBE mostrar mensaje de permiso denegado

----

4. Metricas a Visualizar
------------------------

4.1 Metricas Principales
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 40 30

   * - Metrica
     - Descripcion
     - Fuente
   * - Total de Llamadas
     - Cantidad de llamadas en periodo
     - call_metrics.total_calls
   * - Llamadas Completadas
     - Llamadas atendidas exitosamente
     - call_metrics.completed_calls
   * - Llamadas Abandonadas
     - Llamadas que colgaron antes de ser atendidas
     - call_metrics.abandoned_calls
   * - Tasa de Abandono
     - Porcentaje de llamadas abandonadas
     - Calculado: abandoned/total * 100
   * - Tiempo Promedio de Espera
     - Segundos promedio en cola
     - call_metrics.avg_wait_time
   * - Duracion Promedio
     - Segundos promedio de llamada
     - call_metrics.avg_duration

4.2 Visualizaciones Requeridas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   WIDGETS DEL DASHBOARD:
   
   1. KPIs Principales (tarjetas)
      ├── Total llamadas hoy
      ├── Tasa de abandono
      ├── Tiempo promedio espera
      └── Duracion promedio
   
   2. Grafico de Tendencia (linea)
      └── Llamadas por hora (ultimas 24h)
   
   3. Distribucion por Centro (barras)
      └── Top 10 centros por volumen
   
   4. Distribucion por Cola (pie)
      └── Porcentaje por tipo de cola
   
   5. Tabla de Detalle
      └── Metricas por centro/cola con paginacion

----

5. Trazabilidad
---------------

5.1 Hacia Arriba (Origen)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq_001
     │
     ├──▶ BR_001: Inmutabilidad de Fuente (datos solo lectura)
     ├──▶ BR_002: ETL Programado (datos cada 6h)
     └──▶ BR_003: RBAC Flat (acceso por roles R008, R009)

5.2 Hacia Abajo (Deriva)
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq_001
     │
     └──▶ UC_001: Consultar Dashboard
           │
           ├──▶ FR_001: Cargar Dashboard
           └──▶ FR_002: Filtrar Metricas

5.3 Matriz de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 25 25

   * - BR
     - BReq
     - UC
     - FR
     - TST
   * - BR_001, BR_002
     - **BReq_001**
     - UC_001
     - FR_001, FR_002
     - TST_UC_001

----

6. Historial de Cambios
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Creacion inicial

----

Referencias
-----------

- :ref:`br-001` - Inmutabilidad de Fuente Operacional
- :ref:`br-002` - Actualizacion mediante ETL Programado
- :ref:`br-003` - Control de Acceso RBAC Flat
- :ref:`uc-001` - Consultar Dashboard (pendiente)
