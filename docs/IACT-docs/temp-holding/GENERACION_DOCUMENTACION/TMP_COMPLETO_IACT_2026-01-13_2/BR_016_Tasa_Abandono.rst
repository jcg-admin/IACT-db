.. meta::
   :artefacto: BR_016
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
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

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_016
   * - **Nombre**
     - Tasa de Abandono
   * - **Tipo**
     - Cálculo
   * - **Categoría**
     - KPI / Métricas Operacionales
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_016**

   La Tasa de Abandono se calcula como el porcentaje de llamadas abandonadas
   respecto al total de llamadas entrantes en un período determinado.

1.2 Fórmula de Cálculo
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Tasa_Abandono = (Llamadas_Abandonadas / Total_Llamadas_Entrantes) × 100

   Donde:
   - Llamadas_Abandonadas: Llamadas donde el cliente colgó antes de ser atendido
   - Total_Llamadas_Entrantes: Todas las llamadas recibidas en el período

1.3 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - llamada_abandonada: Llamada terminada por cliente antes de atención
     - llamada_entrante: Llamada recibida en el IVR
     - tasa_abandono: Porcentaje calculado de abandono
     - periodo: Rango de tiempo para el cálculo (hora, día, mes)

   REGLA DE CÁLCULO:
     tasa_abandono ES IGUAL A 
       (CONTAR llamadas_abandonadas EN periodo / 
        CONTAR llamadas_entrantes EN periodo) × 100
     
     El resultado DEBE expresarse como porcentaje con 2 decimales.

1.4 Justificación
^^^^^^^^^^^^^^^^^

La tasa de abandono es un KPI crítico porque:

- **Calidad de servicio**: Indica capacidad de atención
- **Dimensionamiento**: Ayuda a planificar recursos
- **SLA**: Métrica contractual común
- **Experiencia cliente**: Refleja frustración de usuarios

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Cálculo**
   * - 
     - [X] **Cálculo**: Define fórmula matemática para derivar valor

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Estática - fórmula fija
- **Automatizable**: Sí - calculada por ETL
- **Alcance**: MOD_Reports, MOD_Alerts

----

3. Aplicación en Sistema
------------------------

3.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripción de Aplicación
   * - Dashboard Principal
     - KPI destacado en panel superior
   * - Reportes Trimestrales
     - Tendencia de abandono por período
   * - Alertas
     - Umbral de alerta si > 15%
   * - ETL
     - Cálculo durante procesamiento nocturno

3.2 Umbrales de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 30 50
   :header-rows: 1

   * - Rango
     - Clasificación
     - Acción
   * - 0% - 5%
     - Excelente
     - Ninguna
   * - 5% - 10%
     - Aceptable
     - Monitorear
   * - 10% - 15%
     - Precaución
     - Revisar recursos
   * - > 15%
     - Crítico
     - Alerta BR_014

----

4. Implementación Técnica
-------------------------

4.1 SQL de Cálculo
^^^^^^^^^^^^^^^^^^

.. code-block:: sql

   -- BR_016: Cálculo de Tasa de Abandono
   SELECT 
       fecha,
       centro_id,
       ROUND(
           (SUM(CASE WHEN estado = 'ABANDONADA' THEN 1 ELSE 0 END)::DECIMAL / 
            COUNT(*)::DECIMAL) * 100, 
           2
       ) AS tasa_abandono
   FROM llamadas
   WHERE fecha BETWEEN :fecha_inicio AND :fecha_fin
   GROUP BY fecha, centro_id;

4.2 Modelo Django
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/reports/services/kpi_calculator.py
   
   class KPICalculator:
       """
       Calculador de KPIs que implementa BR_016.
       """
       
       @staticmethod
       def calcular_tasa_abandono(fecha_inicio, fecha_fin, centro_id=None):
           """
           BR_016: Calcula tasa de abandono.
           
           Returns:
               Decimal: Porcentaje con 2 decimales
           """
           queryset = Llamada.objects.filter(
               fecha__range=(fecha_inicio, fecha_fin)
           )
           
           if centro_id:
               queryset = queryset.filter(centro_id=centro_id)
           
           total = queryset.count()
           if total == 0:
               return Decimal('0.00')
           
           abandonadas = queryset.filter(estado='ABANDONADA').count()
           
           tasa = (Decimal(abandonadas) / Decimal(total)) * 100
           return tasa.quantize(Decimal('0.01'))

----

5. Trazabilidad
---------------

- **Origen**: BReq_RPT_Reporteria
- **UC Relacionados**: UC_RPT_01, UC_RPT_07
- **BR Relacionada**: BR_014 (alerta si excede umbral)

----

6. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Versión inicial

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
