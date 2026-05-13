.. meta::
   :artefacto: NOM_001
   :tipo: Normativa
   :dominio: base_cognitiva
   :subdominio: _normativa
   :estado: Aprobado
   :version: 2.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-08
   :autor: Equipo IACT
   :clasificacion: Interno

.. _nom-001:

==============================================================================
NOM_001: Nomenclatura Estándar del Proyecto IACT v2.0.0
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
     - UC_ACC_001, TPL_BR_1_0_0
   * - **Guión medio (-)**
     - En nombres descriptivos (multi-palabra)
     - Business-Rules, Call-Center
   * - **NUNCA espacios**
     - N/A
     -  [ERROR] "UC ACC 001.rst"

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

2.4 Números Secuenciales y Versionado
--------------------------------------

.. important::

   **NUEVO en v2.0.0**
   
   **Regla de dígitos:**
   
   - **Artefactos con módulos (UC):** 2 dígitos (01, 02, ..., 99)
   - **Artefactos globales (BR, CNST, STD, etc.):** 3 dígitos (001, 002, ..., 999)
   
   **Versionado obligatorio:**
   
   - **TODOS los artefactos** deben incluir versionado semántico: ``_[MAJOR]_[MINOR]_[PATCH].rst``

**Ejemplos:**

.. code-block:: text

   # Artefactos con módulo (2 dígitos):
   UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
   UC_ACC_09_Auditar_Cambios_Acceso_4_0_0.rst
   
   # Artefactos globales (3 dígitos):
   BR_001_Cliente_Debe_Autenticarse_1_0_0.rst
   CNST_005_Seguridad_DRF_1_1_0.rst
   NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst
   STD_001_Suite_Calidad_Codigo_1_0_0.rst
   
   # FR especial (guión bajo + punto):
   FR_001.01_Validar_Username_1_0_0.rst

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
- 2_0_0 → Cambio de nomenclatura v1.0 → v2.0 (incompatible)

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
     - Cambio 2 dígitos → 3 dígitos
   * - MINOR
     - Nueva sección, campo, o funcionalidad
     - Agregar diagrama PlantUML
   * - PATCH
     - Corrección de errores, typos, formato
     - Corregir referencia CNST

----

4. Nomenclatura por Tipo de Artefacto
=====================================

4.1 Templates (TPL) - 17 Templates en v2.2.0
---------------------------------------------

**Formato:**
.. code-block:: text

   TPL_[TIPO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

**Componentes:**
- TPL = Prefijo de template
- [TIPO] = Prefijo del artefacto (BR, UC, FR) o nombre descriptivo (INDEX, GLOS)
- [Nombre_Descriptivo] = PascalCase, guiones medios si necesario
- [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Catálogo Completo de 17 TPL (v2.2.0):**

.. list-table::
   :widths: 5 15 50 10 20
   :header-rows: 1

   * - #
     - TIPO
     - Nombre de Archivo
     - Líneas
     - Categoría
   * - 1
     - BReq
     - TPL_BReq_Objetivos_Negocio_1_0_0.rst
     - 450
     - Requisitos
   * - 2
     - BR
     - TPL_BR_Business_Rules_1_0_0.rst
     - 580
     - Requisitos
   * - 3
     - UC
     - TPL_UC_Casos_de_Uso_2_0_0.rst
     - 620
     - Requisitos
   * - 4
     - FR
     - TPL_FR_Requisitos_Funcionales_1_0_0.rst
     - 533
     - Requisitos
   * - 5
     - NFR
     - TPL_NFR_No_Funcionales_1_0_0.rst
     - 520
     - Requisitos
   * - 6
     - CNST
     - TPL_CNST_Restricciones_1_0_0.rst
     - 440
     - Arquitectura
   * - 7
     - MOD
     - TPL_MOD_Modulos_1_0_0.rst
     - 480
     - Arquitectura
   * - 8
     - ADR
     - TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
     - 470
     - Arquitectura
   * - 9
     - FD
     - TPL_FD_Fichas_Dominio_1_0_0.rst
     - 520
     - Arquitectura
   * - 10
     - VIEW
     - TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst
     - 510
     - Arquitectura
   * - 11
     - API
     - TPL_API_Documentacion_API_1_1_0.rst
     - 650
     - Arquitectura
   * - 12
     - STD
     - TPL_STD_Estandares_1_0_0.rst
     - 617
     - Normativa
   * - 13
     - PROC
     - TPL_PROC_Procedimientos_1_0_0.rst
     - 578
     - Normativa
   * - 14
     - POL
     - TPL_POL_Politicas_1_0_0.rst
     - 490
     - Normativa
   * - 15
     - TST
     - TPL_TST_Pruebas_1_0_0.rst
     - 580
     - Evidencia
   * - 16
     - RTM
     - TPL_RTM_Trazabilidad_1_0_0.rst
     - 576
     - Evidencia
   * - 17
     - INDEX
     - TPL_INDEX_Indices_1_0_0.rst
     - 304
     - Utilitario

**Total:** 17 templates, ~8,918 líneas

**Regla especial para [TIPO]:**

- Si el artefacto tiene prefijo estándar → Usar el prefijo (BR, UC, FR, NFR, CNST, MOD, ADR, FD, VIEW, API, STD, PROC, POL, TST, RTM)
- Si es un template utilitario sin prefijo → Usar nombre descriptivo (INDEX, GLOS, METH, META)

4.2 Casos de Uso (UC)
---------------------

**Identificador:**
.. code-block:: text

   UC_[MOD]_[NN]
   
   Donde:
     UC    = Prefijo estándar
     [MOD] = Código módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
     [NN]  = Secuencial de 2 dígitos dentro del módulo (01, 02, 03, ...)

**Nombre de Archivo:**
.. code-block:: text

   UC_[MOD]_[NN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

**Ejemplos:**

.. code-block:: text

   UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
   UC_USR_01_Crear_Usuario_4_0_0.rst
   UC_ACC_01_Asignar_Funciones_4_0_0.rst
   UC_PIP_01_Supervisar_ETL_4_0_0.rst
   UC_RPT_06_Exportar_CSV_4_0_0.rst
   UC_ALR_01_Configurar_Alerta_4_0_0.rst
   UC_AUD_01_Consultar_Auditoria_4_0_0.rst
   UC_LOG_01_Consultar_Logs_4_0_0.rst

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

   BR_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     BR    = Prefijo Business Rule
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, PascalCase
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   BR_001_Cliente_Debe_Autenticarse_1_0_0.rst
   BR_007_Separacion_Funciones_1_0_0.rst
   BR_015_Restriccion_SoD_1_0_0.rst
   BR_020_Clasificacion_Datos_1_0_0.rst

4.4 Requisitos Funcionales (FR)
-------------------------------

**Formato:**
.. code-block:: text

   FR_[NNN].[NN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     FR    = Prefijo Functional Requirement
     [NNN] = Número del UC origen (001, 002, 060, ...)
     [NN]  = Secuencial de 2 dígitos dentro del UC (01, 02, 03, ...)
     [Nombre_Descriptivo] = Opcional, en español
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

.. important::

   **Separador especial:** FR usa **guión bajo + punto** (``_[NNN].[NN]_``)

**Ejemplos:**

.. code-block:: text

   FR_001.01_Validar_Credenciales_1_0_0.rst
   FR_010.06_Verificar_SoD_1_0_0.rst
   FR_060.03_Generar_CSV_1_0_0.rst

**Nota:** En v4.0 de UC también se acepta el formato expandido:

.. code-block:: text

   FR_UCAUTH_01.01_Validar_Username_1_0_0.rst
   FR_UCACC_05.02_Verificar_SoD_1_0_0.rst

4.5 Restricciones de Arquitectura (CNST)
----------------------------------------

**Formato:**
.. code-block:: text

   CNST_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     CNST  = Prefijo Constraint
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, PascalCase
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   CNST_001_Comunicaciones_Prohibidas_1_0_0.rst
   CNST_002_Sesion_Unica_Timeout_1_0_0.rst
   CNST_003_BD_Dual_Inmutable_1_0_0.rst
   CNST_005_RBAC_Flat_NIST_1_1_0.rst
   CNST_010_Clasificacion_Datos_1_0_0.rst

4.6 Objetivos de Negocio (BReq)
--------------------------------

**Formato:**
.. code-block:: text

   BReq_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     BReq  = Prefijo Business Requirement
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, PascalCase
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   BReq_001_Objetivos_IACT_1_0_0.rst
   BReq_002_Mejorar_Visibilidad_IVR_1_0_0.rst
   BReq_004_Cumplimiento_Seguridad_1_0_0.rst

**Nota:** En v2.2.0 también se usan códigos por módulo:

.. code-block:: text

   BReq_AUTH_Autenticacion_1_0_0.rst
   BReq_USR_Gestion_Usuarios_1_0_0.rst
   BReq_ACC_Control_Acceso_1_0_0.rst

4.7 Decisiones Arquitectónicas (ADR)
------------------------------------

**Formato:**
.. code-block:: text

   ADR_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     ADR   = Prefijo Architecture Decision Record
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En inglés, kebab-case
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   ADR_001_Database_PostgreSQL_1_0_0.rst
   ADR_003_RBAC_Flat_Model_1_0_0.rst
   ADR_007_No_External_Communications_1_0_0.rst

4.8 Fundamentos Conceptuales (FND)
-----------------------------------

**Formato:**
.. code-block:: text

   FND_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     FND   = Prefijo Foundation
     [NN]  = Secuencial de 2 dígitos (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   FND_01_Concepto_Requisito.rst
   FND_02_Reglas_de_Negocio.rst
   FND_03_Casos_de_Uso.rst
   FND_05_Jerarquia_4_Niveles.rst

**Nota:** FND mantiene 2 dígitos por ser privado y limitado a <10 documentos.

4.9 Ontología SBVR
------------------

**Formato:**
.. code-block:: text

   SBVR_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     SBVR  = Prefijo Semantics of Business Vocabulary
     [NN]  = Secuencial de 2 dígitos (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   SBVR_01_Conceptos_Nucleares.rst
   SBVR_02_Fact_Types.rst
   SBVR_03_Reglas_Estructurales.rst
   SBVR_05_Vocabulario_Controlado.rst

**Nota:** SBVR mantiene 2 dígitos por ser privado y limitado a <10 documentos.

4.10 Taxonomías (TXM)
----------------------

**Formato:**
.. code-block:: text

   TXM_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     TXM   = Prefijo Taxonomy
     [NN]  = Secuencial de 2 dígitos (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   TXM_01_Taxonomia_Requisitos.rst
   TXM_02_Taxonomia_Artefactos.rst
   TXM_03_Taxonomia_Reglas_Negocio.rst

**Nota:** TXM mantiene 2 dígitos por ser privado y limitado a <10 documentos.

4.11 Metamodelos (MTM)
-----------------------

**Formato:**
.. code-block:: text

   MTM_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     MTM   = Prefijo Metamodel
     [NN]  = Secuencial de 2 dígitos (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   MTM_01_Metamodelo_Requisitos.rst
   MTM_02_Metamodelo_Trazabilidad.rst
   MTM_03_Metamodelo_RBAC.rst

**Nota:** MTM mantiene 2 dígitos por ser privado y limitado a <10 documentos.

4.12 Metadata (META)
--------------------

**Formato:**
.. code-block:: text

   META_[NN]_[Nombre_Descriptivo].rst
   
   Donde:
     META  = Prefijo Metadata
     [NN]  = Secuencial de 2 dígitos (01, 02, 03, ...)
     [Nombre_Descriptivo] = En español, guiones bajos

**Ejemplos:**

.. code-block:: text

   META_01_Identidad_Proyecto.rst
   META_02_Clasificacion_Documental.rst
   META_04_Contexto_IACT.rst
   META_05_Estructura_Documental.rst

**Nota:** META mantiene 2 dígitos por ser privado y limitado a <10 documentos.

4.13 Procedimientos (PROC) - 38 Procedimientos en v2.2.0
---------------------------------------------------------

**NUEVO en v2.0.0**

**Formato:**
.. code-block:: text

   PROC_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

**Componentes:**
- PROC = Prefijo de procedimiento
- [Nombre_Descriptivo] = En español/inglés, guiones bajos entre palabras
- [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Catálogo Completo de 38 PROC (v2.2.0):**

**Categoría 1: Preparación y Apoyo (4 PROC)**

.. list-table::
   :widths: 50 40 10
   :header-rows: 1

   * - Archivo
     - Propósito
     - Líneas
   * - PROC_Revision_UC_Previo_Derivacion_1_0_0.rst
     - Revisar UC antes de derivar FR
     - 375
   * - PROC_Revision_TPL_Previo_Generacion_1_0_0.rst
     - Revisar TPL antes de generar
     - 355
   * - PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst
     - Crear carpetas en /tmp
     - 393
   * - PROC_Crear_Plan_Analisis_1_0_0.rst
     - Crear documentos de análisis
     - 150

**Categoría 2: Generación de Artefactos (16 PROC)**

.. list-table::
   :widths: 50 40 10
   :header-rows: 1

   * - Archivo
     - Propósito
     - Líneas
   * - PROC_Generacion_BReq_1_0_0.rst
     - Generar objetivos de negocio
     - 162
   * - PROC_Generacion_BR_1_0_0.rst
     - Generar reglas de negocio
     - 393
   * - PROC_Generacion_UC_1_0_0.rst
     - Generar casos de uso
     - 441
   * - PROC_Generacion_FR_1_0_0.rst
     - Generar requisitos funcionales
     - 459
   * - PROC_Generacion_NFR_1_0_0.rst
     - Generar requisitos no funcionales
     - 402
   * - PROC_Generacion_TST_1_0_0.rst
     - Generar casos de prueba
     - 509
   * - PROC_Generacion_CNST_1_0_0.rst
     - Generar restricciones
     - 175
   * - PROC_Generacion_MOD_1_0_0.rst
     - Generar especificaciones de módulo
     - 190
   * - PROC_Generacion_ADR_1_0_0.rst
     - Generar decisiones arquitectónicas
     - 180
   * - PROC_Generacion_STD_1_0_0.rst
     - Generar estándares
     - 411
   * - PROC_Generacion_POL_1_0_0.rst
     - Generar políticas
     - 165
   * - PROC_Generacion_FD_1_0_0.rst
     - Generar fichas de dominio
     - 164
   * - PROC_Generacion_VIEW_1_0_0.rst
     - Generar vistas arquitectónicas
     - 178
   * - PROC_Generacion_API_1_0_0.rst
     - Generar documentación de API
     - 463
   * - PROC_Generacion_RTM_1_0_0.rst
     - Generar matrices de trazabilidad
     - 446
   * - PROC_Generacion_Index_1_0_0.rst
     - Generar archivos index
     - 398

**Categoría 3: Derivación (5 PROC)**

.. list-table::
   :widths: 50 40 10
   :header-rows: 1

   * - Archivo
     - Propósito
     - Líneas
   * - PROC_Derivacion_BReq_BR_1_0_0.rst
     - Derivar BReq → BR
     - 177
   * - PROC_Derivacion_BR_UC_1_0_0.rst
     - Derivar BR → UC
     - 187
   * - PROC_Derivacion_UC_FR_1_0_0.rst
     - Derivar UC → FR
     - 485
   * - PROC_Derivacion_FR_TST_1_1_0.rst
     - Derivar FR → TST
     - 440
   * - PROC_Derivacion_FR_CODE_1_0_0.rst
     - Derivar FR → CODE
     - 184

**Categoría 4: Gobernanza Documental (7 PROC)**

.. list-table::
   :widths: 50 40 10
   :header-rows: 1

   * - Archivo
     - Propósito
     - Líneas
   * - PROC_Versionado_Semantico_1_0_0.rst
     - Aplicar versionado semántico
     - 372
   * - PROC_Congelamiento_Subdominio_1_0_0.rst
     - Congelar subdominios
     - 388
   * - PROC_Descongelamiento_Subdominio_1_0_0.rst
     - Descongelar subdominios
     - 386
   * - PROC_Actualizacion_Modelo_Documental_1_0_0.rst
     - Actualizar modelo documental
     - 389
   * - PROC_Cambio_Requisitos_1_0_0.rst
     - Gestionar cambios en requisitos
     - 351
   * - PROC_Revision_Artefactos_1_0_0.rst
     - Revisar artefactos
     - 403
   * - PROC_Aprobacion_Documentos_1_0_0.rst
     - Aprobar documentos
     - 402

**Categoría 5: Transferencia y Publicación (3 PROC)**

.. list-table::
   :widths: 50 40 10
   :header-rows: 1

   * - Archivo
     - Propósito
     - Líneas
   * - PROC_Copiar_Tmp_Outputs_1_0_0.rst
     - Copiar de /tmp a /outputs
     - 389
   * - PROC_Validacion_Sphinx_1_0_0.rst
     - Validar con Sphinx
     - 175
   * - PROC_Publicacion_Documentacion_1_0_0.rst
     - Publicar documentación
     - 179

**Categoría 6: Trazabilidad y Verificación (3 PROC)**

.. list-table::
   :widths: 50 40 10
   :header-rows: 1

   * - Archivo
     - Propósito
     - Líneas
   * - PROC_Verificacion_Cobertura_1_0_0.rst
     - Verificar cobertura de requisitos
     - 190
   * - PROC_Auditoria_Documental_1_0_0.rst
     - Auditar modelo documental
     - 183
   * - PROC_Identificar_Gaps_Huerfanos_1_0_0.rst
     - Identificar gaps y huérfanos
     - 184

**Total:** 38 procedimientos, ~11,873 líneas

4.14 Estándares (STD)
---------------------

**Formato:**
.. code-block:: text

   STD_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     STD   = Prefijo Standard
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español/inglés, guiones bajos
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   STD_001_Suite_Calidad_Codigo_1_0_0.rst
   STD_002_Metodologia_SBVR_UML_Larman_1_0_0.rst
   STD_003_Clean_Code_Naming_1_0_0.rst
   STD_004_Nomenclatura_Proyecto_1_0_0.rst
   STD_005_Estilo_Documentacion_Sphinx_1_0_0.rst
   STD_006_Versionado_Semantico_1_0_0.rst

4.15 Políticas (POL)
--------------------

**Formato:**
.. code-block:: text

   POL_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     POL   = Prefijo Policy
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, guiones bajos
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   POL_001_Seguridad_Informacion_1_0_0.rst
   POL_002_Control_Acceso_1_0_0.rst

4.16 Normativas (NOM)
---------------------

**NUEVO en v2.0.0**

**Formato:**
.. code-block:: text

   NOM_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
   
   Donde:
     NOM   = Prefijo Normativa
     [NNN] = Secuencial global de 3 dígitos (001, 002, 003, ...)
     [Nombre_Descriptivo] = En español, guiones bajos
     [MAJOR]_[MINOR]_[PATCH] = Versionado semántico

**Ejemplos:**

.. code-block:: text

   NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst
   NOM_002_Gobernanza_Documental_1_0_0.rst

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
   * - MOD
     - Module
     - arquitectura
     - Módulos del sistema
   * - VIEW
     - View
     - arquitectura
     - Vistas arquitectónicas
   * - FD
     - Ficha de Dominio
     - arquitectura
     - Fichas de dominio
   * - API
     - Application Programming Interface
     - arquitectura
     - Documentación de APIs
   * - MDL
     - Model
     - arquitectura
     - Modelos de datos
   * - TPL
     - Template
     - normativa
     - Plantillas de documentos
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
   * - NOM
     - Normativa
     - normativa
     - Documentos normativos
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
   * - GLOS
     - Glossary
     - base_cognitiva
     - Glosario
   * - METH
     - Methodology
     - base_cognitiva
     - Metodologías analíticas
   * - TST
     - Test
     - evidencia
     - Casos de prueba
   * - RTM
     - Requirements Traceability Matrix
     - evidencia
     - Matrices de trazabilidad
   * - COV
     - Coverage
     - evidencia
     - Reportes de cobertura

**Total:** 27 prefijos en v2.0.0 (antes 17 en v1.0.0)

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
     - Versionado semántico si aplica (templates, procedimientos, normativas)
   * - ☐
     - Números secuenciales con 3 dígitos para artefactos públicos (001, 002)
   * - ☐
     - Números secuenciales con 2 dígitos para artefactos privados (01, 02)

----

7. Ejemplos Completos por Dominio
==================================

7.1 Dominio: requisitos/
-------------------------

.. code-block:: text

   requisitos/
   ├── vision/
   │   └── BReq_001_Objetivos_IACT_1_0_0.rst
   ├── reglas_negocio/
   │   ├── BR_001_Cliente_Debe_Autenticarse_1_0_0.rst
   │   └── BR_015_Restriccion_SoD_1_0_0.rst
   ├── casos_uso/
   │   ├── auth/
   │   │   ├── UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
   │   │   └── UC_AUTH_02_Cerrar_Sesion_4_0_0.rst
   │   └── access/
   │       ├── UC_ACC_01_Asignar_Funciones_4_0_0.rst
   │       └── UC_ACC_05_Gestionar_SoD_4_0_0.rst
   ├── funcionales/
   │   ├── FR_001.01_Validar_Credenciales_1_0_0.rst
   │   └── FR_010.06_Verificar_SoD_1_0_0.rst
   └── no_funcionales/
       └── NFR_SEC_001_Autenticacion_2FA_1_0_0.rst

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
   ├── estandares/
   │   ├── STD_001_Suite_Calidad_Codigo_1_0_0.rst
   │   ├── STD_002_Metodologia_SBVR_UML_Larman_1_0_0.rst
   │   └── plantillas/
   │       ├── TPL_BReq_Objetivos_Negocio_1_0_0.rst
   │       ├── TPL_BR_Business_Rules_1_0_0.rst
   │       ├── TPL_UC_Casos_de_Uso_2_0_0.rst
   │       ├── TPL_FR_Requisitos_Funcionales_1_0_0.rst
   │       ├── TPL_NFR_No_Funcionales_1_0_0.rst
   │       ├── TPL_CNST_Restricciones_1_0_0.rst
   │       ├── TPL_MOD_Modulos_1_0_0.rst
   │       ├── TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
   │       ├── TPL_FD_Fichas_Dominio_1_0_0.rst
   │       ├── TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst
   │       ├── TPL_API_Documentacion_API_1_1_0.rst
   │       ├── TPL_STD_Estandares_1_0_0.rst
   │       ├── TPL_PROC_Procedimientos_1_0_0.rst
   │       ├── TPL_POL_Politicas_1_0_0.rst
   │       ├── TPL_TST_Pruebas_1_0_0.rst
   │       ├── TPL_RTM_Trazabilidad_1_0_0.rst
   │       └── TPL_INDEX_Indices_1_0_0.rst
   ├── procedimientos/
   │   ├── PROC_Revision_UC_Previo_Derivacion_1_0_0.rst
   │   ├── PROC_Revision_TPL_Previo_Generacion_1_0_0.rst
   │   ├── PROC_Generacion_BReq_1_0_0.rst
   │   ├── PROC_Generacion_BR_1_0_0.rst
   │   ├── PROC_Generacion_UC_1_0_0.rst
   │   ├── PROC_Generacion_FR_1_0_0.rst
   │   ├── PROC_Derivacion_BReq_BR_1_0_0.rst
   │   ├── PROC_Derivacion_BR_UC_1_0_0.rst
   │   ├── PROC_Derivacion_UC_FR_1_0_0.rst
   │   ├── PROC_Versionado_Semantico_1_0_0.rst
   │   └── PROC_Copiar_Tmp_Outputs_1_0_0.rst
   ├── restricciones/
   │   ├── CNST_001_Comunicaciones_Prohibidas_1_0_0.rst
   │   └── CNST_005_RBAC_Flat_NIST_1_1_0.rst
   └── politicas/
       └── POL_001_Revision_Documentos_1_0_0.rst

----

8. Migración de Nomenclatura v1.0 → v2.0
========================================

8.1 Cambios Principales
------------------------

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - Aspecto
     - v1.0.0
     - v2.0.0
   * - Dígitos secuenciales
     - 2 dígitos (01, 02)
     - **3 dígitos (001, 002)**
   * - Templates
     - 6 ejemplos
     - **17 TPL completos**
   * - Procedimientos
     - No versionados
     - **38 PROC versionados**
   * - Prefijos totales
     - 17
     - **27 prefijos**
   * - Normativas
     - No existía NOM
     - **NOM con versionado**

8.2 Tabla de Migración
-----------------------

.. list-table::
   :widths: 40 40 20
   :header-rows: 1

   * - Antigua (v1.0)
     - Nueva (v2.0)
     - Tipo Cambio
   * - NOM_01_...
     - NOM_001_..._2_0_0.rst
     - Dígitos + versión
   * - STD_01_...
     - STD_001_..._1_0_0.rst
     - Dígitos + versión
   * - BR_001_...
     - BR_001_..._1_0_0.rst
     - + versión
   * - CNST_001_...
     - CNST_001_..._1_0_0.rst
     - + versión
   * - UC_ACC_01
     - UC_ACC_01_..._4_0_0.rst
     - + versión
   * - FR (sin formato)
     - FR_001.01_..._1_0_0.rst
     - Nuevo formato
   * - TPL_BR_1_0_0
     - TPL_BR_Business_Rules_1_0_0.rst
     - Nombre descriptivo
   * - PROC_Generacion_FR
     - PROC_Generacion_FR_1_0_0.rst
     - + versionado

8.3 Reglas de Migración
------------------------

1. **Casos de Uso (UC):**
   - Mantienen 2 dígitos (01, 02, ..., 99)
   - Añadir versionado semántico
   - Ejemplo: UC_ACC_01 → UC_ACC_01_Asignar_Funciones_4_0_0.rst

2. **Artefactos globales (BR, CNST, STD, ADR, POL, NOM):**
   - Mantienen 3 dígitos (001, 002, ..., 999)
   - Añadir versionado semántico si no lo tienen
   - Ejemplo: BR_001_Fuente_Inmutable → BR_001_Fuente_Inmutable_1_0_0.rst

3. **Requisitos Funcionales (FR):**
   - Nuevo formato: FR_[NNN].[NN]_[Nombre]_X_Y_Z.rst
   - Usar guión bajo + punto (no guión medio)
   - Ejemplo: FR-001.01 → FR_001.01_Validar_Username_1_0_0.rst

4. **Templates (TPL):**
   - Añadir nombre descriptivo si falta
   - Versionado ya obligatorio
   - Ejemplo: TPL_BR_1_0_0 → TPL_BR_Business_Rules_1_0_0.rst

5. **Procedimientos (PROC):**
   - Añadir versionado semántico si no lo tienen
   - Ejemplo: PROC_Generacion_FR → PROC_Generacion_FR_1_0_0.rst

6. **Artefactos privados (FND, SBVR, TXM, MTM, META):**
   - Mantener 2 dígitos (01, 02, ...)
   - Sin versionado (documentos internos)
   - Ejemplo: FND_05 (sin cambios)

----

9. Historial de Cambios
========================

.. list-table::
   :widths: 10 15 20 55
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial con nomenclatura v4.0.0 completa
   * - 2.0.0
     - 2026-01-08
     - Equipo IACT
     - Migración 2→3 dígitos. 17 TPL + 38 PROC documentados. 10 nuevos prefijos (NOM, PROC, VIEW, FD, API, MDL, GLOS, METH, COV). Basado en MODELO_DOCUMENTAL_IACT_v2.2.0

----

**Trazabilidad:** Este documento es la fuente de verdad para nomenclatura.
Consultar antes de crear nuevos artefactos.

**Base:** MODELO_DOCUMENTAL_IACT_v2.2.0 y ANEXO_A_ARBOL_COMPLETO_v2.2.0
