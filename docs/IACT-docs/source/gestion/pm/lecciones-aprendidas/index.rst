.. meta::
 :artefacto: INDEX_LECCIONES_APRENDIDAS
 :tipo: Indice
 :dominio: gestion
 :subdominio: pm/lecciones-aprendidas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

======================
Lecciones Aprendidas
======================

Esta sección consolida **deep-reviews** y **lecciones aprendidas**
del proyecto IACT — análisis retrospectivos sobre la calidad de
remediaciones, refactors y entregables.

Per :doc:`/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates`,
los deep-reviews son artefactos de **Phase 11 TRACK/EVALUATE** (skill
``workflow-track``).

Catálogo
========

.. toctree::
 :maxdepth: 1

 deep-review-rbac-coherencia-artefactos-canonicos
 deep-review-rbac-drift-residual-base-cognitiva

Convención
==========

Naming: ``deep-review-{tema}-{aspecto}.rst`` — auto-explicativo, sin
prefijos numéricos ni nombres de fases del WP origen.

Cada deep-review declara metadata canónica con ``:tipo: Deep-Review``
y trazabilidad bidireccional al WP origen + audit master cuando
aplique.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``workflow-track`` (Phase 11 TRACK/EVALUATE)
 * - **Audits relacionados**
   - :doc:`/gestion/pm/audits/index`
