.. meta::
 :artefacto: PROC_GOB_001
 :tipo: Procedimiento
 :dominio: normativa
 :subdominio: procedimientos
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================================
PROC_GOB_001: Mapeo Procedimientos ↔ Templates ↔ Workflows
==========================================================

.. note::

 **Versión 2.0.0 (reescrita desde cero el 2026-04-30).** Este
 documento mapea explícitamente la relación entre procedimientos
 operativos, templates documentales, checklists y workflows
 CI/CD del proyecto IACT. Todos los enlaces son navegables
 (:doc: refs); no quedan referencias a archivos que no existen.

1. Propósito
============

Este documento es la **matriz maestra** del ecosistema documental
del proyecto IACT. Permite a cualquier miembro del equipo saber
qué procedimiento seguir, qué template usar, qué checklist
validar y qué workflow CI/CD se ejecutará automáticamente en
cada fase del ciclo de vida.

**Audiencia:** Business Analysts, Product Owners, Tech Leads,
DevOps, QA, todo el equipo SDLC.

----

2. Visión general del ecosistema
================================

El ecosistema IACT integra cinco capas:

::

  ┌────────────────────────────────────────────────────────┐
  │                  ECOSISTEMA IACT                       │
  ├────────────────────────────────────────────────────────┤
  │                                                        │
  │  PROCEDIMIENTOS ──────────► TEMPLATES                  │
  │   (manuales)                (artefactos canónicos)     │
  │       │                          │                     │
  │       │                          │                     │
  │       ▼                          ▼                     │
  │  CHECKLISTS ─────────► ARTEFACTOS DOCUMENTALES         │
  │   (validación)         (entregables firmados)          │
  │                                                        │
  │  WORKFLOWS CI/CD + SCRIPTS shell (automatización)      │
  │  ─────────────────────────────────────────────────     │
  │                                                        │
  │  RUNBOOKS (operación de incidentes)                    │
  │                                                        │
  └────────────────────────────────────────────────────────┘

**Flujo típico:**

1. Developer sigue un :doc:`procedimiento </normativa/procedimientos/index>`.
2. Usa un :doc:`template </normativa/estandares/plantillas/index>` para crear el artefacto.
3. Valida con :doc:`checklist </gestion/pm/checklists/index>` aplicable.
4. Push → workflow CI/CD se ejecuta automáticamente
   (ver :doc:`/normativa/procedimientos/proc-devops-001-devops-automation`).
5. Si hay incidente operacional → :doc:`runbook </devops/runbooks/index>`.

----

3. Inventario del ecosistema
============================

3.1 Procedimientos operativos
-----------------------------

.. list-table::
 :header-rows: 1
 :widths: 30 50 20

 * - Procedimiento
   - Descripción
   - Doc canónico
 * - Aseguramiento de calidad
   - Procesos QA del producto
   - :doc:`/normativa/procedimientos/proc-qa-004-qa`
 * - Estrategia de QA
   - Hoja de ruta de calidad
   - :doc:`/normativa/procedimientos/proc-qa-002-estrategia-qa`
 * - Análisis de seguridad
   - Scan y revisión de seguridad
   - :doc:`/normativa/procedimientos/proc-qa-003-analisis-seguridad`
 * - Release y deployment
   - Procedimiento de release
   - :doc:`/normativa/procedimientos/proc-devops-002-release`
 * - DevOps automation
   - Automatización con scripts locales
   - :doc:`/normativa/procedimientos/proc-devops-001-devops-automation`
 * - Diseño técnico detallado
   - Documentar HLD/LLD
   - :doc:`/normativa/procedimientos/proc-dev-004-diseno-tecnico`
 * - Desarrollo local
   - Setup y workflow de dev
   - :doc:`/normativa/procedimientos/proc-dev-003-desarrollo-local`
 * - Gestión de cambios
   - Cambios documentales
   - :doc:`/normativa/procedimientos/proc-gob-011-gestion-cambios`
 * - Trazabilidad de requisitos
   - Linking BR → UC → FR
   - :doc:`/normativa/procedimientos/proc-req-019-trazabilidad-requisitos`
 * - Instalación de entorno
   - Setup de ambientes
   - :doc:`/normativa/procedimientos/proc-ops-003-instalacion-entorno`
 * - Revisión documental
   - QA documental periódico
   - :doc:`/normativa/procedimientos/proc-gob-012-revision-documental`

3.2 Templates documentales
--------------------------

Catálogo completo en
:doc:`/normativa/estandares/plantillas/index`.

Categorías:

- **Spec — Requisitos:** breq, br, fr, nfr, decisión, query SQL, validación.
- **Casos de Uso (7 patrones):** general, construcción 7 pasos, actor secundario, CRUD, Larman, stakeholder-driven, temporal, UI-driven.
- **Trazabilidad:** matriz RTM.
- **Arquitectura técnica:** ADR, API, CNST, FD, MOD, vistas arquitectónicas.
- **Gobernanza:** index, política, procedimiento, estándar, pruebas.
- **Diseño de software:** SAD (HLD), SRS (LLD).
- **Release y operaciones:** release plan, deployment guide, troubleshooting.
- **Project Management (PMBOK):** business case, project charter, project management plan, stakeholder analysis, requisito stakeholder, changelog.
- **Setup y entornos:** setup entorno, setup QA.
- **Implementación técnica:** Django app, ETL job, UI/UX, manual usuario.

3.3 Checklists
--------------

.. list-table::
 :header-rows: 1
 :widths: 40 60

 * - Checklist
   - Doc canónico
 * - Desarrollo
   - :doc:`/gestion/pm/checklists/checklist-desarrollo`
 * - Testing
   - :doc:`/gestion/pm/checklists/checklist-testing`
 * - Trazabilidad de requisitos
   - :doc:`/gestion/pm/checklists/checklist-trazabilidad-requisitos`
 * - Cambios documentales
   - :doc:`/gestion/pm/checklists/checklist-cambios-documentales`

3.4 Runbooks operacionales
--------------------------

.. list-table::
 :header-rows: 1
 :widths: 40 60

 * - Runbook
   - Doc canónico
 * - Verificar servicios
   - :doc:`/devops/runbooks/runbook-verificar-servicios`
 * - Reprocesar ETL fallido
   - :doc:`/devops/runbooks/runbook-reprocesar-etl-fallido`

3.5 Workflows CI/CD (archivos del repo)
---------------------------------------

Los workflows YAML viven en ``.github/workflows/`` (o equivalente
del repo) — NO son docs Sphinx. La gobernanza de su uso y
configuración vive en
:doc:`/normativa/procedimientos/proc-devops-001-devops-automation`.

.. list-table::
 :header-rows: 1
 :widths: 25 35 40

 * - Workflow
   - Script local invocado
   - Validaciones que ejecuta
 * - ``backend-ci.yml``
   - ``backend_test.sh``
   - Tests, coverage ≥ 80% (RNF-002), lint
 * - ``frontend-ci.yml``
   - ``frontend_test.sh``
   - Tests, lint, build
 * - ``test-pyramid.yml``
   - ``test_pyramid_check.sh``
   - 60% Unit / 30% Integration / 10% E2E
 * - ``deploy.yml``
   - —
   - Blue-green, health checks, rollback
 * - ``migrations.yml``
   - —
   - Dry-run, conflicts, backwards compatibility
 * - ``infrastructure-ci.yml``
   - —
   - Validación de provisioning
 * - ``security-scan.yml``
   - ``security_scan.sh``
   - Bandit, secrets, SQL injection (RNF-002)
 * - ``incident-response.yml``
   - —
   - Auto-rollback, alertas, post-mortem

----

4. Mapeo por fase SDLC
======================

El ciclo de vida del proyecto IACT cubre 7 fases. Cada fase usa
procedimientos específicos, genera artefactos con templates
canónicos, y valida con checklists.

4.1 Fase 1 — Planning & Requirements
------------------------------------

**Responsable:** Business Analyst, Product Owner.

**Objetivo:** identificar necesidad, derivar requisitos.

**Procedimientos aplicables:**

- :doc:`/normativa/procedimientos/proc-req-019-trazabilidad-requisitos`

**Templates a usar:**

- :doc:`/normativa/estandares/plantillas/tpl-bc-business-case`
- :doc:`/normativa/estandares/plantillas/tpl-pc-project-charter`
- :doc:`/normativa/estandares/plantillas/tpl-stk-stakeholder-analysis`
- :doc:`/normativa/estandares/plantillas/tpl-rs-requisito-stakeholder`
- :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
- :doc:`/normativa/estandares/plantillas/tpl-br-business-rules`
- :doc:`/normativa/estandares/plantillas/tpl-fr-requisitos-funcionales`
- :doc:`/normativa/estandares/plantillas/tpl-nfr-no-funcionales`

**Checklists:**

- :doc:`/gestion/pm/checklists/checklist-trazabilidad-requisitos`

**Workflows CI/CD:** ninguno (fase pre-desarrollo).

4.2 Fase 2 — Feasibility & Design
---------------------------------

**Responsable:** Architect, Tech Lead, BA.

**Procedimientos aplicables:**

- :doc:`/normativa/procedimientos/proc-dev-004-diseno-tecnico`

**Templates a usar:**

- :doc:`/normativa/estandares/plantillas/tpl-sad-arquitectura-software` (HLD)
- :doc:`/normativa/estandares/plantillas/tpl-srs-software-requirements-spec` (LLD)
- :doc:`/normativa/estandares/plantillas/tpl-mod-modulos`
- :doc:`/normativa/estandares/plantillas/tpl-fd-flujos-datos`
- :doc:`/normativa/estandares/plantillas/tpl-adr-decisiones-arquitectonicas`
- :doc:`/normativa/estandares/plantillas/tpl-cnst-restricciones`
- :doc:`/normativa/estandares/plantillas/tpl-view-vistas-arquitectonicas`

4.3 Fase 3 — Implementation
---------------------------

**Responsable:** Developers, Tech Leads.

**Procedimientos aplicables:**

- :doc:`/normativa/procedimientos/proc-dev-003-desarrollo-local`
- :doc:`/normativa/procedimientos/proc-ops-003-instalacion-entorno`

**Templates a usar:**

- :doc:`/normativa/estandares/plantillas/tpl-django-app-django-app`
- :doc:`/normativa/estandares/plantillas/tpl-etl-job-etl-job`
- :doc:`/normativa/estandares/plantillas/tpl-setup-entorno-setup`
- :doc:`/normativa/estandares/plantillas/tpl-ui-ux-ui-ux`
- :doc:`/normativa/estandares/plantillas/tpl-api-documentacion-api`

**Checklists:**

- :doc:`/gestion/pm/checklists/checklist-desarrollo`

**Workflows CI/CD:**

- ``backend-ci.yml``, ``frontend-ci.yml``, ``infrastructure-ci.yml``.

4.4 Fase 4 — Testing
--------------------

**Responsable:** QA Engineers, Developers.

**Procedimientos aplicables:**

- :doc:`/normativa/procedimientos/proc-qa-004-qa`
- :doc:`/normativa/procedimientos/proc-qa-002-estrategia-qa`
- :doc:`/normativa/procedimientos/proc-qa-003-analisis-seguridad`

**Templates a usar:**

- :doc:`/normativa/estandares/plantillas/tpl-tst-pruebas`
- :doc:`/normativa/estandares/plantillas/tpl-setup-qa-setup`

**Checklists:**

- :doc:`/gestion/pm/checklists/checklist-testing`

**Workflows CI/CD:**

- ``test-pyramid.yml``, ``security-scan.yml``.

4.5 Fase 5 — Deployment
-----------------------

**Responsable:** DevOps, Tech Leads.

**Procedimientos aplicables:**

- :doc:`/normativa/procedimientos/proc-devops-002-release`
- :doc:`/normativa/procedimientos/proc-devops-001-devops-automation`

**Templates a usar:**

- :doc:`/normativa/estandares/plantillas/tpl-release-plan-release-management`
- :doc:`/normativa/estandares/plantillas/tpl-deployment-guide-deployment`
- :doc:`/normativa/estandares/plantillas/tpl-changelog-changelog`

**Workflows CI/CD:**

- ``deploy.yml``, ``migrations.yml``.

4.6 Fase 6 — Maintenance & Operations
-------------------------------------

**Responsable:** DevOps, Soporte, SRE.

**Procedimientos aplicables:**

- :doc:`/normativa/procedimientos/proc-gob-011-gestion-cambios`
- :doc:`/normativa/procedimientos/proc-gob-012-revision-documental`

**Templates a usar:**

- :doc:`/normativa/estandares/plantillas/tpl-troubleshooting-runbook`
- :doc:`/normativa/estandares/plantillas/tpl-mu-manual-usuario`

**Runbooks operacionales:**

- :doc:`/devops/runbooks/runbook-verificar-servicios`
- :doc:`/devops/runbooks/runbook-reprocesar-etl-fallido`

**Workflows CI/CD:**

- ``incident-response.yml``.

4.7 Fase 7 — Documentación transversal
--------------------------------------

**Responsable:** todo el equipo, según artefacto.

**Templates de gobernanza siempre disponibles:**

- :doc:`/normativa/estandares/plantillas/tpl-index-indices`
- :doc:`/normativa/estandares/plantillas/tpl-pol-politicas`
- :doc:`/normativa/estandares/plantillas/tpl-proc-procedimientos`
- :doc:`/normativa/estandares/plantillas/tpl-std-estandares`
- :doc:`/normativa/estandares/plantillas/tpl-trz-matriz-rtm`

----

5. Decision tree: ¿qué template usar?
=====================================

::

  ¿Qué tipo de artefacto vas a generar?
  │
  ├─► Necesidad / problema de negocio
  │     └─► tpl-breq-objetivos-negocio + tpl-bc-business-case
  │
  ├─► Decisión arquitectónica
  │     └─► tpl-adr-decisiones-arquitectonicas
  │
  ├─► Caso de uso
  │     ├─► CRUD simple → tpl-uc-crud-operaciones
  │     ├─► Conducido por stakeholder → tpl-uc-stakeholder-driven
  │     ├─► Larman con contratos → tpl-uc-larman-contratos
  │     ├─► Temporal / scheduler → tpl-uc-temporal-schedulers
  │     ├─► UI-driven → tpl-uc-ui-driven
  │     └─► General → tpl-uc-casos-de-uso
  │
  ├─► Diseño técnico
  │     ├─► Alto nivel (HLD) → tpl-sad-arquitectura-software
  │     ├─► Bajo nivel (LLD) → tpl-srs-software-requirements-spec
  │     └─► Schema BD → tpl-mod-modulos
  │
  ├─► Pruebas
  │     └─► tpl-tst-pruebas (cubre plan + casos)
  │
  ├─► Release / Deployment
  │     ├─► Plan de release → tpl-release-plan-release-management
  │     ├─► Guía de deployment → tpl-deployment-guide-deployment
  │     └─► Changelog → tpl-changelog-changelog
  │
  └─► Operaciones / Incidentes
        ├─► Runbook → tpl-troubleshooting-runbook
        └─► Manual usuario → tpl-mu-manual-usuario

----

6. Ejemplo SDLC end-to-end
==========================

.. admonition:: Ejemplo SDLC end-to-end (saga dark-mode)
   :class: tip

   El flujo completo SDLC aplicado a una feature concreta vive en
   la saga pedagógica
   :doc:`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/index`.

   Esta saga muestra los **14 artefactos** generados desde la
   necesidad inicial (BN-001) hasta el deployment a staging,
   recorriendo las 7 fases SDLC. Cada artefacto declara la
   ``:skill_aplicada:`` y la ``:fase_sdlc:`` correspondiente.

   **Recorrido:** descubrimiento → análisis → especificación →
   diseño → implementación → pruebas → release → deployment.

----

7. Trazabilidad y referencias cruzadas
======================================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **STDs aplicables**
   - :doc:`/normativa/estandares/std-007-convencion-naming`,
     :doc:`/normativa/estandares/std-006-versionado-semantico`
 * - **Skills metodológicas**
   - ``ba-elicitation``, ``rm-specification``, ``bpa-design``,
     ``pm-planning``, ``pm-executing``, ``dmaic-control``,
     ``cp-recommend`` (entre otras)
 * - **Documento padre**
   - :doc:`/normativa/procedimientos/proc-gob-002-gobernanza-sdlc`

----

8. Historial de cambios
=======================

.. list-table::
 :header-rows: 1
 :widths: 12 15 73

 * - Versión
   - Fecha
   - Cambios
 * - 1.0.0
   - 2026-01-07
   - Versión inicial migrada de temp-holding (con 179 referencias
     a archivos no-existentes — herencia del estado pre-Sphinx).
 * - 2.0.0
   - 2026-04-30
   - **Reescritura desde cero.** Eliminadas 179 referencias a
     archivos no-resueltos (formato Markdown legacy).
     no-resueltas. Mapeo completo a :doc: navegables. Eliminadas
     menciones a agentes SDLC especulativos. Sección dark-mode
     reemplazada por admonition con link a saga pedagógica real.
     Líneas: 1409 → ~340 (-76%). 12 templates faltantes
     importados desde temp-holding al schema STD-007.
