.. meta::
   :artefacto: BR_008
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-008:

============================
BR_008: Auditoria de Accesos
============================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_008
   * - **Nombre**
     - Auditoria de Accesos
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

Todo acceso al sistema DEBE ser registrado en el log de auditoria.
El registro DEBE incluir: usuario, timestamp, IP, accion realizada,
recurso accedido, y resultado (exito/fallo).

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Acceso: Login, logout, operacion sobre recursos
     - Log de auditoria: Registro inmutable de eventos
     - Evento auditable: Accion que requiere registro

   REGLA:
     Es obligatorio que todo acceso genere registro de auditoria.
     Es obligatorio que el registro incluya todos los campos requeridos.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Auditoria completa permite detectar accesos no autorizados, investigar
incidentes de seguridad, cumplir con regulaciones, y demostrar
trazabilidad de acciones en el sistema.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restriccion**: Limita acciones o valores permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica
- **Automatizable**: Si - middleware de auditoria
- **Alcance**: Sistema completo

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

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripcion de Aplicacion
   * - MOD_Auth
     - Registra login/logout
   * - MOD_Audit
     - Almacena y consulta logs
   * - Middleware DRF
     - Captura todas las operaciones

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
   * - CNST_009
     - Define requisitos de logging y auditoria

5.2 UC Afectados
^^^^^^^^^^^^^^^^

- UC-060: Registrar Evento de Auditoria
- UC-061: Consultar Log de Auditoria
- UC-062: Generar Reporte de Auditoria

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Todo request genera entrada en log de auditoria
2. Campos obligatorios presentes en cada registro
3. Logs disponibles para consulta por AGR-007

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
