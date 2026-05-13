.. meta::
 :artefacto: TPL_SETUP_QA
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

============================================
TPL_SETUP_QA: Plantilla de Setup de QA
============================================

.. note::

 Plantilla para configurar el ambiente y procesos de QA.
 Aplica skill ``dmaic-control``.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Proyecto**
   - {nombre}
 * - **Tipo de QA**
   - Funcional / Performance / Seguridad / Documental
 * - **Owner**
   - QA Lead

2. Tooling
==========

- Test runners (Jest, pytest, Playwright).
- Linters / formatters.
- Coverage tools.
- CI integration.

3. Estrategia de pruebas
========================

Ver :doc:`/normativa/procedimientos/proc-qa-002-estrategia-qa` y
:doc:`tpl-tst-pruebas` para test plan + casos de prueba.

Pirámide objetivo:

- 60% unit tests
- 30% integration tests
- 10% E2E tests

4. Métricas de calidad
======================

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Métrica
   - Objetivo
   - Cómo se mide
 * - Cobertura código
   - ≥ 80% (RNF-002)
   - coverage.py / istanbul
 * - Test pass rate
   - 100%
   - CI runs
 * - Defects escapados
   - < 5%
   - Tracking post-release

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``dmaic-control``
 * - **Procedimientos aplicables**
   - :doc:`/normativa/procedimientos/proc-qa-002-estrategia-qa`,
     :doc:`/normativa/procedimientos/proc-qa-004-qa`
