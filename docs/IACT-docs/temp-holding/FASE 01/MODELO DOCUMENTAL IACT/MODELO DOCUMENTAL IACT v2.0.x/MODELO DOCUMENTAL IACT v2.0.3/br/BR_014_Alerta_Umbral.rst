.. meta::
   :artefacto: BR_014
   :tipo: Business Rule
   :subtipo: Desencadenador
   :modalidad: Deontica (Obligacion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-014:

==============================================================================
BR_014: Alerta por Umbral Superado
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   SI una metrica monitoreada supera el umbral configurado,
   ENTONCES el sistema DEBE enviar notificacion a los destinatarios
   configurados para esa alerta, via buzon interno.

**Enunciado SBVR:**

   If a monitored metric exceeds its configured threshold,
   then the system must notify the configured recipients
   via internal mailbox.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Desencadenador (Trigger)
   * - **Modalidad**
     - Deontica - Obligacion (Obligation)
   * - **Estatica/Dinamica**
     - Dinamica (umbrales configurables)

**Nota:** Es DESENCADENADOR porque la accion (notificacion) es
OBSERVABLE por los destinatarios. Genera Casos de Uso.

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Requisitos de Negocio - Monitoreo Proactivo
   * - **Documento**
     - Especificacion Funcional IACT
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Proactividad:** Alertar antes de que problemas escalen.

2. **Monitoreo automatico:** No depender de revision manual.

3. **Tiempo de respuesta:** Reducir tiempo de reaccion a anomalias.

4. **Personalizacion:** Diferentes umbrales para diferentes metricas.

----

Condicion y Accion
------------------

Condicion (SI)
^^^^^^^^^^^^^^

.. code-block:: text

   Condicion: metrica.valor > alerta.umbral

   Variables:
   - metrica: Valor actual de la metrica monitoreada
   - umbral: Valor configurado en la alerta

   Operadores soportados:
   - MAYOR_QUE (>)
   - MENOR_QUE (<)
   - IGUAL_A (=)
   - DIFERENTE_DE (!=)

Accion (ENTONCES)
^^^^^^^^^^^^^^^^^

.. code-block:: text

   Accion: Notificar destinatarios via buzon interno

   1. Crear mensaje en internal_messages
   2. Destinatarios: todos los configurados para esa alerta
   3. Prioridad: segun configuracion de alerta
   4. Contenido: nombre alerta, metrica, valor actual, umbral

   Nota: Respeta BR_004 (solo comunicaciones internas)

----

Casos de Uso Generados
----------------------

Esta BR genera directamente:

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Descripcion
   * - UC_036
     - Crear Alerta
     - Configurar metrica, umbral, destinatarios
   * - UC_037
     - Recibir Notificacion
     - Usuario recibe alerta en buzon

Influye en:

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Relacion
   * - UC_038
     - Pausar Alerta
     - Suspender temporalmente
   * - UC_039
     - Historial Alertas
     - Ver alertas disparadas
   * - UC_040
     - Gestionar Destinatarios
     - Configurar quien recibe

----

Modelo de Datos
---------------

.. code-block:: sql

   -- Configuracion de alertas
   CREATE TABLE alerts (
       id SERIAL PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       metric_type VARCHAR(50) NOT NULL,
       operator VARCHAR(20) NOT NULL,  -- 'GT', 'LT', 'EQ', 'NE'
       threshold DECIMAL(10,2) NOT NULL,
       priority VARCHAR(20) DEFAULT 'NORMAL',
       is_active BOOLEAN DEFAULT TRUE,
       created_by INTEGER REFERENCES users(id),
       created_at TIMESTAMP DEFAULT NOW()
   );

   -- Destinatarios de alertas
   CREATE TABLE alert_recipients (
       id SERIAL PRIMARY KEY,
       alert_id INTEGER REFERENCES alerts(id),
       user_id INTEGER REFERENCES users(id),
       UNIQUE(alert_id, user_id)
   );

   -- Historial de alertas disparadas
   CREATE TABLE alert_history (
       id SERIAL PRIMARY KEY,
       alert_id INTEGER REFERENCES alerts(id),
       triggered_at TIMESTAMP DEFAULT NOW(),
       metric_value DECIMAL(10,2),
       threshold_value DECIMAL(10,2),
       recipients_notified INTEGER
   );

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-036.01
     - Sistema DEBE permitir configurar metrica a monitorear
   * - FR-036.02
     - Sistema DEBE permitir configurar umbral y operador
   * - FR-036.03
     - Sistema DEBE permitir asignar destinatarios
   * - FR-036.04
     - Sistema DEBE evaluar alertas periodicamente
   * - FR-037.01
     - Sistema DEBE enviar notificacion a buzon cuando umbral superado
   * - FR-037.02
     - Sistema DEBE incluir valor actual y umbral en notificacion
   * - FR-039.01
     - Sistema DEBE registrar cada alerta disparada en historial

----

Implementacion Tecnica
----------------------

Evaluador de Alertas
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/alerts.py

   class AlertEvaluator:

       OPERATORS = {
           'GT': lambda v, t: v > t,
           'LT': lambda v, t: v < t,
           'EQ': lambda v, t: v == t,
           'NE': lambda v, t: v != t,
       }

       def evaluate_all(self):
           """
           BR_014: Evaluar todas las alertas activas
           """
           alerts = Alert.objects.filter(is_active=True)

           for alert in alerts:
               current_value = self._get_metric_value(alert.metric_type)
               threshold = alert.threshold

               if self._check_condition(alert.operator, current_value, threshold):
                   self._trigger_alert(alert, current_value)

       def _check_condition(self, operator, value, threshold):
           return self.OPERATORS[operator](value, threshold)

       def _trigger_alert(self, alert, current_value):
           # Crear notificaciones (BR_004: solo buzon interno)
           recipients = AlertRecipient.objects.filter(alert=alert)

           for recipient in recipients:
               InternalMessage.objects.create(
                   recipient_id=recipient.user_id,
                   sender_type='ALERT',
                   subject=f"Alerta: {alert.name}",
                   body=f"La metrica {alert.metric_type} ha superado el umbral.\n"
                        f"Valor actual: {current_value}\n"
                        f"Umbral: {alert.threshold}",
                   priority=alert.priority
               )

           # Registrar en historial
           AlertHistory.objects.create(
               alert=alert,
               metric_value=current_value,
               threshold_value=alert.threshold,
               recipients_notified=recipients.count()
           )

Job de Evaluacion
^^^^^^^^^^^^^^^^^

.. code-block:: text

   Frecuencia: Cada 15 minutos
   Hora: Continuo durante horario laboral

----

Metricas Monitoreables
----------------------

.. list-table::
   :header-rows: 1
   :widths: 30 40 30

   * - Metrica
     - Descripcion
     - Umbral Tipico
   * - TASA_ABANDONO
     - % llamadas abandonadas
     - > 10%
   * - TIEMPO_ESPERA_PROM
     - Segundos promedio en cola
     - > 120 seg
   * - LLAMADAS_EN_COLA
     - Cantidad en espera
     - > 50
   * - NIVEL_SERVICIO
     - % atendidas en < 20 seg
     - < 80%

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Al superar umbral, destinatarios reciben notificacion en buzon
2. Notificacion incluye metrica, valor actual y umbral
3. Alerta disparada se registra en historial
4. Alertas pausadas no disparan notificaciones

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-004` - BR_004 Comunicaciones Internas
- MOD_Alerts - Modulo de Alertas
- UC_036 a UC_040 - Casos de uso de alertas

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

- Origen: Requisitos de Negocio
- Tipo: Desencadenador (genera UC)
- Genera: UC_036, UC_037
- Influye: UC_038, UC_039, UC_040
- Deriva: FR-036.01 a FR-036.04, FR-037.01, FR-037.02, FR-039.01
