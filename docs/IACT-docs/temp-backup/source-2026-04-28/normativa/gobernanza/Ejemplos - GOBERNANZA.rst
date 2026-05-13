Ejemplos Completos
==================

Este espacio contiene ejemplos completos y funcionales de artefactos
documentales, código y configuraciones del proyecto IACT.

Página padre
------------

-  `Anexos <../README.md>`__

Información clave
-----------------

Tipos de Ejemplos
~~~~~~~~~~~~~~~~~

**Documentación:** - Ejemplos de ADR completos - Ejemplos de
especificaciones de requisitos - Ejemplos de planes de testing -
Ejemplos de runbooks operativos

**Código:** - Servicios completos con tests - Modelos Django con
validaciones - Comandos de management - Scripts de ETL

**Configuración:** - Archivos de configuración completos - Docker
compose files - GitHub Actions workflows - Pre-commit hooks

Ejemplos Disponibles
--------------------

1. ADR Ejemplo - Vagrant Infrastructure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Archivo:**
`ADR_2025_001 <../../arquitectura/adr/ADR_2025_001-vagrant-mod-wsgi.md>`__

**Qué demuestra:** - Estructura completa de un ADR - Análisis de
múltiples opciones - Justificación de decisión - Plan de implementación
- Métricas de validación

**Cuándo usarlo:** Referencia cuando necesites documentar una decisión
arquitectónica significativa.

--------------

2. Servicio Django con Repository Pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ejemplo:**

.. code:: python

   # repositories/call_repository.py
   from typing import List, Optional
   from datetime import date
   from analytics.models import Call

   class CallRepository:
       """Repository for Call data access."""

       def get_calls_by_date(self, target_date: date) -> List[Call]:
           """Retrieve all calls for a specific date."""
           return Call.objects.filter(
               start_time__date=target_date
           ).select_related('agent').all()

       def get_call_by_id(self, call_id: str) -> Optional[Call]:
           """Retrieve a single call by ID."""
           try:
               return Call.objects.get(call_id=call_id)
           except Call.DoesNotExist:
               return None

   # services/metrics_service.py
   from typing import Dict
   from datetime import date
   from .repositories import CallRepository

   class MetricsService:
       """Service for calculating call center metrics."""

       def __init__(self):
           self.call_repo = CallRepository()

       def calculate_daily_aht(self, target_date: date) -> float:
           """Calculate Average Handling Time for a date."""
           calls = self.call_repo.get_calls_by_date(target_date)

           if not calls:
               return 0.0

           total_duration = sum(call.duration for call in calls)
           return total_duration / len(calls)

   # tests/test_metrics_service.py
   import pytest
   from datetime import date
   from services import MetricsService
   from tests.factories import CallFactory

   class TestMetricsService:
       """Tests for MetricsService."""

       def setup_method(self):
           self.service = MetricsService()
           self.test_date = date(2025, 11, 2)

       def test_calculate_daily_aht_with_calls(self):
           """Should calculate correct AHT when calls exist."""
           # Arrange
           CallFactory.create_batch(3, start_time=self.test_date, duration=120)

           # Act
           result = self.service.calculate_daily_aht(self.test_date)

           # Assert
           assert result == 120.0

       def test_calculate_daily_aht_no_calls(self):
           """Should return 0 when no calls exist."""
           result = self.service.calculate_daily_aht(self.test_date)
           assert result == 0.0

**Qué demuestra:** - Repository Pattern para abstracción de datos -
Service Layer para lógica de negocio - Tests con patrón
Arrange-Act-Assert - Type hints completos - Docstrings descriptivos

--------------

3. GitHub Actions Workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ejemplo:**

.. code:: yaml

   # .github/workflows/ci.yml
   name: CI Pipeline

   on:
     pull_request:
       branches: [main, develop]
     push:
       branches: [main, develop]

   jobs:
     quality:
       runs-on: ubuntu-latest

       steps:
         - uses: actions/checkout@v3

         - name: Set up Python
           uses: actions/setup-python@v4
           with:
             python-version: '3.11'

         - name: Cache dependencies
           uses: actions/cache@v3
           with:
             path: ~/.cache/pip
             key: ${{ runner.os }}-pip-${{ hashFiles('requirements.txt') }}

         - name: Install dependencies
           run: |
             pip install -r requirements.txt
             pip install black pylint flake8 mypy pytest-cov

         - name: Format check
           run: black --check .

         - name: Lint
           run: |
             pylint **/*.py
             flake8 .

         - name: Type check
           run: mypy .

         - name: Tests with coverage
           run: pytest --cov=. --cov-report=xml --cov-fail-under=80

         - name: Upload coverage
           uses: codecov/codecov-action@v3
           with:
             file: ./coverage.xml

**Qué demuestra:** - Pipeline CI completo - Caching de dependencias -
Múltiples checks de calidad - Requisito de cobertura mínima

--------------

4. Docker Compose para Desarrollo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ejemplo:**

.. code:: yaml

   # docker_compose.yml
   version: '3.8'

   services:
     postgres:
       image: postgres:15-alpine
       container_name: iact_postgres
       environment:
         POSTGRES_USER: django_user
         POSTGRES_PASSWORD: django_pass
         POSTGRES_DB: iact_analytics
       ports:
         - "15432:5432"
       volumes:
         - postgres_data:/var/lib/postgresql/data
         - ./scripts/init-postgres.sql:/docker-entrypoint-initdb.d/init.sql
       healthcheck:
         test: ["CMD-SHELL", "pg_isready -U django_user"]
         interval: 10s
         timeout: 5s
         retries: 5

     mariadb:
       image: mariadb:10.11
       container_name: iact_mariadb
       environment:
         MYSQL_ROOT_PASSWORD: rootpass
         MYSQL_USER: django_user
         MYSQL_PASSWORD: django_pass
         MYSQL_DATABASE: iact_ivr
       ports:
         - "13306:3306"
       volumes:
         - mariadb_data:/var/lib/mysql
       healthcheck:
         test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
         interval: 10s
         timeout: 5s
         retries: 5

     django:
       build: .
       container_name: iact_django
       command: python manage.py runserver 0.0.0.0:8000
       volumes:
         - .:/app
       ports:
         - "8000:8000"
       depends_on:
         postgres:
           condition: service_healthy
         mariadb:
           condition: service_healthy
       environment:
         - DATABASE_URL=postgresql://django_user:django_pass@postgres:5432/iact_analytics
         - IVR_DATABASE_URL=mysql://django_user:django_pass@mariadb:3306/iact_ivr

   volumes:
     postgres_data:
     mariadb_data:

**Qué demuestra:** - Multi-container setup - Health checks - Volume
management - Dependency ordering - Environment variables

--------------

5. Pre-commit Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Ejemplo:**

.. code:: yaml

   # .pre_commit_config.yaml
   repos:
     - repo: https://github.com/psf/black
       rev: 23.11.0
       hooks:
         - id: black
           language_version: python3.11

     - repo: https://github.com/pycqa/isort
       rev: 5.12.0
       hooks:
         - id: isort
           args: ["--profile", "black"]

     - repo: https://github.com/pycqa/flake8
       rev: 6.1.0
       hooks:
         - id: flake8
           args: ['--max-line-length=88', '--extend-ignore=E203']

     - repo: https://github.com/pre-commit/mirrors-mypy
       rev: v1.7.0
       hooks:
         - id: mypy
           additional_dependencies: [types-all]

     - repo: https://github.com/pre-commit/pre-commit-hooks
       rev: v4.5.0
       hooks:
         - id: trailing-whitespace
         - id: end-of-file-fixer
         - id: check-yaml
         - id: check-added-large-files
         - id: detect-private-key

**Qué demuestra:** - Hooks de calidad automáticos - Formateo automático
- Detección de secrets - Validación de archivos

Cómo Usar Estos Ejemplos
------------------------

1. **Leer y entender** el ejemplo completo
2. **Copiar** la estructura relevante
3. **Adaptar** a tu caso específico
4. **Probar** que funciona correctamente
5. **Documentar** cambios significativos

Convenciones
------------

-  Todos los ejemplos deben ser funcionales (no pseudocódigo)
-  Incluir comentarios explicativos
-  Seguir lineamientos del proyecto
-  Incluir tests cuando sea código

Recursos relacionados
---------------------

-  `Plantillas <../../plantillas/README.md>`__
-  `Lineamientos de
   Código <../../arquitectura/lineamientos_codigo.md>`__
-  `Checklists <../../checklists/README.md>`__
