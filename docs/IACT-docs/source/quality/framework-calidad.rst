.. meta::
 :artefacto: QA_002
 :tipo: Framework
 :dominio: quality
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Medio

====================
Framework de Calidad
====================

Pipeline de validacion automatizada del sistema IACT.

1. Stack
========

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Tipo
   - Herramientas
 * - Linters Python
   - ruff, mypy
 * - Linters JS/TS
   - ESLint, Prettier
 * - Tests Python
   - pytest + pytest-django + factory-boy
 * - Tests JS
   - Jest + Testing Library
 * - Coverage
   - coverage.py + Codecov
 * - Security
   - Bandit (Python), npm audit (JS)
 * - CI/CD
   - GitHub Actions / GitLab CI
 * - Sphinx build
   - sphinx-build con ``-W`` en CI (CNST: build limpio)

2. Pipeline CI
==============

.. code-block:: text

 PR submitted
 ↓
 Linters → fail-fast si format/style violations
 ↓
 Unit tests → coverage >= 80%
 ↓
 Integration tests → DB en docker
 ↓
 E2E tests (solo en main)
 ↓
 Sphinx build con -W (validar docs)
 ↓
 Security scan
 ↓
 Merge / Deploy

3. Verificacion de cumplimiento de CNSTs
=========================================

El framework de calidad verifica automaticamente cumplimiento de
restricciones canonicas:

- :doc:`/normativa/restricciones/cnst-009-autenticacion-drf-obligatoria`
  → tests verifican ``permission_classes`` declaradas
- :doc:`/normativa/restricciones/cnst-011-throttling-obligatorio-en-endpoints-publicos`
  → tests verifican rate limits
- :doc:`/normativa/restricciones/cnst-026-pii-prohibida-en-logs-y-auditoria`
  → linter de logs sanitiza PII
- :doc:`/normativa/restricciones/cnst-032-menu-dinamico-obligatorio`
  → E2E test verifica `obtener_menu_usuario`
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
  → linter custom rechaza "Capacidad" en codigo nuevo
