.. _uc-alr-05-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User** o **Admin User** con funcion
  apropiada
- **SubscriptionRepo**

Auth + RBAC + segmento (admin).

::

   POST /api/me/alert-subscriptions/
   body: {
     subscription_type: rule|severity|scope,
     rule_id?, severity?, scope?
   }

   POST /api/users/{user_id}/alert-subscriptions/
     (requiere manage_user_subscriptions)

Response: Subscription completo.
