.. _uc-aud-02-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_AUD_02
 * - **BReq**
   - BReq-004
 * - **Funcion RBAC**
   - ``search_audit``

1.1 Proposito
=============

Investigar incidentes via search libre.
Backend usa motor full-text (Elasticsearch
/ Postgres FTS / similar) sobre payload
indexado.

1.2 Restricciones
=================

CNST-008, CNST-009, CNST-025, CNST-026.
Required: date range para evitar full
table scans.

1.3 Out of scope
================

- Listado timeline (UC_AUD_01).
