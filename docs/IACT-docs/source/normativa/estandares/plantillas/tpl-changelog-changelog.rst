.. meta::
 :artefacto: TPL_CHANGELOG
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================
TPL_CHANGELOG: Plantilla de Changelog
==========================================

.. note::

 Plantilla para changelog de release siguiendo formato
 `Keep a Changelog <https://keepachangelog.com/>`__.
 Aplica skill ``pm-executing``.

1. Estructura por release
=========================

Cada versión documenta cambios bajo categorías estandarizadas.

::

 ## [X.Y.Z] - YYYY-MM-DD

 ### Added
 - Funcionalidades nuevas.

 ### Changed
 - Cambios en funcionalidad existente.

 ### Deprecated
 - Funcionalidades marcadas para remoción.

 ### Removed
 - Funcionalidades eliminadas.

 ### Fixed
 - Bug fixes.

 ### Security
 - Vulnerabilidades corregidas.

2. Reglas
=========

- **Cronológico inverso:** versión más reciente arriba.
- **Solo cambios visibles para usuarios** del producto/API.
- **No cambios internos** (refactor sin cambio de comportamiento).
- **SemVer:** `[X.Y.Z]` cumple Semantic Versioning 2.0.0.
- **Trazabilidad:** cada entry con referencia a issue/PR.

3. Ejemplo
==========

::

 ## [1.5.0] - 2026-Q3

 ### Added
 - Dark mode toggle (RF-001-dark-mode-toggle).
 - Persistencia de preferencia visual (RF-002-dark-mode-persistence).

 ### Changed
 - Toggle aplica modo sin recarga de página.

 ### Fixed
 - FOUC en login eliminado.

4. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``pm-executing`` (PMBOK)
 * - **Convención**
   - Keep a Changelog (keepachangelog.com)
 * - **Templates relacionados**
   - :doc:`tpl-release-plan-release-management`
