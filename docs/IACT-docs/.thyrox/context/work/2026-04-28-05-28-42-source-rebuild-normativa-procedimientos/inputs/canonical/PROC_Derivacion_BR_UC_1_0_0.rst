.. meta::
   :artefacto: PROC_Derivacion_BR_UC
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Derivacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-derivacion-br-uc:

=====================================================================
PROC_Derivacion_BR_UC: Derivacion de Reglas de Negocio a Casos de Uso
=====================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Derivacion_BR_UC
   * - **Nombre**
     - Derivacion de BR a UC
   * - **Categoria**
     - Derivacion
   * - **Ratio Esperado**
     - 1 BR -> 2-3 UC
   * - **Duracion**
     - 1-2 horas por modulo

----

1. Proposito
------------

Derivar Casos de Uso (UC) desde Reglas de Negocio (BR),
identificando las interacciones necesarias para implementar cada BR.

----

2. Alcance
----------

**Aplica A:** Derivacion sistematica BR -> UC por modulo.

**No Aplica A:** UC sin BR relacionada (casos especiales documentar).

----

3. Metodologia de Derivacion
----------------------------

Para cada BR, identificar:

1. **Quien** necesita interactuar (Actor)
2. **Que** accion realiza (Verbo)
3. **Para que** proposito (Objetivo)

Cada combinacion Actor-Accion-Objetivo = 1 UC candidato.

----

4. Procedimiento
----------------

**Paso 1: Agrupar BR por Modulo**

.. code-block:: text

   MOD_Auth:
   - BR_005: Sesion Unica
   - BR_008: Auditoria Accesos
   - BR_015: Bloqueo Intentos

**Paso 2: Analizar Cada BR**

Extraer interacciones necesarias:

.. code-block:: text

   BR_005: Sesion Unica
   
   Interacciones:
   - Usuario inicia sesion -> UC_001
   - Usuario cierra sesion -> UC_002
   - Admin gestiona sesiones -> UC_005

**Paso 3: Identificar UC Candidatos**

Consolidar interacciones en UC:

.. code-block:: text

   UC identificados para MOD_Auth:
   - UC_001: Iniciar Sesion
   - UC_002: Cerrar Sesion
   - UC_003: Recuperar Password
   - UC_004: Cambiar Password
   - UC_005: Gestionar Sesiones

**Paso 4: Generar UC**

Ejecutar PROC_Generacion_UC por cada UC.

**Paso 5: Vincular BR en UC**

En seccion "Reglas de Negocio" del UC, listar BR aplicables.

**Paso 6: Verificar Cobertura**

Cada BR debe tener al menos 1 UC que la implemente.

----

5. Matriz de Derivacion
-----------------------

.. list-table::
   :header-rows: 1

   * - BR
     - UC que Aplican
     - Cantidad
   * - BR_005
     - UC_001, UC_002, UC_005
     - 3
   * - BR_008
     - UC_001, UC_002, UC_060
     - 3
   * - BR_015
     - UC_001
     - 1

----

6. Artefactos de Salida
-----------------------

- UC_[NNN].rst generados
- RTM_BR_UC actualizada

----

7. Verificacion
---------------

- [ ] Cada BR tiene minimo 1 UC
- [ ] UC agrupados por modulo
- [ ] Trazabilidad BR <-> UC completa

----

8. Referencias
--------------

- PROC_Generacion_UC
- PROC_Generacion_RTM
- TPL_UC

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
