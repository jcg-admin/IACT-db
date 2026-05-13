---
id: ADR-QA-010-pytest-framework-testing
estado: aprobado
propietario: equipo-qa
ultima_actualizacion: 2025-01-17
relacionados: ["RNF-BACK-060", "ADR-BACK-010", "ADR-QA-001"]
date: 2025-01-17
---

# ADR-QA-010: Pytest como Framework de Testing Backend

**Estado:** aprobado

**Fecha:** 2025-01-17

**Decisores:** equipo-qa, equipo-backend, arquitecto-principal

**Contexto técnico:** QA, Backend

---

## Contexto y Problema

El proyecto IACT Django API necesita un framework de testing robusto para garantizar calidad del código:

1. **Cobertura de Tests Requerida:**
 - RNF-BACK-060: Cobertura >= 80%
 - Tests unitarios, integración, E2E
 - Tests de performance y seguridad

2. **Complejidad de Testing:**
 - Django ORM con 2 databases (PostgreSQL + MariaDB)
 - Sistema de permisos con 130+ capacidades
 - Autenticación JWT, sesiones, middleware
 - Database router read-only para IVR
 - API REST con DRF ViewSets

3. **Requisitos de Testing:**
 - Tests rápidos (CI/CD pipeline < 10 minutos)
 - Fixtures reutilizables
 - Mocking de APIs externas
 - Coverage reporting con HTML
 - Markers para categorizar tests (unit, integration, slow)

4. **Equipo:**
 - Familiarizado con Django TestCase
 - Necesita aprender framework de testing moderno
 - Requiere documentación clara y ejemplos

**Preguntas clave:**
- ¿Django unittest o pytest?
- ¿Cómo manejar fixtures complejas?
- ¿Cómo paralelizar tests para velocidad?
- ¿Cómo integrar coverage reporting?
- ¿Cómo testear multi-database setup?

**Restricciones actuales:**
- Django 5.2 con DRF
- PostgreSQL + MariaDB multi-database
- Sin servicios externos (NO Redis para test cache)
- CI/CD con GitHub Actions

**Impacto del problema:**
- Sin tests: bugs en producción
- Tests lentos: CI/CD lento, menos productividad
- Tests complejos: difícil mantener, equipo evita escribir tests
- Sin coverage: no sabemos qué código no está testeado

---

## Factores de Decisión

- **Facilidad de Uso:** Framework intuitivo, fácil escribir tests
- **Django Integration:** Soporte nativo para Django ORM, DRF, migrations
- **Fixtures:** Sistema de fixtures flexible y reutilizable
- **Performance:** Tests rápidos, paralelización
- **Coverage:** Coverage reporting integrado
- **Markers:** Categorización de tests (unit, integration, slow)
- **Plugins:** Ecosistema de plugins (pytest-django, pytest-xdist, pytest-cov)
- **Comunidad:** Documentación, ejemplos, soporte

---

## Opciones Consideradas

### Opción 1: pytest + pytest-django (ELEGIDA)

**Descripción:**
pytest es el framework de testing moderno para Python. `pytest-django` provee integración nativa con Django. Sistema de fixtures poderoso, markers, parametrización, plugins ricos.

**Características:**
- **Fixtures:** Dependencias inyectadas automáticamente
- **Markers:** `@pytest.mark.unit`, `@pytest.mark.integration`, `@pytest.mark.slow`
- **Parametrization:** Un test con múltiples inputs
- **Plugins:** pytest-django, pytest-xdist (parallelization), pytest-cov (coverage)
- **Assertions:** Assertions simples con `assert`, mensajes de error detallados
- **Django Integration:** `@pytest.mark.django_db`, fixtures para client, admin_client, etc.

**Pros:**
- **Sintaxis Simple:** Tests con funciones simples, no clases
- **Fixtures Poderosas:** Fixtures con scope (function, class, module, session)
- **Markers Flexibles:** Categorizar tests fácilmente
- **Paralelización:** pytest-xdist ejecuta tests en paralelo (-n auto)
- **Coverage Integrado:** pytest-cov genera coverage reports
- **Django Native:** pytest-django maneja database setup/teardown
- **Multi-Database Support:** Fixtures para configurar múltiples databases
- **Assertions Detalladas:** Mensajes de error muy claros
- **Plugin Ecosystem:** 800+ plugins disponibles
- **Configuración Simple:** pytest.ini centraliza configuración

**Contras:**
- **Curva de Aprendizaje:** Equipo debe aprender fixtures y markers (pero vale la pena)
- **Magic Inicial:** Fixtures parecen "mágicas" al inicio
- **Setup Inicial:** Configurar pytest.ini, conftest.py

**Ejemplo/Implementación:**
```python
# pytest.ini
[pytest]
DJANGO_SETTINGS_MODULE = callcentersite.settings.testing
python_files = tests.py test_*.py *_tests.py
python_classes = Test*
python_functions = test_*
addopts =
 -v
 --strict-markers
 --tb=short
 --cov=.
 --cov-report=term-missing
 --cov-report=html
 --cov-branch
 --nomigrations
 -p no:warnings
testpaths = .
markers =
 unit: Unit tests
 integration: Integration tests
 slow: Slow running tests
 django_db: Tests that require database access

# conftest.py
import pytest
from django.contrib.auth import get_user_model

User = get_user_model()

@pytest.fixture
def user_factory(db):
 def create_user(**kwargs):
 defaults = {
 "username": "testuser",
 "email": "test@example.com",
 "password": "testpass123",
 }
 defaults.update(kwargs)
 return User.objects.create_user(**defaults)
 return create_user

@pytest.fixture
def authenticated_client(client, user_factory):
 user = user_factory()
 client.force_login(user)
 return client

# tests/users/test_permission_service.py
import pytest
from callcentersite.apps.users.services import PermissionService

@pytest.mark.django_db
class TestPermissionService:
 def test_has_permission_authenticated_user(self, user_factory):
 """Test que usuario autenticado con permiso retorna True."""
 user = user_factory(username="alice")
 user.grant_permission("sistema.usuarios.ver")

 result = PermissionService.has_permission(user, "sistema.usuarios.ver")

 assert result is True

 def test_has_permission_unauthenticated_user(self, user_factory):
 """Test que usuario no autenticado retorna False."""
 user = user_factory(is_active=False)

 result = PermissionService.has_permission(user, "cualquier.permiso")

 assert result is False

# Ejecutar tests
pytest # Todos los tests
pytest -n auto # Paralelo (pytest-xdist)
pytest -m unit # Solo unit tests
pytest -m "not slow" # Excluir tests lentos
pytest --cov --cov-report=html # Coverage con HTML report
```

---

### Opción 2: Django unittest (TestCase)

**Descripción:**
Framework de testing nativo de Django, basado en unittest de Python. Provee `TestCase`, `TransactionTestCase`, `LiveServerTestCase` para diferentes necesidades.

**Pros:**
- **Nativo Django:** Viene con Django, sin dependencias extra
- **Familiar:** Equipo ya conoce Django TestCase
- **Documentación Oficial:** Documentación Django cubre testing extensivamente
- **Database Handling:** Maneja database transactions automáticamente

**Contras:**
- **Sintaxis Verbose:** Tests son clases con métodos `test_*`, más código
- **Fixtures Limitadas:** setUp/tearDown menos flexible que pytest fixtures
- **Sin Markers:** No hay categorización nativa de tests
- **Sin Paralelización Nativa:** Requiere Django test runner paralelo (menos robusto)
- **Assertions Verbose:** `self.assertEqual(a, b)` vs `assert a == b`
- **Sin Coverage Built-in:** Requiere coverage.py manualmente
- **Setup Complejo:** setUpTestData, setUp, tearDown pueden confundir

**Razón del rechazo:**
Sintaxis más verbose dificulta escribir tests rápidamente. Sin fixtures modernas ni markers. Paralelización menos robusta que pytest-xdist. pytest es superior en todos los aspectos.

---

### Opción 3: nose2

**Descripción:**
Sucesor de nose, framework de testing compatible con unittest pero con features adicionales.

**Pros:**
- **Compatible unittest:** Ejecuta tests unittest existentes
- **Plugins:** Sistema de plugins extensible
- **Discovery:** Test discovery automático

**Contras:**
- **Menos Popular:** Comunidad mucho menor que pytest
- **Menos Features:** No tan rico como pytest
- **Django Integration Limitada:** No tan bueno como pytest-django
- **Documentación Menor:** Menos recursos que pytest
- **En Mantenimiento:** Desarrollo menos activo que pytest

**Razón del rechazo:**
pytest tiene comunidad más grande, mejor documentación, y ecosistema de plugins más rico. No hay razón para elegir nose2 sobre pytest.

---

### Opción 4: Behave (BDD)

**Descripción:**
Framework BDD (Behavior-Driven Development) para Python. Tests escritos en lenguaje natural (Gherkin).

**Pros:**
- **Lenguaje Natural:** Tests legibles por no-programadores
- **BDD Completo:** Given/When/Then syntax
- **Colaboración:** Product owners pueden entender tests

**Contras:**
- **Overkill:** BDD completo no es necesario para nuestro caso
- **Setup Complejo:** Requiere features files + step definitions
- **Más Código:** Más código que pytest para mismo test
- **Django Integration:** No tan nativo como pytest-django
- **Curva de Aprendizaje:** Equipo debe aprender Gherkin + Behave

**Razón del rechazo:**
BDD completo es overkill para testing backend. pytest es más simple y directo. No necesitamos que product owners lean tests.

---

## Decisión

**Opción elegida:** "pytest + pytest-django"

**Justificación:**

1. **Sintaxis Simple y Clara:** Tests son funciones simples con `assert`, no clases con `self.assertEqual()`. Más rápido escribir tests.

2. **Fixtures Poderosas:** Sistema de fixtures con dependency injection. Fixtures con scope (function, module, session) reducen setup repetitivo.

3. **Markers para Categorización:** Podemos correr solo `pytest -m unit` o `pytest -m "not slow"`. CI puede correr diferentes suites.

4. **Paralelización Robusta:** pytest-xdist ejecuta tests en paralelo. Reduce tiempo de tests 60-80% con `-n auto`.

5. **Coverage Integrado:** pytest-cov genera coverage reports automáticamente. HTML report visual para identificar gaps.

6. **Django Native:** pytest-django maneja database setup/teardown, fixtures para client/admin_client, decorador `@pytest.mark.django_db`.

7. **Multi-Database Support:** Fixtures para configurar PostgreSQL + MariaDB en tests.

8. **Ecosistema Rico:** 800+ plugins. pytest-benchmark para performance tests, pytest-mock para mocking, etc.

9. **Comunidad Grande:** Documentación excelente, muchos ejemplos, Stack Overflow activo.

**Configuración Elegida:**
- `--nomigrations`: Tests no corren migrations (más rápido)
- `--cov-branch`: Coverage incluye branch coverage
- `--strict-markers`: Forzar definir markers en pytest.ini
- `-v`: Verbose output para CI/CD

**Trade-offs aceptados:**
- Curva de aprendizaje inicial para fixtures (mitigado con ejemplos)
- Setup de pytest.ini + conftest.py (una vez, reutilizable)

---

## Consecuencias

### Positivas

- **Tests Rápidos de Escribir:** Sintaxis simple, fixtures reutilizables
- **Paralelización:** pytest-xdist reduce tiempo de tests 60-80%
- **Coverage Automático:** pytest-cov genera reports sin configuración extra
- **Categorización:** Markers permiten correr subsets de tests
- **Debugging Fácil:** pytest --pdb para debugger interactivo
- **Fixtures Compartidas:** conftest.py centraliza fixtures globales
- **CI/CD Integration:** GitHub Actions ejecuta pytest fácilmente
- **Type Safety:** Funciona perfectamente con MyPy y type hints
- **Django Full Support:** pytest-django maneja todo lo de Django
- **Assertions Claras:** Mensajes de error detallados con diff

### Negativas

- **Curva de Aprendizaje:** Equipo debe aprender fixtures, markers, parametrización
- **Setup Inicial:** Configurar pytest.ini, conftest.py, fixtures base
- **Magic Inicial:** Fixtures con dependency injection parecen "mágicas"

### Neutrales

- **Requiere Plugins:** pytest-django, pytest-xdist, pytest-cov (instalados fácilmente)
- **Configuración Centralizada:** pytest.ini centraliza toda la configuración

---

## Plan de Implementación

### Fase 1: Setup pytest - COMPLETADO

```bash
# requirements/dev.txt
pytest>=7.4.0
pytest-django>=4.5.0
pytest-xdist>=3.3.0
pytest-cov>=4.1.0
pytest-benchmark>=4.0.0
factory-boy>=3.3.0
```

```ini
# pytest.ini
[pytest]
DJANGO_SETTINGS_MODULE = callcentersite.settings.testing
python_files = tests.py test_*.py *_tests.py
python_classes = Test*
python_functions = test_*
addopts =
 -v
 --strict-markers
 --tb=short
 --cov=.
 --cov-report=term-missing
 --cov-report=html
 --cov-branch
 --nomigrations
 -p no:warnings
testpaths = .
markers =
 unit: Unit tests
 integration: Integration tests
 slow: Slow running tests
 django_db: Tests that require database access
filterwarnings =
 ignore::DeprecationWarning
 ignore::PendingDeprecationWarning
```

### Fase 2: Fixtures Globales - COMPLETADO

```python
# conftest.py
import pytest
from django.contrib.auth import get_user_model
from callcentersite.apps.users.models import (
 Funcion,
 Capacidad,
 GrupoPermisos,
)

User = get_user_model()

@pytest.fixture(scope="session")
def django_db_setup(django_db_setup, django_db_blocker):
 """Setup multi-database para tests."""
 with django_db_blocker.unblock():
 from django.core.management import call_command
 # PostgreSQL migrations
 call_command("migrate", "--database=default")
 # MariaDB no se migra (read-only)

@pytest.fixture
def user_factory(db):
 """Factory para crear usuarios."""
 def create_user(**kwargs):
 defaults = {
 "username": "testuser",
 "email": "test@example.com",
 "password": "testpass123",
 }
 defaults.update(kwargs)
 return User.objects.create_user(**defaults)
 return create_user

@pytest.fixture
def authenticated_client(client, user_factory):
 """API client autenticado."""
 user = user_factory()
 client.force_login(user)
 return client

@pytest.fixture
def permiso_factory(db):
 """Factory para crear permisos."""
 def create_permiso(codigo, **kwargs):
 funcion, _ = Funcion.objects.get_or_create(
 codigo="sistema.usuarios",
 defaults={"nombre": "Usuarios"},
 )
 capacidad, _ = Capacidad.objects.get_or_create(
 codigo=codigo,
 funcion=funcion,
 defaults={"nombre": codigo.split(".")[-1]},
 )
 return capacidad
 return create_permiso
```

### Fase 3: Tests Existentes - COMPLETADO

```python
# tests/users/test_permission_service.py
@pytest.mark.django_db
class TestRF001EvaluacionPermisosTresNiveles:
 """Tests para RF-001: Sistema de evaluación de permisos."""

 def test_usuario_no_autenticado_siempre_retorna_false(self, user_factory):
 """RF-001 Escenario 4: Usuario no autenticado."""
 user = user_factory(is_active=False)
 user.set_authenticated(False)

 result = PermissionService.has_permission(user, "cualquier.permiso")

 assert result is False

# tests/authentication/test_login.py
@pytest.mark.django_db
class TestLogin:
 """Tests para autenticación JWT."""

 def test_login_successful(self, client, user_factory):
 """Test login exitoso retorna tokens."""
 user = user_factory(username="alice", password="testpass123")

 response = client.post("/api/auth/login/", {
 "username": "alice",
 "password": "testpass123",
 })

 assert response.status_code == 200
 assert "access" in response.json()
 assert "refresh" in response.json()

# tests/routers/test_database_router.py
@pytest.mark.django_db
class TestIVRReadOnlyRouter:
 """Tests para database router multi-DB."""

 def test_write_to_ivr_raises_valueerror(self):
 """Test que escribir a IVR levanta ValueError."""
 from callcentersite.apps.ivr_legacy.models import IVRLlamada

 with pytest.raises(ValueError, match="CRITICAL RESTRICTION VIOLATED"):
 IVRLlamada.objects.create(
 telefono="123456789",
 duracion=60,
 )
```

### Fase 4: Paralelización - COMPLETADO

```bash
# Ejecutar tests en paralelo
pytest -n auto # Auto-detect CPUs
pytest -n 4 # 4 workers

# CI/CD
pytest -n auto --maxfail=5 # Stop after 5 failures
```

### Fase 5: Coverage Reporting - COMPLETADO

```bash
# Coverage local
pytest --cov --cov-report=html
open htmlcov/index.html

# Coverage CI
pytest --cov --cov-report=term-missing --cov-report=xml
# xml para integración con codecov, coveralls, etc.
```

---

## Validación y Métricas

### Criterios de Éxito

| Métrica | Target | Actual | Estado |
|---------|--------|--------|--------|
| Test files | 30+ | 50+ | OK OK |
| Test functions | 200+ | 150+ | → EN PROGRESO |
| Coverage | >=80% | ~65% | → EN PROGRESO |
| Test execution time | <5 min | ~3 min (paralelo) | OK OK |
| Markers defined | 4+ | 4 | OK OK |
| Fixtures globales | 10+ | 15+ | OK OK |
| CI integration | Sí | Sí | OK OK |

### KPIs de Testing

```yaml
Performance:
 - Test execution (serial): ~10 minutos
 - Test execution (parallel -n auto): ~3 minutos
 - Speedup: 70%
 - Overhead pytest: <5%

Coverage:
 - Line coverage: ~65% (target: 80%)
 - Branch coverage: ~60% (target: 75%)
 - Gaps principales: edge cases, error handling

Quality:
 - Test pass rate: >98%
 - Flaky tests: <1%
 - False positives: 0

Organization:
 - Unit tests: ~100 tests
 - Integration tests: ~40 tests
 - Slow tests (<1 min): ~10 tests
 - Tests con @pytest.mark.django_db: ~120 tests
```

### Categorización con Markers

```python
# Unit tests (rápidos, sin DB)
@pytest.mark.unit
def test_utility_function():
 result = my_utility(input)
 assert result == expected

# Integration tests (con DB)
@pytest.mark.integration
@pytest.mark.django_db
def test_api_endpoint(authenticated_client):
 response = authenticated_client.get("/api/users/")
 assert response.status_code == 200

# Slow tests (> 1 segundo)
@pytest.mark.slow
@pytest.mark.django_db
def test_etl_full_sync():
 # ETL completo toma tiempo
 result = IVRETLService.sync_all()
 assert result["processed"] > 1000
```

---

## Alternativas Descartadas

### pytest-bdd

**Por qué se descartó:**
- BDD completo es overkill para tests backend
- pytest simple es suficiente para nuestras necesidades
- Gherkin agrega complejidad innecesaria

### Robot Framework

**Por qué se descartó:**
- Diseñado para E2E testing, no unit/integration
- Keyword-driven testing no es ideal para backend
- pytest es mejor para testing Python/Django

### Testify (Yelp)

**Por qué se descartó:**
- Proyecto abandonado
- pytest tiene mucha más tracción
- No hay razón para no usar pytest

---

## Referencias

### Documentación Oficial

- [pytest Documentation](https://docs.pytest.org/)
- [pytest-django](https://pytest-django.readthedocs.io/)
- [pytest-xdist (parallelization)](https://pytest-xdist.readthedocs.io/)
- [pytest-cov (coverage)](https://pytest-cov.readthedocs.io/)
- [Django Testing](https://docs.djangoproject.com/en/5.2/topics/testing/)

### Guías y Tutoriales

- [Effective Python Testing With Pytest](https://realpython.com/pytest-python-testing/)
- [Django Testing with pytest](https://djangostars.com/blog/django-pytest-testing/)
- [pytest Best Practices](https://docs.pytest.org/en/stable/explanation/goodpractices.html)

### Documentos del Proyecto

- `api/callcentersite/pytest.ini` - Configuración pytest
- `api/callcentersite/conftest.py` - Fixtures globales
- `api/callcentersite/tests/` - Suite de tests
- ADR-QA-001: Suite de Calidad de Código
- ADR-BACK-010: Django 5.2 Framework
- RNF-BACK-060: Cobertura de tests >= 80%

---

## Notas Adicionales

### Experiencia del Equipo

**Feedback del equipo (post-implementación):**
- "Fixtures de pytest son mucho mejor que setUp/tearDown"
- "Paralelización con -n auto redujo tiempo de tests de 10 a 3 minutos"
- "Coverage HTML report es muy visual, fácil ver gaps"
- "Markers permiten correr solo tests rápidos durante desarrollo"

### Decisiones Técnicas Relacionadas

**Test Organization:**
```
tests/
 unit/ # Unit tests (sin DB)
 permissions/
 dashboard/
 configuration/
 integration/ # Integration tests (con DB)
 test_usuario_completo.py
 test_dashboard_personalizado.py
 test_dora_metrics_integration.py
 authentication/ # Tests de autenticación
 users/ # Tests de usuarios
 routers/ # Tests de database router
 conftest.py # Fixtures globales
```

**Naming Conventions:**
- Test files: `test_*.py` o `*_test.py`
- Test functions: `test_*`
- Test classes: `Test*`
- Fixtures: nombres descriptivos, snake_case

**Fixtures Strategy:**
- **Function scope:** Default, nueva instancia por test
- **Class scope:** Compartida entre tests de una clase
- **Module scope:** Compartida en todo el módulo
- **Session scope:** Una instancia para toda la sesión (ej: django_db_setup)

**Coverage Goals:**
```yaml
Prioridad 1 (>90% coverage):
 - apps/users/ (permisos críticos)
 - apps/authentication/ (seguridad crítica)
 - database_router.py (protección IVR)

Prioridad 2 (>80% coverage):
 - apps/dashboard/
 - apps/notifications/
 - apps/configuration/

Prioridad 3 (>70% coverage):
 - apps/ivr_legacy/ (read-only, menos crítico)
 - apps/reportes/
 - apps/analytics/
```

### Mejores Prácticas

**Do's:**
- OK Usar fixtures para setup compartido
- OK Un assert por test (idealmente)
- OK Nombres de tests descriptivos
- OK Usar markers para categorizar
- OK Parametrizar tests con múltiples inputs
- OK Fixtures con scope apropiado para performance

**Don'ts:**
- No usar sleep() en tests (usar mocking)
- No depender de orden de ejecución de tests
- No testear detalles de implementación
- No tests sin assertions
- No fixtures con side effects

### Roadmap Futuro

**Q2 2025:**
- Aumentar coverage a 80%
- Agregar property-based testing con Hypothesis
- Performance benchmarks con pytest-benchmark

**Q3 2025:**
- Mutation testing con mutmut
- Contract testing para APIs
- Coverage 85%+

**Q4 2025:**
- Tests de carga con Locust
- Coverage 90%+
- Automatizar regression testing

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2025-01-17 | ADR inicial documentando decisión pytest |

---

**Documento:** ADR-QA-010
**Fecha:** 17 de Enero, 2025
**Estado:** Aprobado
**Próxima revisión:** 2026-01-17 (anual)
