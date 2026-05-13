====================================================
PlantUML Guide — Centralized Styling & Documentation
====================================================

Propósito del Dominio
=====================

La **PlantUML Guide** establece los estándares visuales y convenciones de diagramación para el proyecto IACT, garantizando consistencia, accesibilidad y mantenibilidad en 100+ diagramas.

Este dominio responde a la pregunta fundamental: **"¿Cómo se diagraman correctamente los componentes del IACT?"**

PlantUML Centralized Styling (Phase 1 Setup)
============================================

.. toctree::
   :maxdepth: 2
   :caption: Color System & Palette

   color-palette

.. toctree::
   :maxdepth: 2
   :caption: Usage Guidelines

   GUIDELINES

.. toctree::
   :maxdepth: 2
   :caption: Examples

   ejemplos/test-uc-diagram
   ejemplos/test-component-diagram
   ejemplos/sistema-completo
   ejemplos/etl-pipeline

**Status:** Phase 1 Setup (Phase 10 EXECUTE) — Complete ✅

All documentation and centralized styles ready for production use with 100+ diagrams.

**Quick Links:**

- :doc:`color-palette` — 6 base colors + T1-T4 variants (WCAG 2.1 AA validated)
- :doc:`GUIDELINES` — How to use centralized styles + usage rules
- :doc:`ejemplos/test-uc-diagram` — Use Case diagram with styles (validated)
- :doc:`ejemplos/test-component-diagram` — Component diagram with styles (validated)
- :doc:`ejemplos/sistema-completo` — Complete system diagram (planned)
- :doc:`ejemplos/etl-pipeline` — ETL process diagram (planned)

**Related:**

- See `ADR: PlantUML Naming Conventions <https://github.com/jcg-admin/iact-docs>`_ for POSIX _prefix convention rationale
- Reference: ``source/_static/plantuml-styles.puml`` (centralized style definitions)


.. toctree::
   :hidden:
   :maxdepth: 1

   METADATA-STANDARD
