.. _uc-opr-04-parte-03:

==========================
Parte 3 — Flujo principal
==========================

Hold:

PASO 1 — POST hold.
PASO 2 — JWT + ownership (la llamada
es del invoker).
PASO 3 — Telephony.hold(call_id).
PASO 4 — UPDATE CallSession.hold_started_at.
PASO 5 — Audit ``CALL_HELD``.
PASO 6 — 200.

Unhold:

Espejo: Telephony.unhold +
hold_duration_seconds += delta.
Audit ``CALL_UNHELD``.
