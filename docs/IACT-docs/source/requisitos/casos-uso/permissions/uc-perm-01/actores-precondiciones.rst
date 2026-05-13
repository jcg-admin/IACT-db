.. _uc-perm-01-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``assign_function_groups``
(misma que UC_ACC_04). Tipica audiencia desde
vista PERM:

- Admin de seguridad (governance, no
  operacion diaria).
- Compliance officer realizando reviews.
- Auditor con privilegio extendido para
  remediar findings.

P-15 RBAC granular: la misma funcion canonica
es accedida desde multiples vistas UI.

2.2 Actores Secundarios
=======================

Identicos a UC_ACC_04:

- User destino (receptor pasivo).
- Sistema (validar, persistir, notificar).
- BD MySQL (atomicidad).
- Auditor (consume AuditEvent AGR_ASSIGNED).

Actor adicional especifico de la vista PERM:

- **Admin de catalogo RBAC**: usa la vista
  PERM como punto de entrada para diagnosticar
  estructura del modelo (composicion AGRs vs
  composicion efectiva por User).

2.3 Precondiciones
==================

Identicas a UC_ACC_04:

- Backend respondiendo, BD accesible, HTTPS,
  invocante con
  ``assign_function_groups``, User destino
  valido, AGR existe + ACTIVE, SoD compliance
  del set efectivo resultante.

2.4 Postcondiciones
===================

Identicas a UC_ACC_04 (mismos artefactos
producidos: Assignment AGR, AuditEvent
AGR_ASSIGNED, InternalMessage opcional, cache
invalidate).

**Diferencia vista PERM**: la UI puede mostrar
post-asignacion una vista de **catalogo
actualizada** (composicion del AGR + counts de
Users que lo tienen, etc.). Esa vista es
adicional en el frontend; backend no cambia.
