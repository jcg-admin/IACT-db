.. meta::
   :artefacto: BR_001
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-001:

====================================
BR_001: Fuente Operacional Inmutable
====================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_001
   * - **Nombre**
     - Fuente Operacional Inmutable
   * - **Tipo**
     - Hecho
   * - **Categoria**
     - Operacional
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

La base de datos MySQL del sistema IVR ES de solo lectura para el sistema IACT.
IACT NO PUEDE ejecutar operaciones INSERT, UPDATE o DELETE en la base IVR.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Base IVR: Base de datos MySQL del sistema de telefonia
     - IACT: Sistema de analitica de dashboard
     - Operacion de escritura: INSERT, UPDATE, DELETE

   REGLA:
     Es obligatorio que IACT acceda a Base IVR unicamente en modo lectura.
     Es prohibido que IACT ejecute operaciones de escritura en Base IVR.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

La base IVR es un sistema legacy critico que alimenta multiples aplicaciones
del call center. Modificar datos comprometeria la integridad operacional y
afectaria otros sistemas dependientes. Esta restriccion es impuesta por el
cliente como requisito no negociable.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Hecho**: Define estructura o relacion del dominio

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - restriccion arquitectonica permanente
- **Automatizable**: Si - mediante Database Router de Django
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
     - CNST_003_Base_Datos_Dual_Inmutable
   * - **Seccion**
     - Arquitectura de Datos
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST (Restriccion del cliente)

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Cliente / Sponsor del proyecto
- **Proceso de Cambio**: Requiere aprobacion ejecutiva del cliente
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
   * - Database Router
     - IVRReadOnlyRouter bloquea escrituras a base IVR
   * - MOD_Pipeline
     - ETL solo extrae datos, no modifica origen
   * - Django ORM
     - Modelos IVR marcados como managed=False

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los agrupadores RBAC (ninguno puede escribir en IVR)
- **Sistemas Externos**: Sistema IVR (MariaDB)

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones definidas. La inmutabilidad es absoluta.

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
   * - CNST_003
     - Define arquitectura dual y permisos de base de datos

5.2 BReq Influenciados
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq-005
     - Integridad de Datos Operacionales

5.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC-050
     - Supervisar Estado ETL - solo lectura de IVR
   * - UC-017 a UC-024
     - Reportes - consultan datos IVR via replica

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Database Router rechaza operaciones de escritura a IVR
2. Logs de base de datos no muestran escrituras desde IACT
3. Tests automatizados verifican bloqueo de escritura

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Continua (cada request)
- **Responsable**: Database Router

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Excepcion DatabaseError bloqueando la operacion
- Registro en log de seguridad
- Notificacion a admin_sistema

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