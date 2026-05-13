.. _uc-perm-06-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre detalle de AGR custom    (Frontend)
   PASO 2   Selecciona functions a agregar +
            functions a quitar + change_reason     (Frontend)
   PASO 3   Modal robusto + preview SoD cascade   (Frontend)
   PASO 4   Confirma                                (Frontend)
   PASO 5   POST /api/access-groups/{id}/
            functions/ (con add_ids + remove_ids)  (FE → BE)
   PASO 6   Validar JWT +
            manage_access_group_composition         (Backend)
   PASO 7   Validar AGR existe + ACTIVE + custom    (Backend → BD)
   PASO 8   Validar functions add/remove existen
            ACTIVE                                   (Backend → BD)
   PASO 9   Filtrar idempotencia (skip ya
            presentes en add, no presentes en
            remove)                                  (Backend → BD)
   PASO 10  Calcular cascade_affected_user_count    (Backend → BD)
   PASO 11  Validar SoD post-cambio para cada
            User con AGR (defensa cascade)           (Backend → BD)
   PASO 12  INSERT AccessGroupFunction (add)         (Backend → BD)
   PASO 13  DELETE AccessGroupFunction (remove)      (Backend → BD)
   PASO 14  Invalidar cache (post-COMMIT)            (Backend)
   PASO 15  AuditEvent
            ACCESS_GROUP_COMPOSITION_CHANGED          (Backend → BD)
   PASO 16  200 OK con resumen + cascade count       (BE → FE)

3.2 Detalle clave
=================

PASO 11 — SoD cascade validation
--------------------------------

::

   for user in users_with_agr:
       new_effective = (user.effective ∪
                       added_functions) -
                      removed_functions
       SoDValidator.validate(new_effective,
                              rules)
       if violated:
           raise CascadeSoDViolation(
             user_id, conflict)

All-or-nothing: si CUALQUIER User violaria
SoD, el cambio se bloquea.

Decision politica:

- Default strict: bloquea cualquier cascade
  violation.
- Setting permissive: permite cambio + lista
  Users en violacion (deben resolverse via
  UC_PERM_01 / UC_ACC_02 individualmente).

PASO 12-13 — Cambios atomicos
-----------------------------

::

   add_pairs = [(agr_id, fid)
                for fid in add_function_ids
                if not existing(agr_id, fid)]
   remove_pairs = [(agr_id, fid)
                   for fid in remove_function_ids
                   if existing(agr_id, fid)]

   AccessGroupFunctionRepository
     .bulk_insert(add_pairs)
   AccessGroupFunctionRepository
     .bulk_delete(remove_pairs)

3.3 Atomicidad
==============

PASOS 12-15 dentro de transaccion atomica.
Cache post-COMMIT (P-29).
