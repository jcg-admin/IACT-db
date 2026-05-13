.. _uc-alr-01-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Validator metric desconocido.
UT-02: Validator scope cross-segmento.
UT-03: Validator action target inexistente.
UT-04: DryRunEngine cuenta hits correcto.

IT-01: Crear rule + evaluator notify.
IT-02: Update incrementa version.
IT-03: Pause / resume.
IT-04: Delete cascade.
IT-05: Dry-run reporta hits sin disparar.
IT-06: Cooldown evita re-fire.

E2E-01: Owner crea + dry-run + activa.

SEC-01: Cross-segmento bloqueado.
SEC-02: Sin permiso 403.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..05
   - CRUD + validation
   - IT-01..02, UT-01..03
 * - CA-06..07
   - State / cleanup
   - IT-03, IT-04
 * - CA-08
   - Dry-run
   - UT-04, IT-05
 * - CA-09
   - Cooldown
   - IT-06
 * - CA-10
   - Audit
   - integration
 * - CA-11
   - Auth
   - SEC-02

Cobertura: 4 unit, 6 integration, 1 E2E,
2 security. 100% de los 11 CAs.
