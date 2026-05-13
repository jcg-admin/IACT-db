.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Alerts
   :uc_id: UC_ALR_03
   :normativa: CNST-001, CNST-009

===========================
UC_ALR_03: Reconocer Alerta
===========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ALR_03
   * - **Nombre**
     - Reconocer Alerta
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Alerts
   * - **Funcion RBAC**
     - ALR-003: reconoce_alertas
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-ALR-003

2. Descripcion
--------------

Este caso de uso permite a un supervisor reconocer (acknowledge) una
alerta activa, indicando que ha sido vista y se esta tomando accion.
El reconocimiento se registra en auditoria (CNST-009) y se notifica
al equipo via InternalMessage (CNST-001).

**Caracteristicas principales:**

- Marcar alerta como reconocida (acknowledged)
- Registrar quien y cuando reconocio
- Agregar comentario opcional de accion tomada
- Notificar al equipo via InternalMessage
- La alerta permanece visible hasta que la metrica vuelva a normal

**Estados de Alerta:**

- ACTIVE: Alerta activa, no reconocida
- ACKNOWLEDGED: Alerta reconocida, accion en progreso
- RESOLVED: Metrica volvio a nivel normal (automatico)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ALR_03

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER

   rectangle "MOD_Alerts" {
     usecase "UC_ALR_03\nReconocer Alerta" as UC03
     usecase "Registrar\nReconocimiento" as REG
     usecase "Notificar\nEquipo" as NOT
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC03
   UC03 --> REG : include
   UC03 --> NOT : include
   UC03 --> AUD : include
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
     - El usuario tiene sesion activa con funcion ALR-003
   * - PRE-02
     - La alerta existe y esta en estado ACTIVE
   * - PRE-03
     - La alerta pertenece al segmento del usuario

4.2 Trigger
^^^^^^^^^^^

El supervisor hace clic en el boton Reconocer de una alerta activa.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - La alerta queda marcada como ACKNOWLEDGED
   * - POST-02
     - Se registra ALERT_ACK en auditoria (CNST-009)
   * - POST-03
     - Se notifica al equipo via InternalMessage (CNST-001)

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Supervisor
     - Visualiza alerta activa en el panel
   * - 2
     - Supervisor
     - Hace clic en boton Reconocer
   * - 3
     - Sistema
     - Valida funcion ALR-003
   * - 4
     - Sistema
     - Muestra dialogo de reconocimiento
   * - 5
     - Supervisor
     - Opcionalmente ingresa comentario de accion
   * - 6
     - Supervisor
     - Confirma reconocimiento
   * - 7
     - Sistema
     - Actualiza estado de alerta a ACKNOWLEDGED
   * - 8
     - Sistema
     - Registra usuario y timestamp de reconocimiento
   * - 9
     - Sistema
     - Registra ALERT_ACK en auditoria
   * - 10
     - Sistema
     - Envia notificacion via InternalMessage al equipo
   * - 11
     - Sistema
     - Muestra confirmacion

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ALR_03

   @startuml
   actor "AGR-003 Supervisor" as S
   participant "Frontend" as FE
   participant "AlertController" as AC
   participant "AlertService" as AS
   participant "InternalMessage" as IM
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   S -> FE: Click Reconocer alerta
   FE --> S: Dialogo de reconocimiento
   S -> FE: comentario (opcional)
   S -> FE: Confirmar

   FE -> AC: POST /api/alerts/{id}/acknowledge
   AC -> AC: verify_function(ALR-003)

   AC -> AS: acknowledge_alert(alert_id, user, comment)

   AS -> DB: SELECT * FROM alerts WHERE id = ?
   DB --> AS: alert

   alt alerta no existe
     AS --> AC: AlertNotFoundError
     AC --> FE: 404 Not Found
     FE --> S: Error: Alerta no encontrada
   end

   alt alerta ya reconocida
     AS --> AC: AlreadyAcknowledgedError
     AC --> FE: 409 Conflict
     FE --> S: Error: Alerta ya fue reconocida
   end

   AS -> DB: UPDATE alerts\nSET status = 'ACKNOWLEDGED',\nacked_by = ?,\nacked_at = NOW(),\nack_comment = ?
   DB --> AS: updated

   AS -> UAL: record(ALERT_ACK, user, alert, comment)
   note right of UAL: CNST-009
   UAL -> DB: INSERT user_action_log

   AS -> IM: notify(team_subscribers, alert_acked)
   note right of IM
     CNST-001: SOLO
     InternalMessage
   end note

   AS --> AC: acknowledged
   AC --> FE: 200 OK
   FE --> S: Confirmacion visual
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Reconocer con Comentario Detallado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Supervisor
     - Ingresa comentario detallado de accion tomada
   * - 10a
     - Sistema
     - Incluye comentario en la notificacion al equipo

7.2 FA-02: Reconocer Multiples Alertas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Supervisor
     - Selecciona multiples alertas activas
   * - 2a
     - Supervisor
     - Hace clic en Reconocer Seleccionadas
   * - 7a
     - Sistema
     - Procesa reconocimiento de cada alerta

8. Excepciones
--------------

8.1 EX-01: Alerta Ya Reconocida
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - La alerta ya tiene status ACKNOWLEDGED
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - Esta alerta ya fue reconocida por [usuario] el [fecha]
   * - **Codigo Error**
     - ALR-020

8.2 EX-02: Alerta Ya Resuelta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - La alerta ya tiene status RESOLVED
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - Esta alerta ya fue resuelta automaticamente
   * - **Codigo Error**
     - ALR-021

8.3 EX-03: Sin Permiso ALR-003
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Usuario no tiene funcion ALR-003
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - No tiene permisos para reconocer alertas
   * - **Codigo Error**
     - ALR-022

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ALR_03

   @startuml
   start
   :Supervisor selecciona alerta activa;
   :Click en Reconocer;

   if (Tiene funcion ALR-003?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar dialogo de reconocimiento;
   :Ingresar comentario (opcional);
   :Confirmar reconocimiento;

   if (Alerta ya reconocida?) then (si)
     :Mostrar error ya reconocida;
     stop
   else (no)
   endif

   if (Alerta ya resuelta?) then (si)
     :Mostrar error ya resuelta;
     stop
   else (no)
   endif

   :Actualizar estado a ACKNOWLEDGED;
   :Registrar acked_by y acked_at;

   :Registrar en auditoria;
   note right: CNST-009

   :Notificar equipo via InternalMessage;
   note right: CNST-001

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
   * - BR-ALR-20
     - Unico Reconocimiento
     - Una alerta solo puede ser reconocida una vez
   * - BR-ALR-21
     - No Resuelve
     - El reconocimiento no resuelve la alerta, solo indica que se vio
   * - BR-ALR-22
     - Notificacion Equipo
     - Se notifica al equipo via InternalMessage unicamente
   * - BR-ALR-23
     - Registro Completo
     - Se registra usuario, timestamp y comentario opcional

**Transiciones de Estado:**

.. code-block:: text

   ACTIVE --> ACKNOWLEDGED (por reconocimiento manual)
   ACTIVE --> RESOLVED (automatico cuando metrica vuelve a normal)
   ACKNOWLEDGED --> RESOLVED (automatico cuando metrica vuelve a normal)

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
     - Notificacion de reconocimiento SOLO via InternalMessage.notify(). PROHIBIDO email/SMS.
   * - CNST-009
     - Auditoria Inmutable
     - Registro ALERT_ACK con usuario, alerta, comentario y timestamp.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ALR-020
     - El sistema debe permitir reconocer alertas
     - Estado cambia a ACKNOWLEDGED correctamente
   * - FR-ALR-021
     - El sistema debe registrar quien reconocio
     - Campos acked_by y acked_at poblados
   * - FR-ALR-022
     - El sistema debe notificar al equipo
     - Mensaje enviado via InternalMessage
   * - FR-ALR-023
     - El sistema debe auditar el reconocimiento
     - Registro en user_action_log

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ALR-003: Reconocer alertas activas
   * - **Reglas de Negocio**
     - BR-ALR-20 a BR-ALR-23
   * - **Restricciones**
     - CNST-001 (InternalMessage), CNST-009 (Auditoria)
   * - **UC Relacionados**
     - UC_ALR_02 (Ver Alertas), UC_ALR_04 (Historial)
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - ALR-003: reconoce_alertas

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
