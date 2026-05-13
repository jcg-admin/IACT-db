.. meta::
   :artefacto: NOM_01
   :tipo: Normativa
   :dominio: base_cognitiva
   :subdominio: _normativa
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _nom-01:

==============================================================================
NOM_01: Nomenclatura Estándar del Proyecto IACT v1.0.0
==============================================================================

.. contents:: Contenido
   :depth: 3
   :local:

----

1. Propósito
============

Este documento define la **nomenclatura estándar** para todos los artefactos
del proyecto IACT. Establece las convenciones de nombres de archivo,
identificadores y versionado semántico que deben seguirse en toda la
documentación del proyecto.

.. important::

   **NORMATIVA OBLIGATORIA**
   
   Todos los artefactos generados en el proyecto DEBEN seguir estas
   convenciones. Las desviaciones requieren aprobación del Arquitecto
   de Documentación.

----

2. Principios Generales
=======================

2.1 Separadores
---------------

.. list-table::
   :widths: 20 30 50
   :header-rows: 1

   * - Separador
     - Uso
     - Ejemplo
   * - **Guión bajo (_)**
     - Entre componentes principales
     - UC_ACC_01, TPL_BR_1_0_0
   * - **Guión medio (-)**
     - En nombres descriptivos (multi-palabra)
     - Business-Rules, Call-Center
   * - **NUNCA espacios**
     - N/A
     - ❌ "UC ACC 01.rst"

2.2 Capitalización
------------------

- **Prefijos:** MAYÚSCULAS (UC, BR, FR, TPL, etc.)
- **Códigos módulo:** MAYÚSCULAS (AUTH, USR, ACC, etc.)
- **Nombres descriptivos:** PascalCase (Iniciar_Sesion, Crear_Usuario)
- **Extensión archivo:** minúsculas (.rst, .md, .py)

2.3 Idioma
----------

- **Identificadores/Códigos:** INGLÉS (UC, BR, FR, AUTH, USR)
- **Nombres descriptivos:** ESPAÑOL (Iniciar_Sesion, Crear_Usuario)
- **Contenido de documentos:** ESPAÑOL

----

3. Versionado Semántico
=======================

3.1 Formato
-----------

Todos los artefactos usan **versionado semántico SemVer 2.0.0**:

.. code-block:: text

   [MAJOR]_[MINOR]_[PATCH]
   
   Donde:
     MAJOR = Cambios incompatibles con versiones anteriores
     MINOR = Nueva funcionalidad compatible con versión anterior
     PATCH = Correcciones de bugs compatibles

**Ejemplos:**
- 1_0_0 → Versión inicial
- 1_1_0 → Agregada nueva sección (compatible)
- 2_0_0 → Cambio de nomenclatura v2.0 → v4.0 (incompatible)

3.2 Incremento de Versión
--------------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - Incremento
     - Cuándo
     - Ejemplo
   * - MAJOR
     - Cambio de estructura, nomenclatura, o incompatible
     - UC v2.0 → UC v4.0
   * - MINOR
     - Nueva sección, campo, o funcionalidad
     - Agregar diagrama PlantUML
   * - PATCH
     - Corrección de errores, typos, formato
     - Corregir referencia CNST

----

4. Nomenclatura por Tipo de Artefacto
=====================================

4.1 Templates (TPL)
-------------------

**Formato:**
.. code-block:: text

   TPL_[PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

**Componentes:**
- TPL = Prefijo de template
- [PREFIJO] = Tipo de artefacto (BR, UC, FR, etc.)
- [Nombre_Descriptivo] = En inglés, PascalCase, guiones medios
- [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   TPL_BR_Business_Rules_1_0_0.rst
   TPL_UC_Casos_de_Uso_2_0_0.rst
   TPL_FR_Requisitos_Funcionales_1_0_0.rst
   TPL_CNST_Restricciones_1_0_0.rst
   TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
   TPL_PROC_Procedimientos_1_0_0.rst
   TPL_INDEX_Indices_1_0_0.rst

4.2 Casos de Uso (UC)
---------------------

**Identificador:**
.. code-block:: text

   UC_[MOD]_[NN]
   
   Donde:
     UC    = Prefijo estándar
     [MOD] = Código módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
     [NN]  = Secuencial dentro del módulo (01, 02, 03, ...)

**Nombre de Archivo:**
.. code-block:: text

   UC_[MOD]_[NN]_[Nombre_Descriptivo].rst

**Ejemplos:**

.. code-block:: text

   UC_AUTH_01_Iniciar_Sesion.rst
   UC_USR_01_Crear_Usuario.rst
   UC_ACC_01_Asignar_Funciones.rst
   UC_PIP_01_Supervisar_ETL.rst
   UC_RPT_06_Exportar_CSV.rst
   UC_ALR_01_Configurar_Alerta.rst
   UC_AUD_01_Consultar_Auditoria.rst
   UC_LOG_01_Consultar_Logs.rst

**Códigos de Módulo (8):**

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - Código
     - Módulo
     - Descripción
   * - AUTH
     - MOD_Auth
     - Autenticación y gestión de sesiones
   * - USR
     - MOD_Users
     - Gestión de usuarios e identidades
   * - ACC
     - MOD_Access
     - Control de acceso RBAC
   * - PIP
     - MOD_Pipeline
     - Supervisión del proceso ETL
   * - RPT
     - MOD_Reports
     - Reportes, dashboard y exportación
   * - ALR
     - MOD_Alerts
     - Alertas y notificaciones internas
   * - AUD
     - MOD_Audit
     - Auditoría y compliance
   * - LOG
     - MOD_Logs
     - Bitácoras técnicas del sistema

4.3 Reglas de Negocio (BR)
---------------------------

**Formato:**
.. code-block:: text

   BR_[NNN]_[Nombre_Descriptivo].rst
   
   Donde:
     BR    = Prefijo Business Rule
     [NNN] = Secuencial global (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, PascalCase

**Ejemplos:**

.. code-block:: text

   BR_001_Cliente_Debe_Autenticarse.rst
   BR_007_Separacion_Funciones.rst
   BR_015_Restriccion_SoD.rst

4.4 Requisitos Funcionales (FR)
-------------------------------

**Formato:**
.. code-block:: text

   FR_[UC]_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     FR    = Prefijo Functional Requirement
     [UC]  = UC origen (AUTH_01, ACC_01, etc.)
     [NN]  = Secuencial dentro del UC (01, 02, 03, ...)
     [Nombre_Descriptivo] = Opcional, en español

**Ejemplos:**

.. code-block:: text

   FR_AUTH_01_01_Validar_Credenciales.rst
   FR_ACC_01_06_Verificar_SoD.rst
   FR_RPT_06_03_Generar_CSV.rst

4.5 Restricciones de Arquitectura (CNST)
----------------------------------------

**Formato:**
.. code-block:: text

   CNST_[NNN]_[Nombre_Descriptivo].rst
   
   Donde:
     CNST  = Prefijo Constraint
     [NNN] = Secuencial global (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, PascalCase

**Ejemplos:**

.. code-block:: text

   CNST_001_Comunicaciones_Prohibidas.rst
   CNST_002_Sesion_Unica_Timeout.rst
   CNST_003_BD_Dual_Inmutable.rst
   CNST_005_RBAC_Flat_NIST.rst

4.6 Objetivos de Negocio (BReq)
--------------------------------

**Formato:**
.. code-block:: text

   BReq_[NNN]_[Nombre_Descriptivo].rst
   
   Donde:
     BReq  = Prefijo Business Requirement
     [NNN] = Secuencial global (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, PascalCase

**Ejemplos:**

.. code-block:: text

   BReq_001_Objetivos_IACT.rst
   BReq_002_Mejorar_Visibilidad_IVR.rst
   BReq_004_Cumplimiento_Seguridad.rst

4.7 Decisiones Arquitectónicas (ADR)
------------------------------------

**Formato:**
.. code-block:: text

   ADR_[NNN]_[Nombre_Descriptivo].rst
   
   Donde:
     ADR   = Prefijo Architecture Decision Record
     [NNN] = Secuencial global (001, 002, 003, ...)
     [Nombre_Descriptivo] = En inglés, kebab-case

**Ejemplos:**

.. code-block:: text

   ADR_001_Database_PostgreSQL.rst
   ADR_003_RBAC_Flat_Model.rst
   ADR_007_No_External_Communications.rst

4.8 Fundamentos Conceptuales (FND)
-----------------------------------

**Formato:**
.. code-block:: text

   FND_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     FND   = Prefijo Foundation
     [NN]  = Secuencial (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   FND_01_Concepto_Requisito.rst
   FND_02_Reglas_de_Negocio.rst
   FND_03_Casos_de_Uso.rst
   FND_05_Jerarquia_4_Niveles.rst

4.9 Ontología SBVR
------------------

**Formato:**
.. code-block:: text

   SBVR_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     SBVR  = Prefijo Semantics of Business Vocabulary
     [NN]  = Secuencial (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   SBVR_01_Conceptos_Nucleares.rst
   SBVR_02_Fact_Types.rst
   SBVR_03_Reglas_Estructurales.rst
   SBVR_05_Vocabulario_Controlado.rst

4.10 Taxonomías (TXM)
----------------------

**Formato:**
.. code-block:: text

   TXM_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     TXM   = Prefijo Taxonomy
     [NN]  = Secuencial (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   TXM_01_Taxonomia_Requisitos.rst
   TXM_02_Taxonomia_Artefactos.rst
   TXM_03_Taxonomia_Reglas_Negocio.rst

4.11 Metamodelos (MTM)
-----------------------

**Formato:**
.. code-block:: text

   MTM_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     MTM   = Prefijo Metamodel
     [NN]  = Secuencial (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   MTM_01_Metamodelo_Requisitos.rst
   MTM_02_Metamodelo_Trazabilidad.rst
   MTM_03_Metamodelo_RBAC.rst

4.12 Metadata (META)
--------------------

**Formato:**
.. code-block:: text

   META_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     META  = Prefijo Metadata
     [NN]  = Secuencial (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   META_01_Identidad_Proyecto.rst
   META_02_Clasificacion_Documental.rst
   META_04_Contexto_IACT.rst
   META_05_Estructura_Documental.rst

----

5. Catálogo Completo de Prefijos
=================================

.. list-table::
   :widths: 10 30 15 45
   :header-rows: 1

   * - Prefijo
     - Nombre Completo
     - Dominio
     - Uso
   * - UC
     - Use Case
     - requisitos
     - Casos de uso del sistema
   * - BR
     - Business Rule
     - requisitos
     - Reglas de negocio
   * - FR
     - Functional Requirement
     - requisitos
     - Requisitos funcionales
   * - NFR
     - Non-Functional Requirement
     - requisitos
     - Requisitos no funcionales
   * - BReq
     - Business Requirement
     - requisitos
     - Objetivos de negocio
   * - CNST
     - Constraint
     - requisitos
     - Restricciones de arquitectura
   * - ADR
     - Architecture Decision Record
     - arquitectura
     - Decisiones arquitectónicas
   * - TPL
     - Template
     - normativa
     - Plantillas de documentos
   * - FND
     - Foundation
     - base_cognitiva
     - Fundamentos conceptuales
   * - SBVR
     - SBVR Ontology
     - base_cognitiva
     - Ontología SBVR
   * - TXM
     - Taxonomy
     - base_cognitiva
     - Taxonomías
   * - MTM
     - Metamodel
     - base_cognitiva
     - Metamodelos
   * - META
     - Metadata
     - base_cognitiva
     - Metadata del proyecto
   * - PROC
     - Procedure
     - normativa
     - Procedimientos
   * - POL
     - Policy
     - normativa
     - Políticas
   * - STD
     - Standard
     - normativa
     - Estándares
   * - MOD
     - Module
     - arquitectura
     - Módulos del sistema
   * - RTM
     - Requirements Traceability Matrix
     - requisitos
     - Matrices de trazabilidad

----

6. Checklist de Validación
===========================

Al crear o renombrar un artefacto, verificar:

.. list-table::
   :widths: 10 90
   :header-rows: 0

   * - ☐
     - Prefijo correcto según tipo de artefacto
   * - ☐
     - Separadores correctos (guión bajo entre componentes)
   * - ☐
     - Capitalización correcta (prefijos MAYÚSCULAS)
   * - ☐
     - Nombre descriptivo en PascalCase
   * - ☐
     - Sin espacios en el nombre del archivo
   * - ☐
     - Extensión en minúsculas (.rst)
   * - ☐
     - Versionado semántico si aplica (templates)
   * - ☐
     - Números secuenciales con ceros a la izquierda (01, 02, no 1, 2)

----

7. Ejemplos Completos por Dominio
==================================

7.1 Dominio: requisitos/
-------------------------

.. code-block:: text

   requisitos/
   ├── vision/
   │   └── BReq_001_Objetivos_IACT.rst
   ├── reglas_negocio/
   │   ├── BR_001_Cliente_Debe_Autenticarse.rst
   │   └── BR_015_Restriccion_SoD.rst
   ├── casos_uso/
   │   ├── auth/
   │   │   ├── UC_AUTH_01_Iniciar_Sesion.rst
   │   │   └── UC_AUTH_02_Cerrar_Sesion.rst
   │   └── access/
   │       ├── UC_ACC_01_Asignar_Funciones.rst
   │       └── UC_ACC_05_Gestionar_SoD.rst
   ├── funcionales/
   │   ├── FR_AUTH_01_01_Validar_Credenciales.rst
   │   └── FR_ACC_01_06_Verificar_SoD.rst
   └── no_funcionales/
       └── NFR_SEC_001_Autenticacion_2FA.rst

7.2 Dominio: base_cognitiva/
-----------------------------

.. code-block:: text

   base_cognitiva/
   ├── _fundamentos_conceptuales/
   │   ├── FND_01_Concepto_Requisito.rst
   │   └── FND_03_Casos_de_Uso.rst
   ├── _ontologia_sbvr/
   │   ├── SBVR_01_Conceptos_Nucleares.rst
   │   └── SBVR_05_Vocabulario_Controlado.rst
   ├── _taxonomias_y_metamodelos/
   │   ├── taxonomias/
   │   │   ├── TXM_01_Taxonomia_Requisitos.rst
   │   │   └── TXM_02_Taxonomia_Artefactos.rst
   │   └── metamodelos/
   │       ├── MTM_01_Metamodelo_Requisitos.rst
   │       └── MTM_03_Metamodelo_RBAC.rst
   └── _metadata/
       ├── META_01_Identidad_Proyecto.rst
       └── META_05_Estructura_Documental.rst

7.3 Dominio: normativa/
------------------------

.. code-block:: text

   normativa/
   ├── templates/
   │   ├── TPL_UC_Casos_de_Uso_2_0_0.rst
   │   ├── TPL_BR_Business_Rules_1_0_0.rst
   │   └── TPL_INDEX_Indices_1_0_0.rst
   ├── restricciones/
   │   ├── CNST_001_Comunicaciones_Prohibidas.rst
   │   └── CNST_005_RBAC_Flat_NIST.rst
   ├── procedimientos/
   │   └── PROC_001_Derivacion_UC_a_FR.rst
   └── politicas/
       └── POL_001_Revision_Documentos.rst

----

8. Migración de Nomenclatura Antigua
====================================

8.1 Cambios v2.0 → v4.0
------------------------

.. list-table::
   :widths: 20 20 60
   :header-rows: 1

   * - Antigua (v2.0)
     - Nueva (v4.0)
     - Notas
   * - UC-010
     - UC_ACC_01
     - Cambio de guión a guión bajo, prefijo módulo
   * - UC-005
     - UC_USR_01 o UC_AUTH_XX
     - Depende del contexto (usuarios o auth)
   * - UC-043
     - UC_ACC_05
     - Reordenación por módulo
   * - UC_010 (sin guión)
     - UC_ACC_01
     - Unificación a formato v4.0

**Regla General:**
La nomenclatura v4.0.0 introduce:
1. Guión bajo (_) como separador único
2. Prefijo de módulo (MOD) entre UC y número
3. Numeración secuencial por módulo (no global)

----

9. Historial de Cambios
========================

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial con nomenclatura v4.0.0 completa

----

**Trazabilidad:** Este documento es la fuente de verdad para nomenclatura.
Consultar antes de crear nuevos artefactos.
