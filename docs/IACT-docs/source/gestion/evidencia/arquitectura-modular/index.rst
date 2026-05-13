.. meta::
 :artefacto: INDEX_ARQUITECTURA_MODULAR
 :tipo: Indice
 :dominio: gestion
 :subdominio: evidencia/arquitectura-modular
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================
Evidencia: Arquitectura Modular
==================================

Esta sección consolida **análisis arquitectónicos modulares** del
proyecto IACT — inventarios de módulos canónicos, mapeo de
funciones por módulo, gaps de cobertura, y trazabilidad a CNSTs.

Per :doc:`/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates`,
los análisis modulares son artefactos de **Phase 3 ANALYZE** (skill
``bpa-analyze``).

Catálogo
========

.. toctree::
 :maxdepth: 1

 analisis-catalogo-modular-iact

Convención
==========

Naming: ``analisis-{tema}-{aspecto}.rst`` — auto-explicativo, sin
prefijos numéricos ni nombres de fases del WP origen.

Cada análisis declara metadata canónica con
``:tipo: Evidencia`` y trazabilidad bidireccional al WP origen +
decisiones canonificadas (ADRs, CNSTs) cuando aplique.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``bpa-analyze`` (Business Process Analysis — Analyze)
 * - **Modelo arquitectónico vigente**
   - :doc:`/arquitectura-tecnica/index`
 * - **Decisiones derivadas (RBAC)**
   - :doc:`/gestion/evidencia/rbac-historia/index`
