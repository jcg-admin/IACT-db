.. _uc-rpt-11-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - share_reports
 * - **P-44**
   - Visibility audit prio
   - share + apply
 * - **P-58**
   - Segment-bound
   - receptor con SU scope
 * - **P-71** (nuevo)
   - Receiver-scoped data on
     shared view
   - estructura compartida,
     datos por scope receptor
 * - **P-72** (nuevo)
   - Internal-channel
     notification
   - mailbox no email
     (CNST-001/002)

10.2 P-71: Receiver-scoped data
===============================

**Problema**: si receptor ve datos del
owner, se viola CNST-008 (cross-segmento).

**Solucion**: la vista comparte ESTRUCTURA
(filtros, columns, layout) pero los datos
se calculan con el segmento DEL RECEPTOR.

Cada usuario ve la misma vista con sus
datos. Caso comun: supervisor regional
comparte template con leads de otras
regiones.

10.3 P-72: Internal-channel notification
========================================

**Problema**: las notificaciones de share
podrían usar email para alcance, pero
CNST-001 lo prohibe.

**Solucion**: mailbox interno (CNST-002).
Receptor ve notificaciones al login.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-44
   - audit eventos
 * - P-58
   - PASO apply, FA-02
 * - P-71
   - CA-04
 * - P-72
   - PASO 7, NFR 6.6
