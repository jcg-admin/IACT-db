.. meta::
 :artefacto: INDEX_ARQUITECTURA_TECNICA
 :tipo: Indice
 :dominio: arquitectura_tecnica
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

====================
Arquitectura Tecnica
====================

Vista arquitectonica del sistema IACT: decisiones tecnicas
high-level, vistas, modelos de datos y diagramas.

.. toctree::
 :maxdepth: 2
 :caption: Modelos arquitectonicos

 rbac/index
 modelo-dominio-iact

.. toctree::
 :maxdepth: 2
 :caption: Analisis arquitectonicos

 matriz-dependencias-uc-iact

.. toctree::
 :maxdepth: 2
 :caption: Modulos arquitectonicos

 modulos/index

.. toctree::
 :maxdepth: 2
 :caption: Catálogos del sistema

 catalogos/index

.. note::

 Este cajon esta en construccion incremental. Los siguientes
 subdominios se incorporaran en iteraciones futuras del WP #7:

 - ``arquitectura/`` — overview, observability, storage, data
   centralization, design patterns
 - ``despliegue/`` — deployment topologies, infraestructura
 - ``diseno_detallado/`` — diseno de componentes
 - ``plantuml-guide/`` — guia de diagramas PlantUML
