.. _uc-auth-04-parte-12:

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
   - 12
   - ≥ 90% lineas
 * - Integration
   - 9
   - flujo + EXs + CNSTs
 * - E2E
   - 3
   - flujos completos UI

12.2 Tests backend
==================

12.2.1 PolicyValidator violaciones
----------------------------------

.. code-block:: python

   def test_policy_corto():
       v = PasswordPolicyValidator()
       assert 'min_length' in v.validate('Ab1!', mock_user)

   def test_policy_sin_mayuscula():
       v = PasswordPolicyValidator()
       assert 'missing_uppercase' in \
              v.validate('mipassword123!', mock_user)

   def test_policy_contiene_username(mock_user):
       mock_user.username = 'ana'
       v = PasswordPolicyValidator()
       assert 'contains_username' in \
              v.validate('Ana12345678!', mock_user)

12.2.2 change_password happy path
---------------------------------

.. code-block:: python

   import bcrypt, pytest

   @pytest.mark.django_db
   def test_change_happy(user_factory, session_factory):
       u = user_factory(password='OldPass123!')
       s = session_factory(user=u, state='ACTIVE')
       svc = AuthService()

       r = svc.change_password(
           user=u, session_id=s.session_id,
           current_password='OldPass123!',
           new_password='NewSecure2026!@')

       u.refresh_from_db()
       assert u.first_login is False
       assert bcrypt.checkpw(b'NewSecure2026!@',
                             u.password_hash.encode())
       assert PasswordHistory.objects.filter(user=u).count() >= 1
       assert AuditEvent.objects.filter(
           event_type='PASSWORD_CHANGED',
           actor_user_id=u.id).exists()

12.2.3 wrong_current
--------------------

.. code-block:: python

   def test_change_wrong_current(user_factory, session_factory):
       u = user_factory(password='Right123!')
       s = session_factory(user=u, state='ACTIVE')
       with pytest.raises(WrongCurrentPassword):
           AuthService().change_password(
               user=u, session_id=s.session_id,
               current_password='WrongPwd!',
               new_password='NewSecure2026!@')

12.2.4 weak_password
--------------------

.. code-block:: python

   def test_change_weak(user_factory, session_factory):
       u = user_factory(password='OldPass123!')
       s = session_factory(user=u, state='ACTIVE')
       with pytest.raises(WeakPassword) as exc:
           AuthService().change_password(
               user=u, session_id=s.session_id,
               current_password='OldPass123!',
               new_password='abc')
       assert 'min_length' in exc.value.violations

12.2.5 same_as_current
----------------------

.. code-block:: python

   def test_change_same(user_factory, session_factory):
       u = user_factory(password='OldPass123!')
       s = session_factory(user=u, state='ACTIVE')
       with pytest.raises(SameAsCurrent):
           AuthService().change_password(
               user=u, session_id=s.session_id,
               current_password='OldPass123!',
               new_password='OldPass123!')

12.2.6 reused
-------------

.. code-block:: python

   def test_change_reused(user_factory, session_factory):
       u = user_factory(password='OldPass123!')
       s = session_factory(user=u, state='ACTIVE')
       svc = AuthService()
       svc.change_password(user=u, session_id=s.session_id,
           current_password='OldPass123!',
           new_password='NewOne2026!@')
       svc.change_password(user=u, session_id=s.session_id,
           current_password='NewOne2026!@',
           new_password='NewTwo2026!@')
       with pytest.raises(PasswordReused):
           svc.change_password(user=u, session_id=s.session_id,
               current_password='NewTwo2026!@',
               new_password='NewOne2026!@')  # reuso

12.2.7 first_login → false
--------------------------

.. code-block:: python

   def test_change_marks_first_login_false(
           user_factory, session_factory):
       u = user_factory(password='Temp123!@', first_login=True)
       s = session_factory(user=u, state='ACTIVE')
       AuthService().change_password(
           user=u, session_id=s.session_id,
           current_password='Temp123!@',
           new_password='RealPass2026!@')
       u.refresh_from_db()
       assert u.first_login is False

12.2.8 cierra otras sessions
----------------------------

.. code-block:: python

   def test_change_cierra_otras_sesiones(
           user_factory, session_factory, settings):
       settings.CLOSE_OTHER_SESSIONS_ON_PASSWORD_CHANGE = True
       u = user_factory(password='OldPass123!')
       s_current = session_factory(user=u, state='ACTIVE')
       s_other1 = session_factory(user=u, state='ACTIVE')
       s_other2 = session_factory(user=u, state='ACTIVE')

       AuthService().change_password(
           user=u, session_id=s_current.session_id,
           current_password='OldPass123!',
           new_password='NewSecure2026!@')

       s_current.refresh_from_db()
       s_other1.refresh_from_db()
       s_other2.refresh_from_db()
       assert s_current.state == 'ACTIVE'
       assert s_other1.state == 'CLOSED'
       assert s_other2.state == 'CLOSED'

12.2.9 atomicidad rollback
--------------------------

.. code-block:: python

   from unittest.mock import patch

   def test_atomicidad_audit_falla(
           user_factory, session_factory):
       u = user_factory(password='OldPass123!')
       original_hash = u.password_hash
       s = session_factory(user=u, state='ACTIVE')

       with patch.object(AuditEvent.objects, 'create',
                         side_effect=Exception('audit down')):
           with pytest.raises(Exception):
               AuthService().change_password(
                   user=u, session_id=s.session_id,
                   current_password='OldPass123!',
                   new_password='NewSecure2026!@')

       u.refresh_from_db()
       assert u.password_hash == original_hash

12.2.10 Integration — endpoint 200
----------------------------------

.. code-block:: python

   def test_endpoint_200(api_client, auth_user):
       resp = api_client.post(
           '/api/auth/change-password/',
           data={'current_password': auth_user['password'],
                 'new_password': 'NewSecure2026!@',
                 'new_password_confirmation':
                     'NewSecure2026!@'},
           HTTP_AUTHORIZATION=f'Bearer {auth_user["token"]}',
           format='json')
       assert resp.status_code == 200
       assert 'next_step' in resp.json()

12.2.11 Integration — wrong_current 400
---------------------------------------

.. code-block:: python

   def test_endpoint_wrong_current(api_client, auth_user):
       resp = api_client.post(
           '/api/auth/change-password/',
           data={'current_password': 'wrong',
                 'new_password': 'NewSecure2026!@',
                 'new_password_confirmation':
                     'NewSecure2026!@'},
           HTTP_AUTHORIZATION=f'Bearer {auth_user["token"]}',
           format='json')
       assert resp.status_code == 400
       assert resp.json()['error'] == 'WRONG_CURRENT_PASSWORD'

12.2.12 Integration — sin password en logs
------------------------------------------

.. code-block:: python

   def test_no_password_in_logs(api_client, auth_user, caplog):
       NEW = 'SuperSecret2026!@'
       with caplog.at_level('DEBUG'):
           api_client.post(
               '/api/auth/change-password/',
               data={'current_password': auth_user['password'],
                     'new_password': NEW,
                     'new_password_confirmation': NEW},
               HTTP_AUTHORIZATION=f'Bearer {auth_user["token"]}',
               format='json')
       assert NEW not in caplog.text
       assert auth_user['password'] not in caplog.text

12.2.13 Integration — sin password en audit payload
---------------------------------------------------

.. code-block:: python

   def test_audit_no_password(api_client, auth_user):
       NEW = 'SuperSecret2026!@'
       api_client.post(
           '/api/auth/change-password/',
           data={'current_password': auth_user['password'],
                 'new_password': NEW,
                 'new_password_confirmation': NEW},
           HTTP_AUTHORIZATION=f'Bearer {auth_user["token"]}',
           format='json')
       evt = AuditEvent.objects.filter(
           event_type='PASSWORD_CHANGED',
           actor_user_id=auth_user['user_id']).first()
       assert NEW not in str(evt.payload)
       assert auth_user['email'] not in str(evt.payload)

12.3 Tests frontend (Jest + RTL)
================================

12.3.1 useChangePassword OK
---------------------------

.. code-block:: javascript

   test('submit OK navega tras scope_upgraded', async () => {
     authApi.changePassword = jest.fn().mockResolvedValue({
       message: 'OK', scope_upgraded: true,
       next_step: 'landing'});
     const { result } = renderHook(() => useChangePassword());
     await act(() => result.current.submit({
       current: 'a', next: 'NewSecure2026!@',
       confirm: 'NewSecure2026!@'}));
     expect(navigateSpy).toHaveBeenCalledWith('/');
   });

12.3.2 useChangePassword muestra violations
-------------------------------------------

.. code-block:: javascript

   test('errors expone violations', async () => {
     authApi.changePassword = jest.fn().mockRejectedValue({
       response: { data: { error: 'WEAK_PASSWORD',
         violations: ['min_length'] }}});
     const { result } = renderHook(() => useChangePassword());
     await act(() => result.current.submit({
       current: 'a', next: 'b', confirm: 'b'}));
     expect(result.current.errors.violations)
       .toContain('min_length');
   });

12.4 Tests E2E (Playwright)
===========================

12.4.1 Cambio voluntario
------------------------

.. code-block:: javascript

   test('cambio voluntario', async ({ page }) => {
     await login(page, 'ana', 'OldPass123!');
     await page.goto('/profile/security');
     await page.fill('[name=current]', 'OldPass123!');
     await page.fill('[name=next]', 'NewSecure2026!@');
     await page.fill('[name=confirm]', 'NewSecure2026!@');
     await page.click('button[type=submit]');
     await expect(
       page.getByText(/Contrasena actualizada/)).toBeVisible();
   });

12.4.2 Forzado post first_login
-------------------------------

.. code-block:: javascript

   test('forzado post first_login', async ({ page }) => {
     await login(page, 'newuser', 'TempPwd123!');
     await expect(page).toHaveURL(/change-password/);
     await page.fill('[name=current]', 'TempPwd123!');
     await page.fill('[name=next]', 'MyReal2026!@');
     await page.fill('[name=confirm]', 'MyReal2026!@');
     await page.click('button[type=submit]');
     await expect(page).not.toHaveURL(/change-password/);
   });

12.4.3 Mostrar violations en UI
-------------------------------

.. code-block:: javascript

   test('violations visibles', async ({ page }) => {
     await login(page, 'ana', 'OldPass123!');
     await page.goto('/profile/security');
     await page.fill('[name=current]', 'OldPass123!');
     await page.fill('[name=next]', 'short');
     await page.fill('[name=confirm]', 'short');
     await page.click('button[type=submit]');
     await expect(
       page.getByText(/longitud minima/i)).toBeVisible();
   });

12.5 Resumen
============

.. list-table::
 :widths: 15 35 50
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - policy_corto / sin_mayuscula / contiene_username
   - CA-03
 * - Unit
   - change_happy
   - CA-01
 * - Unit
   - wrong_current
   - CA-02
 * - Unit
   - weak / same / reused
   - CA-03..05
 * - Unit
   - first_login_false
   - CA-08
 * - Unit
   - cierra_otras_sesiones
   - CA-09
 * - Unit
   - atomicidad_rollback
   - CA-11
 * - Integration
   - endpoint_200
   - CA-01
 * - Integration
   - wrong_current
   - CA-02
 * - Integration
   - no_password_in_logs
   - CA-12
 * - Integration
   - audit_no_password
   - CA-13
 * - Frontend
   - submit_OK / errors_violations
   - usabilidad
 * - E2E
   - voluntario / forzado / violations
   - flujos completos
