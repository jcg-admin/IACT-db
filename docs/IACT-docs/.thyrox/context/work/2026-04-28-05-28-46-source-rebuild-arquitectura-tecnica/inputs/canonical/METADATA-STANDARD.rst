==================================================
PlantUML Diagram Metadata Standard — @IACT-DIAGRAM
==================================================

:project: IACT-docs
:created: 2026-04-25
:updated: 2026-04-26
:status: Active (updated Phase C: Consolidated PlantUML v2.0.0)

Propósito
=========

**Phase C Update (2026-04-26):** As of Phase C Consolidation, all PlantUML diagrams should use the single consolidated style file at ``_static/plantuml-styles.puml`` (v2.0.0). See `GUIDELINES.rst <GUIDELINES.rst>`_ for consolidation details.

El estándar **@IACT-DIAGRAM** automatiza la organización de diagramas PlantUML en la estructura:

.. code-block:: text

   build/html/_static/img/diagrams/
   ├── {modulo}/
   │   └── {tipo}/
   │       └── {diagrama}.png

Sin necesidad de archivos de configuración separados — los metadatos viven directamente en el código PlantUML.

Formato de Metadatos
====================

Agregar al inicio de cada bloque PlantUML:

.. code-block:: plaintext

   ' @IACT-DIAGRAM
   ' module: {modulo}
   ' type: {tipo}
   ' description: {descripción opcional}

**Ubicación:** Justo después de ``!include`` en el bloque ``.. uml::``.

Ejemplo Completo
================

.. code-block:: rst

   .. uml::

      !include ../_static/plantuml-styles.puml

      ' @IACT-DIAGRAM
      ' module: requisitos
      ' type: use-case
      ' description: Sistema de autenticación de usuario

      actor "Usuario" as user
      usecase "Iniciar sesión" as login

      user --> login

Módulos Válidos
===============

.. list-table::
   :header-rows: 1

   * - Módulo
     - Descripción
   * - ``requisitos``
     - Especificaciones, casos de uso, requisitos
   * - ``arquitectura_tecnica``
     - Arquitectura, componentes, despliegue
   * - ``base_cognitiva``
     - Conceptos, taxonomías, metamodelos
   * - ``normativa``
     - Gobernanza, procedimientos, políticas
   * - ``gestion``
     - Gestión de proyecto, recursos
   * - ``plantuml-guide``
     - Ejemplos y guías de PlantUML


Tipos Válidos
=============

.. list-table::
   :header-rows: 1

   * - Tipo
     - UML Equivalent
     - Ejemplo
   * - ``use-case``
     - Use Case Diagram
     - Actor + Usecase (oval)
   * - ``component``
     - Component Diagram
     - Componentes, interfaces, dependencias
   * - ``sequence``
     - Sequence Diagram
     - Actores, mensajes, sincronización
   * - ``activity``
     - Activity Diagram
     - Flujos, decisiones, paralelismo
   * - ``state``
     - State Machine
     - Estados, transiciones
   * - ``deployment``
     - Deployment Diagram
     - Nodos, artefactos, conexiones
   * - ``diagram``
     - Genérico
     - Cualquier diagrama sin tipo específico


Ejemplo por Tipo
================

**Use Case:**

.. code-block:: plaintext

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case

   actor "Usuario"
   usecase "Consultar datos"

**Component:**

.. code-block:: plaintext

   ' @IACT-DIAGRAM
   ' module: arquitectura_tecnica
   ' type: component

   package "Backend" {
     component [API REST]
   }

**Sequence:**

.. code-block:: plaintext

   ' @IACT-DIAGRAM
   ' module: arquitectura_tecnica
   ' type: sequence

   actor User
   participant API
   User -> API: GET /data

**Activity:**

.. code-block:: plaintext

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: activity

   start
   :Procesar solicitud;
   end

Cómo Funciona (Internamente)
============================

1. **Pre-Build:** Sphinx analiza todos los archivos RST
2. **Extracción:** Lee metadatos ``@IACT-DIAGRAM`` de cada bloque ``.. uml::``
3. **Generación:** PlantUML genera PNGs con nombres de hash
4. **Post-Build:** Hook reorganiza los PNGs según módulo/tipo
5. **Resultado:** Estructura limpia sin necesidad de configuración manual

Proceso Automático:

.. code-block:: text

   RST files ──[extract metadata]──> Internal map: {puml_content: (modulo, tipo)}
                                       │
   Sphinx build ──[generates PNGs]──> build/html/_static/img/diagrams/{hash}/{file}.png
                                       │
   Post-build hook ──[reorganize]───> build/html/_static/img/diagrams/{modulo}/{tipo}/{file}.png

Nuevo Diagrama: Checklist
=========================

Para agregar un nuevo diagrama PlantUML:

1. ☐ Crear bloque ``.. uml::`` en archivo RST
2. ☐ Agregar ``!include ../_static/plantuml-styles.puml``
3. ☐ **Agregar metadatos @IACT-DIAGRAM** (¡esto es crítico!)
4. ☐ Completar el diagrama PlantUML
5. ☐ Ejecutar ``make clean && make html``
6. ☐ Verificar: Diagrama aparece en ``build/html/_static/img/diagrams/{modulo}/{tipo}/``

Preguntas Frecuentes
====================

**P: ¿Qué pasa si no agrego metadatos?**
R: El diagrama se coloca en ``diagrams/plantuml-guide/diagram/`` (default).

**P: ¿Puedo cambiar el módulo/tipo después?**
R: Sí, edita los metadatos en el bloque PlantUML y vuelve a ejecutar ``make html``.

**P: ¿Se sincroniza con Git?**
R: No. Los PNGs se reorganizan localmente en cada build. Git no rastrea cambios menores.

**P: ¿Puedo tener múltiples diagramas en un mismo RST file?**
R: Sí, cada bloque ``.. uml::`` puede tener sus propios metadatos.

Referencias
===========

- `PlantUML Language Reference <http://plantuml.com/guide>`_
- `sphinxcontrib.plantuml docs <https://pypi.org/project/sphinxcontrib-plantuml/>`_
- `IACT Color Palette <color-palette.rst>`_
- `IACT PlantUML Styling Guidelines <GUIDELINES.rst>`_
