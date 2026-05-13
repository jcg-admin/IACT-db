.. _uc-cli-01-parte-01:

==============================
Parte 1 — Informacion general
==============================

ID: UC_CLI_01 · BReq-007 · Function:
NO aplica (actor externo, no
autenticado en sistema).

Trigger: numero externo que llama
a un DID (Direct Inward Dial) del
call center.

Requisitos:

- Welcome / saludo audio.
- Identificacion del cliente
  (caller_id).
- Hash del caller_id antes de
  persistir (CNST-026).

Restricciones: sin PII en logs;
caller_hash desde primer momento.
