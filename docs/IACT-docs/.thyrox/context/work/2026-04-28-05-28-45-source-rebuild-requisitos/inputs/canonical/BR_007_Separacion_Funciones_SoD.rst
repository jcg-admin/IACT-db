.. meta::
   :artefacto: BR_007
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-007:

===================================
BR_007: Separacion de Funciones SoD
===================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_007
   * - **Nombre**
     - Separacion de Funciones SoD
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

Ciertas combinaciones de funciones NO PUEDEN ser asignadas al mismo usuario
para prevenir conflictos de interes y fraude. El sistema DEBE validar
restricciones SoD antes de cualquier asignacion de funciones.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - SoD: Separation of Duties (Segregacion de Funciones)
     - Restriccion SoD: Par de funciones mutuamente excluyentes
     - Conflicto SoD: Usuario con funciones que violan restriccion

   REGLA:
     Es prohibido que un usuario tenga funciones que violen una restriccion SoD.
     Es obligatorio que el sistema valide SoD antes de asignar funciones.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

SoD es control fundamental de seguridad que previene fraude y errores.
Ej: quien crea usuarios no debe poder asignar permisos administrativos.
Cumple con principios de auditoria y control interno.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restriccion**: Limita acciones o valores permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Dinamica - restricciones configurables
- **Automatizable**: Si - validacion en asignacion
- **Alcance**: MOD_Access

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
     - Segregacion de Funciones
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST + Estandar NIST

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: admin_seguridad (AGR-008)
- **Proceso de Cambio**: Configuracion via UC-043
- **Frecuencia de Revision**: Semestral

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
     - Valida SoD en asignacion de funciones
   * - Tabla sod_restrictions
     - Almacena pares de funciones incompatibles
   * - API asignacion
     - Rechaza asignacion si viola SoD

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: AGR-001 (asigna funciones), AGR-008 (configura SoD)

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones automaticas. Casos especiales requieren aprobacion
documentada del sponsor y registro en auditoria.

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
   * - CNST_005
     - Define requisitos de SoD

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
     - Asignar Funciones - validacion SoD
   * - UC-043
     - Configurar SoD - definir restricciones
   * - UC-044
     - Consultar Permisos Efectivos - muestra conflictos

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. No existen usuarios con funciones que violen SoD
2. Intentos de asignacion violatoria son rechazados
3. Restricciones SoD documentadas y vigentes

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Por transaccion de asignacion
- **Responsable**: MOD_Access

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Asignacion bloqueada con mensaje de error
- Registro en log de auditoria
- Notificacion a admin_seguridad

----

7. Restricciones SoD Definidas
------------------------------

::

   SOD_001: USR-001 (crear usuario) vs ACC-001 (asignar funcion admin)
   SOD_002: AUD-001 (ver auditoria) vs AUD-004 (exportar auditoria)
   SOD_003: PIP-001 (ejecutar ETL) vs PIP-004 (modificar config ETL)

----

8. Historial de Cambios
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
