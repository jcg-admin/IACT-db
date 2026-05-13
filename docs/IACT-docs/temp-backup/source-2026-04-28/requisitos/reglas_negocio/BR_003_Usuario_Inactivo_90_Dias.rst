.. meta::
   :artefacto: BR_003
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-003:

================================
BR_003: Usuario Inactivo 90 Dias
================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_003
   * - **Nombre**
     - Usuario Inactivo 90 Dias
   * - **Tipo**
     - Inferencia
   * - **Categoria**
     - Seguridad
   * - **Criticidad**
     - Media
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

SI un usuario no ha iniciado sesion en los ultimos 90 dias,
ENTONCES el sistema INFIERE que el usuario esta inactivo
y su cuenta DEBE ser marcada para revision de seguridad.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Usuario inactivo: Usuario sin inicio de sesion en 90+ dias
     - Ultimo acceso: Fecha/hora del ultimo login exitoso
     - Estado de revision: Marca para evaluacion de seguridad

   REGLA:
     Es obligatorio que un usuario sea clasificado como inactivo
     si su ultimo acceso fue hace mas de 90 dias.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Cuentas sin uso prolongado representan riesgo de seguridad. Pueden
pertenecer a empleados que ya no estan en la organizacion o ser
objetivo de acceso no autorizado. La marca de inactividad permite
auditoria y posible desactivacion preventiva.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Inferencia**: Deriva hechos internos no observables

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - umbral de 90 dias fijo
- **Automatizable**: Si - job batch de revision
- **Alcance**: MOD_Users, MOD_Access

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - Politica de Seguridad Organizacional
   * - **Seccion**
     - Gestion de Cuentas de Usuario
   * - **Tipo Fuente**
     - Politica Interna

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: admin_seguridad (AGR-008)
- **Proceso de Cambio**: Revision de politica de seguridad
- **Frecuencia de Revision**: Anual

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
   * - MOD_Users
     - Almacena fecha de ultimo acceso
   * - MOD_Access
     - Evalua estado de inactividad
   * - Job Batch
     - Ejecuta revision periodica de cuentas

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los usuarios del sistema
- **Notificados**: AGR-008 (admin_seguridad), AGR-007 (auditor)

4.3 Excepciones
^^^^^^^^^^^^^^^

- Cuentas de servicio (sin login interactivo) excluidas
- Cuentas en estado de licencia aprobada excluidas

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
   * - (ninguna)
     - Derivada de politica organizacional

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
   * - UC-009
     - Listar Usuarios - muestra estado inactivo
   * - UC-061
     - Consultar Log Auditoria - registra cambios estado

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Sistema calcula dias desde ultimo acceso correctamente
2. Usuarios con 90+ dias sin acceso marcados como inactivos
3. Reporte de usuarios inactivos disponible para auditoria

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Diaria (job nocturno)
- **Responsable**: Sistema batch

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Cuenta marcada como inactiva en sistema
- Notificacion a admin_seguridad para revision
- Registro en log de auditoria

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