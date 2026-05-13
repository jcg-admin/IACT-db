.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Alerts
   :uc_id: UC_ALR_05
   :normativa: CNST-001, CNST-004, CNST-009

==================================
UC_ALR_05: Gestionar Suscripciones
==================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ALR_05
   * - **Nombre**
     - Gestionar Suscripciones
   * - **Actor Principal**
     - AGR-005: agr_gestor_alertas
   * - **Modulo**
     - MOD_Alerts
   * - **Funcion RBAC**
     - ALR-005: gestiona_suscripciones
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-ALR-005

2. Descripcion
--------------

Este caso de uso permite gestionar las suscripciones de usuarios a
alertas. Define quien recibe notificaciones cuando se disparan alertas.
Las notificaciones son EXCLUSIVAMENTE via InternalMessage (CNST-001).

**Caracteristicas principales:**

- Suscribir usuarios a tipos de alertas
- Configurar nivel de severidad minimo para notificacion
- Suscripcion por segmento (CNST-004)
- Notificaciones SOLO via InternalMessage (CNST-001)
- Registro de cambios en auditoria (CNST-009)

**Restriccion Critica CNST-001:**

.. warning::
   Las notificaciones de alerta se envian EXCLUSIVAMENTE via
   InternalMessage.notify(). Esta PROHIBIDO enviar notificaciones
   por email, SMS o cualquier otro canal externo.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ALR_05

   @startuml
   left to right direction
   actor "AGR-005\nagr_gestor_alertas" as USER

   rectangle "MOD_Alerts" {
     usecase "UC_ALR_05\nGestionar Suscripciones" as UC05
     usecase "Suscribir\nUsuario" as SUB
     usecase "Desuscribir\nUsuario" as UNSUB
     usecase "Configurar\nNivel Minimo" as NIVEL
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC05
   UC05 --> SUB : extend
   UC05 --> UNSUB : extend
   UC05 --> NIVEL : extend
   UC05 --> AUD : include
   @enduml

4. Contexto de Ejecucion
------------------------

4.1 Precondiciones
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Precondicion
   * - PRE-01
     - El usuario tiene sesion activa con funcion ALR-005
   * - PRE-02
     - El usuario destino existe y esta activo
   * - PRE-03
     - El usuario destino pertenece al mismo segmento

4.2 Trigger
^^^^^^^^^^^

El gestor de alertas accede a la gestion de suscripciones.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - La suscripcion queda configurada
   * - POST-02
     - Se registra SUBSCRIPTION_CONFIG en auditoria (CNST-009)

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Gestor
     - Accede a gestion de suscripciones
   * - 2
     - Sistema
     - Valida funcion ALR-005
   * - 3
     - Sistema
     - Muestra usuarios y sus suscripciones actuales
   * - 4
     - Gestor
     - Selecciona usuario del segmento
   * - 5
     - Sistema
     - Muestra suscripciones actuales del usuario
   * - 6
     - Gestor
     - Selecciona tipo de alerta a suscribir
   * - 7
     - Gestor
     - Configura nivel de severidad minimo
   * - 8
     - Gestor
     - Guarda suscripcion
   * - 9
     - Sistema
     - Valida usuario del mismo segmento
   * - 10
     - Sistema
     - Crea/actualiza registro de suscripcion
   * - 11
     - Sistema
     - Registra en auditoria
   * - 12
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ALR_05

   @startuml
   actor "AGR-005 Gestor" as G
   participant "Frontend" as FE
   participant "AlertController" as AC
   participant "SubscriptionService" as SS
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   G -> FE: Accede a Suscripciones
   FE -> AC: GET /api/alerts/subscriptions
   AC -> AC: verify_function(ALR-005)
   AC -> SS: get_subscriptions(segmento)
   SS -> DB: SELECT * FROM alert_subscriptions\nJOIN users ON user_id\nWHERE segmento_id = ?
   DB --> SS: subscriptions
   SS --> AC: subscriptions
   AC --> FE: 200 OK
   FE --> G: Lista de suscripciones

   G -> FE: Configura suscripcion
   G -> FE: user_id, alert_type, min_severity
   FE -> AC: POST /api/alerts/subscriptions
   AC -> SS: subscribe(user_id, alert_type, severity)

   SS -> DB: SELECT * FROM users WHERE id = ?
   DB --> SS: user

   SS -> SS: validate_same_segment()
   note right: CNST-004

   alt usuario diferente segmento
     SS --> AC: SegmentMismatchError
     AC --> FE: 403 Forbidden
   end

   SS -> DB: INSERT/UPDATE alert_subscriptions\nSET alert_type = ?,\nmin_severity = ?,\nnotify_method = 'INTERNAL_MESSAGE'
   note right: CNST-001 Solo InternalMessage

   SS -> UAL: record(SUBSCRIPTION_CONFIG)
   note right: CNST-009
   UAL -> DB: INSERT user_action_log

   SS --> AC: subscription_saved
   AC --> FE: 200 OK
   FE --> G: Confirmacion

   == Cuando se dispara alerta ==

   participant "AlertEngine" as AE
   participant "InternalMessage" as IM

   AE -> SS: get_subscribers(alert)
   SS -> DB: SELECT usuarios suscritos
   DB --> SS: subscribers

   loop cada suscriptor
     SS -> IM: notify(user, alert)
     note right
       CNST-001: SOLO
       InternalMessage
       PROHIBIDO email/SMS
     end note
   end
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Desuscribir Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Gestor
     - Selecciona suscripcion existente
   * - 6b
     - Gestor
     - Hace clic en Eliminar Suscripcion
   * - 10a
     - Sistema
     - Elimina registro de suscripcion
   * - 11a
     - Sistema
     - Registra SUBSCRIPTION_REMOVED en auditoria

7.2 FA-02: Suscripcion Masiva
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Gestor
     - Selecciona multiples usuarios del segmento
   * - 10a
     - Sistema
     - Crea suscripciones para todos los seleccionados

7.3 FA-03: Modificar Nivel de Severidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Gestor
     - Selecciona suscripcion existente
   * - 7a
     - Gestor
     - Cambia nivel de severidad minimo
   * - 10a
     - Sistema
     - Actualiza registro existente

8. Excepciones
--------------

8.1 EX-01: Usuario de Otro Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Usuario destino pertenece a segmento diferente
   * - **Accion Sistema**
     - Rechaza suscripcion
   * - **Mensaje Usuario**
     - Solo puede suscribir usuarios de su mismo segmento
   * - **Codigo Error**
     - ALR-040

8.2 EX-02: Usuario Inactivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Usuario destino esta inactivo o eliminado
   * - **Accion Sistema**
     - Rechaza suscripcion
   * - **Mensaje Usuario**
     - El usuario seleccionado no esta activo
   * - **Codigo Error**
     - ALR-041

8.3 EX-03: Suscripcion Duplicada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Ya existe suscripcion para usuario y tipo de alerta
   * - **Accion Sistema**
     - Actualiza suscripcion existente
   * - **Mensaje Usuario**
     - Suscripcion actualizada

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ALR_05

   @startuml
   start
   :Gestor accede a Gestion de Suscripciones;

   if (Tiene funcion ALR-005?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar usuarios y suscripciones del segmento;
   :Seleccionar usuario;

   if (Usuario del mismo segmento?) then (no)
     :Mostrar error de segmento;
     note right: CNST-004
     stop
   else (si)
   endif

   if (Usuario activo?) then (no)
     :Mostrar error usuario inactivo;
     stop
   else (si)
   endif

   :Seleccionar tipo de alerta;
   :Configurar nivel minimo de severidad;
   :Guardar suscripcion;

   note right
     CNST-001: Notificaciones
     SOLO via InternalMessage
     PROHIBIDO email/SMS
   end note

   :Registrar en auditoria;
   note right: CNST-009

   :Mostrar confirmacion;

   stop
   @enduml

10. Reglas de Negocio
---------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - ID
     - Regla
     - Descripcion
   * - BR-ALR-40
     - Solo InternalMessage
     - Las notificaciones se envian EXCLUSIVAMENTE via InternalMessage (CNST-001)
   * - BR-ALR-41
     - Mismo Segmento
     - Solo se pueden suscribir usuarios del mismo segmento (CNST-004)
   * - BR-ALR-42
     - Nivel Minimo
     - El usuario solo recibe alertas de severidad >= nivel configurado
   * - BR-ALR-43
     - Usuario Activo
     - Solo usuarios activos pueden tener suscripciones

**Tipos de Alerta Suscribibles:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Tipo
     - Descripcion
   * - TMO_ALTO
     - Tiempo Medio de Operacion sobre umbral
   * - ABANDONO_ALTO
     - Tasa de abandono sobre umbral
   * - ESPERA_ALTA
     - Tiempo de espera sobre umbral
   * - NS_BAJO
     - Nivel de servicio bajo umbral
   * - OCUPACION_ALTA
     - Ocupacion de agentes sobre umbral
   * - TODAS
     - Todas las alertas del segmento

**Niveles de Severidad:**

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - Nivel
     - Descripcion
   * - CRITICAL
     - Recibe solo alertas criticas
   * - WARNING
     - Recibe alertas criticas y de advertencia
   * - INFO
     - Recibe todas las alertas (incluyendo informativas)

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-001
     - Comunicacion Interna
     - Las notificaciones se envian SOLO via InternalMessage.notify(). PROHIBIDO email/SMS/push.
   * - CNST-004
     - Segmentos
     - Solo usuarios del mismo segmento pueden suscribirse
   * - CNST-009
     - Auditoria Inmutable
     - Registro de creacion, modificacion y eliminacion de suscripciones

**Implementacion CNST-001:**

.. code-block:: python

   # services/alert_notifier.py
   class AlertNotifier:
       def notify_subscribers(self, alert):
           subscriptions = self.get_subscriptions(
               segmento=alert.segmento_id,
               alert_type=alert.type,
               min_severity=alert.severity
           )

           for sub in subscriptions:
               # CNST-001: SOLO InternalMessage
               InternalMessage.notify(
                   recipient=sub.user,
                   title=f"Alerta: {alert.type}",
                   body=f"{alert.metrica}: {alert.valor}",
                   priority='HIGH' if alert.severity == 'CRITICAL' else 'NORMAL'
               )
               # PROHIBIDO:
               # - EmailService.send()
               # - SMSGateway.send()
               # - PushNotification.send()

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ALR-040
     - El sistema debe permitir suscribir usuarios
     - Registro en alert_subscriptions creado
   * - FR-ALR-041
     - El sistema debe notificar via InternalMessage
     - Mensaje en buzon interno del usuario
   * - FR-ALR-042
     - El sistema debe respetar nivel minimo
     - Solo alertas >= nivel configurado enviadas
   * - FR-ALR-043
     - El sistema debe auditar cambios
     - Registro en user_action_log

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ALR-005: Gestionar suscripciones a alertas
   * - **Reglas de Negocio**
     - BR-ALR-40 a BR-ALR-43
   * - **Restricciones**
     - CNST-001 (critica), CNST-004, CNST-009
   * - **UC Relacionados**
     - UC_ALR_01 (Umbrales), UC_ALR_02 (Ver Alertas)
   * - **Actor Principal**
     - AGR-005: agr_gestor_alertas
   * - **Funcion RBAC**
     - ALR-005: gestiona_suscripciones

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial v4.0 con CNST-001