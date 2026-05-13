.. _uc-perm-03-parte-12:

==========================
Parte 12 — Testing
==========================

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad delta
   - Cobertura
 * - Unit
   - 5
   - ≥ 90%
 * - Integration
   - 6
   - sub-flujos UI
 * - E2E
   - 3
   - flujos UI

12.2 Tests unitarios especificos PERM
=====================================

12.2.1 GrantPreviewService.preview
----------------------------------

::

   GIVEN target + functions + expires_at
   WHEN  preview
   THEN  GrantPreview con
         estimated_sod_violations,
         duration_days, warnings
   AND   ZERO ExceptionalPermission

12.2.2 Preview NO persiste (CA-PERM-01)
---------------------------------------

::

   GIVEN preview ejecutado
   WHEN  inspecciono BD
   THEN  ZERO Permission, ZERO Audit

12.2.3 Preview detecta SoD violations
-------------------------------------

::

   GIVEN funcion en conflicto
   WHEN  preview
   THEN  estimated_sod_violations > 0
   AND   warnings con regla SoD

12.2.4 Cache catalogo invalidate post-grant
-------------------------------------------

::

   GIVEN catalogo cached
   WHEN  grant exitoso
   THEN  FunctionCatalogCache.invalidate

12.2.5 Modal warning visible (CA-PERM-02)
-----------------------------------------

Test UI: modal contiene texto "high-priority
audit".

12.3 Integracion
================

12.3.1 GET preview 200 (CA-PERM-01)
-----------------------------------

::

   GIVEN payload valido
   WHEN  GET preview
   THEN  status == 200
   AND   ZERO persistence

12.3.2 POST 201 (CA-01 heredado)
--------------------------------

::

   GIVEN invoker con
         grant_exceptional_permission
   WHEN  POST con payload completo
   THEN  status == 201

12.3.3 Audit unificado (CA-PERM-04)
-----------------------------------

::

   GIVEN grant via vista PERM
   THEN  AuditEvent.event_type ==
         EXCEPTIONAL_PERMISSION_GRANTED

12.3.4 Mailbox HARD rollback (CA heredado)
------------------------------------------

::

   GIVEN mailbox falla
   WHEN  POST
   THEN  500 + rollback

12.3.5 Auto-grant 400 (CA heredado)
-----------------------------------

::

   GIVEN invoker == target
   WHEN  POST
   THEN  status == 400 ALERTA CRITICA

12.3.6 Throttling 429 estricto
------------------------------

::

   GIVEN > 10 grants/hora
   WHEN  POST
   THEN  status == 429

12.4 E2E
========

12.4.1 Admin de seguridad otorga via PERM
-----------------------------------------

::

   GIVEN admin con la funcion en vista PERM
   WHEN  selecciona functions, expires_at,
         escribe justification con TKT,
         confirma en modal con warning audit
   THEN  toast confirma
   AND   target recibe InternalMessage

12.4.2 Modal con warning de high-priority audit
-----------------------------------------------

::

   GIVEN modal de confirmacion abre
   WHEN  invoker visualiza
   THEN  banner "esta operacion sera
         auditada con visibilidad alta"

12.4.3 Preview muestra SoD warnings
-----------------------------------

::

   GIVEN invoker selecciona funcion con SoD
         conflict
   WHEN  abre preview
   THEN  modal muestra regla SoD afectada

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - GrantPreviewService
   - 100%
   - 100%
 * - FunctionCatalogCache
   - ≥ 90%
   - ≥ 85%
 * - HTTPPreviewExcEndpoint
   - ≥ 90%
   - ≥ 85%
