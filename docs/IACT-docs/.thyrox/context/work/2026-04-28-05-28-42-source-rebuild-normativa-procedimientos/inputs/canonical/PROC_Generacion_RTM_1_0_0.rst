.. meta::
   :artefacto: PROC_Generacion_RTM
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-generacion-rtm:

===========================================================
PROC_Generacion_RTM: Generacion de Matrices de Trazabilidad
===========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_RTM
   * - **Nombre**
     - Generacion de Matrices de Trazabilidad
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada par de artefactos a trazar
   * - **Duracion Estimada**
     - 30-60 minutos por RTM
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Matrices de Trazabilidad
de Requisitos (RTM) siguiendo el template TPL_RTM.

**Objetivo:** Crear RTM bidireccionales que demuestren cobertura completa
y permitan identificar gaps y huerfanos.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Trazabilidad entre niveles de requisitos
- RTM del proyecto IACT
- Verificacion de cobertura

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Trazabilidad a codigo (usar RTM_FR_CODE)
- Matrices de pruebas ejecutadas

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - QA Lead
     - Genera RTM
     - Lectura de todos los artefactos
   * - Arquitecto
     - Valida completitud
     - Lectura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Artefactos origen y destino generados
- [ ] TPL_RTM revisado
- [ ] Estructura /tmp/trazabilidad/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_RTM_Trazabilidad_1_0_0.rst
     - Template de RTM
     - Si
   * - Artefactos origen
     - Nivel superior (BReq, BR, UC, FR)
     - Si
   * - Artefactos destino
     - Nivel inferior (BR, UC, FR, TST)
     - Si

----

6. Procedimiento
----------------

6.1 RTM del Proyecto IACT
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - RTM
     - Relacion
     - Ratio Esperado
   * - RTM_BReq_BR
     - BReq -> BR
     - 1:2-3
   * - RTM_BR_UC
     - BR -> UC
     - 1:2-3
   * - RTM_UC_FR
     - UC -> FR
     - 1:3-8
   * - RTM_FR_TST
     - FR -> TST
     - 1:1-2
   * - RTM_FR_CODE
     - FR -> Codigo
     - 1:N

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar RTM a Generar**

- **Responsable**: QA Lead
- **Accion**: Determinar par origen-destino:

  .. code-block:: text

     Formato: RTM_[Origen]_[Destino]
     
     Ejemplo: RTM_UC_FR
     - Origen: UC (Casos de Uso)
     - Destino: FR (Requisitos Funcionales)

- **Resultado**: RTM identificada
- **Verificacion**: Par valido segun jerarquia

**Paso 2: Inventariar Artefactos Origen**

- **Responsable**: QA Lead
- **Accion**: Listar todos los artefactos origen:

  .. code-block:: bash

     # Ejemplo para UC
     find casos_uso/ -name "UC_*.rst" | sort
     
     # Resultado
     UC_001, UC_002, ..., UC_073
     Total: 49 UC

- **Resultado**: Lista de origenes
- **Verificacion**: Cantidad correcta

**Paso 3: Inventariar Artefactos Destino**

- **Responsable**: QA Lead
- **Accion**: Listar todos los artefactos destino:

  .. code-block:: bash

     # Ejemplo para FR
     find funcionales/ -name "FR_*.rst" | sort
     
     # Resultado
     FR_UC001_01, FR_UC001_02, ..., FR_UC073_03
     Total: 158 FR

- **Resultado**: Lista de destinos
- **Verificacion**: Cantidad correcta

**Paso 4: Crear Matriz Origen -> Destino**

- **Responsable**: QA Lead
- **Accion**: Mapear cada origen a sus destinos:

  .. code-block:: rst

     .. list-table::
        :header-rows: 1
     
        * - UC Origen
          - FR Derivados
          - Cantidad
        * - UC_001
          - FR_UC001_01, FR_UC001_02, FR_UC001_03, FR_UC001_04, FR_UC001_05
          - 5
        * - UC_002
          - FR_UC002_01, FR_UC002_02, FR_UC002_03
          - 3
        * - ...
          - ...
          - ...

- **Resultado**: Matriz directa
- **Verificacion**: Todos los origenes mapeados

**Paso 5: Crear Matriz Inversa (Destino -> Origen)**

- **Responsable**: QA Lead
- **Accion**: Verificar que cada destino tiene origen:

  .. code-block:: rst

     .. list-table::
        :header-rows: 1
     
        * - FR
          - UC Origen
          - Estado
        * - FR_UC001_01
          - UC_001
          - OK
        * - FR_UC001_02
          - UC_001
          - OK
        * - FR_XXXX_01
          - ???
          - HUERFANO

- **Resultado**: Matriz inversa
- **Verificacion**: Huerfanos identificados

**Paso 6: Calcular Metricas de Cobertura**

- **Responsable**: QA Lead
- **Accion**: Calcular estadisticas:

  .. code-block:: rst

     **Metricas RTM_UC_FR:**
     
     - Total UC: 49
     - UC con FR: 49
     - UC sin FR (gaps): 0
     - Cobertura: 100%
     
     - Total FR: 158
     - FR con UC: 158
     - FR huerfanos: 0
     - Ratio promedio: 3.2 FR/UC

- **Resultado**: Metricas calculadas
- **Verificacion**: Cobertura >= objetivo

**Paso 7: Analizar Gaps y Huerfanos**

- **Responsable**: QA Lead
- **Accion**: Documentar problemas encontrados:

  .. code-block:: rst

     **Analisis de Gaps:**
     
     UC sin FR (requieren derivacion):
     - Ninguno
     
     **Analisis de Huerfanos:**
     
     FR sin UC (posible error):
     - Ninguno
     
     **Exclusiones Justificadas:**
     
     - UC_099: Caso de uso futuro, excluido de RTM

- **Resultado**: Analisis documentado
- **Verificacion**: Gaps/huerfanos explicados

**Paso 8: Generar Diagrama PlantUML**

- **Responsable**: QA Lead
- **Accion**: Crear visualizacion:

  .. code-block:: rst

     .. uml::
     
        @startuml
        left to right direction
        
        package "Casos de Uso" {
          [UC_001]
          [UC_002]
        }
        
        package "Requisitos Funcionales" {
          [FR_UC001_01]
          [FR_UC001_02]
          [FR_UC002_01]
        }
        
        UC_001 --> FR_UC001_01
        UC_001 --> FR_UC001_02
        UC_002 --> FR_UC002_01
        @enduml

- **Resultado**: Diagrama generado
- **Verificacion**: Visualizacion clara

**Paso 9: Guardar y Validar**

- **Responsable**: QA Lead
- **Accion**: Guardar y validar:

  .. code-block:: bash

     # Guardar
     /tmp/trazabilidad/RTM_UC_FR_1_0_0.rst
     
     # Validar
     sphinx-build -b html -W /tmp/trazabilidad/ /tmp/build/

- **Resultado**: RTM guardada y validada
- **Verificacion**: Sin errores Sphinx

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - RTM_[Origen]_[Destino].rst
     - Matriz de Trazabilidad
     - /tmp/trazabilidad/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Matriz directa (origen -> destino) completa
- [ ] Matriz inversa (destino -> origen) completa
- [ ] Metricas de cobertura calculadas
- [ ] Gaps y huerfanos analizados
- [ ] Diagrama PlantUML incluido

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Cobertura >= 95% (objetivo 100%)
- [ ] Todos los gaps justificados
- [ ] Huerfanos = 0 (o justificados)
- [ ] Metricas documentadas
- [ ] Diagrama renderizable

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Cobertura < 95%
     - Generar plan para cerrar gaps
   * - Huerfanos encontrados
     - Investigar origen, corregir o eliminar
   * - Artefactos sin ID
     - Asignar ID antes de incluir

----

11. Referencias
---------------

- TPL_RTM_Trazabilidad_1_0_0.rst
- PROC_Verificacion_Cobertura
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
