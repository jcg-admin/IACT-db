.. meta::
 :artefacto: QA_001
 :tipo: Estrategia
 :dominio: quality
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Alto

=====================
Estrategia de Testing
=====================

Estrategia de testing del sistema IACT: niveles, herramientas,
cobertura objetivo y procesos.

1. Niveles de Testing
======================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Nivel
   - Herramientas
   - Foco
 * - Unit tests
   - pytest, jest
   - Logica de negocio aislada por componente
 * - Integration tests
   - pytest, supertest
   - Interaccion entre componentes (BD, API, ETL)
 * - E2E tests
   - Cypress, Playwright
   - Flujos de usuario completos UI ↔ backend
 * - Performance tests
   - Locust, k6
   - SLA endpoints (CNST_017)
 * - Security tests
   - Bandit, OWASP ZAP
   - CNST_009..014 (Auth/Permission/Throttling/Validacion)

2. Cobertura objetivo
=====================

- **Unit tests**: 80% statement coverage minimo en backend.
- **Integration tests**: cubrir todos los UCs criticos (CNST_017 SLA).
- **E2E tests**: cubrir los UC_AUTH_* + UC_USR_* + 1 flujo completo
  por modulo.

3. Procedimientos relacionados
==============================

- :doc:`/normativa/procedimientos/proc-qa-001-actividades-garantia-documental`
- :doc:`/normativa/procedimientos/proc-qa-002-estrategia-qa`
- :doc:`/normativa/procedimientos/proced-qa-001-ejecutar-tests`

4. ADRs aplicables
==================

- :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`
- ADR-QA-002 (testing strategy Jest + Testing Library) — pendiente
  migracion a source en WP #14 v2 (vive actualmente en
  ``inputs/canonical/``).
