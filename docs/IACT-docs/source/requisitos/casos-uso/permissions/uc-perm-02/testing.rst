.. _uc-perm-02-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests Given/When/Then. Stack-agnostico.

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad delta
   - Cobertura
 * - Unit
   - 6
   - ≥ 90%
 * - Integration
   - 7
   - sub-flujos UI
 * - E2E
   - 3
   - flujos UI vista PERM

12.2 Tests unitarios especificos PERM
=====================================

12.2.1 RevokePreviewService.preview
-----------------------------------

::

   GIVEN target con AGR-006 ACTIVE (8 functions)
   WHEN  preview(target, agr_id=6)
   THEN  functions_count_to_revoke = 8
   AND   warnings calculadas
   AND   ZERO Assignment cambiado

12.2.2 AGRNotAssigned (CA-PERM-01)
----------------------------------

::

   GIVEN agr_id nunca asignado al target
   WHEN  revoke_access_group
   THEN  raise AGRNotAssigned

12.2.3 Doble confirmacion logica (CA-PERM-03)
---------------------------------------------

::

   GIVEN preview con warnings.critical_revoked
         no vacio
   WHEN  UI procesa
   THEN  modal requiere literal "REVOCAR"

12.2.4 Cache catalogo invalidate
--------------------------------

::

   GIVEN catalogo cached
   WHEN  revoke exitosa
   THEN  AGRViewCache.invalidate llamado

12.2.5 revoke_access_group happy
--------------------------------

::

   GIVEN target con AGR-006 ACTIVE
   WHEN  revoke con reason
   THEN  Assignment AGR state=REVOKED
   AND   AuditEvent AGR_REVOKED
   AND   warnings calculadas

12.2.6 SoD violations resolved tracking
---------------------------------------

::

   GIVEN target con violacion SoD por AGR
   WHEN  revoke ese AGR
   THEN  output incluye flag de
         "violations resolved"

12.3 Tests de integracion
=========================

12.3.1 GET preview-revoke (CA-PERM-04)
--------------------------------------

::

   GIVEN target + agr_id valido
   WHEN  GET preview-revoke
   THEN  status == 200
   AND   ZERO Assignment cambiado
   AND   ZERO AuditEvent

12.3.2 DELETE 200
-----------------

::

   GIVEN invoker con revoke_function_groups
   WHEN  DELETE
   THEN  status == 200
   AND   AuditEvent AGR_REVOKED

12.3.3 AGR no asignado 404 (CA-PERM-01)
---------------------------------------

::

   GIVEN agr nunca asignado
   WHEN  DELETE
   THEN  status == 404 AGR_NOT_ASSIGNED

12.3.4 Sin permiso 403
----------------------

::

   GIVEN invoker sin revoke_function_groups
   WHEN  DELETE
   THEN  status == 403

12.3.5 Auto-revoke 400
----------------------

::

   GIVEN invoker.id == target.id
   WHEN  DELETE
   THEN  status == 400 ALERTA

12.3.6 revoke_reason vacio 400
------------------------------

::

   GIVEN payload sin revoke_reason
   WHEN  DELETE
   THEN  status == 400

12.3.7 Audit unificado ACC/PERM (CA-PERM-06)
--------------------------------------------

::

   GIVEN revocaciones via ambas vistas
   WHEN  inspecciono AuditEvents
   THEN  ambos event_type == 'AGR_REVOKED'

12.4 E2E
========

12.4.1 Admin revoca via vista PERM
----------------------------------

::

   GIVEN admin con revoke_function_groups en
         vista PERM
   WHEN  abre detalle del User en catalogo,
         click "Revocar AGR-006", ingresa
         reason, confirma
   THEN  toast confirma
   AND   catalogo refleja count -1

12.4.2 Modal con doble confirmacion
-----------------------------------

::

   GIVEN preview detecta warnings criticos
   WHEN  click "Revocar"
   THEN  modal pide escribir "REVOCAR"
   AND   sin escribir literal, boton
         deshabilitado

12.4.3 Boton oculto sin permiso
-------------------------------

::

   GIVEN invoker sin revoke_function_groups
   WHEN  abre detalle del User
   THEN  boton "Revocar AGR" no visible

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - RevokePreviewService
   - 100%
   - 100%
 * - AGRViewCache
   - ≥ 90%
   - ≥ 85%
 * - HTTPPreviewRevokeEndpoint
   - ≥ 90%
   - ≥ 85%

Backend: cobertura heredada de UC_ACC_02.
