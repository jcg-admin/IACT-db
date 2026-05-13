.. _uc-alr-05-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — RBAC:

- Self: implícita
  ``manage_own_subscriptions``.
- Otros: ``manage_user_subscriptions``.

PASO 4 — Validar:

- subscription_type valido.
- target rule existe (si rule_id).
- scope ⊆ segmento del User target
  (CNST-008).

PASO 5 — INSERT Subscription.
PASO 6 — Audit.
PASO 7 — 201.

CRUD estandar para list / delete.
