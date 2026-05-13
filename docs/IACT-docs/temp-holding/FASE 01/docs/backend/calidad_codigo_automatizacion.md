---
id: DOC-BACKEND-CALIDAD-AUTO
estado: activo
propietario: equipo-desarrollo-backend
ultima_actualizacion: 2025-11-04
relacionados: ["ADR_2025_002", "DOC-BACKEND-INDEX", "PROC-DEV-LOCAL", "PROC-QA"]
tipo: documentacion
categoria: desarrollo
date: 2025-11-13
---

# Guía de Calidad de Código y Automatización

Esta guía documenta todas las herramientas de calidad de código, automatización y validación implementadas en el proyecto Backend Django.

## Tabla de Contenidos

1. [Configuración de Pre-commit](#configuración-de-pre-commit)
2. [Ruff - Linter y Formateador](#ruff---linter-y-formateador)
3. [MyPy - Validación de Tipos](#mypy---validación-de-tipos)
4. [Testing con Pytest](#testing-con-pytest)
5. [GitHub Actions CI/CD](#github-actions-cicd)
6. [Logging Profesional](#logging-profesional)
7. [Medición de Rendimiento](#medición-de-rendimiento)
8. [AsyncIO y HTTPX](#asyncio-y-httpx)
9. [Makefile - Automatización](#makefile---automatización)

---

## Configuración de Pre-commit

Pre-commit ejecuta automáticamente validaciones antes de cada commit.

### Instalación

```bash
# Instalar pre-commit
pip install pre-commit

# O usar el Makefile
make pre-commit-install
```

### Hooks Configurados

- **Ruff**: Linter y formateador automático
- **MyPy**: Validación estática de tipos
- **Django Upgrade**: Actualiza código a Django 5.2
- **Bandit**: Análisis de seguridad
- **Detect Secrets**: Detecta credenciales accidentales
- **Pre-commit hooks estándar**: trailing-whitespace, end-of-file-fixer, check-yaml, etc.

### Uso

```bash
# Ejecutar manualmente en todos los archivos
pre-commit run --all-files

# O usar Makefile
make pre-commit-run

# Los hooks se ejecutan automáticamente en cada commit
git commit -m "mensaje"
```

---

## Ruff - Linter y Formateador

Ruff es un linter extremadamente rápido que reemplaza múltiples herramientas (flake8, isort, etc.).

### Configuración

Configurado en `pyproject.toml`:

```toml
[tool.ruff]
line-length = 100
target-version = "py312"

[tool.ruff.lint]
select = [
 "E", "W", # pycodestyle
 "F", # pyflakes
 "I", # isort
 "B", # flake8-bugbear
 "DJ", # flake8-django
 "S", # flake8-bandit (security)
 "ASYNC", # flake8-async
 # ... y muchos más
]
```

### Uso

```bash
# Ejecutar linter
ruff check callcentersite

# Auto-fix
ruff check callcentersite --fix

# Formatear código
ruff format callcentersite

# O usar Makefile
make lint
make lint-fix
make format
```

---

## MyPy - Validación de Tipos

MyPy valida tipos estáticos en Python para detectar errores antes de la ejecución.

### Configuración

Configurado en `pyproject.toml`:

```toml
[tool.mypy]
python_version = "3.12"
warn_return_any = true
strict_optional = true
check_untyped_defs = true
plugins = ["mypy_django_plugin.main", "mypy_drf_plugin.main"]
```

### Uso

```bash
# Ejecutar validación de tipos
mypy callcentersite --show-error-codes --pretty

# O usar Makefile
make type-check
```

### Ejemplo de Código con Types

```python
from typing import Optional, List

def get_user_by_id(user_id: int) -> Optional[User]:
 """Obtiene un usuario por ID."""
 try:
 return User.objects.get(id=user_id)
 except User.DoesNotExist:
 return None

def get_active_users() -> List[User]:
 """Retorna lista de usuarios activos."""
 return list(User.objects.filter(is_active=True))
```

---

## Testing con Pytest

### Ejecución Paralela

```bash
# Tests en paralelo con pytest-xdist
pytest -n auto

# O usar Makefile
make test-fast
```

### Coverage

```bash
# Tests con coverage
pytest --cov=callcentersite --cov-report=html --cov-report=term-missing

# O usar Makefile
make test-coverage

# Ver reporte HTML
open htmlcov/index.html
```

### Configuración

En `pyproject.toml`:

```toml
[tool.pytest.ini_options]
DJANGO_SETTINGS_MODULE = "callcentersite.settings"
addopts = "-v --strict-markers --tb=short"
markers = [
 "unit: Unit tests",
 "integration: Integration tests",
 "slow: Slow tests",
]
```

---

## GitHub Actions CI/CD

### Workflow Configurado

Archivo: `.github/workflows/python_ci.yml`

#### Jobs:

1. **code-quality**: Ejecuta Ruff, MyPy, Bandit
2. **tests**: Ejecuta pytest con coverage en PostgreSQL
3. **performance**: Benchmarks de rendimiento
4. **dependency-check**: Safety y pip-audit para vulnerabilidades

### Triggers

- Push a `main`, `develop`, `feature/*`, `claude/*`
- Pull requests a `main`, `develop`
- Manual dispatch

### Artifacts Generados

- Reporte de Bandit (JSON)
- Coverage HTML
- Benchmark results
- Security reports (Safety, pip-audit)

---

## Logging Profesional

### Configuración de Logging

Archivo: `callcentersite/settings/logging_config.py`

```python
from callcentersite.settings.logging_config import get_logging_config

LOGGING = get_logging_config()
```

#### Handlers:

- **console**: Logs a stdout (nivel INFO)
- **console_debug**: Logs de debug solo en desarrollo
- **file**: Logs rotativos a archivo (10MB, 5 backups)
- **file_debug**: Logs de debug en archivo separado
- **error_file**: Solo errores (10MB, 10 backups)
- **mail_admins**: Envía errores críticos por email a administradores

#### Formatters:

- **verbose**: Formato completo con nivel, timestamp, módulo, proceso, thread
- **simple**: Formato simple con nivel y mensaje
- **json**: Formato JSON para parseo automático

#### Loggers por App:

- `django`: Logs generales de Django
- `django.request`: Errores de requests HTTP
- `django.security`: Advertencias de seguridad
- `django.db.backends`: Queries SQL (solo en debug)
- `callcentersite`: Logs de la aplicación
- `callcentersite.apps.etl`: Logs específicos de ETL
- `callcentersite.apps.authentication`: Logs de autenticación
- `callcentersite.apps.audit`: Logs de auditoría

#### Variables de Entorno:

```bash
LOG_DIR=/var/log/callcentersite # Directorio para archivos de log
DJANGO_LOG_LEVEL=INFO # Nivel de log de Django
APP_LOG_LEVEL=INFO # Nivel de log de la aplicación
```

### Uso en Código

```python
import logging

logger = logging.getLogger(__name__)

def my_function():
 logger.info("Iniciando operación")
 try:
 # código
 logger.debug("Detalles de debug")
 except Exception as e:
 logger.error(f"Error: {e}", exc_info=True)
 # Los errores se registran en error_file y se envían por email

# Logging estructurado con extra fields
logger.info(
 "Operación completada",
 extra={
 "user_id": user.id,
 "operation": "export",
 "duration": elapsed_time,
 }
)
```

### Rotación de Logs

Los archivos de log se rotan automáticamente:

- **django.log**: 10MB máximo, 5 archivos de respaldo
- **django_debug.log**: 10MB máximo, 3 archivos de respaldo
- **django_errors.log**: 10MB máximo, 10 archivos de respaldo

### Retención de Logs

Según restricciones del proyecto:

- **Aplicación**: 30 días
- **Acceso**: 90 días
- **Auditoría**: 2+ años
- **Rotación**: Automática por tamaño

---

## Medición de Rendimiento

### Decoradores de Performance

Archivo: `callcentersite/apps/common/utils/performance.py`

#### Timeit

```python
from callcentersite.apps.common.utils.performance import timeit

@timeit
def expensive_operation():
 # código
 return result

# Logs: "expensive_operation took 1.23 seconds"
```

#### Timeit Verbose

```python
from callcentersite.apps.common.utils.performance import timeit_verbose

@timeit_verbose(iterations=100)
def fast_operation():
 return sum(range(1000))

# Logs: Average, Min, Max over 100 iterations
```

#### Profile Performance

```python
from callcentersite.apps.common.utils.performance import profile_performance

@profile_performance(output_file="profile.txt")
def complex_operation():
 # código complejo
 pass
```

### Context Managers

```python
from callcentersite.apps.common.utils.performance import measure_time, profile_block

# Medir tiempo
with measure_time("Database query"):
 User.objects.all()[:100]

# Profiling de bloque
with profile_block("complex_operation_profile.txt"):
 for i in range(1000):
 complex_calculation()
```

### Performance Monitor

```python
from callcentersite.apps.common.utils.performance import PerformanceMonitor

monitor = PerformanceMonitor()

with monitor.measure("operation1"):
 # código

with monitor.measure("operation2"):
 # código

monitor.report() # Imprime reporte completo
```

### Comando de Profiling

```bash
# Profiling con cProfile
python manage.py profile_code --code="your_code" --output=profile.prof

# Con SnakeViz
python manage.py profile_code --code="your_code" --snakeviz

# O usar Makefile
make profile CODE='your_code_here'
make profile-snakeviz
```

---

## AsyncIO y HTTPX

### Cliente HTTP Asíncrono

Archivo: `callcentersite/apps/common/utils/async_http.py`

#### AsyncHTTPClient

```python
from callcentersite.apps.common.utils.async_http import AsyncHTTPClient

# Context manager
async with AsyncHTTPClient(base_url="https://api.example.com") as client:
 response = await client.get("/endpoint")
 data = response.json()

# Múltiples peticiones en paralelo
urls = ["https://api.example.com/1", "https://api.example.com/2"]
responses = await client.parallel_get(urls)
```

#### Helper Functions

```python
from callcentersite.apps.common.utils.async_http import fetch_url, fetch_multiple

# Single fetch
response = await fetch_url("https://api.example.com/data")
data = response.json()

# Multiple fetches con límite de concurrencia
urls = ["url1", "url2", "url3"]
responses = await fetch_multiple(urls, max_concurrent=5)
```

### Helpers Asíncronos

Archivo: `callcentersite/apps/common/utils/async_helpers.py`

#### Convertir Sync a Async

```python
from callcentersite.apps.common.utils.async_helpers import sync_to_async

@sync_to_async
def blocking_io():
 time.sleep(5)
 return "done"

# Ahora se puede usar con await
result = await blocking_io() # No bloquea el event loop
```

#### Retry con Backoff

```python
from callcentersite.apps.common.utils.async_helpers import retry_async_decorator

@retry_async_decorator(max_retries=5, delay=1.0, backoff=2.0)
async def fetch_data():
 async with httpx.AsyncClient() as client:
 response = await client.get("https://api.example.com")
 return response.json()

data = await fetch_data() # Reintenta automáticamente
```

#### Gather con Concurrencia Limitada

```python
from callcentersite.apps.common.utils.async_helpers import gather_with_concurrency

tasks = [fetch_url(url) for url in urls]
results = await gather_with_concurrency(5, *tasks) # Max 5 concurrentes
```

### Migración de Requests a HTTPX

```python
# ANTES (síncrono con requests)
import requests

def fetch_data(url):
 response = requests.get(url)
 return response.json()

# DESPUÉS (asíncrono con HTTPX)
from callcentersite.apps.common.utils.async_http import fetch_url

async def fetch_data(url):
 response = await fetch_url(url)
 return response.json()
```

---

## Makefile - Automatización

### Comandos Principales

```bash
# Ver todos los comandos disponibles
make help

# Instalación
make install # Dependencias de producción
make dev-install # Dependencias de desarrollo
make setup # Setup completo de desarrollo

# Calidad de código
make lint # Ejecutar linter
make lint-fix # Linter con auto-fix
make format # Formatear código
make type-check # Validar tipos
make security # Análisis de seguridad
make quality # Todas las verificaciones

# Testing
make test # Todos los tests
make test-fast # Tests en paralelo
make test-coverage # Tests con coverage
make test-unit # Solo tests unitarios
make test-integration # Solo tests de integración
make benchmark # Benchmarks

# Django
make migrate # Ejecutar migraciones
make migrations # Crear migraciones
make run # Iniciar servidor
make shell # Django shell
make superuser # Crear superusuario

# Performance
make profile # Profiling de código
make profile-snakeviz # Visualización con SnakeViz

# Limpieza
make clean # Limpiar archivos temporales
make clean-cache # Limpiar cache
make clean-all # Limpieza completa

# CI
make ci # Pipeline completo (quality + coverage)
```

### Personalización

Edita el `Makefile` para agregar tus propios comandos.

---

## Mejores Prácticas

### 1. Pre-commit Always On

```bash
# Instalar una sola vez
make pre-commit-install

# Los hooks se ejecutan automáticamente
git commit -m "mensaje"
```

### 2. Tests Antes de Push

```bash
# Ejecutar tests rápidamente
make test-fast

# O pipeline completo
make ci
```

### 3. Tipos en Funciones Críticas

```python
def process_data(data: dict[str, Any]) -> list[Result]:
 """Procesa datos y retorna resultados."""
 pass
```

### 4. Logging Estructurado

```python
logger.info(
 "Operación completada",
 extra={
 "user_id": user.id,
 "operation": "export",
 "duration": elapsed_time,
 }
)
```

### 5. Async para I/O

```python
# Usar async para llamadas HTTP, DB queries, etc.
async def fetch_external_data():
 async with AsyncHTTPClient() as client:
 response = await client.get("/api/data")
 return response.json()
```

---

## Troubleshooting

### Pre-commit Fails

```bash
# Re-instalar hooks
pre-commit uninstall
pre-commit install

# Actualizar hooks
pre-commit autoupdate
```

### MyPy Errors

```bash
# Ignorar errores temporalmente
# type: ignore

# O específicamente
# type: ignore[attr-defined]
```

---

## Recursos

- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [MyPy Documentation](https://mypy.readthedocs.io/)
- [Pytest Documentation](https://docs.pytest.org/)
- [HTTPX Documentation](https://www.python-httpx.org/)
- [AsyncIO Documentation](https://docs.python.org/3/library/asyncio.html)
- [Django Logging](https://docs.djangoproject.com/en/5.2/topics/logging/)

---

## Contribuir

Para agregar nuevas herramientas de calidad:

1. Actualizar `pyproject.toml` con la configuración
2. Agregar al `.pre_commit_config.yaml` si aplica
3. Agregar comando al `Makefile`
4. Documentar en este archivo
5. Actualizar CI en `.github/workflows/python_ci.yml`
