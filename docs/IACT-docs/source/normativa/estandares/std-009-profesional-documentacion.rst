.. meta::
 :artefacto: STD_009
 :tipo: Estándar
 :dominio: normativa
 :subdominio: estandares
 :estado: Aprobado
 :version: 1.1.0
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _std-009:

=======================================
STD_009: Documentación Profesional
=======================================

.. contents:: Contenido
 :depth: 3
 :local:

----

1. Propósito
============

Establecer el lenguaje, tono y estructura obligatorios para toda
la documentación del proyecto IACT. Garantiza:

- Comunicación técnica clara y directa.
- Ausencia de coloquialismos, metáforas decorativas y vocabulario
  no profesional.
- Consistencia de tono y terminología en toda la documentación
  publicada.

----

2. Alcance
==========

Aplica a todo documento bajo ``source/`` del proyecto IACT,
incluyendo:

- Standards (STDs).
- Templates (TPLs).
- Architecture Decision Records (ADRs).
- Procedures (PROCs).
- Restrictions (CNSTs).
- Documentación de UCs, FRs, NFRs, BRs.
- Convenciones de tier técnico (backend, frontend, etc.).
- Documentación de proyecto (charter, roadmap, retrospectives).

NO aplica a:

- Comentarios dentro del código (rige STD_Naming_Identificadores
  para nombres + clean code para comentarios).
- Logs operacionales del sistema.
- Mensajes de commit (rigen los lineamientos de Tim Pope del
  repositorio, no este STD).

----

3. Lenguaje obligatorio
=======================

3.1 Tono profesional
--------------------

La documentación usa lenguaje técnico, directo y formal.

**Aceptable:**

- Técnico y preciso.
- Directo y claro.
- Formal pero no rígido.
- Inglés cuando el documento es en inglés; español cuando es en
  español. Sin mezclar idiomas sin razón.
- Terminología consistente.

**No aceptable:**

- Coloquial o conversacional.
- Decorativo o metafórico.
- Mezcla de idiomas sin razón.
- Reglas o leyes informales.
- Referencias humorísticas o "cute".

3.2 Frases prohibidas
---------------------

Las siguientes frases **NO deben aparecer** en la documentación
del proyecto. La tabla lista cada frase prohibida y su
alternativa profesional.

.. list-table::
 :header-rows: 1
 :widths: 30 35 35

 * - Frase prohibida
   - Razón
   - Alternativa profesional
 * - "Regla de Oro"
   - Coloquialismo en español.
   - "Core Principle", "Critical Standard", "Principio
     fundamental".
 * - "Principio Unix"
   - Referencia decorativa a una filosofía externa.
   - "Core Principle", "Architectural Principle".
 * - "Los 5 Pilares"
   - Decorativo, pluraliza arbitrariamente.
   - "Five Core Principles", "Five Standards".
 * - "Si tienes que..."
   - Conversacional en español.
   - "If code requires explanation, it lacks clarity".
 * - "Recuerda que..."
   - Informal.
   - "Note that...", "Important:".
 * - "Para recordar:"
   - Informal.
   - Estructurar como lista o como sección con heading
     formal.
 * - "Recuerda:" / "No olvides:"
   - Informal.
   - Sección o lista estructurada.
 * - "La Magia de X" / "Los Secretos de X"
   - Headers decorativos.
   - "Overview of X", "How X Works", "X — Deep Dive".

----

4. Estructura obligatoria
=========================

4.1 Estilo de headings
----------------------

En documentos Markdown:

.. code-block:: text

 # TITLE (all caps)
 ## SECTION (Title Case)
 ### SUBSECTION (Title Case)

En documentos RST (formato del proyecto), los underlines siguen
la jerarquía estándar. Los **textos** de los headings cumplen:

- Heading principal de archivo: en Title Case o all caps según
  el estilo del documento, manteniendo profesionalismo.
- Sub-headings: Title Case.

**Anti-patrones de heading prohibidos:**

- Headings decorativos: "La Magia de X", "Los Secretos de X".
- Sub-headings informales: "Recuerda:", "No Olvides:", "Tip:".
- Headings con emojis (cubierto también por STD_001).

4.2 Apertura / Introducción
---------------------------

Las secciones introductorias deben describir el contenido
directamente, sin frases coloquiales.

**Correcto:**

.. code-block:: text

 ## Core Principle

 Software must be clear and maintainable above all else.

**Incorrecto:**

.. code-block:: text

 ## Regla de Oro

 La regla de oro es que el software debe ser claro
 y mantenible.

4.3 Listas
----------

**Correcto** — listas declarativas con nombres semánticos:

.. code-block:: text

 Key standards:
 - Clarity: code explains itself.
 - Reliability: fail-fast on errors.
 - Testability: functions are independent.

**Incorrecto** — listas con apertura conversacional:

.. code-block:: text

 Recuerda estos 3 pilares:
 1. La claridad es todo
 2. Los errores deben fallar rápido
 3. Las funciones deben ser independientes

4.4 Ejemplos de código
----------------------

Los comentarios dentro de bloques de código se escriben en inglés
y de forma profesional. Se permite mantener el mismo idioma del
identificador.

**Correcto:**

.. code-block:: python

 # CORRECT — no magic numbers
 MAX_RETRIES = 3
 if retry_count > MAX_RETRIES:
 break

**Incorrecto:**

.. code-block:: python

 # MALO — Números mágicos
 if retry_count > 3:
 break

----

5. Headings recomendados (referencia)
=====================================

Para artefactos del proyecto se recomienda usar (entre otros) los
siguientes nombres de sección:

::

 # TITLE
 ## Overview / Introducción
 ## Core Principles / Principios Centrales
 ## Requirements / Prerrequisitos
 ## Implementation / Proceso
 ## Examples / Ejemplos
 ## Standards / Best Practices
 ## References / Referencias
 ## Next Steps / Siguientes Pasos

----

6. Cumplimiento
===============

6.1 Aplicación retroactiva
--------------------------

Todo documento que entre a ``source/`` durante o después del
rebuild v2.0 (ÉPICA 8 ``source-rebuild-strategy``) **debe cumplir
este estándar**. Documentos heredados son auditados al ser
re-incorporados al nuevo ``source/``.

6.2 Validación
--------------

Validación manual en revisión de PR. La adición de un linter
automatizado para detectar frases prohibidas y validar headings
es deuda técnica abierta a futuro (registrada en
``risks-technical-debt/`` cuando ese cajón se incorpore al
toctree público).

6.3 Documentos auditados al 2026-04-28
---------------------------------------

Audit hecho durante WP #1 ``source-rebuild-base-cognitiva``
confirmó cero ocurrencias de frases prohibidas en
``source/base_cognitiva/``. La única instancia de "Regla de
Oro" (en SBVR_05) fue reemplazada por "Principio fundamental
de univocidad".

----

7. Referencias
==============

- :ref:`std-001` — Documentación Sin Emojis (complementario:
  prohibición de emojis en documentación técnica).
- :ref:`std-008` — Naming de identificadores
  técnicos (complementario: aplica a identificadores de código,
  este STD aplica a narrativa de documentación).

----

8. Historial
============

.. list-table::
 :header-rows: 1
 :widths: 12 15 73

 * - Versión
   - Fecha
   - Cambios
 * - 1.0.0
   - 2026-04-28
   - Versión inicial. Formaliza la convención
     PROFESSIONAL DOCUMENTATION provista por el ejecutor
     (texto base 2026-04-21). Define lenguaje obligatorio,
     lista de frases prohibidas con alternativas, estructura
     de headings y reglas de cumplimiento.
