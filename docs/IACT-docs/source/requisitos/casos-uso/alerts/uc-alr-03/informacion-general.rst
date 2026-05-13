.. _uc-alr-03-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_ALR_03
 * - **Nombre**
   - Reconocer Alerta
 * - **BReq**
   - BReq-006
 * - **Funcion RBAC**
   - ``acknowledge_alerts``

1.2 Proposito
=============

Indicar que un humano vio la alerta y se
hace cargo. Stops further notifications
hasta que cambia state. Permite tracking
de tiempo de respuesta.

1.3 Restricciones
=================

CNST-008, CNST-009, CNST-013, CNST-025.

1.4 Audit
=========

P-39 audit reforzado:
``ALERT_ACKNOWLEDGED`` con actor,
ack_at, note?.
