.. _uc-alr-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — RBAC ``acknowledge_alerts``.
PASO 4 — Cargar Alert.
PASO 5 — Verificar scope ⊆ segmentos.
PASO 6 — Validar state = firing.
PASO 7 — Atomico:

- UPDATE Alert (state, ack_by, ack_at,
  ack_note).
- AuditService.emit
  ``ALERT_ACKNOWLEDGED``.

PASO 8 — Suprimir notificaciones futuras
de esta alerta (mientras siga
acknowledged).
PASO 9 — 200 OK.

Resumen
=======

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - POST + JWT + RBAC
   - Endpoint
   - 009
 * - 4-5
   - Verificar scope
   - Service
   - 008
 * - 6
   - Validar state
   - Validator
   - —
 * - 7
   - UPDATE atomico + audit
   - Tx
   - 025
 * - 8
   - Suprimir notify
   - NotifyService
   - —
 * - 9
   - 200
   - View
   - —
