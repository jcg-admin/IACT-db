.. _uc-alr-01-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``manage_alert_thresholds``
- **AlertRuleRepo**
- **AlertEvaluator** (consume)

2.2 Precondiciones
==================

Auth + RBAC + segmento.

2.3 Postcondiciones
===================

- AlertRule creado / updated / deleted.
- Audit ``ALERT_RULE_CREATED`` etc.
- Evaluator recarga config.

2.4 Datos de entrada
====================

::

   POST /api/alert-rules/
   body: {
     name, metric, scope,
     condition: { op: ">"|"<"|...,
                   threshold: number },
     window_minutes,
     severity,
     actions: [...],
     cooldown_minutes
   }

2.5 Datos de salida
===================

AlertRule completo.
