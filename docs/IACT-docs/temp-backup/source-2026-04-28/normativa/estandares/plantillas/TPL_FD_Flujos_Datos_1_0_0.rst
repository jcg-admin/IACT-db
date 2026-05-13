.. meta::
   :artefacto: TPL_FD
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-fd:

==========================================
TPL_FD: Plantilla de Flujo de Datos v1.0.0
==========================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Flujos de Datos (FD)**
en el proyecto IACT. Los FD describen como los datos se mueven a traves del sistema,
desde su origen hasta su destino, incluyendo transformaciones intermedias.

**Caracteristicas:**

- Describe movimiento de datos end-to-end
- Incluye diagramas de flujo PlantUML
- Documenta transformaciones y validaciones
- Especifica fuentes y destinos de datos
- Relacionado con UC y MOD que participan

**Los 12 Flujos de Datos IACT:**

::

   FD_01  -> Autenticacion
   FD_02  -> Resolucion Permisos
   FD_03  -> Gestion Identidades
   FD_04  -> Ejecucion ETL
   FD_05  -> Supervision ETL
   FD_06  -> Visualizacion
   FD_07  -> Exportacion
   FD_08  -> Alertas
   FD_09  -> Auditoria
   FD_10  -> Bitacoras
   FD_11  -> Enforcement SEC_RULES
   FD_12  -> Mensajeria Interna

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- sphinxcontrib-plantuml >= 0.27
- PlantUML (JAR o servidor)

**Ubicacion:**

::

   arquitectura_tecnica/flujos_datos/FD_[NN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``FD_[NN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Documentar fuentes y destinos de datos
5. Especificar transformaciones intermedias
6. Completar diagrama de flujo PlantUML
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   FD_[NN]

   Donde:
   - FD: Prefijo fijo (Flow Data / Flujo de Datos)
   - [NN]: Numero secuencial de 2 digitos (01-99)

**Ejemplos:**

::

   FD_01  -> Flujo de Autenticacion
   FD_04  -> Flujo de Ejecucion ETL
   FD_07  -> Flujo de Exportacion
   FD_09  -> Flujo de Auditoria

**Nombre de Archivo:**

::

   FD_[NN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - FD_01_Autenticacion.rst
   - FD_04_Ejecucion_ETL.rst
   - FD_07_Exportacion.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: FD_[NN]
      :tipo: Flujo de Datos
      :dominio: arquitectura_tecnica
      :subdominio: flujos_datos
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _fd-[nn]:

                                       
   FD_[NN]: [Nombre del Flujo de Datos]
                                       

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
        - FD_[NN]
      * - **Nombre**
        - [Nombre descriptivo del flujo]
      * - **Tipo**
        - [Sincronico|Asincronico|Batch|Streaming]
      * - **Frecuencia**
        - [Tiempo real|Por evento|Programado|Bajo demanda]
      * - **Modulos Involucrados**
        - MOD_[xxx], MOD_[yyy]
      * - **Estado**
        - [Activo|En desarrollo]

   ----

   1. Descripcion General
   ----------------------

   [Descripcion del proposito del flujo de datos en 2-3 oraciones.
   Responde: Que datos se mueven, de donde a donde, y por que?]

   ----

   2. Diagrama de Flujo
   --------------------

   .. uml::
      :caption: Diagrama de Flujo FD_[NN]
      :align: center

      @startuml
      skinparam backgroundColor #FAFAFA
      skinparam activity {
          BackgroundColor #E3F2FD
          BorderColor #1976D2
      }
      skinparam database {
          BackgroundColor #FFF3E0
          BorderColor #F57C00
      }

      start

      :[Paso inicial - Origen de datos];

      if ([Condicion de validacion]?) then (valido)
          :[Transformacion 1];
          :[Transformacion 2];
      else (invalido)
          :[Manejo de error];
          stop
      endif

      :[Paso final - Destino de datos];

      stop
      @enduml

   ----

   3. Fuentes de Datos
   -------------------

   .. list-table::
      :widths: 25 25 50
      :header-rows: 1

      * - Fuente
        - Tipo
        - Descripcion
      * - [Nombre fuente 1]
        - [BD|API|Archivo|Usuario]
        - [Descripcion de la fuente]
      * - [Nombre fuente 2]
        - [BD|API|Archivo|Usuario]
        - [Descripcion de la fuente]

   ----

   4. Destinos de Datos
   --------------------

   .. list-table::
      :widths: 25 25 50
      :header-rows: 1

      * - Destino
        - Tipo
        - Descripcion
      * - [Nombre destino 1]
        - [BD|API|Archivo|UI]
        - [Descripcion del destino]
      * - [Nombre destino 2]
        - [BD|API|Archivo|UI]
        - [Descripcion del destino]

   ----

   5. Transformaciones
   -------------------

   5.1 Secuencia de Transformaciones
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 10 30 60
      :header-rows: 1

      * - Paso
        - Transformacion
        - Descripcion
      * - 1
        - [Nombre transformacion]
        - [Que hace esta transformacion]
      * - 2
        - [Nombre transformacion]
        - [Que hace esta transformacion]
      * - N
        - [Nombre transformacion]
        - [Que hace esta transformacion]

   5.2 Validaciones
   ^^^^^^^^^^^^^^^^

   - **Validacion 1**: [Descripcion de la validacion]
   - **Validacion 2**: [Descripcion de la validacion]

   5.3 Reglas de Negocio Aplicadas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - BR_[NNN]: [Como se aplica en este flujo]
   - BR_[NNN]: [Como se aplica en este flujo]

   ----

   6. Estructura de Datos
   ----------------------

   6.1 Datos de Entrada
   ^^^^^^^^^^^^^^^^^^^^

   .. code-block:: json

      {
          "campo_1": "[tipo] - [descripcion]",
          "campo_2": "[tipo] - [descripcion]",
          "campo_n": "[tipo] - [descripcion]"
      }

   6.2 Datos de Salida
   ^^^^^^^^^^^^^^^^^^^

   .. code-block:: json

      {
          "campo_1": "[tipo] - [descripcion]",
          "campo_2": "[tipo] - [descripcion]",
          "campo_n": "[tipo] - [descripcion]"
      }

   ----

   7. Componentes Involucrados
   ---------------------------

   .. list-table::
      :widths: 25 25 50
      :header-rows: 1

      * - Componente
        - Modulo
        - Rol en el Flujo
      * - [NombreClase/Servicio]
        - MOD_[xxx]
        - [Que hace en este flujo]
      * - [NombreClase/Servicio]
        - MOD_[yyy]
        - [Que hace en este flujo]

   ----

   8. Manejo de Errores
   --------------------

   8.1 Errores Posibles
   ^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 30 40
      :header-rows: 1

      * - Error
        - Causa
        - Accion
      * - [Codigo/Nombre error]
        - [Causa del error]
        - [Que hacer cuando ocurre]
      * - [Codigo/Nombre error]
        - [Causa del error]
        - [Que hacer cuando ocurre]

   8.2 Estrategia de Retry
   ^^^^^^^^^^^^^^^^^^^^^^^

   - **Intentos maximos**: [N]
   - **Intervalo entre intentos**: [segundos]
   - **Backoff**: [Exponencial|Lineal|Ninguno]

   ----

   9. Rendimiento
   --------------

   9.1 Metricas Esperadas
   ^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 40 30 30
      :header-rows: 1

      * - Metrica
        - Valor Esperado
        - Limite
      * - Tiempo de ejecucion
        - [X segundos]
        - [Y segundos max]
      * - Volumen de datos
        - [N registros]
        - [M registros max]
      * - Frecuencia
        - [Cada X minutos/horas]
        - -

   9.2 Optimizaciones
   ^^^^^^^^^^^^^^^^^^

   - [Optimizacion 1 implementada]
   - [Optimizacion 2 implementada]

   ----

   10. Seguridad
   -------------

   10.1 Datos Sensibles
   ^^^^^^^^^^^^^^^^^^^^

   - [Campo sensible 1]: [Nivel de clasificacion]
   - [Campo sensible 2]: [Nivel de clasificacion]

   10.2 Controles de Seguridad
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Control 1]: [Descripcion]
   - [Control 2]: [Descripcion]

   ----

   11. Trazabilidad
   ----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **UC Relacionados**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]
      * - **MOD Involucrados**
        - MOD_[xxx], MOD_[yyy]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **CNST Aplicables**
        - CNST_[NNN]

   ----

   12. Historial de Cambios
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

Cada FD DEBE incluir minimo estas 12 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, tipo, frecuencia, modulos
   * - 1
     - Descripcion General
     - Proposito del flujo
   * - 2
     - Diagrama de Flujo
     - PlantUML del flujo
   * - 3
     - Fuentes de Datos
     - Origen de los datos
   * - 4
     - Destinos de Datos
     - Donde terminan los datos
   * - 5
     - Transformaciones
     - Pasos, validaciones, BR aplicadas
   * - 6
     - Estructura de Datos
     - Entrada y salida en JSON
   * - 7
     - Componentes
     - Clases/servicios involucrados
   * - 8
     - Manejo de Errores
     - Errores y retry
   * - 9
     - Rendimiento
     - Metricas y optimizaciones
   * - 10
     - Seguridad
     - Datos sensibles, controles
   * - 11
     - Trazabilidad
     - UC, MOD, BR, CNST relacionados
   * - 12
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar un FD, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura FD_[NN]
- [ ] Tipo de flujo especificado
- [ ] Diagrama PlantUML incluido y correcto
- [ ] Fuentes de datos documentadas
- [ ] Destinos de datos documentados
- [ ] Transformaciones secuenciales claras
- [ ] Estructura de datos entrada/salida
- [ ] Errores y manejo documentados
- [ ] Metricas de rendimiento definidas
- [ ] Controles de seguridad especificados

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST y PlantUML
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- UC_*: Casos de uso relacionados
- MOD_*: Modulos involucrados
- BR_*: Business Rules aplicadas
- CNST_*: Restricciones aplicables
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
     - Version inicial de plantilla FD con PlantUML
