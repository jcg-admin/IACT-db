.. meta::
   :artefacto: PROC_Revision_Artefactos
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
   :anterior: PROC_002_Revision_Artefactos

.. _proc-revision-artefactos:

================================================
PROC_Revision_Artefactos: Revision de Artefactos
================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Revision_Artefactos
   * - **Nombre**
     - Revision de Artefactos del Modelo Documental
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Por cada artefacto generado
   * - **Duracion Estimada**
     - 10-30 minutos por artefacto
   * - **Estado**
     - Vigente
   * - **Nota**
     - Renombrado desde PROC_002_Revision_Artefactos

----

1. Proposito
------------

Este procedimiento establece el proceso de revision de calidad para
artefactos del modelo documental antes de su aprobacion.

**Objetivo:** Garantizar que los artefactos cumplen con templates,
estandares y son tecnicamente correctos.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Todos los artefactos nuevos
- Artefactos modificados significativamente
- Artefactos para congelamiento

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Correcciones menores de formato
- Archivos de analisis temporales

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Autor
     - Genera artefacto, solicita revision
     - Escritura en artefacto
   * - Revisor
     - Ejecuta revision, reporta hallazgos
     - Lectura de artefactos
   * - Aprobador
     - Aprueba artefacto revisado
     - Aprobacion

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Artefacto generado y disponible
- [ ] Template correspondiente identificado
- [ ] Revisor asignado (diferente al autor)

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Artefacto a revisar
     - Documento generado
     - Si
   * - TPL correspondiente
     - Template de referencia
     - Si
   * - Checklist de revision
     - Criterios a verificar
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Revision
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Recibir artefacto;
   :Verificar estructura vs TPL;
   :Verificar contenido;
   :Verificar nomenclatura;
   :Verificar trazabilidad;
   :Ejecutar validacion Sphinx;

   if (Hallazgos criticos?) then (si)
       :Documentar hallazgos;
       :Devolver al autor;
       stop
   else (no)
       if (Hallazgos menores?) then (si)
           :Documentar observaciones;
       endif
       :Aprobar revision;
       :Enviar a aprobacion final;
   endif

   stop
   @enduml

6.2 Checklist de Revision
^^^^^^^^^^^^^^^^^^^^^^^^^

**Estructura (vs Template):**

- [ ] Todas las secciones obligatorias presentes
- [ ] Orden de secciones correcto
- [ ] Meta tags completos

**Contenido:**

- [ ] Descripcion clara y completa
- [ ] Sin ambiguedades
- [ ] Tecnica y gramaticalmente correcto

**Nomenclatura:**

- [ ] ID sigue formato del tipo de artefacto
- [ ] Nombre de archivo correcto
- [ ] Version en formato X.Y.Z (si aplica)

**Trazabilidad:**

- [ ] Referencias a artefactos padre existen
- [ ] Referencias a artefactos relacionados validas
- [ ] Seccion de trazabilidad completa

**Tecnico:**

- [ ] Validacion Sphinx sin errores
- [ ] Diagramas PlantUML renderizables
- [ ] Links internos funcionan

6.3 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Verificar Estructura**

- **Responsable**: Revisor
- **Accion**: Comparar artefacto contra TPL:

  .. code-block:: text

     Verificar presencia de:
     - Meta tags
     - Titulo
     - Todas las secciones del TPL
     - Historial de cambios

- **Resultado**: Lista de secciones faltantes (si hay)
- **Verificacion**: Checklist de estructura

**Paso 2: Verificar Contenido**

- **Responsable**: Revisor
- **Accion**: Revisar calidad del contenido:

  - Claridad de redaccion
  - Completitud de informacion
  - Precision tecnica
  - Consistencia con otros artefactos

- **Resultado**: Observaciones de contenido
- **Verificacion**: Sin ambiguedades

**Paso 3: Verificar Nomenclatura**

- **Responsable**: Revisor
- **Accion**: Validar IDs y nombres:

  .. code-block:: bash

     # Verificar ID en meta tag
     grep ":artefacto:" [archivo]
     
     # Verificar nombre archivo
     ls -la [archivo]

- **Resultado**: Nomenclatura correcta
- **Verificacion**: Formato valido

**Paso 4: Verificar Trazabilidad**

- **Responsable**: Revisor
- **Accion**: Validar referencias:

  - Artefacto padre existe
  - Artefactos relacionados existen
  - Bidireccionalidad de referencias

- **Resultado**: Trazabilidad consistente
- **Verificacion**: Sin referencias rotas

**Paso 5: Validacion Tecnica**

- **Responsable**: Revisor
- **Accion**: Ejecutar validacion:

  .. code-block:: bash

     sphinx-build -b html -W docs/ docs/_build/

- **Resultado**: Build exitoso
- **Verificacion**: Sin errores ni warnings

**Paso 6: Documentar Resultado**

- **Responsable**: Revisor
- **Accion**: Registrar resultado de revision:

  .. code-block:: text

     REVISION: [ID artefacto]
     Fecha: YYYY-MM-DD
     Revisor: [Nombre]
     Resultado: Aprobado / Rechazado / Con observaciones
     Hallazgos: [Lista]

- **Resultado**: Revision documentada
- **Verificacion**: Registro completo

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Reporte de revision
     - Resultado y hallazgos
     - Registro de revisiones
   * - Artefacto revisado
     - Corregido si hubo hallazgos
     - Ubicacion original

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Revision documentada
- [ ] Hallazgos comunicados al autor
- [ ] Artefacto listo para aprobacion (si paso)

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aprobacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Sin hallazgos criticos
- [ ] Hallazgos menores documentados
- [ ] Validacion Sphinx exitosa

9.2 Tipos de Hallazgos
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Tipo
     - Descripcion
     - Accion
   * - Critico
     - Bloquea aprobacion
     - Corregir y re-revisar
   * - Mayor
     - Importante pero no bloqueante
     - Corregir antes de congelar
   * - Menor
     - Observacion
     - Corregir cuando sea posible

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Revisor no disponible
     - Asignar revisor alternativo
   * - Desacuerdo autor-revisor
     - Escalar a Arquitecto Doc

----

11. Referencias
---------------

- TPL correspondiente al tipo de artefacto
- PROC_Aprobacion_Documentos
- STD_005: Estilo de Documentacion Sphinx

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
     - Renombrado desde PROC_002, nueva nomenclatura

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
