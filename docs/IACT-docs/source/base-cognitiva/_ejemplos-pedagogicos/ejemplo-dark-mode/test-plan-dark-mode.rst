.. meta::
 :artefacto: TEST-PLAN-dark-mode
 :tipo: Plan de Pruebas
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: pruebas
 :skill_aplicada: dmaic-control
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================
Plan de Pruebas: Dark Mode
==========================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``dmaic-control`` (Six Sigma DMAIC — fase Control) para
 plan de pruebas que valida el comportamiento esperado.

1. Alcance
==========

Este plan cubre las pruebas de la feature Dark Mode aplicada a
los requisitos :doc:`rf-001-dark-mode-toggle` y
:doc:`rf-002-dark-mode-persistence`.

**Out of scope:** rediseño de UI completo del producto (solo se
prueba el theming, no cambios estructurales).

2. Niveles de prueba
====================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Nivel
   - Tooling
   - Cobertura esperada
 * - Unitarias
   - Jest + React Testing Library
   - 90%+ del código nuevo (ThemeProvider, ThemeToggle)
 * - Integración
   - Supertest (backend)
   - 100% de los endpoints de preferences
 * - E2E
   - Playwright
   - Flujo completo del UC-001

3. Casos de prueba
==================

.. list-table::
 :widths: 12 30 18 40
 :header-rows: 1

 * - ID
   - Escenario
   - Tipo
   - Detalle
 * - TC-001
   - Toggle cambia el modo visual
   - E2E
   - :doc:`tc-001-toggle-dark-mode`
 * - TC-002
   - Preferencia persiste tras logout
   - E2E
   - Login/logout cycle
 * - TC-003
   - Default = prefers-color-scheme del SO
   - E2E
   - Mock SO dark, verificar default
 * - TC-004
   - Backend falla pero UI no se bloquea
   - Integración
   - Mock 503, verificar que UI cambia local
 * - TC-005
   - Throttling de POST /theme
   - Integración
   - 11 requests en 1 min → 429

4. Métricas de calidad
======================

- **Cobertura código:** ≥ 90% en módulos nuevos.
- **Test pass rate:** 100% en CI antes de release.
- **Performance:** transición visual < 100ms (medido en E2E).
- **Accesibilidad:** axe-core pass para ambos modos.

5. Criterios de aceptación del release
======================================

1. Todos los TCs en estado PASS.
2. 0 issues de accesibilidad críticos.
3. Performance budget respetado.
4. Security review pasada.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``dmaic-control``
 * - **Fase SDLC**
   - Pruebas
 * - **API backing**
   - :doc:`api-reference-preferences`
 * - **Documento siguiente**
   - :doc:`tc-001-toggle-dark-mode`
