.. meta::
   :artefacto: BR_019
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-019:

=================================
BR_019: Retención de Datos 2 Años
=================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_019
   * - **Nombre**
     - Retención de Datos 2 Años
   * - **Tipo**
     - Restricción
   * - **Categoría**
     - Cumplimiento / Gestión de Datos
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_019**

   El sistema IACT DEBE retener datos operacionales y de auditoría por un
   período máximo de 2 años (730 días). Datos que superen este período
   DEBEN ser archivados o eliminados según la política de retención.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - datos_operacionales: Registros de llamadas, métricas, reportes
     - datos_auditoria: Logs de acciones de usuarios
     - periodo_retencion: 2 años (730 días)
     - fecha_corte: Fecha actual menos periodo_retencion

   REGLA:
     Es OBLIGATORIO que datos con fecha ANTERIOR a fecha_corte sean
     procesados según política de retención.
     
     Datos operacionales PUEDEN ser eliminados tras archivado.
     
     Datos de auditoría DEBEN ser archivados antes de eliminar
     (cumplimiento normativo).

1.3 Justificación
^^^^^^^^^^^^^^^^^

La política de retención de 2 años:

- **Cumplimiento legal**: Requisito de conservación de registros
- **Performance**: Evita crecimiento infinito de base de datos
- **Costos**: Optimiza almacenamiento
- **Auditoría**: Mantiene histórico suficiente para investigaciones
- **Privacidad**: Limita exposición de datos antiguos

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Restricción**
   * - 
     - [X] **Restricción**: Limita período de retención de datos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Estática - política fija
- **Automatizable**: Sí - proceso batch de limpieza
- **Alcance**: Todas las tablas con datos históricos

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_006_Retencion_Datos.rst
   * - **Sección**
     - Política de Retención
   * - **Versión**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST (Restricción Técnica)

3.2 Autoridad de Modificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Oficial de Cumplimiento + DBA
- **Proceso de Cambio**: Requiere aprobación legal y técnica
- **Frecuencia de Revisión**: Anual

----

4. Aplicación en Sistema
------------------------

4.1 Tablas Afectadas
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 20 50
   :header-rows: 1

   * - Tabla
     - Retención
     - Acción al Vencer
   * - llamadas
     - 2 años
     - Archivar + Eliminar
   * - metricas_diarias
     - 2 años
     - Archivar + Eliminar
   * - user_action_log
     - 2 años
     - Archivar (obligatorio)
   * - reportes_generados
     - 2 años
     - Eliminar
   * - alertas_historial
     - 2 años
     - Eliminar
   * - sesiones
     - 90 días
     - Eliminar

4.2 Proceso de Archivado
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Identificar registros con fecha < (hoy - 730 días)
   2. Exportar a archivo comprimido (formato parquet/csv.gz)
   3. Almacenar en storage de archivo (S3 Glacier o similar)
   4. Verificar integridad del archivo
   5. Eliminar registros de base de datos
   6. Registrar operación en auditoría

----

5. Implementación Técnica
-------------------------

5.1 Comando de Limpieza
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/core/management/commands/cleanup_old_data.py
   
   class Command(BaseCommand):
                                                       
       Comando que implementa BR_019: Retención 2 años.
                                                       
       help = 'Limpia datos con más de 2 años de antigüedad'
       
       RETENTION_DAYS = 730  # BR_019: 2 años
       
       def handle(self, *args, **options):
           cutoff_date = timezone.now() - timedelta(days=self.RETENTION_DAYS)
           
           self.stdout.write(f"BR_019: Limpiando datos anteriores a {cutoff_date}")
           
           # Archivar antes de eliminar
           self.archive_audit_logs(cutoff_date)
           self.archive_call_data(cutoff_date)
           
           # Eliminar datos archivados
           deleted_calls = Llamada.objects.filter(
               fecha__lt=cutoff_date
           ).delete()
           
           deleted_metrics = MetricaDiaria.objects.filter(
               fecha__lt=cutoff_date
           ).delete()
           
           self.stdout.write(
               self.style.SUCCESS(
                   f"BR_019: Eliminados {deleted_calls[0]} llamadas, "
                   f"{deleted_metrics[0]} métricas"
               )
           )

5.2 Tarea Celery Programada
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/core/tasks.py
   
   @shared_task
   def cleanup_old_data_task():
                               
       BR_019: Tarea semanal de limpieza de datos antiguos.
       Ejecuta domingos a las 3:00 AM.
                                      
       call_command('cleanup_old_data')

5.3 Configuración Celery Beat
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # config/celery.py
   
   CELERY_BEAT_SCHEDULE = {
       'cleanup-old-data-weekly': {
           'task': 'apps.core.tasks.cleanup_old_data_task',
           'schedule': crontab(hour=3, minute=0, day_of_week=0),  # Domingo 3AM
       },
   }

----

6. Trazabilidad
---------------

- **Origen**: CNST_006 (Retención de Datos)
- **UC Relacionados**: UC_LOG_04 (Configurar Retención)
- **CNST**: CNST_006

----

7. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Versión inicial derivada de CNST_006

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
