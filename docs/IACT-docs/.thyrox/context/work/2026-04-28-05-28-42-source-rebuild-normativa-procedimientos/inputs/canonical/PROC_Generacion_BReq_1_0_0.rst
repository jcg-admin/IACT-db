.. meta::
   :artefacto: PROC_Generacion_BReq
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-generacion-breq:

========================================================
PROC_Generacion_BReq: Generacion de Objetivos de Negocio
========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Generacion_BReq
   * - **Nombre**
     - Generacion de Objetivos de Negocio
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 30-60 minutos por BReq

----

1. Proposito
------------

Generar Objetivos de Negocio (BReq) que representan las metas de alto
nivel del sistema IACT siguiendo TPL_BReq.

----

2. Alcance
----------

**Aplica A:** Definicion de objetivos estrategicos del sistema.

**No Aplica A:** Requisitos detallados (usar BR, UC, FR).

----

3. Categorias de BReq
---------------------

.. list-table::
   :header-rows: 1

   * - ID
     - Categoria
     - Descripcion
   * - BReq_001-002
     - Funcionalidad Core
     - Dashboard, reportes
   * - BReq_003
     - Rendimiento
     - Tiempos de respuesta
   * - BReq_004
     - Seguridad
     - Cumplimiento normativo
   * - BReq_005-006
     - Usabilidad
     - UX, accesibilidad
   * - BReq_007-008
     - Integracion
     - APIs, datos externos

----

4. Procedimiento
----------------

**Paso 1: Identificar Objetivo**

Definir meta de negocio clara y medible.

**Paso 2: Asignar Nomenclatura**

.. code-block:: text

   Formato: BReq_[NNN]
   Archivo: BReq_[NNN]_[Nombre].rst

**Paso 3: Redactar Declaracion**

.. code-block:: text

   "El sistema DEBE [capacidad] PARA [beneficio de negocio]"
   
   Ejemplo:
   "El sistema DEBE proporcionar dashboards interactivos
   PARA facilitar la toma de decisiones basada en datos"

**Paso 4: Definir Metricas de Exito**

- KPI medible
- Valor objetivo
- Metodo de medicion

**Paso 5: Identificar BR Derivadas**

Listar BR que implementaran el BReq.

**Paso 6: Guardar y Validar**

----

5. Artefactos de Salida
-----------------------

- BReq_[NNN]_[Nombre].rst

----

6. Verificacion
---------------

- [ ] Objetivo claro y medible
- [ ] KPIs definidos
- [ ] BR derivadas identificadas

----

7. Referencias
--------------

- TPL_BReq
- PROC_Derivacion_BReq_BR

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
