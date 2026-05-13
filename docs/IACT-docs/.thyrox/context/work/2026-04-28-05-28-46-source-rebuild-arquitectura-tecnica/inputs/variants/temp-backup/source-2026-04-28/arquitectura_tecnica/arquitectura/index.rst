.. _arquitectura:

============
Arquitectura
============

Propósito
=========

Este subdominio contiene las **vistas arquitectónicas** y **decisiones de diseño (ADRs)** 
del proyecto IACT, documentando la estructura de alto nivel del sistema.

La arquitectura define cómo se organizan los componentes principales y las decisiones 
técnicas que guían la implementación.

Contenido
=========

La arquitectura incluye:

* **Diagramas UML:**
  
  * Componentes (estructura del sistema)
  * Despliegue (distribución física)
  * Paquetes (organización lógica)

* **Architecture Decision Records (ADRs):**
  
  * Contexto de la decisión
  * Opciones consideradas
  * Decisión tomada y justificación
  * Consecuencias

Prefijos
========

Los artefactos de este subdominio usan:

* **ARQ_VIS_** para vistas arquitectónicas
* **ARQ_MOD_** para modelos
* **ADR_** para decisiones arquitectónicas

Ejemplo: ``ADR_001_Seleccion_Framework_Backend.rst``

.. note::
   Contenido en desarrollo. Las vistas y decisiones arquitectónicas se documentarán 
   conforme se defina el diseño del sistema.


.. toctree::
   :hidden:
   :maxdepth: 1

   patrones/index
   Diagramas de Referencia - README
   OBSERVABILITY_LAYERS
   README
   STORAGE_ARCHITECTURE
   TASK-010-logging_estructurado_json
   TASK-011-data_centralization_layer
   TASK-029-data_quality_framework
   lineamientos_codigo
