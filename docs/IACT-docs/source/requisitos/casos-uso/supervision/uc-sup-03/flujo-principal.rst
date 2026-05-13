.. _uc-sup-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT + RBAC.
PASO 3 — Validar target ⊆ segmentos
del supervisor.
PASO 4 — Resolver lista de
recipients.
PASO 5 — Bulk INSERT MailboxMessage
por cada recipient.
PASO 6 — Si urgente: push SSE.
PASO 7 — Audit
``BROADCAST_SENT`` con count.
PASO 8 — 200.
