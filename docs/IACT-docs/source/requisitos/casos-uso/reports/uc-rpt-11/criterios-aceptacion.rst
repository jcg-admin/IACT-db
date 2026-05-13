.. _uc-rpt-11-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Share to user
========================

201 + ShareEntry creado.

9.2 CA-02: Share to AGR
=======================

Todos los Users con AGR pueden aplicar.

9.3 CA-03: Share segment_public
===============================

Todo segmento del owner puede aplicar.

9.4 CA-04: Apply con scope del receptor
=======================================

Receptor con seg_b ve datos seg_b
(no seg_a del owner).

9.5 CA-05: Permission read
==========================

Receptor aplica pero NO clona.

9.6 CA-06: Permission clone
===========================

Receptor clona → vista propia.

9.7 CA-07: Expirado bloquea
===========================

Apply con share expirado → 403.

9.8 CA-08: Revocado bloquea
===========================

Apply con share revocado → 403.

9.9 CA-09: Cascade delete
=========================

Owner borra view → shares borrados.

9.10 CA-10: Receptor sin segmento
=================================

400 USER_WITHOUT_SEGMENT.

9.11 CA-11: Sin permiso 403
===========================

Owner sin share_reports → 403.

9.12 CA-12: Audit completo
==========================

SHARED, REVOKED, APPLIED emitidos.

9.13 CA-13: Mailbox notify
==========================

Receptor recibe mensaje (si preferencia
permite).

9.14 CA-14: NO email externo
============================

CNST-001 verified.

9.15 Resumen
============

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Tipos share
   - Funcional
 * - CA-04
   - Scope receptor
   - Cumplimiento
 * - CA-05..06
   - Permissions
   - Funcional
 * - CA-07..08
   - TTL/revoke
   - Seguridad
 * - CA-09
   - Cascade
   - Robustez
 * - CA-10
   - Sin segmento
   - Robustez
 * - CA-11
   - Sin permiso
   - Seguridad
 * - CA-12
   - Audit
   - Compliance
 * - CA-13..14
   - Notify
   - Cumplimiento
