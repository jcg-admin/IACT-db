.. meta::
   :artefacto: TPL_FR
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-fr:

===============================================
TPL_FR: Plantilla de Requisito Funcional v1.0.0
===============================================


Propósito
---------

Esta plantilla define la estructura estándar para documentar **Requisitos Funcionales (FR)**
en el proyecto IACT. Los FR representan el nivel más detallado de especificación antes
de la implementación en código.

**Características:**

- Derivados de Casos de Uso (UC)
- Formato de criterios DADO/CUANDO/ENTONCES
- Trazabilidad completa hacia UC y BR
- Ratio aproximado: 1 UC → 8 FR

----

Requisitos Técnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicación:**

::

   requisitos/funcionales/[modulo]/FR_UC[MOD]_[NN]_[NN].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de sección "Plantilla" a nuevo archivo
2. Nombrar archivo según nomenclatura: ``FR_UC[MOD]_[NN]_[NN].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Completar criterios de aceptación en formato DADO/CUANDO/ENTONCES
5. Verificar trazabilidad hacia UC padre
6. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   FR_UC[MOD]_[NN]_[NN]

   Donde:
   - FR: Prefijo fijo (Functional Requirement)
   - UC[MOD]: Caso de Uso padre (AUTH, USR, ACC, PIP, RPT, ALR, AUD, LOG)
   - [NN]: Número del UC (01-99)
   - [NN]: Número secuencial del FR dentro del UC (01-99)

**Ejemplos:**

::

   FR_UCAUTH_01_01  → Primer FR del UC_AUTH_01
   FR_UCAUTH_01_02  → Segundo FR del UC_AUTH_01
   FR_UCUSR_02_03   → Tercer FR del UC_USR_02
   FR_UCACC_05_01   → Primer FR del UC_ACC_05

**Nombre de Archivo:**

::

   FR_UC[MOD]_[NN]_[NN].rst

   Ejemplos:
   - FR_UCAUTH_01_01.rst
   - FR_UCUSR_02_03.rst
   - FR_UCACC_05_01.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: FR_UC[MOD]_[NN]_[NN]
      :tipo: Requisito Funcional
      :dominio: requisitos
      :subdominio: funcionales/[modulo]
      :modulo: MOD_[Modulo]
      :uc_padre: UC_[MOD]_[NN]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _fr-uc[mod]-[nn]-[nn]:

                                                         
   FR_UC[MOD]_[NN]_[NN]: [Nombre del Requisito Funcional]
                                                         

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   1. Identificación
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - FR_UC[MOD]_[NN]_[NN]
      * - **Nombre**
        - [Nombre descriptivo del requisito funcional]
      * - **UC Padre**
        - UC_[MOD]_[NN]: [Nombre del UC]
      * - **Módulo**
        - MOD_[Modulo]
      * - **Tipo**
        - [Validación|Proceso|Interfaz|Datos|Auditoría|Seguridad]
      * - **Prioridad**
        - [Alta|Media|Baja]
      * - **Complejidad**
        - [Alta|Media|Baja]

   ----

   2. Especificación
   -----------------

   2.1 Descripción
   ^^^^^^^^^^^^^^^

   [Descripción detallada del requisito funcional en 2-4 oraciones.
   Debe responder: ¿Qué debe hacer el sistema específicamente?]

   2.2 Justificación
   ^^^^^^^^^^^^^^^^^

   [Por qué es necesario este requisito. Qué problema resuelve o qué
   valor aporta al usuario o al sistema.]

   ----

   3. Criterio de Aceptación
   -------------------------

   .. note:: **Formato DADO/CUANDO/ENTONCES**

   **DADO:**
     - [Precondición 1: Estado inicial del sistema]
     - [Precondición 2: Datos o contexto necesario]

   **CUANDO:**
     - [Acción que dispara el requisito]

   **ENTONCES:**
     - [Resultado esperado 1]
     - [Resultado esperado 2]
     - [Resultado esperado N]

   ----

   4. Reglas y Restricciones
   -------------------------

   4.1 Reglas de Negocio Aplicables
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 35 50
      :header-rows: 1

      * - BR
        - Nombre
        - Aplicación en este FR
      * - BR_[NNN]
        - [Nombre de la regla]
        - [Cómo aplica esta BR al FR]

   4.2 Restricciones Arquitectónicas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 35 50
      :header-rows: 1

      * - CNST
        - Nombre
        - Aplicación en este FR
      * - CNST_[NNN]
        - [Nombre de la restricción]
        - [Cómo aplica esta CNST al FR]

   ----

   5. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **UC Padre**
        - UC_[MOD]_[NN]: [Nombre del UC]
      * - **Paso del Flujo**
        - Paso [N] del flujo [normal|alterno|excepción]
      * - **BReq Origen**
        - BReq_[MOD]: [Nombre]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **CNST Aplicables**
        - CNST_[NNN], CNST_[NNN]
      * - **Función RBAC**
        - [xxx]_[nnn]: [nombre_funcion]

   ----

   6. Historial de Cambios
   -----------------------

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

Secciones Obligatorias
----------------------

Cada FR DEBE incluir mínimo estas 6 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Sección
     - Contenido
   * - 1
     - Identificación
     - ID, nombre, UC padre, módulo, tipo, prioridad
   * - 2
     - Especificación
     - Descripción detallada y justificación
   * - 3
     - Criterio de Aceptación
     - Formato DADO/CUANDO/ENTONCES obligatorio
   * - 4
     - Reglas y Restricciones
     - BR y CNST aplicables
   * - 5
     - Trazabilidad
     - Enlaces a UC, BReq, BR, CNST, RBAC
   * - 6
     - Historial
     - Control de versiones del FR

----

Tipos de FR
-----------

Clasificación según TXM_01:

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Tipo
     - Descripción
   * - **Validación**
     - Verifica formato, rango, existencia de datos
   * - **Proceso**
     - Ejecuta lógica de negocio, transformaciones
   * - **Interfaz**
     - Presenta información al usuario, actualiza UI
   * - **Datos**
     - CRUD en base de datos
   * - **Auditoría**
     - Registra eventos en logs de auditoría
   * - **Seguridad**
     - Verifica permisos, autenticación, autorización

----

Ejemplos de Criterios de Aceptación
-----------------------------------

**Ejemplo 1: FR de Validación**

::

   DADO:
     - El usuario está en el formulario de login
     - El campo username está visible

   CUANDO:
     - El usuario ingresa un username con formato inválido

   ENTONCES:
     - El sistema muestra mensaje "Username debe tener 3-50 caracteres alfanuméricos"
     - El campo username se resalta en rojo
     - El botón Submit permanece deshabilitado

**Ejemplo 2: FR de Proceso**

::

   DADO:
     - El usuario tiene sesión activa
     - El usuario tiene función auth_logout asignada

   CUANDO:
     - El usuario hace clic en "Cerrar Sesión"

   ENTONCES:
     - El token JWT actual se invalida
     - La sesión se elimina de la base de datos
     - El usuario es redirigido a la página de login
     - Se registra evento en auditoría

**Ejemplo 3: FR de Auditoría**

::

   DADO:
     - Un usuario ha completado una acción auditable
     - El sistema está configurado para auditar

   CUANDO:
     - La acción se completa exitosamente

   ENTONCES:
     - Se crea registro en user_action_log
     - El registro incluye: user_id, action, timestamp, ip_address
     - El registro es inmutable (BR_010)

----

Validación
----------

Antes de aprobar un FR, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura FR_UC[MOD]_[NN]_[NN]
- [ ] UC padre existe y está referenciado
- [ ] Criterios DADO/CUANDO/ENTONCES completos
- [ ] Al menos una BR o CNST referenciada
- [ ] Trazabilidad completa (UC, BReq, BR, CNST)
- [ ] Tipo de FR clasificado
- [ ] Prioridad asignada

**Comando de validación:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- FND_07: Requerimientos Funcionales (definición conceptual)
- FND_03 v1.3.0: Casos de Uso (relación UC → FR)
- FND_04: Trazabilidad (enlaces entre artefactos)
- TXM_01: Taxonomía de Requisitos (tipos de FR)
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
     - Versión inicial de plantilla FR
