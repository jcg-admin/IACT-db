.. meta::
 :artefacto: RELEASE-PLAN-v1-5-0
 :tipo: Plan de Release
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: release
 :skill_aplicada: pm-executing
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

======================
Plan de Release v1.5.0
======================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``pm-executing`` (PMBOK — Executing Process Group) para
 coordinar el release que incluye Dark Mode.

1. Resumen
==========

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Versión**
   - v1.5.0
 * - **Fecha de release**
   - 2026-Q3 (TBD por equipo de release)
 * - **Tipo**
   - Minor (nueva feature, sin breaking changes)
 * - **Features**
   - Dark Mode (saga dark-mode)
 * - **Owner**
   - Product Manager + Tech Lead Backend

2. Scope
========

**In-scope:**

- Feature Dark Mode completa (RF-001 + RF-002).
- API ``/api/preferences/theme`` (GET + POST).
- Tabla ``user_preferences``.
- Tests E2E + integración (TC-001..005).

**Out-of-scope:**

- Cambios estructurales de UI más allá del theming.
- Otras preferencias de usuario (idioma, etc.).

3. Plan de release
==================

.. list-table::
 :widths: 8 25 25 42
 :header-rows: 1

 * - Día
   - Fase
   - Owner
   - Acción
 * - D-7
   - Code freeze
   - Tech Lead
   - PR final mergeada a release/v1.5.0
 * - D-5
   - Build & deploy a STAGING
   - DevOps
   - Ver :doc:`deployment-guide-staging`
 * - D-4 a D-2
   - Smoke tests + QA
   - QA + Soporte
   - TC-001..005 ejecutados; sign-off
 * - D-1
   - Release notes + comm
   - Product Manager
   - Anuncio interno + customer notification
 * - D-0
   - Deploy a PRODUCCIÓN
   - DevOps
   - Blue-green; ventana 06:00-08:00
 * - D+1
   - Monitoreo
   - Soporte + DevOps
   - Métricas dashboard, error rates
 * - D+7
   - Post-release retro
   - Equipo
   - Lecciones aprendidas

4. Rollback plan
================

**Trigger:** error rate > 1% en 30 min, o feature degradación
detectada.

**Acción:**

1. Switch blue-green a versión anterior (v1.4.x).
2. Revertir migration ``20260501-add-user-preferences.sql``
   solo si la causa raíz es la BD.
3. Notificar a stakeholders.
4. Post-mortem en 48h.

5. Communication
================

- **Customer-facing:** banner en producto + email opcional.
- **Internal:** Slack + reunión weekly retrospectiva.
- **Soporte:** training de 30min sobre la feature pre-release.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``pm-executing``
 * - **Fase SDLC**
   - Release
 * - **TC backing**
   - :doc:`tc-001-toggle-dark-mode`
 * - **Documento siguiente**
   - :doc:`deployment-guide-staging`
