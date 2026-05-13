.. meta::
 :artefacto: INDEX_METODOLOGIA_APLICACION
 :tipo: Indice
 :dominio: requisitos
 :subdominio: _metodologia-aplicacion
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================================
Metodología aplicada — cómo documentar requisitos en IACT
==========================================================

Propósito
=========

Sub-cajón con el **plan operativo** y los **ejemplos
aplicados al dominio IACT** que guían la generación de los
artefactos de requisitos (BReq, BR, UC, FR, NFR).

Marco aplicado
==============

**Requirements Management** (ISO 29148 / IEEE) — los skills
``rm-elicitation``, ``rm-analysis``, ``rm-specification``,
``rm-validation``, ``rm-management``.

Los documentos aquí cubren las cinco fases del ciclo RM
aplicadas al dominio IACT.

Catálogo
========

.. toctree::
 :maxdepth: 1
 :caption: Plan operativo

 plan-documentacion-uc

.. toctree::
 :maxdepth: 1
 :caption: Aplicaciones de técnicas al dominio

 diagramas-uml
 orientacion-objetos
 analisis-dominio
 relaciones-uml
 agregacion-interfaces
 casos-uso-especificacion
 casos-uso-diagramas
 diagramas-estados
 diagramas-secuencias
 diagramas-colaboraciones
 diagramas-actividades
 diagramas-componentes
 diagramas-distribucion
 diagramas-tiempo
 patrones-diseno

Mapeo a skills RM
=================

.. list-table::
 :widths: 38 32 30
 :header-rows: 1

 * - Documento
   - Skill principal
   - Fase RM
 * - :doc:`plan-documentacion-uc`
   - ``rm-management``
   - Gestión de baseline + trazabilidad
 * - :doc:`diagramas-uml`
   - ``rm-specification``
   - Formalizar requisitos con UML
 * - :doc:`orientacion-objetos`
   - ``rm-analysis``
   - Análisis OOP de requisitos
 * - :doc:`analisis-dominio`
   - ``rm-elicitation`` + ``rm-analysis``
   - Sustantivos→clases / verbos→operaciones
 * - :doc:`relaciones-uml`
   - ``rm-specification``
   - Modelado de relaciones entre entidades
 * - :doc:`agregacion-interfaces`
   - ``rm-specification``
   - Modelado de aggregation/composition/interfaces
 * - :doc:`casos-uso-especificacion`
   - ``rm-elicitation`` + ``rm-analysis`` + ``rm-specification``
   - Especificación textual completa de UCs (Hora 6)
 * - :doc:`casos-uso-diagramas`
   - ``rm-elicitation`` + ``rm-specification``
   - Modelado visual de UCs con PlantUML (Hora 7)
 * - :doc:`diagramas-estados`
   - ``rm-specification`` + ``rm-analysis``
   - Comportamiento temporal de objetos (Hora 8)
 * - :doc:`diagramas-secuencias`
   - ``rm-specification`` + ``rm-analysis``
   - Interacciones entre objetos en el tiempo (Hora 9)
 * - :doc:`diagramas-colaboraciones`
   - ``rm-specification`` + ``rm-analysis``
   - Contexto espacial e interacciones (Hora 10)
 * - :doc:`diagramas-actividades`
   - ``rm-specification`` + ``rm-analysis``
   - Flujos, decisiones y paralelismo en procesos (Hora 11)
 * - :doc:`diagramas-componentes`
   - ``rm-specification`` + ``rm-analysis``
   - Arquitectura física y contratos entre apps (Hora 12)
 * - :doc:`diagramas-distribucion`
   - ``rm-specification`` + ``rm-analysis``
   - Despliegue, nodos y protocolos en intranet (Hora 13)
 * - :doc:`diagramas-tiempo`
   - ``rm-specification``
   - Timing diagram preliminar (WP abierto en HOLD)
 * - :doc:`patrones-diseno`
   - ``rm-specification`` + ``rm-analysis``
   - Patrones GoF aplicados a Django/Python en IACT

Convención
==========

- Naming kebab-lowercase per
  :doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`.
- Diagramas en **PlantUML** (no Mermaid) per
  :doc:`/base-cognitiva/plantuml-guide/guidelines`.
- Ejemplos del dominio IACT (call center IVR + analytics +
  RBAC + ETL), no genéricos.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skills aplicados**
   - ``rm-elicitation`` / ``rm-analysis`` /
     ``rm-specification`` / ``rm-management``
 * - **Metodologías hermanas (en normativa)**
   - :doc:`/normativa/estandares/metodologia-analisis-dominio-ucs`,
     :doc:`/normativa/estandares/metodologia-oop-para-ucs`
 * - **Plantilla canónica de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Teoría UML genérica**
   - :doc:`/base-cognitiva/_uml/index`
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
