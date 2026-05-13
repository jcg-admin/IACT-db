
.. meta::
   :artefacto: META_05
   :tipo: Estructura
   :dominio: base_cognitiva
   :subdominio: _metadata
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-18
   :autor: PMO IACT
   :clasificacion: Interno

.. _meta_05_estructura_documental:

==========================================================
META_05 · Estructura Documental
==========================================================

.. contents:: Contenido
   :local:
   :depth: 2

------------------------------------------------------------
1. Propósito
------------------------------------------------------------

Este documento presenta el mapa completo de la estructura documental IACT,
proporcionando navegación rápida y visión global del sistema de 5 dominios,
21 subdominios y 6 subcarpetas organizativas.

------------------------------------------------------------
2. Resumen Ejecutivo
------------------------------------------------------------

.. list-table::
   :widths: 40 60
   :header-rows: 0
   :stub-columns: 1

   * - Dominios Primarios
     - 5
   * - Subdominios (nivel 2)
     - 21
   * - Subcarpetas Organizativas
     - 6
   * - Subdominios Congelados
     - 17
   * - Subdominios Descongelados
     - 4

------------------------------------------------------------
3. Mapa de Dominios
------------------------------------------------------------

3.1. Dominio: base_cognitiva/
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** Fundamentos conceptuales, metodologías y contexto del proyecto.

**Owner:** PMO

.. list-table::
   :widths: 30 15 55
   :header-rows: 1

   * - Subdominio
     - Estado
     - Contenido
   * - _metadata/
     - Congelado
     - Identidad, clasificación, fases SDLC, contexto IACT.
   * - glosario/
     - Congelado
     - Términos y definiciones del proyecto.
   * - fundamentos_conceptuales/
     - Congelado
     - Concepto de requisito, reglas de negocio, casos de uso, trazabilidad.
   * - ontologia_sbvr/
     - Congelado
     - Conceptos nucleares SBVR, tipos de regla, vocabulario controlado.
   * - taxonomias_y_metamodelos/
     - Descongelado
     - Taxonomías de requisitos y artefactos, metamodelos.
   * - metodologias_analiticas/
     - Congelado
     - Derivación BR a UC, derivación UC a FR.

**Prefijos:** META_, GLO_, FND_, SBVR_, TXM_, MTM_, METH_

3.2. Dominio: requisitos/
^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** Captura completa de requisitos del sistema.

**Owner:** Business Analyst Lead

.. list-table::
   :widths: 30 15 55
   :header-rows: 1

   * - Subdominio
     - Estado
     - Contenido
   * - vision/
     - Congelado
     - Visión del producto, objetivos de negocio.
   * - reglas_negocio/
     - Congelado
     - Reglas de negocio (BR_xxx).
   * - casos_uso/
     - Congelado
     - Casos de uso del sistema (UC_xxx).
   * - funcionales/
     - Congelado
     - Requisitos funcionales (FR_xxx).
   * - no_funcionales/
     - Congelado
     - Requisitos de calidad, rendimiento, seguridad (NFR_xxx).

**Prefijos:** VIS_, BR_, UC_, FR_, NFR_

3.3. Dominio: arquitectura_tecnica/
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** Decisiones técnicas, diseño e implementación.

**Owner:** Arquitecto de Software

.. list-table::
   :widths: 30 15 55
   :header-rows: 1

   * - Subdominio
     - Estado
     - Contenido
   * - arquitectura/
     - Descongelado
     - SAD, vistas arquitectónicas, decisiones (ADR_xxx).
   * - diseño_detallado/
     - Descongelado
     - Diseño de componentes, módulos, clases (DES_xxx).
   * - especificaciones/
     - Congelado
     - APIs, contratos, protocolos (SPEC_xxx).
   * - infraestructura/
     - Congelado
     - Configuración de ambientes, despliegue (INFRA_xxx).

**Prefijos:** SAD_, ADR_, DES_, SPEC_, INFRA_

**Subcarpetas en arquitectura/:**

- decisiones/ (ADR_xxx)
- vistas/ (VIEW_xxx)

**Subcarpetas en diseño_detallado/:**

- componentes/ (DES_COMP_xxx)
- integraciones/ (DES_INT_xxx)

3.4. Dominio: normativa/
^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** Estándares, restricciones y plantillas oficiales.

**Owner:** PMO / Arquitecto

.. list-table::
   :widths: 30 15 55
   :header-rows: 1

   * - Subdominio
     - Estado
     - Contenido
   * - estandares/
     - Descongelado
     - Estándares de código, documentación, naming.
   * - restricciones/
     - Congelado
     - Restricciones del modelo, antipatrones, RACI.

**Prefijos:** STD_, TPL_, RSTR_, RACI_

**Subcarpetas en estandares/:**

- codigo/ (STD_CODE_xxx)
- plantillas/ (TPL_xxx)

3.5. Dominio: trazabilidad/
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Propósito:** Matrices de trazabilidad y validación cruzada.

**Owner:** QA Lead / PMO

.. list-table::
   :widths: 30 15 55
   :header-rows: 1

   * - Subdominio
     - Estado
     - Contenido
   * - matrices/
     - Congelado
     - RTM master y matrices específicas.
   * - reportes/
     - Congelado
     - Reportes de cobertura, gaps, validación.
   * - validaciones/
     - Congelado
     - Scripts y resultados de validación automática.

**Prefijos:** RTM_, RPT_, VAL_

------------------------------------------------------------
4. Árbol Completo
------------------------------------------------------------

::

   documentacion/
   │
   ├── base_cognitiva/
   │   ├── index.rst
   │   ├── _metadata/
   │   │   ├── index.rst
   │   │   ├── META_01_Identidad_Proyecto.rst
   │   │   ├── META_02_Clasificacion_Documental.rst
   │   │   ├── META_03_Fases_SDLC.rst
   │   │   ├── META_04_Contexto_IACT.rst
   │   │   └── META_05_Estructura_Documental.rst
   │   ├── glosario/
   │   │   ├── index.rst
   │   │   └── IACT_Glossary_v1_0_0.rst
   │   ├── fundamentos_conceptuales/
   │   │   ├── index.rst
   │   │   ├── FND_01_Concepto_Requisito.rst
   │   │   ├── FND_02_Reglas_de_Negocio.rst
   │   │   ├── FND_03_Casos_de_Uso.rst
   │   │   └── FND_04_Trazabilidad.rst
   │   ├── ontologia_sbvr/
   │   │   ├── index.rst
   │   │   ├── SBVR_01_Conceptos_Nucleares.rst
   │   │   ├── SBVR_02_Tipos_Regla_Negocio.rst
   │   │   └── SBVR_03_Vocabulario_Controlado.rst
   │   ├── taxonomias_y_metamodelos/
   │   │   ├── index.rst
   │   │   ├── taxonomias/
   │   │   │   ├── TXM_01_Taxonomia_Requisitos.rst
   │   │   │   └── TXM_02_Taxonomia_Artefactos.rst
   │   │   └── metamodelos/
   │   │       ├── MTM_01_Metamodelo_Requisitos.rst
   │   │       └── MTM_02_Metamodelo_Trazabilidad.rst
   │   └── metodologias_analiticas/
   │       ├── index.rst
   │       ├── METH_01_Derivacion_BR_a_UC.rst
   │       └── METH_02_Derivacion_UC_a_FR.rst
   │
   ├── requisitos/
   │   ├── index.rst
   │   ├── vision/
   │   ├── reglas_negocio/
   │   ├── casos_uso/
   │   ├── funcionales/
   │   └── no_funcionales/
   │
   ├── arquitectura_tecnica/
   │   ├── index.rst
   │   ├── arquitectura/
   │   │   ├── index.rst
   │   │   ├── decisiones/
   │   │   └── vistas/
   │   ├── diseño_detallado/
   │   │   ├── index.rst
   │   │   ├── componentes/
   │   │   └── integraciones/
   │   ├── especificaciones/
   │   └── infraestructura/
   │
   ├── normativa/
   │   ├── index.rst
   │   ├── estandares/
   │   │   ├── index.rst
   │   │   ├── codigo/
   │   │   └── plantillas/
   │   └── restricciones/
   │
   └── trazabilidad/
       ├── index.rst
       ├── matrices/
       ├── reportes/
       └── validaciones/

------------------------------------------------------------
5. Subdominios Descongelados
------------------------------------------------------------

Los siguientes subdominios han sido descongelados y pueden contener
subcarpetas organizativas:

.. list-table::
   :widths: 30 20 50
   :header-rows: 1

   * - Subdominio
     - Fecha
     - Criterio de Descongelamiento
   * - taxonomias_y_metamodelos/
     - 2024-10-15
     - (c) Reglas incompatibles entre taxonomías y metamodelos.
   * - estandares/
     - 2024-09-01
     - (a) Volumen extremo, (d) Complejidad prevista.
   * - arquitectura/
     - 2024-09-15
     - (b) Múltiples owners, (c) Reglas incompatibles.
   * - diseño_detallado/
     - 2024-10-01
     - (c) Reglas incompatibles, (d) Complejidad prevista.

------------------------------------------------------------
6. Navegación Rápida por Rol
------------------------------------------------------------

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Rol
     - Rutas Principales
   * - PMO
     - base_cognitiva/_metadata/, trazabilidad/matrices/, normativa/restricciones/
   * - BA
     - requisitos/reglas_negocio/, requisitos/casos_uso/, requisitos/funcionales/
   * - Arquitecto
     - arquitectura_tecnica/arquitectura/, arquitectura_tecnica/diseño_detallado/
   * - Dev
     - requisitos/funcionales/, arquitectura_tecnica/diseño_detallado/, arquitectura_tecnica/especificaciones/
   * - QA
     - requisitos/casos_uso/, trazabilidad/matrices/, trazabilidad/reportes/

------------------------------------------------------------
7. Referencias
------------------------------------------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Documento
     - Referencia
   * - Contexto IACT
     - :doc:`META_04_Contexto_IACT`
   * - Definiciones Oficiales
     - :doc:`/normativa/restricciones/RESTRICCIONES_COMPLETAS`
   * - Árbol Completo con Justificaciones
     - ÁRBOL_COMPLETO_IACT_CON_JUSTIFICACIONES_v_2_0_0.md

------------------------------------------------------------
Historial de Cambios
------------------------------------------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-18
     - PMO IACT
     - Versión inicial aprobada

----

**Trazabilidad:** Complementa index.rst con explicaciones detalladas.
Mapa de referencia para navegación y auditoría estructural.