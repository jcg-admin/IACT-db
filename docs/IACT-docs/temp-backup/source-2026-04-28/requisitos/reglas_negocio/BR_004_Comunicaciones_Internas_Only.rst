.. meta::
   :artefacto: BR_004
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-004:

====================================
BR_004: Comunicaciones Internas Only
====================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_004
   * - **Nombre**
     - Comunicaciones Internas Only
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

El sistema IACT NO DEBE enviar comunicaciones a servicios externos.
Todas las notificaciones DEBEN utilizar unicamente el buzon interno
del sistema. Esta prohibido el uso de email externo, SMS, o APIs
de terceros para notificaciones.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Comunicacion externa: Email, SMS, webhook a servicios terceros
     - Buzon interno: Sistema de mensajeria dentro de IACT
     - Notificacion: Mensaje generado por el sistema para usuarios

   REGLA:
     Es prohibido que IACT envie comunicaciones a servicios externos.
     Es obligatorio que todas las notificaciones usen el buzon interno.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Restriccion impuesta por el cliente para mantener datos sensibles
dentro del perimetro de la organizacion. Evita fuga de informacion
operacional y simplifica cumplimiento de politicas de datos.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restriccion**: Limita acciones o valores permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - restriccion permanente
- **Automatizable**: Si - no implementar integraciones externas
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
     - CNST_001_Comunicaciones_Prohibidas
   * - **Seccion**
     - Restricciones de Comunicacion
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Cliente / Sponsor
- **Proceso de Cambio**: Aprobacion ejecutiva del cliente
- **Frecuencia de Revision**: Solo ante cambio de politica

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
   * - MOD_Alerts
     - Notificaciones solo via buzon interno
   * - MOD_Users
     - Recuperacion password via pregunta seguridad
   * - MOD_Audit
     - Alertas de auditoria via buzon interno

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los agrupadores RBAC
- **Sistemas Externos**: Ninguno (prohibido)

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones definidas.

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
   * - CNST_001
     - Define prohibicion de comunicaciones externas

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
   * - UC-003
     - Recuperar Password - sin email externo
   * - UC-037
     - Recibir Notificacion Alerta - via buzon interno
   * - UC-040
     - Gestionar Destinatarios - solo usuarios internos

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. No existe codigo que llame APIs externas de comunicacion
2. No hay configuracion de SMTP/email externo
3. Todas las notificaciones van a tabla de buzon interno

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Manual (revision de codigo) + Automatizado (tests)
- **Frecuencia**: Por release
- **Responsable**: QA, admin_seguridad

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Violacion de politica del cliente
- Potencial incumplimiento contractual
- Revision de seguridad obligatoria

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
