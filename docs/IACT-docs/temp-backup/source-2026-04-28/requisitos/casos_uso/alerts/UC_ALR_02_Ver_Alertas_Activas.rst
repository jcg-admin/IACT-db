.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Alerts
   :uc_id: UC_ALR_02
   :normativa: CNST-001, CNST-003, CNST-004

==============================
UC_ALR_02: Ver Alertas Activas
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_ALR_02
   * - **Nombre**
     - Ver Alertas Activas
   * - **Actor Principal**
     - AGR-001: agr_operador_basico
   * - **Modulo**
     - MOD_Alerts
   * - **Funcion RBAC**
     - ALR-002: ve_alertas
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-ALR-002

2. Descripcion
--------------

Este caso de uso permite visualizar las alertas activas del sistema en
tiempo real. Solo se muestran alertas del segmento del usuario (CNST-004).
Los datos provienen de BD Analytics (CNST-003) y las notificaciones
se envian via InternalMessage (CNST-001).

**Caracteristicas principales:**

- Ver alertas activas en tiempo real
- Filtrado automatico por segmento del usuario
- Indicadores visuales por nivel de severidad
- Auto-refresh cada 30 segundos
- Ordenamiento por severidad (criticas primero)

**Restriccion CNST-001:**

.. warning::
   Las notificaciones de alerta se envian EXCLUSIVAMENTE via
   InternalMessage.notify(). PROHIBIDO enviar por email o SMS.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_ALR_02

   @startuml
   left to right direction
   actor "AGR-001\nagr_operador_basico" as USER
   actor "Sistema\nMonitor" as SYS

   rectangle "MOD_Alerts" {
     usecase "UC_ALR_02\nVer Alertas Activas" as UC02
     usecase "Filtrar por\nSegmento" as SEG
     usecase "Auto Refresh\n30s" as REF
     usecase "Notificar via\nInternalMessage" as NOT
   }

   USER --> UC02
   UC02 --> SEG : include
   UC02 --> REF : include
   SYS --> NOT
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
     - El usuario tiene sesion activa con funcion ALR-002
   * - PRE-02
     - El usuario tiene un segmento asignado
   * - PRE-03
     - El motor de alertas esta activo

4.2 Trigger
^^^^^^^^^^^

El usuario accede al panel de alertas o recibe una notificacion de alerta.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran alertas activas del segmento del usuario
   * - POST-02
     - El panel se actualiza automaticamente cada 30 segundos

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Usuario
     - Accede al panel de alertas
   * - 2
     - Sistema
     - Valida funcion ALR-002
   * - 3
     - Sistema
     - Obtiene segmento del usuario
   * - 4
     - Sistema
     - Consulta alertas activas del segmento en Analytics
   * - 5
     - Sistema
     - Ordena por severidad (CRITICAL > WARNING > INFO)
   * - 6
     - Sistema
     - Renderiza panel con indicadores visuales
   * - 7
     - Sistema
     - Inicia temporizador de auto-refresh (30s)
   * - 8
     - Usuario
     - Visualiza alertas activas

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_ALR_02

   @startuml
   actor "AGR-001 Usuario" as U
   participant "Frontend" as FE
   participant "AlertController" as AC
   participant "AlertService" as AS
   participant "InternalMessage" as IM
   database "Analytics" as DB

   U -> FE: Accede a Panel de Alertas
   FE -> AC: GET /api/alerts/active
   AC -> AC: verify_function(ALR-002)
   AC -> AC: get_user_segment()

   AC -> AS: get_active_alerts(segmento)
   AS -> DB: SELECT * FROM alerts\nWHERE segmento_id = ?\nAND status = 'ACTIVE'\nORDER BY severity DESC,\ncreated_at DESC
   note right of DB: CNST-003 BD Analytics
   DB --> AS: alerts
   AS --> AC: alerts
   AC --> FE: 200 OK + alerts
   FE --> U: Panel de alertas

   loop cada 30 segundos
     FE -> AC: GET /api/alerts/active
     AC --> FE: updated_alerts
     FE --> U: Panel actualizado
   end

   == Nueva Alerta Detectada ==

   participant "AlertEngine" as AE

   AE -> AS: create_alert(metrica, valor, segmento)
   AS -> DB: INSERT INTO alerts
   AS -> IM: notify(subscribers, alert)
   note right of IM
     CNST-001: SOLO
     InternalMessage
     PROHIBIDO email/SMS
   end note
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Sin Alertas Activas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Sistema
     - No hay alertas activas para el segmento
   * - 6a
     - Sistema
     - Muestra panel vacio con mensaje informativo
   * - 6b
     - Sistema
     - Muestra indicador verde de estado normal

7.2 FA-02: Nueva Alerta Durante Visualizacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Sistema
     - Detecta nueva alerta en ciclo de refresh
   * - 7b
     - Sistema
     - Muestra notificacion visual destacada
   * - 7c
     - Sistema
     - Si es CRITICAL, reproduce alerta sonora

7.3 FA-03: Ver Detalle de Alerta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Usuario
     - Hace clic en una alerta
   * - 8b
     - Sistema
     - Muestra panel de detalle con metrica, valor, umbral, timestamp

8. Excepciones
--------------

8.1 EX-01: Sin Permiso ALR-002
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion ALR-002 asignada
   * - **Accion Sistema**
     - Rechaza acceso al panel de alertas
   * - **Mensaje Usuario**
     - No tiene permisos para ver alertas
   * - **Codigo Error**
     - ALR-010

8.2 EX-02: Usuario Sin Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Usuario no tiene segmento asignado
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - Usuario sin segmento asignado. Contacte al administrador.
   * - **Codigo Error**
     - ALR-011

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_ALR_02

   @startuml
   start
   :Usuario accede a Panel de Alertas;

   if (Tiene funcion ALR-002?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Obtener segmento del usuario;
   note right: CNST-004

   if (Usuario tiene segmento?) then (no)
     :Mostrar error sin segmento;
     stop
   else (si)
   endif

   :Consultar alertas activas;
   note right: CNST-003 BD Analytics

   :Ordenar por severidad;

   if (Hay alertas activas?) then (si)
     :Renderizar alertas con indicadores;
     switch (Severidad mas alta?)
     case (CRITICAL)
       :Indicador ROJO parpadeante;
     case (WARNING)
       :Indicador AMARILLO;
     case (INFO)
       :Indicador AZUL;
     endswitch
   else (no)
     :Mostrar panel vacio;
     :Indicador VERDE (normal);
   endif

   :Iniciar auto-refresh 30s;

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
   * - BR-ALR-10
     - Filtro por Segmento
     - Usuario solo ve alertas de su segmento asignado
   * - BR-ALR-11
     - Orden por Severidad
     - Alertas criticas primero, luego advertencias, luego info
   * - BR-ALR-12
     - Refresh Automatico
     - Panel se actualiza cada 30 segundos
   * - BR-ALR-13
     - Solo InternalMessage
     - Notificaciones SOLO via InternalMessage (CNST-001)

**Niveles de Severidad:**

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Nivel
     - Indicador
     - Descripcion
   * - CRITICAL
     - Rojo
     - Metrica en nivel critico, requiere accion inmediata
   * - WARNING
     - Amarillo
     - Metrica en nivel de advertencia, monitorear
   * - INFO
     - Azul
     - Alerta informativa, sin accion requerida

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
     - Las notificaciones de alerta se envian EXCLUSIVAMENTE via InternalMessage.notify(). PROHIBIDO email, SMS o canales externos.
   * - CNST-003
     - BD Dual
     - Datos de alertas se leen de BD Analytics
   * - CNST-004
     - Segmentos de Datos
     - Filtro automatico por segmento del usuario

**Implementacion CNST-001:**

.. code-block:: python

   # services/alert_notifier.py
   class AlertNotifier:
       def notify_alert(self, alert, subscribers):
           for user in subscribers:
               # CNST-001: SOLO InternalMessage
               InternalMessage.notify(
                   recipient=user,
                   title=f"Alerta {alert.severity}: {alert.metrica}",
                   body=f"Valor: {alert.valor} (Umbral: {alert.umbral})",
                   priority='HIGH' if alert.severity == 'CRITICAL' else 'NORMAL'
               )
               # PROHIBIDO:
               # - EmailService.send()
               # - SMSService.send()
               # - PushNotification.send()

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-ALR-010
     - El sistema debe mostrar alertas activas
     - Lista ordenada por severidad visible
   * - FR-ALR-011
     - El sistema debe filtrar por segmento
     - Solo alertas del segmento del usuario mostradas
   * - FR-ALR-012
     - El sistema debe auto-refrescar
     - Actualizacion cada 30 segundos sin recargar
   * - FR-ALR-013
     - El sistema debe notificar via InternalMessage
     - Notificaciones en buzon interno unicamente

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-ALR-002: Visualizar alertas activas del sistema
   * - **Reglas de Negocio**
     - BR-ALR-10 a BR-ALR-13
   * - **Restricciones**
     - CNST-001 (InternalMessage), CNST-003 (BD Dual), CNST-004 (Segmentos)
   * - **UC Relacionados**
     - UC_ALR_01 (Umbrales), UC_ALR_03 (Reconocer), UC_ALR_04 (Historial)
   * - **Actor Principal**
     - AGR-001: agr_operador_basico
   * - **Funcion RBAC**
     - ALR-002: ve_alertas

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