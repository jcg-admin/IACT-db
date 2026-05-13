.. _uc-rpt-04-parte-10:

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
 * - **P-15**
   - RBAC granular
   - export_reports
 * - **P-39**
   - Audit reforzado
   - QUEUED / COMPLETED / FAILED
 * - **P-44**
   - Visibility audit prio
   - operacion sensitiva
 * - **P-57**
   - Async export with mailbox
   - reuso de UC_PERM_10
 * - **P-58**
   - Segment-bound
   - filtro CNST-008
 * - **P-64** (nuevo)
   - Permission re-check at
     execution
   - permiso re-validado en worker
 * - **P-65** (nuevo)
   - Streaming export
   - cursor + batch para evitar
     memory blow-up

10.2 P-64: Permission re-check
==============================

**Problema**: encolar es sync; ejecucion
puede ser minutos despues. Permisos del
User pueden cambiar en ese intervalo.

**Solucion**: worker re-valida permiso al
inicio (PASO W3). Si revocado, fail
PERMISSION_REVOKED en lugar de exfiltrar
datos a alguien que ya no debe.

10.3 P-65: Streaming export
===========================

**Problema**: cargar 1M filas en memoria
para escribir CSV mata el worker.

**Solucion**: cursor server-side + batch
write (10K filas). Memoria O(batch_size),
no O(total_rows). Valido para todos los
formatos excepto PDF (que tiene su limite
explicito).

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-39
   - PASO 8, W10
 * - P-44
   - audit eventos
 * - P-57
   - PASO 7, W11
 * - P-58
   - PASO W4
 * - P-64
   - PASO W3
 * - P-65
   - PASO W4
