.. meta::
   :artefacto: TPL_BReq
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-breq:

=================================================
TPL_BReq: Plantilla de Objetivo de Negocio v1.0.0
=================================================


Propósito
---------

Esta plantilla define la estructura estándar para documentar **Business Requirements (BReq)**
en el proyecto IACT. Los BReq representan los objetivos de negocio de alto nivel que
el sistema debe satisfacer, constituyendo el nivel más alto de la jerarquía de requisitos.

**Características:**

- Nivel más alto de abstracción (Nivel 1 de 5)
- Derivan en Business Rules (BR) y Casos de Uso (UC)
- Alineados con módulos funcionales del sistema
- Orientados a valor de negocio, no a implementación técnica

**Jerarquía:**

::

   BReq (Nivel 1) → BR (Nivel 2) → UC (Nivel 3) → FR (Nivel 4) → CODE/TST (Nivel 5)

----

Requisitos Técnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicación:**

::

   requisitos/objetivos_negocio/BReq_[MOD]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de sección "Plantilla" a nuevo archivo
2. Nombrar archivo según nomenclatura: ``BReq_[MOD]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Definir objetivos medibles y verificables
5. Identificar BR y UC que derivarán de este BReq
6. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   BReq_[MOD]

   Donde:
   - BReq: Prefijo fijo (Business Requirement)
   - [MOD]: Código del módulo (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)

**Ejemplos:**

::

   BReq_AUTH  → Objetivo de negocio de Autenticación
   BReq_USR   → Objetivo de negocio de Gestión de Usuarios
   BReq_RPT   → Objetivo de negocio de Reportería
   BReq_AUD   → Objetivo de negocio de Auditoría

**Nombre de Archivo:**

::

   BReq_[MOD]_[Nombre_Descriptivo].rst

   Ejemplos:
   - BReq_AUTH_Autenticacion.rst
   - BReq_USR_Gestion_Usuarios.rst
   - BReq_RPT_Reporteria.rst
   - BReq_AUD_Auditoria.rst

----

Relación BReq → Módulo
----------------------

Cada BReq está alineado con un módulo funcional:

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - BReq
     - Módulo
     - Descripción
   * - BReq_AUTH
     - MOD_Auth
     - Autenticación y gestión de sesiones
   * - BReq_USR
     - MOD_Users
     - Gestión del ciclo de vida de usuarios
   * - BReq_ACC
     - MOD_Access
     - Control de acceso y permisos RBAC
   * - BReq_PIP
     - MOD_Pipeline
     - Pipeline de datos ETL
   * - BReq_RPT
     - MOD_Reports
     - Reportería y visualización analítica
   * - BReq_ALR
     - MOD_Alerts
     - Sistema de alertas y notificaciones
   * - BReq_AUD
     - MOD_Audit
     - Auditoría y compliance
   * - BReq_LOG
     - MOD_Logs
     - Bitácoras del sistema

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: BReq_[MOD]
      :tipo: Objetivo de Negocio
      :dominio: requisitos
      :subdominio: objetivos_negocio
      :modulo: MOD_[Modulo]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _breq-[mod]:

                                               
   BReq_[MOD]: [Nombre del Objetivo de Negocio]
                                               

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - BReq_[MOD]
      * - **Nombre**
        - [Nombre descriptivo del objetivo]
      * - **Módulo**
        - MOD_[Modulo]
      * - **Stakeholder**
        - [Stakeholder principal interesado]
      * - **Prioridad**
        - [Crítica|Alta|Media|Baja]
      * - **Estado**
        - Vigente

   ----

   1. Declaración del Objetivo
   ---------------------------

   1.1 Enunciado
   ^^^^^^^^^^^^^

   .. note:: **Objetivo de Negocio BReq_[MOD]**

      [Enunciado claro y conciso del objetivo de negocio en 1-2 oraciones.
      Debe expresar QUÉ se quiere lograr, no CÓMO lograrlo.
      Usar formato: "El sistema debe permitir/proveer/garantizar..."]

   1.2 Justificación de Negocio
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   [Por qué es importante este objetivo para el negocio.
   Qué valor aporta, qué problema resuelve, qué necesidad satisface.]

   1.3 Beneficios Esperados
   ^^^^^^^^^^^^^^^^^^^^^^^^

   - [Beneficio 1: Descripción del beneficio esperado]
   - [Beneficio 2: Descripción del beneficio esperado]
   - [Beneficio 3: Descripción del beneficio esperado]

   ----

   2. Alcance
   ----------

   2.1 Incluido
   ^^^^^^^^^^^^

   - [Funcionalidad o capacidad incluida en este objetivo]
   - [Otra funcionalidad incluida]
   - [Otra funcionalidad incluida]

   2.2 Excluido
   ^^^^^^^^^^^^

   - [Funcionalidad explícitamente fuera de alcance]
   - [Otra exclusión]

   ----

   3. Stakeholders
   ---------------

   .. list-table::
      :widths: 25 35 40
      :header-rows: 1

      * - Stakeholder
        - Rol
        - Interés
      * - [Stakeholder 1]
        - [Rol en el proyecto]
        - [Qué espera de este objetivo]
      * - [Stakeholder 2]
        - [Rol en el proyecto]
        - [Qué espera de este objetivo]

   ----

   4. Criterios de Éxito
   ---------------------

   El objetivo se considera alcanzado cuando:

   - [ ] [Criterio medible y verificable 1]
   - [ ] [Criterio medible y verificable 2]
   - [ ] [Criterio medible y verificable 3]

   ----

   5. Artefactos Derivados
   -----------------------

   5.1 Business Rules (BR)
   ^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - BR
        - Nombre
        - Relación con BReq
      * - BR_[NNN]
        - [Nombre de la BR]
        - [Cómo esta BR implementa el objetivo]
      * - BR_[NNN]
        - [Nombre de la BR]
        - [Cómo esta BR implementa el objetivo]

   5.2 Casos de Uso (UC)
   ^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 50 30
      :header-rows: 1

      * - UC
        - Nombre
        - Cobertura
      * - UC_[MOD]_[NN]
        - [Nombre del UC]
        - [Qué parte del objetivo cubre]
      * - UC_[MOD]_[NN]
        - [Nombre del UC]
        - [Qué parte del objetivo cubre]

   ----

   6. Restricciones
   ----------------

   6.1 Restricciones de Negocio
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Restricción de negocio que limita el objetivo]
   - [Otra restricción de negocio]

   6.2 Restricciones Técnicas (CNST)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - CNST
        - Nombre
        - Impacto en BReq
      * - CNST_[NNN]
        - [Nombre de la restricción]
        - [Cómo afecta al objetivo]

   ----

   7. Dependencias
   ---------------

   7.1 Depende De
   ^^^^^^^^^^^^^^

   - [BReq_XXX]: [Descripción de la dependencia]
   - [Sistema externo]: [Descripción de la dependencia]

   7.2 Requerido Por
   ^^^^^^^^^^^^^^^^^

   - [BReq_YYY]: [Por qué depende de este objetivo]

   ----

   8. Riesgos
   ----------

   .. list-table::
      :widths: 30 20 50
      :header-rows: 1

      * - Riesgo
        - Probabilidad
        - Mitigación
      * - [Descripción del riesgo]
        - [Alta|Media|Baja]
        - [Estrategia de mitigación]

   ----

   9. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Módulo**
        - MOD_[Modulo]
      * - **BR Derivadas**
        - BR_[NNN], BR_[NNN], BR_[NNN]
      * - **UC Derivados**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]
      * - **CNST Aplicables**
        - CNST_[NNN], CNST_[NNN]

   ----

   10. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Versión
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Versión inicial

   ----

   *Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada BReq DEBE incluir mínimo estas 10 secciones:

.. list-table::
   :widths: 5 30 65
   :header-rows: 1

   * - #
     - Sección
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, módulo, stakeholder, prioridad
   * - 1
     - Declaración del Objetivo
     - Enunciado, justificación, beneficios
   * - 2
     - Alcance
     - Incluido y excluido
   * - 3
     - Stakeholders
     - Interesados y sus expectativas
   * - 4
     - Criterios de Éxito
     - Métricas verificables
   * - 5
     - Artefactos Derivados
     - BR y UC que implementan el objetivo
   * - 6
     - Restricciones
     - De negocio y técnicas (CNST)
   * - 7
     - Dependencias
     - De qué depende y qué depende de él
   * - 8
     - Riesgos
     - Riesgos y mitigaciones
   * - 9
     - Trazabilidad
     - Enlaces a MOD, BR, UC, CNST
   * - 10
     - Historial
     - Control de versiones

----

Buenas Prácticas
----------------

**Redacción del Enunciado:**

::

   ✅ CORRECTO (orientado a valor):
   "El sistema debe permitir a los usuarios autenticarse de forma segura
   para acceder a las funcionalidades según su rol asignado."

   ❌ INCORRECTO (orientado a implementación):
   "El sistema debe usar JWT con expiración de 8 horas y almacenar
   sesiones en PostgreSQL."

**Criterios de Éxito:**

::

   ✅ CORRECTO (medible):
   "El 100% de los accesos están controlados por el modelo RBAC"
   "El tiempo de autenticación es menor a 2 segundos"

   ❌ INCORRECTO (vago):
   "El sistema es seguro"
   "La autenticación funciona bien"

----

Validación
----------

Antes de aprobar un BReq, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura BReq_[MOD]
- [ ] Enunciado orientado a valor, no a implementación
- [ ] Justificación de negocio clara
- [ ] Criterios de éxito medibles
- [ ] BR derivadas identificadas
- [ ] UC derivados identificados
- [ ] CNST aplicables referenciadas
- [ ] Stakeholders identificados
- [ ] Riesgos documentados

**Comando de validación:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- FND_05: Jerarquía de 5 Niveles
- FND_02: Reglas de Negocio (nivel derivado)
- FND_03: Casos de Uso (nivel derivado)
- MODELO_DOCUMENTAL_IACT: Estructura de artefactos
- STD_006: Versionado Semántico

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial de plantilla BReq
