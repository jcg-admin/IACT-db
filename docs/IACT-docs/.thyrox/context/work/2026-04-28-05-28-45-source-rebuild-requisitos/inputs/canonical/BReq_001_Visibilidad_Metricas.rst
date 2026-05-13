
.. meta::
   :artefacto: BReq_001
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _breq-001:

=====================================
BReq_001: Visibilidad de Metricas IVR
=====================================


Resumen
-------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BReq-001
   * - **Nombre**
     - Visibilidad de Metricas IVR
   * - **Categoria**
     - Analitica Operacional
   * - **Prioridad**
     - Alta
   * - **Estado**
     - Aprobado

----

1. Enunciado Formal
-------------------

El sistema DEBE proporcionar visibilidad en tiempo casi-real de las
metricas operacionales del IVR, permitiendo a los supervisores monitorear
el estado del call center mediante dashboards actualizados automaticamente.

----

2. Metrica de Exito
-------------------

::

   Indicadores:
   - Actualizacion de dashboard: Cada 5 minutos (auto-refresh)
   - Latencia maxima de datos: D+1 (dia siguiente al operacional)
   - Metricas disponibles: 100% de KPIs clave
   - Disponibilidad del dashboard: >= 99.5%
   
   Frecuencia de medicion: Continua (monitoreo automatico)

----

3. Justificacion
----------------

Sin visibilidad de metricas, los supervisores operan "a ciegas":

- No pueden detectar problemas hasta que escalan
- Carecen de datos para tomar decisiones
- No pueden comparar rendimiento entre centros
- No identifican tendencias ni patrones

Con un dashboard de metricas:

- Monitoreo proactivo del estado operacional
- Deteccion temprana de anomalias
- Comparacion de rendimiento entre centros
- Identificacion de tendencias y patrones
- Soporte para decisiones basadas en datos

----

4. BR que Influyen
------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - BR
     - Nombre
     - Como Influye
   * - BR_002
     - ETL Batch Nocturno
     - Define cuando se actualizan los datos (medianoche, D+1)
   * - BR_016
     - Tasa de Abandono
     - Define formula de calculo de KPI clave
   * - BR_017
     - Tiempo Promedio Espera
     - Define formula de calculo de KPI clave (ASA)

----

5. UC que Genera
----------------

**Dashboard (MOD_Reports):**

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - UC
     - Nombre
     - Relacion
   * - UC-025
     - Visualizar Dashboard Operativo
     - Vista principal con widgets de metricas
   * - UC-026
     - Ver KPIs en Tiempo Real
     - Indicadores clave actualizados
   * - UC-027
     - Analizar Tendencias
     - Graficos historicos de metricas
   * - UC-028
     - Comparar Periodos
     - Analisis comparativo temporal
   * - UC-029
     - Filtrar por Centro
     - Segmentacion geografica de datos
   * - UC-030
     - Exportar Vista Dashboard
     - Captura del estado actual

**Pipeline (MOD_Pipeline):**

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - UC
     - Nombre
     - Relacion
   * - UC-050
     - Supervisar Estado ETL
     - Monitoreo del proceso de sincronizacion
   * - UC-051
     - Consultar Errores ETL
     - Diagnostico de problemas de datos
   * - UC-052
     - Consultar Disponibilidad Datos
     - Verificar hasta que fecha hay datos
   * - UC-053
     - Reiniciar Proceso ETL
     - Recuperacion manual si falla

----

6. Criterios de Aceptacion
--------------------------

1. Dashboard principal con al menos 6 widgets de KPIs
2. Auto-refresh cada 5 minutos sin intervencion del usuario
3. Datos actualizados a D+1 (dia anterior completo)
4. Filtros por centro y rango de fechas funcionales
5. Graficos de tendencia historica disponibles
6. Exportacion de vista a imagen/PDF
7. Disponibilidad >= 99.5% en horario laboral

----

7. KPIs Incluidos
-----------------

::

   Metricas principales del dashboard:
   
   1. Tasa de Abandono (BR_016)
      Formula: (Abandonadas / Total) * 100
   
   2. Tiempo Promedio de Espera - ASA (BR_017)
      Formula: SUM(Tiempo_Espera) / COUNT(Atendidas)
   
   3. Llamadas Atendidas
      Contador simple por periodo
   
   4. Llamadas Abandonadas
      Contador simple por periodo
   
   5. Nivel de Servicio
      Porcentaje atendidas en < X segundos
   
   6. Ocupacion de Agentes
      Tiempo en llamada / Tiempo disponible

----

8. Stakeholders
---------------

- **Sponsor**: Gerencia de Operaciones
- **Beneficiarios**: Supervisores de Call Center
- **Usuarios**: AGR-004 visor_dashboard, AGR-003 analista_reportes

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
     - 2026-01-06
     - Equipo IACT
     - Version inicial
