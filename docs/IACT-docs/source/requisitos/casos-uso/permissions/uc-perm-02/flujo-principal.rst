.. _uc-perm-02-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo (vista PERM)
==================================

::

   PASO 1   Invoker abre detalle de User en
            vista PERM o catalogo               (Frontend)
   PASO 2   Identifica AGR a revocar             (Frontend)
   PASO 3   Click "Revocar AGR" + ingresa
            revoke_reason                         (Frontend)
   PASO 4   Modal con composicion + warnings     (Frontend)
   PASO 5   Confirma (con doble check si
            warnings criticos)                    (Frontend)
   PASO 6   DELETE /api/users/{id}/
            access-groups/{agr_id}/               (FE → BE)
   ── flujo backend identico a UC_ACC_02
      sobre target_type=AGR ──
   PASO 7   Validar JWT + revoke_function_groups
   PASO 8   Validar User + Assignment AGR existe
   PASO 9   Calcular post-revoke + warnings
   PASO 10  UPDATE Assignment → REVOKED
   PASO 11  Cache invalidate post-COMMIT
   PASO 12  AuditEvent AGR_REVOKED
   PASO 13  (Opcional) InternalMessage
   PASO 14  200 OK con resumen + warnings
   ── retorno UI ──
   PASO 15  Refresh catalogo (counts -1)         (Frontend)

3.2 Diferencias clave de la vista PERM
======================================

PASO 4 — Modal con composicion expandida
----------------------------------------

A diferencia de UC_ACC_02 que muestra solo
"Revocar AGR-006 de Ana", la vista PERM
expande:

::

   "Vas a revocar el AGR 'user_admin_group'
    de 'ana.gomez.0001'. Esto eliminara las
    siguientes 8 capacidades (efectivas):
    - create_users
    - modify_users
    - ...

    Tras la revocacion, el User quedara con
    {N} funciones efectivas restantes.

    Warnings detectadas: {warnings}.

    Confirmas?"

PASO 5 — Doble confirmacion si warnings
---------------------------------------

Si ``warnings.critical_revoked`` no vacio,
modal pide escribir "REVOCAR" literal.

PASO 15 — Refresh catalogo
--------------------------

Vista PERM actualiza:

- Count de Users del AGR decrementado.
- Coverage RBAC del User actualizado en
  vista efectiva (UC_ACC_03).

3.3 Atomicidad
==============

Identica a UC_ACC_02 (transaccion ACID en
PASOS backend 10-12).
