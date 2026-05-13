.. _uc-rpt-11-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Receptor sin segmento
================================

Receptor recibe el share pero no tiene
segmento → al aplicar, vista falla con
USER_WITHOUT_SEGMENT.

4.2 FA-02: Receptor con scope distinto
======================================

Owner es supervisor de seg_a, receptor de
seg_b. Receptor aplica vista → datos solo
de seg_b. Vista misma estructura, pero
contenido diferente (cada quien con su
scope).

4.3 FA-03: Share a AGR
======================

target_type=agr → todos los Users con
ese AGR ACTIVE pueden ver. Si User es
revocado del AGR, pierde acceso (sin
borrar el share).

4.4 FA-04: Share expira
=======================

expires_at pasado → ShareEntry inactivo;
aplicar da 403 expired.

4.5 FA-05: Owner borra view
===========================

ON DELETE CASCADE: shares relacionados se
borran. Receptor pierde acceso. Notificacion
en mailbox.

4.6 FA-06: Permission clone
===========================

Receptor con clone hace POST clone →
nueva vista propia. Original share
sigue.

4.7 FA-07: Notify settings del receptor
=======================================

Si receptor desactivo notificaciones de
shares (preferencia), share se crea pero
NO mailbox. Audit lo registra de cualquier
forma.

4.8 Resumen
===========

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin segmento
   - error apply
   - degradado
 * - FA-02
   - Scope distinto
   - aplica con SU scope
   - CNST-008
 * - FA-03
   - Target AGR
   - todos los con AGR
   - dinamico
 * - FA-04
   - Expirado
   - 403
   - revocacion temporal
 * - FA-05
   - Owner borra view
   - cascade delete
   - notify
 * - FA-06
   - Clone permission
   - copia
   - convenience
 * - FA-07
   - Receptor mute
   - no mailbox
   - preferencia
