Procedimiento: Aseguramiento de Calidad (QA)
============================================

Propósito
---------

Definir el proceso de QA para asegurar la calidad del software antes de
release.

Alcance
-------

Aplica a todas las features, bug fixes y cambios significativos del
proyecto.

Niveles de Testing
------------------

1. Tests Unitarios (Desarrolladores)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsable**: Desarrollador **Cuándo**: Durante desarrollo (TDD)
**Cobertura objetivo**: 80%+

.. code:: bash

   # Ejecutar tests unitarios
   pytest tests/unit/

   # Con cobertura
   pytest --cov=api --cov-report=html tests/unit/

   # Ver reporte
   open htmlcov/index.html

2. Tests de Integración (Desarrolladores + QA)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsable**: Desarrollador (crea), QA (valida) **Cuándo**: Antes de
PR **Alcance**: Integración entre componentes

.. code:: bash

   # Tests de integración
   pytest tests/integration/

   # Con DB real
   pytest tests/integration/ --use-real-db

3. Tests End-to-End (QA)
~~~~~~~~~~~~~~~~~~~~~~~~

**Responsable**: QA **Cuándo**: En staging antes de release **Alcance**:
Flujos completos de usuario

.. code:: bash

   # Tests E2E (ejemplo con Selenium - futuro)
   pytest tests/e2e/

   # O manualmente siguiendo test cases

4. Tests de Aceptación (QA + Product Owner)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsable**: QA y PO **Cuándo**: Antes de release a producción
**Alcance**: Validación de criterios de aceptación

Procedimiento de QA
-------------------

Fase 1: Planning
~~~~~~~~~~~~~~~~

1.1 Recibir Feature/Bug
^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Leer issue/requisito completo
-  ☐ Entender criterios de aceptación
-  ☐ Identificar casos de prueba
-  ☐ Estimar esfuerzo de testing

1.2 Crear Test Plan
^^^^^^^^^^^^^^^^^^^

.. code:: markdown

   # Test Plan: Autenticación JWT

   ## Feature
   Implementar autenticación con JWT tokens

   ## Scope
   - Login endpoint
   - Token refresh
   - Logout
   - Protected endpoints

   ## Test Cases
   1. TC-001: Login exitoso con credenciales válidas
   2. TC-002: Login falla con credenciales inválidas
   3. TC-003: Token expira después de timeout
   4. TC-004: Refresh token funciona correctamente
   5. TC-005: Logout invalida token

   ## Test Environment
   - Staging
   - Python 3.11
   - PostgreSQL 14

   ## Test Data
   - User: test@example.com / Pass123!
   - Admin: admin@example.com / Admin123!

   ## Success Criteria
   - Todos los tests pasan
   - No hay security issues
   - Performance aceptable (< 200ms por request)

Fase 2: Test Development
~~~~~~~~~~~~~~~~~~~~~~~~

2.1 Escribir Test Cases
^^^^^^^^^^^^^^^^^^^^^^^

.. code:: python

   # tests/integration/test_authentication.py

   import pytest
   from rest_framework.test import APIClient

   @pytest.fixture
   def api_client():
       return APIClient()

   @pytest.fixture
   def test_user(db):
       from api.users.models import User
       return User.objects.create_user(
           username='test',
           email='test@example.com',
           password='Pass123!'
       )

   class TestAuthentication:
       """Tests de autenticación JWT"""

       def test_login_exitoso(self, api_client, test_user):
           """TC-001: Login exitoso con credenciales válidas"""
           response = api_client.post('/api/auth/login/', {
               'username': 'test',
               'password': 'Pass123!'
           })

           assert response.status_code == 200
           assert 'access_token' in response.data
           assert 'refresh_token' in response.data

       def test_login_credenciales_invalidas(self, api_client):
           """TC-002: Login falla con credenciales inválidas"""
           response = api_client.post('/api/auth/login/', {
               'username': 'test',
               'password': 'WrongPass!'
           })

           assert response.status_code == 401
           assert 'error' in response.data

2.2 Ejecutar Tests
^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Tests específicos
   pytest tests/integration/test_authentication.py -v

   # Con logging detallado
   pytest tests/integration/test_authentication.py -v --log-cli-level=DEBUG

   # Guardar resultados
   pytest tests/integration/ --junit-xml=results/junit.xml

Fase 3: Execution
~~~~~~~~~~~~~~~~~

3.1 Tests Automáticos
^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   # Suite completa
   pytest

   # Por prioridad
   pytest -m "priority_high"
   pytest -m "smoke"

   # Por feature
   pytest -m "authentication"

3.2 Tests Manuales
^^^^^^^^^^^^^^^^^^

Usar checklist de QA:

**Feature**: Autenticación JWT

+-----------+-------+---------------------+-----------------+--------+
| Test Case | Pasos | Resultado Esperado  | Resultado Real  | Status |
+===========+=======+=====================+=================+========+
| TC-001    | 1. Ir | Token recibido      | Token recibido  | OK     |
|           | a     |                     |                 | PASS   |
|           | /lo   |                     |                 |        |
|           | gin2. |                     |                 |        |
|           | Ing   |                     |                 |        |
|           | resar |                     |                 |        |
|           | cred  |                     |                 |        |
|           | encia |                     |                 |        |
|           | les3. |                     |                 |        |
|           | Click |                     |                 |        |
|           | Login |                     |                 |        |
+-----------+-------+---------------------+-----------------+--------+
| TC-002    | 1. Ir | Error 401           | Error 401       | OK     |
|           | a     |                     |                 | PASS   |
|           | /lo   |                     |                 |        |
|           | gin2. |                     |                 |        |
|           | Ing   |                     |                 |        |
|           | resar |                     |                 |        |
|           | cr    |                     |                 |        |
|           | edenc |                     |                 |        |
|           | iales |                     |                 |        |
|           | i     |                     |                 |        |
|           | nváli |                     |                 |        |
|           | das3. |                     |                 |        |
|           | Click |                     |                 |        |
|           | Login |                     |                 |        |
+-----------+-------+---------------------+-----------------+--------+

Ver: `Checklist de Testing <../checklists/checklist_testing.md>`__

3.3 Reportar Bugs
^^^^^^^^^^^^^^^^^

Si se encuentra un bug:

.. code:: bash

   # Crear issue
   gh issue create \
     --title "Bug: Login falla con espacios en password" \
     --body "$(cat <<EOF
   ## Descripción
   Login endpoint no valida correctamente passwords con espacios.

   ## Steps to Reproduce
   1. Crear usuario con password que contenga espacios
   2. Intentar login con ese usuario
   3. Error 500

   ## Expected Behavior
   Debería aceptar o rechazar claramente

   ## Actual Behavior
   Error 500 Internal Server Error

   ## Environment
   - Branch: feature/jwt-auth
   - Python: 3.11
   - DB: PostgreSQL 14

   ## Screenshots
   [adjuntar si aplica]

   ## Severity
   Medium - no bloquea feature pero es UX issue

   ## Test Case
   TC-001 variant
   EOF
   )" \
     --label "bug,qa" \
     --assignee @desarrollador

Fase 4: Regression Testing
~~~~~~~~~~~~~~~~~~~~~~~~~~

Antes de cada release:

.. code:: bash

   # Suite de regresión completa
   pytest tests/ -m "regression"

   # Smoke tests críticos
   pytest tests/ -m "smoke"

Fase 5: Sign-off
~~~~~~~~~~~~~~~~

5.1 Criterios de Sign-off
^^^^^^^^^^^^^^^^^^^^^^^^^

-  ☐ Todos los test cases ejecutados
-  ☐ > 95% de tests pasan
-  ☐ Bugs críticos: 0
-  ☐ Bugs altos: < 3
-  ☐ Documentación QA completada
-  ☐ Performance aceptable
-  ☐ No hay security issues

5.2 QA Report
^^^^^^^^^^^^^

.. code:: markdown

   # QA Report: Feature Autenticación JWT

   **Date**: 2025-11-04
   **Tester**: QA Team
   **Environment**: Staging

   ## Summary
   Feature autenticación JWT lista para producción.

   ## Test Results
   - Total test cases: 25
   - Passed: 24 (96%)
   - Failed: 1 (4%)
   - Blocked: 0

   ## Bugs Found
   | ID | Severity | Status | Description |
   |----|----------|--------|-------------|
   | #234 | Low | Open | Typo en mensaje de error |

   ## Performance
   - Average response time: 145ms OK
   - P95 response time: 220ms OK
   - Peak load: 100 req/s OK

   ## Security
   - No SQL injection vulnerabilities OK
   - Passwords hashed correctly OK
   - Tokens encrypted OK

   ## Recommendation
   OK **APPROVED** for production release

   ## Notes
   - Bug #234 puede ser fixed en próximo release
   - Monitorear performance en producción

   **Signed-off by**: QA Lead

Tests Especiales
----------------

Security Testing
~~~~~~~~~~~~~~~~

.. code:: bash

   # SQL Injection testing
   pytest tests/security/test_sql_injection.py

   # XSS testing
   pytest tests/security/test_xss.py

   # Authentication bypass
   pytest tests/security/test_auth_bypass.py

Performance Testing
~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Load testing (ejemplo con locust)
   locust -f tests/performance/locustfile.py

   # Stress testing
   pytest tests/performance/ --workers=50

Compatibility Testing
~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Diferentes versiones de Python
   tox

   # Diferentes bases de datos
   pytest --db=postgresql
   pytest --db=mariadb

Herramientas
------------

Testing
~~~~~~~

-  **pytest**: Tests unitarios e integración
-  **pytest-django**: Tests Django
-  **pytest-cov**: Cobertura de código
-  **factory_boy**: Test data factories
-  **faker**: Datos fake realistas

QA
~~

-  **Selenium**: Tests E2E (futuro)
-  **Postman**: Tests API manuales
-  **locust**: Performance testing
-  **OWASP ZAP**: Security testing

Métricas de QA
--------------

Medir y reportar:

-  **Test Coverage**: > 80%
-  **Test Pass Rate**: > 95%
-  **Bug Detection Rate**: bugs encontrados / total estimado
-  **Bug Escape Rate**: bugs en prod / total encontrado
-  **Mean Time to Test**: tiempo promedio de testing
-  **Automation Rate**: tests automatizados / total tests

Recursos Relacionados
---------------------

-  `Checklist de Testing <../checklists/checklist_testing.md>`__
-  `Estrategia de QA <../qa/estrategia_qa.md>`__
-  `Procedimiento: Desarrollo
   Local <procedimiento_desarrollo_local.md>`__
-  `Procedimiento: Release <procedimiento_release.md>`__

Referencias
-----------

-  `pytest Documentation <https://docs.pytest.org/>`__
-  `Django
   Testing <https://docs.djangoproject.com/en/stable/topics/testing/>`__
-  `Test
   Pyramid <https://martinfowler.com/articles/practical-test-pyramid.html>`__

Changelog
---------

-  2025-11-04: Creación inicial del procedimiento
