.. meta::
   :dominio: base_cognitiva
   :subdominio: _taxonomias_y_metamodelos
   :tipo: Indice
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _taxonomias-y-metamodelos-index:

========================
Taxonomias y Metamodelos
========================


Proposito del Subdominio
------------------------

Este subdominio contiene las **clasificaciones jerarquicas** (taxonomias) y
las **estructuras formales** (metamodelos) que organizan los conceptos del
proyecto IACT.

.. note::

   **Subdominio DESCONGELADO**

   Criterio: Reglas incompatibles entre TXM y MTM.

   - Taxonomias (TXM\_): Clasifican conceptos en jerarquias
   - Metamodelos (MTM\_): Definen estructuras formales (UML)

   Tienen templates y notaciones diferentes, por lo que se organizan
   en subcarpetas separadas.

----

Audiencia
---------

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Rol
     - Uso del Subdominio
   * - Arquitecto
     - Referencia para estructura formal del sistema
   * - Analista de Negocio
     - Clasificacion de requisitos y artefactos
   * - Desarrollador
     - Comprension de modelos de datos y relaciones
   * - QA
     - Validacion de cobertura y trazabilidad

----

Estructura del Subdominio
-------------------------

.. code-block:: text

   _taxonomias_y_metamodelos/
   │
   ├── index.rst                              ← Este archivo
   │
   ├── taxonomias/                            ← Clasificaciones jerarquicas
   │   ├── TXM_01_Taxonomia_Requisitos.rst
   │   ├── TXM_02_Taxonomia_Artefactos.rst
   │   └── TXM_03_Taxonomia_Reglas_Negocio.rst
   │
   └── metamodelos/                           ← Estructuras formales UML
       ├── MTM_01_Metamodelo_Requisitos.rst
       ├── MTM_02_Metamodelo_Trazabilidad.rst
       └── MTM_03_Metamodelo_RBAC.rst

----

Catalogo de Taxonomias
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - ID
     - Nombre
     - Contenido
   * - TXM_01
     - :ref:`txm-01`
     - Clasificacion jerarquica de tipos de requisitos (BR, UC, FR, NFR)
   * - TXM_02
     - :ref:`txm-02`
     - Clasificacion de todos los artefactos del sistema documental
   * - TXM_03
     - :ref:`txm-03`
     - Clasificacion de los 5 tipos de Business Rules

Proposito de las Taxonomias
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las taxonomias responden a la pregunta **"¿Como se clasifican los conceptos?"**

- Organizan conceptos en categorias jerarquicas
- Definen criterios de clasificacion
- Proporcionan arboles de decision
- NO definen relaciones formales (eso es trabajo de metamodelos)

----

Catalogo de Metamodelos
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - ID
     - Nombre
     - Contenido
   * - MTM_01
     - :ref:`mtm-01`
     - Diagrama UML de clases de tipos de requisitos
   * - MTM_02
     - :ref:`mtm-02`
     - Modelo formal de trazabilidad y tipos de enlaces
   * - MTM_03
     - :ref:`mtm-03`
     - Modelo RBAC: Usuario, Rol, Permiso, Sesion, Segmento

Proposito de los Metamodelos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los metamodelos responden a la pregunta **"¿Como se relacionan formalmente?"**

- Definen estructura con diagramas UML
- Especifican cardinalidades y restricciones
- Incluyen invariantes OCL
- Sirven como base para validacion automatica

----

Diferencia: Taxonomia vs Metamodelo
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 25 37 38

   * - Aspecto
     - Taxonomia (TXM)
     - Metamodelo (MTM)
   * - Pregunta
     - ¿Como se clasifica?
     - ¿Como se estructura?
   * - Notacion
     - Arboles jerarquicos
     - Diagramas UML
   * - Contenido
     - Categorias y subtipos
     - Clases y relaciones
   * - Proposito
     - Organizar conceptos
     - Formalizar estructura
   * - Ejemplo
     - "FR es subtipo de Requisito"
     - "FR tiene cardinalidad 1:N con UC"

----

Orden de Lectura Recomendado
----------------------------

Para comprension completa del modelo IACT:

.. code-block:: text

   1. TXM_01 Taxonomia Requisitos
      └── Entender tipos de requisitos

   2. TXM_03 Taxonomia Reglas Negocio
      └── Entender los 5 tipos de BR

   3. MTM_01 Metamodelo Requisitos
      └── Formalizar relaciones BR-UC-FR

   4. MTM_02 Metamodelo Trazabilidad
      └── Entender links y cobertura

   5. TXM_02 Taxonomia Artefactos
      └── Mapa completo del sistema documental

   6. MTM_03 Metamodelo RBAC
      └── Core de seguridad del sistema

----

Matriz de Relaciones
--------------------

Como se relacionan taxonomias y metamodelos:

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - Taxonomia
     - Metamodelo
     - Relacion
   * - TXM_01 (Requisitos)
     - MTM_01 (Requisitos)
     - TXM clasifica, MTM formaliza relaciones
   * - TXM_03 (BR)
     - MTM_01 (Requisitos)
     - TXM detalla tipos BR, MTM los relaciona con UC/FR
   * - TXM_02 (Artefactos)
     - MTM_02 (Trazabilidad)
     - TXM lista artefactos, MTM define enlaces entre ellos
   * - --
     - MTM_03 (RBAC)
     - Core de seguridad, referenciado por SBVR_01

----

Estadisticas del Subdominio
---------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Archivo
     - Lineas
     - Tipo
     - Estado
   * - TXM_01_Taxonomia_Requisitos
     - 651
     - Taxonomia
     - Completo
   * - TXM_02_Taxonomia_Artefactos
     - 639
     - Taxonomia
     - Completo
   * - TXM_03_Taxonomia_Reglas_Negocio
     - 682
     - Taxonomia
     - Completo
   * - MTM_01_Metamodelo_Requisitos
     - 654
     - Metamodelo
     - Completo
   * - MTM_02_Metamodelo_Trazabilidad
     - 625
     - Metamodelo
     - Completo
   * - MTM_03_Metamodelo_RBAC
     - 696
     - Metamodelo
     - Completo
   * - **TOTAL**
     - **3,947**
     - **6 artefactos**
     - **100%**

----

Referencias Cruzadas
--------------------

Subdominios Relacionados
^^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fundamentos-conceptuales-index` - Marco teorico (FND_01 a FND_07)
- :ref:`ontologia-sbvr-index` - Semantica formal SBVR
- gobernanza/trazabilidad/ - RTM basada en MTM_02

Documentos Fuente
^^^^^^^^^^^^^^^^^

- Modelo_RBAC_Completo_IACT (fuente para MTM_03)
- ARBOL_COMPLETO_IACT_v2_0_0 (estructura oficial)
- OMG SBVR 1.5 / UML 2.5.1 (estandares)

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-20
     - Equipo IACT
     - Version inicial con 3 TXM + 3 MTM

----

**Trazabilidad:** Este subdominio proporciona la estructura formal
(clasificaciones y modelos) que fundamenta todo el sistema documental
IACT. Es prerequisito para la creacion de artefactos en requisitos/
y gobernanza/trazabilidad/.

.. toctree::
   :hidden:
   :maxdepth: 1

   taxonomias/index
   metamodelos/index
