.. meta::
   :artefacto: PROC_Derivacion_BReq_BR
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Derivacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-derivacion-breq-br:

====================================================================
PROC_Derivacion_BReq_BR: Derivacion de Objetivos a Reglas de Negocio
====================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Derivacion_BReq_BR
   * - **Nombre**
     - Derivacion de BReq a BR
   * - **Categoria**
     - Derivacion
   * - **Ratio Esperado**
     - 1 BReq -> 2-3 BR
   * - **Duracion**
     - 1-2 horas por BReq

----

1. Proposito
------------

Derivar Reglas de Negocio (BR) desde Objetivos de Negocio (BReq),
garantizando trazabilidad completa y cobertura de requisitos.

----

2. Alcance
----------

**Aplica A:** Derivacion sistematica BReq -> BR.

**No Aplica A:** Creacion de BR sin BReq padre.

----

3. Jerarquia de Derivacion
--------------------------

::

   BReq (Objetivo de Negocio)
     └── BR (Regla de Negocio)
           └── UC (Caso de Uso)
                 └── FR (Requisito Funcional)

----

4. Procedimiento
----------------

**Paso 1: Seleccionar BReq**

Identificar BReq a derivar del catalogo.

**Paso 2: Analizar Requisitos del BReq**

Extraer requisitos implicitos:

- Que restricciones impone?
- Que validaciones requiere?
- Que procesos define?
- Que autorizaciones necesita?

**Paso 3: Identificar BR Candidatas**

Por cada requisito implicito, crear BR candidata:

.. code-block:: text

   BReq_004: Cumplimiento de Seguridad
   
   BR derivadas:
   - BR_005: Sesion Unica (restriccion)
   - BR_008: Auditoria Accesos (proceso)
   - BR_015: Bloqueo Intentos (restriccion)

**Paso 4: Generar BR**

Ejecutar PROC_Generacion_BR por cada BR identificada.

**Paso 5: Verificar Cobertura**

Confirmar que BReq tiene BR derivadas suficientes.

**Paso 6: Actualizar Trazabilidad**

En cada BR, documentar BReq origen.

----

5. Matriz de Derivacion
-----------------------

.. list-table::
   :header-rows: 1

   * - BReq
     - BR Derivadas
     - Cantidad
   * - BReq_001
     - BR_001, BR_002
     - 2
   * - BReq_002
     - BR_003, BR_004, BR_005
     - 3
   * - BReq_004
     - BR_005, BR_008, BR_015
     - 3

----

6. Artefactos de Salida
-----------------------

- BR_[NNN].rst generadas
- RTM_BReq_BR actualizada

----

7. Verificacion
---------------

- [ ] Cada BReq tiene minimo 1 BR
- [ ] Ratio BReq:BR entre 1:2 y 1:4
- [ ] Trazabilidad bidireccional

----

8. Referencias
--------------

- PROC_Generacion_BR
- PROC_Generacion_RTM
- TPL_BR

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
