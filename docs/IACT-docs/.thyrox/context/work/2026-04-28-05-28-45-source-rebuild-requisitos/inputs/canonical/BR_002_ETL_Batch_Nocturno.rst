.. meta::
   :artefacto: BR_002
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-002:

==========================
BR_002: ETL Batch Nocturno
==========================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_002
   * - **Nombre**
     - ETL Batch Nocturno
   * - **Tipo**
     - Desencadenador
   * - **Categoria**
     - Operacional
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

SI el reloj del sistema marca las 00:00 horas (medianoche),
ENTONCES el sistema DEBE iniciar el proceso ETL de sincronizacion
de datos desde la base IVR hacia la base Analytics.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - ETL: Proceso Extract-Transform-Load
     - Medianoche: 00:00:00 hora local del servidor
     - Base IVR: Origen de datos operacionales
     - Base Analytics: Destino de datos procesados

   REGLA:
     Es obligatorio que el proceso ETL se ejecute diariamente a medianoche.
     Es obligatorio que ETL extraiga datos del dia anterior completo.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

La sincronizacion nocturna minimiza impacto en sistemas productivos,
garantiza datos completos del dia anterior, y permite ventana de
mantenimiento predecible. El horario nocturno evita competencia
por recursos con operaciones diurnas del call center.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Desencadenador**: Genera comportamiento observable (SI...ENTONCES)

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - horario fijo
- **Automatizable**: Si - mediante cron/scheduler
- **Alcance**: MOD_Pipeline

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_004_Actualizacion_Datos_ETL
   * - **Seccion**
     - Proceso ETL
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: admin_sistema (AGR-009)
- **Proceso de Cambio**: Solicitud de cambio con justificacion operacional
- **Frecuencia de Revision**: Anual

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
   * - MOD_Pipeline
     - Ejecuta jobs ETL programados
   * - Celery Beat
     - Scheduler que dispara proceso a medianoche
   * - Base Analytics
     - Recibe datos sincronizados

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: AGR-009 (admin_sistema), AGR-010 (operador_etl)
- **Sistemas Externos**: Sistema IVR, Scheduler del sistema

4.3 Excepciones
^^^^^^^^^^^^^^^

- Ejecucion manual permitida por AGR-009 en casos de emergencia
- Re-ejecucion por fallo permitida durante ventana nocturna

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relacion
   * - CNST_004
     - Define proceso ETL y restricciones de actualizacion

5.2 BReq Influenciados
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq-001
     - Visibilidad de Metricas IVR (datos actualizados diariamente)

5.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC-050
     - Supervisar Estado ETL - trigger nocturno
   * - UC-051
     - Consultar Errores ETL - post ejecucion
   * - UC-052
     - Consultar Disponibilidad Datos - actualizada tras ETL

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Job ETL inicia entre 00:00:00 y 00:01:00
2. Datos del dia anterior disponibles antes de 06:00
3. Log de ejecucion registra inicio y fin

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Diaria (post-ejecucion)
- **Responsable**: Sistema de monitoreo

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Alerta a AGR-009 y AGR-010
- Registro en log de errores ETL
- Datos del dia anterior no disponibles hasta re-ejecucion

----

7. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-04
     - Equipo IACT
     - Version inicial