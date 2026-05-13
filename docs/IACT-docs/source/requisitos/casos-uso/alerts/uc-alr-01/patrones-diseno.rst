.. _uc-alr-01-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - manage_alert_thresholds
 * - **P-39**
   - Audit reforzado
   - cambios CRUD
 * - **P-58**
   - Segment-bound
   - scope ⊆ segmento
 * - **P-72**
   - Internal-channel
     notification
   - mailbox no email
 * - **P-77** (nuevo)
   - Dry-run before commit
   - test rule contra
     historico antes de
     activar
 * - **P-78** (nuevo)
   - Cooldown to suppress
     storms
   - cooldown_minutes evita
     spam de alertas

10.2 P-77: Dry-run
==================

**Problema**: una regla mal configurada
puede inundar mailbox con falsos positivos
o silenciar real issues.

**Solucion**: endpoint dry-run evalua la
regla contra historico (ultimas 24h) sin
disparar acciones. Reporta cuantas veces
habria disparado. Owner ajusta antes de
activar.

10.3 P-78: Cooldown
===================

**Problema**: si la metrica oscila cerca
del umbral, alerta se dispara repetidamente.
Stress operacional.

**Solucion**: cooldown_minutes despues de
disparo: silencia re-fires hasta que
expira. Trade-off: pierde alertas
intermedias pero el operador no ignora la
ventana.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-39
   - audit cambios
 * - P-58
   - PASO 4, FA-01
 * - P-72
   - actions = mailbox
 * - P-77
   - FA-03
 * - P-78
   - cooldown field
