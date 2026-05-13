.. _uc-acc-09-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``view_access_audit``
(P-15 RBAC granular). Tipicamente AGR-008
auditor_group la contiene.

2.2 Actores Secundarios
=======================

- **Sistema**: query con filtros,
  paginacion, agregaciones.
- **BD analitica**: indices apropiados sobre
  AuditEvent para consultas eficientes.
- **Frontend**: tabla paginada con filtros,
  vista detalle, vista agregada (counts).

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/access/audit/`` (GET).
- BD MySQL accesible.
- Invocante con la funcion.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de lectura
--------------------------------

- 200 OK con resultado paginado.
- Sin write — operacion read-only excepto
  audit selectivo de la propia consulta
  (P-16 — meta-audit).

2.4.2 Audit P-16 selectivo
--------------------------

AuditEvent ``ACCESS_AUDIT_VIEWED`` se emite
SOLO si la consulta esta filtrada por
``target_user_id`` especifico (caso de
investigacion). Listado amplio NO se audita
(volumen alto).

2.4.3 Postcondiciones de fallo
------------------------------

- EX-01 (401), EX-02 (403), EX-03 (400 bad
  filter), EX-04 (429): rollback no aplica.
