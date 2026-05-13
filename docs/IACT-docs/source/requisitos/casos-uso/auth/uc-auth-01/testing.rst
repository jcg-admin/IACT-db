.. _uc-auth-01-parte-12:

==================================
Parte 12 — Testing
==================================

Estrategia de pruebas para UC_AUTH_01. Cada
criterio de aceptacion de Parte 9 (CA-01..CA-16)
mapea a uno o mas tests; aqui se documenta el
plan, no el codigo final (vive en el repo de
implementacion).

12.1 Niveles de prueba
======================

.. list-table::
 :widths: 22 78
 :header-rows: 1

 * - Nivel
   - Foco
 * - **Unitario**
   - ``AuthService``, ``LocalPasswordStrategy``,
     ``LoginSerializer`` aislados con mocks de
     BD y servicios externos
 * - **Integracion (Django TestCase)**
   - ``LoginView`` con BD real (sqlite test) +
     transacciones reales
 * - **API contract**
   - request/response JSON shape verificada
     contra Parte 7
 * - **End-to-end (E2E)**
   - flujo completo desde frontend hasta BD —
     fuera del scope de tests automatizados de
     este UC; vive en suite QA del proyecto

12.2 Tests backend (pytest + Django TestCase)
=============================================

Plan de 16 tests que cubren los 16 criterios de
aceptacion de Parte 9.

12.2.1 Flujo principal
----------------------

::

   # tests/test_login_view.py

   def test_login_happy_path(self):
       """CA-01: User ACTIVE sin Sessions previas."""
       user = make_active_user(username='alice',
                               password='S3cret!XY')
       response = client.post('/api/auth/login/', {
           'username': 'alice',
           'password': 'S3cret!XY',
       }, format='json')
       assert response.status_code == 200
       assert response.data['tokens']['access']
       assert response.data['user']['user_id'] == str(user.user_id)
       assert Session.objects.filter(
           user=user, state='ACTIVE').count() == 1
       assert AuditEvent.objects.filter(
           event_type='LOGIN', actor_user=user).exists()
       user.refresh_from_db()
       assert user.last_login_at is not None
       # CNST-026: payload sin password
       audit = AuditEvent.objects.get(event_type='LOGIN',
                                       actor_user=user)
       assert 'password' not in str(audit.payload)


   def test_login_supersedes_previous_session(self):
       """CA-02: CNST-004 sesion unica."""
       user = make_active_user(username='bob',
                               password='S3cret!XY')
       prev = Session.objects.create(
           user=user, state='ACTIVE',
           expires_at=now() + timedelta(minutes=15),
           client_info={'device': 'old-device'})
       response = client.post('/api/auth/login/', {
           'username': 'bob',
           'password': 'S3cret!XY',
           'client_info': {'device': 'new-device'},
       }, format='json')
       assert response.status_code == 200
       prev.refresh_from_db()
       assert prev.state == 'CLOSED'
       assert prev.close_reason == 'SUPERSEDED'
       assert AuditEvent.objects.filter(
           event_type='SESSION_CLOSED').exists()


   def test_login_rollback_on_db_failure(self):
       """CA-03: atomicidad transaccion paso 10-14."""
       user = make_active_user(username='carol',
                               password='S3cret!XY')
       with mock.patch('apps.audit.models.AuditEvent.objects.create',
                       side_effect=DatabaseError):
           response = client.post('/api/auth/login/', {
               'username': 'carol',
               'password': 'S3cret!XY',
           }, format='json')
       assert response.status_code == 503
       assert response.data['error']['code'] == 'DB_TRANSIENT_ERROR'
       assert Session.objects.filter(user=user).count() == 0

12.2.2 Flujos alternos
----------------------

::

   def test_login_first_login_redirects_to_change_password(self):
       """CA-04: FA-01 first_login true."""
       user = make_active_user(username='dan',
                               password='temp-Pwd1!',
                               first_login=True)
       response = client.post('/api/auth/login/', {
           'username': 'dan',
           'password': 'temp-Pwd1!',
       }, format='json')
       assert response.status_code == 200
       assert response.data['next_step'] == 'change_password'

   def test_login_warns_when_password_expiring(self):
       """CA-05: FA-02 password proximo a expirar."""
       user = make_active_user(
           username='eve', password='S3cret!XY',
           password_expires_at=now() + timedelta(days=2))
       response = client.post('/api/auth/login/', {
           'username': 'eve', 'password': 'S3cret!XY',
       }, format='json')
       assert response.status_code == 200
       assert response.data['warning']['type'] == 'password_expiring'

   def test_login_warns_when_no_permissions(self):
       """CA-06: FA-04 sin Assignments."""
       user = make_active_user(username='frank',
                               password='S3cret!XY')
       Assignment.objects.filter(user=user).delete()
       response = client.post('/api/auth/login/', {
           'username': 'frank', 'password': 'S3cret!XY',
       }, format='json')
       assert response.status_code == 200
       assert response.data['warning']['type'] == 'no_permissions'

12.2.3 Excepciones
------------------

::

   def test_login_user_not_found(self):
       """CA-07: EX-01 username inexistente."""
       response = client.post('/api/auth/login/', {
           'username': 'nonexistent',
           'password': 'whatever12!',
       }, format='json')
       assert response.status_code == 401
       assert response.data['error']['code'] == 'INVALID_CREDENTIALS'
       assert AuditEvent.objects.filter(
           event_type='LOGIN_FAILED').exists()

   def test_login_bad_password(self):
       """CA-08: EX-02 password incorrecto."""
       user = make_active_user(username='gina',
                               password='S3cret!XY')
       response = client.post('/api/auth/login/', {
           'username': 'gina', 'password': 'wrong-Pwd!',
       }, format='json')
       assert response.status_code == 401
       assert response.data['error']['code'] == 'INVALID_CREDENTIALS'

   def test_login_blocked_account(self):
       """CA-09: EX-03 cuenta bloqueada."""
       user = make_active_user(username='hank',
                               password='S3cret!XY',
                               state='BLOCKED')
       response = client.post('/api/auth/login/', {
           'username': 'hank', 'password': 'S3cret!XY',
       }, format='json')
       assert response.status_code == 403
       assert response.data['error']['code'] == 'ACCOUNT_BLOCKED'

   def test_login_inactive_account(self):
       """CA-10: EX-04 BR-009 v2.0.0."""
       user = make_active_user(username='ivan',
                               password='S3cret!XY',
                               state='INACTIVE')
       response = client.post('/api/auth/login/', {
           'username': 'ivan', 'password': 'S3cret!XY',
       }, format='json')
       assert response.status_code == 403
       assert response.data['error']['code'] == 'ACCOUNT_INACTIVE'

   def test_login_rate_limited(self):
       """CA-11: EX-05 throttling CNST-011."""
       # Disparar el throttle mock al limite
       with mock.patch.object(AnonLoginThrottle,
                              'allow_request',
                              return_value=False):
           response = client.post('/api/auth/login/', {
               'username': 'alice', 'password': 'whatever',
           }, format='json')
       assert response.status_code == 429
       assert response.data['error']['code'] == 'RATE_LIMITED'
       assert 'Retry-After' in response

   def test_login_validation_error(self):
       """CA-12: EX-06 datos malformados."""
       response = client.post('/api/auth/login/', {
           'username': '',  # vacio invalido
           'password': 'short',  # < 8 chars
       }, format='json')
       assert response.status_code == 400
       assert response.data['error']['code'] == 'VALIDATION_ERROR'
       assert 'username' in response.data['error']['fields']
       assert 'password' in response.data['error']['fields']

12.2.4 Transversales
--------------------

::

   def test_login_https_required(self):
       """CA-13: HTTPS obligatorio."""
       # Configurar test client en modo plain HTTP
       response = http_client.post('/api/auth/login/',
                                   {...}, format='json')
       # Debe ser 403 o redirect a HTTPS
       assert response.status_code in (301, 308, 403)

   def test_audit_event_immutable(self):
       """CA-14: CNST-025 inmutable."""
       user = make_active_user()
       client.post('/api/auth/login/', {...}, format='json')
       audit = AuditEvent.objects.get(event_type='LOGIN')
       with pytest.raises((IntegrityError, ProtectedError)):
           audit.event_type = 'TAMPERED'
           audit.save()
       with pytest.raises((IntegrityError, ProtectedError)):
           audit.delete()

   def test_no_pii_in_logs(self):
       """CA-15a: password no aparece en logs."""
       with capture_logs() as captured:
           client.post('/api/auth/login/', {
               'username': 'alice',
               'password': 'TopSecret!XYZ',
           }, format='json')
       full_log_text = ' '.join(c.message for c in captured)
       assert 'TopSecret!XYZ' not in full_log_text

   def test_no_pii_in_audit_payload(self):
       """CA-15b: password no aparece en AuditEvent."""
       client.post('/api/auth/login/', {
           'username': 'alice',
           'password': 'TopSecret!XYZ',
       }, format='json')
       events = AuditEvent.objects.filter(
           event_type__startswith='LOGIN')
       for event in events:
           assert 'TopSecret!XYZ' not in str(event.payload)

   def test_login_performance_sla(self):
       """CA-16: latencia P95 dentro de SLA CNST-017."""
       user = make_active_user()
       times = []
       for _ in range(100):
           t0 = perf_counter()
           client.post('/api/auth/login/', {
               'username': 'alice',
               'password': 'S3cret!XY',
           }, format='json')
           times.append(perf_counter() - t0)
       p95 = sorted(times)[int(len(times) * 0.95)]
       # SLA cita CNST-017; cifra concreta en ADR
       assert p95 < SLA_LOGIN_P95_SECONDS

12.3 Tests frontend (Jest + RTL)
================================

Cobertura de la UI del formulario y el flujo
de respuesta:

.. list-table::
 :widths: 38 62
 :header-rows: 1

 * - Test
   - Verifica
 * - ``test_login_form_submits_credentials``
   - El formulario hace POST con username y
     password al endpoint correcto
 * - ``test_login_disables_button_during_submit``
   - El boton se deshabilita entre click y
     respuesta
 * - ``test_login_shows_error_on_401``
   - Mensaje "Credenciales invalidas" visible
 * - ``test_login_redirects_to_dashboard_on_200``
   - Tras respuesta exitosa, navega al landing
 * - ``test_login_redirects_to_change_password_when_next_step_set``
   - FA-01 — redirige a UC_AUTH_04
 * - ``test_login_shows_password_warning_modal``
   - FA-02 — modal aparece si warning presente
 * - ``test_login_validates_username_min_length``
   - Validacion cliente-side
 * - ``test_login_validates_password_min_length``
   - idem
 * - ``test_login_handles_429_with_retry_after``
   - El frontend espera Retry-After segundos
     antes de habilitar reintento

12.4 Cobertura objetivo
=======================

.. list-table::
 :widths: 30 20 50
 :header-rows: 1

 * - Metrica
   - Objetivo
   - Razon
 * - Cobertura de lineas (``AuthService``)
   - >= 95%
   - Codigo critico de seguridad
 * - Cobertura de lineas (``LoginView``)
   - >= 90%
   - Wrapping del service; alta cobertura sin
     ser absoluta
 * - Cobertura de lineas (Serializer)
   - 100%
   - Validaciones puras, faciles de testear
 * - Cobertura de ramas (Service)
   - >= 90%
   - Cubrir las ramas de excepcion
 * - Tests E2E (frontend + backend)
   - 1 happy path mandatorio
   - Verificacion de flujo completo
 * - Performance (P95)
   - dentro de SLA CNST-017
   - Garantia operativa

12.5 Datos de prueba
====================

Helpers que viven en
``backend/apps/auth_app/tests/factories.py``
(Factory Boy):

.. code-block:: python

   class UserFactory(factory.django.DjangoModelFactory):
       class Meta:
           model = User
       user_id     = factory.LazyFunction(uuid.uuid4)
       username    = factory.Sequence(lambda n: f'user-{n}')
       state       = 'ACTIVE'
       first_login = False
       password_expires_at = factory.LazyFunction(
           lambda: timezone.now() + timedelta(days=90))

   def make_active_user(username, password,
                         state='ACTIVE',
                         first_login=False,
                         password_expires_at=None):
       user = UserFactory(username=username,
                          state=state,
                          first_login=first_login)
       user.set_password(password)
       if password_expires_at is not None:
           user.password_expires_at = password_expires_at
       user.save()
       return user

12.6 Resumen
============

- 16 tests backend (pytest + Django TestCase)
  cubriendo CA-01..CA-16.
- 9 tests frontend (Jest + RTL) cubriendo la UI.
- Cobertura objetivo >= 90% en codigo del UC.
- Performance verificada contra CNST-017.
- Inmutabilidad de auditoria verificada con
  intentos de UPDATE/DELETE rechazados.
- PII (password, tokens) verificada ausente en
  logs y AuditEvent payload (CNST-026).

Cuando se implemente el codigo del UC, los tests
viven en
``backend/apps/auth_app/tests/`` y
``frontend/src/features/auth/tests/``.
