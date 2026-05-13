.. _uc-rpt-17-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_17
 * - **Nombre**
   - Reporte de Clientes Unicos
 * - **BReq**
   - BReq-001, BReq-003
 * - **Funcion RBAC**
   - ``view_unique_clients_reports``

1.2 Proposito
=============

Medir alcance: cuantos clientes distintos
nos contactaron, cuantos son recurrentes,
distribucion de frecuencia. Util para
campanas inbound y dimensionamiento.

1.3 Identificador del cliente
=============================

CNST-026 sin PII: el reporte identifica
clientes via **hash** de su identificador
(telefono / cliente_id):

::

   client_hash = sha256(client_id +
                          tenant_salt)

Hash determinístico permite contar
distincts y recurrencias sin exponer PII.

1.4 Metricas
============

- Distinct clients en periodo
- Avg calls per client
- Recurrencia distribution
  (1, 2, 3+ calls)
- New vs returning (vs periodo prior)
- Top 10 clients por volumen
  (mostrados solo como hash + count, no
  identificable)

1.5 Restricciones
=================

CNST-007, CNST-008, CNST-009, CNST-026.

1.6 Out of scope
================

- Re-identificar clientes (PII).
- Listas de clientes (operacional).
