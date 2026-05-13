.. meta::
   :artefacto: PROC_Auditoria_Documental
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Trazabilidad
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-auditoria-documental:

==========================================================
PROC_Auditoria_Documental: Auditoria del Modelo Documental
==========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Auditoria_Documental
   * - **Nombre**
     - Auditoria del Modelo Documental
   * - **Categoria**
     - Trazabilidad
   * - **Frecuencia**
     - Mensual o por release
   * - **Duracion**
     - 2-4 horas

----

1. Proposito
------------

Realizar auditoria integral del modelo documental para verificar
consistencia, completitud y adherencia a estandares.

----

2. Alcance
----------

**Aplica A:** Todo el modelo documental IACT.

**No Aplica A:** Codigo fuente, configuracion.

----

3. Areas de Auditoria
---------------------

1. **Estructura:** Carpetas y organizacion
2. **Nomenclatura:** IDs y nombres de archivo
3. **Contenido:** Secciones obligatorias
4. **Trazabilidad:** RTM y referencias
5. **Versionado:** Coherencia de versiones

----

4. Procedimiento
----------------

**Paso 1: Verificar Estructura**

.. code-block:: bash

   # Comparar estructura real vs modelo
   find docs/ -type d | sort > estructura_real.txt
   diff estructura_esperada.txt estructura_real.txt

**Paso 2: Verificar Nomenclatura**

.. code-block:: bash

   # Buscar archivos con nomenclatura incorrecta
   find docs/ -name "*.rst" | grep -v -E "^(BR|UC|FR|TST|PROC|TPL)_"

**Paso 3: Verificar Secciones Obligatorias**

Para cada tipo de artefacto, verificar secciones del TPL:

.. code-block:: bash

   # Verificar que BR tiene seccion Declaracion
   grep -L "Declaracion" reglas_negocio/BR_*.rst

**Paso 4: Verificar Trazabilidad**

Ejecutar PROC_Verificacion_Cobertura y PROC_Identificar_Gaps_Huerfanos.

**Paso 5: Verificar Versionado**

.. code-block:: bash

   # Verificar coherencia version archivo vs meta
   for f in PROC_*.rst; do
     file_ver=$(echo $f | grep -oE "[0-9]+_[0-9]+_[0-9]+")
     meta_ver=$(grep ":version:" $f | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
     # Comparar
   done

**Paso 6: Generar Reporte**

.. code-block:: text

   REPORTE AUDITORIA - 2026-01-07
   
   ESTRUCTURA: OK
   - Carpetas esperadas: 15
   - Carpetas encontradas: 15
   
   NOMENCLATURA: OK
   - Archivos correctos: 150/150
   
   CONTENIDO: 2 HALLAZGOS
   - BR_015: Falta seccion Excepciones
   - UC_030: Falta seccion Historial
   
   TRAZABILIDAD: OK
   - Cobertura UC->FR: 100%
   
   VERSIONADO: OK

**Paso 7: Plan de Remediacion**

Para cada hallazgo, asignar responsable y fecha.

----

5. Artefactos de Salida
-----------------------

- Reporte de auditoria
- Plan de remediacion
- Metricas de calidad

----

6. Verificacion
---------------

- [ ] 5 areas auditadas
- [ ] Hallazgos documentados
- [ ] Plan de remediacion definido

----

7. Referencias
--------------

- PROC_Verificacion_Cobertura
- PROC_Identificar_Gaps_Huerfanos
- STD del proyecto

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
