.. _uc-perm-01-parte-05:

==========================
Parte 5 — Excepciones
==========================

.. note::

 Excepciones identicas a UC_ACC_04 Parte 5
 (mismo backend). Esta parte resume y agrega
 excepciones especificas de la vista UI PERM.

5.1 Heredadas de UC_ACC_04
==========================

EX-01..EX-12: token invalido, sin permiso,
user invalido, auto-asignacion (P-11), AGR
no existe / inactivo, SoD violation,
duplicada, BD timeout, audit fail,
throttling, payload invalido.

Status codes y responses identicos.

5.2 Excepciones UI especificas
==============================

5.2.1 EX-PERM-01: Preview falla sin persistir
---------------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - GET preview-only (FA-08)
 * - **Condicion**
   - errores en preview (datos inconsistentes,
     User no existe)
 * - **Response**
   - 400 / 404 segun causa
 * - **AuditEvent**
   - NO se emite (preview no es accion)

5.2.2 EX-PERM-02: Bulk parcial (futuro)
---------------------------------------

Si endpoint bulk implementado, decision por
politica: all-or-nothing total vs continue
on error con reporte. Documentar al
implementar.

5.3 Resumen
===========

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01..12
   - Heredadas UC_ACC_04
   - segun cada una
   - segun cada una
 * - EX-PERM-01
   - Preview error
   - 400/404
   - (sin audit)
 * - EX-PERM-02
   - Bulk parcial
   - segun politica
   - (al implementar)
