.. _uc-opr-10-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET inbox.
PASO 2 — JWT.
PASO 3 — Query MailboxRepo WHERE
recipient = invoker.id.
PASO 4 — Filter por status.
PASO 5 — 200.

Marcar leido:

POST /{id}/read/ → UPDATE status =
read + audit.
