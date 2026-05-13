.. meta::
   :artefacto: BR_016
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

.. _br-016:

==============================================================================
BR_016: Tasa de Abandono
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   La Tasa de Abandono se calcula como el porcentaje de llamadas
   abandonadas respecto al total de llamadas recibidas en un periodo.

**Formula:**

.. code-block:: text

   Tasa_Abandono = (Llamadas_Abandonadas / Total_Llamadas) * 100

**Enunciado SBVR:**

   Abandonment rate equals abandoned calls divided by total calls
   multiplied by 100.

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

Variables de la Formula
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 25 40 35

   * - Variable
     - Definicion
     - Fuente de Datos
   * - Llamadas_Abandonadas
     - Llamadas donde cliente colgo antes de ser atendido
     - BD IVR: calls.status = 'ABANDONED'
   * - Total_Llamadas
     - Total de llamadas entrantes en el periodo
     - BD IVR: COUNT(calls)
   * - Periodo
     - Rango de fechas para el calculo
     - Parametro del reporte

----

Implementacion
--------------

SQL
^^^

.. code-block:: sql

   -- BR_016: Tasa de Abandono
   SELECT
       COUNT(*) FILTER (WHERE status = 'ABANDONED') as abandonadas,
       COUNT(*) as total,
       ROUND(
           COUNT(*) FILTER (WHERE status = 'ABANDONED')::DECIMAL
           / NULLIF(COUNT(*), 0) * 100,
           2
       ) as tasa_abandono
   FROM calls
   WHERE call_date BETWEEN :fecha_inicio AND :fecha_fin
     AND segment_id = :segment_id;  -- BR_012: Filtro por segmento

Python
^^^^^^

.. code-block:: python

   # services/metrics.py

   class MetricsService:

       def calculate_abandonment_rate(self, start_date, end_date, segment_id=None):
           """
           BR_016: Calcula tasa de abandono

           Returns:
               dict: {abandonadas, total, tasa_abandono}
           """
           qs = Call.objects.filter(
               call_date__range=(start_date, end_date)
           )

           # BR_012: Filtro por segmento
           if segment_id:
               qs = qs.filter(segment_id=segment_id)

           total = qs.count()
           abandonadas = qs.filter(status='ABANDONED').count()

           if total == 0:
               tasa = Decimal('0.00')
           else:
               tasa = (Decimal(abandonadas) / Decimal(total) * 100).quantize(
                   Decimal('0.01')
               )

           return {
               'abandonadas': abandonadas,
               'total': total,
               'tasa_abandono': tasa
           }

----

Interpretacion
--------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rango
     - Clasificacion
     - Accion
   * - 0% - 3%
     - Excelente
     - Mantener
   * - 3% - 5%
     - Aceptable
     - Monitorear
   * - 5% - 10%
     - Atencion
     - Investigar causas
   * - > 10%
     - Critico
     - Accion inmediata (BR_014)

----

Casos de Uso Relacionados
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Uso de BR_016
   * - UC_017
     - Reporte Trimestral
     - Incluye tasa de abandono
   * - UC_025
     - Dashboard Principal
     - Muestra tasa en tiempo casi-real
   * - UC_036
     - Crear Alerta
     - Puede configurar umbral de abandono

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-MET.01
     - Sistema DEBE calcular tasa de abandono segun formula BR_016
   * - FR-MET.02
     - Sistema DEBE permitir filtrar por periodo
   * - FR-MET.03
     - Sistema DEBE permitir filtrar por segmento
   * - FR-MET.04
     - Sistema DEBE mostrar tasa con 2 decimales

----

Validacion
----------

Casos de Prueba
^^^^^^^^^^^^^^^

.. code-block:: text

   TEST_001: Calculo basico
   - Total: 100, Abandonadas: 5
   - Resultado: 5.00%

   TEST_002: Sin llamadas
   - Total: 0
   - Resultado: 0.00% (no division por cero)

   TEST_003: Todas abandonadas
   - Total: 50, Abandonadas: 50
   - Resultado: 100.00%

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-014` - BR_014 Alerta por Umbral
- :ref:`br-017` - BR_017 Tiempo Promedio Espera
- :ref:`br-018` - BR_018 Indice de Eficiencia
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

- Origen: Metricas de Call Center
- Tipo: Calculo (no genera UC, usado en UC existentes)
- Usado en: UC_017, UC_025, UC_036
- Deriva: FR-MET.01 a FR-MET.04
