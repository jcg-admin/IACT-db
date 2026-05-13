.. _uc-perm-09-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-09**
   - Audit-or-abort
   - INSERT en tx caller; fallo ⇒ rollback
 * - **P-39**
   - Audit reforzado
   - CRITICAL_ACTION replica
 * - **P-44**
   - Visibility audit prio
   - eventos UNAUTHORIZED + critical
 * - **P-51**
   - Read-no-audit
   - clarifica que el READ no audita
 * - **P-54** (nuevo)
   - PII-free audit
   - hash de identificadores; payload
     scaneado pre-write
 * - **P-55** (nuevo)
   - Append-only enforcement
   - constraint a nivel BD prohibe
     UPDATE / DELETE

10.2 P-54: PII-free audit
=========================

**Problema**: AuditEvents son persistencia
larga (anos). Si contienen PII, se vuelven
un riesgo de compliance (GDPR / similar).

**Solucion**:

- Sanitizacion sistematica antes del INSERT.
- Hash de identificadores que necesitan
  trazabilidad (username en LOGIN_FAILED →
  username_hash).
- Scanner regex pre-write detecta emails /
  numeros de identidad / telefonos.
- Bloquea el evento si detecta PII (no
  decora — es enforcement).

10.3 P-55: Append-only enforcement
==================================

**Problema**: una tabla "audit" mutable es
un audit fake. Cualquier admin con UPDATE
podria reescribir historia.

**Solucion** multi-capa:

- A nivel BD: trigger que rechaza UPDATE /
  DELETE sobre la tabla.
- A nivel orm/repo: solo metodo
  ``insert``, sin ``update / delete``.
- A nivel deployment: el rol de BD que usa
  el servicio NO tiene UPDATE/DELETE grant
  sobre audit_event.

Tres barreras independientes — defense in
depth.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - P-09
   - PASO 6, FA-02, CA-08
 * - P-39
   - FA-05, CA-12
 * - P-44
   - 1.3 catalog
 * - P-51
   - 1.4 NO-audita
 * - P-54
   - PASO 3-4, FA-01, CA-05/06
 * - P-55
   - CA-02, NFR 6.2, EX-05
