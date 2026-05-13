.. _uc-alr-04-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **Alert** (state ∈ {resolved, closed}).

7.2 Indices
===========

- ``Alert(state, fired_at DESC)``.
- ``Alert(rule_id, fired_at DESC)``.

7.3 Aging
=========

- > 90 dias → archive partition.
- > 1 ano → cold storage (export only).
