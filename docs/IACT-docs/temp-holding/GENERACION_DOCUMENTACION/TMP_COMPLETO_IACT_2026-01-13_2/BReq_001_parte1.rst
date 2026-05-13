.. meta::
   :artefacto: BReq_001
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :ultimo_cambio: 2026-01-06
   :autor: Equipo IACT
   :clasificacion: Interno

.. _breq-001:

==============================================================================
BReq_001: Objetivos de Negocio IACT
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
------------

Este documento define los Business Requirements (BReq) del proyecto IACT -
IVR Analytics & Customer Tracking. Los BReq representan los objetivos de
alto nivel que justifican la existencia del sistema.

1.1 Alcance
^^^^^^^^^^^

- Define 5 objetivos de negocio medibles
- Establece metricas de exito cuantificables
- Documenta trazabilidad hacia BR (influencia) y UC (generacion)
- Sirve como base para validar el exito del proyecto

1.2 Relacion con META_04
^^^^^^^^^^^^^^^^^^^^^^^^

META_04 describe el CONTEXTO del proyecto (stakeholders, sistemas, ambiente).
Este documento define los OBJETIVOS (metas medibles del negocio).

::

   META_04: "Donde opera IACT?" -> Contexto
   BReq:    "Por que existe IACT?" -> Objetivos

----

2. Vision del Proyecto
----------------------

2.1 Enunciado de Vision
^^^^^^^^^^^^^^^^^^^^^^^

IACT proporciona a los supervisores y analistas del call center una
plataforma de analitica que transforma datos operacionales del IVR en
informacion accionable, permitiendo decisiones basadas en evidencia y
reduciendo el tiempo de respuesta ante incidentes.

2.2 Problema de Negocio
^^^^^^^^^^^^^^^^^^^^^^^

Actualmente, los datos del sistema IVR estan disponibles pero no son
facilmente accesibles ni analizables. Los supervisores carecen de
visibilidad en tiempo real sobre metricas clave como:

- Tasa de abandono de llamadas
- Tiempo promedio de espera
- Carga por centro de atencion
- Tendencias y anomalias

2.3 Solucion Propuesta
^^^^^^^^^^^^^^^^^^^^^^

IACT extrae datos del IVR mediante proceso ETL nocturno, los transforma
en metricas accionables, y los presenta en dashboards y reportes accesibles
segun el perfil de cada usuario.

----

3. Business Requirements
------------------------

3.1 BReq-001: Visibilidad de Metricas IVR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Enunciado Formal**

El sistema DEBE proporcionar visibilidad en tiempo casi-real de las
metricas operacionales del IVR, permitiendo a los supervisores monitorear
el estado del call center.

**Metrica de Exito**

::

   Dashboard actualizado automaticamente cada 5 minutos
   Latencia maxima de datos: D+1 (dia siguiente al operacional)
   100% de metricas clave disponibles en dashboard

**Justificacion**

Sin visibilidad de metricas, los supervisores operan "a ciegas" y no
pueden detectar problemas hasta que escalan significativamente.

**BR que Influyen**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - BR
     - Nombre
     - Como Influye
   * - BR_002
     - ETL Batch Nocturno
     - Define cuando se actualizan los datos (D+1)
   * - BR_016
     - Tasa de Abandono
     - Define calculo de metrica clave
   * - BR_017
     - Tiempo Promedio Espera
     - Define calculo de metrica clave

**UC que Genera**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - UC
     - Nombre
     - Relacion
   * - UC-025
     - Visualizar Dashboard Operativo
     - Vista principal de metricas
   * - UC-026
     - Ver KPIs en Tiempo Real
     - Indicadores actualizados
   * - UC-027
     - Analizar Tendencias
     - Graficos historicos
   * - UC-028
     - Comparar Periodos
     - Analisis comparativo
   * - UC-029
     - Filtrar por Centro
     - Segmentacion de datos
   * - UC-030
     - Exportar Vista Dashboard
     - Compartir estado
   * - UC-050
     - Supervisar Estado ETL
     - Monitoreo del proceso
   * - UC-051
     - Consultar Errores ETL
     - Diagnostico de problemas
   * - UC-052
     - Consultar Disponibilidad Datos
     - Verificar actualizacion
   * - UC-053
     - Reiniciar Proceso ETL
     - Recuperacion manual

----

3.2 BReq-002: Reduccion de Tiempo de Respuesta a Incidentes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Enunciado Formal**

El sistema DEBE reducir el tiempo de deteccion y respuesta a incidentes
operacionales mediante alertas proactivas basadas en umbrales configurables.

**Metrica de Exito**

::

   Reduccion >= 40% en tiempo de respuesta vs linea base
   Linea base: Tiempo promedio actual sin sistema de alertas
   Medicion: Tiempo desde ocurrencia hasta primera accion correctiva

**Justificacion**

La deteccion tardia de problemas (alta tasa de abandono, colas saturadas)
resulta en perdida de clientes y deterioro del servicio.

**BR que Influyen**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - BR
     - Nombre
     - Como Influye
   * - BR_014
     - Alerta por Umbral
     - Define mecanismo de deteccion automatica

**UC que Genera**

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - UC
     - Nombre
     - Relacion
   * - UC-036
     - Crear Alerta por Umbral
     - Configuracion de deteccion
   * - UC-037
     - Recibir Notificacion Alerta
     - Comunicacion al usuario
   * - UC-038
     - Consultar Historial Alertas
     - Registro de eventos
   * - UC-039
     - Modificar Configuracion Alerta
     - Ajuste de umbrales
   * - UC-040
     - Gestionar Destinatarios Alerta
     - Distribucion de notificaciones
