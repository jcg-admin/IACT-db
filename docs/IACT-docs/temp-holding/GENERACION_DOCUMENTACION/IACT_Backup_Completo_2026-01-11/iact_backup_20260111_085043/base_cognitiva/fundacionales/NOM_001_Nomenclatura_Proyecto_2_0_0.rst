.. meta::
   :Proyecto: IACT
   :Codigo: NOM-001
   :Titulo: Nomenclatura del Proyecto
   :Version: 2.0.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE
   :Clasificacion: C2 - INTERNAL

=============================================
NOM-001: Nomenclatura del Proyecto IACT
=============================================

:ID: NOM-001
:Versión: 2.0.0
:Fecha: 2026-01-08
:Estado: VIGENTE
:Autores: Equipo IACT
:Aprobado por: CTO

.. contents:: Tabla de Contenido
   :depth: 3
   :local:

Introducción
============

Este documento define la nomenclatura estándar obligatoria para todos los archivos del proyecto IACT (IVR Analytics & Customer Tracking).

Alcance
-------

Aplica a:

- Material pedagógico (PARTES 0-6)
- Templates (TPL_*)
- Reglas de negocio (BR_IACT_*)
- Casos de uso (UC_IACT_*)
- Requisitos funcionales (FR_*)
- Constraints (CNST_*)
- Análisis y planes
- Índices maestros

Prerequisito
------------

Leer: STD_001_Estandares_Documentacion_1_1_0.rst

Formato General
===============

Estructura
----------

Todos los archivos deben seguir este formato::

   [PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].ext

Componentes
-----------

PREFIJO
^^^^^^^

Identificador del tipo de documento (ver tabla de prefijos).

**Reglas:**

- Solo letras MAYÚSCULAS
- Sin espacios
- Máximo 10 caracteres

**Ejemplos:** PARTE, TPL, BR, UC, FR, CNST

Nombre_Descriptivo
^^^^^^^^^^^^^^^^^^

Descripción en CamelCase con guiones bajos.

**Reglas:**

- Cada palabra comienza con MAYÚSCULA
- Separadas por guiones bajos (_)
- Sin espacios
- Sin guiones (-)
- Sin caracteres especiales

**Ejemplos:**

- Identificar_Reglas_Negocio_IACT
- Construccion_7_Pasos
- Consultar_Reporte

MAJOR_MINOR_PATCH
^^^^^^^^^^^^^^^^^

Versionado semántico **OBLIGATORIO**.

**Formato:** X_Y_Z donde X, Y, Z son dígitos

**Reglas:**

- Separados por guiones bajos (_)
- MAJOR: Cambios incompatibles
- MINOR: Nueva funcionalidad compatible
- PATCH: Correcciones y mejoras

**Ejemplos:** 1_0_0, 2_1_0, 4_0_0

ext
^^^

Extensión del archivo.

**Valores permitidos:**

- .md - Material pedagógico (Markdown)
- .rst - Documentación técnica (reStructuredText)

Tabla de Prefijos
=================

Completa
--------

.. list-table::
   :header-rows: 1
   :widths: 12 23 40 25

   * - Prefijo
     - Descripción
     - Aplica a
     - Extensión
   * - PARTE
     - Material pedagógico
     - PARTES 0-6
     - .md
   * - TPL
     - Templates
     - Plantillas de documentación
     - .rst
   * - BR
     - Business Rules
     - Reglas de negocio
     - .rst
   * - UC
     - Use Cases
     - Casos de uso
     - .rst
   * - FR
     - Functional Requirements
     - Requisitos funcionales
     - .rst
   * - CNST
     - Constraints
     - Restricciones del sistema
     - .rst
   * - BRQ
     - Business Requirements
     - Objetivos de negocio
     - .rst
   * - AGR
     - Agrupadores RBAC
     - Agrupadores de funciones
     - .rst
   * - STD
     - Estándares
     - Estándares de proyecto
     - .rst
   * - NOM
     - Nomenclaturas
     - Nomenclaturas
     - .rst
   * - ANLSS
     - Análisis
     - Documentos de análisis
     - .md
   * - PLN
     - Planes
     - Planes de trabajo
     - .md
   * - INDICE
     - Índices
     - Índices maestros
     - .md
   * - MAPA
     - Mapas
     - Mapas de referencias
     - .md
   * - PROC
     - Procedimientos
     - Procedimientos técnicos
     - .rst
   * - CNFG
     - Configuración
     - Archivos de config
     - .rst

Ejemplos por Tipo
-----------------

Material Pedagógico (PARTE)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
   PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
   PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
   PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
   PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
   PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
   PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
   PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
   PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
   PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
   PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md
   PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md

Templates (TPL)
^^^^^^^^^^^^^^^

.. code-block:: text

   TPL_BR_Decision_Tipo_1_0_0.rst
   TPL_UC_Construccion_7_Pasos_1_0_0.rst
   TPL_UC_Identificacion_Actor_1_0_0.rst
   TPL_FR_Documentacion_10_Componentes_1_0_0.rst
   TPL_UC_Flujos_Alternos_1_0_0.rst
   TPL_UC_Integracion_BR_1_0_0.rst
   TPL_UC_Derivacion_FR_1_0_0.rst
   TPL_FR_Casos_Prueba_1_0_0.rst
   TPL_UC_Checklist_Calidad_26_Puntos_1_0_0.rst
   TPL_UC_Peer_Review_1_0_0.rst
   TPL_UC_Walkthrough_Stakeholder_1_0_0.rst
   TPL_TRZ_Matriz_RTM_1_0_0.rst

Business Rules (BR)
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
   BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst
   BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst
   BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst
   BR_IACT_053_Calculo_Promedio_Duracion_1_0_0.rst

Use Cases (UC)
^^^^^^^^^^^^^^

.. code-block:: text

   UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   UC_IACT_RPT_09_Aprobar_Rechazar_Consulta_4_0_0.rst
   UC_IACT_AUTH_01_Iniciar_Sesion_4_0_0.rst
   UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
   UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
   UC_IACT_ACC_01_Asignar_Funciones_4_0_0.rst

Functional Requirements (FR)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR_RPT_01_07_Calcular_Count_1_0_0.rst
   FR_AUTH_07_02_Query_Sesiones_Expirar_1_0_0.rst
   FR_ACC_01_04_Validar_Nivel_Seguridad_1_0_0.rst

Constraints (CNST)
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CNST_001_No_Emails_Externos_1_0_0.rst
   CNST_003_BD_IVR_Solo_Lectura_1_0_0.rst
   CNST_005_RBAC_Flat_SoD_1_0_0.rst
   CNST_006_Rango_Maximo_2_Anios_1_0_0.rst
   CNST_007_Limites_Exportacion_1_0_0.rst
   CNST_009_Auditoria_Obligatoria_1_0_0.rst

Fundacionales (STD, NOM)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   STD_001_Estandares_Documentacion_1_1_0.rst
   NOM_001_Nomenclatura_Proyecto_2_0_0.rst

Análisis (ANLSS)
^^^^^^^^^^^^^^^^

.. code-block:: text

   ANLSS_Consolidado_Completo_IACT_2_0_0.md
   ANLSS_Parte_0_Completo_1_0_0.md

Índices (INDICE, MAPA)
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md
   MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md

Catálogo Completo de Documentos
================================

Este catálogo lista TODOS los documentos planificados del proyecto IACT con nomenclatura correcta.

Material Pedagógico (12 archivos)
----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 60 15 15

   * - #
     - Nombre Archivo
     - Líneas
     - Estado
   * - 1
     - PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
     - 2,780
     - GENERADO
   * - 2
     - PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
     - ~2,500
     - PENDIENTE
   * - 3
     - PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
     - 3,735
     - EXISTE
   * - 4
     - PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
     - 4,359
     - EXISTE
   * - 5
     - PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
     - 3,332
     - EXISTE
   * - 6
     - PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
     - 936
     - EXISTE
   * - 7
     - PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
     - 3,277
     - EXISTE
   * - 8
     - PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
     - 1,801
     - EXISTE
   * - 9
     - PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
     - 1,280
     - EXISTE
   * - 10
     - PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
     - ~2,000
     - PENDIENTE
   * - 11
     - PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md
     - ~1,500
     - PENDIENTE
   * - 12
     - PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md
     - ~2,500
     - PENDIENTE

**Total:** 12 archivos, ~27,000 líneas

Templates (12 archivos)
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 10 60 15 15

   * - #
     - Nombre Archivo
     - Tipo
     - Estado
   * - 1
     - TPL_BR_Decision_Tipo_1_0_0.rst
     - BR
     - PENDIENTE
   * - 2
     - TPL_UC_Construccion_7_Pasos_1_0_0.rst
     - UC
     - PENDIENTE
   * - 3
     - TPL_UC_Identificacion_Actor_1_0_0.rst
     - UC
     - PENDIENTE
   * - 4
     - TPL_FR_Documentacion_10_Componentes_1_0_0.rst
     - FR
     - PENDIENTE
   * - 5
     - TPL_UC_Flujos_Alternos_1_0_0.rst
     - UC
     - PENDIENTE
   * - 6
     - TPL_UC_Integracion_BR_1_0_0.rst
     - UC
     - PENDIENTE
   * - 7
     - TPL_UC_Derivacion_FR_1_0_0.rst
     - UC/FR
     - PENDIENTE
   * - 8
     - TPL_FR_Casos_Prueba_1_0_0.rst
     - FR
     - PENDIENTE
   * - 9
     - TPL_UC_Checklist_Calidad_26_Puntos_1_0_0.rst
     - UC
     - PENDIENTE
   * - 10
     - TPL_UC_Peer_Review_1_0_0.rst
     - UC
     - PENDIENTE
   * - 11
     - TPL_UC_Walkthrough_Stakeholder_1_0_0.rst
     - UC
     - PENDIENTE
   * - 12
     - TPL_TRZ_Matriz_RTM_1_0_0.rst
     - Trazabilidad
     - PENDIENTE

**Total:** 12 templates

Fundacionales (2 archivos)
---------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 60 15 15

   * - #
     - Nombre Archivo
     - Líneas
     - Estado
   * - 1
     - STD_001_Estandares_Documentacion_1_1_0.rst
     - 473
     - GENERADO
   * - 2
     - NOM_001_Nomenclatura_Proyecto_2_0_0.rst
     - ~600
     - GENERADO

Ejemplos BR (7 archivos)
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 70 20

   * - #
     - Nombre Archivo
     - Estado
   * - 1
     - BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
     - PENDIENTE
   * - 2
     - BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst
     - PENDIENTE
   * - 3
     - BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst
     - PENDIENTE
   * - 4
     - BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst
     - PENDIENTE
   * - 5
     - BR_IACT_053_Calculo_Promedio_Duracion_1_0_0.rst
     - PENDIENTE
   * - 6
     - BR_IACT_001_Definicion_Cliente_Activo_1_0_0.rst
     - PENDIENTE
   * - 7
     - BR_IACT_104_Alerta_Abandonadas_1_0_0.rst
     - PENDIENTE

Ejemplos UC (6 archivos)
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 70 20

   * - #
     - Nombre Archivo
     - Estado
   * - 1
     - UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
     - PENDIENTE
   * - 2
     - UC_IACT_RPT_09_Aprobar_Rechazar_Consulta_4_0_0.rst
     - PENDIENTE
   * - 3
     - UC_IACT_AUTH_01_Iniciar_Sesion_4_0_0.rst
     - PENDIENTE
   * - 4
     - UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
     - PENDIENTE
   * - 5
     - UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
     - PENDIENTE
   * - 6
     - UC_IACT_ACC_01_Asignar_Funciones_4_0_0.rst
     - PENDIENTE

Índices (2 archivos)
--------------------

.. list-table::
   :header-rows: 1
   :widths: 10 70 20

   * - #
     - Nombre Archivo
     - Estado
   * - 1
     - INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md
     - PENDIENTE
   * - 2
     - MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md
     - PENDIENTE

**Total General:** ~40 archivos planificados

Reglas de Versionado
=====================

Versionado Semántico
--------------------

Formato: MAJOR.MINOR.PATCH (separado por puntos en la versión, por guiones bajos en el nombre de archivo)

MAJOR
^^^^^

Incrementar cuando:

- Cambio incompatible de estructura
- Eliminación de secciones principales
- Cambio de formato (MD a RST o viceversa)
- Reestructuración completa

**Ejemplo:**

.. code-block:: text

   PARTE_1_Identificar_Reglas_Negocio_IACT_1_5_3.md
     ↓ Reestructuración completa
   PARTE_1_Identificar_Reglas_Negocio_IACT_2_0_0.md

MINOR
^^^^^

Incrementar cuando:

- Agregar nueva sección
- Agregar nuevos ejemplos
- Agregar nuevo contenido compatible
- Expandir documentación existente

**Ejemplo:**

.. code-block:: text

   PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
     ↓ Agregar sección "Técnicas Avanzadas"
   PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_0.md

PATCH
^^^^^

Incrementar cuando:

- Corrección de typos
- Mejora de redacción
- Corrección de referencias rotas
- Actualización de ejemplos menores
- Cambios de formato menor

**Ejemplo:**

.. code-block:: text

   PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_0.md
     ↓ Corregir 5 typos
   PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_1.md

Versionado de UC
----------------

Los Use Cases usan versión 4.0.0 para indicar que siguen el estándar UC v4.0:

.. code-block:: text

   UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst

Si el UC se modifica:

.. code-block:: text

   UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst  # Original
     ↓ Agregar flujo alterno
   UC_IACT_RPT_01_Consultar_Reporte_4_1_0.rst
     ↓ Corregir paso 7
   UC_IACT_RPT_01_Consultar_Reporte_4_1_1.rst

Casos Especiales
================

Archivos con Subfijos
----------------------

Algunos archivos tienen subfijos adicionales:

.. code-block:: text

   PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
   PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
   PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
   
   # A, B, C indican sub-partes de PARTE 2

   PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
   PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
   PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
   PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
   
   # A, B, C, D indican sub-partes de PARTE 3

Archivos Consolidados
----------------------

.. code-block:: text

   ANLSS_Consolidado_Completo_IACT_2_0_0.md
   
   # "Consolidado" indica que unifica varios análisis

Cambios v1.0 → v2.0
====================

Resumen de Cambios
------------------

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Aspecto
     - v1.0
     - v2.0
   * - Dígitos secuenciales
     - 2 (01-99)
     - 3 (001-999)
   * - Versionado
     - Opcional
     - **OBLIGATORIO**
   * - Formato versión
     - No especificado
     - _MAJOR_MINOR_PATCH
   * - Separador versión
     - Puntos o guiones
     - Solo guiones bajos
   * - Prefijos
     - 17 tipos
     - 27 tipos
   * - Separadores nombre
     - Guiones (-) permitidos
     - Solo guiones bajos (_)

Ejemplos Comparativos
---------------------

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - v1.0 (Antiguo)
     - v2.0 (Nuevo)
   * - PARTE_1.md
     - PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
   * - PARTE-2A-FUNDAMENTOS.md
     - PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
   * - T01_Decision_Tipo_BR.md
     - TPL_BR_Decision_Tipo_1_0_0.rst
   * - UC-IACT-RPT-01.rst
     - UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   * - BR-028.rst
     - BR_IACT_028_Aprobacion_Consultas_1_0_0.rst

Migración
---------

Archivos con nomenclatura v1.0 deben ser regenerados con v2.0.

No es suficiente renombrar - deben actualizarse todas las referencias internas.

Ver: PLAN_REGENERACION_COMPLETA_DESDE_CERO_1_0_0.md

Validación
==========

Script de Validación
--------------------

Usar script de validación:

.. code-block:: bash

   # Validar nomenclatura de un archivo
   ./validar_nomenclatura.sh PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

   # Validar referencias en un archivo
   ./validar_referencias.sh PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

Criterios de Validación
------------------------

Un archivo pasa validación si:

- Tiene formato [PREFIJO]_[Nombre]_[X]_[Y]_[Z].{md|rst}
- Usa guiones bajos, NO guiones
- Prefijo está en lista de prefijos válidos
- Extensión es .md o .rst
- No contiene emojis (excepto en bloques de código de ejemplo)
- Referencias a otros documentos usan nomenclatura v2.0

Historial de Cambios
=====================

Versión 2.0.0 (2026-01-08)
--------------------------

**Cambios Incompatibles:**

- Versionado ahora OBLIGATORIO (antes opcional)
- Solo guiones bajos _ (antes guiones - permitidos)
- 3 dígitos secuenciales (antes 2)

**Nuevos Prefijos:**

- MAPA (mapas de referencias)
- CNFG (configuración)
- PROC (procedimientos)

**Nuevos Ejemplos:**

- Catálogo completo de 40 documentos
- Tabla de prefijos expandida
- Ejemplos de versionado

**Autor:** Equipo IACT

Versión 1.0.0 (2025-12-01)
--------------------------

**Contenido Inicial:**

- Formato general definido
- 17 prefijos básicos
- Versionado opcional
- Ejemplos básicos

**Autor:** Equipo IACT

Referencias
===========

- STD_001_Estandares_Documentacion_1_1_0.rst
- PLAN_REGENERACION_COMPLETA_DESDE_CERO_1_0_0.md
- validar_nomenclatura.sh
- validar_referencias.sh
- referencias_maestro.txt

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

