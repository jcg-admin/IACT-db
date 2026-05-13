.. meta::
   :artefacto: PROC_Generacion_POL
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-generacion-pol:

============================================
PROC_Generacion_POL: Generacion de Politicas
============================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Generacion_POL
   * - **Nombre**
     - Generacion de Politicas
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 30-60 minutos por POL

----

1. Proposito
------------

Generar Politicas (POL) que establecen directrices de alto nivel
para gobierno del proyecto.

----

2. Alcance
----------

**Aplica A:** Directrices organizacionales y de proyecto.

**No Aplica A:** Procedimientos operativos (usar PROC).

----

3. Diferencia POL vs STD vs PROC
--------------------------------

.. list-table::
   :header-rows: 1

   * - Tipo
     - Nivel
     - Responde a
   * - POL
     - Estrategico
     - Que debemos hacer?
   * - STD
     - Tactico
     - Como debe ser?
   * - PROC
     - Operativo
     - Como se hace?

----

4. Procedimiento
----------------

**Paso 1: Identificar Necesidad**

Definir area que requiere politica.

**Paso 2: Asignar Nomenclatura**

.. code-block:: text

   Formato: POL_[NNN]
   Archivo: POL_[NNN]_[Nombre].rst

**Paso 3: Redactar Declaracion**

Directriz clara y concisa:

.. code-block:: text

   POL_001: Politica de Seguridad
   
   "Todo acceso al sistema IACT debe estar autenticado
   y autorizado segun modelo RBAC definido."

**Paso 4: Definir Alcance**

A quien aplica y en que contexto.

**Paso 5: Documentar Excepciones**

Casos donde no aplica la politica.

**Paso 6: Referenciar STD y PROC**

Estandares y procedimientos que implementan la politica.

**Paso 7: Obtener Aprobacion**

POL requiere aprobacion de nivel directivo.

**Paso 8: Guardar y Validar**

----

5. Artefactos de Salida
-----------------------

- POL_[NNN]_[Nombre].rst

----

6. Verificacion
---------------

- [ ] Directriz clara
- [ ] Alcance definido
- [ ] STD/PROC referenciados
- [ ] Aprobacion obtenida

----

7. Referencias
--------------

- TPL_POL
- STD relacionados
- PROC relacionados

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
