.. _uc-alr-03-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``acknowledge_alerts``
- **AlertRepo**

2.2 Precondiciones
==================

- Alert existe + estado firing.
- Alert.scope ⊆ segmentos del User.

2.3 Postcondiciones
===================

- Alert.state = acknowledged.
- acknowledged_by = invoker.id.
- acknowledged_at = now().
- Audit ALERT_ACKNOWLEDGED.

2.4 Datos de entrada
====================

::

   POST /api/alerts/{alert_id}/ack/
   body: {
     note?: string (≤ 500 char)
   }

2.5 Datos de salida
===================

Alert actualizado.
