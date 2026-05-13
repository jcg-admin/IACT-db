.. _uc-opr-10-parte-01:

==============================
Parte 1 — Informacion general
==============================

ID: UC_OPR_10 · BReq-007 · Function:
implícita ``read_own_mailbox``.

CNST-001 prohibe email externo,
CNST-002 obliga mailbox interno.
Este UC es la lectura del agente.

Mensajes:

- Notificacion broadcast (UC_SUP_03)
- Mensaje individual del supervisor
- Alertas operacionales (export ready,
  schedule auto-paused, etc.)
