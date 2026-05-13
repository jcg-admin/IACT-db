# DOCUMENTACION DE IMPLEMENTACION DE SCRIPTS

**Proyecto:** IACT Call Center
**Fecha:** 2025-11-18
**Fase:** FASE 3 - TASK-041
**Version:** 1.0

## Objetivo

Documentar todos los scripts de automatizacion, deployment, testing y mantenimiento del backend, con trazabilidad a requisitos y procesos.

---

## Scripts de Testing

### pytest - Test Runner

**Ubicacion:** `pytest` (instalado globalmente)
**Requisito:** RNF-BACK-060 (Cobertura >= 80%)
**Proceso:** PROC-BACK-001 (Fase 5, 6)

**Uso:**
```bash
# Todos los tests
pytest

# Con cobertura
pytest --cov=callcentersite --cov-report=html --cov-fail-under=80

# Solo un modulo
pytest callcentersite/apps/permissions/tests/

# Solo tests unitarios
pytest -m unit

# Solo tests de integracion
pytest -m integration

# Con verbose
pytest -vv

# Stopping at first failure
pytest -x
```

**Configuracion:** `pytest.ini`

**Outputs:**
- Reporte de tests
- Coverage HTML en `htmlcov/`
- Coverage XML para CI

**Trazabilidad:**
- → MATRIZ-requisitos-tests.md (cobertura completa)
- → PROC-BACK-001 (desarrollo TDD)

---

### flake8 - Linter

**Ubicacion:** `flake8` (instalado en requirements-dev.txt)
**Requisito:** RNF-BACK-061 (Calidad de codigo)
**Proceso:** PROC-BACK-001 (Fase 10 - CI/CD)

**Uso:**
```bash
# Lint todo el proyecto
flake8 callcentersite/

# Con configuracion custom
flake8 --config=.flake8 callcentersite/

# Solo un archivo
flake8 callcentersite/apps/users/models.py

# Generar reporte
flake8 --format=html --htmldir=flake8-report callcentersite/
```

**Configuracion:** `.flake8` o `setup.cfg`

**Reglas principales:**
- Max line length: 100
- Max complexity: 10
- Exclude: migrations, __pycache__

**Trazabilidad:**
- → RNF-BACK-061 (complejidad ciclomatica)
- → lineamientos_codigo.md

---

### black - Code Formatter

**Ubicacion:** `black` (instalado en requirements-dev.txt)
**Requisito:** RNF-BACK-061 (Consistencia de codigo)
**Proceso:** PROC-BACK-001 (Fase 10)

**Uso:**
```bash
# Formatear todo
black callcentersite/

# Solo check (no modificar)
black --check callcentersite/

# Diff de cambios
black --diff callcentersite/

# Un archivo especifico
black callcentersite/apps/users/models.py
```

**Configuracion:** `pyproject.toml`
```toml
[tool.black]
line-length = 100
target-version = ['py311']
include = '\.pyi?$'
extend-exclude = '''
/(
 migrations
 | __pycache__
)/
'''
```

**Trazabilidad:**
- → lineamientos_codigo.md
- → PROC-BACK-001 (code review)

---

### isort - Import Sorter

**Ubicacion:** `isort` (instalado en requirements-dev.txt)
**Requisito:** RNF-BACK-061 (Organizacion imports)
**Proceso:** PROC-BACK-001 (Fase 10)

**Uso:**
```bash
# Ordenar imports
isort callcentersite/

# Solo check
isort --check-only callcentersite/

# Diff de cambios
isort --diff callcentersite/
```

**Configuracion:** `.isort.cfg` o `setup.cfg`
```ini
[isort]
profile = black
line_length = 100
known_django = django
sections = FUTURE,STDLIB,DJANGO,THIRDPARTY,FIRSTPARTY,LOCALFOLDER
```

**Trazabilidad:**
- → lineamientos_codigo.md

---

## Scripts de Seguridad

### bandit - Security Scanner

**Ubicacion:** `bandit` (instalado en requirements-dev.txt)
**Requisito:** RNF-BACK-020 (OWASP compliance)
**Proceso:** PROC-BACK-001 (Fase 10), PROC-BACK-002 (Fase 4)

**Uso:**
```bash
# Scan completo
bandit -r callcentersite/

# Con severity threshold
bandit -r callcentersite/ -ll # Solo low+

# Generar reporte JSON
bandit -r callcentersite/ -f json -o bandit-report.json

# Excluir tests
bandit -r callcentersite/ --exclude callcentersite/*/tests/*
```

**Checks principales:**
- SQL injection
- Hard-coded passwords
- Shell injection
- Insecure crypto
- Yaml unsafe load

**Trazabilidad:**
- → RNF-BACK-020 (OWASP Top 10)
- → PROC-BACK-002 (scan de dependencias)

---

### safety - Dependency Vulnerability Scanner

**Ubicacion:** `safety` (instalado en requirements-dev.txt)
**Requisito:** RNF-BACK-020 (Seguridad)
**Proceso:** PROC-BACK-002 (Fase 4)

**Uso:**
```bash
# Scan vulnerabilities
safety check --file requirements.txt

# Full report
safety check --file requirements.txt --full-report

# JSON output
safety check --file requirements.txt --json

# Con threshold
safety check --file requirements.txt --severity high
```

**Database:** PyUp Safety DB (CVE database)

**Trazabilidad:**
- → PROC-BACK-002 (gestion dependencias)
- → RNF-BACK-020 (seguridad)

---

## Scripts de Django

### manage.py - Django Management

**Ubicacion:** `/api/callcentersite/manage.py`
**Proceso:** Todos los procesos de desarrollo

**Comandos principales:**

#### Migraciones
```bash
# Crear migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Mostrar plan de migraciones
python manage.py showmigrations

# Migrar a version especifica
python manage.py migrate permissions 0001

# Fake migration (mark as applied)
python manage.py migrate --fake permissions 0002

# Rollback
python manage.py migrate permissions zero
```

#### Servidor de desarrollo
```bash
# Runserver
python manage.py runserver

# En otro puerto
python manage.py runserver 8080

# Accesible desde red
python manage.py runserver 0.0.0.0:8000
```

#### Shell
```bash
# Django shell
python manage.py shell

# Shell plus (con modelos auto-importados)
python manage.py shell_plus
```

#### Tests
```bash
# Ejecutar tests Django
python manage.py test

# Con keepdb (no recrear DB)
python manage.py test --keepdb

# Paralelo
python manage.py test --parallel
```

#### Usuarios
```bash
# Crear superuser
python manage.py createsuperuser

# Cambiar password
python manage.py changepassword username
```

#### Utilidades
```bash
# Recolectar static files
python manage.py collectstatic

# Limpiar sesiones expiradas
python manage.py clearsessions

# Verificar deployment
python manage.py check --deploy
```

**Trazabilidad:**
- → PROC-BACK-001 (desarrollo)
- → PROC-BACK-005 (migraciones)

---

## Scripts de Deployment

### Docker Build

**Ubicacion:** `Dockerfile` en root
**Requisito:** RNF-BACK-042 (Escalado horizontal)
**Proceso:** PROC-BACK-007 (Deployment)

**Uso:**
```bash
# Build imagen
docker build -t iact-backend:latest .

# Build con tag especifico
docker build -t iact-backend:v1.2.3 .

# Build sin cache
docker build --no-cache -t iact-backend:latest .

# Multi-stage build optimizado
docker build --target production -t iact-backend:latest .
```

**Dockerfile estructura:**
```dockerfile
FROM python:3.11-slim as base

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
 postgresql-client \
 && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Codigo de aplicacion
COPY . /app
WORKDIR /app

# Usuario no-root
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Puerto
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
 CMD curl -f http://localhost:8000/health/ || exit 1

# Comando
CMD ["gunicorn", "callcentersite.wsgi:application", "--bind", "0.0.0.0:8000"]
```

**Trazabilidad:**
- → RNF-BACK-030 (uptime)
- → PROC-BACK-007 (deployment)

---

### docker-compose - Orquestacion Local

**Ubicacion:** `docker-compose.yml` en root
**Requisito:** Ambiente de desarrollo
**Proceso:** PROC-BACK-001 (Fase 4)

**Uso:**
```bash
# Levantar servicios
docker-compose up

# En background
docker-compose up -d

# Rebuild containers
docker-compose up --build

# Solo un servicio
docker-compose up backend

# Ver logs
docker-compose logs -f backend

# Ejecutar comando
docker-compose exec backend python manage.py migrate

# Detener servicios
docker-compose down

# Limpiar volumenes
docker-compose down -v
```

**Servicios definidos:**
- backend (Django)
- postgres (DB primaria)
- mysql (DB analytics)
- redis (Cache)
- celery (Background tasks)

**Trazabilidad:**
- → PROC-BACK-001 (desarrollo)

---

## Scripts de CI/CD

### GitHub Actions Workflows

**Ubicacion:** `.github/workflows/`

#### backend-tests.yml

**Trigger:** Push a develop, PRs
**Requisito:** RNF-BACK-060 (Tests automaticos)
**Proceso:** PROC-BACK-001 (Fase 10)

```yaml
name: Backend Tests

on:
 push:
 branches: [develop, main]
 pull_request:
 branches: [develop, main]

jobs:
 test:
 runs-on: ubuntu-latest

 services:
 postgres:
 image: postgres:13
 env:
 POSTGRES_PASSWORD: postgres
 options: >-
 --health-cmd pg_isready
 --health-interval 10s

 steps:
 - uses: actions/checkout@v2

 - name: Set up Python
 uses: actions/setup-python@v2
 with:
 python-version: 3.11

 - name: Install dependencies
 run: |
 pip install -r requirements-dev.txt

 - name: Run flake8
 run: flake8 callcentersite/

 - name: Run black
 run: black --check callcentersite/

 - name: Run isort
 run: isort --check-only callcentersite/

 - name: Run bandit
 run: bandit -r callcentersite/

 - name: Run safety
 run: safety check --file requirements.txt

 - name: Run tests
 run: |
 pytest --cov=callcentersite --cov-report=xml --cov-fail-under=80

 - name: Upload coverage
 uses: codecov/codecov-action@v2
```

**Trazabilidad:**
- → PROC-BACK-001 (CI/CD)
- → RNF-BACK-060 (cobertura)

---

#### deploy-staging.yml

**Trigger:** Push a develop (despues de tests OK)
**Proceso:** PROC-BACK-007 (Deployment)

```yaml
name: Deploy to Staging

on:
 push:
 branches: [develop]

jobs:
 deploy:
 runs-on: ubuntu-latest
 needs: test

 steps:
 - uses: actions/checkout@v2

 - name: Build Docker image
 run: docker build -t iact-backend:staging .

 - name: Push to registry
 run: |
 echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
 docker push iact-backend:staging

 - name: Deploy to staging
 run: |
 # Comando de deployment (ejemplo con kubectl)
 kubectl set image deployment/backend backend=iact-backend:staging
```

**Trazabilidad:**
- → PROC-BACK-007 (deployment)
- → PROC-BACK-001 (Fase 11)

---

## Scripts de Mantenimiento

### Limpieza de Sesiones

**Archivo:** `scripts/cleanup_sessions.sh`

```bash
#!/bin/bash
# Limpia sesiones expiradas de la BD

cd /app
python manage.py clearsessions
echo "Sesiones expiradas limpiadas: $(date)"
```

**Cron:** Diario a las 2 AM
**Trazabilidad:** → RNF-BACK-025 (sesiones JWT)

---

### Backup de Base de Datos

**Archivo:** `scripts/backup_database.sh`

```bash
#!/bin/bash
# Backup de PostgreSQL

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"

pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > $BACKUP_DIR/backup_$DATE.sql
gzip $BACKUP_DIR/backup_$DATE.sql

# Limpiar backups antiguos (> 30 dias)
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +30 -delete

echo "Backup completado: backup_$DATE.sql.gz"
```

**Cron:** Diario a las 1 AM
**Trazabilidad:**
- → RNF-BACK-033 (backup diario)
- → RNF-BACK-031 (RPO)

---

### Health Check

**Archivo:** `scripts/health_check.sh`

```bash
#!/bin/bash
# Verifica salud del sistema

# Health endpoint
curl -f http://localhost:8000/health/ || exit 1

# Base de datos
python manage.py dbshell -c "SELECT 1;" || exit 1

# Redis
redis-cli ping || exit 1

echo "Health check OK"
```

**Cron:** Cada 5 minutos
**Trazabilidad:**
- → RNF-BACK-034 (health checks)
- → RNF-BACK-030 (uptime)

---

## Scripts de Utilidades

### Generate Secret Key

**Archivo:** `scripts/generate_secret_key.py`

```python
#!/usr/bin/env python
"""Genera un SECRET_KEY seguro para Django."""

from django.core.management.utils import get_random_secret_key

print(get_random_secret_key())
```

**Uso:**
```bash
python scripts/generate_secret_key.py
```

**Trazabilidad:** → RNF-BACK-021 (seguridad)

---

### Database Migration Check

**Archivo:** `scripts/check_migrations.sh`

```bash
#!/bin/bash
# Verifica que no haya migraciones pendientes

cd /app
PENDING=$(python manage.py showmigrations --plan | grep "[ ]" | wc -l)

if [ $PENDING -gt 0 ]; then
 echo "ERROR: Hay $PENDING migraciones pendientes"
 exit 1
fi

echo "OK: No hay migraciones pendientes"
```

**Uso:** Pre-deployment check
**Trazabilidad:** → PROC-BACK-005 (migraciones)

---

## Matriz de Trazabilidad: Scripts vs Requisitos

| Script | Requisito | Proceso | Frecuencia | Automatizado |
|--------|-----------|---------|------------|--------------|
| pytest | RNF-BACK-060 | PROC-BACK-001 | Por commit | Si (CI) |
| flake8 | RNF-BACK-061 | PROC-BACK-001 | Por commit | Si (CI) |
| black | RNF-BACK-061 | PROC-BACK-001 | Por commit | Si (CI) |
| isort | RNF-BACK-061 | PROC-BACK-001 | Por commit | Si (CI) |
| bandit | RNF-BACK-020 | PROC-BACK-001 | Por commit | Si (CI) |
| safety | RNF-BACK-020 | PROC-BACK-002 | Diario | Si (CI) |
| makemigrations | N/A | PROC-BACK-005 | Manual | No |
| migrate | N/A | PROC-BACK-005 | Deploy | Si (CD) |
| docker build | RNF-BACK-042 | PROC-BACK-007 | Deploy | Si (CD) |
| backup_database.sh | RNF-BACK-033 | N/A | Diario | Si (cron) |
| cleanup_sessions.sh | RNF-BACK-025 | N/A | Diario | Si (cron) |
| health_check.sh | RNF-BACK-034 | N/A | 5 min | Si (cron) |

---

## Resumen de Automatizacion

| Categoria | Scripts | Automatizados | % Automatizacion |
|-----------|---------|---------------|------------------|
| Testing | 4 | 4 | 100% |
| Security | 2 | 2 | 100% |
| Deployment | 3 | 3 | 100% |
| Mantenimiento | 3 | 3 | 100% |
| Utilidades | 3 | 0 | 0% |
| **TOTAL** | **15** | **12** | **80%** |

---

## Referencias

- PROC-BACK-001: Proceso de desarrollo de features
- PROC-BACK-002: Gestion de dependencias
- PROC-BACK-007: Deployment
- RNF-BACK-XXX: Requisitos no funcionales
- lineamientos_codigo.md: Estandares de codigo

---

**Documento generado:** 2025-11-18
**Responsable:** Claude Code Agent
**Proximo review:** Trimestral
