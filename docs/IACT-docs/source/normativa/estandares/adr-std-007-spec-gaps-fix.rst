.. meta::
 :artefacto: ADR_STD_007_SPEC_GAPS_FIX
 :tipo: ADR
 :dominio: normativa
 :subdominio: estandares
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================================
ADR STD-007: Spec Gaps Fix (v2.0.2)
==========================================================

.. note::

 Migrado a source/ desde ADR histórico del WP origen.
 Aplica skill ``cp-recommend``. Origen del bump STD-007
 v2.0.1 → v2.0.2.

1. Contexto
===========

Tras STD-007 v2.0.1 (asignación módulos REQ/DOC + STDs 008/009),
deep-review adversarial identificó 13 findings (F-01..F-13).
Bloque A del WP ``std007-spec-gaps-cleanup`` triageó cada uno y
produjo inventarios verificados.

Este ADR documenta las **7 decisiones de spec** que se materializan
en STD-007 v2.0.1 → v2.0.2 (PATCH compatible — no rompe el
commitment de 30 días iniciado en v2.0.0).

2. Decisión 1 — F-01: 9 ``procedimiento-*`` → ``proc-<MOD>-<NNN>``
==================================================================

.. list-table::
 :widths: 38 50 12
 :header-rows: 1

 * - Origen
   - Destino
   - MOD
 * - procedimiento-analisis-seguridad
   - proc-qa-003-analisis-seguridad
   - qa
 * - procedimiento-desarrollo-local
   - proc-dev-003-desarrollo-local
   - dev
 * - procedimiento-diseno-tecnico
   - proc-dev-004-diseno-tecnico
   - dev
 * - procedimiento-gestion-cambios
   - proc-gob-011-gestion-cambios
   - gob
 * - procedimiento-instalacion-entorno
   - proc-ops-003-instalacion-entorno
   - ops
 * - procedimiento-qa
   - proc-qa-004-qa
   - qa
 * - procedimiento-release
   - proc-devops-002-release
   - devops
 * - procedimiento-revision-documental
   - proc-gob-012-revision-documental
   - gob
 * - procedimiento-trazabilidad-requisitos
   - proc-req-019-trazabilidad-requisitos
   - req

**Acción física en Bloque C.**

3. Decisión 2 — F-02: documentar ``arq`` prefix con módulo ``mod``
==================================================================

Los 8 archivos ``arq-mod-NNN-*`` se mantienen sin renombrar.
STD-007 v2.0.2 § 4 documenta:

::

 Prefijo: arq
 Tipo: Documento de arquitectura técnica
 Módulos válidos: mod (módulo funcional). Reservados para
                  futuro: svc (servicio), comp (componente).
 Patrón: arq-<mod>-<NNN>-<desc>.rst

**Acción física: 0 archivos** (decisión sin renames).

4. Decisión 3 — F-03: módulos canónicos para ``adr-`` y ``rnf-``
================================================================

STD-007 v2.0.2 § 4 extiende las tablas de módulos:

**``adr-``** (Architecture Decision Record):

::

 back, front, devops, gob, qa
 Reservados futuros: ops, req, doc

**``rnf-``** (Requisito No Funcional):

::

 proc (procesos del sistema/SDLC)
 Reservados futuros: sec (seguridad), perf (performance), avail

**Acción física: 0 archivos** (sólo extensión de spec).

5. Decisión 4 — F-04: clarificar scope de la convención
=======================================================

STD-007 v2.0.2 § 2 agrega nota explícita:

  Esta convención aplica a **filenames y dirnames únicamente**.
  Los campos de metadata YAML (``:artefacto:``, ``:tipo:``,
  ``:dominio:``, etc.) son **códigos semánticos del artefacto**
  y permanecen en su formato propio (PascalCase, snake_case,
  abreviaturas) según el schema canónico de metadata. La
  convención de naming NO regula el contenido de metadata.

6. Decisión 5 — F-05: política de filenames únicos
==================================================

STD-007 v2.0.2 § 3 agrega regla y excepción documentada:

**Regla:** los filenames ``.rst`` deben ser únicos en todo
``source/`` para evitar ambigüedad en ``:doc:`` refs relativas.

**Excepción:** archivos paralelos intencionales en dominios
mirror (frontend/backend, etl-pipeline en dominios distintos).
Documentar el caso paralelo en el toctree padre o en metadata.

Casos actuales aceptados:

::

 conventions.rst   en {frontend,backend}/      — convenciones espejo
 overview.rst      en {frontend,backend}/      — overview espejo
 etl-pipeline.rst  en {databases,plantuml-guide/ejemplos}/ — distinto contexto

**Acción física: 0 archivos.**

7. Decisión 6 — F-06: guías sin prefijo en directorios temáticos
================================================================

STD-007 v2.0.2 § 4.4 clarifica:

  Los archivos sin prefijo (``<descripcion-kebab>.rst``) pueden
  coexistir con artefactos numerados en directorios temáticos
  cuando son **guías normativas** complementarias. La distinción
  categorial vive en ``:tipo: Guia`` vs ``:tipo: Estándar`` del
  frontmatter, no en el directorio.

Casos actuales aceptados:

::

 source/normativa/estandares/guia-estilo.rst         (:tipo: Guia)
 source/normativa/estandares/estandares-codigo.rst   (:tipo: Guia)
 source/normativa/estandares/shell-scripting-guide.rst (:tipo: Guia)

**Acción física: 0 archivos.**

8. Decisión 7 — F-13: schema canónico de metadata YAML
======================================================

STD-007 v2.0.2 § 6 (nueva sección) define el schema único para
frontmatter ``.. meta::`` en ``source/``:

8.1 Campos obligatorios
-----------------------

.. list-table::
 :widths: 22 38 40
 :header-rows: 1

 * - Campo
   - Tipo
   - Ejemplo
 * - ``:artefacto:``
   - ID semántico (PascalCase/UPPER)
   - ``STD_007``, ``UC_ACC_01``, ``BR_009``
 * - ``:tipo:``
   - Categoría (PascalCase)
   - ``Estándar``, ``Caso de Uso``, ``Regla de Negocio``, ``Guia``
 * - ``:dominio:``
   - Top-level dir
   - ``normativa``, ``requisitos``, ``arquitectura``
 * - ``:subdominio:``
   - Sub-categoría
   - ``estandares``, ``casos-uso``, ``procedimientos``
 * - ``:estado:``
   - Lifecycle status
   - ``Borrador``, ``En Revisión``, ``Aprobado``, ``Deprecado``
 * - ``:version:``
   - SemVer 2.0.0
   - ``1.0.0``, ``2.0.1``
 * - ``:fecha_creacion:``
   - ISO date
   - ``2026-04-29``
 * - ``:autor:``
   - Equipo o persona
   - ``Equipo IACT``, ``NestorMonroy``

8.2 Campos recomendados
-----------------------

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Campo
   - Cuándo
 * - ``:ultimo_cambio:``
   - Si difiere de ``:fecha_creacion:``
 * - ``:clasificacion:``
   - ``Interno``, ``Público``, ``Confidencial``
 * - ``:normativa:``
   - Cross-refs a CNSTs aplicables (UCs, FRs)

8.3 Schema legacy UC (DEPRECADO)
--------------------------------

49 archivos UC/FR usan schema legacy:

.. list-table::
 :widths: 30 10 60
 :header-rows: 1

 * - Legacy
   - →
   - Canonical
 * - ``:uc_id:``
   - →
   - ``:artefacto:``
 * - ``:date:``
   - →
   - ``:fecha_creacion:``
 * - ``:status:``
   - →
   - ``:estado:``
 * - ``:module:``
   - →
   - ``:subdominio:``
 * - ``:project:``
   - →
   - (eliminar — redundante con repo)

**Acción física en Bloque E.1:** migrar 49 archivos al schema
canónico vía mapping 1:1.

9. Salvaguarda anti norm-churn
==============================

**v2.0.2 es PATCH compatible** — no modifica el patrón universal
§ 3 ni reglas establecidas en v2.0.0/v2.0.1. Sólo:

- Extiende § 4 con prefijos/módulos previamente sin documentar
  pero ya en uso (``arq``, ``adr-back/front``, ``rnf-proc``).
- Agrega § 6 documentando schema de metadata previamente
  implícito.
- Clarifica scope en § 2 y excepciones aceptables en § 3 / § 4.4.

**El commitment de 30 días sigue vigente** (cierre 2026-05-29
desde v2.0.0). Las extensiones de v2.0.2 son **clarificaciones**,
no cambios al patrón.

10. Consecuencias
=================

**Positivas:**

- 100% del corpus cumple spec (la spec ahora cubre todo lo que el
  corpus usa).
- Schema de metadata documentado previene drift futuro.
- Reduce footprint de cambios físicos: F-02, F-05, F-06 sin
  renames.

**Costo:**

- 9 renames (F-01).
- 49 archivos migrar schema (F-13).
- 5 archivos fix MD residual (F-10).
- ~30 archivos completar metadata (F-07/F-08/F-09).

11. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``cp-recommend`` (Consulting Process — Recommend)
 * - **WP origen**
   - ``2026-04-29-16-17-35-std007-spec-gaps-cleanup``
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **ADRs previos**
   - | :doc:`adr-std-007-naming-kebab-correction` (v2.0.0)
     | :doc:`adr-std-007-procedimientos-modulos-req-doc` (v2.0.1)
 * - **Estándar referenciado**
   - :doc:`std-007-convencion-naming` (v2.0.2+)
