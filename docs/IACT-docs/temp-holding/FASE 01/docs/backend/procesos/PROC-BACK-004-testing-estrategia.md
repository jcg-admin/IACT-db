---
id: PROC-BACK-004
tipo: proceso
categoria: backend
version: 1.0.0
fecha_creacion: 2025-11-18
propietario: equipo-qa
estado: activo
relacionados: ["PROC-BACK-001", "PROC-BACK-003", "PROC-BACK-005"]
date: 2025-11-18
---

# PROC-BACK-004: Estrategia de Testing Backend

## Objetivo

Definir la estrategia integral de testing para el backend Django/DRF, abarcando desde tests unitarios hasta tests de integracion y end-to-end, asegurando calidad, confiabilidad y mantenibilidad del sistema.

---

## Alcance

### Aplica a

- Tests unitarios de modelos, servicios, serializers
- Tests de integracion de APIs y flujos
- Tests funcionales de casos de uso
- Tests de regresion
- Tests de seguridad
- Tests de performance

### No aplica a

- Tests de frontend (ver estrategia frontend)
- Tests de infraestructura (ver estrategia DevOps)
- Tests de carga distribuida (requiere herramientas especializadas)

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **QA Lead** | Definir estrategia de testing, aprobar criterios de calidad |
| **Backend Developer** | Escribir tests unitarios y de integracion |
| **QA Engineer** | Diseñar test cases, ejecutar tests funcionales |
| **Tech Lead** | Aprobar cobertura minima, revisar tests criticos |
| **DevOps** | Configurar CI/CD para ejecucion automatica |

---

## Piramide de Testing

```mermaid
graph TB
    subgraph "Piramide de Testing"
        E2E[Tests E2E<br/>10% - Lentos - Alto costo]
        INT[Tests Integracion<br/>20% - Medios - Medio costo]
        UNIT[Tests Unitarios<br/>70% - Rapidos - Bajo costo]
    end

    UNIT --> INT
    INT --> E2E

    style E2E fill:#FF6B6B
    style INT fill:#FFD93D
    style UNIT fill:#6BCF7F
```

**Distribucion recomendada:**
- **70% Tests Unitarios:** Rapidos, aislados, bajo costo
- **20% Tests de Integracion:** Componentes integrados
- **10% Tests E2E:** Flujos completos, alto costo

---

## Flujo del Proceso

```mermaid
graph TD
    A[1. Diseñar test cases] --> B[2. Escribir tests]
    B --> C[3. Ejecutar localmente]
    C --> D{Tests pasan?}
    D -->|No| E[Fix tests o codigo]
    E --> C
    D -->|Si| F[4. Commit con tests]
    F --> G[5. CI ejecuta tests]
    G --> H{CI OK?}
    H -->|No| E
    H -->|Si| I[6. Code review]
    I --> J[7. Merge]
    J --> K[8. Tests en staging]
    K --> L{QA OK?}
    L -->|No| E
    L -->|Si| M[9. Deploy a produccion]
    M --> N[10. Monitoreo]
```

---

## FASE 1: Diseño de Test Cases

### Objetivo

Diseñar casos de prueba antes de implementar, siguiendo metodologia TDD.

### Tipos de Test Cases

#### 1.1 Tests Unitarios

**Objetivo:** Validar unidades individuales de codigo (funciones, metodos, clases).

**Caracteristicas:**
- Aislados (sin dependencias externas)
- Rapidos (< 100ms por test)
- Deterministicos (mismo resultado siempre)
- Independientes (orden no importa)

**Aplica a:**
- Metodos de modelos
- Funciones de servicios
- Validaciones de serializers
- Utilidades y helpers

**Ejemplo de test case:**

```markdown
### TC-UNIT-001: Crear usuario con datos validos

**Descripcion:** Validar que UserService.crear_usuario() crea usuario correctamente

**Precondiciones:**
- Base de datos limpia
- Datos validos disponibles

**Pasos:**
1. Llamar UserService.crear_usuario(username='test', email='test@example.com', password='pass123')
2. Verificar usuario creado
3. Verificar campos correctos

**Resultado esperado:**
- Usuario creado con id
- username = 'test'
- email = 'test@example.com'
- is_active = True
- password hasheado (bcrypt)

**Criterios de aceptacion:**
- Usuario existe en DB
- Password no esta en texto plano
```

#### 1.2 Tests de Integracion

**Objetivo:** Validar interaccion entre multiples componentes.

**Caracteristicas:**
- Integran multiples capas (views + services + models)
- Medianamente rapidos (< 500ms por test)
- Usan base de datos de test
- Validan flujos completos

**Aplica a:**
- Endpoints REST (request -> response)
- Flujos de autenticacion
- Operaciones transaccionales
- Integraciones con servicios externos (mocked)

**Ejemplo de test case:**

```markdown
### TC-INT-001: Login exitoso via API

**Descripcion:** Validar flujo completo de login via POST /api/v1/auth/login/

**Precondiciones:**
- Usuario 'test' existe en DB con password 'pass123'
- Endpoint /api/v1/auth/login/ disponible

**Pasos:**
1. POST /api/v1/auth/login/ con {"username": "test", "password": "pass123"}
2. Verificar status code 200
3. Verificar response contiene access_token y refresh_token
4. Verificar tokens son JWT validos

**Resultado esperado:**
- Status: 200 OK
- Response: {"access_token": "...", "refresh_token": "..."}
- Tokens decodificables con SECRET_KEY
- Token contiene user_id correcto

**Criterios de aceptacion:**
- Login exitoso con credenciales correctas
- Tokens JWT validos
- Audit log creado
```

#### 1.3 Tests Funcionales (E2E)

**Objetivo:** Validar casos de uso completos desde perspectiva del usuario.

**Caracteristicas:**
- Flujos end-to-end
- Lentos (> 1s por test)
- Simulan usuario real
- Alto valor de negocio

**Aplica a:**
- Casos de uso criticos (UC-XXX)
- Flujos multi-paso
- Integraciones reales

**Ejemplo de test case:**

```markdown
### TC-E2E-001: Flujo completo de gestion de usuario

**Descripcion:** Validar flujo completo: crear usuario -> asignar permisos -> login -> acceder recurso protegido

**Precondiciones:**
- Sistema disponible
- Grupo 'Agentes' existe con permiso 'operaciones.llamadas.ver'

**Pasos:**
1. Admin crea usuario via POST /api/v1/usuarios/
2. Admin asigna usuario a grupo 'Agentes' via POST /api/v1/permissions/usuarios-grupos/
3. Usuario hace login via POST /api/v1/auth/login/
4. Usuario accede a GET /api/v1/llamadas/ con token
5. Verificar respuesta exitosa con datos

**Resultado esperado:**
- Usuario creado correctamente
- Usuario asignado a grupo
- Login exitoso con tokens
- Acceso exitoso a recurso protegido
- Response con lista de llamadas

**Criterios de aceptacion:**
- Flujo completo sin errores
- Permisos aplicados correctamente
- Audit logs generados en cada paso
```

### Matriz de Test Cases

| Componente | Unit | Integration | E2E | Prioridad |
|------------|------|-------------|-----|-----------|
| Modelos | Alta | Baja | No | P1 |
| Servicios | Alta | Media | No | P1 |
| Serializers | Alta | Baja | No | P1 |
| Views/APIs | Media | Alta | Baja | P1 |
| Permisos | Media | Alta | Media | P1 |
| Autenticacion | Baja | Alta | Alta | P1 |
| Casos de uso criticos | No | Media | Alta | P1 |

### Criterios de salida

- [ ] Test cases diseñados para feature
- [ ] Cobertura planificada >= 80%
- [ ] Casos negativos incluidos
- [ ] Edge cases considerados

---

## FASE 2: Implementacion de Tests

### Objetivo

Escribir tests siguiendo metodologia TDD y mejores practicas.

### Estructura de Tests

```
callcentersite/
├── apps/
│   ├── users/
│   │   ├── tests/
│   │   │   ├── __init__.py
│   │   │   ├── conftest.py          # Fixtures compartidos
│   │   │   ├── test_models.py       # Tests de modelos
│   │   │   ├── test_services.py     # Tests de servicios
│   │   │   ├── test_serializers.py  # Tests de serializers
│   │   │   ├── test_views.py        # Tests de views
│   │   │   └── test_integration.py  # Tests de integracion
│   │   ├── models.py
│   │   ├── services.py
│   │   ├── serializers.py
│   │   └── views.py
│   └── permissions/
│       ├── tests/
│       │   └── ...
│       └── ...
└── tests/
    ├── integration/     # Tests de integracion cross-app
    ├── functional/      # Tests funcionales E2E
    └── conftest.py      # Fixtures globales
```

### Metodologia TDD (Test-Driven Development)

#### Ciclo Red-Green-Refactor

```mermaid
graph LR
    A[RED<br/>Escribir test que falla] --> B[GREEN<br/>Escribir codigo minimo]
    B --> C[REFACTOR<br/>Mejorar codigo]
    C --> A
```

**Paso 1: RED - Test que falla**

```python
# tests/test_services.py
def test_crear_usuario_exitoso():
    # Arrange
    datos = {
        'username': 'nuevo.usuario',
        'email': 'nuevo@example.com',
        'password': 'SecureP@ss123'
    }

    # Act
    usuario = UserService.crear_usuario(**datos)

    # Assert
    assert usuario.username == 'nuevo.usuario'
    assert usuario.email == 'nuevo@example.com'
    assert usuario.is_active == True
    assert usuario.check_password('SecureP@ss123')
```

**Paso 2: GREEN - Codigo minimo**

```python
# services.py
class UserService:
    @staticmethod
    def crear_usuario(username: str, email: str, password: str):
        usuario = User.objects.create_user(
            username=username,
            email=email,
            password=password
        )
        return usuario
```

**Paso 3: REFACTOR - Mejorar codigo**

```python
# services.py
class UserService:
    @staticmethod
    def crear_usuario(username: str, email: str, password: str, segment: str = '') -> User:
        """
        UC-014: Crear usuario/agente.

        Args:
            username: Nombre de usuario unico
            email: Email del usuario
            password: Contraseña en texto plano
            segment: Segmento del usuario

        Returns:
            Usuario creado

        Raises:
            ValidationError: Si username o email ya existen
        """
        # Validar username unico
        if User.objects.filter(username=username).exists():
            raise ValidationError(f'Username "{username}" ya existe')

        # Validar email unico
        if User.objects.filter(email=email).exists():
            raise ValidationError(f'Email "{email}" ya existe')

        # Crear usuario
        usuario = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            segment=segment,
            status='ACTIVO'
        )
        return usuario
```

### Patron AAA (Arrange-Act-Assert)

Todos los tests deben seguir patron AAA:

```python
def test_ejemplo():
    # ARRANGE: Preparar datos y estado
    usuario = User.objects.create(username='test')
    datos = {'nombre': 'Test'}

    # ACT: Ejecutar accion a probar
    resultado = funcion_a_probar(usuario, datos)

    # ASSERT: Verificar resultado esperado
    assert resultado.nombre == 'Test'
    assert resultado.usuario == usuario
```

### Fixtures con pytest

#### Fixtures Basicos

```python
# conftest.py
import pytest
from django.contrib.auth import get_user_model

User = get_user_model()

@pytest.fixture
def usuario_test(db):
    """Fixture de usuario basico."""
    return User.objects.create_user(
        username='test.user',
        email='test@example.com',
        password='pass123'
    )

@pytest.fixture
def usuario_admin(db):
    """Fixture de usuario administrador."""
    return User.objects.create_superuser(
        username='admin',
        email='admin@example.com',
        password='admin123'
    )

@pytest.fixture
def api_client():
    """Fixture de cliente API."""
    from rest_framework.test import APIClient
    return APIClient()

@pytest.fixture
def authenticated_client(api_client, usuario_test):
    """Fixture de cliente autenticado."""
    token = generate_jwt_token(usuario_test)
    api_client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
    return api_client
```

#### Fixtures Complejos con factory_boy

```python
# factories.py
import factory
from factory.django import DjangoModelFactory

class UserFactory(DjangoModelFactory):
    class Meta:
        model = User

    username = factory.Sequence(lambda n: f'user{n}')
    email = factory.LazyAttribute(lambda obj: f'{obj.username}@example.com')
    first_name = factory.Faker('first_name')
    last_name = factory.Faker('last_name')
    is_active = True

    @factory.post_generation
    def password(obj, create, extracted, **kwargs):
        if extracted:
            obj.set_password(extracted)
        else:
            obj.set_password('default123')

class GrupoFactory(DjangoModelFactory):
    class Meta:
        model = Grupo

    nombre = factory.Sequence(lambda n: f'Grupo {n}')
    descripcion = factory.Faker('text')

# Uso en tests
def test_con_factories():
    usuario = UserFactory(username='custom.user', password='custom123')
    grupo = GrupoFactory()
    assert usuario.username == 'custom.user'
```

### Tests de Modelos

```python
# tests/test_models.py
import pytest
from django.core.exceptions import ValidationError

@pytest.mark.django_db
class TestUserModel:

    def test_crear_usuario_exitoso(self):
        usuario = User.objects.create_user(
            username='test',
            email='test@example.com',
            password='pass123'
        )
        assert usuario.is_active == True
        assert usuario.is_deleted == False
        assert usuario.check_password('pass123')

    def test_username_unico(self):
        User.objects.create_user(username='test', password='pass123')
        with pytest.raises(Exception):  # IntegrityError
            User.objects.create_user(username='test', password='pass123')

    def test_mark_deleted(self):
        usuario = User.objects.create_user(username='test', password='pass123')
        usuario.mark_deleted()
        assert usuario.is_deleted == True
        assert usuario.is_active == False

    def test_str_method(self):
        usuario = User.objects.create_user(username='test', password='pass123')
        assert str(usuario) == 'test'
```

### Tests de Servicios

```python
# tests/test_services.py
import pytest
from django.core.exceptions import ValidationError

@pytest.mark.django_db
class TestUserService:

    def test_crear_usuario_exitoso(self):
        usuario = UserService.crear_usuario(
            username='nuevo',
            email='nuevo@example.com',
            password='SecureP@ss123'
        )
        assert usuario.username == 'nuevo'
        assert usuario.email == 'nuevo@example.com'
        assert usuario.is_active == True

    def test_crear_usuario_username_duplicado_falla(self):
        UserService.crear_usuario(
            username='duplicado',
            email='duplicado@example.com',
            password='pass123'
        )
        with pytest.raises(ValidationError) as exc:
            UserService.crear_usuario(
                username='duplicado',
                email='otro@example.com',
                password='pass123'
            )
        assert 'ya existe' in str(exc.value)

    def test_crear_usuario_email_invalido_falla(self):
        with pytest.raises(ValidationError):
            UserService.crear_usuario(
                username='test',
                email='not-an-email',
                password='pass123'
            )
```

### Tests de Serializers

```python
# tests/test_serializers.py
import pytest

class TestUserSerializer:

    def test_serializer_con_datos_validos(self):
        data = {
            'username': 'test.user',
            'email': 'test@example.com',
            'password': 'SecureP@ss123'
        }
        serializer = UserSerializer(data=data)
        assert serializer.is_valid()
        assert serializer.validated_data['username'] == 'test.user'

    def test_serializer_email_invalido(self):
        data = {
            'username': 'test',
            'email': 'not-an-email',
            'password': 'pass123'
        }
        serializer = UserSerializer(data=data)
        assert not serializer.is_valid()
        assert 'email' in serializer.errors

    def test_serializer_no_expone_password(self):
        usuario = User.objects.create_user(
            username='test',
            email='test@example.com',
            password='pass123'
        )
        serializer = UserSerializer(usuario)
        assert 'password' not in serializer.data
```

### Tests de Views/APIs

```python
# tests/test_views.py
import pytest
from rest_framework import status

@pytest.mark.django_db
class TestUserViewSet:

    def test_listar_usuarios_autenticado(self, authenticated_client, usuario_test):
        response = authenticated_client.get('/api/v1/usuarios/')
        assert response.status_code == status.HTTP_200_OK
        assert len(response.json()['results']) >= 1

    def test_listar_usuarios_sin_autenticacion_falla(self, api_client):
        response = api_client.get('/api/v1/usuarios/')
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_crear_usuario_sin_permiso_falla(self, authenticated_client):
        # authenticated_client es usuario sin permiso crear
        data = {
            'username': 'nuevo',
            'email': 'nuevo@example.com',
            'password': 'pass123'
        }
        response = authenticated_client.post('/api/v1/usuarios/', data=data)
        assert response.status_code == status.HTTP_403_FORBIDDEN

    def test_crear_usuario_con_permiso_exitoso(self, admin_client):
        data = {
            'username': 'nuevo.usuario',
            'email': 'nuevo@example.com',
            'password': 'SecureP@ss123'
        }
        response = admin_client.post('/api/v1/usuarios/', data=data)
        assert response.status_code == status.HTTP_201_CREATED
        assert response.json()['username'] == 'nuevo.usuario'
        assert 'password' not in response.json()
```

### Tests de Integracion

```python
# tests/test_integration.py
import pytest

@pytest.mark.django_db
class TestAuthenticationFlow:

    def test_flujo_login_completo(self, api_client):
        # 1. Crear usuario
        User.objects.create_user(
            username='test',
            email='test@example.com',
            password='pass123'
        )

        # 2. Login
        response = api_client.post('/api/v1/auth/login/', {
            'username': 'test',
            'password': 'pass123'
        })
        assert response.status_code == status.HTTP_200_OK
        assert 'access_token' in response.json()
        assert 'refresh_token' in response.json()

        # 3. Acceder recurso protegido con token
        token = response.json()['access_token']
        api_client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
        response = api_client.get('/api/v1/usuarios/me/')
        assert response.status_code == status.HTTP_200_OK
        assert response.json()['username'] == 'test'
```

### Criterios de salida

- [ ] Tests implementados siguiendo TDD
- [ ] Patron AAA aplicado
- [ ] Fixtures reutilizados
- [ ] Cobertura >= 80%

---

## FASE 3: Ejecucion de Tests

### Objetivo

Ejecutar tests de forma local y automatica en CI.

### Comandos de Ejecucion

```bash
# Todos los tests
pytest

# Con cobertura
pytest --cov=callcentersite --cov-report=html

# Solo unit tests
pytest callcentersite/apps/users/tests/test_services.py

# Solo integration tests
pytest callcentersite/tests/integration/

# Tests de una app
pytest callcentersite/apps/users/

# Test especifico
pytest callcentersite/apps/users/tests/test_services.py::test_crear_usuario_exitoso

# Con verbose
pytest -v

# Con output
pytest -s

# Parallel execution
pytest -n auto

# Stop en primer fallo
pytest -x

# Re-ejecutar tests fallidos
pytest --lf
```

### Configuracion pytest

```ini
# pytest.ini
[pytest]
DJANGO_SETTINGS_MODULE = callcentersite.settings.test
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts =
    --reuse-db
    --nomigrations
    --cov=callcentersite
    --cov-report=html
    --cov-report=term
    --cov-fail-under=80
    -v
    --strict-markers
markers =
    unit: Unit tests
    integration: Integration tests
    functional: Functional tests
    slow: Slow tests (> 1s)
    security: Security tests
```

### Settings de Test

```python
# settings/test.py
from .base import *

DEBUG = False
TESTING = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.MD5PasswordHasher',  # Rapido para tests
]

EMAIL_BACKEND = 'django.core.mail.backends.locmem.EmailBackend'

CELERY_TASK_ALWAYS_EAGER = True
CELERY_TASK_EAGER_PROPAGATES = True

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    }
}
```

### CI Configuration (GitHub Actions)

```yaml
# .github/workflows/backend-tests.yml
name: Backend Tests

on:
  pull_request:
    branches: [develop, main]
  push:
    branches: [develop, main]

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: test_db
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_pass
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install -r requirements-dev.txt

      - name: Run tests
        env:
          DATABASE_URL: postgresql://test_user:test_pass@localhost:5432/test_db
        run: |
          pytest --cov=callcentersite --cov-report=xml --cov-fail-under=80

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
          fail_ci_if_error: true
```

### Criterios de salida

- [ ] Todos los tests pasan
- [ ] Cobertura >= 80%
- [ ] CI pipeline verde

---

## FASE 4: Analisis de Cobertura

### Objetivo

Analizar y mejorar cobertura de tests.

### Metricas de Cobertura

```bash
# Generar reporte
pytest --cov=callcentersite --cov-report=html

# Ver en navegador
open htmlcov/index.html
```

### Objetivo de Cobertura por Componente

| Componente | Objetivo | Razon |
|------------|----------|-------|
| Servicios | >= 90% | Logica critica de negocio |
| Modelos | >= 80% | Persistencia de datos |
| Serializers | >= 85% | Validacion de entrada |
| Views | >= 75% | Orquestacion (menos logica) |
| Utilidades | >= 90% | Funciones reutilizables |

### Analisis de Coverage Report

```
Name                           Stmts   Miss  Cover   Missing
------------------------------------------------------------
callcentersite/apps/users/models.py     45      3    93%   67-69
callcentersite/apps/users/services.py   120     5    96%   145, 189-192
callcentersite/apps/users/views.py      67     15    78%   23-25, 45-50
------------------------------------------------------------
TOTAL                          1234     89    92%
```

**Acciones:**
- Identificar lineas no cubiertas (Missing)
- Priorizar cobertura de servicios y modelos
- Agregar tests para casos no cubiertos

### Criterios de salida

- [ ] Cobertura general >= 80%
- [ ] Servicios >= 90%
- [ ] Sin branches criticos sin cubrir

---

## FASE 5: Tests de Seguridad

### Objetivo

Validar controles de seguridad implementados.

### Tests de Autenticacion

```python
@pytest.mark.security
class TestAuthentication:

    def test_acceso_sin_token_bloqueado(self, api_client):
        response = api_client.get('/api/v1/usuarios/')
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_token_invalido_bloqueado(self, api_client):
        api_client.credentials(HTTP_AUTHORIZATION='Bearer invalid-token')
        response = api_client.get('/api/v1/usuarios/')
        assert response.status_code == status.HTTP_401_UNAUTHORIZED

    def test_token_expirado_bloqueado(self, api_client):
        token_expirado = generate_expired_token()
        api_client.credentials(HTTP_AUTHORIZATION=f'Bearer {token_expirado}')
        response = api_client.get('/api/v1/usuarios/')
        assert response.status_code == status.HTTP_401_UNAUTHORIZED
```

### Tests de Autorizacion

```python
@pytest.mark.security
class TestAuthorization:

    def test_acceso_sin_permiso_bloqueado(self, authenticated_client_sin_permiso):
        response = authenticated_client_sin_permiso.post('/api/v1/usuarios/', data={})
        assert response.status_code == status.HTTP_403_FORBIDDEN

    def test_idor_bloqueado(self, authenticated_client):
        # Crear usuario A y B
        usuario_a = UserFactory()
        usuario_b = UserFactory()

        # Usuario A intenta acceder datos de usuario B
        client_a = autenticar_cliente(usuario_a)
        response = client_a.get(f'/api/v1/usuarios/{usuario_b.id}/')
        assert response.status_code == status.HTTP_403_FORBIDDEN
```

### Tests de Validacion

```python
@pytest.mark.security
class TestValidation:

    def test_sql_injection_bloqueado(self, api_client):
        response = api_client.get('/api/v1/usuarios/?username=admin\' OR \'1\'=\'1')
        assert response.status_code != status.HTTP_500_INTERNAL_SERVER_ERROR

    def test_xss_sanitizado(self, admin_client):
        data = {
            'username': '<script>alert("xss")</script>',
            'email': 'test@example.com',
            'password': 'pass123'
        }
        response = admin_client.post('/api/v1/usuarios/', data=data)
        # Verificar que script se sanitiza o rechaza
        assert '<script>' not in response.json().get('username', '')
```

### Criterios de salida

- [ ] Tests de autenticacion completos
- [ ] Tests de autorizacion completos
- [ ] Tests de validacion completos
- [ ] Sin vulnerabilidades evidentes

---

## FASE 6: Tests de Performance

### Objetivo

Validar que sistema cumple requisitos de performance.

### Tests de Query Performance

```python
@pytest.mark.slow
class TestQueryPerformance:

    def test_listado_usuarios_sin_n_plus_1(self, django_assert_num_queries):
        # Crear 100 usuarios
        UserFactory.create_batch(100)

        # Listar debe hacer solo 2 queries (usuarios + count)
        with django_assert_num_queries(2):
            response = api_client.get('/api/v1/usuarios/')
            assert len(response.json()['results']) == 100
```

### Tests de Response Time

```python
import time

@pytest.mark.slow
class TestResponseTime:

    def test_endpoint_responde_en_menos_de_1_segundo(self, api_client):
        start = time.time()
        response = api_client.get('/api/v1/usuarios/')
        duration = time.time() - start

        assert response.status_code == 200
        assert duration < 1.0  # < 1 segundo
```

### Criterios de salida

- [ ] Sin queries N+1 en endpoints criticos
- [ ] Response time < 1s para endpoints standard
- [ ] Response time < 500ms para endpoints criticos

---

## Metricas del Proceso

| Metrica | Objetivo | Medicion |
|---------|----------|----------|
| Cobertura de tests | >= 80% | pytest --cov |
| Tests unitarios | >= 70% total tests | Conteo de tests |
| Tests integracion | >= 20% total tests | Conteo de tests |
| Tests E2E | >= 10% total tests | Conteo de tests |
| Tiempo ejecucion (local) | < 5 minutos | pytest --durations |
| Tiempo ejecucion (CI) | < 10 minutos | GitHub Actions |
| Tests fallidos | 0 | CI pipeline |
| Flaky tests | 0 | Monitoreo CI |

---

## Herramientas

| Herramienta | Proposito |
|-------------|-----------|
| pytest | Framework de testing |
| pytest-django | Integracion Django |
| pytest-cov | Cobertura de codigo |
| pytest-mock | Mocking |
| factory_boy | Generacion de datos test |
| faker | Datos fake realistas |
| freezegun | Mock de tiempo |
| responses | Mock de requests HTTP |

---

## Referencias

- PROC-BACK-001: Desarrollo de Features Backend
- PROC-BACK-003: Code Review Backend
- TDD_IMPLEMENTACION.md: Metodologia TDD
- lineamientos_codigo.md: Estandares de codigo

---

**Documento generado:** 2025-11-18
**Responsable:** Equipo QA
**Proximo review:** Trimestral
