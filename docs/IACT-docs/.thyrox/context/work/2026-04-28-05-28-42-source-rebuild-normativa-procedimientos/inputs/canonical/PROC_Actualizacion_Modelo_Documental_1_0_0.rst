.. meta::
   :artefacto: PROC_Actualizacion_Modelo_Documental
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-actualizacion-modelo-documental:

==================================================================
PROC_Actualizacion_Modelo_Documental: Actualizar Modelo Documental
==================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Actualizacion_Modelo_Documental
   * - **Nombre**
     - Actualizar Modelo Documental IACT
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Por cada cambio significativo
   * - **Duracion Estimada**
     - 30-60 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece como actualizar el documento MODELO_DOCUMENTAL_IACT
cuando se realizan cambios en la estructura, artefactos o metricas del proyecto.

**Objetivo:** Mantener el modelo documental sincronizado con el estado real
del proyecto, aplicando versionado semantico.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Adicion de nuevos artefactos (BR, UC, FR, etc.)
- Cambios en estructura de carpetas
- Actualizacion de metricas
- Cambios en nomenclatura o estandares

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Correcciones menores de typos (no cambia version)
- Cambios en artefactos individuales (tienen su propia version)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Arquitecto Doc
     - Ejecuta actualizacion
     - Escritura en modelo
   * - QA Lead
     - Valida consistencia
     - Lectura de modelo

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Cambios a documentar identificados
- [ ] Version actual del modelo conocida
- [ ] STD_006 (Versionado Semantico) revisado

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - MODELO_DOCUMENTAL_IACT_vX.Y.Z.md
     - Version actual del modelo
     - Si
   * - Lista de cambios
     - Cambios a incorporar
     - Si
   * - STD_006
     - Estandar de versionado
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Actualizacion del Modelo
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Identificar cambios realizados;
   :Determinar tipo de cambio;

   if (Cambio incompatible?) then (si)
       :Incrementar MAJOR;
   elseif (Nueva funcionalidad?) then (si)
       :Incrementar MINOR;
   else (correccion)
       :Incrementar PATCH;
   endif

   :Actualizar seccion correspondiente;
   :Actualizar metricas;
   :Actualizar CHANGELOG;
   :Actualizar fecha y version;
   :Generar nuevo archivo;
   :Validar consistencia;

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar Tipo de Cambio**

- **Responsable**: Arquitecto Doc
- **Accion**: Clasificar cambios segun STD_006:

  .. list-table::
     :widths: 20 40 40
     :header-rows: 1

     * - Tipo
       - Descripcion
       - Incremento
     * - MAJOR
       - Cambio incompatible, reestructuracion
       - X.0.0
     * - MINOR
       - Nueva funcionalidad, nuevos artefactos
       - x.Y.0
     * - PATCH
       - Correccion, actualizacion metricas
       - x.y.Z

- **Resultado**: Tipo de cambio identificado
- **Verificacion**: Clasificacion correcta

**Paso 2: Calcular Nueva Version**

- **Responsable**: Arquitecto Doc
- **Accion**: Aplicar incremento:

  .. code-block:: text

     Version actual: 2.1.1
     
     Si MAJOR: 3.0.0
     Si MINOR: 2.2.0
     Si PATCH: 2.1.2

- **Resultado**: Nueva version calculada
- **Verificacion**: Sigue formato X.Y.Z

**Paso 3: Actualizar Secciones Afectadas**

- **Responsable**: Arquitecto Doc
- **Accion**: Modificar secciones relevantes:

  - Arbol de directorios (si cambio estructura)
  - Inventario de artefactos (si nuevos artefactos)
  - Metricas (siempre actualizar)
  - Estado de subdominios (congelado/descongelado)

- **Resultado**: Secciones actualizadas
- **Verificacion**: Datos correctos

**Paso 4: Actualizar Metricas**

- **Responsable**: Arquitecto Doc
- **Accion**: Recalcular contadores:

  .. code-block:: text

     Metricas v2.1.2:
     - BReq: 8
     - BR: 20 (sin cambio)
     - UC: 49 (sin cambio)
     - FR: 55 -> 75 (+20)
     - TST: 0
     - PROC: 3 -> 11 (+8)
     - TPL: 6 -> 17 (+11)

- **Resultado**: Metricas actualizadas
- **Verificacion**: Totales correctos

**Paso 5: Actualizar CHANGELOG**

- **Responsable**: Arquitecto Doc
- **Accion**: Agregar entrada al historial:

  .. code-block:: markdown

     ## CHANGELOG
     
.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - v2.1.2
     - 2026-01-07
     - +8 PROC FASE 1, +11 TPL
   * - v2.1.1
     - 2026-01-07
     - +10 BR, STD_006
   * - v2.1.0
     - 2026-01-06
     - Modelo base

- **Resultado**: CHANGELOG actualizado
- **Verificacion**: Entrada agregada

**Paso 6: Generar Nuevo Archivo**

- **Responsable**: Arquitecto Doc
- **Accion**: Crear archivo con nueva version:

  .. code-block:: bash

     # Nombre del archivo
     MODELO_DOCUMENTAL_IACT_v2_1_2.md
     
     # Guardar en /tmp primero
     /tmp/MODELO_DOCUMENTAL_IACT_v2_1_2.md

- **Resultado**: Archivo generado
- **Verificacion**: Archivo existe

**Paso 7: Validar Consistencia**

- **Responsable**: QA Lead
- **Accion**: Verificar:

  - Totales de metricas cuadran
  - Arbol refleja estructura real
  - CHANGELOG completo
  - Version correcta en header

- **Resultado**: Modelo validado
- **Verificacion**: Sin inconsistencias

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - MODELO_DOCUMENTAL_IACT_vX_Y_Z.md
     - Modelo actualizado
     - /mnt/user-data/outputs/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Nueva version del modelo generada
- [ ] Metricas actualizadas
- [ ] CHANGELOG con entrada nueva
- [ ] Archivo disponible en outputs

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Version sigue formato X.Y.Z
- [ ] Incremento correcto segun tipo de cambio
- [ ] Metricas consistentes con artefactos reales
- [ ] CHANGELOG incluye todos los cambios

9.2 Checklist de Secciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Header con version y fecha
- [ ] Arbol de directorios
- [ ] Inventario de artefactos
- [ ] Metricas actualizadas
- [ ] Estado de subdominios
- [ ] CHANGELOG

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Metricas no cuadran
     - Recontar artefactos reales
   * - Version duplicada
     - Incrementar PATCH adicional
   * - Cambios multiples categorias
     - Usar incremento mayor

----

11. Referencias
---------------

- STD_006: Versionado Semantico
- MODELO_DOCUMENTAL_IACT (version actual)

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
     - 2026-01-07
     - Equipo IACT
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
