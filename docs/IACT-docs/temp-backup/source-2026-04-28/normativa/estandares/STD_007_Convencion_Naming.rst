.. meta::
   :artefacto: STD_007
   :tipo: Estándar
   :dominio: normativa
   :subdominio: estandares
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

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
- Compatibilidad cross-platform (Windows, Linux, macOS).
- Resolución correcta de URLs HTML rendered.
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
- Archivos en ``.claude/``, ``.thyrox/``, ``scripts/``.
- ``LICENSE``, ``CHANGELOG.md``, ``ROADMAP.md``, ``readme.rst`` en raíz.

----

3. Reglas Generales (aplican a todo bajo source/)
-------------------------------------------------

3.1 Caracteres Permitidos
^^^^^^^^^^^^^^^^^^^^^^^^^

Los nombres de archivos y directorios DEBEN contener únicamente:

- Letras ASCII: ``a-z``, ``A-Z``
- Dígitos: ``0-9``
- Separadores: ``-`` (hyphen) y ``_`` (underscore)
- Punto: ``.`` solo para extensión final (``.rst``, ``.puml``)

3.2 Caracteres PROHIBIDOS
^^^^^^^^^^^^^^^^^^^^^^^^^

Los nombres NO DEBEN contener:

- **Espacios** — usar ``-`` o ``_`` en su lugar.
- **Paréntesis** ``(``, ``)``, ``[``, ``]``, ``{``, ``}``.
- **Tildes**: ``á``, ``é``, ``í``, ``ó``, ``ú``, ``ü``.
- **Eñe**: ``ñ``, ``Ñ`` — usar ``n`` o ``ny``.
- **Otros símbolos**: arroba, hash, dolar, porcentaje, ampersand,
  asterisco, signo de pregunta, exclamación, suma, igual, coma,
  punto y coma, dos puntos, comillas (dobles o simples), backtick,
  tilde, pipe, backslash. La barra ``/`` solo se permite como
  separador de path.

**Ejemplos PROHIBIDOS:**

- ``Diagramas de Referencia - README.rst`` (espacios)
- ``Architecture Decision Records (ADRs) - Indice Maestro.rst`` (espacios + parens)
- ``diseño_detallado/`` (ñ)
- ``Planificación y releases del frontend-README.rst`` (tildes + espacios)

**Ejemplos CORRECTOS:**

- ``diagramas-de-referencia.rst``
- ``adr-indice-maestro.rst``
- ``diseno_detallado/``
- ``planificacion-y-releases-frontend.rst``

3.3 Mezcla de Separadores
^^^^^^^^^^^^^^^^^^^^^^^^^

NO mezclar ``-`` y ``_`` en el mismo nombre **a menos que** la mezcla
siga la estructura: ``<PREFIX-CON-HYPHEN>_<descripcion-con-cualquiera>``.

**Permitido (estructural):**

- ``ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst`` (kebab puro)
- ``UC_ACC_01_Asignar_Funciones.rst`` (snake puro)
- ``PROC-DEV-001-pipeline_trabajo_iact.rst`` (mixed permitido: prefix
  con hyphen, descripción con underscore)

**Prohibido (caos):**

- ``mi_archivo-de-prueba.rst`` (mezcla sin razón estructural)

3.4 Versión en Filename
^^^^^^^^^^^^^^^^^^^^^^^

NO incluir versión en el nombre del archivo. La versión vive en el
metadata YAML del archivo, NO en el filename.

**Prohibido:**

- ``TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst``
- ``IACT_Glossary_v1_0_0.rst``
- ``MODELO_RBAC_v5_2_1.rst``

**Correcto:**

- ``TPL_ADR_Decisiones_Arquitectonicas.rst`` (con ``:version:`` en
  meta YAML).
- ``IACT_Glossary.rst``
- ``MODELO_RBAC.rst``

3.5 Longitud Máxima
^^^^^^^^^^^^^^^^^^^

Filenames ≤ 100 caracteres (incluyendo extensión). Más allá de eso,
usar abreviaciones documentadas o reorganizar el contenido.

----

4. Convenciones por Tipo de Artefacto
--------------------------------------

4.1 Artefactos Numerados con Prefijo Fijo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Patrón:** ``<PREFIX>_<NN>_<Descripcion_PascalCase>.rst``

Donde:

- ``<PREFIX>`` es un acronym de 2-5 caracteres en MAYÚSCULAS.
- ``<NN>`` es 2 o 3 dígitos zero-padded (``01``, ``002``).
- ``<Descripcion_PascalCase>`` con cada palabra capitalizada y
  separada por ``_``.

**Aplica a:**

.. list-table::
   :header-rows: 1
   :widths: 15 30 55

   * - Prefijo
     - Dominio
     - Ejemplo
   * - ``UC``
     - Casos de uso (con sub-módulo)
     - ``UC_ACC_01_Asignar_Funciones.rst``
   * - ``BR``
     - Reglas de negocio
     - ``BR_001_Fuente_Operacional_Inmutable.rst``
   * - ``BReq``
     - Business requirements
     - ``BReq_001_Visibilidad_Metricas.rst``
   * - ``CNST``
     - Restricciones arquitectónicas
     - ``CNST_001_Comunicaciones_Prohibidas.rst``
   * - ``META``
     - Metadata del proyecto
     - ``META_01_Identidad_Proyecto.rst``
   * - ``FND``
     - Fundamentos conceptuales
     - ``FND_01_Concepto_Requisito.rst``
   * - ``SBVR``
     - Ontología SBVR
     - ``SBVR_01_Conceptos_Nucleares.rst``
   * - ``MTM``
     - Metamodelos
     - ``MTM_03_Metamodelo_RBAC.rst``
   * - ``TXM``
     - Taxonomías
     - ``TXM_01_Taxonomia_Requisitos.rst``
   * - ``GOB``
     - Gobernanza
     - ``GOB_01_Modelo_Gobernanza_IACT.rst``
   * - ``STD``
     - Estándares
     - ``STD_006_Versionado_Semantico.rst``
   * - ``TPL``
     - Plantillas (templates)
     - ``TPL_ADR_Decisiones_Arquitectonicas.rst``

4.2 Artefactos con Módulo y Numeración
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Patrón:** ``<PREFIX>-<MOD>-<NNN>-<descripcion-en-kebab>.rst``

Donde:

- ``<PREFIX>`` y ``<MOD>`` van en MAYÚSCULAS, separados por ``-``.
- ``<NNN>`` es 3 dígitos zero-padded.
- ``<descripcion>`` en kebab-case minúsculas.

**Aplica a:**

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Prefijo
     - Dominio
     - Ejemplo
   * - ``ADR``
     - Architecture Decision Records
     - ``ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst``
   * - ``PROCED``
     - Procedimientos de gobernanza
     - ``PROCED-GOB-003-documentar-regla-negocio.rst``
   * - ``PROC``
     - Procedimientos generales
     - ``PROC-DEV-001-pipeline-trabajo-iact.rst``
   * - ``RNF``
     - Requisitos no funcionales
     - ``RNF-PROC-001-proceso-sdlc.rst``

**Migración recomendada:** los archivos actuales con mixed-separators
(``PROC-DEV-001-pipeline_trabajo_iact.rst``) → kebab puro
(``PROC-DEV-001-pipeline-trabajo-iact.rst``).

4.3 Requisitos Funcionales (FR) Sub-numerados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Patrón:** ``FR-NNN.NN_descripcion_snake_case.rst``

Donde:

- ``NNN`` es número del UC asociado.
- ``.NN`` es sub-numeración del FR (01, 02, ...).

**Ejemplo:**

- ``FR-010.01_Listar_funciones_disponibles.rst``
- ``FR-010.02_Validar_SoD_antes_asignar.rst``

4.4 Guías y Documentos Generales
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Patrón:** ``<descripcion-en-kebab-case>.rst``

Para artefactos sin numeración intrínseca (guías de estilo, lineamientos,
glosarios, etc.).

**Ejemplos:**

- ``git-workflow.rst``
- ``color-palette.rst``
- ``glosario.rst``
- ``actores.rst``
- ``shell-scripting-guide.rst`` (renombrado de
  ``shell_scripting_guide.rst``)

4.5 Punto de Entrada de Directorio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla:** ``index.rst`` (NO ``README.rst``).

Sphinx usa ``index.rst`` como punto de entrada por convención. Tener
``README.rst`` en paralelo crea ambigüedad: ¿cuál es el punto de
entrada del directorio?

**Migración:** los 11 archivos ``README*.rst`` deben convertirse:

- Si el directorio NO tiene ``index.rst``: renombrar ``README.rst`` →
  ``index.rst``.
- Si ya hay ``index.rst``: el ``README.rst`` debe re-nombrarse
  conceptualmente (ej. ``arquitectura-overview.rst``) o mergearse al
  ``index.rst``.

----

5. Convenciones para Directorios
--------------------------------

5.1 Patrón Recomendado
^^^^^^^^^^^^^^^^^^^^^^

``snake_case`` para directorios con palabras múltiples.

**Ejemplos correctos:**

- ``arquitectura_tecnica/``
- ``casos_uso/``
- ``reglas_negocio/``
- ``requisitos_funcionales/``

**Ejemplos a renombrar:**

- ``diseño_detallado/`` → ``diseno_detallado/`` (sin ñ)
- ``plantuml-guide/`` → ``plantuml_guide/`` (consistencia con resto;
  alternativa: dejar como excepción si el nombre del producto es así)

5.2 Directorios Internos con prefijo underscore
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla:** prefijar con ``_`` los directorios cuyo contenido es
referencia interna y NO debe aparecer en navegación pública.

**Ejemplos:**

- ``_metadata/``
- ``_fundamentos_conceptuales/``
- ``_ontologia_sbvr/``
- ``_taxonomias_y_metamodelos/``

Sphinx por defecto excluye ``_`` prefijos del toctree público — esto
es intencional.

5.3 Directorios con Numeración (Casos de Uso)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Patrón:** ``UC_<NNN>_<Descripcion_PascalCase>/``

**Ejemplos:**

- ``UC_001_Iniciar_Sesion/``
- ``UC_006_Crear_Usuario/``
- ``UC_010_Asignar_Funciones/``

----

6. Tabla de Decisión Rápida
---------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 25 45

   * - Tipo de Artefacto
     - Convención
     - Ejemplo
   * - Caso de Uso
     - ``UC_<MOD>_<NN>_<Desc>.rst``
     - ``UC_ACC_01_Asignar_Funciones.rst``
   * - Regla de Negocio
     - ``BR_<NNN>_<Desc>.rst``
     - ``BR_001_Fuente_Operacional_Inmutable.rst``
   * - Restricción
     - ``CNST_<NNN>_<Desc>.rst``
     - ``CNST_001_Comunicaciones_Prohibidas.rst``
   * - ADR
     - ``ADR-<MOD>-<NNN>-<desc-kebab>.rst``
     - ``ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst``
   * - Procedimiento (gobernanza)
     - ``PROCED-<MOD>-<NNN>-<desc-kebab>.rst``
     - ``PROCED-GOB-003-documentar-regla-negocio.rst``
   * - Procedimiento general
     - ``PROC-<MOD>-<NNN>-<desc-kebab>.rst``
     - ``PROC-DEV-001-pipeline-trabajo-iact.rst``
   * - Estándar
     - ``STD_<NNN>_<Desc>.rst``
     - ``STD_006_Versionado_Semantico.rst``
   * - Plantilla
     - ``TPL_<KEY>_<Desc>.rst``
     - ``TPL_ADR_Decisiones_Arquitectonicas.rst``
   * - Guía general
     - ``<desc-kebab>.rst``
     - ``git-workflow.rst``
   * - Punto de entrada de dir
     - ``index.rst``
     - ``arquitectura_tecnica/index.rst``
   * - Directorio
     - ``snake_case/``
     - ``casos_uso/``
   * - Directorio interno
     - ``_snake_case/``
     - ``_metadata/``

----

7. Decisiones de Gobernanza
---------------------------

7.1 Cambios a esta convención
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cualquier cambio a esta convención requiere:

1. Propuesta documentada como ADR (``ADR-GOB-NNN-<desc>.rst``).
2. Aprobación del Tech Lead + Equipo de Gobernanza.
3. Bump MAJOR de versión en este documento.
4. Migración planificada de archivos existentes.

7.2 Excepciones
^^^^^^^^^^^^^^^

Existen excepciones documentadas:

- ``index.rst`` y archivos generados por Sphinx (no toca naming).
- Directorios ``_static/``, ``_templates/`` (convención Sphinx).
- ``readme.rst`` en raíz (es legacy del proyecto, no en ``source/``).

Cualquier nueva excepción requiere registro en este documento bajo
sección 7.2.

----

8. Cumplimiento
---------------

8.1 Estado Actual del Proyecto (snapshot 2026-04-28)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Auditoría inicial detectó:

- 377 archivos ``.rst`` en 34 patrones distintos.
- 9 archivos con espacios.
- 2 archivos con paréntesis.
- 1 directorio con ñ (``diseño_detallado``).
- 46 archivos con mixed-separators sin razón estructural.
- 17+ archivos con versión en filename.
- 11 archivos ``README*.rst`` paralelos a ``index.rst``.

Plan de migración por dominio (dividido en WPs separados):

- WP cleanup procedimientos
- WP cleanup gobernanza
- WP cleanup estándares
- WP cleanup arquitectura técnica
- WP cleanup gestión

Cada WP renombra archivos de su dominio + actualiza refs en cascada.

8.2 Validación de Nombres Nuevos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NO se incluye validación automatizada en CI (decisión del ejecutor).
La validación es por revisión manual en PRs.

Los autores son responsables de respetar este estándar al crear nuevos
archivos. Las violaciones detectadas en review deben corregirse antes
del merge.

----

9. Referencias
--------------

- :ref:`std-006` — STD_006: Versionado Semántico (versiones van en
  metadata, no en filename).
- ``ADR-GOB-006-clasificacion-reglas-negocio.rst`` — convenciones de
  clasificación que usan estos prefijos.
- ``GUIA_ESTILO.rst`` — guía de estilo de redacción (complementa este
  estándar).

----

10. Historial de Cambios
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
