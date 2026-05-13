.. meta::
   :artefacto: BR_006
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-006:

======================
BR_006: RBAC Flat NIST
======================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_006
   * - **Nombre**
     - RBAC Flat NIST
   * - **Tipo**
     - Hecho
   * - **Categoria**
     - Seguridad
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

El sistema de control de acceso IACT ES un modelo RBAC Flat basado en
NIST RBAC. NO existe jerarquia de roles. Los usuarios reciben funciones
atomicas directamente, agrupadas en Agrupadores para conveniencia
administrativa.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - RBAC: Role-Based Access Control
     - Flat: Sin jerarquia de herencia entre roles
     - Funcion atomica: Permiso indivisible (ej: USR-001)
     - Agrupador: Conjunto de funciones para asignacion conveniente

   REGLA:
     Es obligatorio que el modelo de acceso siga NIST RBAC.
     Es obligatorio que no exista herencia entre roles/agrupadores.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

El modelo Flat simplifica auditoria (permisos explicitos, no heredados),
evita complejidad de herencia multiple, y permite control granular.
Cumple con NIST SP 800-53 y facilita revision de accesos.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Hecho**: Define estructura o relacion del dominio

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - modelo arquitectonico
- **Automatizable**: Si - estructura de tablas RBAC
- **Alcance**: MOD_Access, sistema completo

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_005_Seguridad_DRF_Checklist
   * - **Seccion**
     - Modelo de Control de Acceso
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST + Estandar NIST

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Arquitecto de Seguridad, admin_seguridad (AGR-008)
- **Proceso de Cambio**: Revision arquitectonica formal
- **Frecuencia de Revision**: Solo ante cambio de arquitectura

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripcion de Aplicacion
   * - MOD_Access
     - Implementa modelo RBAC con 44 funciones atomicas
   * - Middleware DRF
     - Valida permisos por funcion, no por rol
   * - Base Analytics
     - Tablas: funciones, agrupadores, user_funciones

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los agrupadores RBAC (AGR-001 a AGR-010)

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones. El modelo Flat es absoluto.

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relacion
   * - CNST-005
     - Estandar de seguridad DRF (autenticacion, autorizacion en APIs)
   * - :ref:`cnst-012`
     - Modelo RBAC Flat consolidado: 42 funciones, 10 grupos, 3 reglas SoD,
       permisos temporales con vencimiento. Implementa esta BR.

5.2 BReq Influenciados
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq-004
     - Cumplimiento de Seguridad

5.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC-010
     - Asignar Funciones a Usuario
   * - UC-011
     - Gestionar Permisos por Agrupador
   * - UC-044
     - Consultar Permisos Efectivos
   * - UC-045
     - Gestionar Catalogo de Agrupadores
   * - UC-046
     - Gestionar Catalogo de Funciones

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. No existe tabla de herencia de roles
2. Permisos se resuelven por union de funciones asignadas
3. 44 funciones atomicas definidas en catalogo

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado + Manual
- **Frecuencia**: Por release (estructura), continua (permisos)
- **Responsable**: QA, admin_seguridad

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Violacion de arquitectura de seguridad
- Revision obligatoria de modelo de acceso

----

7. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-04
     - Equipo IACT
     - Version inicial