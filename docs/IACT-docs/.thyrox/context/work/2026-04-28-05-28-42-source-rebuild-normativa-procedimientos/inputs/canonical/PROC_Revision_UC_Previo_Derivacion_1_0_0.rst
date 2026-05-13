.. meta::
   :artefacto: PROC_Revision_UC_Previo_Derivacion
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Preparacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-revision-uc-previo-derivacion:

======================================================================
PROC_Revision_UC_Previo_Derivacion: Revision de UC Previo a Derivacion
======================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Revision_UC_Previo_Derivacion
   * - **Nombre**
     - Revision de Casos de Uso Previo a Derivacion de FR
   * - **Categoria**
     - Preparacion
   * - **Frecuencia**
     - Antes de cada sesion de derivacion FR
   * - **Duracion Estimada**
     - 15-30 minutos por modulo
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para revisar y analizar los Casos de Uso (UC)
antes de derivar Requisitos Funcionales (FR). Garantiza que se extrae toda la
informacion necesaria del UC para generar FR completos y trazables.

**Objetivo:** Asegurar que el proceso de derivacion UC -> FR se realiza con
informacion completa y verificada.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Derivacion de FR desde UC existentes
- Sesiones de generacion masiva de FR por modulo
- Verificacion de informacion antes de crear artefactos

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Creacion de UC nuevos (usar PROC_Generacion_UC)
- Modificacion de UC existentes (usar PROC_Cambio_Requisitos)
- Derivacion de otros artefactos (BR, TST)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Analista
     - Ejecuta la revision y extrae informacion
     - Lectura de UC
   * - Arquitecto
     - Valida consistencia con BR y CNST
     - Lectura de BR, CNST

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] UC del modulo estan generados y aprobados
- [ ] Acceso a carpeta casos_uso/[modulo]/
- [ ] Lista de UC a revisar identificada
- [ ] BR y CNST relacionadas disponibles para consulta

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - UC_[NNN]_[Nombre].rst
     - Caso de Uso a revisar
     - Si
   * - BR_[NNN].rst
     - Reglas de negocio referenciadas
     - Si
   * - CNST_[NNN].rst
     - Restricciones referenciadas
     - No
   * - TPL_FR
     - Template de FR (para conocer campos requeridos)
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Revision de UC
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

   :Listar UC del modulo;

   :Abrir primer UC;

   repeat
       :Extraer seccion Resumen;
       :Extraer Flujo Normal;
       :Identificar pasos del Sistema;
       :Extraer Flujos Alternos;
       :Extraer Excepciones;
       :Extraer BR aplicables;
       :Extraer FR Derivados (seccion Trazabilidad);
       :Registrar informacion en documento de trabajo;

       if (Mas UC pendientes?) then (si)
           :Abrir siguiente UC;
       else (no)
       endif
   repeat while (Mas UC?) is (si)

   :Consolidar lista de FR a generar;
   :Verificar nomenclatura FR;
   :Calcular total FR por UC;

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Listar UC del Modulo**

- **Responsable**: Analista
- **Accion**: Ejecutar comando para listar UC del modulo a procesar

  .. code-block:: bash

     find /ruta/casos_uso/[modulo] -name "UC_*.rst" | sort

- **Resultado**: Lista ordenada de UC a revisar
- **Verificacion**: Contar UC coincide con inventario del modulo

**Paso 2: Abrir y Analizar UC**

- **Responsable**: Analista
- **Accion**: Para cada UC, abrir archivo y extraer:

  1. **Seccion Resumen**: ID, Nombre, Actor, Modulo, Prioridad
  2. **Seccion Flujo Normal**: Identificar pasos que inician con "Sistema..."
  3. **Seccion Flujos Alternos**: Identificar variaciones
  4. **Seccion Excepciones**: Identificar manejo de errores
  5. **Seccion Reglas de Negocio**: BR aplicables
  6. **Seccion Trazabilidad**: FR Derivados ya identificados

- **Resultado**: Informacion extraida por UC
- **Verificacion**: Todas las secciones revisadas

**Paso 3: Identificar Pasos del Sistema**

- **Responsable**: Analista
- **Accion**: Del Flujo Normal, extraer SOLO pasos que comienzan con "Sistema":

  .. code-block:: text

     Ejemplo UC_001:
     - Paso 5: Sistema valida formato de campos -> FR-001.01
     - Paso 6: Sistema verifica credenciales -> FR-001.02
     - Paso 7: Sistema invalida sesiones previas -> FR-001.04
     - Paso 8: Sistema genera token JWT -> FR-001.03
     - Paso 9: Sistema registra evento auditoria -> FR-001.05

- **Resultado**: Lista de acciones del sistema = FR candidatos
- **Verificacion**: Cada paso del sistema tiene FR asociado

**Paso 4: Extraer FR de Seccion Trazabilidad**

- **Responsable**: Analista
- **Accion**: Localizar seccion "FR Derivados" en el UC y extraer lista:

  .. code-block:: text

     **FR Derivados:**
     - FR-001.01: Validar formato username
     - FR-001.02: Validar credenciales
     - FR-001.03: Generar token JWT

- **Resultado**: Lista oficial de FR a generar
- **Verificacion**: Nomenclatura sigue patron FR-NNN.NN

**Paso 5: Registrar BR y CNST Aplicables**

- **Responsable**: Analista
- **Accion**: De seccion "Reglas de Negocio", extraer BR referenciadas:

  .. code-block:: text

     BR aplicables a este UC:
     - BR_005: Sesion Unica
     - BR_008: Auditoria Accesos
     - BR_015: Bloqueo Intentos

- **Resultado**: Lista de BR para incluir en cada FR
- **Verificacion**: BR existen en catalogo

**Paso 6: Consolidar Informacion**

- **Responsable**: Analista
- **Accion**: Crear documento de trabajo con:

  - Total UC revisados
  - Total FR identificados
  - FR por UC (ratio)
  - BR aplicables por FR
  - CNST aplicables

- **Resultado**: Documento de trabajo para derivacion
- **Verificacion**: Totales cuadran con inventario

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Documento de trabajo
     - Lista de FR a generar con informacion extraida
     - /tmp/ o notas
   * - Lista de FR por UC
     - Inventario FR-NNN.NN por cada UC
     - Documento de trabajo

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Todos los UC del modulo han sido revisados
- [ ] Lista completa de FR a generar disponible
- [ ] BR y CNST por FR identificadas
- [ ] Nomenclatura FR verificada (FR-NNN.NN)
- [ ] Informacion suficiente para ejecutar PROC_Derivacion_UC_FR

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Cada UC tiene al menos 1 FR derivado
- [ ] Nomenclatura FR es consistente (FR-NNN.NN)
- [ ] BR referenciadas existen en catalogo
- [ ] Total FR coincide con seccion Trazabilidad de UC

9.2 Comando de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Contar FR derivados en UC
   grep -h "FR-[0-9]" casos_uso/[modulo]/UC_*.rst | wc -l

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - UC sin seccion Trazabilidad
     - Derivar FR desde pasos del sistema en Flujo Normal
   * - BR referenciada no existe
     - Reportar gap, continuar con otras BR
   * - Nomenclatura FR inconsistente
     - Corregir antes de proceder con derivacion

----

11. Referencias
---------------

- TPL_UC: Estructura de Casos de Uso
- TPL_FR: Template de Requisitos Funcionales
- PROC_Derivacion_UC_FR: Procedimiento de derivacion
- FND_04: Trazabilidad

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
