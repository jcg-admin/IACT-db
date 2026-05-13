.. _uc-auth-05-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Estructura backend
=======================

::

   apps/auth_app/
   ├── views/
   │   ├── session_list_view.py        # GET listado
   │   ├── session_detail_view.py      # GET detalle
   │   ├── session_close_view.py       # POST close
   │   └── close_all_sessions_view.py  # POST close-all
   ├── permissions.py                  # HasViewAllSessions, etc.
   ├── filters.py                      # SessionFilter (django-filter)
   ├── serializers/
   │   └── session_serializer.py
   ├── services/
   │   └── session_service.py          # close, close_all
   └── repositories/
       └── session_repository.py

11.2 Permission classes
=======================

.. code-block:: python

   class HasViewAllSessions(BasePermission):
       def has_permission(self, request, view):
           return request.user.is_authenticated and \
               request.user.has_function('view_all_active_sessions')

   class HasCloseUserSession(BasePermission):
       def has_permission(self, request, view):
           return request.user.is_authenticated and \
               request.user.has_function('close_user_session')

   class HasViewOwnSessions(BasePermission):
       def has_permission(self, request, view):
           return request.user.is_authenticated

11.3 SessionListView
====================

.. code-block:: python

   from rest_framework.generics import ListAPIView
   from django_filters.rest_framework import DjangoFilterBackend
   from .permissions import HasViewAllSessions
   from .serializers import SessionSerializer
   from .filters import SessionFilter
   from apps.auth_app.models import Session

   class SessionListView(ListAPIView):
       serializer_class = SessionSerializer
       permission_classes = [HasViewAllSessions]
       filter_backends = [DjangoFilterBackend]
       filterset_class = SessionFilter
       throttle_scope = 'session_list'

       def get_queryset(self):
           qs = Session.objects.select_related('user')
           # default solo ACTIVE si no se especifica state
           if 'state' not in self.request.query_params:
               qs = qs.filter(state='ACTIVE')
           return qs.order_by('-created_at')

       def list(self, request, *args, **kwargs):
           response = super().list(request, *args, **kwargs)
           # FA-05 audit
           target_uid = request.query_params.get('user_id')
           if target_uid:
               AuditEvent.objects.create(
                   event_type='SESSIONS_VIEWED_FOR_USER',
                   actor_user_id=request.user.id,
                   payload={'target_user_id': int(target_uid)})
           return response

11.4 SessionFilter
==================

.. code-block:: python

   import django_filters
   from apps.auth_app.models import Session

   class SessionFilter(django_filters.FilterSet):
       user_id = django_filters.NumberFilter(
           field_name='user_id')
       ip_like = django_filters.CharFilter(
           field_name='client_info__ip',
           lookup_expr='icontains')
       user_agent_like = django_filters.CharFilter(
           field_name='client_info__user_agent',
           lookup_expr='icontains')
       created_after = django_filters.IsoDateTimeFilter(
           field_name='created_at', lookup_expr='gte')
       created_before = django_filters.IsoDateTimeFilter(
           field_name='created_at', lookup_expr='lte')
       state = django_filters.CharFilter(field_name='state')

       class Meta:
           model = Session
           fields = ['state', 'user_id']

11.5 SessionSerializer (sin PII)
================================

.. code-block:: python

   class SessionSerializer(serializers.ModelSerializer):
       username = serializers.CharField(
           source='user.username', read_only=True)

       class Meta:
           model = Session
           fields = [
               'session_id', 'user_id', 'username',
               'state', 'created_at', 'expires_at',
               'closed_at', 'close_reason', 'client_info',
           ]
           # NO incluir email, full_name (CNST-026)

11.6 SessionCloseView
=====================

.. code-block:: python

   from rest_framework.views import APIView
   from .permissions import HasCloseUserSession
   from .services import SessionService

   class SessionCloseView(APIView):
       permission_classes = [HasCloseUserSession]
       throttle_scope = 'session_close'

       def post(self, request, session_id):
           svc = SessionService()
           try:
               result = svc.close(
                   session_id=session_id,
                   admin=request.user,
                   ip=self._client_ip(request),
                   user_agent=request.META.get(
                       'HTTP_USER_AGENT', ''),
                   notify_user=request.data.get(
                       'notify_user',
                       settings.NOTIFY_USER_ON_ADMIN_SESSION_CLOSE))
           except Session.DoesNotExist:
               return Response(
                   {'error': 'SESSION_NOT_FOUND'},
                   status=status.HTTP_404_NOT_FOUND)
           return Response(result, status=200)

11.7 CloseAllSessionsView
=========================

.. code-block:: python

   class CloseAllSessionsView(APIView):
       permission_classes = [HasCloseUserSession]
       throttle_scope = 'session_close'

       def post(self, request, user_id):
           if user_id == request.user.id and not getattr(
                   settings,
                   'ALLOW_ADMIN_SELF_BULK_CLOSE', False):
               return Response(
                   {'error': 'SELF_BULK_CLOSE_FORBIDDEN',
                    'message': 'No puedes cerrar todas tus '
                               'propias sesiones por esta '
                               'via. Usa Cerrar sesion.'},
                   status=400)

           svc = SessionService()
           try:
               result = svc.close_all_for_user(
                   target_user_id=user_id,
                   admin=request.user,
                   notify_user=settings.NOTIFY_USER_ON_ADMIN_SESSION_CLOSE)
           except User.DoesNotExist:
               return Response(
                   {'error': 'USER_NOT_FOUND'},
                   status=404)
           return Response(result, status=200)

11.8 SessionService
===================

.. code-block:: python

   from django.db import transaction
   from django.utils import timezone
   from apps.auth_app.models import (
       Session, BlacklistedToken, AuditEvent,
       InternalMessage, User)

   class SessionService:
       def close(self, session_id, admin, ip='',
                 user_agent='', notify_user=True):
           with transaction.atomic():
               session = (Session.objects
                          .select_for_update()
                          .select_related('user')
                          .filter(session_id=session_id)
                          .first())
               if session is None:
                   raise Session.DoesNotExist

               if session.state == 'CLOSED':
                   AuditEvent.objects.create(
                       event_type='SESSION_CLOSE_NOOP',
                       actor_user_id=admin.id,
                       payload={'target_session_id':
                                str(session_id),
                                'already_closed': True,
                                'original_close_reason':
                                session.close_reason})
                   return {'session_id': str(session_id),
                           'already_closed': True}

               session.state = 'CLOSED'
               session.close_reason = 'ADMIN_REVOKED'
               session.closed_at = timezone.now()
               session.closed_by_admin_id = admin.id
               session.save()

               if session.access_jti:
                   BlacklistedToken.objects.create(
                       jti=session.access_jti,
                       expires_at=session.expires_at,
                       token_type='ACCESS')

               AuditEvent.objects.create(
                   event_type='SESSION_CLOSED',
                   actor_user_id=admin.id,
                   payload={
                       'target_user_id': session.user_id,
                       'target_session_id':
                           str(session_id),
                       'ip': ip,
                       'user_agent': user_agent,
                       'reason': 'ADMIN_REVOKED'})

               if notify_user:
                   InternalMessage.objects.create(
                       recipient=session.user,
                       sender=None,
                       subject='Sesion cerrada por administrador',
                       body=self._notify_body(session))

               return {
                   'session_id': str(session_id),
                   'closed_at':
                       session.closed_at.isoformat(),
                   'close_reason': 'ADMIN_REVOKED',
                   'user_notified': notify_user,
               }

       def close_all_for_user(self, target_user_id, admin,
                               notify_user=True):
           with transaction.atomic():
               user = User.objects.get(id=target_user_id)
               sessions = list(Session.objects
                               .select_for_update()
                               .filter(user=user, state='ACTIVE'))
               count = len(sessions)

               if count == 0:
                   AuditEvent.objects.create(
                       event_type='BULK_SESSION_CLOSE_NOOP',
                       actor_user_id=admin.id,
                       payload={'target_user_id':
                                target_user_id,
                                'sessions_closed': 0})
                   return {'target_user_id': target_user_id,
                           'sessions_closed': 0,
                           'session_ids': []}

               session_ids = []
               for s in sessions:
                   s.state = 'CLOSED'
                   s.close_reason = 'ADMIN_REVOKED'
                   s.closed_at = timezone.now()
                   s.closed_by_admin_id = admin.id
                   s.save()
                   session_ids.append(str(s.session_id))

                   if s.access_jti:
                       BlacklistedToken.objects.create(
                           jti=s.access_jti,
                           expires_at=s.expires_at,
                           token_type='ACCESS')

                   AuditEvent.objects.create(
                       event_type='SESSION_CLOSED',
                       actor_user_id=admin.id,
                       payload={
                           'target_user_id': target_user_id,
                           'target_session_id':
                               str(s.session_id),
                           'reason': 'ADMIN_REVOKED'})

               AuditEvent.objects.create(
                   event_type='BULK_SESSION_CLOSE',
                   actor_user_id=admin.id,
                   payload={'target_user_id':
                            target_user_id,
                            'sessions_closed': count,
                            'session_ids': session_ids})

               if notify_user:
                   InternalMessage.objects.create(
                       recipient=user,
                       sender=None,
                       subject='Todas tus sesiones fueron cerradas',
                       body='Un administrador ha cerrado todas tus '
                            f'sesiones activas ({count}).')

               return {
                   'target_user_id': target_user_id,
                   'sessions_closed': count,
                   'session_ids': session_ids,
               }

       @staticmethod
       def _notify_body(session):
           return (
               'Tu sesion en este dispositivo fue cerrada por '
               'un administrador.\n'
               f'Cliente: {session.client_info.get("user_agent", "")}\n'
               f'Cerrada a las: {session.closed_at.isoformat()}')

11.9 URLs
=========

.. code-block:: python

   urlpatterns = [
       path('sessions/', SessionListView.as_view()),
       path('sessions/own/', OwnSessionsView.as_view()),
       path('sessions/<uuid:session_id>/',
            SessionDetailView.as_view()),
       path('sessions/<uuid:session_id>/close/',
            SessionCloseView.as_view()),
   ]
   # En apps/users/urls.py:
   #   path('<int:user_id>/close-all-sessions/',
   #        CloseAllSessionsView.as_view())

11.10 Settings
==============

.. code-block:: python

   NOTIFY_USER_ON_ADMIN_SESSION_CLOSE = True
   ALLOW_ADMIN_SELF_BULK_CLOSE = False

   REST_FRAMEWORK['DEFAULT_THROTTLE_RATES'].update({
       'session_list': '100/min',
       'session_close': '60/min',
   })

11.11 Frontend
==============

.. code-block:: javascript

   // src/features/admin/sessions/SessionsTable.jsx
   import { useSessions } from './useSessions';

   export function SessionsTable({ filters }) {
     const { data, isLoading } = useSessions(filters);
     // tabla con paginacion, filtros, badge "TU SESION"
     // boton "Cerrar" con modal individual
   }

   // src/features/admin/sessions/useCloseAllSessions.js
   export function useCloseAllSessions() {
     return async (userId, userName) => {
       const ok = await openConfirmModal({
         title: 'Cerrar TODAS las sesiones',
         message: `Esto cerrara TODAS las sesiones de ${userName} `
                  + `inmediatamente. ¿Continuar?`,
         destructive: true, requireDoubleConfirm: true });
       if (!ok) return;
       await api.post(`/users/${userId}/close-all-sessions/`);
       toast.success(`Sesiones cerradas`);
     };
   }
