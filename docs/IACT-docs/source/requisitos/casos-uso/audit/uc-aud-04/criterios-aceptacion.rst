.. _uc-aud-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: PRIVILEGED_ACCESS template genera
reporte con Users con funciones criticas.
CA-02: CONFIG_CHANGES.
CA-03: LOGIN_PATTERNS.
CA-04: SENSITIVE_DATA_ACCESS.
CA-05: Reporte firmado HMAC.
CA-06: Verify endpoint valida firma.
CA-07: Sin findings explicito.
CA-08: NO email externo (mailbox).
CA-09: Audit P-39 emitido.
CA-10: Sin permiso 403.
CA-11: Template invalido 400.

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Templates
   - Funcional
 * - CA-05..06
   - Firma + verify
   - Cumplimiento
 * - CA-07
   - Explicit
   - UX
 * - CA-08..09
   - Notify + audit
   - Cumplimiento
 * - CA-10..11
   - Auth/validation
   - varios
