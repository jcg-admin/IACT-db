====================================================
ALERTS Module — Use Case Diagram
====================================================

:module: ALERTS
:diagram_type: use-case
:color: COLOR_ALERTS (#EF4444)
:actors: Operator, Supervisor, AlertService, Notification Engine
:created: 2026-04-26
:status: Production

Overview
========

The ALERTS (Alert System) module detects anomalies in system metrics, user behavior, and compliance events, triggering notifications and escalation workflows.

Use Case Diagram
================

.. uml::

   @startuml alerts_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: ALERTS module alerting and escalation use cases

   actor "Operator" as operator <<AGR_OPERADOR>>
   actor "Supervisor" as supervisor <<AGR_OPERADOR>>
   actor "AlertService" as alert_svc <<SISTEMA>>

   usecase "Create\nAlert" as create_alert
   usecase "Trigger\nAlert" as trigger_alert
   usecase "Escalate\nAlert" as escalate
   usecase "Acknowledge\nAlert" as acknowledge
   usecase "Close\nAlert" as close_alert
   usecase "View\nAlerts" as view_alerts

   usecase "Evaluate\nRule" as eval_rule
   usecase "Route\nNotification" as route_notif
   usecase "Track\nStatus" as track_status

   operator --> create_alert
   operator --> view_alerts
   operator --> acknowledge
   operator --> close_alert

   supervisor --> escalate

   trigger_alert --> eval_rule: <<include>>
   trigger_alert --> route_notif: <<include>>
   trigger_alert --> track_status: <<include>>

   escalate --> route_notif: <<include>>
   escalate --> track_status: <<include>>

   note right of trigger_alert
     Automatic detection based
     on metric thresholds
     or rule violations
   end note

   note right of escalate
     Route to supervisor
     if not acknowledged
     within SLA
   end note

   @enduml

**Actors:**
- Operator: Creates alerts, acknowledges notifications
- Supervisor: Escalates unresolved alerts
- AlertService: Evaluates rules and triggers alerts

**Use Cases:**

1. **Create Alert** - Define alert rule with conditions, thresholds, and notification targets
2. **Trigger Alert** - Rule engine evaluates metric and automatically creates alert instance
3. **Escalate Alert** - Route to supervisor if operator doesn't acknowledge within SLA
4. **Acknowledge Alert** - Operator marks alert as received and being handled
5. **Close Alert** - Resolve and close alert (manual or automatic after remediation)
6. **View Alerts** - Display alert dashboard with open/closed/acknowledged status

**Constraints:**
- CNST-ALERTS-001: Alert creation to notification: <30 seconds
- CNST-ALERTS-002: Escalation SLA: 15 minutes for P1, 1 hour for P2, 4 hours for P3
- CNST-ALERTS-003: Deduplication window: 5 minutes (same condition, same target)
- CNST-ALERTS-004: Alert history retained 1 year

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_ALERTS (#EF4444)
