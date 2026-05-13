.. _uc-aud-04-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Template validator.
UT-02: HMAC signer.
UT-03: Hash recompute.

IT-01: PRIVILEGED_ACCESS produce reporte.
IT-02: CONFIG_CHANGES.
IT-03: LOGIN_PATTERNS.
IT-04: SENSITIVE_DATA_ACCESS.
IT-05: Verify match.
IT-06: Verify mismatch (manipulado).
IT-07: Audit emitido.
IT-08: Mailbox notify.

E2E-01: Compliance officer genera y verifica.

SEC-01: NO email externo.
SEC-02: Sin permiso 403.
SEC-03: Verify detecta tampering.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - Templates
   - IT-01..04
 * - CA-05..06
   - Firma/verify
   - UT-02, IT-05, IT-06, SEC-03
 * - CA-07
   - Explicit
   - integration
 * - CA-08..09
   - Notify/audit
   - IT-07, IT-08
 * - CA-10..11
   - Auth/validation
   - SEC-02

Cobertura: 3 unit, 8 integration, 1 E2E,
3 security. 100% de los 11 CAs.
