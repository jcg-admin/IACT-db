.. _uc-opr-03-parte-01:

==============================
Parte 1 — Informacion general
==============================

ID: UC_OPR_03 · BReq-007 · Function:
``initiate_outbound_call``.

Proposito: agente inicia llamada a
cliente desde campaña asignada o
callback solicitado.

Modos:

- Manual dial (agente teclea numero)
- Auto-dial (sistema marca y asigna
  agente cuando contesta)
- Preview-dial (agente revisa info y
  acepta marcar)

Restricciones: CNST-009/013/025.
Politica anti-fraud: numero NO sale
de lista permitida → bloqueado.
