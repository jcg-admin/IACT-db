.. meta::
   :artefacto: BR_018
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-018:

============================
BR_018: Índice de Eficiencia
============================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_018
   * - **Nombre**
     - Índice de Eficiencia
   * - **Tipo**
     - Cálculo
   * - **Categoría**
     - KPI / Métricas Operacionales
   * - **Criticidad**
     - Media
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_018**

   El Índice de Eficiencia se calcula como el porcentaje de llamadas atendidas
   respecto al total de llamadas entrantes, representando la capacidad efectiva
   de atención del call center en un período determinado.

1.2 Fórmula de Cálculo
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Indice_Eficiencia = (Llamadas_Atendidas / Total_Llamadas_Entrantes) × 100

   Donde:
   - Llamadas_Atendidas: Llamadas contestadas por un agente
   - Total_Llamadas_Entrantes: Todas las llamadas recibidas

   Relación con Tasa de Abandono:
   Indice_Eficiencia ≈ 100 - Tasa_Abandono (aproximación)

1.3 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - llamada_atendida: Llamada contestada por agente
     - llamada_entrante: Llamada recibida en el sistema
     - indice_eficiencia: Porcentaje de llamadas atendidas
     - periodo: Rango de tiempo para el cálculo

   REGLA DE CÁLCULO:
     indice_eficiencia ES IGUAL A 
       (CONTAR llamadas_atendidas EN periodo / 
        CONTAR llamadas_entrantes EN periodo) × 100
     
     El resultado DEBE expresarse como porcentaje con 2 decimales.

1.4 Justificación
^^^^^^^^^^^^^^^^^

El Índice de Eficiencia es importante porque:

- **Visión positiva**: Complementa tasa de abandono con enfoque en logros
- **Benchmarking**: Permite comparar entre centros
- **Objetivos**: Facilita establecer metas de mejora
- **Reportes ejecutivos**: Métrica preferida para presentaciones

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
- **Alcance**: MOD_Reports

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
     - KPI complementario a tasa de abandono
   * - Reportes Comparativos
     - Eficiencia por centro
   * - Reportes Ejecutivos
     - Resumen de desempeño

3.2 Umbrales de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 30 50
   :header-rows: 1

   * - Rango
     - Clasificación
     - Observación
   * - 95% - 100%
     - Excelente
     - Objetivo ideal
   * - 90% - 95%
     - Bueno
     - Aceptable
   * - 85% - 90%
     - Regular
     - Requiere atención
   * - < 85%
     - Deficiente
     - Acción correctiva

----

4. Implementación Técnica
-------------------------

4.1 SQL de Cálculo
^^^^^^^^^^^^^^^^^^

.. code-block:: sql

   -- BR_018: Cálculo de Índice de Eficiencia
   SELECT 
       fecha,
       centro_id,
       ROUND(
           (SUM(CASE WHEN estado = 'ATENDIDA' THEN 1 ELSE 0 END)::DECIMAL / 
            COUNT(*)::DECIMAL) * 100, 
           2
       ) AS indice_eficiencia
   FROM llamadas
   WHERE fecha BETWEEN :fecha_inicio AND :fecha_fin
   GROUP BY fecha, centro_id;

4.2 Modelo Django
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/reports/services/kpi_calculator.py
   
   class KPICalculator:
                                                
       Calculador de KPIs que implementa BR_018.
                                                
       
       @staticmethod
       def calcular_indice_eficiencia(fecha_inicio, fecha_fin, centro_id=None):
                                                                               
           BR_018: Calcula índice de eficiencia.
           
           Returns:
               Decimal: Porcentaje con 2 decimales
                                                  
           queryset = Llamada.objects.filter(
               fecha__range=(fecha_inicio, fecha_fin)
           )
           
           if centro_id:
               queryset = queryset.filter(centro_id=centro_id)
           
           total = queryset.count()
           if total == 0:
               return Decimal('0.00')
           
           atendidas = queryset.filter(estado='ATENDIDA').count()
           
           indice = (Decimal(atendidas) / Decimal(total)) * 100
           return indice.quantize(Decimal('0.01'))

----

5. Trazabilidad
---------------

- **Origen**: BReq_RPT_Reporteria
- **UC Relacionados**: UC_RPT_01, UC_RPT_06, UC_RPT_07
- **BR Relacionadas**: BR_016 (complementario)

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
