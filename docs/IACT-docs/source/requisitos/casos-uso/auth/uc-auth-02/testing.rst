.. _uc-auth-02-parte-12:

==========================
Parte 12 — Testing
==========================

12.1 Pyramid de testing
=======================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit (services, models)
   - 12 tests
   - ≥ 90% lineas
 * - Integration (BD + DRF)
   - 8 tests
   - flujo principal + FAs + EXs
 * - E2E (Cypress / Playwright)
   - 3 tests
   - happy path + replay + token invalido

12.2 Tests backend (pytest + Django)
====================================

12.2.1 Unit — AuthService.logout (happy path)
---------------------------------------------

.. code-block:: python

   # tests/unit/services/test_auth_service_logout.py
   import pytest
   from unittest.mock import MagicMock
   from apps.auth_app.services import AuthService

   @pytest.mark.django_db
   def test_logout_marca_session_closed(session_factory):
       session = session_factory(state='ACTIVE')
       svc = AuthService(invalidator=MagicMock())

       result = svc.logout(
           user_id=session.user_id,
           session_id=session.session_id,
           access_jti='access-jti',
           refresh_token='refresh-token',
           ip='10.0.0.1',
           user_agent='Mozilla/5.0')

       session.refresh_from_db()
       assert session.state == 'CLOSED'
       assert session.close_reason == 'USER_LOGOUT'
       assert session.closed_at is not None
       assert 'logout_at' in result

12.2.2 Unit — User mismatch
---------------------------

.. code-block:: python

   def test_logout_user_mismatch_raises(session_factory):
       session = session_factory(state='ACTIVE', user_id=1)
       svc = AuthService(invalidator=MagicMock())

       with pytest.raises(UserMismatch):
           svc.logout(user_id=999,
                      session_id=session.session_id,
                      access_jti='x',
                      ip='', user_agent='')

       session.refresh_from_db()
       assert session.state == 'ACTIVE'  # sin cambios

12.2.3 Unit — Session no encontrada
-----------------------------------

.. code-block:: python

   def test_logout_session_not_found_raises():
       svc = AuthService(invalidator=MagicMock())
       with pytest.raises(SessionNotFound):
           svc.logout(user_id=1,
                      session_id='non-existent',
                      access_jti='x',
                      ip='', user_agent='')

12.2.4 Unit — Idempotencia (FA-02)
----------------------------------

.. code-block:: python

   def test_logout_idempotente_session_ya_closed(
           session_factory):
       session = session_factory(state='CLOSED',
                                 close_reason='USER_LOGOUT')
       svc = AuthService(invalidator=MagicMock())

       result = svc.logout(
           user_id=session.user_id,
           session_id=session.session_id,
           access_jti='x', ip='', user_agent='')

       session.refresh_from_db()
       assert session.close_reason == 'USER_LOGOUT'  # preservado

12.2.5 Unit — FA-03 SUPERSEDED preserved
----------------------------------------

.. code-block:: python

   def test_logout_no_sobrescribe_superseded(session_factory):
       session = session_factory(state='CLOSED',
                                 close_reason='SUPERSEDED')
       svc = AuthService(invalidator=MagicMock())
       svc.logout(user_id=session.user_id,
                  session_id=session.session_id,
                  access_jti='x', ip='', user_agent='')
       session.refresh_from_db()
       assert session.close_reason == 'SUPERSEDED'

12.2.6 Unit — Sin refresh token (FA-01)
---------------------------------------

.. code-block:: python

   def test_logout_sin_refresh_solo_blacklistea_access(
           session_factory):
       session = session_factory(state='ACTIVE')
       invalidator = MagicMock()
       svc = AuthService(invalidator=invalidator)

       svc.logout(user_id=session.user_id,
                  session_id=session.session_id,
                  access_jti='access',
                  refresh_token=None,
                  ip='', user_agent='')

       assert invalidator.invalidate.call_count == 1

12.2.7 Unit — AuditEvent emitido
--------------------------------

.. code-block:: python

   def test_logout_emite_audit_event(session_factory):
       session = session_factory(state='ACTIVE')
       svc = AuthService(invalidator=MagicMock())

       svc.logout(user_id=session.user_id,
                  session_id=session.session_id,
                  access_jti='x', ip='10.0.0.1',
                  user_agent='UA')

       assert AuditEvent.objects.filter(
           event_type='LOGOUT',
           actor_user_id=session.user_id).exists()

12.2.8 Unit — AuditEvent sin PII (CNST-026)
-------------------------------------------

.. code-block:: python

   def test_audit_payload_no_contiene_pii(session_factory,
                                           user_factory):
       user = user_factory(email='ana@example.com',
                           full_name='Ana Garcia')
       session = session_factory(state='ACTIVE', user=user)
       svc = AuthService(invalidator=MagicMock())
       svc.logout(user_id=user.id,
                  session_id=session.session_id,
                  access_jti='x', ip='', user_agent='')

       evt = AuditEvent.objects.get(event_type='LOGOUT')
       payload_str = str(evt.payload)
       assert 'ana@example.com' not in payload_str
       assert 'Ana Garcia' not in payload_str

12.2.9 Integration — POST /api/auth/logout/
-------------------------------------------

.. code-block:: python

   # tests/integration/test_logout_endpoint.py
   @pytest.mark.django_db
   def test_logout_endpoint_200_ok(api_client, auth_user):
       token = auth_user['access_token']
       resp = api_client.post(
           '/api/auth/logout/',
           HTTP_AUTHORIZATION=f'Bearer {token}',
           data={'refresh_token': auth_user['refresh_token']},
           format='json')

       assert resp.status_code == 200
       assert 'logout_at' in resp.json()

12.2.10 Integration — Token invalido (EX-01)
--------------------------------------------

.. code-block:: python

   def test_logout_token_invalido_401(api_client):
       resp = api_client.post(
           '/api/auth/logout/',
           HTTP_AUTHORIZATION='Bearer token-invalido')
       assert resp.status_code == 401

12.2.11 Integration — Token blacklisted post-logout
---------------------------------------------------

.. code-block:: python

   def test_token_post_logout_es_rechazado(api_client,
                                            auth_user):
       token = auth_user['access_token']
       api_client.post('/api/auth/logout/',
                       HTTP_AUTHORIZATION=f'Bearer {token}')

       # uso del mismo token contra otro endpoint
       resp = api_client.get('/api/users/me/',
           HTTP_AUTHORIZATION=f'Bearer {token}')
       assert resp.status_code == 401

12.2.12 Integration — Atomicidad (EX-05)
----------------------------------------

.. code-block:: python

   from unittest.mock import patch

   def test_atomicidad_rollback_si_blacklist_falla(
           session_factory, api_client, auth_user):
       with patch.object(DBBlacklistStrategy, 'invalidate',
                         side_effect=Exception('bl down')):
           resp = api_client.post(
               '/api/auth/logout/',
               HTTP_AUTHORIZATION=f'Bearer {auth_user["access_token"]}')

       assert resp.status_code == 500
       session = Session.objects.get(
           session_id=auth_user['session_id'])
       assert session.state == 'ACTIVE'  # rollback

12.2.13 Integration — Rate limit (EX-07)
----------------------------------------

.. code-block:: python

   def test_logout_rate_limit_429(api_client, auth_user,
                                    settings):
       settings.REST_FRAMEWORK['DEFAULT_THROTTLE_RATES'] = \
           {'logout': '2/min'}
       for _ in range(2):
           api_client.post('/api/auth/logout/',
               HTTP_AUTHORIZATION=f'Bearer {auth_user["access_token"]}')

       resp = api_client.post('/api/auth/logout/',
           HTTP_AUTHORIZATION=f'Bearer {auth_user["access_token"]}')
       assert resp.status_code == 429

12.3 Tests frontend (Jest + RTL)
================================

12.3.1 useLogout — happy path
-----------------------------

.. code-block:: javascript

   // src/features/auth/hooks/__tests__/useLogout.test.js
   import { renderHook, act } from '@testing-library/react';
   import { useLogout } from '../useLogout';

   test('useLogout limpia localStorage y redirige', async () => {
     localStorage.setItem('access_token', 'a');
     localStorage.setItem('refresh_token', 'r');
     authApi.logout = jest.fn().mockResolvedValue({});

     const { result } = renderHook(() => useLogout(), {
       wrapper: TestProviders,
     });
     await act(() => result.current());

     expect(localStorage.getItem('access_token')).toBeNull();
     expect(localStorage.getItem('refresh_token')).toBeNull();
     expect(navigateSpy).toHaveBeenCalledWith(
       '/login',
       expect.objectContaining({ state: expect.any(Object) }));
   });

12.3.2 useLogout — backend falla, frontend igual limpia
-------------------------------------------------------

.. code-block:: javascript

   test('useLogout limpia incluso si el backend falla', async () => {
     localStorage.setItem('access_token', 'a');
     authApi.logout = jest.fn().mockRejectedValue(
       new Error('500'));

     const { result } = renderHook(() => useLogout(), {
       wrapper: TestProviders,
     });
     await act(() => result.current());

     expect(localStorage.getItem('access_token')).toBeNull();
   });

12.3.3 LogoutButton — modal opcional
------------------------------------

.. code-block:: javascript

   test('LogoutButton muestra modal de confirmacion', () => {
     render(<LogoutButton confirmRequired />);
     fireEvent.click(screen.getByText('Cerrar sesion'));
     expect(screen.getByText(
       /Estas seguro de cerrar sesion/i)).toBeInTheDocument();
   });

12.4 Tests E2E (Playwright)
===========================

12.4.1 Happy path
-----------------

.. code-block:: javascript

   test('logout E2E', async ({ page }) => {
     await page.goto('/');
     await login(page, 'ana', 'Pass123!');
     await page.click('[data-testid="logout-button"]');
     await page.click('[data-testid="logout-confirm"]');
     await expect(page).toHaveURL('/login');
     await expect(page.getByText(
       'Tu sesion fue cerrada correctamente')).toBeVisible();
   });

12.4.2 Token rechazado post-logout
----------------------------------

.. code-block:: javascript

   test('token blacklisted no permite acceso', async ({
       page, request }) => {
     await login(page, 'ana', 'Pass123!');
     const token = await page.evaluate(
       () => localStorage.getItem('access_token'));
     await page.click('[data-testid="logout-button"]');
     await page.click('[data-testid="logout-confirm"]');

     const resp = await request.get('/api/users/me/', {
       headers: { Authorization: `Bearer ${token}` }
     });
     expect(resp.status()).toBe(401);
   });

12.4.3 Replay (FA-02)
---------------------

.. code-block:: javascript

   test('doble logout no rompe la UI', async ({ page }) => {
     await login(page, 'ana', 'Pass123!');
     await page.click('[data-testid="logout-button"]');
     await page.click('[data-testid="logout-confirm"]');
     await page.goBack();
     // segundo intento desde token ya invalido
     await page.click('[data-testid="logout-button"]')
       .catch(() => {});
     await expect(page).toHaveURL('/login');
   });

12.5 Factories (pytest)
=======================

.. code-block:: python

   # tests/factories.py
   import factory
   from apps.auth_app.models import Session, User

   class UserFactory(factory.django.DjangoModelFactory):
       class Meta:
           model = User
       username = factory.Sequence(lambda n: f'user{n}')

   class SessionFactory(factory.django.DjangoModelFactory):
       class Meta:
           model = Session
       user = factory.SubFactory(UserFactory)
       state = 'ACTIVE'
       expires_at = factory.LazyFunction(
           lambda: timezone.now() + timedelta(minutes=15))

12.6 Cobertura objetivo
=======================

.. list-table::
 :widths: 40 30 30
 :header-rows: 1

 * - Modulo
   - Lineas
   - Branches
 * - apps/auth_app/services/auth_service.py
   - ≥ 95%
   - ≥ 90%
 * - apps/auth_app/views/logout_view.py
   - ≥ 90%
   - ≥ 85%
 * - apps/auth_app/services/token_invalidator.py
   - ≥ 90%
   - ≥ 85%
 * - frontend/features/auth/hooks/useLogout.js
   - ≥ 90%
   - ≥ 85%

12.7 Resumen de tests
=====================

.. list-table::
 :widths: 15 25 60
 :header-rows: 1

 * - Capa
   - Test
   - Concepto
 * - Unit
   - test_logout_marca_session_closed
   - CA-01
 * - Unit
   - test_logout_user_mismatch
   - CA-05
 * - Unit
   - test_logout_session_not_found
   - EX-02
 * - Unit
   - test_logout_idempotente
   - CA-02 / FA-02
 * - Unit
   - test_no_sobrescribe_superseded
   - FA-03
 * - Unit
   - test_sin_refresh
   - CA-03 / FA-01
 * - Unit
   - test_emite_audit_event
   - CA-13
 * - Unit
   - test_audit_payload_no_pii
   - CA-14
 * - Integration
   - test_logout_endpoint_200_ok
   - CA-01 end-to-end
 * - Integration
   - test_token_invalido_401
   - CA-04
 * - Integration
   - test_token_post_logout_rechazado
   - CA-10
 * - Integration
   - test_atomicidad_rollback
   - CA-06
 * - Integration
   - test_rate_limit_429
   - CA-08
 * - Frontend
   - test_useLogout_happy
   - CA-09
 * - Frontend
   - test_useLogout_backend_falla
   - CA-09 robustez
 * - E2E
   - test_logout_e2e
   - flujo completo
 * - E2E
   - test_token_blacklisted_e2e
   - CA-10
 * - E2E
   - test_doble_logout
   - FA-02
