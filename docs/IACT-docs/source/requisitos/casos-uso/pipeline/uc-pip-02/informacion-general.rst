.. _uc-pip-02-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_PIP_02
 * - **BReq**
   - BReq-005, BReq-006
 * - **Funcion RBAC**
   - ``view_etl_errors``

1.1 Proposito
=============

Diagnosticar pipelines fallados.
Stack trace, error code, payload muestra
(sin PII), correlation id para tracing.

1.2 Restricciones
=================

CNST-009. Stack traces pueden contener
informacion sensible — sanitizar.

1.3 Out of scope
================

- Reintento (UC_PIP_04).
