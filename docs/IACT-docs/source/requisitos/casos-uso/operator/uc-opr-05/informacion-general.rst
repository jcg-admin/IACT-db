.. _uc-opr-05-parte-01:

==============================
Parte 1 — Informacion general
==============================

ID: UC_OPR_05 · BReq-007 · Function:
implícita ``transfer_own_call``.

Tipos:

- Warm transfer: agente A consulta a B,
  presenta el caso, luego pasa caller
  a B.
- Cold transfer: agente A pasa
  directamente a B / cola sin
  presentacion.
- Queue transfer: pasa a una cola
  (skill).

Restricciones: target debe estar
disponible o cola valida. Reason
required (UC_RPT_15 audit).
