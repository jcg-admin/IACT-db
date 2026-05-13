.. _uc-opr-01-parte-10:

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
 * - **P-09**
   - Audit-or-abort
   - INSERT history en tx
 * - **P-32**
   - Reason-required
   - break / training
 * - **P-39**
   - Audit reforzado
   - HR/adherence
 * - **P-82** (nuevo)
   - State-machine validated
     transitions
   - solo transiciones del
     diagrama estado son
     aceptadas

10.2 P-82: State-machine validated
==================================

**Problema**: estado libre permite
``training → busy`` sin pasar por
available, lo cual rompe routing.

**Solucion**: validador rechaza
transiciones no listadas en 1.3 con
409 INVALID_STATE_TRANSITION.

Trazabilidad
============

- P-09: PASO 5
- P-32: PASO 3
- P-39: NFR
- P-82: PASO 3 + CA-05
