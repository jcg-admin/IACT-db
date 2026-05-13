.. _uc-alr-04-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_ALR_04
 * - **BReq**
   - BReq-006
 * - **Funcion RBAC**
   - ``view_alert_history``

1.1 Proposito
=============

Analizar tendencias: alertas mas frecuentes,
tiempo medio de ack, tiempo medio de
resolve. Insumo para mejorar reglas
(UC_ALR_01) y SLAs.

1.2 Periodo
===========

Hasta 1 ano online. > 1 ano via export
(UC_RPT_04 con archive).

1.3 Restricciones
=================

CNST-008, CNST-009.

1.4 Out of scope
================

- Alertas activas (UC_ALR_02).
