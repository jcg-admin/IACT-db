.. =============================================================================
.. TPL_005_Plantilla_ARQ_MOD.rst
.. Plantilla para Documentos de Modulos Funcionales (Arquitectura)
.. Version: 1.0.0
.. Fecha: 2025-12-22
.. =============================================================================

==================================
TPL_005: Plantilla ARQ_MOD
==================================

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Informacion del Documento
============================

.. list-table::
   :widths: 30 70
   :header-rows: 0

   * - **Plantilla**
     - TPL_005_Plantilla_ARQ_MOD
   * - **Version**
     - 1.0.0
   * - **Fecha**
     - 2025-12-22
   * - **Tipo**
     - Documento de Diseno Arquitectonico
   * - **Proposito**
     - Definir la estructura estandar para documentar modulos funcionales

----

2. Proposito de los ARQ_MOD
===========================

Los documentos ARQ_MOD_ son **documentos de diseno arquitectonico** que:

1. **Definen** la arquitectura logica de cada modulo del sistema
2. **Son referenciados** por UC, FR, API, TST en su metadata
3. **NO son artefactos RTM/PMO** - son arquitectura del software
4. **Documentan** servicios, APIs, capas, componentes, responsabilidades

**Principio fundamental:**

- ARQ_MOD_ = Arquitectura del SISTEMA (software)
- UC_, FR_, BR_ = Arquitectura DOCUMENTAL (trazabilidad)

----

3. Plantilla ARQ_MOD
====================

.. code-block:: rst

   .. =============================================================================
   .. ARQ_MOD_XXX_NOMBRE.rst
   .. Modulo Funcional: [Nombre del Modulo]
   .. Version: 1.0.0
   .. =============================================================================

   ================================================
   ARQ_MOD_XXX: [Nombre del Modulo]
   ================================================

   .. metadata::
      :id: ARQ_MOD_XXX
      :codigo: [CODIGO_CORTO]
      :nombre: [Nombre Completo del Modulo]
      :version: 1.0.0
      :estado: BORRADOR | EN_REVISION | APROBADO
      :fecha_creacion: YYYY-MM-DD
      :ultima_actualizacion: YYYY-MM-DD
      :autor: [Nombre del Autor]
      :revisor: [Nombre del Revisor]

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   1. Proposito
   ============

   [Descripcion clara y concisa de que hace este modulo y que problema resuelve]

   **Pregunta clave que responde:**

      [Ej: "¿Quien eres? ¿Tu sesion es valida?"]

   ----

   2. Alcance
   ==========

   2.1 Incluye
   -----------

   - [Funcionalidad incluida 1]
   - [Funcionalidad incluida 2]
   - [Funcionalidad incluida 3]

   2.2 Excluye (NO incluye)
   ------------------------

   - [Funcionalidad excluida 1] → Pertenece a ARQ_MOD_YYY
   - [Funcionalidad excluida 2] → Pertenece a ARQ_MOD_ZZZ

   ----

   3. Responsabilidades
   ====================

   3.1 PUEDE Hacer
   ---------------

   .. list-table::
      :widths: 70 30
      :header-rows: 1

      * - Responsabilidad
        - UC Relacionado
      * - [Responsabilidad 1]
        - UC_XXX
      * - [Responsabilidad 2]
        - UC_YYY

   3.2 NO PUEDE Hacer (Violaciones)
   --------------------------------

   .. warning::

      Las siguientes acciones violan la separacion de responsabilidades:

   - [Violacion tipica 1] → Eso es responsabilidad de ARQ_MOD_YYY
   - [Violacion tipica 2] → Eso es responsabilidad de ARQ_MOD_ZZZ
   - [Violacion tipica 3] → Viola restriccion CNST_XXX

   ----

   4. Dependencias
   ===============

   4.1 Depende de
   --------------

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Modulo
        - Razon
      * - ARQ_MOD_YYY
        - [Razon de dependencia]

   4.2 Es Requerido por
   --------------------

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Modulo
        - Razon
      * - ARQ_MOD_ZZZ
        - [Razon]

   ----

   5. Componentes Tecnicos
   =======================

   5.1 Apps Django
   ---------------

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - App
        - Descripcion
      * - apps.[nombre]
        - [Descripcion]

   5.2 Modelos de Datos
   --------------------

   - DSC_MOD_XXX_[Modelo1]
   - DSC_MOD_YYY_[Modelo2]

   5.3 APIs Expuestas
   ------------------

   - API_XXX_[Endpoints]

   ----

   6. Restricciones Aplicables
   ===========================

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - CNST
        - Descripcion
      * - CNST_XXX
        - [Como afecta a este modulo]

   ----

   7. Casos de Uso Asociados
   =========================

   .. list-table::
      :widths: 15 50 35
      :header-rows: 1

      * - UC ID
        - Nombre
        - Descripcion
      * - UC_XXX
        - [Nombre UC]
        - [Descripcion breve]

   ----

   8. Requisitos Funcionales Derivados
   ===================================

   .. list-table::
      :widths: 15 50 35
      :header-rows: 1

      * - FR ID
        - Nombre
        - Deriva de UC
      * - FR_XXX
        - [Nombre FR]
        - UC_YYY

   ----

   9. Diagrama de Contexto
   =======================

   .. code-block:: text

      +------------------+
      |   ARQ_MOD_XXX    |
      |   [NOMBRE]       |
      +--------+---------+
               |
        +------+------+
        |             |
        v             v
   [Dependencia1] [Dependencia2]

   ----

   10. Historial de Cambios
   ========================

   .. list-table::
      :widths: 15 15 70
      :header-rows: 1

      * - Version
        - Fecha
        - Cambios
      * - 1.0.0
        - YYYY-MM-DD
        - Version inicial

----

4. Ejemplo de Uso
=================

Ver: ``ARQ_MOD_001_AUTH.rst`` como referencia de implementacion.

----

5. Reglas de Nomenclatura
=========================

- **Prefijo:** ARQ_MOD\_
- **Numero:** 3 digitos (001-008)
- **Nombre:** Codigo corto en mayusculas
- **Extension:** .rst

Ejemplos:

- ARQ_MOD_001_AUTH.rst
- ARQ_MOD_002_USER_IDENTITY.rst
- ARQ_MOD_003_RBAC_CORE.rst

----

6. Ubicacion en Estructura
==========================

.. code-block:: text

   IACT/
   +-- arquitectura_tecnica/
       +-- arquitectura/
           +-- modulos/
               +-- index.rst
               +-- ARQ_MOD_001_AUTH.rst
               +-- ARQ_MOD_002_USER_IDENTITY.rst
               +-- ...

----

7. Validacion
=============

Checklist antes de aprobar un ARQ_MOD:

.. list-table::
   :widths: 10 90
   :header-rows: 0

   * - [ ]
     - Proposito claro y pregunta clave definida
   * - [ ]
     - Alcance con inclusiones y exclusiones explicitas
   * - [ ]
     - Responsabilidades PUEDE/NO PUEDE documentadas
   * - [ ]
     - Dependencias identificadas
   * - [ ]
     - Apps Django mapeadas
   * - [ ]
     - CNST aplicables listadas
   * - [ ]
     - UC asociados listados
   * - [ ]
     - FR derivados listados
   * - [ ]
     - No hay solapamiento con otros ARQ_MOD

----

*Plantilla version 1.0.0 - 2025-12-22*
