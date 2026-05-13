
3.4 Ejemplo de Cadena Completa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CADENA: BR_007 (SoD) → UC-043 → FR-043.x

   BR_007: Separacion de Funciones SoD
     │
     │ influye
     v
   BReq-004: Cumplimiento de Seguridad
     │
     │ genera
     v
   UC-043: Configurar SoD
     │
     │ deriva
     ├──→ FR-043.1: Sistema DEBE mostrar lista de restricciones SoD
     ├──→ FR-043.2: Sistema DEBE validar conflictos al crear SoD
     ├──→ FR-043.3: Sistema DEBE impedir asignacion que viole SoD
     ├──→ FR-043.4: Sistema DEBE registrar en auditoria cambios SoD
     └──→ FR-043.5: Sistema DEBE notificar al admin de seguridad
           │
           │ implementa
           v
         apps/access/sod.py
           │
           │ verifica
           v
         TST_Access_SoD_001 a TST_Access_SoD_005

----

4. Metricas de Cobertura
------------------------

4.1 Definicion de Metricas
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 15 60

   * - Metrica
     - Umbral
     - Formula
   * - **Cobertura BReq→UC**
     - 100%
     - (BReq con UC derivados / Total BReq) × 100
   * - **Cobertura BR→UC**
     - 100%
     - (BR con impacto en UC / Total BR aplicables) × 100
   * - **Cobertura UC→FR**
     - 100%
     - (UC con FR derivados / Total UC) × 100
   * - **Cobertura FR→CODE**
     - 90%
     - (FR implementados / Total FR) × 100
   * - **Cobertura FR→TEST**
     - 80%
     - (FR con tests / Total FR) × 100

4.2 Estado Actual IACT
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   METRICA                 VALOR      ESTADO
   ───────────────────────────────────────────────
   BReq identificados        5        ✅ Completo
   BR identificadas         20        ✅ Completo
   UC identificados         49        ✅ Completo
   FR derivados              0        ❌ Pendiente
   
   Cobertura BReq→UC       100%       ✅ Verificado
   Cobertura BR→UC           -        ⏳ Pendiente RTM
   Cobertura UC→FR          0%        ❌ Pendiente derivar
   Cobertura FR→CODE        0%        ❌ Pendiente implementar
   Cobertura FR→TEST        0%        ❌ Pendiente

4.3 Interpretacion de Metricas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   COBERTURA 100%:
     Todos los artefactos origen tienen al menos un derivado.
     NO significa que esten completos, solo que tienen enlace.

   COBERTURA < 100%:
     Existen artefactos sin derivados documentados.
     Requiere accion: derivar o justificar exclusion.

   COBERTURA > 100%:
     Error de calculo o artefactos duplicados.
     Requiere revision de la RTM.

----

5. Herramientas de Trazabilidad en IACT
---------------------------------------

5.1 Sphinx Cross-References
^^^^^^^^^^^^^^^^^^^^^^^^^^^

IACT utiliza el sistema de referencias cruzadas de Sphinx para mantener
trazabilidad dentro de la documentacion.

.. code-block:: rst

   En BR_007_Separacion_Funciones_SoD.rst:
   
   .. _br-007:

   Trazabilidad
   ------------
   - Influye en: :ref:`breq-004`
   - UC Relacionados: :ref:`uc-043`
   - FR Derivados: FR-043.1 a FR-043.5


   En UC_043_Configurar_SoD.rst:

   .. _uc-043:

   Trazabilidad
   ------------
   - Origen BR: :ref:`br-007`
   - BReq: :ref:`breq-004`
   - FR Derivados: FR-043.1 a FR-043.5

5.2 Etiquetas de Metadata
^^^^^^^^^^^^^^^^^^^^^^^^^

Cada artefacto incluye metadata que facilita trazabilidad:

.. code-block:: rst

   .. meta::
      :artefacto: UC_043
      :origen_br: BR_007
      :origen_breq: BReq-004
      :fr_derivados: FR-043.1, FR-043.2, FR-043.3, FR-043.4, FR-043.5
      :modulo: MOD_Access

5.3 Seccion de Trazabilidad Estandar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo artefacto de requisitos DEBE incluir una seccion de trazabilidad:

.. code-block:: rst

   ----

   Trazabilidad
   ------------

   Origen
   ^^^^^^
   - Business Rule: BR_007 (Separacion de Funciones SoD)
   - Business Requirement: BReq-004 (Cumplimiento Seguridad)

   Derivados
   ^^^^^^^^^
   - FR-043.1: Mostrar lista restricciones SoD
   - FR-043.2: Validar conflictos
   - FR-043.3: Impedir asignacion violatoria
   - FR-043.4: Registrar en auditoria
   - FR-043.5: Notificar admin seguridad

   Implementacion
   ^^^^^^^^^^^^^^
   - Modulo: MOD_Access
   - Codigo: apps/access/sod.py
   - Tests: TST_Access_SoD_*

----

6. Proceso de Mantenimiento de Trazabilidad
-------------------------------------------

6.1 Al Crear Nuevo Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Identificar ORIGEN (de donde viene)
   2. Documentar enlace en seccion Trazabilidad
   3. Actualizar artefacto origen con nuevo derivado
   4. Actualizar RTM_Master
   5. Verificar metricas de cobertura

6.2 Al Modificar Artefacto Existente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Ejecutar analisis de impacto (que depende de este)
   2. Revisar todos los derivados
   3. Propagar cambios necesarios
   4. Actualizar fechas y versiones
   5. Documentar cambio en historial

6.3 Al Eliminar Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Verificar que no tiene derivados activos
   2. Si tiene derivados, reasignarlos o eliminarlos
   3. Actualizar artefactos origen (remover referencia)
   4. Marcar como obsoleto en RTM (no borrar)
   5. Documentar razon de eliminacion
