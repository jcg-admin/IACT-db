.. meta::
   :artefacto: PROC_Generacion_CNST
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-generacion-cnst:

==========================================================
PROC_Generacion_CNST: Generacion de Restricciones Tecnicas
==========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Generacion_CNST
   * - **Nombre**
     - Generacion de Restricciones Tecnicas
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 20-40 minutos por CNST

----

1. Proposito
------------

Generar Restricciones Tecnicas (CNST) que documentan limitaciones
tecnologicas, decisiones de stack y constraints del sistema.

----

2. Alcance
----------

**Aplica A:** Restricciones de tecnologia, infraestructura, integracion.

**No Aplica A:** Reglas de negocio (usar BR).

----

3. Categorias de CNST
---------------------

.. list-table::
   :header-rows: 1

   * - Rango
     - Categoria
     - Ejemplos
   * - 001-003
     - Stack Tecnologico
     - Python, Django, PostgreSQL
   * - 004-006
     - Seguridad
     - JWT, RBAC, DRF
   * - 007-008
     - Integracion
     - APIs externas, formatos
   * - 009-010
     - Infraestructura
     - Docker, Cloud

----

4. Procedimiento
----------------

**Paso 1: Identificar Restriccion**

Documentar constraint tecnico obligatorio.

**Paso 2: Asignar Nomenclatura**

.. code-block:: text

   Formato: CNST_[NNN]
   Archivo: CNST_[NNN]_[Nombre].rst

**Paso 3: Documentar Justificacion**

Por que esta restriccion es necesaria:

- Requisito de cliente
- Decision arquitectonica
- Limitacion tecnica
- Estandar de industria

**Paso 4: Especificar Impacto**

- Componentes afectados
- FR que deben cumplir
- ADR relacionadas

**Paso 5: Definir Verificacion**

Como validar cumplimiento de la restriccion.

**Paso 6: Guardar y Validar**

----

5. Ejemplo CNST
---------------

.. code-block:: text

   CNST_001: Stack Backend Python/Django
   
   Restriccion: El backend DEBE usar Python 3.11+ y Django 5.0+
   
   Justificacion: Estandar corporativo, equipo capacitado
   
   Impacto: Todos los modulos backend
   
   Verificacion: python --version, pip show django

----

6. Artefactos de Salida
-----------------------

- CNST_[NNN]_[Nombre].rst

----

7. Verificacion
---------------

- [ ] Restriccion clara y verificable
- [ ] Justificacion documentada
- [ ] Impacto identificado

----

8. Referencias
--------------

- TPL_CNST
- ADR relacionadas

----

9. Historial
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
