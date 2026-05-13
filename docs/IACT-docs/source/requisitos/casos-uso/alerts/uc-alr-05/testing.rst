.. _uc-alr-05-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Validator type valido.
UT-02: Detectar duplicado.

IT-01: Crear sub propia.
IT-02: Admin crea sub de otro.
IT-03: Cross-segmento → 400.
IT-04: Duplicada → 409.
IT-05: Mute global.
IT-06: Bulk add.
IT-07: Auto-pause cuando pierde segmento.

E2E-01: Onboarding admin.
E2E-02: User mute + unmute.

SEC-01: Sin permiso admin path → 403.
SEC-02: User no edita sub de otro.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..02
   - CRUD
   - IT-01, IT-02
 * - CA-03..04
   - Validation
   - IT-03, IT-04
 * - CA-05..06
   - UX
   - IT-05, IT-06
 * - CA-07
   - Auto-pause
   - IT-07
 * - CA-08
   - Auth
   - SEC-01..02
 * - CA-09
   - Audit
   - integration

Cobertura: 2 unit, 7 integration, 2 E2E,
2 security. 100% de los 9 CAs.
