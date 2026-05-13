.. _diseño-detallado:

================
Diseño Detallado
================

Propósito
=========

Este subdominio contiene el **diseño de bajo nivel** del proyecto IACT, 
especificando APIs, modelos de datos, interfaces y componentes internos.

El diseño detallado traduce la arquitectura de alto nivel en especificaciones 
técnicas implementables.

Contenido
=========

El diseño detallado incluye:

* **APIs REST:** Especificación de endpoints, request/response
* **Modelos de Datos:** Esquemas de base de datos (ER, tablas)
* **Interfaces:** Contratos entre componentes
* **Flujos de Interacción:** Diagramas de secuencia, colaboración
* **Componentes Internos:** Clases, módulos, servicios

Stack Detallado
===============

* **Backend API:** Django REST Framework
  
  * Autenticación JWT
  * Serializers
  * ViewSets y routers

* **Base de Datos Analítica:** PostgreSQL
  
  * Esquema optimizado para consultas
  * Índices y particiones

* **Proceso ETL:**
  
  * Extracción desde MySQL
  * Transformaciones de datos
  * Carga a PostgreSQL

Prefijos
========

Los artefactos de este subdominio usan:

* **API_** para especificaciones de APIs
* **DSC_MOD_** para modelos de datos
* **DSC_INT_** para interfaces
* **DSC_CMP_** para componentes

Ejemplo: ``API_001_Dashboard_Metricas.rst``

.. note::
   Contenido en desarrollo. Las especificaciones detalladas se documentarán 
   durante la fase de diseño e implementación.


.. toctree::
   :hidden:
   :maxdepth: 1

   README_diseno_detallado
