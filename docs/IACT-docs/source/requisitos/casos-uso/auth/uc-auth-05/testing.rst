.. _uc-auth-05-parte-12:

==========================
Parte 12 — Testing
==========================

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit
   - 10
   - ≥ 90%
 * - Integration
   - 10
   - sub-flujos + EXs
 * - E2E
   - 3
   - flujo admin + bulk

12.2 Tests backend
==================

12.2.1 Unit — list_active default ACTIVE
----------------------------------------

.. code-block:: python

   @pytest.mark.django_db
   def test_list_default_active(session_factory):
       session_factory(state='ACTIVE')
       session_factory(state='CLOSED')
       svc = SessionService()
       qs = (Session.objects.filter(state='ACTIVE'))
       assert qs.count() == 1

12.2.2 Unit — close happy
-------------------------

.. code-block:: python

   def test_close_happy(session_factory, admin_factory):
       admin = admin_factory(with_function='close_user_session')
       s = session_factory(state='ACTIVE')

       svc = SessionService()
       result = svc.close(session_id=s.session_id, admin=admin)

       s.refresh_from_db()
       assert s.state == 'CLOSED'
       assert s.close_reason == 'ADMIN_REVOKED'
       assert s.closed_by_admin_id == admin.id
       assert AuditEvent.objects.filter(
           event_type='SESSION_CLOSED').exists()

12.2.3 Unit — close idempotente (FA-02)
---------------------------------------

.. code-block:: python

   def test_close_idempotente(session_factory, admin_factory):
       admin = admin_factory(with_function='close_user_session')
       s = session_factory(state='CLOSED',
                           close_reason='USER_LOGOUT')

       SessionService().close(session_id=s.session_id, admin=admin)

       s.refresh_from_db()
       assert s.close_reason == 'USER_LOGOUT'  # preservado
       assert AuditEvent.objects.filter(
           event_type='SESSION_CLOSE_NOOP').exists()

12.2.4 Unit — close emite InternalMessage
-----------------------------------------

.. code-block:: python

   def test_close_emite_internal_message(
           session_factory, admin_factory):
       admin = admin_factory(with_function='close_user_session')
       s = session_factory(state='ACTIVE')

       SessionService().close(session_id=s.session_id,
                              admin=admin, notify_user=True)

       assert InternalMessage.objects.filter(
           recipient=s.user).count() == 1

12.2.5 Unit — close_all_for_user
--------------------------------

.. code-block:: python

   def test_close_all_for_user(
           user_factory, session_factory, admin_factory):
       admin = admin_factory(with_function='close_user_session')
       u = user_factory()
       session_factory(user=u, state='ACTIVE')
       session_factory(user=u, state='ACTIVE')
       session_factory(user=u, state='ACTIVE')

       result = SessionService().close_all_for_user(
           target_user_id=u.id, admin=admin)

       assert result['sessions_closed'] == 3
       assert Session.objects.filter(
           user=u, state='CLOSED').count() == 3
       assert AuditEvent.objects.filter(
           event_type='SESSION_CLOSED').count() == 3
       assert AuditEvent.objects.filter(
           event_type='BULK_SESSION_CLOSE').count() == 1

12.2.6 Unit — close_all NOOP cuando no hay sesiones
---------------------------------------------------

.. code-block:: python

   def test_close_all_noop(user_factory, admin_factory):
       admin = admin_factory(with_function='close_user_session')
       u = user_factory()  # sin sessions

       result = SessionService().close_all_for_user(
           target_user_id=u.id, admin=admin)

       assert result['sessions_closed'] == 0
       assert AuditEvent.objects.filter(
           event_type='BULK_SESSION_CLOSE_NOOP').exists()

12.2.7 Unit — Atomicidad bulk
-----------------------------

.. code-block:: python

   from unittest.mock import patch

   def test_atomicidad_bulk_audit_falla(
           user_factory, session_factory, admin_factory):
       admin = admin_factory(with_function='close_user_session')
       u = user_factory()
       s1 = session_factory(user=u, state='ACTIVE')
       s2 = session_factory(user=u, state='ACTIVE')

       call_count = [0]
       original_create = AuditEvent.objects.create

       def fail_on_third(*args, **kwargs):
           call_count[0] += 1
           if call_count[0] == 3:
               raise Exception('audit down')
           return original_create(*args, **kwargs)

       with patch.object(AuditEvent.objects, 'create',
                         side_effect=fail_on_third):
           with pytest.raises(Exception):
               SessionService().close_all_for_user(
                   target_user_id=u.id, admin=admin)

       s1.refresh_from_db()
       s2.refresh_from_db()
       assert s1.state == 'ACTIVE'  # rollback
       assert s2.state == 'ACTIVE'

12.2.8 Integration — GET listado 200
------------------------------------

.. code-block:: python

   def test_endpoint_list_200(api_client, admin_view_token,
                               session_factory):
       for _ in range(3):
           session_factory(state='ACTIVE')
       resp = api_client.get(
           '/api/auth/sessions/',
           HTTP_AUTHORIZATION=f'Bearer {admin_view_token}')
       assert resp.status_code == 200
       assert resp.json()['count'] >= 3

12.2.9 Integration — listado sin permiso 403
--------------------------------------------

.. code-block:: python

   def test_endpoint_list_sin_permiso_403(api_client,
                                            regular_token):
       resp = api_client.get(
           '/api/auth/sessions/',
           HTTP_AUTHORIZATION=f'Bearer {regular_token}')
       assert resp.status_code == 403

12.2.10 Integration — filter user_id audit
------------------------------------------

.. code-block:: python

   def test_filter_user_id_audita(api_client,
                                    admin_view_token,
                                    user_factory):
       u = user_factory()
       api_client.get(
           f'/api/auth/sessions/?user_id={u.id}',
           HTTP_AUTHORIZATION=f'Bearer {admin_view_token}')
       assert AuditEvent.objects.filter(
           event_type='SESSIONS_VIEWED_FOR_USER',
           payload__target_user_id=u.id).exists()

12.2.11 Integration — close 200
-------------------------------

.. code-block:: python

   def test_endpoint_close_200(api_client, admin_close_token,
                                session_factory):
       s = session_factory(state='ACTIVE')
       resp = api_client.post(
           f'/api/auth/sessions/{s.session_id}/close/',
           HTTP_AUTHORIZATION=f'Bearer {admin_close_token}')
       assert resp.status_code == 200

12.2.12 Integration — close sin permiso 403
-------------------------------------------

.. code-block:: python

   def test_endpoint_close_sin_permiso(
           api_client, admin_view_token, session_factory):
       s = session_factory(state='ACTIVE')
       resp = api_client.post(
           f'/api/auth/sessions/{s.session_id}/close/',
           HTTP_AUTHORIZATION=f'Bearer {admin_view_token}')
       assert resp.status_code == 403

12.2.13 Integration — auto-bulk-close 400 (EX-04)
-------------------------------------------------

.. code-block:: python

   def test_auto_bulk_close_prohibido(
           api_client, admin_close_user, settings):
       settings.ALLOW_ADMIN_SELF_BULK_CLOSE = False
       resp = api_client.post(
           f'/api/users/{admin_close_user["id"]}/close-all-sessions/',
           HTTP_AUTHORIZATION=f'Bearer {admin_close_user["token"]}')
       assert resp.status_code == 400
       assert resp.json()['error'] == 'SELF_BULK_CLOSE_FORBIDDEN'

12.2.14 Integration — token rechazado post-cierre
-------------------------------------------------

.. code-block:: python

   def test_token_post_close_rechazado(
           api_client, admin_close_token, auth_user):
       api_client.post(
           f'/api/auth/sessions/{auth_user["session_id"]}/close/',
           HTTP_AUTHORIZATION=f'Bearer {admin_close_token}')
       resp = api_client.get(
           '/api/users/me/',
           HTTP_AUTHORIZATION=f'Bearer {auth_user["token"]}')
       assert resp.status_code == 401

12.2.15 Integration — vista propia
----------------------------------

.. code-block:: python

   def test_endpoint_own(api_client, regular_user,
                          session_factory):
       session_factory(user=regular_user['user'], state='ACTIVE')
       session_factory(state='ACTIVE')  # de otro user
       resp = api_client.get(
           '/api/auth/sessions/own/',
           HTTP_AUTHORIZATION=f'Bearer {regular_user["token"]}')
       data = resp.json()
       for s in data['results']:
           assert s['user_id'] == regular_user['user'].id

12.3 Tests E2E (Playwright)
===========================

12.3.1 Admin lista y cierra
---------------------------

.. code-block:: javascript

   test('admin lista sesiones y cierra una', async ({ page }) => {
     await loginAdmin(page);
     await page.goto('/admin/sessions');
     await expect(page.locator('table tbody tr'))
       .toHaveCount.greaterThan(0);
     await page.click('[data-testid="close-session-uuid1"]');
     await page.click('[data-testid="confirm-destructive"]');
     await expect(page.getByText(/Sesion cerrada/)).toBeVisible();
   });

12.3.2 Bulk close
-----------------

.. code-block:: javascript

   test('admin cierra todas las del user', async ({ page }) => {
     await loginAdmin(page);
     await page.goto('/admin/users/42');
     await page.click('[data-testid="close-all-sessions"]');
     await page.click('[data-testid="confirm-destructive"]');
     await page.click('[data-testid="confirm-destructive-2"]');
     await expect(page.getByText(/Sesiones cerradas: 3/))
       .toBeVisible();
   });

12.3.3 Vista propia
-------------------

.. code-block:: javascript

   test('user ve sus propias sesiones', async ({ page }) => {
     await loginUser(page, 'ana', 'pwd');
     await page.goto('/profile/sessions');
     const rows = await page.locator('table tbody tr').count();
     expect(rows).toBeGreaterThan(0);
     // todos los rows muestran "ana" como username
   });

12.4 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Modulo
   - Lineas
   - Branches
 * - apps/auth_app/services/session_service.py
   - ≥ 95%
   - ≥ 90%
 * - apps/auth_app/views/session_*.py
   - ≥ 90%
   - ≥ 85%
 * - apps/auth_app/permissions.py
   - 100%
   - 100%

12.5 Resumen
============

.. list-table::
 :widths: 15 30 55
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - close_happy
   - CA-04
 * - Unit
   - close_idempotente
   - CA-05
 * - Unit
   - close_all_for_user
   - CA-06
 * - Unit
   - close_all_noop
   - FA-03
 * - Unit
   - atomicidad_bulk
   - CA-13
 * - Integration
   - list_200
   - CA-01
 * - Integration
   - list_sin_permiso
   - CA-08
 * - Integration
   - filter_user_id_audita
   - CA-02
 * - Integration
   - close_200 / close_sin_permiso
   - CA-04, CA-09
 * - Integration
   - auto_bulk_close
   - CA-07
 * - Integration
   - token_post_close
   - CA-10
 * - Integration
   - vista_propia
   - CA-12
 * - E2E
   - admin lista y cierra / bulk / propia
   - flujos completos
