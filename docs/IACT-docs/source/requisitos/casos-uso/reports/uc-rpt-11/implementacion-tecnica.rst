.. _uc-rpt-11-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- **ShareEndpoint** (POST/GET/DELETE)
- **ShareValidator**
- **ShareEntryRepo**
- **ShareResolver** (al apply)
- **MailboxService**
- **AuditService**

11.2 Contratos
==============

::

   contract ShareService:
     create(view_id, target, permission,
            expires_at, message,
            invoker, ctx)
       returns: ShareEntryRef
     revoke(share_id, invoker)
     list_sent(invoker)
     list_received(invoker)
     resolve(view_id, invoker)
       returns: ShareEntry | null
       (used by SavedViewService.apply)

11.3 Pseudocodigo (create)
==========================

::

   procedure create_share(view_id, target,
                          permission,
                          expires_at,
                          message,
                          invoker, ctx):
       require AuthorizationGuard.has(
                 invoker, 'share_reports')
       view = SavedViewRepo.get(view_id)
       if view.actor_id != invoker.id:
           raise NotOwner
       ShareValidator.validate_target(
         target)
       if target.id == invoker.id:
           raise SelfShare
       if expires_at and
            expires_at < now():
           raise InvalidExpires

       share = ShareEntry(
         id=uuid_v7(),
         view_id, owner_id=invoker.id,
         target_type=target.type,
         target_id=target.id,
         permission, expires_at,
         created_at=now())
       ShareEntryRepo.save(share)

       AuditService.emit(
         'REPORT_SHARED',
         actor_id=invoker.id,
         target_type='saved_view',
         target_id=view.id,
         payload={
           share_id: share.id,
           target, permission,
           expires_at, message_excerpt})

       targets =
         resolve_recipient_users(target)
       for u in targets:
           if u.preferences.notify_shares:
               MailboxService.notify(
                 user_id=u.id,
                 subject='View shared',
                 body={...})

       return share

11.4 Pseudocodigo (resolve at apply)
====================================

::

   procedure resolve(view_id, invoker):
       active_shares =
         ShareEntryRepo
           .list_active_for_view(
             view_id,
             now())
       for s in active_shares:
           if matches(s, invoker):
               AuditService.emit(
                 'REPORT_SHARE_APPLIED',
                 actor_id=invoker.id,
                 target_type='saved_view',
                 target_id=view_id,
                 payload={share_id: s.id})
               return s
       return null

11.5 Stack-agnostico
====================

- BD: cualquier RDBMS.
- Mailbox: el servicio interno.
