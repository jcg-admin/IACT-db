.. meta::
 :artefacto: STD_007
 :tipo: Estándar
 :dominio: normativa
 :subdominio: estandares
 :estado: Aprobado
 :version: 2.0.2
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _std-007:

====================================================
STD_007: Convención de Naming de Archivos y Carpetas
====================================================


1. Propósito
------------

Establecer las reglas obligatorias de nomenclatura para **todos los
archivos y directorios** de la documentación del proyecto IACT que viven
bajo ``source/``. Garantiza:

- Consistencia entre dominios (procedimientos, gobernanza, requisitos,
  etc.).
- Compatibilidad cross-platform (Windows NTFS, macOS HFS+ son
  case-insensitive — sin uppercase no hay riesgo).
- Resolución correcta de URLs HTML rendered (lowercase canonical).
- Resolución correcta de ``:doc:`` y ``:ref:`` (case-sensitive en
  Sphinx).
- Predictibilidad para autores nuevos.
- Reducción de fricción en shell, git, autocompletado y herramientas
  de búsqueda.

----

2. Alcance
----------

Aplica a:

- **Todos los archivos** ``.rst`` bajo ``source/``.
- **Todos los archivos** ``.puml`` referenciados desde ``source/``.
- **Todos los directorios** bajo ``source/``.
- **Todos los archivos** dentro de ``source/_static/`` y
  ``source/_templates/`` (con excepciones documentadas).

NO aplica a:

- Archivos de configuración del proyecto (``conf.py``,
  ``pyproject.toml``, etc.).
- Archivos fuera de ``source/`` (configuración del entorno,
  tooling interno, scripts del repositorio).
- ``LICENSE``, ``CHANGELOG.rst``, ``ROADMAP.rst``, ``readme.rst`` en raíz.
- **Campos de metadata YAML** dentro de archivos (``:artefacto:``,
  ``:tipo:``, ``:dominio:``, etc.). Son **códigos semánticos del
  artefacto**, no filenames — siguen su schema canónico documentado
  en §6 (PascalCase, snake_case, abreviaturas según el campo).

----

3. Reglas Universales (aplican a TODO bajo source/)
---------------------------------------------------

3.1 Patrón Único
^^^^^^^^^^^^^^^^

**Toda la nomenclatura sigue una sola regla:**

- **Minúsculas exclusivamente** (``a-z``, ``0-9``).
- **Guión medio** (``-``) como único separador en descripciones.
- **Sin underscore** en descripciones (excepto en directorios internos
  Sphinx, §5.2).
- **Sin MAYÚSCULAS** en ningún componente.

**Patrón canónico de archivos numerados:**

::

  <prefix>-<NNN>-<descripcion-kebab>.rst

**Patrón canónico de directorios:**

::

  <descripcion-kebab>/

3.2 Caracteres PROHIBIDOS
^^^^^^^^^^^^^^^^^^^^^^^^^

Los nombres NO DEBEN contener:

- **Espacios** — usar ``-`` en su lugar.
- **MAYÚSCULAS** — todo en minúsculas.
- **Underscore** ``_`` en descripciones (preservado solo para prefijos
  internos Sphinx ``_static``, ``_templates``, ``_metadata``, etc.).
- **Paréntesis** ``(``, ``)``, ``[``, ``]``, ``{``, ``}``.
- **Tildes**: ``á``, ``é``, ``í``, ``ó``, ``ú``, ``ü``.
- **Eñe**: ``ñ``, ``Ñ`` — usar ``n`` o ``ny``.
- **Otros símbolos**: arroba, hash, dolar, porcentaje, ampersand,
  asterisco, signo de pregunta, exclamación, suma, igual, coma,
  punto y coma, dos puntos, comillas (dobles o simples), backtick,
  tilde, pipe, backslash. La barra ``/`` solo se permite como
  separador de path.

**Ejemplos PROHIBIDOS:**

- ``Diagramas de Referencia.rst`` (espacios + mayúsculas)
- ``UC_ACC_01_Asignar_Funciones.rst`` (mayúsculas + underscore)
- ``PROC-DEV-001-pipeline_trabajo_iact.rst`` (mezcla; underscore en
  descripción)
- ``arquitectura_tecnica/`` (underscore en directorio público)
- ``UC_001_Iniciar_Sesion/`` (mayúsculas + underscore)

**Ejemplos CORRECTOS:**

- ``diagramas-de-referencia.rst``
- ``uc-acc-01/index.rst``
- ``proc-dev-001-pipeline-trabajo-iact.rst``
- ``arquitectura-tecnica/``
- ``uc-001-iniciar-sesion/``

3.3 Versión en Filename
^^^^^^^^^^^^^^^^^^^^^^^

NO incluir versión en el nombre del archivo. La versión vive en el
metadata YAML del archivo.

**Prohibido:**

- ``tpl-adr-decisiones-arquitectonicas-1-0-0.rst``
- ``modelo-rbac-v5-2-1.rst``

**Correcto:**

- ``tpl-adr-decisiones-arquitectonicas.rst`` (con ``:version:`` en
  meta YAML).
- ``modelo-rbac.rst``

3.4 Longitud Máxima
^^^^^^^^^^^^^^^^^^^

Filenames ≤ 100 caracteres (incluyendo extensión). Más allá de eso,
usar abreviaciones documentadas o reorganizar el contenido.

3.5 Filenames únicos en source/
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla:** los filenames ``.rst`` deben ser únicos en todo
``source/``. Permite que las refs ``:doc:`relative-path``` resuelvan
sin ambigüedad.

**Excepción documentada:** archivos paralelos intencionales en
dominios mirror son aceptables. La paralelidad debe ser explícita
en el toctree padre o en metadata. Casos actualmente aceptados:

.. list-table::
 :header-rows: 1
 :widths: 30 70

 * - Filename
   - Paths
 * - ``conventions.rst``
   - ``frontend/`` y ``backend/`` (mirror)
 * - ``overview.rst``
   - ``frontend/`` y ``backend/`` (mirror)
 * - ``etl-pipeline.rst``
   - ``databases/`` y ``plantuml-guide/ejemplos/`` (contextos distintos)

Nuevos casos paralelos requieren registro como excepción aquí.

----

4. Patrones por Tipo de Artefacto
----------------------------------

Una sola regla universal: ``<prefix>-<NNN>-<descripcion-kebab>.rst``.
Los prefijos identifican la categoría sin cambiar la convención.

.. list-table::
 :header-rows: 1
 :widths: 18 30 52

 * - Prefijo
   - Tipo
   - Ejemplo
 * - ``uc``
   - Caso de uso (con módulo)
   - ``uc-acc-01/index.rst``
 * - ``br``
   - Regla de negocio
   - ``br-001-fuente-operacional-inmutable.rst``
 * - ``breq``
   - Business requirement
   - ``breq-001-visibilidad-metricas.rst``
 * - ``cnst``
   - Restricción arquitectónica
   - ``cnst-001-prohibicion-de-email-y-smtp.rst``
 * - ``meta``
   - Metadata del proyecto
   - ``meta-01-identidad-proyecto.rst``
 * - ``fnd``
   - Fundamento conceptual
   - ``fnd-01-concepto-requisito.rst``
 * - ``sbvr``
   - Ontología SBVR
   - ``sbvr-01-conceptos-nucleares.rst``
 * - ``mtm``
   - Metamodelo
   - ``mtm-03-metamodelo-rbac.rst``
 * - ``txm``
   - Taxonomía
   - ``txm-01-taxonomia-requisitos.rst``
 * - ``gob``
   - Gobernanza
   - ``gob-01-modelo-gobernanza-iact.rst``
 * - ``std``
   - Estándar
   - ``std-006-versionado-semantico.rst``
 * - ``tpl``
   - Plantilla
   - ``tpl-adr-decisiones-arquitectonicas.rst``
 * - ``adr``
   - Architecture Decision Record (con módulo)
   - ``adr-back-001-grupos-funcionales-sin-jerarquia.rst``
 * - ``proced``
   - Procedimiento de gobernanza (con módulo)
   - ``proced-gob-003-documentar-regla-negocio.rst``
 * - ``proc``
   - Procedimiento (con módulo: dev, devops, ops, qa, gob, req, doc)
   - ``proc-dev-001-pipeline-trabajo-iact.rst``
 * - ``rnf``
   - Requisito no funcional (con módulo)
   - ``rnf-proc-001-proceso-sdlc.rst``
 * - ``fr``
   - Requisito funcional (sub-numerado)
   - ``fr-010-01-listar-funciones-disponibles.rst``
 * - ``arq``
   - Documento de arquitectura técnica (con módulo: mod, futuros svc/comp)
   - ``arq-mod-001-auth.rst``
 * - (sin prefijo)
   - Guía o documento general (puede coexistir en dirs temáticos —
     ver §5.4)
   - ``git-workflow.rst``, ``glosario.rst``, ``guia-estilo.rst``

**Notas:**

- ``<NNN>`` es 2 o 3 dígitos zero-padded según la categoría
  (``01``, ``001``).
- El módulo ``<MOD>`` (cuando aplica) va entre prefijo y número, en
  minúsculas: ``adr-back-001-...``, ``proc-dev-001-...``.
- ``fr`` antes usaba ``FR-NNN.NN`` con punto; en v2.0.0 se reemplaza
  por ``fr-NNN-NN-`` para evitar el punto en filename (Sphinx URL).

**Módulos canónicos para procedimientos (proc/proced):**

.. list-table::
 :header-rows: 1
 :widths: 12 30 58

 * - Módulo
   - Dominio
   - Ejemplo
 * - ``dev``
   - Software development pipeline
   - ``proc-dev-001-pipeline-trabajo-iact.rst``
 * - ``devops``
   - Infraestructura, CI/CD, automatización
   - ``proc-devops-001-devops-automation.rst``
 * - ``ops``
   - Operaciones, deployment, runtime
   - ``proc-ops-001-deployment.rst``
 * - ``qa``
   - Calidad, garantía documental, testing
   - ``proc-qa-001-actividades-garantia-documental.rst``
 * - ``gob``
   - Gobernanza documental — lifecycle: aprobación,
     publicación, congelamiento, auditoría, versionado
   - ``proc-gob-003-aprobacion-documentos.rst``
 * - ``req``
   - Requirements engineering — generación, derivación,
     revisión y cobertura de artefactos de requisitos
     (UC, BR, BReq, CNST, FR, NFR)
   - ``proc-req-007-generacion-uc.rst``
 * - ``doc``
   - Documentation engineering — generación de artefactos
     documentales (no de requisitos): STD, ADR, POL, MOD,
     FD, VIEW, RTM, API, TST, INDEX + tooling Sphinx
   - ``proc-doc-001-generacion-std.rst``

**Módulos canónicos para Architecture Decision Records (adr):**

.. list-table::
 :header-rows: 1
 :widths: 12 30 58

 * - Módulo
   - Dominio
   - Ejemplo
 * - ``back``
   - Backend (servicios, modelos, APIs)
   - ``adr-back-001-grupos-funcionales-sin-jerarquia.rst``
 * - ``front``
   - Frontend (UI, frameworks, bundling)
   - ``adr-front-001-frontend-modular-monolith.rst``
 * - ``devops``
   - Infraestructura, CI/CD, automatización
   - ``adr-devops-001-vagrant-mod-wsgi-importante-produc.rst``
 * - ``gob``
   - Gobernanza documental, naming, organización
   - ``adr-gob-001-organizacion-proyecto-por-dominio.rst``
 * - ``qa``
   - Calidad, testing strategy
   - ``adr-qa-002-testing-strategy-jest-testing-library.rst``

Reservados para futuro: ``ops``, ``req``, ``doc``, ``data``.

**Módulos canónicos para Requisitos No Funcionales (rnf):**

.. list-table::
 :header-rows: 1
 :widths: 12 30 58

 * - Módulo
   - Dominio
   - Ejemplo
 * - ``proc``
   - Procesos del sistema o SDLC (gobernanza del proceso)
   - ``rnf-proc-001-proceso-sdlc.rst``

Reservados para futuro: ``sec`` (seguridad), ``perf``
(performance), ``avail`` (disponibilidad), ``scal`` (escalabilidad).

**Módulos canónicos para Documentos de Arquitectura (arq):**

.. list-table::
 :header-rows: 1
 :widths: 12 30 58

 * - Módulo
   - Dominio
   - Ejemplo
 * - ``mod``
   - Módulo funcional del sistema
   - ``arq-mod-001-auth.rst``

Reservados para futuro: ``svc`` (servicio), ``comp`` (componente).

**Ubicación física de los ADRs por módulo (convención de
directorios):**

Los ADRs viven en el **directorio de su módulo de dominio**,
no en un cajón centralizado. Esto refleja el principio de
organización-por-dominio (ADR-GOB-001).

.. list-table::
 :header-rows: 1
 :widths: 18 42 40

 * - Módulo
   - Directorio destino
   - Razón
 * - ``adr-gob-*``
   - ``source/normativa/gobernanza/``
   - "gob" ES su módulo de dominio
 * - ``adr-back-*``
   - ``source/backend/``
   - Decisiones del backend viven con la doc del backend
 * - ``adr-front-*``
   - ``source/frontend/``
   - Decisiones del frontend viven con la doc del frontend
 * - ``adr-devops-*``
   - ``source/devops/``
   - Decisiones de infraestructura viven con la doc de devops
 * - ``adr-qa-*``
   - ``source/quality/``
   - Decisiones de QA/testing viven con la doc de calidad

Aplicado en el WP ``2026-04-29-22-23-05-adr-domain-reorganization``
(Z.1.A del programa modelo-rbac-improvement).

----

5. Convenciones para Directorios
--------------------------------

5.1 Patrón Universal
^^^^^^^^^^^^^^^^^^^^

``kebab-case`` en minúsculas para todos los directorios públicos.

**Ejemplos correctos:**

- ``arquitectura-tecnica/``
- ``casos-uso/``
- ``reglas-negocio/``
- ``requisitos-funcionales/``
- ``uc-001-iniciar-sesion/``
- ``uc-006-crear-usuario/``

**Ejemplos PROHIBIDOS:**

- ``arquitectura_tecnica/`` (underscore)
- ``UC_001_Iniciar_Sesion/`` (mayúsculas + underscore)
- ``diseño_detallado/`` (ñ + underscore)

5.2 Directorios Internos Sphinx (excepción)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla:** los directorios cuyo prefijo ``_`` los excluye del toctree
público preservan ese prefijo (convención Sphinx). Su contenido sigue
en kebab-case.

**Ejemplos:**

- ``_static/`` (Sphinx asset directory)
- ``_templates/`` (Sphinx template directory)
- ``_metadata/`` (referencia interna)
- ``_fundamentos-conceptuales/`` (kebab interno)
- ``_ontologia-sbvr/``
- ``_taxonomias-y-metamodelos/``

5.3 Punto de Entrada de Directorio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla:** ``index.rst`` (NO ``README.rst``). Es la única excepción
permitida al patrón kebab-lowercase: el nombre ``index`` es palabra
simple en minúsculas y no requiere transformación.

5.4 Guías sin prefijo en directorios temáticos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los archivos sin prefijo (``<descripcion-kebab>.rst``) pueden
coexistir con artefactos numerados en directorios temáticos cuando
son **guías normativas** complementarias. La distinción categorial
vive en el campo ``:tipo:`` del frontmatter (``:tipo: Guia`` vs
``:tipo: Estándar``), no en el directorio.

Casos actualmente aceptados:

.. list-table::
 :header-rows: 1
 :widths: 50 50

 * - Path
   - Justificación
 * - ``normativa/estandares/guia-estilo.rst``
   - Guía de estilo redaccional (:tipo: Guia)
 * - ``normativa/estandares/estandares-codigo.rst``
   - Convenciones de código (:tipo: Guia)
 * - ``normativa/estandares/shell-scripting-guide.rst``
   - Guía operativa de shell (:tipo: Guia)

----

6. Schema Canónico de Metadata YAML
------------------------------------

El frontmatter ``.. meta::`` de cada archivo ``.rst`` bajo
``source/`` sigue el schema canónico definido en esta sección.
Schemas alternativos (legacy UC) están **deprecados** y deben
migrar.

6.1 Campos obligatorios
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 22 28 50

 * - Campo
   - Formato
   - Ejemplo
 * - ``:artefacto:``
   - ID semántico (PascalCase, snake_case, UPPER, abreviaturas
     según convención del artefacto)
   - ``STD_007``, ``UC_ACC_01``, ``BR_009``, ``Guia_Estilo``
 * - ``:tipo:``
   - Categoría en PascalCase
   - ``Estándar``, ``Caso de Uso``, ``Regla de Negocio``,
     ``Guia``, ``Procedimiento``, ``ADR``
 * - ``:dominio:``
   - Top-level dir bajo ``source/`` (kebab)
   - ``normativa``, ``requisitos``, ``arquitectura-tecnica``
 * - ``:subdominio:``
   - Sub-categoría (kebab, suele coincidir con sub-dir)
   - ``estandares``, ``casos-uso``, ``procedimientos``
 * - ``:estado:``
   - Lifecycle status
   - ``Borrador``, ``En Revisión``, ``Aprobado``, ``Deprecado``
 * - ``:version:``
   - SemVer 2.0.0 (ver STD_006)
   - ``1.0.0``, ``2.0.1``
 * - ``:fecha_creacion:``
   - ISO date ``YYYY-MM-DD``
   - ``2026-04-29``
 * - ``:autor:``
   - Equipo o persona
   - ``Equipo IACT``, ``NestorMonroy``

6.2 Campos recomendados
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Campo
   - Cuándo usar
 * - ``:ultimo_cambio:``
   - Si difiere de ``:fecha_creacion:``
 * - ``:clasificacion:``
   - ``Interno`` / ``Público`` / ``Confidencial``
 * - ``:normativa:``
   - Cross-refs a CNSTs aplicables (UCs, FRs)

6.3 Schema legacy UC (DEPRECADO)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Algunos artefactos UC/FR históricos usan un schema alternativo
que **debe migrar** al canónico. Mapeo de equivalencias:

.. list-table::
 :header-rows: 1
 :widths: 30 10 60

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
   - (eliminar — redundante con repo-level)

Nuevos archivos NO deben usar el schema legacy.

----

7. Tabla de Decisión Rápida
---------------------------

.. list-table::
 :header-rows: 1
 :widths: 32 30 38

 * - Tipo
   - Patrón
   - Ejemplo
 * - Caso de uso
   - ``uc-<mod>-<nn>-<desc>.rst``
   - ``uc-acc-01/index.rst``
 * - Regla de negocio
   - ``br-<nnn>-<desc>.rst``
   - ``br-001-fuente-operacional-inmutable.rst``
 * - Restricción
   - ``cnst-<nnn>-<desc>.rst``
   - ``cnst-001-prohibicion-de-email-y-smtp.rst``
 * - ADR
   - ``adr-<mod>-<nnn>-<desc>.rst``
   - ``adr-back-001-grupos-funcionales-sin-jerarquia.rst``
 * - Procedimiento gobernanza
   - ``proced-<mod>-<nnn>-<desc>.rst``
   - ``proced-gob-003-documentar-regla-negocio.rst``
 * - Procedimiento general
   - ``proc-<mod>-<nnn>-<desc>.rst``
   - ``proc-dev-001-pipeline-trabajo-iact.rst``
 * - Estándar
   - ``std-<nnn>-<desc>.rst``
   - ``std-006-versionado-semantico.rst``
 * - Plantilla
   - ``tpl-<key>-<desc>.rst``
   - ``tpl-adr-decisiones-arquitectonicas.rst``
 * - Requisito funcional
   - ``fr-<nnn>-<nn>-<desc>.rst``
   - ``fr-010-01-listar-funciones-disponibles.rst``
 * - Guía sin prefijo
   - ``<desc-kebab>.rst``
   - ``git-workflow.rst``
 * - Punto de entrada
   - ``index.rst``
   - ``arquitectura-tecnica/index.rst``
 * - Directorio público
   - ``<desc-kebab>/``
   - ``casos-uso/``
 * - Directorio interno Sphinx
   - ``_<desc-kebab>/``
   - ``_metadata/``

----

8. Convención de Idioma (código vs documentación)
--------------------------------------------------

Origen: ``modelo-rbac-iact.rst`` § "ESTÁNDAR DE NOMENCLATURA v5.2.1"
+ decisiones D-RBAC-1 y CNST_033 Vocabulario Unificado RBAC.

8.1 Tabla canónica de idioma por tipo de elemento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Tipo de elemento
   - Idioma
   - Ejemplo
 * - Modelos Django (clases, métodos)
   - Inglés
   - ``class FunctionGroup(models.Model):``
 * - Funciones SQL nativas (PostgreSQL)
   - Inglés
   - ``CREATE FUNCTION user_has_permission(...)``
 * - Variables, atributos en código
   - Inglés
   - ``user_id``, ``expires_at``
 * - Códigos de funciones (capabilities)
   - Inglés
   - ``manage_sessions``, ``view_reports``, ``export_csv``
 * - Nombres de grupos (system y custom)
   - Inglés con sufijo ``_group``
   - ``basic_operator_group``, ``auditor_group``
 * - Nombres de reglas SoD
   - Inglés con sufijo ``_separation``
   - ``pipeline_audit_separation``
 * - Comentarios en código
   - Español
   - ``# Validar antes de persistir``
 * - Docstrings de clases / métodos
   - Español
   - ``"""Grupo de funciones que se asignan juntas."""``
 * - help_text de campos Django
   - Español
   - ``help_text="Identificador único del grupo (AGR-001)"``
 * - Documentación técnica (.rst)
   - Español
   - "El sistema permite..."
 * - Mensajes de UI / errores al usuario final
   - Español
   - ``"No tiene permiso para esta acción"``
 * - Logs de aplicación
   - Inglés
   - ``"User authenticated successfully"``
 * - Mensajes de commit Git
   - Inglés (Tim Pope)
   - ``"Add FunctionGroup model"``

**Nota:** la convención de idioma aplica a CONTENIDO de código y docs,
NO a nombres de archivo. Los archivos siempre siguen kebab-lowercase
(§3-§4).

8.2 Justificación
^^^^^^^^^^^^^^^^^

- **Código en inglés**: facilita la colaboración con equipos
  internacionales, alineamiento con frameworks (Django, DRF) y
  bibliotecas (SQL, Python) que usan inglés. Reduce fricción al
  buscar documentación externa.
- **Documentación y comentarios en español**: el equipo de negocio
  consume la documentación. Los comentarios contextualizan
  decisiones del dominio. La UI es en español porque los usuarios
  finales son hispanohablantes.
- **Logs en inglés**: facilita parsing por herramientas SIEM/ELK que
  asumen inglés. Los logs son consumidos por operaciones técnicas,
  no por usuarios finales.

8.3 Excepciones
^^^^^^^^^^^^^^^

- **Documentos legados** (creados antes de esta convención): se
  permite preservar el idioma original; nuevas ediciones aplican la
  convención.
- **Términos técnicos sin traducción aceptada**: ``framework``,
  ``timeout``, ``token``, ``cache``, ``deploy`` se mantienen en
  inglés incluso en docs en español.

----

9. Decisiones de Gobernanza
---------------------------

9.1 Cambios a esta convención
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cualquier cambio a esta convención requiere:

1. Propuesta documentada como ADR (``adr-gob-NNN-<desc>.rst``).
2. Aprobación del Tech Lead + Equipo de Gobernanza.
3. Bump MAJOR de versión en este documento.
4. Migración planificada de archivos existentes.

9.2 Commitment de Estabilidad (v2.0.0)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**30 días sin nuevas modificaciones a STD_007 después de la fecha
de v2.0.0** (2026-04-29 → 2026-05-29).

Esta cláusula previene "norm churn" — la modificación reactiva de
normas más rápido de lo que el sistema puede asimilarlas. Si en
30 días aparece evidencia que justifique nueva modificación, debe
abrirse WP propio con deep-review previo.

Decisión registrada en
``adr-naming-conventions-kebab-correction.rst``.

9.3 Excepciones permitidas al patrón
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Solo dos excepciones documentadas:

- ``index.rst`` — punto de entrada Sphinx por convención.
- Directorios con prefijo ``_`` — exclusión del toctree público
  por convención Sphinx (``_static/``, ``_templates/``,
  ``_metadata/``, etc.). El resto del nombre sigue en kebab-lowercase.

Cualquier nueva excepción requiere bump MAJOR + ADR.

----

10. Cumplimiento
----------------

10.1 Estado del Proyecto (snapshot v2.0.0)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Auditoría 2026-04-29 detectó (verificado con find/grep):

- 401 archivos ``.rst`` totales bajo ``source/``.
- **315 archivos** con violación del patrón universal nuevo.
- **18 directorios** públicos con violación.
- 6 directorios ``_*`` Sphinx preservados.
- 48 ``index.rst`` preservados (excepción).
- 242 referencias ``:doc:`` + 128 ``:ref:`` + 123 toctrees a
  actualizar en cascada.

La migración se ejecuta en WP único
``2026-04-29-14-56-40-std007-rename-cleanup`` con script idempotente
y PILOT previo.

10.2 Validación de Nombres Nuevos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NO se incluye validación automatizada en CI (decisión del ejecutor).
La validación es por revisión manual en PRs.

Los autores son responsables de respetar este estándar al crear nuevos
archivos. Las violaciones detectadas en review deben corregirse antes
del merge.

----

11. Referencias
---------------

- :ref:`std-006` — STD_006: Versionado Semántico (versiones van en
  metadata, no en filename).
- ``adr-naming-conventions-heterogeneity-accepted.rst`` — ADR original
  v1.0.0 que aceptaba 5 dialectos (corregido por v2.0.0).
- ``adr-naming-conventions-kebab-correction.rst`` — ADR de corrección
  que motiva v2.0.0.

----

12. Historial de Cambios
------------------------

.. list-table::
 :header-rows: 1
 :widths: 12 12 76

 * - Versión
   - Fecha
   - Cambios
 * - 1.0.0
   - 2026-04-28
   - Versión inicial. Define convenciones para 12 tipos de artefactos
     en source/, reglas de directorios, caracteres prohibidos,
     versión en metadata (no filename), index.rst como entry-point,
     tabla de decisión rápida.
 * - 1.1.0
   - 2026-04-29
   - §3.3 clarifica que kebab puro NO es opción genérica: la
     selección de dialecto está determinada por la categoría del
     artefacto, no por preferencia del autor. Aceptaba 5 dialectos
     coexistiendo (snake+Pascal, kebab puro, mixed, etc.).
 * - 2.0.0
   - 2026-04-29
   - **MAJOR — corrección.** Reemplaza los 5 dialectos heterogéneos
     por **patrón único universal**
     ``<prefix>-<NNN>-<descripcion-kebab>.rst`` en minúsculas.
     Aplica a archivos y directorios. Preserva solo ``index.rst``
     y prefijos ``_`` de Sphinx. Motivado por:
     (a) heterogeneidad estructural observable en cualquier ``ls``,
     (b) costo de migración crece exponencial por refs cruzadas,
     (c) forward-only institucionalizaba dos convenciones en lugar
     de mitigarlas. Ver ADR
     ``adr-naming-conventions-kebab-correction.rst``. Incluye
     commitment de 30 días sin modificaciones (§8.2) como
     salvaguarda anti norm-churn.
 * - 2.0.1
   - 2026-04-29
   - **PATCH — clarificación.** §4 documenta tabla canónica de
     módulos para ``proc``/``proced``: ``dev``, ``devops``, ``ops``,
     ``qa``, ``gob``, ``req`` (nuevo), ``doc`` (nuevo). REQ y DOC
     creados para clasificar 32 procedimientos previamente
     transversales (sin módulo). 7 procedimientos adicionales
     asignados a ``gob`` (lifecycle documental). Total 39 archivos
     re-clasificados. NO modifica el patrón universal §3 — la
     clarificación es compatible y no rompe el commitment de
     estabilidad de v2.0.0. Ver ADR
     ``adr-procedimientos-modulos-req-doc.rst``.
 * - 2.0.2
   - 2026-04-29
   - **PATCH — spec gaps.** Cierra 7 huecos detectados por
     deep-review adversarial sin alterar el patrón universal §3:
     (1) §2 NO aplica clarifica que campos de metadata YAML
     quedan fuera de scope; (2) §3.5 nueva regla de filenames
     únicos con excepciones documentadas (frontend/backend mirror,
     etl-pipeline cross-context); (3) §4 agrega prefijo ``arq``
     con módulo ``mod``; (4) §4 agrega tablas de módulos canónicos
     para ``adr-`` ({back, front, devops, gob, qa}) y ``rnf-``
     ({proc}); (5) §5.4 nueva sección autoriza guías sin prefijo
     en directorios temáticos (distinción por ``:tipo: Guia``);
     (6) §6 nueva sección define schema canónico de metadata YAML
     y deprecación del schema legacy UC. Compatible con v2.0.0/v2.0.1.
     Commitment de 30 días NO se reinicia. Ver ADR
     ``adr-std007-spec-gaps-fix.rst``.
