.. meta::
   :Proyecto: IACT
   :Codigo: STD-001
   :Titulo: Estándares de Documentación
   :Version: 1.1.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE
   :Clasificacion: C2 - INTERNAL

================================================
STD-001: Estándares de Documentación Proyecto
================================================

:ID: STD-001
:Versión: 1.1.0
:Fecha: 2026-01-08
:Estado: VIGENTE
:Autores: Equipo IACT
:Aprobado por: CTO

.. contents:: Tabla de Contenido
   :depth: 3
   :local:

Introducción
============

Este documento establece los estándares obligatorios de documentación para el proyecto IACT (IVR Analytics & Customer Tracking).

Alcance
-------

Aplica a:

- Material pedagógico (PARTES 0-6)
- Templates técnicos (TPL_*)
- Documentos de requisitos (BR, UC, FR)
- Documentos de análisis y planificación
- Toda documentación técnica del proyecto

No aplica a:

- Código fuente (ver guía de estilo Python/Django)
- Comentarios en código
- Documentación de usuario final

Audiencia
---------

- Desarrolladores
- Analistas de Negocio
- Product Owners
- Arquitectos
- QA Engineers

Regla 1: Prohibición de Emojis
================================

Contexto
--------

Los emojis Unicode causan problemas en:

- Sistemas de control de versión (diff, merge)
- Herramientas de documentación (Sphinx, Docutils)
- Editores de texto en algunos entornos
- Búsqueda y reemplazo automatizado

Regla
-----

**PROHIBIDO** usar emojis Unicode en toda la documentación técnica.

Emojis Prohibidos
-----------------

Lista no exhaustiva de emojis comúnmente usados:

.. code-block:: text

   ✅ ❌ ⚠️  (checkmarks, cruz, advertencia)
   🚀 📁 💾  (iconos temáticos)
   ⭐ 🔴 🟢  (estrellas, círculos de color)
   🎯 📊 📈  (objetivos, gráficos)
   🔧 🔄 ⏱️  (herramientas, reloj)

Cualquier carácter Unicode > U+007F que sea emoji está prohibido.

Alternativas Permitidas
------------------------

Usar prefijos textuales entre corchetes:

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Emoji Prohibido
     - Alternativa Permitida
     - Uso
   * - ✅
     - [OK]
     - Estado exitoso
   * - ❌
     - [ERROR]
     - Estado fallido
   * - ⚠️
     - [WARN]
     - Advertencia
   * - 🚀
     - [DEPLOY]
     - Despliegue
   * - 📁
     - [FILE]
     - Archivo/Directorio
   * - 💾
     - [SAVE]
     - Guardar
   * - ⭐
     - [IMPORTANT]
     - Importante
   * - 🔴
     - [BLOCKER]
     - Bloqueador
   * - 🟢
     - [READY]
     - Listo
   * - 🎯
     - [GOAL]
     - Objetivo
   * - 📊
     - [DATA]
     - Datos/Métricas

Ejemplos Correctos
------------------

Markdown (.md):

.. code-block:: markdown

   # Estado de Generación
   
   [OK] PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md generado
   [ERROR] Falta TPL_UC_Construccion_7_Pasos_1_0_0.rst
   [WARN] Referencias a PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md pendientes

reStructuredText (.rst):

.. code-block:: rst

   Resultados
   ==========
   
   [OK] Validación pasó
   [ERROR] 3 referencias rotas
   [WARN] Nomenclatura antigua detectada

Ejemplos Incorrectos
--------------------

.. code-block:: markdown

   # Estado de Generación
   
   ✅ PARTE 0 generado          # INCORRECTO: Emoji
   ❌ Falta Template T01         # INCORRECTO: Emoji
   ⚠️ Referencias pendientes    # INCORRECTO: Emoji

Validación
----------

Script de validación automática:

.. code-block:: bash

   # Detectar emojis en archivos
   grep -r '[✅❌⚠️🚀📁💾⭐🔴🟢🎯📊🔧]' *.{md,rst} && echo "ERROR: Emojis encontrados"

Penalización
------------

Documentos con emojis serán **rechazados en code review**.

Regla 2: Formato de Documentación
===================================

Material Pedagógico
-------------------

**Formato:** Markdown (.md)

**Aplica a:**

- PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
- PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
- ... (todas las PARTES 0-6)

**Características:**

- Sintaxis Markdown estándar (CommonMark)
- Headers con # (H1), ## (H2), ### (H3)
- Listas con - o 1.
- Bloques de código con triple backtick
- Tablas con pipe |

Documentación Técnica
---------------------

**Formato:** reStructuredText (.rst)

**Aplica a:**

- Templates (TPL_*)
- Business Rules (BR_IACT_*)
- Use Cases (UC_IACT_*)
- Functional Requirements (FR_*)
- Constraints (CNST_*)
- Estándares (STD_*)
- Nomenclaturas (NOM_*)

**Características:**

- Sintaxis RST estricta
- Metadatos en bloque .. meta::
- Headers con ==, --, ^^
- Directivas .. code-block::, .. list-table::
- Referencias cruzadas con :ref:

Regla 3: Nomenclatura Obligatoria
===================================

Todos los archivos deben seguir **NOM_001_Nomenclatura_Proyecto_2_0_0.rst**.

Formato General
---------------

::

   [PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].ext

Donde:

- PREFIJO: Tipo de documento (ver NOM_001_Nomenclatura_Proyecto_2_0_0.rst)
- Nombre_Descriptivo: CamelCase con guiones bajos
- MAJOR_MINOR_PATCH: Versionado semántico **OBLIGATORIO**
- ext: .md (pedagógico) o .rst (técnico)

Ejemplos Correctos
------------------

.. code-block:: text

   [OK] PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
   [OK] TPL_UC_Construccion_7_Pasos_1_0_0.rst
   [OK] UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   [OK] BR_IACT_028_Aprobacion_Consultas_1_0_0.rst

Ejemplos Incorrectos
--------------------

.. code-block:: text

   [ERROR] PARTE_1.md                          # Falta nombre descriptivo y versión
   [ERROR] PARTE-1-Identificar-BR.md           # Usa guiones en lugar de guiones bajos
   [ERROR] PARTE_1_Identificar_BR.md           # Falta versionado
   [ERROR] parte_1_identificar_br_1_0_0.md     # Minúsculas (debe ser MAYÚSCULAS)

Validación
----------

Script de validación:

.. code-block:: bash

   # Validar nomenclatura
   ./validar_nomenclatura.sh PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

Regla 4: Referencias Cruzadas
===============================

Todas las referencias a otros documentos deben usar nombres completos con versionado.

Referencias Correctas
---------------------

Markdown:

.. code-block:: markdown

   Como se explicó en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 3.2,
   los 5 tipos de reglas de negocio son...
   
   Para documentar BR, usar TPL_BR_Decision_Tipo_1_0_0.rst.
   
   Ver ejemplo en BR_IACT_028_Aprobacion_Consultas_1_0_0.rst.

reStructuredText:

.. code-block:: rst

   Ver :ref:`PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0` para más detalles.
   
   Usar template :doc:`TPL_UC_Construccion_7_Pasos_1_0_0`.

Referencias Incorrectas
-----------------------

.. code-block:: markdown

   [ERROR] Como se explicó en PARTE 0...       # Sin nombre de archivo
   [ERROR] Ver Template T01...                 # Nomenclatura antigua
   [ERROR] Usar el template de UC...           # Demasiado genérico
   [ERROR] BR-028 especifica...                # Sin nombre de archivo

Validación
----------

.. code-block:: bash

   # Detectar referencias antiguas
   ./validar_referencias.sh PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

Regla 5: Metadatos Obligatorios
=================================

Documentos RST
--------------

Todos los documentos .rst deben incluir bloque de metadatos:

.. code-block:: rst

   .. meta::
      :Proyecto: IACT
      :Codigo: [CODIGO-UNICO]
      :Titulo: [Título descriptivo]
      :Version: X.Y.Z
      :Fecha: YYYY-MM-DD
      :Estado: [DRAFT|REVIEW|VIGENTE|OBSOLETO]
      :Clasificacion: [C1-PUBLIC|C2-INTERNAL|C3-CONFIDENTIAL]

Ejemplo:

.. code-block:: rst

   .. meta::
      :Proyecto: IACT
      :Codigo: UC-IACT-RPT-01
      :Titulo: Consultar Reporte Trimestral Consolidado
      :Version: 4.0.0
      :Fecha: 2026-01-08
      :Estado: VIGENTE
      :Clasificacion: C2-INTERNAL

Documentos Markdown
-------------------

Incluir frontmatter al inicio:

.. code-block:: markdown

   ---
   proyecto: IACT
   documento: PARTE_1
   titulo: Identificar Reglas de Negocio
   version: 1.0.0
   fecha: 2026-01-08
   estado: VIGENTE
   ---

Regla 6: Versionado Semántico
===============================

Todos los documentos usan versionado semántico MAJOR.MINOR.PATCH.

Incremento MAJOR
----------------

Cambios incompatibles que requieren actualizar documentos dependientes:

- Cambio de estructura completa
- Eliminación de secciones principales
- Cambio de nomenclatura de IDs (BR-XXX → BR_XXX)

Incremento MINOR
----------------

Agregar funcionalidad compatible:

- Nueva sección
- Nuevos ejemplos
- Nueva BR/UC/FR

Incremento PATCH
----------------

Correcciones y aclaraciones:

- Corrección de typos
- Mejora de redacción
- Corrección de referencias rotas

Ejemplos
--------

.. code-block:: text

   PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
     ↓ Agregar sección "Técnicas Avanzadas"
   PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_0.md
     ↓ Corregir typos
   PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_1.md
     ↓ Reestructuración completa
   PARTE_1_Identificar_Reglas_Negocio_IACT_2_0_0.md

Historial de Cambios
=====================

Versión 1.1.0 (2026-01-08)
--------------------------

**Cambios:**

- Actualización de ejemplos con nomenclatura NOM_001 v2.0.0
- Referencias correctas a documentos versionados
- Ejemplos con PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
- Ejemplos con TPL_BR_Decision_Tipo_1_0_0.rst
- Integración con validar_nomenclatura.sh

**Autor:** Equipo IACT

Versión 1.0.0 (2025-12-15)
--------------------------

**Cambios:**

- Versión inicial
- Regla de prohibición de emojis
- Formato RST vs Markdown
- Nomenclatura básica

**Autor:** Equipo IACT

Referencias
===========

- NOM_001_Nomenclatura_Proyecto_2_0_0.rst
- PLAN_REGENERACION_COMPLETA_DESDE_CERO_1_0_0.md
- validar_nomenclatura.sh
- validar_referencias.sh

Aprobación
==========

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol
     - Nombre
     - Fecha
   * - CTO
     - [Pendiente]
     - 2026-01-08
   * - Tech Lead
     - [Pendiente]
     - 2026-01-08
   * - Equipo IACT
     - [Aprobado]
     - 2026-01-08

