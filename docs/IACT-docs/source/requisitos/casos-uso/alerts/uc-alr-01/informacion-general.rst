.. _uc-alr-01-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_ALR_01
 * - **Nombre**
   - Configurar Umbrales de Alertas
 * - **BReq**
   - BReq-006 (operacion continua)
 * - **Funcion RBAC**
   - ``manage_alert_thresholds``

1.2 Proposito
=============

Definir reglas: "si SL < 80% por 5 min,
emitir alerta CRITICA al supervisor". Las
reglas se evaluan continuamente por
ALR-Evaluator (UC interno).

1.3 Estructura de regla
=======================

::

   AlertRule:
     name, description
     metric: SL | abandon_rate | queue_depth
             | TMO | login_failures | ...
     scope: { segment | queue | campaign }
     condition: comparator + threshold
     window: rolling N minutes
     severity: info | warning | critical
     actions: [
       mailbox_notify_user(user_id),
       mailbox_notify_agr(agr_code),
       create_incident_ticket
     ]
     status: active | paused
     cooldown_minutes: int

1.4 Restricciones
=================

- CNST-001: NO email externo. Acciones via
  mailbox interno.
- CNST-008: scope segmento del owner.
- CNST-013, CNST-025.

1.5 Out of scope
================

- Evaluador del rule (interno, ALR
  pipeline).
- UI alertas activas (UC_ALR_02).
- Reconocer / cerrar (UC_ALR_03).
