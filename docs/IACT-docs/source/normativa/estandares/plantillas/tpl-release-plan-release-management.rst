.. meta::
 :artefacto: TPL_RELEASE_PLAN
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================================
TPL_RELEASE_PLAN: Plantilla de Plan de Release
==============================================

.. note::

 Plantilla para documentar planes de release. Aplicar al
 generar artefactos `release-plan-{version}.rst`. Usa
 ``pm-executing`` (PMBOK — Executing Process Group).

1. Propósito
============

Definir la estructura mínima obligatoria para un plan de release
en el proyecto IACT. Cubre alcance, cronograma, rollback,
comunicación y sign-off.

2. Cuándo usar esta plantilla
=============================

- Antes de cada release Minor o Major.
- NO se usa para hot-fixes (los cuales tienen template propio).
- Aplicable a deploys a STAGING y PRODUCCIÓN.

3. Estructura obligatoria del documento
=======================================

3.1 Resumen
-----------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Versión**
   - {vX.Y.Z}
 * - **Fecha de release**
   - {YYYY-Q*} o fecha exacta
 * - **Tipo**
   - Major / Minor / Patch (semver)
 * - **Features**
   - Lista de features incluidas
 * - **Owner**
   - Product Manager + Tech Lead

3.2 Scope
---------

**In-scope:** lista explícita de features/bug fixes incluidos.

**Out-of-scope:** lista explícita de lo que NO entra (gestión
de expectativas).

3.3 Plan de release (cronograma)
--------------------------------

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
   - PR final mergeada a release branch
 * - D-5
   - Build & deploy STAGING
   - DevOps
   - Smoke tests
 * - D-4 a D-2
   - QA + sign-off
   - QA
   - Suite de tests pasada
 * - D-1
   - Release notes + comm
   - PM
   - Anuncio interno + customer
 * - D-0
   - Deploy a PRODUCCIÓN
   - DevOps
   - Ventana de deploy + monitoreo
 * - D+1
   - Monitoreo intensivo
   - Soporte + DevOps
   - Métricas, error rates
 * - D+7
   - Post-release retro
   - Equipo
   - Lecciones aprendidas

3.4 Rollback plan
-----------------

**Trigger:** condiciones que activan rollback (ej. error rate >
1% en 30 min).

**Acción de rollback:** pasos numerados sin ambigüedad.

**Verificación post-rollback:** cómo confirmar que el sistema
volvió al estado previo.

3.5 Communication
-----------------

- **Customer-facing:** banner / email / blog post.
- **Internal:** Slack / reunión weekly.
- **Soporte:** training pre-release.

3.6 Riesgos identificados
-------------------------

.. list-table::
 :widths: 30 35 35
 :header-rows: 1

 * - Riesgo
   - Probabilidad/Impacto
   - Mitigación
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

3.7 Sign-off
------------

.. list-table::
 :widths: 25 25 25 25
 :header-rows: 1

 * - Rol
   - Nombre
   - Firma
   - Fecha
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}
   - {ejemplo}

4. Ejemplo de aplicación
========================

Ver :doc:`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/release-plan-v1-5-0`
como ejemplo concreto aplicado a la feature Dark Mode.

5. Convenciones de naming
=========================

- Archivo: ``release-plan-{version-semver}.rst`` (kebab-lowercase
  per :doc:`/normativa/estandares/std-007-convencion-naming`).
- Ubicación: artefacto vivo del proyecto, en branch correspondiente
  o en el WP de trabajo asociado.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``pm-executing`` (PMBOK)
 * - **Templates relacionados**
   - :doc:`tpl-deployment-guide-deployment`, :doc:`tpl-troubleshooting-runbook`
 * - **STD aplicable**
   - :doc:`/normativa/estandares/std-007-convencion-naming`
