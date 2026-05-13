.. _uc-alr-01-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Cross-segmento bloqueado.
FA-02: Pause / resume sin perder estado.
FA-03: Test rule (dry-run) — backend
ejecuta evaluacion sobre ultimas 24h y
reporta si dispararía. NO crea alertas
reales.
FA-04: Cooldown evita spam (alerta no
re-dispara dentro de cooldown).
FA-05: Action mailbox a User inexistente:
rechazado al crear.

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Cross-segmento
   - 400
   - CNST-008
 * - FA-02
   - Pause
   - paused state
   -
 * - FA-03
   - Test rule
   - dry-run
   - validacion
 * - FA-04
   - Cooldown
   - no re-fire
   -
 * - FA-05
   - Action invalido
   - 400
   - validation
