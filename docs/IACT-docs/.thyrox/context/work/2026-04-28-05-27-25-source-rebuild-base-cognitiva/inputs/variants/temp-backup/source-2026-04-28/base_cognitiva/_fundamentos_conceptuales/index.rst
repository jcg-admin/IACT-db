.. _fundamentos-conceptuales-index:

========================
Fundamentos Conceptuales
========================

:Dominio: base_cognitiva
:Subdominio: _fundamentos_conceptuales
:Estado: CONGELADO
:Visibilidad: PRIVADO (excluido de build HTML)
:Documentos: 7
:Ultima Actualizacion: 2025-12-19

Proposito
---------

Este subdominio contiene el **marco teorico y conceptual** que fundamenta
todo el modelo de analisis del proyecto IACT. Define QUE ES cada concepto
clave utilizado en la especificacion de requisitos.

.. important::

   **FND = Fundamento Conceptual (teoria)**

   Los fundamentos conceptuales responden a la pregunta "Que ES esto?"
   No describen COMO hacer algo (eso corresponde a metodologias_analiticas).

   Ejemplo:

   - FND_02 explica QUE ES una Regla de Negocio
   - METH_01 explica COMO derivar Casos de Uso desde Reglas de Negocio

Audiencia
---------

- Nuevos miembros del equipo (onboarding conceptual)
- Business Analysts que necesitan entender la terminologia
- Arquitectos que definen estructura documental
- Cualquier rol que requiera claridad sobre conceptos base

Pregunta Central
----------------

Este subdominio responde a:

   **"Por que este modelo de analisis? Que significa cada concepto?"**

Catalogo de Fundamentos
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 10 35 55

   * - ID
     - Titulo
     - Contenido Principal
   * - FND_01
     - :ref:`fnd-01`
     - Definicion de requisito, tipos, caracteristicas
   * - FND_02
     - :ref:`fnd-02`
     - Reglas de Negocio, tipos SBVR, modalidades
   * - FND_03
     - :ref:`fnd-03`
     - Casos de Uso, estructura, actores, flujos
   * - FND_04
     - :ref:`fnd-04`
     - Trazabilidad, tipos, RTM, beneficios
   * - FND_05
     - :ref:`fnd-05`
     - Jerarquia 4 niveles BR-BReq-UC-FR
   * - FND_06
     - :ref:`fnd-06`
     - Derivacion vs Transformacion, responsabilidad unica
   * - FND_07
     - :ref:`fnd-07`
     - Requerimientos Funcionales, SMART, criterios aceptacion

Organizacion Conceptual
-----------------------

Conceptos Base (Que ES)
^^^^^^^^^^^^^^^^^^^^^^^

Definiciones fundamentales de los artefactos de analisis.

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-07` - Requerimientos Funcionales

Estructura y Relaciones
^^^^^^^^^^^^^^^^^^^^^^^

Como se organizan y relacionan los conceptos entre si.

- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-04` - Trazabilidad

Principios de Transformacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fundamentos teoricos del proceso de derivacion.

- :ref:`fnd-06` - Derivacion vs Transformacion

Flujo de Lectura Recomendado
----------------------------

Para nuevos miembros del equipo, se recomienda leer en este orden:

.. code-block:: text

   1. FND_01 (Concepto Requisito)
          |
          v
   2. FND_05 (Jerarquia 4 Niveles)
          |
          +---> 3a. FND_02 (Reglas de Negocio)
          |
          +---> 3b. FND_03 (Casos de Uso)
          |
          +---> 3c. FND_07 (Requerimientos Funcionales)
          |
          v
   4. FND_06 (Derivacion vs Transformacion)
          |
          v
   5. FND_04 (Trazabilidad)

Relacion con Otros Subdominios
------------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Subdominio
     - Relacion
   * - _ontologia_sbvr/
     - FND_02 referencia conceptos SBVR definidos en ontologia
   * - _metodologias_analiticas/
     - METH_01 y METH_02 aplican conceptos de FND_02, FND_03, FND_07
   * - _taxonomias_y_metamodelos/
     - Taxonomias clasifican los conceptos definidos aqui
   * - glosario/
     - Terminos tecnicos se definen en el glosario, aqui se explican
   * - requisitos/
     - Los artefactos BR, UC, FR implementan estos conceptos

Fuentes Documentales
--------------------

Los fundamentos conceptuales se basan en:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Documento Fuente
     - Contenido Extraido
   * - CONTEXTO_Y_FUNDAMENTOS.md
     - Jerarquia 4 niveles, problema de trazabilidad
   * - ESPECIFICAR_REQUERIMIENTOS_FUNCIONALES.txt
     - Definicion FR, caracteristicas SMART
   * - ESTRATEGIA_DERIVACION_FR_PROYECTO_GREENFIELD.md
     - Derivacion vs Transformacion, responsabilidad unica
   * - Introduccion_a_las_Tecnicas_de_Larman.md
     - Eventos del sistema, contratos de operacion
   * - 978-3-540-88808-6_20.txt (Paper IBM)
     - Fundamentos SBVR, modalidades aletica/deontica

Historial de Versiones
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 70

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2025-12-19
     - Version inicial con 7 documentos FND

----

Indice de Documentos
--------------------

.. toctree::
   :maxdepth: 1
   :caption: Fundamentos Conceptuales

   FND_01_Concepto_Requisito
   FND_02_Reglas_de_Negocio
   FND_03_Casos_de_Uso
   FND_04_Trazabilidad
   FND_05_Jerarquia_4_Niveles
   FND_06_Derivacion_vs_Transformacion
   FND_07_Requerimientos_Funcionales
