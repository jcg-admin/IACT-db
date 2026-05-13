.. _uc-perm-02-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 Heredadas de UC_ACC_02
==========================

- EX-01 Token invalido (401)
- EX-02 Sin ``revoke_function_groups`` (403,
  AuditEvent UNAUTHORIZED ALERTA)
- EX-03 User no existe (404)
- EX-04 Auto-revocacion P-11 (400 ALERTA)
- EX-05 User ELIMINATED (400)
- EX-06 Payload invalido / revoke_reason
  vacio (400)
- EX-07 BD timeout (503)
- EX-08 Audit fail (500)
- EX-09 Last holder protection si politica
  strict (409)
- EX-10 Throttling (429)

5.2 Especificas vista PERM
==========================

5.2.1 EX-PERM-01: AGR no asignado al User
-----------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 8
 * - **Condicion**
   - el ``agr_id`` no tiene Assignment
     ACTIVE para el User (nunca fue asignado
     o ya REVOKED)
 * - **Response**
   - 404 AGR_NOT_ASSIGNED (404 distinta de
     EX-03 USER_NOT_FOUND)

5.3 Resumen
===========

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01..10
   - Heredadas UC_ACC_02
   - segun cada uno
   - segun cada uno
 * - EX-PERM-01
   - AGR no asignado
   - 404
   - (sin audit)
