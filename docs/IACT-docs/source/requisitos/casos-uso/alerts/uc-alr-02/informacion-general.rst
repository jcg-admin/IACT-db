.. _uc-alr-02-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_ALR_02
 * - **BReq**
   - BReq-006
 * - **Funcion RBAC**
   - ``view_active_alerts``

1.2 Proposito
=============

Mostrar al supervisor las alertas
abiertas, ordenadas por severidad +
recencia. Permite triage rapido + accion
desde la UI (acknowledge, escalate).

1.3 Estados
===========

- ``firing``: regla disparo, no ack.
- ``acknowledged``: alguien la reconocio
  (UC_ALR_03).
- ``resolved``: condicion volvio a
  normal.
- ``closed``: fuera del scope de "activas".

1.4 Auto-refresh
================

10s default (mas frecuente que UC_RPT_01
porque es operacional inmediato).

1.5 Restricciones
=================

CNST-008, CNST-009.

1.6 Out of scope
================

- Acknowledge (UC_ALR_03).
- Historial (UC_ALR_04).
- Suscripciones (UC_ALR_05).
