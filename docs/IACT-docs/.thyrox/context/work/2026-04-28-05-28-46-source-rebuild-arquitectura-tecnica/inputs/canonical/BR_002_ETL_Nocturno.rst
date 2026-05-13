.. meta::
   :artefacto: BR_002
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-002:

==============================================================================
BR_002: Actualizacion de Datos mediante ETL Nocturno
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_002
   * - **Nombre**
     - Actualizacion de Datos mediante ETL Nocturno
   * - **Tipo**
     - Restriccion
   * - **Categoria**
     - Operacional / Sincronizacion
   * - **Criticidad**
     - Critica
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_002**

   Los datos del dashboard IACT NO se actualizan en tiempo real. 
   La sincronizacion con la base IVR se realiza EXCLUSIVAMENTE mediante
   proceso ETL batch programado, ejecutado en ventana nocturna
   (00:00 - 06:00 horas).

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - sincronizacion_tiempo_real: WebSockets, SSE, polling < 1 hora
     - proceso_etl: Extraccion, Transformacion, Carga batch programada
     - ventana_nocturna: Periodo 00:00 a 06:00 horas
     - datos_dashboard: Metricas y analiticos mostrados en UI

   REGLA:
     Es OBLIGATORIO que datos_dashboard se actualicen UNICAMENTE mediante
     proceso_etl ejecutado en ventana_nocturna.
     
     Es PROHIBIDO implementar sincronizacion_tiempo_real para datos IVR
     bajo cualquier circunstancia.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

El proceso ETL nocturno es obligatorio por razones operacionales:

- Minimizar carga en base IVR legacy durante horario laboral
- Evitar impacto en operacion del call center (alta disponibilidad)
- Control de ventanas de mantenimiento predictibles
- Los datos analiticos no requieren tiempo real (historicos)
- Optimizar uso de recursos de red y base de datos

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Restriccion**
   * - 
     - [X] **Restriccion**: Limita mecanismos de actualizacion permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - restriccion permanente del proyecto
- **Automatizable**: Si - ETL programado via cron/celery
- **Alcance**: Sistema completo - toda sincronizacion de datos

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_004_Actualizacion_Datos_ETL.rst
   * - **Seccion**
     - Mecanismo Obligatorio - ETL Programado
   * - **Version**
     - 1.0.0
   * - **Fecha**
     - 2025-12-17
   * - **Tipo Fuente**
     - CNST (Restriccion Tecnica del Cliente)

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Cliente + Equipo Operaciones
- **Proceso de Cambio**: Requiere autorizacion del cliente
- **Frecuencia de Revision**: Anual o cuando condiciones operativas cambien

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripcion de Aplicacion
   * - Proceso ETL
     - Unica forma de sincronizar datos IVR a Analytics
   * - Scheduler (Celery)
     - Programa ejecucion en ventana 00:00-06:00
   * - Dashboard UI
     - Muestra datos sincronizados, no tiempo real
   * - APIs de Metricas
     - Consultan copia local, nunca IVR directo

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los usuarios ven datos con latencia de hasta 24 horas
- **Sistemas Externos**: ETL Scheduler, Base Analytics

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones definidas. La sincronizacion batch es el unico mecanismo
permitido.

----

5. Prohibiciones Explicitas
---------------------------

5.1 Mecanismos Prohibidos
^^^^^^^^^^^^^^^^^^^^^^^^^

Los siguientes mecanismos de tiempo real estan PROHIBIDOS:

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Tecnologia
     - Razon de Prohibicion
   * - WebSockets
     - Streaming de datos en vivo no permitido
   * - Server-Sent Events (SSE)
     - Push de actualizaciones prohibido
   * - Long Polling
     - Consultas frecuentes impactan base legacy
   * - Database Triggers
     - Sincronizacion reactiva no permitida
   * - Change Data Capture
     - CDC en tiempo real prohibido
   * - Message Queues (Kafka/RabbitMQ)
     - Streaming de eventos no permitido

5.2 Librerias Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO instalar o usar:
   # - django-channels (WebSockets)
   # - python-socketio
   # - kafka-python (para streaming)
   # - pika / RabbitMQ (para eventos real-time)

----

6. Trazabilidad
---------------

6.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relacion
   * - CNST_004
     - Define mecanismo ETL y prohibe tiempo real - origen directo de BR_002

6.2 Requisitos de Negocio Derivados (BReq)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq_001
     - Visualizar Metricas (datos con latencia de sincronizacion)
   * - BReq_002
     - Exportar Datos (exporta datos sincronizados)

6.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC_001
     - Postcondicion: Dashboard muestra fecha/hora de ultima sincronizacion
   * - UC_002
     - Precondicion: Reporte generado con datos de ultima sincronizacion

----

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Proceso ETL configurado en Celery Beat para ventana 00:00-06:00
2. No existen WebSockets ni streaming en el codigo
3. Dashboard muestra timestamp de ultima sincronizacion
4. Tests verifican ausencia de librerias prohibidas
5. APIs no consultan directamente base IVR en runtime

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado + Manual
- **Frecuencia**: Continua (cada commit) + Code Review
- **Responsable**: CI/CD Pipeline + Reviewer

7.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Rechazo inmediato en code review
- Degradacion potencial de base IVR del cliente
- Incidente de disponibilidad categoria Critica
- Re-trabajo completo del modulo afectado

----

8. Implementacion Tecnica
-------------------------

8.1 Configuracion ETL
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/config/celery.py
   
   from celery.schedules import crontab
   
   CELERY_BEAT_SCHEDULE = {
       'etl-sync-ivr-metrics': {
           'task': 'apps.etl.tasks.sync_ivr_metrics',
           'schedule': crontab(hour='2', minute='0'),  # 02:00 AM
           'options': {
               'expires': 3600 * 4,  # Expira en 4 horas (antes de 06:00)
           },
       },
       'etl-sync-ivr-calls': {
           'task': 'apps.etl.tasks.sync_ivr_calls',
           'schedule': crontab(hour='3', minute='0'),  # 03:00 AM
           'options': {
               'expires': 3600 * 3,
           },
       },
   }

8.2 Indicador de Sincronizacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/dashboard/views.py
   
   class DashboardView(APIView):
       """
       BR_002: Dashboard muestra fecha/hora de ultima sincronizacion.
       """
       
       def get(self, request):
           last_sync = SyncMetadata.objects.latest('completed_at')
           
           return Response({
               'data': self.get_dashboard_data(),
               'sync_info': {
                   'last_sync': last_sync.completed_at.isoformat(),
                   'next_sync': '02:00 AM (ventana nocturna)',
                   'data_freshness': 'Hasta 24 horas de latencia',
               }
           })

----

9. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Version inicial derivada de CNST_004

----

Referencias
-----------

- CNST_004: Actualizacion de Datos mediante ETL
- BR_001: Inmutabilidad de Fuente Operacional (complementaria)
- FND_02: Reglas de Negocio
- FND_05: Jerarquia de 4 Niveles

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
