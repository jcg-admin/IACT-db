.. meta::
 :artefacto: INDEX_AUDITS
 :tipo: Indice
 :dominio: gestion
 :subdominio: pm/audits
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========
Audits PM
==========

Esta sección consolida **audits** del proyecto IACT — análisis
exhaustivos retrospectivos sobre WPs cerrados, omisiones de
inputs, y verificación cross-WP.

Per :doc:`/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates`,
los audits son artefactos de **Phase 11 TRACK/EVALUATE** (skill
``pm-monitoring``).

Catálogo
========

.. toctree::
 :maxdepth: 1

 audit-cross-wp-source-rebuild
 audit-omisiones-temp-holding-arquitectura-tecnica

Convención
==========

Naming: ``audit-{tema-o-wp}-{aspecto}.rst`` — auto-explicativo,
sin prefijos numéricos ni nombres de fases del WP origen.

Cada audit declara metadata canónica con ``:tipo: Audit`` y
trazabilidad bidireccional al WP origen + lecciones aprendidas
relacionadas cuando aplique.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``pm-monitoring`` (PMBOK — Monitoring & Controlling)
 * - **Lecciones aprendidas relacionadas**
   - :doc:`/gestion/pm/lecciones-aprendidas/index`
