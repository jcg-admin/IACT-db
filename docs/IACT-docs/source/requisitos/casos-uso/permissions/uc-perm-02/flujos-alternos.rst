.. _uc-perm-02-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01..FA-05: heredados UC_ACC_02
=====================================

- Idempotencia (AGR ya REVOKED), warning
  critico, warning no_functions, last
  holder, notify_user=false. Comportamiento
  backend identico.

4.2 FA-06 (PERM): preview pre-revoke
====================================

**Activador**: invoker pide
``GET preview-revoke?user_id&agr_id`` antes
de submit.

**Diferencia**: backend retorna preview con:

- functions_count_to_revoke
- functions_remaining_active
- warnings (no_functions, critical,
  last_holder)
- estimated_sod_changes (revocar puede
  resolver violaciones existentes — esa
  info se entrega).

NO persiste, NO genera AuditEvent.

4.3 FA-07 (PERM): vista catalogo + count post-revoke
====================================================

**Activador**: revocacion exitosa desde
catalogo.

**Diferencia**: catalogo refleja
``users_count -= 1`` post-COMMIT cache
invalidate.

4.4 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01..05
   - heredados UC_ACC_02
   - identicos
   - segun cada uno
 * - FA-06
   - preview pre-revoke
   - GET sin persistir
   - 200 OK preview
 * - FA-07
   - refresh catalogo
   - users_count -= 1
   - n/a (UI)
