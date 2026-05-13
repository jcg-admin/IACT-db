.. meta::
   :artefacto: BR_009
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-009:

=====================
BR_009: Bajas Logicas
=====================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_009
   * - **Nombre**
     - Bajas Logicas
   * - **Tipo**
     - Restriccion
   * - **Categoria**
     - Operacional
   * - **Criticidad**
     - Media
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

Los registros de usuarios NO DEBEN ser eliminados fisicamente de la base
de datos. La eliminacion DEBE ser logica mediante cambio de estado a
INACTIVO, preservando el registro para auditoria e integridad referencial.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Baja logica: Cambio de estado a INACTIVO sin borrar registro
     - Baja fisica: DELETE del registro (prohibido)
     - Estado de usuario: ACTIVO, INACTIVO, BLOQUEADO

   REGLA:
     Es prohibido eliminar fisicamente registros de usuarios.
     Es obligatorio que la eliminacion sea mediante cambio de estado.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Preserva integridad referencial con registros historicos (auditorias,
asignaciones pasadas), cumple requisitos de retencion de datos, y
permite reactivacion si es necesario.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restriccion**: Limita acciones o valores permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica
- **Automatizable**: Si - modelo Django sin delete fisico
- **Alcance**: MOD_Users

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - Politica de Retencion de Datos
   * - **Tipo Fuente**
     - Politica Interna

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

- MOD_Users: Modelo de usuario con soft delete
- API de eliminacion: Cambia estado en lugar de DELETE

4.2 Excepciones
^^^^^^^^^^^^^^^

Solo datos de prueba en ambiente de desarrollo pueden ser borrados fisicamente.

----

5. Trazabilidad
---------------

5.1 UC Afectados
^^^^^^^^^^^^^^^^

- UC-008: Baja Usuario (logica)

5.2 BReq Influenciados
^^^^^^^^^^^^^^^^^^^^^^

- BReq-004: Cumplimiento de Seguridad

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Modelo de usuario implementa soft delete
2. No existe operacion DELETE en API de usuarios
3. Usuarios eliminados tienen estado INACTIVO

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
