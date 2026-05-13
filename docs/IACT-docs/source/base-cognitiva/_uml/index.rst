.. meta::
 :artefacto: INDEX_UML
 :tipo: Indice
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-index:

============================
UML — Notación y Diagramas
============================

Propósito
=========

Este subdominio contiene material **pedagógico y de referencia
sobre la notación UML** (Unified Modeling Language): los tipos de
diagramas, sus convenciones gráficas, y las reglas de modelado
que aplican al proyecto IACT.

Responde a la pregunta: **"¿Qué diagrama UML usar y cómo se
lee?"**.

Distinción con otros cajones
============================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Cajón
   - Foco
 * - ``_uml/`` (este)
   - **Notación UML formal** — qué significan los símbolos,
     cuándo usar cada diagrama, ejemplos pedagógicos.
 * - :doc:`/base-cognitiva/plantuml-guide/index`
   - **Cómo dibujar** UML con PlantUML — sintaxis de la
     herramienta, estilos centralizados, paleta de colores.
 * - :doc:`/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-01-metamodelo-requisitos`
   - **Metamodelo del proyecto** — instancias UML específicas
     que modelan los artefactos de IACT.

Catálogo
========

.. toctree::
 :maxdepth: 1
 :caption: Guía rápida

 cuando-usar-cada-diagrama

.. toctree::
 :maxdepth: 1
 :caption: Lecciones (Schmuller adaptado)

 uml-01-introduccion
 uml-02-orientacion-objetos
 uml-03-uso-orientacion-objetos
 uml-04-uso-relaciones
 uml-05-agregacion-composicion-interfaces
 uml-06-introduccion-casos-uso
 uml-07-diagramas-casos-uso
 uml-08-diagramas-estados
 uml-09-diagramas-secuencias
 uml-10-diagramas-colaboraciones
 uml-11-diagramas-actividades
 uml-12-diagramas-componentes
 uml-13-diagramas-distribucion

Convención
==========

Naming: ``uml-<NN>-<descripcion-kebab>.rst`` per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`.

ID semántico en metadata: ``UML_NN`` (ej: ``UML_01``).

Cada lección sigue la estructura: contenido teórico + diagrama(s)
PlantUML usando los estilos centralizados de
:doc:`/base-cognitiva/plantuml-guide/guidelines`.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation)
 * - **Fuente principal**
   - *Aprendiendo UML en 24 horas* — adaptado al schema canónico
     IACT y diagramas re-creados con PlantUML.
 * - **Estilos PlantUML**
   - ``source/_static/plantuml-styles.puml``
