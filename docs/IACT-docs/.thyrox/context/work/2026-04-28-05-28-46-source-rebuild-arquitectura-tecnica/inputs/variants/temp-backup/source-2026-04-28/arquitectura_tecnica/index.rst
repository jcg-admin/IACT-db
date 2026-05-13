.. _arquitectura-tecnica:

====================
Arquitectura Técnica
====================

Propósito del Dominio
=====================

El dominio **Arquitectura Técnica** define el diseño estructural y operacional del sistema IACT, 
traduciendo requisitos funcionales en un diseño técnico implementable.

Este dominio responde a la pregunta fundamental: **"¿Cómo se construye técnicamente el sistema?"**

Contenido
=========

La arquitectura técnica proporciona:

* **Vistas Arquitectónicas:** Diagramas UML (componentes, despliegue, paquetes)
* **Decisiones de Diseño:** ADRs que documentan elecciones técnicas importantes
* **Diseño Detallado:** APIs, modelos de datos, interfaces
* **Infraestructura:** Configuración de despliegue y operación

Stack Tecnológico
=================

El sistema IACT está construido con:

* **Frontend:** React
* **Backend:** Django REST Framework
* **Bases de Datos:**

  * MySQL (origen - solo lectura)
  * PostgreSQL (destino - analítica)

* **Proceso ETL:** Extracción, Transformación y Carga de datos

Subdominios
===========

.. toctree::
   :maxdepth: 2

   arquitectura/index
   diseño_detallado/index
   despliegue/index

.. note::
   Las decisiones arquitectónicas (ADRs) documentan el contexto, las opciones
   consideradas y las razones detrás de cada elección técnica importante.