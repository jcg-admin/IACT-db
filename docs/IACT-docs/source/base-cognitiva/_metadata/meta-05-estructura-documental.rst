.. meta::
 :artefacto: META_05
 :tipo: Estructura
 :dominio: base_cognitiva
 :subdominio: _metadata
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2025-12-18
 :ultimo_cambio: 2026-04-28
 :autor: PMO IACT
 :clasificacion: Interno

.. _meta-05:
.. _meta_05_estructura_documental:

===============================
META_05 · Estructura Documental
===============================

1. Propósito
------------

Este documento presenta el mapa completo de la estructura documental
del proyecto IACT, organizada en **3 capas ortogonales** según la
arquitectura v2.0 del rebuild de ``source/`` (ÉPICA 8 ``source-rebuild-strategy``).
Proporciona navegación rápida y visión global del sistema.

--------------------

2. Resumen Ejecutivo
--------------------

.. list-table::
 :widths: 40 60
 :header-rows: 0
 :stub-columns: 1

 * - Capas ortogonales
   - 3
 * - Cajones top-level (suma de las 3 capas)
   - 16
 * - Capa 1 (Methodology / Governance)
   - 2 cajones
 * - Capa 2 (Spec + Tech implementation)
   - 10 cajones
 * - Capa 3 (Project lifecycle)
   - 1 cajón con sub-cajones
 * - Versión de la arquitectura
   - v2.0 (ÉPICA 8, 2026-04-28)

-----------------------------

3. Las tres capas ortogonales
-----------------------------

3.1. Capa 1 — Methodology / Governance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** define el cómo se trabaja — vocabulario base,
estándares, plantillas, procedimientos, restricciones, ADRs internos.

**Cajones:**

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Cajón
   - Contenido
 * - ``base_cognitiva/``
   - **Este cajón.** Glosarios + fundamentos conceptuales + ontología
     SBVR + metadata + taxonomías y metamodelos. Provee el vocabulario
     que todos los demás cajones consumen.
 * - ``normativa/``
   - Estándares (STDs), plantillas (TPLs), procedimientos (PROCs),
     restricciones (CNSTs), gobernanza (ADRs internos del proyecto).

3.2. Capa 2 — Product spec + Tech implementation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** especifica el producto IACT y documenta su
implementación por tier técnico.

**Cajones de spec:**

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Cajón
   - Contenido
 * - ``requisitos/``
   - Casos de uso (UCs), requisitos funcionales (FRs), no-funcionales
     (NFRs), reglas de negocio (BRs).
 * - ``arquitectura_tecnica/``
   - Visión arquitectónica de alto nivel, decisiones técnicas
     transversales, vistas, diagramas (incluye plantuml-guide
     absorbido).

**Cajones de implementation por tier:**

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Cajón
   - Tier
 * - ``backend/``
   - Django REST Framework (Python 3.11+).
 * - ``frontend/``
   - React + Webpack.
 * - ``infrastructure/``
   - Ubuntu + Apache (mod_wsgi).
 * - ``databases/``
   - MySQL (operativa, RO) + PostgreSQL (analítica).
 * - ``operations/``
   - Deployment, monitoring, runbooks, incident response.
 * - ``onboarding/``
   - Quickstart de developers, local dev setup, first contribution.
 * - ``quality/``
   - Estrategia de testing (unit, integration, e2e), coverage.
 * - ``risks-technical-debt/``
   - Tech debt log público + risks register técnico.

3.3. Capa 3 — Project lifecycle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** documenta cómo se gestiona el proyecto a lo largo
del tiempo.

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Cajón
   - Contenido
 * - ``gestion/``
   - Sub-cajones de lifecycle: ``charter/``, ``roadmap/``,
     ``okrs/``, ``epicas/``, ``sprints/``, ``releases/``,
     ``retrospectives/``, ``team/``.

-------------------------

4. Reglas de organización
-------------------------

4.1. Naming
^^^^^^^^^^^

Aplica el estándar **STD_007 — Convención de Naming de Archivos
y Carpetas** (definido en ``normativa/estandares/``).
Reglas clave:

- snake_case para directorios.
- Prefijo ``_`` para sub-dominios de referencia interna
  (ej: ``base_cognitiva/_fundamentos_conceptuales/``).
- Sin tildes, ñ, espacios o paréntesis en filenames.
- Versiones en metadata YAML, **no** en filename.

4.2. Punto de entrada
^^^^^^^^^^^^^^^^^^^^^

Cada directorio tiene ``index.rst`` (no ``README.rst``). Sphinx
usa ``index.rst`` como entry-point por convención.

4.3. Versionado de documentos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aplica el estándar **STD_006 — Versionado Semántico** (definido
en ``normativa/estandares/``). Versión va en el campo
``:version:`` del metadata YAML.

4.4. Documentación publicable vs. tooling interno
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``source/`` contiene únicamente documentación publicable del
producto y del proyecto. El tooling interno de gestión (planes,
estados de iniciativas, decisiones internas en proceso) vive en
otros directorios del repositorio fuera del scope de Sphinx, y
no se referencia desde aquí. Si una decisión o aprendizaje
gestado internamente debe llegar al sitio público, se re-autora
a mano en RST en el cajón correspondiente de ``source/``.

-----------------------------

5. Dependencias entre cajones
-----------------------------

Reglas de referencia ``:doc:`` y ``:ref:`` entre cajones:

.. code-block:: text

 base_cognitiva/ → todos (vocabulario)
 normativa/ → todos (reglas, plantillas)
 requisitos/ → backend, frontend, ... (UCs implementables)
 arquitectura_tecnica/ → backend, frontend, ... (decisiones)
 operations/ → backend, frontend, ... (runbooks)
 quality/ → backend, frontend, ... (testing strategy)

Refs cruzadas usan ``:ref:`` con anchor explícito (no ``:doc:``
con path) — robustez frente a futuros renombres.

--------------------------------------------

6. Construcción incremental de la estructura
--------------------------------------------

La estructura v2.0 se construye de forma **incremental dominio
por dominio**. Cada dominio entra al toctree raíz cuando su
contenido inicial está listo. Hasta entonces, el cajón puede no
estar presente en la navegación pública aunque exista físicamente.

------------

7. Historial
------------

.. list-table::
 :header-rows: 1
 :widths: 12 12 76

 * - Versión
   - Fecha
   - Cambios
 * - 1.0.0
   - 2025-12-18
   - Versión inicial: estructura de 5 dominios primarios + 21
     subdominios + 6 subcarpetas organizativas.
 * - 2.0.0
   - 2026-04-28
   - **Bump MAJOR.** Re-escritura completa para reflejar la
     arquitectura v2.0 del rebuild (ÉPICA 8). Cambios:
     (a) introducción de las 3 capas ortogonales; (b) 16 cajones
     top-level (de 6 anteriores); (c) cajones técnicos nuevos
     por tier (backend, frontend, infrastructure, databases,
     operations, onboarding, quality, risks-technical-debt);
     (d) ``gestion/`` expandido con sub-cajones de lifecycle;
     (e) regla que separa documentación publicable del tooling
     interno de gestión.
