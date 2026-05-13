.. meta::
   :artefacto: TPL_CNST
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-cnst:

========================================================
TPL_CNST: Plantilla de Restriccion Arquitectonica v1.0.0
========================================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Restricciones Arquitectonicas (CNST)**
en el proyecto IACT. Las CNST establecen limitaciones tecnicas no negociables que el sistema
debe respetar en su diseno e implementacion.

**Caracteristicas:**

- Limitaciones tecnicas obligatorias
- Derivan en Business Rules (BR) especificas
- Impactan decisiones arquitectonicas (ADR)
- No son negociables sin proceso formal de cambio

**Diferencia CNST vs BR:**

- CNST: Restriccion tecnica/arquitectonica (HOW)
- BR: Regla de negocio (WHAT)

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicacion:**

::

   arquitectura_tecnica/restricciones/CNST_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``CNST_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Clasificar segun categoria (Seguridad, Datos, Infraestructura, etc.)
5. Identificar BR que derivan de esta CNST
6. Documentar impacto en UC y MOD
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   CNST_[NNN]

   Donde:
   - CNST: Prefijo fijo (Constraint)
   - [NNN]: Numero secuencial de 3 digitos (001-999)

**Rangos por Categoria:**

::

   001-009: Comunicaciones y Conectividad
   010-019: Gestion de Datos
   020-029: Seguridad y Acceso
   030-039: Infraestructura
   040-049: Integracion
   050-059: Rendimiento

**Ejemplos:**

::

   CNST_001  -> Comunicaciones Prohibidas (sin email/SMS)
   CNST_003  -> Base de Datos Dual Inmutable
   CNST_005  -> Seguridad DRF Checklist
   CNST_008  -> Infraestructura Deployment

**Nombre de Archivo:**

::

   CNST_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - CNST_001_Comunicaciones_Prohibidas.rst
   - CNST_003_Base_Datos_Dual_Inmutable.rst
   - CNST_005_Seguridad_DRF_Checklist.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: CNST_[NNN]
      :tipo: Restriccion Arquitectonica
      :dominio: arquitectura_tecnica
      :subdominio: restricciones
      :categoria: [Comunicaciones|Datos|Seguridad|Infraestructura|Integracion|Rendimiento]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _cnst-[nnn]:

                                         
   CNST_[NNN]: [Nombre de la Restriccion]
                                         

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
        - CNST_[NNN]
      * - **Nombre**
        - [Nombre descriptivo de la restriccion]
      * - **Categoria**
        - [Comunicaciones|Datos|Seguridad|Infraestructura|Integracion|Rendimiento]
      * - **Criticidad**
        - [Critica|Alta|Media|Baja]
      * - **Negociable**
        - No
      * - **Estado**
        - Vigente

   ----

   1. Definicion
   -------------

   1.1 Enunciado de la Restriccion
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. warning:: **Restriccion Arquitectonica CNST_[NNN]**

      [Enunciado claro y conciso de la restriccion.
      Debe expresar QUE esta limitado o prohibido tecnicamente.]

   1.2 Justificacion Tecnica
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   [Por que existe esta restriccion. Que problema tecnico resuelve,
   que riesgo mitiga, que dependencia impone.]

   1.3 Origen
   ^^^^^^^^^^

   - **Fuente**: [Requisito de negocio|Limitacion tecnica|Normativa|Decisiones previas]
   - **Documento**: [Referencia al documento origen si existe]
   - **Fecha**: [Fecha de establecimiento]

   ----

   2. Especificacion Tecnica
   -------------------------

   2.1 Descripcion Detallada
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   [Descripcion tecnica completa de la restriccion.
   Incluir detalles de implementacion, tecnologias involucradas,
   configuraciones requeridas.]

   2.2 Parametros
   ^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 30 40
      :header-rows: 1

      * - Parametro
        - Valor
        - Descripcion
      * - [parametro_1]
        - [valor_1]
        - [Descripcion del parametro]
      * - [parametro_2]
        - [valor_2]
        - [Descripcion del parametro]

   2.3 Tecnologias Involucradas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Tecnologia 1]: [Rol en la restriccion]
   - [Tecnologia 2]: [Rol en la restriccion]

   ----

   3. Impacto en Sistema
   ---------------------

   3.1 Modulos Afectados
   ^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - Modulo
        - Impacto
      * - MOD_[xxx]
        - [Como afecta esta CNST al modulo]
      * - MOD_[yyy]
        - [Como afecta esta CNST al modulo]

   3.2 Casos de Uso Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - UC
        - Impacto
      * - UC_[MOD]_[NN]
        - [Como afecta esta CNST al UC]
      * - UC_[MOD]_[NN]
        - [Como afecta esta CNST al UC]

   3.3 Lo que NO se puede hacer
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Accion o funcionalidad prohibida por esta restriccion]
   - [Otra accion prohibida]

   ----

   4. Business Rules Derivadas
   ---------------------------

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - BR
        - Nombre
        - Relacion
      * - BR_[NNN]
        - [Nombre de la BR]
        - [Como esta BR implementa la CNST]
      * - BR_[NNN]
        - [Nombre de la BR]
        - [Como esta BR implementa la CNST]

   ----

   5. Implementacion
   -----------------

   5.1 Codigo de Referencia
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: python

      # Implementacion de CNST_[NNN]
      # [Nombre de la restriccion]
      
      # settings.py o configuracion relevante
      [CODIGO_EJEMPLO]

   5.2 Configuracion
   ^^^^^^^^^^^^^^^^^

   .. code-block:: yaml

      # Configuracion requerida
      [CONFIGURACION_EJEMPLO]

   5.3 Validacion de Cumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: bash

      # Comando para verificar cumplimiento
      [COMANDO_VERIFICACION]

   ----

   6. Excepciones
   --------------

   6.1 Excepciones Permitidas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Excepcion 1: Condicion bajo la cual no aplica]
   - [Excepcion 2: Otra condicion de excepcion]

   6.2 Proceso de Excepcion
   ^^^^^^^^^^^^^^^^^^^^^^^^

   Para solicitar una excepcion a esta CNST:

   1. [Paso 1 del proceso]
   2. [Paso 2 del proceso]
   3. [Paso 3: Aprobacion requerida por...]

   ----

   7. Verificacion
   ---------------

   7.1 Criterios de Cumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [ ] [Criterio verificable 1]
   - [ ] [Criterio verificable 2]
   - [ ] [Criterio verificable 3]

   7.2 Metodo de Verificacion
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Tipo**: [Automatico|Manual|Mixto]
   - **Frecuencia**: [Continuo|Por deployment|Por release]
   - **Herramienta**: [Herramienta de verificacion]

   ----

   8. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ADR Relacionadas**
        - ADR_[NNN]: [Nombre]
      * - **BR Derivadas**
        - BR_[NNN], BR_[NNN]
      * - **UC Afectados**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]
      * - **MOD Afectados**
        - MOD_[xxx], MOD_[yyy]
      * - **NFR Relacionados**
        - NFR_[NNN]

   ----

   9. Historial de Cambios
   -----------------------

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

Cada CNST DEBE incluir minimo estas 9 secciones:

.. list-table::
   :widths: 5 30 65
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, categoria, criticidad
   * - 1
     - Definicion
     - Enunciado, justificacion, origen
   * - 2
     - Especificacion Tecnica
     - Descripcion, parametros, tecnologias
   * - 3
     - Impacto en Sistema
     - MOD, UC afectados, prohibiciones
   * - 4
     - BR Derivadas
     - Business Rules que implementan la CNST
   * - 5
     - Implementacion
     - Codigo, configuracion, validacion
   * - 6
     - Excepciones
     - Excepciones permitidas y proceso
   * - 7
     - Verificacion
     - Criterios y metodo
   * - 8
     - Trazabilidad
     - ADR, BR, UC, MOD, NFR relacionados
   * - 9
     - Historial
     - Control de versiones

----

Categorias de CNST
------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Categoria
     - Descripcion
   * - **Comunicaciones**
     - Restricciones sobre canales de comunicacion (email, SMS, etc.)
   * - **Datos**
     - Restricciones sobre almacenamiento, acceso, retencion de datos
   * - **Seguridad**
     - Restricciones de autenticacion, autorizacion, cifrado
   * - **Infraestructura**
     - Restricciones de deployment, servidores, contenedores
   * - **Integracion**
     - Restricciones de APIs externas, protocolos, formatos
   * - **Rendimiento**
     - Restricciones de tiempos, throughput, recursos

----

Validacion
----------

Antes de aprobar una CNST, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura CNST_[NNN]
- [ ] Categoria asignada correctamente
- [ ] Enunciado es claro y no ambiguo
- [ ] Justificacion tecnica documentada
- [ ] BR derivadas identificadas
- [ ] MOD y UC afectados listados
- [ ] Implementacion de referencia incluida
- [ ] Criterios de verificacion definidos
- [ ] Proceso de excepcion documentado

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- ADR_*: Decisiones arquitectonicas relacionadas
- BR_*: Business Rules derivadas
- NFR_*: Requisitos no funcionales relacionados
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
     - Version inicial de plantilla CNST
