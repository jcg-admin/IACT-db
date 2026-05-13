.. _uc-opr-03-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Agente con ``initiate_outbound_call``.
- TelephonyClient.
- CampaignRepo / CallbackQueue.

::

   POST /api/me/calls/outbound/
   body: {
     destination: phone (hashed o raw
                  policy-dependent),
     campaign_id?,
     callback_id?,
     mode: manual|preview|auto
   }
