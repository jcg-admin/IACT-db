.. meta::
   :artefacto: TPL_STD
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-std:

=====================================
TPL_STD: Plantilla de Estandar v1.0.0
=====================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Estandares (STD)**
en el proyecto IACT. Los estandares establecen normas tecnicas y convenciones
que deben seguirse en el desarrollo y documentacion del proyecto.

**Caracteristicas:**

- Normas tecnicas obligatorias
- Convenciones de codigo y documentacion
- Guias de estilo y formato
- Reglas verificables y auditables

**Los 6 Estandares IACT:**

::

   STD_001  -> Estructura de Documentacion
   STD_002  -> Nomenclatura de Artefactos
   STD_003  -> Formato de Diagramas PlantUML
   STD_004  -> Convenciones de Codigo Python
   STD_005  -> Formato de Commits Git
   STD_006  -> Versionado Semantico

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicacion:**

::

   normativa/estandares/STD_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``STD_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Definir reglas claras y verificables
5. Incluir ejemplos correctos e incorrectos
6. Especificar metodo de verificacion
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   STD_[NNN]

   Donde:
   - STD: Prefijo fijo (Standard)
   - [NNN]: Numero secuencial de 3 digitos (001-999)

**Rangos por Categoria:**

::

   001-019: Documentacion
   020-039: Codigo
   040-059: Arquitectura
   060-079: Pruebas
   080-099: Operaciones

**Ejemplos:**

::

   STD_001  -> Estructura de Documentacion
   STD_006  -> Versionado Semantico
   STD_020  -> Convenciones Python
   STD_040  -> Patrones de Diseno

**Nombre de Archivo:**

::

   STD_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - STD_001_Estructura_Documentacion.rst
   - STD_006_Versionado_Semantico.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: STD_[NNN]
      :tipo: Estandar
      :dominio: normativa
      :subdominio: estandares
      :categoria: [Documentacion|Codigo|Arquitectura|Pruebas|Operaciones]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _std-[nnn]:

                                   
   STD_[NNN]: [Nombre del Estandar]
                                   

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
        - STD_[NNN]
      * - **Nombre**
        - [Nombre descriptivo del estandar]
      * - **Categoria**
        - [Documentacion|Codigo|Arquitectura|Pruebas|Operaciones]
      * - **Obligatoriedad**
        - [Obligatorio|Recomendado]
      * - **Aplica a**
        - [Artefactos o procesos donde aplica]
      * - **Estado**
        - Vigente

   ----

   1. Proposito
   ------------

   [Descripcion del proposito del estandar en 2-3 oraciones.
   Responde: Por que existe este estandar y que problema resuelve?]

   ----

   2. Alcance
   ----------

   2.1 Aplica A
   ^^^^^^^^^^^^

   - [Tipo de artefacto o proceso donde aplica]
   - [Otro contexto de aplicacion]

   2.2 No Aplica A
   ^^^^^^^^^^^^^^^

   - [Excepciones o situaciones donde NO se usa]

   ----

   3. Definiciones
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Termino
        - Definicion
      * - [Termino 1]
        - [Definicion del termino]
      * - [Termino 2]
        - [Definicion del termino]

   ----

   4. Reglas del Estandar
   ----------------------

   4.1 Regla 1: [Nombre de la Regla]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Enunciado:**
   [Descripcion clara de la regla]

   **Ejemplo correcto:**

   .. code-block:: [lenguaje]

      [Ejemplo de aplicacion correcta]

   **Ejemplo incorrecto:**

   .. code-block:: [lenguaje]

      [Ejemplo de aplicacion incorrecta]

   ----

   4.2 Regla 2: [Nombre de la Regla]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Enunciado:**
   [Descripcion clara de la regla]

   **Ejemplo correcto:**

   .. code-block:: [lenguaje]

      [Ejemplo de aplicacion correcta]

   **Ejemplo incorrecto:**

   .. code-block:: [lenguaje]

      [Ejemplo de aplicacion incorrecta]

   ----

   4.3 Regla N: [Nombre de la Regla]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Enunciado:**
   [Descripcion clara de la regla]

   **Ejemplo correcto:**

   .. code-block:: [lenguaje]

      [Ejemplo de aplicacion correcta]

   ----

   5. Tabla de Reglas Resumen
   --------------------------

   .. list-table::
      :widths: 10 40 25 25
      :header-rows: 1

      * - #
        - Regla
        - Obligatoriedad
        - Verificacion
      * - 1
        - [Nombre regla 1]
        - Obligatorio
        - [Automatica|Manual]
      * - 2
        - [Nombre regla 2]
        - Obligatorio
        - [Automatica|Manual]
      * - N
        - [Nombre regla N]
        - Recomendado
        - [Automatica|Manual]

   ----

   6. Verificacion
   ---------------

   6.1 Verificacion Automatica
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: bash

      # Comando para verificar cumplimiento
      [comando_de_verificacion]

   6.2 Verificacion Manual
   ^^^^^^^^^^^^^^^^^^^^^^^

   **Checklist de revision:**

   - [ ] [Item de verificacion 1]
   - [ ] [Item de verificacion 2]
   - [ ] [Item de verificacion 3]

   6.3 Herramientas
   ^^^^^^^^^^^^^^^^

   - [Herramienta 1]: [Para que se usa]
   - [Herramienta 2]: [Para que se usa]

   ----

   7. Excepciones
   --------------

   7.1 Excepciones Permitidas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Excepcion 1: Condicion bajo la cual no aplica]
   - [Excepcion 2: Otra condicion de excepcion]

   7.2 Proceso de Excepcion
   ^^^^^^^^^^^^^^^^^^^^^^^^

   Para solicitar una excepcion a este estandar:

   1. [Paso 1 del proceso]
   2. [Paso 2 del proceso]
   3. [Paso 3: Aprobacion requerida por...]

   ----

   8. Consecuencias de Incumplimiento
   ----------------------------------

   - [Consecuencia 1: Que pasa si no se cumple]
   - [Consecuencia 2: Impacto en el proyecto]

   ----

   9. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **PROC Relacionados**
        - PROC_[NNN]: [Nombre]
      * - **TPL Relacionados**
        - TPL_[XXX]: [Nombre]
      * - **Artefactos Afectados**
        - [Lista de tipos de artefactos]

   ----

   10. Referencias
   ---------------

   - [Referencia 1]: [URL o documento]
   - [Referencia 2]: [URL o documento]

   ----

   11. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Version inicial

   ----

   *Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada STD DEBE incluir minimo estas 11 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, categoria, obligatoriedad
   * - 1
     - Proposito
     - Por que existe el estandar
   * - 2
     - Alcance
     - Donde aplica y donde no
   * - 3
     - Definiciones
     - Terminos clave
   * - 4
     - Reglas del Estandar
     - Cada regla con ejemplos
   * - 5
     - Tabla de Reglas
     - Resumen de todas las reglas
   * - 6
     - Verificacion
     - Automatica, manual, herramientas
   * - 7
     - Excepciones
     - Permitidas y proceso
   * - 8
     - Consecuencias
     - Impacto de incumplimiento
   * - 9
     - Trazabilidad
     - PROC, TPL, artefactos relacionados
   * - 10
     - Referencias
     - Documentacion externa
   * - 11
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar un STD, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura STD_[NNN]
- [ ] Categoria asignada correctamente
- [ ] Proposito claro y justificado
- [ ] Alcance bien definido
- [ ] Cada regla tiene ejemplo correcto e incorrecto
- [ ] Metodo de verificacion especificado
- [ ] Excepciones documentadas
- [ ] Consecuencias de incumplimiento claras

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- PROC_*: Procedimientos que aplican estandares
- TPL_*: Plantillas que implementan estandares
- STD_006: Versionado Semantico

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial de plantilla STD
