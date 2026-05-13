.. _uc-opr-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT + RBAC.
PASO 3 — Validar destination
(formato + lista permitida).
PASO 4 — Verificar agent state =
available.
PASO 5 — Telephony.dial(destination).
PASO 6 — Esperar pickup / busy / no
answer.
PASO 7 — Si pickup: bridge agent +
caller, atomic state busy + audit
``OUTBOUND_CALL_INITIATED``.
PASO 8 — 200 con call_session_id.
