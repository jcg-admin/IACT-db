.. _uc-opr-06-parte-01:

==============================
Parte 1 — Informacion general
==============================

ID: UC_OPR_06 · BReq-007 · Function:
implícita ``set_call_disposition``.

Disposition catalog (configurable):

- ``resolved``: caso atendido OK.
- ``follow_up``: requiere callback.
- ``escalation``: pasa a otro depto.
- ``unreachable``: no contacto
  efectivo (outbound).
- ``do_not_call``: cliente solicita.

Notes opcionales (≤ 500 char,
sanitized).

Restricciones: disposition obligatoria
en ACW; sin disposition NO se sale
de ACW (P-86).
