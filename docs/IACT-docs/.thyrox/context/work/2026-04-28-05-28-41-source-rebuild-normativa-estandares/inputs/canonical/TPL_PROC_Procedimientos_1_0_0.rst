.. meta::
   :artefacto: TPL_PROC
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-proc:

===========================================
TPL_PROC: Plantilla de Procedimiento v1.0.0
===========================================


Propósito
---------

Esta plantilla define la estructura estándar para documentar **Procedimientos (PROC)**
en el proyecto IACT. Los procedimientos establecen los pasos formales para ejecutar
actividades de gobernanza, generación de artefactos y control de cambios.

**Características:**

- Pasos numerados y secuenciales
- Roles y responsabilidades definidos
- Precondiciones y postcondiciones claras
- Artefactos de entrada y salida especificados
- Criterios de verificación incluidos

----

Requisitos Técnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicación:**

::

   normativa/procedimientos/PROC_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de sección "Plantilla" a nuevo archivo
2. Nombrar archivo según nomenclatura: ``PROC_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Definir roles involucrados
5. Completar pasos del procedimiento
6. Especificar artefactos de entrada/salida
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   PROC_[NNN]

   Donde:
   - PROC: Prefijo fijo (Procedure)
   - [NNN]: Número secuencial de 3 dígitos (001-999)

**Categorías de PROC:**

::

   001-009: Procedimientos de Cambio y Control
   010-019: Procedimientos de Generación de Artefactos
   020-029: Procedimientos de Derivación
   030-039: Procedimientos de Gobernanza
   040-049: Procedimientos de Trazabilidad
   050-059: Procedimientos de Verificación

**Ejemplos:**

::

   PROC_001  → Cambio de Requisitos
   PROC_006  → Generación de FR
   PROC_014  → Derivación UC a FR
   PROC_017  → Aplicar Versionado Semántico

**Nombre de Archivo:**

::

   PROC_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - PROC_001_Cambio_Requisitos.rst
   - PROC_006_Generacion_FR.rst
   - PROC_014_Derivacion_UC_FR.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: PROC_[NNN]
      :tipo: Procedimiento
      :dominio: normativa
      :subdominio: procedimientos
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _proc-[nnn]:

                                         
   PROC_[NNN]: [Nombre del Procedimiento]
                                         

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
        - PROC_[NNN]
      * - **Nombre**
        - [Nombre descriptivo del procedimiento]
      * - **Categoría**
        - [Cambio|Generación|Derivación|Gobernanza|Trazabilidad|Verificación]
      * - **Frecuencia**
        - [Por evento|Diario|Semanal|Por release]
      * - **Duración Estimada**
        - [Tiempo estimado de ejecución]
      * - **Estado**
        - Vigente

   ----

   1. Propósito
   ------------

   [Descripción del objetivo del procedimiento en 2-3 oraciones.
   Responde: ¿Qué se logra al ejecutar este procedimiento?]

   ----

   2. Alcance
   ----------

   2.1 Aplica A
   ^^^^^^^^^^^^

   - [Artefactos, actividades o situaciones donde aplica]
   - [Otro contexto de aplicación]

   2.2 No Aplica A
   ^^^^^^^^^^^^^^^

   - [Excepciones o situaciones donde NO se usa este procedimiento]

   ----

   3. Roles y Responsabilidades
   ----------------------------

   .. list-table::
      :widths: 20 30 50
      :header-rows: 1

      * - Rol
        - Responsabilidad
        - Permisos Requeridos
      * - [Rol_Ejecutor]
        - Ejecuta los pasos del procedimiento
        - [Función RBAC requerida]
      * - [Rol_Revisor]
        - Revisa y aprueba resultados
        - [Función RBAC requerida]
      * - [Rol_Aprobador]
        - Aprobación final
        - [Función RBAC requerida]

   ----

   4. Precondiciones
   -----------------

   Antes de iniciar este procedimiento, verificar:

   - [ ] [Precondición 1: Artefacto o estado requerido]
   - [ ] [Precondición 2: Acceso o permiso necesario]
   - [ ] [Precondición 3: Template disponible]
   - [ ] [Precondición 4: Información de entrada completa]

   ----

   5. Artefactos de Entrada
   ------------------------

   .. list-table::
      :widths: 30 50 20
      :header-rows: 1

      * - Artefacto
        - Descripción
        - Obligatorio
      * - [TPL_xxx]
        - Plantilla a utilizar
        - Sí
      * - [Artefacto_Fuente]
        - Documento origen de información
        - Sí
      * - [Artefacto_Referencia]
        - Documento de consulta
        - No

   ----

   6. Procedimiento
   ----------------

   6.1 Diagrama de Flujo
   ^^^^^^^^^^^^^^^^^^^^^

   .. uml::
      :caption: Flujo del Procedimiento PROC_[NNN]
      :align: center

      @startuml
      skinparam backgroundColor #FAFAFA
      skinparam activity {
          BackgroundColor #E3F2FD
          BorderColor #1976D2
          DiamondBackgroundColor #FFF9C4
          DiamondBorderColor #F57C00
      }

      start

      :[Paso 1];

      if ([Condición de decisión]?) then (sí)
          :[Acción si verdadero];
      else (no)
          :[Acción si falso];
      endif

      :[Paso final];

      stop
      @enduml

   6.2 Pasos Detallados
   ^^^^^^^^^^^^^^^^^^^^

   **Paso 1: [Nombre del Paso]**

   - **Responsable**: [Rol]
   - **Acción**: [Descripción detallada de la acción]
   - **Resultado**: [Qué se produce o cambia]
   - **Verificación**: [Cómo verificar que se completó correctamente]

   **Paso 2: [Nombre del Paso]**

   - **Responsable**: [Rol]
   - **Acción**: [Descripción detallada de la acción]
   - **Resultado**: [Qué se produce o cambia]
   - **Verificación**: [Cómo verificar que se completó correctamente]

   **Paso 3: [Nombre del Paso]**

   - **Responsable**: [Rol]
   - **Acción**: [Descripción detallada de la acción]
   - **Resultado**: [Qué se produce o cambia]
   - **Verificación**: [Cómo verificar que se completó correctamente]

   **Paso N: [Nombre del Paso Final]**

   - **Responsable**: [Rol]
   - **Acción**: [Descripción detallada de la acción]
   - **Resultado**: [Qué se produce o cambia]
   - **Verificación**: [Cómo verificar que se completó correctamente]

   ----

   7. Artefactos de Salida
   -----------------------

   .. list-table::
      :widths: 30 50 20
      :header-rows: 1

      * - Artefacto
        - Descripción
        - Ubicación
      * - [Artefacto_Generado]
        - [Descripción del artefacto producido]
        - [Ruta en el proyecto]
      * - [Registro_Actualizado]
        - [Documento actualizado como resultado]
        - [Ruta en el proyecto]

   ----

   8. Postcondiciones
   ------------------

   Al finalizar este procedimiento:

   - [ ] [Postcondición 1: Estado final del sistema o artefacto]
   - [ ] [Postcondición 2: Registro o log actualizado]
   - [ ] [Postcondición 3: Notificación enviada]

   ----

   9. Verificación y Validación
   ----------------------------

   9.1 Criterios de Aceptación
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [ ] [Criterio 1: Artefacto cumple con template]
   - [ ] [Criterio 2: Nomenclatura correcta]
   - [ ] [Criterio 3: Trazabilidad completa]
   - [ ] [Criterio 4: Validación Sphinx exitosa]

   9.2 Comando de Validación
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: bash

      # Validar artefactos generados
      sphinx-build -b html -W docs/ docs/_build/

   ----

   10. Manejo de Excepciones
   -------------------------

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Excepción
        - Acción Correctiva
      * - [Excepción 1]
        - [Qué hacer si ocurre esta excepción]
      * - [Excepción 2]
        - [Qué hacer si ocurre esta excepción]

   ----

   11. Referencias
   ---------------

   - [TPL_xxx]: Plantilla utilizada
   - [STD_xxx]: Estándar relacionado
   - [PROC_xxx]: Procedimiento relacionado

   ----

   12. Historial de Cambios
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

Cada PROC DEBE incluir mínimo estas 12 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Sección
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, categoría, frecuencia, duración
   * - 1
     - Propósito
     - Objetivo del procedimiento
   * - 2
     - Alcance
     - Donde aplica y donde NO aplica
   * - 3
     - Roles y Responsabilidades
     - Quién ejecuta, revisa, aprueba
   * - 4
     - Precondiciones
     - Checklist antes de iniciar
   * - 5
     - Artefactos de Entrada
     - Templates y documentos necesarios
   * - 6
     - Procedimiento
     - Diagrama + pasos detallados
   * - 7
     - Artefactos de Salida
     - Qué se produce
   * - 8
     - Postcondiciones
     - Estado final esperado
   * - 9
     - Verificación
     - Criterios y comandos de validación
   * - 10
     - Manejo de Excepciones
     - Qué hacer si algo falla
   * - 11
     - Referencias
     - Templates, estándares, otros PROC
   * - 12
     - Historial
     - Control de versiones

----

Categorías de Procedimientos
----------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Categoría
     - Descripción
   * - **Cambio**
     - Control de cambios en requisitos y documentos
   * - **Generación**
     - Crear nuevos artefactos (BR, UC, FR, etc.)
   * - **Derivación**
     - Derivar artefactos hijos de padres (UC→FR)
   * - **Gobernanza**
     - Versionado, congelamiento, aprobaciones
   * - **Trazabilidad**
     - Generar y mantener RTM
   * - **Verificación**
     - Validar cumplimiento y cobertura

----

Ejemplo de Pasos
----------------

**Ejemplo: Procedimiento de Generación de FR**

::

   Paso 1: Revisar Template
   - Responsable: Analista
   - Acción: Abrir TPL_FR_Requisitos_Funcionales_1_0_0.rst
   - Resultado: Template disponible para uso
   - Verificación: Template existe y es versión correcta

   Paso 2: Identificar UC Padre
   - Responsable: Analista
   - Acción: Localizar UC del cual se derivará el FR
   - Resultado: UC identificado con sus pasos de flujo
   - Verificación: UC está en estado Aprobado

   Paso 3: Crear Archivo FR
   - Responsable: Analista
   - Acción: Copiar template y nombrar según nomenclatura
   - Resultado: Archivo FR_UCxxx_nn_nn.rst creado
   - Verificación: Nombre sigue patrón FR_UC[MOD]_[NN]_[NN].rst

   Paso 4: Completar Secciones
   - Responsable: Analista
   - Acción: Llenar las 6 secciones obligatorias
   - Resultado: FR documentado completamente
   - Verificación: Todas las secciones tienen contenido

   Paso 5: Validar
   - Responsable: Analista
   - Acción: Ejecutar sphinx-build -W
   - Resultado: Build exitoso sin errores
   - Verificación: Comando retorna código 0

----

Validación
----------

Antes de aprobar un PROC, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura PROC_[NNN]
- [ ] Categoría asignada correctamente
- [ ] Roles definidos con permisos RBAC
- [ ] Precondiciones son verificables
- [ ] Pasos son secuenciales y claros
- [ ] Cada paso tiene responsable, acción, resultado
- [ ] Artefactos de entrada/salida especificados
- [ ] Postcondiciones verificables
- [ ] Excepciones documentadas

**Comando de validación:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- STD_006: Versionado Semántico
- MODELO_DOCUMENTAL_IACT: Estructura de artefactos
- TPL_*: Plantillas referenciadas en procedimientos

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
     - Versión inicial de plantilla PROC
