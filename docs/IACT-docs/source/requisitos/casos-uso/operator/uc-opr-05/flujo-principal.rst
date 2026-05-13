.. _uc-opr-05-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT + ownership.
PASO 3 — Validar target.
PASO 4 — Verificar target available
o cola valida.
PASO 5a (warm) — Telephony.consult
(call agente B), agente A presenta
caso, luego complete-transfer.

PASO 5b (cold) — Telephony.transfer
direct.
PASO 6 — Atomic: TransferEvent
record + Audit ``CALL_TRANSFERRED``.
PASO 7 — 200.
