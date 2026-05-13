.. meta::
   :artefacto: BR_017
   :tipo: Business Rule
   :subtipo: Calculo
   :modalidad: Aletica
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-017:

==============================================================================
BR_017: Tiempo Promedio de Espera
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   El Tiempo Promedio de Espera (Average Wait Time - AWT) se calcula
   como la suma de todos los tiempos de espera dividido por el numero
   de llamadas que esperaron en cola.

**Formula:**

.. code-block:: text

   Tiempo_Promedio_Espera = SUM(tiempo_espera) / COUNT(llamadas_con_espera)

**Enunciado SBVR:**

   Average wait time equals the sum of wait times divided by
   the count of calls that waited in queue.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Calculo (Calculation)
   * - **Modalidad**
     - Aletica (verdad matematica)
   * - **Estatica/Dinamica**
     - Estatica (formula fija)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Metricas de Call Center - Estandar de Industria
   * - **Documento**
     - Especificacion Funcional IACT - Metricas
   * - **Fecha Vigencia**
     - 2025-01-01

----

Implementacion
--------------

SQL
^^^

.. code-block:: sql

   -- BR_017: Tiempo Promedio de Espera
   SELECT
       ROUND(AVG(wait_time_seconds)::DECIMAL, 2) as tiempo_promedio
   FROM calls
   WHERE call_date BETWEEN :fecha_inicio AND :fecha_fin
     AND wait_time_seconds > 0
     AND segment_id = :segment_id;

Python
^^^^^^

.. code-block:: python

   def calculate_average_wait_time(self, start_date, end_date, segment_id=None):
       """BR_017: Calcula tiempo promedio de espera"""
       qs = Call.objects.filter(
           call_date__range=(start_date, end_date),
           wait_time_seconds__gt=0
       )
       if segment_id:
           qs = qs.filter(segment_id=segment_id)

       promedio = qs.aggregate(avg=Avg('wait_time_seconds'))['avg'] or 0
       return round(promedio, 2)

----

Casos de Uso Relacionados
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Uso de BR_017
   * - UC_017
     - Reporte Trimestral
     - Incluye tiempo promedio
   * - UC_025
     - Dashboard Principal
     - Muestra AWT actual
   * - UC_036
     - Crear Alerta
     - Umbral de tiempo espera

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-MET.05
     - Sistema DEBE calcular tiempo promedio de espera segun formula BR_017
   * - FR-MET.06
     - Sistema DEBE excluir llamadas con tiempo_espera = 0
   * - FR-MET.07
     - Sistema DEBE mostrar tiempo en formato mm:ss

----

Referencias
-----------

- :ref:`br-016` - BR_016 Tasa de Abandono
- :ref:`br-018` - BR_018 Indice de Eficiencia

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-03
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:**

- Tipo: Calculo
- Usado en: UC_017, UC_025, UC_036
- Deriva: FR-MET.05 a FR-MET.07
