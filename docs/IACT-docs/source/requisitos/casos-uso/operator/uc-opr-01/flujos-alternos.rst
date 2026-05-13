.. _uc-opr-01-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Auto-state busy en llamada
=================================

UC_OPR_02 al atender → estado busy
automatico, sin invocar UC_OPR_01.

FA-02: Auto-ACW al colgar
=========================

Llamada termina → after_call_work
automatico (politica wrap-up time
configurable).

FA-03: Forced offline por inactividad
=====================================

Agente sin actividad > N min en
available → auto-offline + mailbox
notify.

FA-04: Break no autorizado
==========================

Politica organizacional: solo X breaks
de Y minutos. Si excede, transicion
break rechazada o auto-pause.

FA-05: Reason obligatoria en training
=====================================

Para training, reason debe referenciar
ID de curso / sesion.

FA-06: Logout de sesion
=======================

Logout (UC_AUTH_02) implícitamente
fuerza estado offline.

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Llamada
   - busy auto
   - sin manual
 * - FA-02
   - Hangup
   - ACW auto
   - wrap-up
 * - FA-03
   - Inactivo
   - offline forzado
   - mailbox
 * - FA-04
   - Break excedido
   - rechazado
   - politica
 * - FA-05
   - Training
   - reason ID curso
   -
 * - FA-06
   - Logout
   - offline
   - cascade
