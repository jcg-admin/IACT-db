.. meta::
   :artefacto: PROC_Verificacion_Cobertura
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Trazabilidad
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-verificacion-cobertura:

====================================================================
PROC_Verificacion_Cobertura: Verificacion de Cobertura de Requisitos
====================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Verificacion_Cobertura
   * - **Nombre**
     - Verificacion de Cobertura de Requisitos
   * - **Categoria**
     - Trazabilidad
   * - **Frecuencia**
     - Semanal o por milestone
   * - **Duracion**
     - 30-60 minutos

----

1. Proposito
------------

Verificar que los requisitos tienen cobertura adecuada en los niveles
inferiores de la jerarquia (derivacion) y superiores (trazabilidad).

----

2. Alcance
----------

**Aplica A:** Todas las RTM del proyecto.

**No Aplica A:** Artefactos individuales.

----

3. Metricas de Cobertura
------------------------

.. list-table::
   :header-rows: 1

   * - RTM
     - Objetivo
     - Minimo Aceptable
   * - BReq -> BR
     - 100%
     - 95%
   * - BR -> UC
     - 100%
     - 95%
   * - UC -> FR
     - 100%
     - 100%
   * - FR -> TST
     - 100%
     - 90%
   * - FR -> CODE
     - 100%
     - 80%

----

4. Procedimiento
----------------

**Paso 1: Obtener RTM Actuales**

Localizar todas las RTM generadas.

**Paso 2: Calcular Cobertura por RTM**

.. code-block:: text

   Cobertura = (Origen con Destino / Total Origen) * 100
   
   Ejemplo RTM_UC_FR:
   - Total UC: 49
   - UC con FR: 49
   - Cobertura: 100%

**Paso 3: Identificar Gaps**

Listar artefactos origen sin destino:

.. code-block:: text

   Gaps RTM_FR_TST:
   - FR_UC050_01: Sin TST
   - FR_UC050_02: Sin TST
   
   Total gaps: 2 de 158 (1.3%)

**Paso 4: Identificar Huerfanos**

Listar artefactos destino sin origen:

.. code-block:: text

   Huerfanos:
   - Ninguno identificado

**Paso 5: Generar Reporte**

.. code-block:: text

   REPORTE DE COBERTURA - 2026-01-07
   
.. list-table::
   :header-rows: 1

   * - RTM
     - Cobertura
     - Gaps
     - Estado
   * - BReq_BR
     - 100%
     - 0
     - OK
   * - BR_UC
     - 100%
     - 0
     - OK
   * - UC_FR
     - 100%
     - 0
     - OK
   * - FR_TST
     - 98.7%
     - 2
     - REVISAR

**Paso 6: Plan de Accion**

Para cada gap, definir accion:

- Generar artefacto faltante
- Justificar exclusion
- Escalar si es bloqueante

----

5. Artefactos de Salida
-----------------------

- Reporte de cobertura
- Lista de gaps con plan de accion

----

6. Verificacion
---------------

- [ ] Todas las RTM evaluadas
- [ ] Cobertura >= minimo aceptable
- [ ] Gaps tienen plan de accion
- [ ] Huerfanos = 0 o justificados

----

7. Referencias
--------------

- PROC_Generacion_RTM
- PROC_Identificar_Gaps_Huerfanos

----

8. Historial
------------

.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT*
