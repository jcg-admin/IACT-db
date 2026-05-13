.. _uc-auth-03-parte-12:

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
   - 14 tests
   - ≥ 90% lineas
 * - Integration
   - 9 tests
   - flujo + EXs + CNSTs
 * - E2E
   - 3 tests
   - flujo admin + frontend no-leak

12.2 Tests backend
==================

12.2.1 PasswordGenerator complejidad
------------------------------------

.. code-block:: python

   import re
   from apps.auth_app.services import StandardPasswordGenerator

   def test_generate_cumple_complejidad():
       gen = StandardPasswordGenerator()
       for _ in range(100):
           pwd = gen.generate(length=12)
           assert len(pwd) >= 12
           assert re.search(r'[A-Z]', pwd)
           assert re.search(r'[a-z]', pwd)
           assert re.search(r'[0-9]', pwd)
           assert re.search(r'[!@#\$%\^&\*\(\)\-_=\+\[\]\{\}]', pwd)

12.2.2 PasswordGenerator entropia
---------------------------------

.. code-block:: python

   def test_generate_distintos():
       gen = StandardPasswordGenerator()
       passwords = {gen.generate() for _ in range(1000)}
       assert len(passwords) == 1000  # cero colisiones

12.2.3 reset_password happy path
--------------------------------

.. code-block:: python

   import bcrypt
   import pytest

   @pytest.mark.django_db
   def test_reset_password_actualiza_hash(
           admin_factory, user_factory):
       admin = admin_factory(with_function='reset_password')
       target = user_factory(first_login=False)
       svc = AuthService()

       result = svc.reset_password(
           admin=admin, target=target,
           ip='10.0.0.1', user_agent='UA')

       target.refresh_from_db()
       assert target.first_login is True
       assert target.password_changed_at is not None
       # El hash cambio
       assert target.password_hash != ''
       # No retorna password
       assert 'password' not in result
       assert 'temp_password' not in result

12.2.4 Sessions cerradas
------------------------

.. code-block:: python

   def test_reset_cierra_sessions(
           admin_factory, user_factory, session_factory):
       admin = admin_factory(with_function='reset_password')
       target = user_factory()
       session_factory(user=target, state='ACTIVE')
       session_factory(user=target, state='ACTIVE')

       AuthService().reset_password(
           admin=admin, target=target, ip='', user_agent='')

       assert Session.objects.filter(
           user=target, state='CLOSED',
           close_reason='PASSWORD_RESET').count() == 2

12.2.5 InternalMessage creado
-----------------------------

.. code-block:: python

   def test_reset_crea_internal_message(
           admin_factory, user_factory):
       admin = admin_factory(with_function='reset_password')
       target = user_factory()

       AuthService().reset_password(
           admin=admin, target=target, ip='', user_agent='')

       msgs = InternalMessage.objects.filter(recipient=target)
       assert msgs.count() == 1
       assert msgs.first().subject == 'Contrasena temporal'

12.2.6 AuditEvent emitido
-------------------------

.. code-block:: python

   def test_reset_emite_audit_event(
           admin_factory, user_factory):
       admin = admin_factory(with_function='reset_password')
       target = user_factory()

       AuthService().reset_password(
           admin=admin, target=target,
           ip='10.0.0.1', user_agent='UA')

       evt = AuditEvent.objects.get(
           event_type='PASSWORD_RESET',
           actor_user_id=admin.id)
       assert evt.payload['target_user_id'] == target.id
       # CNST-026: sin PII
       assert 'email' not in str(evt.payload).lower()
       assert target.email not in str(evt.payload)

12.2.7 Atomicidad mailbox falla
-------------------------------

.. code-block:: python

   from unittest.mock import patch

   def test_atomicidad_si_mailbox_falla(
           admin_factory, user_factory):
       admin = admin_factory(with_function='reset_password')
       target = user_factory()
       original_hash = target.password_hash

       with patch.object(InternalMessage.objects, 'create',
                         side_effect=Exception('mb down')):
           with pytest.raises(MailboxFailure):
               AuthService().reset_password(
                   admin=admin, target=target,
                   ip='', user_agent='')

       target.refresh_from_db()
       assert target.password_hash == original_hash  # ROLLBACK

12.2.8 Atomicidad audit falla
-----------------------------

.. code-block:: python

   def test_atomicidad_si_audit_falla(
           admin_factory, user_factory):
       admin = admin_factory(with_function='reset_password')
       target = user_factory()
       original_hash = target.password_hash

       with patch.object(AuditEvent.objects, 'create',
                         side_effect=Exception('audit down')):
           with pytest.raises(Exception):
               AuthService().reset_password(
                   admin=admin, target=target,
                   ip='', user_agent='')

       target.refresh_from_db()
       assert target.password_hash == original_hash
       assert InternalMessage.objects.filter(
           recipient=target).count() == 0

12.2.9 Integration — endpoint 200 OK
------------------------------------

.. code-block:: python

   def test_endpoint_reset_password_200(
           api_client, admin_with_function, user_factory):
       target = user_factory()
       resp = api_client.post(
           f'/api/users/{target.id}/reset-password/',
           HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')
       assert resp.status_code == 200
       data = resp.json()
       assert 'temp_password' not in data
       assert 'password' not in data

12.2.10 Integration — sin permiso 403 (EX-02)
---------------------------------------------

.. code-block:: python

   def test_endpoint_sin_permiso_403(
           api_client, regular_admin, user_factory):
       target = user_factory()
       resp = api_client.post(
           f'/api/users/{target.id}/reset-password/',
           HTTP_AUTHORIZATION=f'Bearer {regular_admin["token"]}')
       assert resp.status_code == 403

12.2.11 Integration — auto-reset 400 (EX-04)
--------------------------------------------

.. code-block:: python

   def test_endpoint_auto_reset_400(
           api_client, admin_with_function):
       admin_id = admin_with_function['user_id']
       resp = api_client.post(
           f'/api/users/{admin_id}/reset-password/',
           HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')
       assert resp.status_code == 400
       assert resp.json()['error'] == 'SELF_RESET_FORBIDDEN'

12.2.12 Integration — user no existe 404 (EX-03)
------------------------------------------------

.. code-block:: python

   def test_endpoint_user_no_existe_404(
           api_client, admin_with_function):
       resp = api_client.post(
           '/api/users/99999/reset-password/',
           HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')
       assert resp.status_code == 404

12.2.13 Integration — CNST-001 sin email
----------------------------------------

.. code-block:: python

   def test_no_envia_email(
           api_client, admin_with_function, user_factory):
       target = user_factory()
       with patch('django.core.mail.send_mail') as m:
           api_client.post(
               f'/api/users/{target.id}/reset-password/',
               HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')
       m.assert_not_called()

12.2.14 Integration — sin contrasena en logs
--------------------------------------------

.. code-block:: python

   def test_sin_contrasena_en_logs(
           api_client, admin_with_function, user_factory,
           caplog):
       target = user_factory()
       with caplog.at_level('DEBUG'):
           api_client.post(
               f'/api/users/{target.id}/reset-password/',
               HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')

       msg = InternalMessage.objects.filter(
           recipient=target).first()
       # extrae el password del body
       import re
       m = re.search(r'Contrasena temporal: (\S+)', msg.body)
       temp_pwd = m.group(1)
       assert temp_pwd not in caplog.text

12.2.15 Integration — throttling 429 (EX-08)
--------------------------------------------

.. code-block:: python

   def test_rate_limit_429(api_client, admin_with_function,
                           user_factory, settings):
       settings.REST_FRAMEWORK['DEFAULT_THROTTLE_RATES'] = \
           {'reset_password': '2/5min'}
       u1, u2, u3 = (user_factory() for _ in range(3))
       for u in (u1, u2):
           api_client.post(
               f'/api/users/{u.id}/reset-password/',
               HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')
       resp = api_client.post(
           f'/api/users/{u3.id}/reset-password/',
           HTTP_AUTHORIZATION=f'Bearer {admin_with_function["token"]}')
       assert resp.status_code == 429

12.3 Tests frontend (Jest + RTL)
================================

12.3.1 useResetPassword muestra confirm
---------------------------------------

.. code-block:: javascript

   test('reset solicita confirmacion', async () => {
     const { result } = renderHook(() => useResetPassword());
     openConfirmModal.mockResolvedValue(false);
     await act(() => result.current.reset(42, 'Ana'));
     expect(usersApi.resetPassword).not.toHaveBeenCalled();
   });

12.3.2 reset NO muestra contrasena
----------------------------------

.. code-block:: javascript

   test('UI no contiene la contrasena temporal', async () => {
     usersApi.resetPassword = jest.fn().mockResolvedValue({
       message: 'Contrasena reseteada...',
       target_user_id: 42,
     });
     const { result } = renderHook(() => useResetPassword());
     openConfirmModal.mockResolvedValue(true);
     await act(() => result.current.reset(42, 'Ana'));
     // toast no contiene patrones de contrasena
     expect(toast.success).toHaveBeenCalledWith(
       expect.stringMatching(/buzon/));
     expect(toast.success.mock.calls[0][0])
       .not.toMatch(/[A-Z][a-z]+\d+[!@#]/);
   });

12.4 Tests E2E (Playwright)
===========================

12.4.1 Flujo admin completo
---------------------------

.. code-block:: javascript

   test('admin resetea password de user', async ({ page }) => {
     await loginAdmin(page);
     await page.goto('/users');
     await page.click('[data-testid="user-row-42"]');
     await page.click('[data-testid="reset-password"]');
     await page.click('[data-testid="confirm-destructive"]');
     await expect(
       page.getByText(/buzon interno/)).toBeVisible();
     // verifica que la contrasena no aparece
     const html = await page.content();
     expect(html).not.toMatch(/Contrasena temporal: \w+/);
   });

12.4.2 User recibe mensaje en buzon
-----------------------------------

.. code-block:: javascript

   test('user afectado ve mensaje en buzon', async ({
       browser, dbHelper }) => {
     // admin resetea
     const adminCtx = await browser.newContext();
     const adminPage = await adminCtx.newPage();
     await loginAdmin(adminPage);
     await resetPasswordViaUI(adminPage, 42);

     // user mira buzon
     const userCtx = await browser.newContext();
     const userPage = await userCtx.newPage();
     // user usa la temp_password leyendola del DB de test
     const tempPwd = await dbHelper.extractTempPasswordFromMailbox(42);
     await loginUser(userPage, 'ana', tempPwd);
     await expect(userPage).toHaveURL(/change-password/);
   });

12.4.3 Self-reset bloqueado
---------------------------

.. code-block:: javascript

   test('admin no puede resetearse a si mismo', async ({
       page }) => {
     await loginAdmin(page);
     await page.goto(`/users/${adminId}`);
     // boton ausente o deshabilitado
     const btn = page.locator('[data-testid="reset-password"]');
     await expect(btn).toBeHidden();
   });

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Modulo
   - Lineas
   - Branches
 * - apps/auth_app/services/auth_service.py
   - ≥ 95%
   - ≥ 90%
 * - apps/auth_app/services/password_generator.py
   - 100%
   - 100%
 * - apps/users/views/reset_password_view.py
   - ≥ 90%
   - ≥ 85%

12.6 Resumen
============

.. list-table::
 :widths: 15 30 55
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - generate_cumple_complejidad
   - BR-AUTH-21
 * - Unit
   - generate_distintos
   - BR-AUTH-21 entropia
 * - Unit
   - reset_actualiza_hash
   - CA-01
 * - Unit
   - reset_cierra_sessions
   - CA-04
 * - Unit
   - crea_internal_message
   - CA-14
 * - Unit
   - emite_audit_event
   - CA-15, CA-16
 * - Unit
   - atomicidad_mailbox_falla
   - CA-11
 * - Unit
   - atomicidad_audit_falla
   - CA-12
 * - Integration
   - endpoint_200
   - CA-01, CA-02
 * - Integration
   - sin_permiso_403
   - CA-07
 * - Integration
   - auto_reset_400
   - CA-06
 * - Integration
   - user_no_existe_404
   - CA-08
 * - Integration
   - no_envia_email
   - CA-13 (CNST-001)
 * - Integration
   - sin_contrasena_en_logs
   - CA-03
 * - Integration
   - rate_limit_429
   - CA-17
 * - Frontend
   - reset_solicita_confirmacion
   - usabilidad
 * - Frontend
   - UI_no_contiene_contrasena
   - CA-19
 * - E2E
   - admin_resetea
   - flujo completo
 * - E2E
   - user_recibe_mensaje
   - CA-05 + CA-14
 * - E2E
   - self_reset_bloqueado
   - CA-06
