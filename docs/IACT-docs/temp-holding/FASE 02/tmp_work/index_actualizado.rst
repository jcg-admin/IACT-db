.. IACT - Sistema de Dashboard Analytics documentation master file

====================================================
IACT - Sistema de Dashboard Analytics
====================================================

.. image:: _static/img/logo.svg
   :alt: IACT Logo
   :align: center
   :width: 200px

----

Bienvenido a la Documentación del Proyecto IACT
================================================

El proyecto IACT es una solución de **Dashboard Analytics** que conecta datos operativos con necesidades de análisis de negocio mediante un proceso ETL robusto y trazable.

Arquitectura del Sistema
------------------------

* **Fuente de Datos:** MySQL (operativa, solo lectura)
* **Destino Analítico:** PostgreSQL (optimizado para consultas)
* **Backend:** Django REST Framework
* **Frontend:** React (Dashboard)

Estructura de la Documentación
==============================

Esta documentación sigue el **Modelo Documental IACT v2.0.0**, organizado en 5 Dominios Primarios que gobiernan 21 Subdominios especializados.

.. toctree::
   :maxdepth: 1
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence

.. toctree::
   :maxdepth: 2
   :caption: Base Cognitiva

   base_cognitiva/index

.. toctree::
   :maxdepth: 2
   :caption: Normativa

   normativa/index

.. toctree::
   :maxdepth: 2
   :caption: Requisitos

   requisitos/index

.. toctree::
   :maxdepth: 2
   :caption: Arquitectura Técnica

   arquitectura_tecnica/index

.. toctree::
   :maxdepth: 2
   :caption: Gestión

   gestion/index

Índices y Búsqueda
==================

* :ref:`genindex`
* :ref:`search`

----

.. note::
   **Versión:** 1.0.0  
   **Fecha:** 2025  
   **Equipo:** IACT Development Team
