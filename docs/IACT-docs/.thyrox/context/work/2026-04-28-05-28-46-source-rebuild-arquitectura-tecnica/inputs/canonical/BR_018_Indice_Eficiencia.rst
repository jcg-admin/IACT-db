.. meta::
   :artefacto: BR_018
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

.. _br-018:

==============================================================================
BR_018: Indice de Eficiencia
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   El Indice de Eficiencia es una metrica compuesta que combina
   la tasa de llamadas completadas con la tasa de no-transferencia,
   reflejando la capacidad del IVR de resolver llamadas sin
   intervencion humana adicional.

**Formula:**

.. code-block:: text

   Indice_Eficiencia = (Llamadas_Completadas / Total_Llamadas)
                       * (1 - Tasa_Transferencia)

   Donde:
   - Tasa_Transferencia = Llamadas_Transferidas / Llamadas_Atendidas

   Resultado: Valor entre 0 y 1 (o 0% a 100%)

**Enunciado SBVR:**

   Efficiency index equals completed calls ratio multiplied by
   non-transfer rate.

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
     - Metricas de Call Center - KPI Compuesto
   * - **Documento**
     - Especificacion Funcional IACT - Metricas
   * - **Fecha Vigencia**
     - 2025-01-01

----

Variables de la Formula
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 25 40 35

   * - Variable
     - Definicion
     - Fuente
   * - Llamadas_Completadas
     - Llamadas finalizadas exitosamente
     - calls.status = 'COMPLETED'
   * - Total_Llamadas
     - Todas las llamadas del periodo
     - COUNT(calls)
   * - Llamadas_Transferidas
     - Llamadas pasadas a agente humano
     - calls.transferred = TRUE
   * - Llamadas_Atendidas
     - Llamadas no abandonadas
     - calls.status != 'ABANDONED'

----

Implementacion
--------------

SQL
^^^

.. code-block:: sql

   -- BR_018: Indice de Eficiencia
   WITH metricas AS (
       SELECT
           COUNT(*) as total,
           COUNT(*) FILTER (WHERE status = 'COMPLETED') as completadas,
           COUNT(*) FILTER (WHERE status != 'ABANDONED') as atendidas,
           COUNT(*) FILTER (WHERE transferred = TRUE) as transferidas
       FROM calls
       WHERE call_date BETWEEN :fecha_inicio AND :fecha_fin
         AND segment_id = :segment_id
   )
   SELECT
       completadas,
       total,
       transferidas,
       atendidas,
       ROUND(
           (completadas::DECIMAL / NULLIF(total, 0))
           * (1 - (transferidas::DECIMAL / NULLIF(atendidas, 0))),
           4
       ) as indice_eficiencia
   FROM metricas;

Python
^^^^^^

.. code-block:: python

   def calculate_efficiency_index(self, start_date, end_date, segment_id=None):
       """BR_018: Calcula indice de eficiencia"""
       qs = Call.objects.filter(call_date__range=(start_date, end_date))
       if segment_id:
           qs = qs.filter(segment_id=segment_id)

       total = qs.count()
       completadas = qs.filter(status='COMPLETED').count()
       atendidas = qs.exclude(status='ABANDONED').count()
       transferidas = qs.filter(transferred=True).count()

       if total == 0 or atendidas == 0:
           return Decimal('0.0000')

       tasa_completadas = Decimal(completadas) / Decimal(total)
       tasa_transferencia = Decimal(transferidas) / Decimal(atendidas)
       indice = tasa_completadas * (1 - tasa_transferencia)

       return indice.quantize(Decimal('0.0001'))

----

Interpretacion
--------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rango
     - Clasificacion
     - Interpretacion
   * - 0.80 - 1.00
     - Excelente
     - IVR resuelve sin transferencias
   * - 0.60 - 0.79
     - Bueno
     - Operacion eficiente
   * - 0.40 - 0.59
     - Regular
     - Oportunidad de mejora
   * - < 0.40
     - Deficiente
     - Revisar flujos IVR

----

Casos de Uso Relacionados
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Uso de BR_018
   * - UC_017
     - Reporte Trimestral
     - Incluye indice de eficiencia
   * - UC_025
     - Dashboard Principal
     - Muestra indice actual
   * - UC_031
     - Analisis Tendencias
     - Evolucion del indice

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-MET.09
     - Sistema DEBE calcular indice de eficiencia segun formula BR_018
   * - FR-MET.10
     - Sistema DEBE mostrar indice con 4 decimales o como porcentaje
   * - FR-MET.11
     - Sistema DEBE permitir comparacion entre periodos

----

Relacion con Otras BR
---------------------

El Indice de Eficiencia es una metrica DERIVADA que utiliza:

- BR_016: Tasa de Abandono (para calcular tasa completadas)
- Datos base que tambien usa BR_017

.. code-block:: text

   BR_016 (Tasa Abandono) + BR_018 (Indice Eficiencia)
   --> Complementarios para medir salud del IVR

----

Referencias
-----------

- :ref:`br-016` - BR_016 Tasa de Abandono
- :ref:`br-017` - BR_017 Tiempo Promedio Espera
- MOD_Reports - Modulo de Reportes

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

- Tipo: Calculo (metrica compuesta)
- Usado en: UC_017, UC_025, UC_031
- Deriva: FR-MET.09 a FR-MET.11
- Relacionado: BR_016, BR_017
