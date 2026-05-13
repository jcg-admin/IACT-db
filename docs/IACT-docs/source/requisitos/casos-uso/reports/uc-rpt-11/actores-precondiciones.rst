.. _uc-rpt-11-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **Owner User con funcion**
  ``share_reports``
- **Receptor** (User / AGR target)
- **MailboxService**
- **AuditService**

2.2 Precondiciones
==================

- Owner autenticado + ``share_reports``.
- SavedView existe y owner es el
  ``actor_id``.
- Receptor existe (User valido o AGR
  valido).

2.3 Postcondiciones
===================

- ShareEntry creado.
- Mailbox notify a receptor(es).
- Audit ``REPORT_SHARED`` con detalle.

2.4 Datos de entrada
====================

::

   POST /api/me/views/{view_id}/shares/
   body: {
     target_type: "user" | "agr" |
                  "segment_public",
     target_id: int | string,
     permission: "read" | "clone",
     message?: string,
     expires_at?: timestamp
   }

2.5 Datos de salida
===================

::

   {
     share_id, view_id,
     target_type, target_id,
     permission, expires_at,
     created_at
   }
