.. _uc-alr-05-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_ALR_05
 * - **BReq**
   - BReq-006
 * - **Funcion RBAC**
   - implícita
     ``manage_own_subscriptions``
     o ``manage_user_subscriptions``
     (admin)

1.1 Proposito
=============

Cada User puede sub/unsub a reglas de
alertas para recibir notificaciones
mailbox. Admin puede gestionar
suscripciones de otros (e.g., onboarding
de nuevo supervisor).

1.2 Tipos de subscription
=========================

(a) ``rule_id``: a una regla especifica.
(b) ``severity_filter``: a TODAS las
    reglas con cierta severity.
(c) ``scope_filter``: a alertas de
    cierto segmento.

1.3 Restricciones
=================

CNST-001 (no email), CNST-002 (mailbox),
CNST-008 (segmento), CNST-009.

1.4 Out of scope
================

- Crear rules (UC_ALR_01).
