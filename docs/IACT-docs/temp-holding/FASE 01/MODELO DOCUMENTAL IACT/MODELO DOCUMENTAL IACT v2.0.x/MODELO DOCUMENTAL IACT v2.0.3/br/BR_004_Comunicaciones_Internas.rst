.. meta::
   :artefacto: BR_004
   :tipo: Business Rule
   :subtipo: Restriccion
   :modalidad: Deontica (Prohibicion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-004:

==============================================================================
BR_004: Comunicaciones Solo Internas
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   El sistema IACT NO DEBE enviar comunicaciones hacia el exterior
   (correo electronico, SMS, webhooks externos). Toda notificacion
   al usuario DEBE realizarse exclusivamente mediante el buzon
   interno del sistema.

**Enunciado SBVR:**

   It is prohibited that IACT system sends external communications.
   It is obligatory that all user notifications use the internal mailbox.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Prohibicion + Obligacion
   * - **Estatica/Dinamica**
     - Estatica (politica de seguridad corporativa)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Seguridad de la Informacion
   * - **Documento**
     - POL_001 Seguridad de la Informacion
   * - **Seccion**
     - 7.2 Comunicaciones y Canales Autorizados
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Seguridad de datos:** Evitar fuga de informacion sensible
   a traves de canales no controlados.

2. **Control corporativo:** La organizacion mantiene control
   total sobre las comunicaciones del sistema.

3. **Compliance:** Cumplimiento de politicas internas de
   comunicacion y proteccion de datos.

4. **Simplicidad:** Elimina dependencia de servicios externos
   (SMTP, gateways SMS) y sus posibles fallos.

5. **Auditoria:** Todas las comunicaciones quedan registradas
   internamente para revision.

----

Alcance de la Prohibicion
-------------------------

Lo que NO esta permitido:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Canal
     - Prohibicion
   * - Email (SMTP)
     - No enviar correos electronicos
   * - SMS
     - No enviar mensajes de texto
   * - Webhooks
     - No llamar URLs externas para notificar
   * - Push notifications
     - No enviar notificaciones push externas
   * - Integraciones externas
     - No enviar datos a sistemas externos

Lo que SI esta permitido:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Canal
     - Uso
   * - Buzon interno
     - Notificaciones dentro del sistema
   * - Interfaz web
     - Mensajes y alertas en pantalla
   * - Base de datos interna
     - Registro de notificaciones
   * - Logs internos
     - Registro tecnico de eventos

----

Mecanismo Alternativo: Buzon Interno
------------------------------------

Descripcion
^^^^^^^^^^^

El buzon interno es un sistema de mensajeria dentro de IACT que
reemplaza todas las comunicaciones externas.

Caracteristicas
^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70

   * - **Almacenamiento**
     - Tabla en PostgreSQL (internal_messages)
   * - **Acceso**
     - Via interfaz web del sistema
   * - **Destinatarios**
     - Usuarios registrados en IACT
   * - **Tipos de mensaje**
     - Notificacion, Alerta, Sistema
   * - **Estados**
     - No leido, Leido, Archivado

Modelo de Datos
^^^^^^^^^^^^^^^

.. code-block:: sql

   CREATE TABLE internal_messages (
       id SERIAL PRIMARY KEY,
       recipient_id INTEGER REFERENCES users(id),
       sender_type VARCHAR(20),  -- 'SYSTEM', 'USER', 'ALERT'
       subject VARCHAR(200),
       body TEXT,
       priority VARCHAR(10),  -- 'LOW', 'NORMAL', 'HIGH', 'CRITICAL'
       status VARCHAR(20) DEFAULT 'UNREAD',
       created_at TIMESTAMP DEFAULT NOW(),
       read_at TIMESTAMP NULL
   );

----

Casos de Uso Afectados
----------------------

Esta BR INFLUYE en todos los UC que requieren notificacion:

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Notificacion via Buzon
   * - UC_010
     - Asignar Roles
     - "Se le ha asignado rol X"
   * - UC_037
     - Recibir Notificacion Alerta
     - Alerta por umbral superado
   * - UC_003
     - Recuperar Password
     - "Su nueva contrasena temporal es..."
   * - UC_006
     - Crear Usuario
     - "Su cuenta ha sido creada"
   * - UC_008
     - Baja Usuario
     - "Su cuenta ha sido desactivada"

----

Requisitos Funcionales Derivados
--------------------------------

Prohibiciones:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-COM.01
     - Sistema NO DEBE tener configuracion SMTP
   * - FR-COM.02
     - Sistema NO DEBE invocar APIs de email externas
   * - FR-COM.03
     - Sistema NO DEBE invocar gateways SMS
   * - FR-COM.04
     - Sistema NO DEBE realizar llamadas HTTP a webhooks externos

Obligaciones:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-COM.10
     - Sistema DEBE implementar tabla internal_messages
   * - FR-COM.11
     - Sistema DEBE proveer interfaz para ver buzon
   * - FR-COM.12
     - Sistema DEBE marcar mensajes como leidos
   * - FR-COM.13
     - Sistema DEBE mostrar contador de mensajes no leidos
   * - FR-COM.14
     - Sistema DEBE permitir archivar mensajes
   * - FR-COM.15
     - Sistema DEBE auditar envio de mensajes internos

----

Impacto en Modulos
------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Modulo
     - Impacto
   * - MOD_Users
     - Notifica creacion/modificacion via buzon
   * - MOD_Access
     - Notifica asignacion de roles via buzon
   * - MOD_Alerts
     - Envia alertas al buzon (NO email)
   * - MOD_Auth
     - Envia contrasenas temporales al buzon

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_001
     - Comunicaciones Prohibidas
     - Implementa esta BR

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. No existe configuracion SMTP en settings
2. No hay imports de librerias de email
3. Busqueda en codigo: cero llamadas a send_mail, smtplib
4. Notificaciones aparecen en buzon interno
5. Usuario puede ver sus mensajes en interfaz

Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^

- Revision de codigo (grep por patrones de email)
- Inspeccion de settings.py
- Tests que verifican que email NO se envia
- Tests de buzon interno

----

Implementacion Tecnica
----------------------

Servicio de Notificacion
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/notification.py

   class NotificationService:
       """
       BR_004: Todas las notificaciones via buzon interno
       """

       def send(self, recipient_id, subject, body, priority='NORMAL'):
           """
           Envia notificacion al buzon interno.
           NO usa email, SMS ni canales externos.
           """
           from messages.models import InternalMessage

           message = InternalMessage.objects.create(
               recipient_id=recipient_id,
               sender_type='SYSTEM',
               subject=subject,
               body=body,
               priority=priority
           )

           # Registrar en auditoria
           self._audit_notification(message)

           return message

       def _audit_notification(self, message):
           # Log interno, NO externo
           pass

   # USO PROHIBIDO - NO IMPLEMENTAR
   # def send_email(recipient, subject, body):
   #     raise NotImplementedError("BR_004: Email prohibido")

----

Excepciones
-----------

Esta BR NO tiene excepciones. Ningun caso justifica envio externo.

Si en el futuro se requiere comunicacion externa, se debe:

1. Modificar politica POL_001
2. Actualizar CNST_001
3. Crear nueva BR que defina condiciones
4. Obtener aprobacion de Seguridad de la Informacion

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`cnst-001` - CNST_001 Comunicaciones Prohibidas
- :ref:`br-014` - BR_014 Alerta por Umbral (usa buzon)
- POL_001 - Politica de Seguridad de la Informacion
- MOD_Alerts - Modulo de Alertas

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-03
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:**

- Origen: POL_001 Seguridad de la Informacion
- Implementa: CNST_001
- Influye: UC_003, UC_006, UC_008, UC_010, UC_037
- Deriva: FR-COM.01 a FR-COM.15
