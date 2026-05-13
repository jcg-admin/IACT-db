.. _uc-rpt-11-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_11
 * - **Funcion RBAC**
   - ``share_reports``
 * - **BReq**
   - BReq-001, BReq-007

1.2 Proposito
=============

Permitir colaboracion: supervisor define
una vista util, comparte con su equipo;
cada User aplica la vista con su propio
scope de datos.

1.3 Tipos de share
==================

(a) **User-to-User**: target = user_id
    de otro User.
(b) **User-to-AGR**: target = AGR; todos
    los Users con ese AGR pueden ver la
    vista compartida.
(c) **Public** (en alcance del segmento):
    visible a todo el segmento del owner.

1.4 Permisos del receptor
=========================

- **read**: aplicar la vista (default).
- **clone**: read + clonar como propia.

NO se permite ``edit`` directo — el
receptor edita su clone.

1.5 Restricciones
=================

- CNST-001: NO email externo. Mailbox
  notify (CNST-002).
- CNST-008: el receptor aplica con SU
  segmento; nunca ve datos cross-segmento
  del owner.
- CNST-013: excepciones estandar.
- CNST-025: audit del share.

1.6 Out of scope
================

- Forwarding del share por receptor (NO
  se permite — share viene del owner).
- External recipient (CNST-001).
