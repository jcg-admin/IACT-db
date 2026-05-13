.. _uc-pip-04-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_PIP_04
 * - **BReq**
   - BReq-005
 * - **Funcion RBAC**
   - ``request_pipeline_retry``

1.1 Proposito
=============

Operador / data engineer puede solicitar
reintento de un pipeline failed, sin
esperar siguiente schedule. Importante
para recovery de errores transitorios.

1.2 Restricciones
=================

- CNST-009.
- CNST-013, CNST-025.
- Operacion sensitiva: P-39 audit
  reforzado + reason obligatoria.

1.3 Out of scope
================

- Crear pipelines (operacional).
