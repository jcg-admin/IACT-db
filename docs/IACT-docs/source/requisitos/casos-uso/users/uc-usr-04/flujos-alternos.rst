.. _uc-usr-04-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Cancelar antes de confirmar
======================================

**Activador**: PASO 4 — admin clickea
"Cancelar" en el modal o cierra el dialog sin
escribir "ELIMINAR".

**Diferencia**: NO se envia DELETE request al
backend. Cero efectos en BD.

**Postcondicion**: User intacto. Sin
AuditEvent.

4.2 FA-02: Doble eliminacion (idempotente)
==========================================

**Activador**: PASO 7 — User ya tiene
``state='ELIMINATED'``.

**Justificacion**: idempotencia. El admin
intento eliminar dos veces (replay de red, doble
click), o concurrencia con otro admin.

**Comportamiento (politica idempotente —
default)**:

::

   PASO 7A (FA-02)  Backend detecta state ya
                    ELIMINATED. NO sobreescribe
                    eliminated_at ni
                    eliminated_by_admin_id
                    originales.

   PASO 14A         AuditEvent
                    USER_ELIMINATE_NOOP con
                    payload {already_eliminated:
                    true,
                    original_eliminated_at,
                    original_eliminated_by}.

   PASO 15A         200 OK con body
                    {"message": "Usuario ya
                    estaba eliminado",
                    "original_eliminated_at":
                    "..."}.

**Comportamiento alternativo (politica strict)**:

- Setting ``STRICT_ELIMINATION=true`` —
  retorna 409 CONFLICT con mensaje "Usuario ya
  fue eliminado".

4.3 FA-03: User con Sessions = 0 y Assignments = 0
==================================================

**Activador**: PASO 11 — el User no tiene
Sessions activas (caso comun cuando admin
ya bloqueo previamente). PASO 10 — User sin
Assignments activos.

**Diferencia**: PASO 11 / PASO 12 / PASO 10 no
ejecutan UPDATE masivo (cero filas afectadas).
AuditEvent payload incluye
``sessions_closed_count=0`` y/o
``assignments_revoked_count=0``.

**Postcondicion**: idem flujo principal pero
con contadores en cero. No es error.

4.4 FA-04: Eliminar desde state INACTIVE / BLOCKED
==================================================

**Activador**: PASO 9 — User actual con
``state='INACTIVE'`` o ``'BLOCKED'``.

**Diferencia**: ninguna en el procesamiento.
``prior_state`` en AuditEvent payload registra
el estado de origen para correlacion.

4.5 FA-05: Notificacion suprimida
=================================

**Activador**: setting
``NOTIFY_USER_ON_ELIMINATION=false``.

**Diferencia**: PASO 13 omitido. AuditEvent
payload incluye ``user_notified=false``.

**Justificacion**: politicas algunas
organizaciones eliminan sin notificar (p.ej.
casos de seguridad).

4.6 FA-06: Eliminacion con InternalMessages pendientes
======================================================

**Activador**: el User tiene mensajes en su
``InternalMailbox`` no leidos (incluyendo el
mensaje de bienvenida UC_USR_01 y eventuales
notificaciones de UC_AUTH_03).

**Diferencia**: los mensajes NO se borran.
Permanecen referenciados al user_id ELIMINATED.
Justificacion: integridad referencial +
preservacion de evidencia.

**Postcondicion**: si politica activa
``user_notified=true`` agrega un mensaje mas
(notificando la eliminacion). El usuario no
podra leerlos (no puede iniciar sesion); pero
quedan disponibles para auditoria via
UC_AUD_*.

4.7 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - Cancelar antes de confirmar
   - Sin request al backend
   - n/a
 * - FA-02
   - User ya ELIMINATED (idempotente)
   - SESSION_CLOSE_NOOP equivalente
   - 200 OK / 409 segun politica
 * - FA-03
   - User sin Sessions / Assignments
   - Contadores en 0
   - 200 OK
 * - FA-04
   - Origen INACTIVE / BLOCKED
   - prior_state en audit
   - 200 OK
 * - FA-05
   - Politica notify=false
   - Sin InternalMessage
   - 200 OK
 * - FA-06
   - User con mensajes en buzon
   - Mensajes preservados
   - 200 OK
