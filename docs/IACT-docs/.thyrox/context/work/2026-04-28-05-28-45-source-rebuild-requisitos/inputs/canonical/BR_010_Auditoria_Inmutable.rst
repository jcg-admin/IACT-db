.. meta::
   :artefacto: BR_010
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-010:

===========================
BR_010: Auditoria Inmutable
===========================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_010
   * - **Nombre**
     - Auditoria Inmutable
   * - **Tipo**
     - Restriccion
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

Los registros de auditoria NO PUEDEN ser modificados ni eliminados
una vez creados. La tabla de auditoria es append-only. Ningun rol
del sistema tiene permiso de UPDATE o DELETE sobre registros de auditoria.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Registro de auditoria: Entrada en log de eventos del sistema
     - Append-only: Solo se permiten operaciones INSERT
     - Inmutabilidad: Imposibilidad de modificar datos existentes

   REGLA:
     Es prohibido modificar registros de auditoria existentes.
     Es prohibido eliminar registros de auditoria.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Garantiza integridad de la evidencia de auditoria para investigaciones,
cumplimiento regulatorio, y deteccion de manipulacion de logs.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restriccion**: Limita acciones o valores permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - restriccion permanente
- **Automatizable**: Si - permisos de BD y modelo
- **Alcance**: MOD_Audit

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_009_Logging_Auditoria_Inmutable
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

- MOD_Audit: Modelo sin metodos update/delete
- Base de datos: Usuario IACT sin permisos UPDATE/DELETE en tabla audit
- API: No expone endpoints de modificacion

4.2 Excepciones
^^^^^^^^^^^^^^^

Solo DBA con acceso directo a BD puede purgar logs antiguos segun
politica de retencion (ver BR_018).

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- CNST_009: Define inmutabilidad de logs

5.2 UC Afectados
^^^^^^^^^^^^^^^^

- UC-060: Registrar Evento (solo INSERT)
- UC-061: Consultar Log (solo SELECT)
- UC-063: Exportar Auditoria (solo SELECT)

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Modelo de auditoria no tiene metodo save() para updates
2. Usuario BD no tiene GRANT UPDATE/DELETE
3. Intentos de modificacion generan error

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
