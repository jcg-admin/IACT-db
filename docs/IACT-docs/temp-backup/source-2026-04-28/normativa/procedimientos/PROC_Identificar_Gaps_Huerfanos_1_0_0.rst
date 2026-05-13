.. meta::
   :artefacto: PROC_Identificar_Gaps_Huerfanos
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Trazabilidad
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-identificar-gaps-huerfanos:

=============================================================
PROC_Identificar_Gaps_Huerfanos: Identificar Gaps y Huerfanos
=============================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Identificar_Gaps_Huerfanos
   * - **Nombre**
     - Identificar Gaps y Huerfanos en Trazabilidad
   * - **Categoria**
     - Trazabilidad
   * - **Frecuencia**
     - Con cada RTM
   * - **Duracion**
     - 15-30 minutos

----

1. Proposito
------------

Identificar artefactos sin cobertura (gaps) y artefactos sin origen
(huerfanos) para mantener integridad del modelo documental.

----

2. Definiciones
---------------

**Gap:** Artefacto origen que no tiene artefacto destino derivado.

- Ejemplo: UC sin FR derivados

**Huerfano:** Artefacto destino que no tiene artefacto origen.

- Ejemplo: FR sin UC padre

----

3. Procedimiento
----------------

**Paso 1: Inventariar Origenes**

.. code-block:: bash

   # Listar todos los UC
   find casos_uso/ -name "UC_*.rst" | wc -l
   # Resultado: 49

**Paso 2: Inventariar Destinos**

.. code-block:: bash

   # Listar todos los FR
   find funcionales/ -name "FR_*.rst" | wc -l
   # Resultado: 158

**Paso 3: Verificar Cobertura Origen -> Destino**

Para cada origen, verificar que tiene destino:

.. code-block:: text

   UC_001 -> FR_UC001_01, FR_UC001_02, ... [OK]
   UC_002 -> FR_UC002_01, FR_UC002_02, ... [OK]
   UC_099 -> ??? [GAP]

**Paso 4: Verificar Trazabilidad Destino -> Origen**

Para cada destino, verificar que tiene origen:

.. code-block:: text

   FR_UC001_01 -> UC_001 [OK]
   FR_UC001_02 -> UC_001 [OK]
   FR_XXXX_01 -> ??? [HUERFANO]

**Paso 5: Documentar Hallazgos**

.. code-block:: text

   GAPS IDENTIFICADOS:
   - UC_099: Sin FR derivados (futuro)
   
   HUERFANOS IDENTIFICADOS:
   - Ninguno
   
   EXCLUSIONES JUSTIFICADAS:
   - UC_099: Caso de uso para fase 2

**Paso 6: Definir Acciones**

Para cada gap/huerfano:

- Generar artefacto faltante
- Eliminar huerfano
- Justificar exclusion

----

4. Comandos de Verificacion
---------------------------

.. code-block:: bash

   # Buscar UC sin FR en trazabilidad
   for uc in $(find casos_uso/ -name "UC_*.rst"); do
     id=$(basename $uc .rst | cut -d'_' -f2)
     count=$(find funcionales/ -name "FR_UC${id}_*.rst" | wc -l)
     if [ $count -eq 0 ]; then
       echo "GAP: $uc"
     fi
   done

----

5. Artefactos de Salida
-----------------------

- Lista de gaps
- Lista de huerfanos
- Exclusiones justificadas

----

6. Verificacion
---------------

- [ ] Todos los origenes verificados
- [ ] Todos los destinos verificados
- [ ] Gaps tienen plan de accion
- [ ] Huerfanos resueltos o eliminados

----

7. Referencias
--------------

- PROC_Generacion_RTM
- PROC_Verificacion_Cobertura

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
