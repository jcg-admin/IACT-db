.. meta::
   :artefacto: TXM_02
   :tipo: Taxonomia
   :dominio: base_cognitiva
   :subdominio: _taxonomias_y_metamodelos
   :subcarpeta: taxonomias
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _txm-02:

===============================
TXM_02: Taxonomia de Artefactos
===============================


Proposito
---------

Este documento presenta la **clasificacion jerarquica** de todos los tipos
de artefactos documentales del proyecto IACT. Define categorias, prefijos,
ubicaciones y relaciones entre artefactos.

----

1. Vista General de la Taxonomia
--------------------------------

.. code-block:: text

   ARTEFACTO DOCUMENTAL
   │
   ├── ARTEFACTO COGNITIVO (base_cognitiva/)
   │   ├── Metadata (META\_)
   │   ├── Glosario (GLOS\_)
   │   ├── Fundamento Conceptual (FND\_)
   │   ├── Ontologia SBVR (SBVR\_)
   │   ├── Taxonomia (TXM\_)
   │   ├── Metamodelo (MTM\_)
   │   └── Metodologia (METH\_)
   │
   ├── ARTEFACTO NORMATIVO (normativa/)
   │   ├── Procedimiento (PROC\_)
   │   ├── Estandar (STD\_)
   │   ├── Politica de Gobernanza (GOB\_)
   │   ├── Restriccion (CNST\_)
   │   └── Trazabilidad (RTM\_, COV\_)
   │
   ├── ARTEFACTO DE REQUISITOS (requisitos/)
   │   ├── Regla de Negocio (BR\_)
   │   ├── Caso de Uso (UC\_)
   │   ├── Requisito Funcional (FR\_)
   │   └── Requisito No Funcional (NFR\_)
   │
   └── ARTEFACTO ARQUITECTONICO (arquitectura/)
       ├── Decision Arquitectonica (ADR\_)
       ├── Vista Arquitectonica (VIEW\_)
       └── Modelo de Datos (MDL\_)

----

2. Artefactos Cognitivos
------------------------

2.1 Metadata (META\_)
^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/_metadata/

**Proposito:** Identidad, clasificacion y contexto del proyecto.

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Artefacto
     - Contenido
   * - META_01
     - Identificacion del Proyecto (nombre, codigo, version)
   * - META_02
     - Clasificacion de Seguridad
   * - META_03
     - Contexto SDLC
   * - META_04
     - Stakeholders
   * - META_05
     - Alcance del Proyecto

2.2 Glosario (GLOS\_)
^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/glosario/

**Proposito:** Definiciones de terminos del dominio.

**Formato:** Termino + Definicion + Sinonimos + Contexto

2.3 Fundamento Conceptual (FND\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/_fundamentos_conceptuales/

**Proposito:** Marco teorico que fundamenta el modelo de analisis.

.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - ID
     - Contenido
   * - FND_01
     - Concepto de Requisito
   * - FND_02
     - Reglas de Negocio
   * - FND_03
     - Casos de Uso
   * - FND_04
     - Trazabilidad
   * - FND_05
     - Jerarquia de 4 Niveles
   * - FND_06
     - Derivacion vs Transformacion
   * - FND_07
     - Requerimientos Funcionales

2.4 Ontologia SBVR (SBVR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/_ontologia_sbvr/

**Proposito:** Semantica formal de conceptos segun estandar SBVR.

.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - ID
     - Contenido
   * - SBVR_01
     - Conceptos Nucleares (sustantivos)
   * - SBVR_02
     - Fact Types (verbos/relaciones)
   * - SBVR_03
     - Reglas Estructurales (aleticas)
   * - SBVR_04
     - Reglas Operativas (deonticas)
   * - SBVR_05
     - Vocabulario Controlado

2.5 Taxonomia (TXM\_)
^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/_taxonomias_y_metamodelos/taxonomias/

**Proposito:** Clasificaciones jerarquicas de conceptos.

.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - ID
     - Contenido
   * - TXM_01
     - Taxonomia de Requisitos
   * - TXM_02
     - Taxonomia de Artefactos (este documento)
   * - TXM_03
     - Taxonomia de Reglas de Negocio

2.6 Metamodelo (MTM\_)
^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/_taxonomias_y_metamodelos/metamodelos/

**Proposito:** Estructuras formales (diagramas UML/ER).

.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - ID
     - Contenido
   * - MTM_01
     - Metamodelo de Requisitos
   * - MTM_02
     - Metamodelo de Trazabilidad
   * - MTM_03
     - Metamodelo RBAC

2.7 Metodologia (METH\_)
^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** base_cognitiva/_metodologias_analiticas/

**Proposito:** Procedimientos de analisis y derivacion.

.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - ID
     - Contenido
   * - METH_01
     - Derivacion UC desde BR
   * - METH_02
     - Derivacion FR desde UC
   * - METH_03
     - Tecnicas de Larman

----

3. Artefactos Normativos
------------------------

3.1 Procedimiento (PROC\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** normativa/procedimientos/

**Proposito:** Pasos para ejecutar procesos del proyecto.

**Ejemplos:**

- PROC_01: Procedimiento de Cambio de Requisitos
- PROC_02: Procedimiento de Revision de Artefactos
- PROC_03: Procedimiento de Aprobacion

3.2 Estandar (STD\_)
^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** normativa/estandares/

**Proposito:** Reglas de formato, nomenclatura, estructura.

**Ejemplos:**

- STD_01: Estandar de Nomenclatura de Artefactos
- STD_02: Estandar de Formato RST
- STD_03: Estandar de Versionado

3.3 Politica de Gobernanza (GOB\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** normativa/gobernanza/

**Proposito:** Lineamientos de alto nivel para gestion documental.

3.4 Restriccion (CNST\_)
^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** normativa/restricciones/

**Proposito:** Limitaciones impuestas al proyecto.

.. list-table::
   :header-rows: 1
   :widths: 15 85

   * - ID
     - Contenido
   * - CNST_001
     - Sin Correo Electronico Externo
   * - CNST_002
     - BD IVR Solo Lectura
   * - CNST_003
     - Sesion Unica por Usuario
   * - CNST_004
     - Auditoria Inmutable

----

4. Artefactos de Requisitos
---------------------------

4.1 Regla de Negocio (BR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** requisitos/reglas_negocio/

**Proposito:** Politicas y restricciones del dominio.

**Formato:** Definicion + Tipo + Modalidad + Fuente + Justificacion

**Ejemplos IACT:**

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - ID
     - Nombre
     - Tipo
   * - BR_001
     - Fuente Operacional Inmutable
     - Restriccion
   * - BR_002
     - Sincronizacion ETL Nocturna
     - Desencadenador
   * - BR_011
     - Modelo RBAC Flat
     - Hecho
   * - BR_015
     - Separacion de Funciones
     - Restriccion

4.2 Caso de Uso (UC\_)
^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** requisitos/casos_uso/

**Proposito:** Narrativas de interaccion actor-sistema.

**Formato:** Actor + Objetivo + Precondiciones + Flujos + Postcondiciones

**Cantidad IACT:** 38 casos de uso identificados

4.3 Requisito Funcional (FR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** requisitos/funcionales/

**Proposito:** Especificaciones atomicas de capacidades.

**Formato:** FR-UC.SEQ: Enunciado + Criterio + Origen

**Cantidad IACT:** ~300 estimados

4.4 Requisito No Funcional (NFR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** requisitos/no_funcionales/

**Proposito:** Atributos de calidad del sistema.

**Categorias:** Rendimiento, Seguridad, Usabilidad, Confiabilidad

----

5. Artefactos Arquitectonicos
-----------------------------

5.1 Decision Arquitectonica (ADR\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** arquitectura/decisiones/

**Proposito:** Documentar decisiones de diseno y su justificacion.

**Formato:** Contexto + Decision + Consecuencias + Alternativas

**Ejemplo IACT:**

- ADR_001: Seleccion de Flat RBAC sobre Hierarchical RBAC

5.2 Vista Arquitectonica (VIEW\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** arquitectura/vistas/

**Proposito:** Perspectivas del sistema (4+1, C4).

**Tipos:**

- VIEW_LOGICA: Componentes y clases
- VIEW_PROCESO: Flujos y secuencias
- VIEW_FISICA: Despliegue e infraestructura
- VIEW_DESARROLLO: Organizacion de codigo

5.3 Modelo de Datos (MDL\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** arquitectura/datos/

**Proposito:** Esquemas de base de datos.

**Tipos:**

- MDL_CONCEPTUAL: Entidades y relaciones (ER)
- MDL_LOGICO: Tablas y columnas
- MDL_FISICO: DDL especifico

----

6. Artefactos de Trazabilidad
-----------------------------

6.1 Matriz RTM (RTM\_)
^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** normativa/trazabilidad/

**Proposito:** Relacionar requisitos entre niveles.

**Formato:** BR -> UC -> FR -> Test -> Codigo

**Artefacto Principal:**

- RTM_IACT_v1_0_0.rst: Matriz de trazabilidad completa

6.2 Reporte de Cobertura (COV\_)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Ubicacion:** normativa/trazabilidad/

**Proposito:** Medir completitud de trazabilidad.

**Metricas:**

- % BR con UC derivados
- % UC con FR derivados
- % FR con tests asociados

----

7. Matriz de Artefactos por Dominio
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 25 20 15 40

   * - Dominio
     - Prefijos
     - Cantidad
     - Proposito
   * - base_cognitiva
     - META, GLOS, FND, SBVR, TXM, MTM, METH
     - ~25
     - Base semantica y conceptual
   * - normativa
     - PROC, STD, GOB, CNST, RTM, COV
     - ~25
     - Normas, gobernanza y trazabilidad
   * - requisitos
     - BR, UC, FR, NFR
     - ~350
     - Especificacion del sistema
   * - arquitectura
     - ADR, VIEW, MDL
     - ~10
     - Diseno tecnico

----

8. Nomenclatura y Convenciones
------------------------------

8.1 Formato de Identificador
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   [PREFIJO]_[NNN]_[Nombre_Descriptivo].rst

   Donde:
   - PREFIJO: Codigo de tipo (BR, UC, FND, etc.)
   - NNN:     Numero secuencial (3 digitos)
   - Nombre:  Descripcion en snake_case

   Ejemplos:
   - BR_001_Fuente_Inmutable.rst
   - UC_010_Asignar_Rol.rst
   - FND_05_Jerarquia_4_Niveles.rst

8.2 Caso Especial: FR
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR_UC[NNN]_[Nombre_UC].rst

   Donde el archivo contiene todos los FR del UC.

   Ejemplo:
   - FR_UC010_Asignar_Rol.rst (contiene FR-10.1 a FR-10.N)

8.3 Visibilidad
^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Prefijo Carpeta
     - Visibilidad
     - Ejemplo
   * - _ (guion bajo)
     - PRIVADO (excluido de build)
     - _fundamentos_conceptuales/
   * - (sin prefijo)
     - PUBLICO (incluido en build)
     - requisitos/, arquitectura/

----

9. Ciclo de Vida de Artefactos
------------------------------

9.1 Estados
^^^^^^^^^^^

.. code-block:: text

   BORRADOR
       |
       v
   EN_REVISION
       |
       v
   APROBADO
       |
       +---> OBSOLETO (si se reemplaza)
       |
       +---> CONGELADO (si es estable)

9.2 Versionado
^^^^^^^^^^^^^^

.. code-block:: text

   MAJOR.MINOR.PATCH

   - MAJOR: Cambios incompatibles o reestructuracion
   - MINOR: Nuevas secciones o contenido significativo
   - PATCH: Correcciones menores, typos

   Ejemplo: v1.2.3
   - 1: Primera version mayor estable
   - 2: Dos adiciones de contenido
   - 3: Tres correcciones menores

----

10. Estadisticas del Sistema Documental
---------------------------------------

10.1 Por Dominio
^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Dominio
     - Subdominios
     - Artefactos
     - Lineas (est.)
   * - base_cognitiva
     - 6
     - ~25
     - ~12,000
   * - normativa
     - 5
     - ~25
     - ~12,000
   * - requisitos
     - 4
     - ~350
     - ~15,000
   * - arquitectura
     - 3
     - ~10
     - ~2,000
   * - **TOTAL**
     - **18**
     - **~410**
     - **~41,000**

10.2 Por Estado
^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Estado
     - Subdominios
     - Descripcion
   * - CONGELADO
     - 12
     - Estructura estable, contenido puede evolucionar
   * - DESCONGELADO
     - 5
     - Estructura activa, en desarrollo

----

11. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`txm-01` - Taxonomia de Requisitos
- :ref:`mtm-01` - Metamodelo de Requisitos
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- ARBOL_COMPLETO_IACT_v2_0_0 - Estructura oficial

Fuentes
^^^^^^^

- IEEE 1471: Architecture Description
- ISO/IEC 42010: Systems Architecture

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
   * - 1.1.0
     - 2025-12-22
     - Equipo IACT
     - Correccion nomenclatura: dominio "gobernanza" renombrado a "normativa". Actualizado estructura de subdominios (procedimientos, estandares, gobernanza, restricciones, trazabilidad). Actualizado estadisticas.
   * - 1.0.0
     - 2025-12-20
     - Equipo IACT
     - Version inicial con taxonomia completa

----

**Trazabilidad:** Esta taxonomia clasifica todos los artefactos del sistema
documental IACT. Es el mapa completo de la documentacion del proyecto y
sirve como referencia para ubicar cualquier tipo de artefacto.
