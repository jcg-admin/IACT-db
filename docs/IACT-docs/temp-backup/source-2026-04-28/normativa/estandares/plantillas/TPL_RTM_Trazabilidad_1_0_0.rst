.. meta::
   :artefacto: TPL_RTM
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-rtm:

===================================================
TPL_RTM: Plantilla de Matriz de Trazabilidad v1.0.0
===================================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Matrices de Trazabilidad
de Requisitos (RTM)** en el proyecto IACT. Las RTM aseguran que todos los requisitos
esten cubiertos desde su origen hasta su implementacion y prueba.

**Caracteristicas:**

- Trazabilidad bidireccional (hacia adelante y hacia atras)
- Cobertura de requisitos verificable
- Identificacion de gaps y huerfanos
- Base para analisis de impacto

**Jerarquia de Trazabilidad IACT:**

::

   BReq -> BR -> UC -> FR -> CODE/TST

**Tipos de RTM:**

::

   RTM_BReq_BR   -> BReq a Business Rules
   RTM_BR_UC     -> BR a Casos de Uso
   RTM_UC_FR     -> UC a Requisitos Funcionales
   RTM_FR_TST    -> FR a Casos de Prueba
   RTM_FR_CODE   -> FR a Codigo

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicacion:**

::

   evidencia/trazabilidad/RTM_[Origen]_[Destino].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``RTM_[Origen]_[Destino].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Completar matriz con todos los artefactos
5. Calcular metricas de cobertura
6. Identificar gaps y huerfanos
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   RTM_[Origen]_[Destino]

   Donde:
   - RTM: Prefijo fijo (Requirements Traceability Matrix)
   - [Origen]: Tipo de artefacto origen (BReq, BR, UC, FR)
   - [Destino]: Tipo de artefacto destino (BR, UC, FR, TST, CODE)

**Ejemplos:**

::

   RTM_BReq_BR   -> Trazabilidad de BReq a BR
   RTM_BR_UC     -> Trazabilidad de BR a UC
   RTM_UC_FR     -> Trazabilidad de UC a FR
   RTM_FR_TST    -> Trazabilidad de FR a TST

**Nombre de Archivo:**

::

   RTM_[Origen]_[Destino].rst

   Ejemplos:
   - RTM_BReq_BR.rst
   - RTM_UC_FR.rst
   - RTM_FR_TST.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: RTM_[Origen]_[Destino]
      :tipo: Matriz de Trazabilidad
      :dominio: evidencia
      :subdominio: trazabilidad
      :nivel_origen: [BReq|BR|UC|FR]
      :nivel_destino: [BR|UC|FR|TST|CODE]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _rtm-[origen]-[destino]:

                                                                      
   RTM_[Origen]_[Destino]: Matriz de Trazabilidad [Origen] a [Destino]
                                                                      

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
        - RTM_[Origen]_[Destino]
      * - **Nivel Origen**
        - [BReq|BR|UC|FR]
      * - **Nivel Destino**
        - [BR|UC|FR|TST|CODE]
      * - **Total Origen**
        - [N] artefactos
      * - **Total Destino**
        - [M] artefactos
      * - **Cobertura**
        - [X]%
      * - **Fecha Actualizacion**
        - [YYYY-MM-DD]

   ----

   1. Alcance
   ----------

   1.1 Proposito
   ^^^^^^^^^^^^^

   Esta matriz establece la trazabilidad entre [Origen] y [Destino],
   permitiendo verificar que cada [Origen] tiene al menos un [Destino]
   que lo implementa/verifica.

   1.2 Artefactos Incluidos
   ^^^^^^^^^^^^^^^^^^^^^^^^

   **Origen ([Origen]):**

   - Total: [N] artefactos
   - Rango: [ID_inicial] a [ID_final]

   **Destino ([Destino]):**

   - Total: [M] artefactos
   - Rango: [ID_inicial] a [ID_final]

   ----

   2. Matriz de Trazabilidad
   -------------------------

   .. list-table::
      :widths: 15 35 35 15
      :header-rows: 1

      * - [Origen]
        - Nombre
        - [Destino] Relacionados
        - Cobertura
      * - [ID_001]
        - [Nombre del artefacto origen]
        - [ID_destino_1], [ID_destino_2]
        - Cubierto
      * - [ID_002]
        - [Nombre del artefacto origen]
        - [ID_destino_3]
        - Cubierto
      * - [ID_003]
        - [Nombre del artefacto origen]
        - -
        - SIN COBERTURA
      * - [ID_NNN]
        - [Nombre del artefacto origen]
        - [ID_destino_N], [ID_destino_M]
        - Cubierto

   ----

   3. Matriz Inversa (Destino a Origen)
   ------------------------------------

   .. list-table::
      :widths: 15 35 35 15
      :header-rows: 1

      * - [Destino]
        - Nombre
        - [Origen] Relacionados
        - Estado
      * - [ID_destino_1]
        - [Nombre del artefacto destino]
        - [ID_001]
        - Vinculado
      * - [ID_destino_2]
        - [Nombre del artefacto destino]
        - [ID_001]
        - Vinculado
      * - [ID_destino_X]
        - [Nombre del artefacto destino]
        - -
        - HUERFANO

   ----

   4. Metricas de Cobertura
   ------------------------

   4.1 Cobertura General
   ^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 40 30 30
      :header-rows: 1

      * - Metrica
        - Valor
        - Objetivo
      * - Total [Origen]
        - [N]
        - -
      * - [Origen] con cobertura
        - [X]
        - [N]
      * - [Origen] sin cobertura
        - [Y]
        - 0
      * - **Porcentaje cobertura**
        - **[X/N * 100]%**
        - **100%**

   4.2 Cobertura por Categoria/Modulo
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 25 25 25
      :header-rows: 1

      * - Categoria/Modulo
        - Total
        - Cubiertos
        - Cobertura
      * - [Categoria 1]
        - [N1]
        - [X1]
        - [X1/N1 * 100]%
      * - [Categoria 2]
        - [N2]
        - [X2]
        - [X2/N2 * 100]%
      * - [Categoria N]
        - [Nn]
        - [Xn]
        - [Xn/Nn * 100]%

   ----

   5. Analisis de Gaps
   -------------------

   5.1 Artefactos Origen Sin Cobertura
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - [Origen]
        - Nombre
        - Accion Requerida
      * - [ID_003]
        - [Nombre]
        - [Crear destino / Justificar exclusion]
      * - [ID_007]
        - [Nombre]
        - [Crear destino / Justificar exclusion]

   5.2 Artefactos Destino Huerfanos
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - [Destino]
        - Nombre
        - Accion Requerida
      * - [ID_destino_X]
        - [Nombre]
        - [Vincular a origen / Eliminar]
      * - [ID_destino_Y]
        - [Nombre]
        - [Vincular a origen / Eliminar]

   ----

   6. Exclusiones Justificadas
   ---------------------------

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - [Origen]
        - Nombre
        - Justificacion de Exclusion
      * - [ID_excluido]
        - [Nombre]
        - [Razon por la que no requiere destino]

   ----

   7. Diagrama de Trazabilidad
   ---------------------------

   .. uml::
      :caption: Trazabilidad [Origen] a [Destino]
      :align: center

      @startuml
      skinparam backgroundColor #FAFAFA
      skinparam object {
          BackgroundColor #E3F2FD
          BorderColor #1976D2
      }

      object "[ID_001]" as O1
      object "[ID_002]" as O2
      object "[ID_003]" as O3

      object "[ID_destino_1]" as D1
      object "[ID_destino_2]" as D2
      object "[ID_destino_3]" as D3

      O1 --> D1
      O1 --> D2
      O2 --> D3
      ' O3 sin cobertura

      @enduml

   ----

   8. Plan de Accion
   -----------------

   .. list-table::
      :widths: 10 40 25 25
      :header-rows: 1

      * - #
        - Accion
        - Responsable
        - Fecha Limite
      * - 1
        - [Crear destino para ID_003]
        - [Nombre]
        - [YYYY-MM-DD]
      * - 2
        - [Vincular huerfano ID_destino_X]
        - [Nombre]
        - [YYYY-MM-DD]

   ----

   9. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Nivel Superior**
        - RTM_[NivelAnterior]_[Origen] (si existe)
      * - **Nivel Inferior**
        - RTM_[Destino]_[NivelSiguiente] (si existe)
      * - **PROC Relacionado**
        - PROC_[NNN]: Verificar Cobertura

   ----

   10. Historial de Cambios
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

Cada RTM DEBE incluir minimo estas 10 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, niveles, totales, cobertura
   * - 1
     - Alcance
     - Proposito, artefactos incluidos
   * - 2
     - Matriz de Trazabilidad
     - Origen a destino
   * - 3
     - Matriz Inversa
     - Destino a origen (huerfanos)
   * - 4
     - Metricas de Cobertura
     - General y por categoria
   * - 5
     - Analisis de Gaps
     - Sin cobertura y huerfanos
   * - 6
     - Exclusiones
     - Justificaciones
   * - 7
     - Diagrama
     - PlantUML de trazabilidad
   * - 8
     - Plan de Accion
     - Acciones para cerrar gaps
   * - 9
     - Trazabilidad
     - RTM relacionadas
   * - 10
     - Historial
     - Control de versiones

----

Definiciones
------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Termino
     - Definicion
   * - **Cobertura**
     - Porcentaje de artefactos origen con al menos un destino vinculado
   * - **Gap**
     - Artefacto origen sin ningun destino vinculado
   * - **Huerfano**
     - Artefacto destino sin ningun origen vinculado
   * - **Exclusion**
     - Artefacto origen que justificadamente no requiere destino

----

Validacion
----------

Antes de aprobar una RTM, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura RTM_[Origen]_[Destino]
- [ ] Todos los artefactos origen listados
- [ ] Todos los artefactos destino listados
- [ ] Matriz directa completa
- [ ] Matriz inversa completa
- [ ] Metricas calculadas correctamente
- [ ] Gaps identificados con accion requerida
- [ ] Huerfanos identificados con accion requerida
- [ ] Exclusiones justificadas
- [ ] Plan de accion para cerrar gaps

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- FND_04: Trazabilidad (definicion conceptual)
- PROC_021: Generar RTM
- PROC_022: Verificar Cobertura
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
     - Version inicial de plantilla RTM
