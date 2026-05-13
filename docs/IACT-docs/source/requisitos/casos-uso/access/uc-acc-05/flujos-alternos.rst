.. _uc-acc-05-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Listado vacio
========================

**Activador**: filtros sin matches.

**Diferencia**: ``count=0``, ``results=[]``.

4.2 FA-02: Filter por rule_id (audit P-16)
==========================================

**Activador**: GET con ``?rule_id=X``.

**Diferencia**: AuditEvent
``SOD_RULES_VIEWED`` con
``payload.target_rule_id``.

4.3 FA-03: Crear regla con violaciones existentes
=================================================

**Activador**: la nueva regla generaria
violaciones para Users que YA tienen el par
conflictivo.

**Diferencia**:

- La regla se crea (no se bloquea).
- Response incluye
  ``existing_violations_count`` y
  ``violating_user_ids`` (sample) — para
  visibilidad.
- AuditEvent SOD_RULE_CREATED payload
  incluye ``existing_violations_count``.
- Frontend muestra warning destacado y
  recomienda revisar UC_ACC_03 para resolver.

**Decision**: NO bloquear. La nueva regla es
politica nueva — los Users con violaciones
deben revisarse, pero la regla debe entrar en
vigor.

4.4 FA-04: Modificar display_name / description
===============================================

**Activador**: PATCH solo con campos
descriptivos.

**Diferencia**: cache NO se invalida (no
afecta logica de validacion).

4.5 FA-05: Retirar con violaciones residuales
=============================================

**Activador**: retirar regla cuando hay Users
con violaciones que esa regla detectaba.

**Diferencia**: la retirada se permite. Las
violaciones dejan de detectarse en
write-time. AuditEvent payload incluye
``residual_violations_count`` para historial.

4.6 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - Listado vacio
   - results=[]
   - 200 OK
 * - FA-02
   - Filter rule_id
   - Audit P-16
   - 200 OK
 * - FA-03
   - Crear con violaciones existentes
   - Warning + count
   - 201 Created
 * - FA-04
   - Modificar solo descriptivo
   - Sin cache invalidate
   - 200 OK
 * - FA-05
   - Retirar con violaciones residuales
   - Audit metadata
   - 200 OK
