.. meta::
   :artefacto: TPL_POL
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-pol:

=====================================
TPL_POL: Plantilla de Politica v1.0.0
=====================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Politicas (POL)**
en el proyecto IACT. Las politicas establecen directrices de alto nivel que
gobiernan el comportamiento y decisiones del proyecto.

**Caracteristicas:**

- Directrices de alto nivel
- Marco de gobernanza del proyecto
- Principios y valores a seguir
- Base para estandares y procedimientos

**Diferencia entre POL, STD y PROC:**

::

   POL  -> QUE se debe lograr (directriz, principio)
   STD  -> COMO debe ser (norma tecnica, formato)
   PROC -> COMO se hace paso a paso (procedimiento)

**Las 2 Politicas IACT:**

::

   POL_001  -> Politica de Seguridad de la Informacion
   POL_002  -> Politica de Gestion de Cambios

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicacion:**

::

   normativa/politicas/POL_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``POL_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Definir principios claros y de alto nivel
5. Identificar STD y PROC que implementan la politica
6. Especificar responsabilidades
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   POL_[NNN]

   Donde:
   - POL: Prefijo fijo (Policy)
   - [NNN]: Numero secuencial de 3 digitos (001-999)

**Rangos por Categoria:**

::

   001-009: Seguridad
   010-019: Calidad
   020-029: Gestion de Cambios
   030-039: Gobernanza de Datos
   040-049: Operaciones

**Ejemplos:**

::

   POL_001  -> Politica de Seguridad
   POL_010  -> Politica de Calidad
   POL_020  -> Politica de Gestion de Cambios

**Nombre de Archivo:**

::

   POL_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - POL_001_Seguridad_Informacion.rst
   - POL_020_Gestion_Cambios.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: POL_[NNN]
      :tipo: Politica
      :dominio: normativa
      :subdominio: politicas
      :categoria: [Seguridad|Calidad|Cambios|Datos|Operaciones]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :aprobado_por: [Nombre del aprobador]
      :fecha_aprobacion: [YYYY-MM-DD]
      :clasificacion: Interno

   .. _pol-[nnn]:

                                     
   POL_[NNN]: [Nombre de la Politica]
                                     

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
        - POL_[NNN]
      * - **Nombre**
        - [Nombre descriptivo de la politica]
      * - **Categoria**
        - [Seguridad|Calidad|Cambios|Datos|Operaciones]
      * - **Aprobado por**
        - [Nombre y rol del aprobador]
      * - **Fecha Aprobacion**
        - [YYYY-MM-DD]
      * - **Proxima Revision**
        - [YYYY-MM-DD]
      * - **Estado**
        - Vigente

   ----

   1. Declaracion de la Politica
   -----------------------------

   .. note:: **Politica POL_[NNN]**

      [Declaracion formal de la politica en 2-4 oraciones.
      Debe ser clara, concisa y de alto nivel.
      Establece el compromiso y direccion general.]

   ----

   2. Proposito
   ------------

   [Descripcion del proposito de la politica.
   Responde: Por que existe esta politica y que objetivo busca?]

   ----

   3. Alcance
   ----------

   3.1 Aplica A
   ^^^^^^^^^^^^

   - [Personas, sistemas o procesos cubiertos]
   - [Otro contexto de aplicacion]

   3.2 No Aplica A
   ^^^^^^^^^^^^^^^

   - [Excepciones o exclusiones]

   ----

   4. Principios
   -------------

   4.1 Principio 1: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   [Descripcion del principio rector]

   4.2 Principio 2: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   [Descripcion del principio rector]

   4.3 Principio N: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   [Descripcion del principio rector]

   ----

   5. Directrices
   --------------

   5.1 [Area 1]
   ^^^^^^^^^^^^

   - [Directriz 1.1]
   - [Directriz 1.2]

   5.2 [Area 2]
   ^^^^^^^^^^^^

   - [Directriz 2.1]
   - [Directriz 2.2]

   5.3 [Area N]
   ^^^^^^^^^^^^

   - [Directriz N.1]
   - [Directriz N.2]

   ----

   6. Roles y Responsabilidades
   ----------------------------

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Rol
        - Responsabilidad
      * - [Rol 1]
        - [Responsabilidades respecto a esta politica]
      * - [Rol 2]
        - [Responsabilidades respecto a esta politica]
      * - [Rol N]
        - [Responsabilidades respecto a esta politica]
      * - Todos
        - Conocer y cumplir esta politica

   ----

   7. Implementacion
   -----------------

   7.1 Estandares Asociados
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - STD
        - Como implementa la politica
      * - STD_[NNN]
        - [Descripcion de como el estandar implementa la politica]
      * - STD_[NNN]
        - [Descripcion de como el estandar implementa la politica]

   7.2 Procedimientos Asociados
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - PROC
        - Como operacionaliza la politica
      * - PROC_[NNN]
        - [Descripcion de como el procedimiento operacionaliza la politica]
      * - PROC_[NNN]
        - [Descripcion de como el procedimiento operacionaliza la politica]

   ----

   8. Cumplimiento
   ---------------

   8.1 Monitoreo
   ^^^^^^^^^^^^^

   - **Frecuencia**: [Continuo|Mensual|Trimestral|Anual]
   - **Responsable**: [Rol responsable del monitoreo]
   - **Metodo**: [Como se monitorea el cumplimiento]

   8.2 Metricas de Cumplimiento
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 40 30 30
      :header-rows: 1

      * - Metrica
        - Objetivo
        - Frecuencia
      * - [Metrica 1]
        - [Valor objetivo]
        - [Frecuencia medicion]
      * - [Metrica 2]
        - [Valor objetivo]
        - [Frecuencia medicion]

   8.3 Incumplimiento
   ^^^^^^^^^^^^^^^^^^

   En caso de incumplimiento:

   1. [Accion 1: Notificacion]
   2. [Accion 2: Investigacion]
   3. [Accion 3: Medidas correctivas]
   4. [Accion 4: Escalamiento si es necesario]

   ----

   9. Excepciones
   --------------

   9.1 Proceso de Excepcion
   ^^^^^^^^^^^^^^^^^^^^^^^^

   Para solicitar una excepcion a esta politica:

   1. [Paso 1: Solicitud formal]
   2. [Paso 2: Justificacion documentada]
   3. [Paso 3: Aprobacion por...]
   4. [Paso 4: Registro de la excepcion]

   9.2 Excepciones Vigentes
   ^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 40 20 20
      :header-rows: 1

      * - ID
        - Descripcion
        - Aprobador
        - Vigencia
      * - EXC-001
        - [Descripcion de la excepcion]
        - [Quien aprobo]
        - [Hasta cuando]

   ----

   10. Revision y Actualizacion
   ----------------------------

   - **Frecuencia de revision**: [Anual|Semestral|Por evento]
   - **Responsable de revision**: [Rol]
   - **Proxima revision programada**: [YYYY-MM-DD]

   **Disparadores de revision extraordinaria:**

   - [Evento 1 que dispara revision]
   - [Evento 2 que dispara revision]

   ----

   11. Trazabilidad
   ----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **STD Asociados**
        - STD_[NNN], STD_[NNN]
      * - **PROC Asociados**
        - PROC_[NNN], PROC_[NNN]
      * - **BR Relacionadas**
        - BR_[NNN], BR_[NNN]
      * - **CNST Relacionadas**
        - CNST_[NNN]

   ----

   12. Referencias
   ---------------

   - [Referencia 1]: [Norma, ley o documento externo]
   - [Referencia 2]: [Norma, ley o documento externo]

   ----

   13. Historial de Cambios
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
        - Version inicial aprobada

   ----

   *Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada POL DEBE incluir minimo estas 13 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, aprobador, fecha
   * - 1
     - Declaracion
     - Enunciado formal de la politica
   * - 2
     - Proposito
     - Por que existe
   * - 3
     - Alcance
     - Donde aplica y donde no
   * - 4
     - Principios
     - Principios rectores
   * - 5
     - Directrices
     - Guias por area
   * - 6
     - Roles y Responsabilidades
     - Quien es responsable de que
   * - 7
     - Implementacion
     - STD y PROC asociados
   * - 8
     - Cumplimiento
     - Monitoreo, metricas, incumplimiento
   * - 9
     - Excepciones
     - Proceso y excepciones vigentes
   * - 10
     - Revision
     - Frecuencia y disparadores
   * - 11
     - Trazabilidad
     - STD, PROC, BR, CNST relacionados
   * - 12
     - Referencias
     - Documentacion externa
   * - 13
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar una POL, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura POL_[NNN]
- [ ] Categoria asignada correctamente
- [ ] Declaracion clara y de alto nivel
- [ ] Principios definidos
- [ ] Directrices especificadas por area
- [ ] Roles y responsabilidades asignados
- [ ] STD y PROC de implementacion identificados
- [ ] Metricas de cumplimiento definidas
- [ ] Proceso de excepcion documentado
- [ ] Frecuencia de revision establecida
- [ ] Aprobador identificado

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- STD_*: Estandares que implementan politicas
- PROC_*: Procedimientos que operacionalizan politicas
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
     - Version inicial de plantilla POL
