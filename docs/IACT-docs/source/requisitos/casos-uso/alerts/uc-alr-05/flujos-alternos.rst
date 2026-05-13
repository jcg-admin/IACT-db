.. _uc-alr-05-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Sub duplicada → 409.
FA-02: Cross-segmento (admin
suscribe a User a segmento que User no
tiene) → 400.
FA-03: Mute global: User puede pausar
todas sus subs (preferencia) sin
borrarlas.
FA-04: Onboarding: admin agrega N subs
de un golpe (bulk).
FA-05: Auto-unsub: si usuario pierde
acceso a un segmento, subs relacionadas
auto-pause; mailbox notify.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Duplicada
   - 409
   - idempotencia
 * - FA-02
   - Cross-segmento
   - 400
   - CNST-008
 * - FA-03
   - Mute global
   - paused all
   - preferencia
 * - FA-04
   - Bulk
   - lista
   - onboarding
 * - FA-05
   - Auto-unsub
   - paused
   - segmento revoke
