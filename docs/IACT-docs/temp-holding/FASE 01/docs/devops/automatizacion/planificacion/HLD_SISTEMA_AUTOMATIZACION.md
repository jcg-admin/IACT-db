---
title: HLD - Extension Sistema de Automatizacion IACT
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: design
subfase: hld
proyecto: IACT---project
modelo_referencia: TFG-Server (adaptado)
status: in_progress
version: 2.0
---

# High-Level Design: Extension Sistema de Automatizacion IACT

**Issue**: IACT-AUTO-001
**Fase**: FASE 3 - DESIGN (High-Level Design)
**Fecha**: 2025-11-13
**Version**: 2.0 (Reescrito con arquitectura real)

---

## IMPORTANTE: Contexto del Diseno

Este HLD diseña la **EXTENSION** del sistema de automatizacion existente de IACT, NO un sistema desde cero.

**IACT YA TIENE**:
- Git hooks funcionales (pre-commit, commit-msg, pre-push, pre-rebase)
- Pre-commit framework (Python) configurado en API
- Validaciones exhaustivas (ruff, mypy, bandit, detect-secrets, no-emojis)
- Scripts de testing, deployment, validacion seguridad/DB
- Configuracion completa pyproject.toml

**LO QUE AGREGAREMOS**:
1. Sistema de Constitucion (gobernanza codificada) - NUEVO
2. CI/CD Local unificado UI+API - EXTENSION
3. Integracion con DevContainer lifecycle hooks - EXTENSION
4. Documentacion completa del sistema - NUEVO
5. Orquestacion centralizada de validaciones - EXTENSION

---

## 1. Vision General del Sistema

### 1.1 Arquitectura Real de IACT

```
IACT---project/
├── ui/                                 # Frontend React + Webpack
│   ├── src/                           # Componentes React
│   ├── public/                        # Assets estaticos
│   ├── package.json                   # Deps: React 18, Webpack 5, Redux, Jest
│   ├── webpack.config.cjs             # Configuracion build
│   ├── jest.config.cjs                # Testing config
│   └── scripts/                       # Scripts UI-specific
│
├── api/callcentersite/                # Backend Django 4.2 + Python 3.12
│   ├── manage.py                      # Django CLI
│   ├── pyproject.toml                 # Ruff, MyPy, Pytest, Coverage config
│   ├── .pre_commit_config.yaml        # Pre-commit hooks (YA CONFIGURADO)
│   ├── pytest.ini                     # Test configuration
│   └── [apps Django...]              # Applications
│
├── infrastructure/                    # Infraestructura y Entornos
│   ├── devcontainer/                 # DevContainer con Docker Compose
│   │   ├── devcontainer.json        # Lifecycle hooks ya configurados
│   │   ├── docker_compose.yml       # PostgreSQL + MariaDB
│   │   └── scripts/                 # init_host, on_create, post_create, etc.
│   ├── vagrant/                      # Vagrant alternativo
│   └── cpython/                      # CPython precompilado custom
│
├── scripts/                          # Automatizacion Centralizada
│   ├── install_hooks.sh             # Ya existe - Instalador hooks
│   ├── git-hooks/                   # Ya existe - Templates hooks
│   │   ├── pre-commit              # Validaciones rapidas
│   │   ├── commit-msg              # Conventional Commits
│   │   ├── pre-push                # Tests + Linting
│   │   └── pre-rebase              # Proteccion ramas
│   ├── clean_emojis.sh             # Ya existe
│   ├── validate_security_config.sh  # Ya existe
│   ├── validate_database_router.sh  # Ya existe
│   ├── run_all_tests.sh            # Ya existe
│   ├── deploy.sh                    # Ya existe
│   └── [40+ scripts mas...]        # Ya existen
│
├── docs/devops/                      # Documentacion DevOps (NUEVA ESTRUCTURA)
│   ├── automatizacion/
│   │   ├── constitucion/           # Sistema constitucion - A CREAR
│   │   ├── git_hooks/              # Docs hooks - A DOCUMENTAR
│   │   ├── ci_cd/                  # CI local - A EXTENDER
│   │   └── planificacion/          # SDLC docs (este HLD)
│   └── git/                         # Guias Git
│
└── .git/hooks/                       # Hooks instalados (generados por install_hooks.sh)
```

**Bases de Datos**:
1. **PostgreSQL** (puerto 5432): Base de datos principal
2. **MariaDB** (puerto 3306): Base de datos secundaria
3. **Database Router**: Ya configurado y validado (validate_database_router.sh)

**Stack Tecnologico Real**:
- **Frontend**: React 18.3.1, Webpack 5.95, Redux Toolkit 2.2, Jest 29, ESLint 8
- **Backend**: Django 4.2, Python 3.12, DRF, Ruff, MyPy, Pytest
- **Infraestructura**: Docker Compose, DevContainer, Vagrant, CPython custom
- **Automatizacion**: Pre-commit framework, Bash scripts, Python scripts

---

### 1.2 Sistema de Automatizacion EXISTENTE (Analisis)

#### 1.2.1 Git Hooks Actuales

**Ubicacion**: `scripts/git-hooks/`
**Instalador**: `scripts/install_hooks.sh`

**Hooks Implementados**:
```bash
# pre-commit: Validaciones rapidas
- Deteccion emojis
- Syntax check
- Debug statements
- File size limits

# commit-msg: Conventional Commits
- Formato: type(scope): description
- Tipos: feat, fix, docs, style, refactor, test, chore

# pre-push: Tests y Linting
- Ejecutar tests
- Linting completo
- Validaciones seguridad

# pre-rebase: Proteccion ramas
- Bloquear rebase en main/develop
```

**Fortalezas**:
- Sistema funcional y en uso
- Instalacion automatizada
- Documentado (menciona ESTRATEGIA_GIT_HOOKS.md)
- Permite bypass (--no-verify)

**Gaps Identificados**:
- No hay sistema de constitucion (principios codificados)
- Validaciones especificas UI no documentadas
- No hay orquestacion centralizada UI+API
- Falta integracion con DevContainer hooks

#### 1.2.2 Pre-commit Framework (API)

**Ubicacion**: `api/callcentersite/.pre_commit_config.yaml`

**Hooks Configurados**:
1. **Ruff** (v0.6.9):
   - Linter Python (reemplaza Flake8, isort, etc.)
   - Formatter Python (reemplaza Black)
   - Config: pyproject.toml

2. **MyPy** (v1.13.0):
   - Type checking estatico
   - Plugins: django-stubs, djangorestframework-stubs
   - Excluye: migrations, tests

3. **Pre-commit Hooks Standard**:
   - trailing-whitespace, end-of-file-fixer
   - check-yaml, check-json, check-toml
   - check-large-files (max 1MB)
   - check-merge-conflict
   - debug-statements
   - mixed-line-ending (force LF)

4. **Django-upgrade** (v1.21.0):
   - Actualizar sintaxis Django a 5.2

5. **Bandit** (v1.7.10):
   - Security scanning
   - Config: pyproject.toml

6. **detect-secrets** (v1.5.0):
   - Deteccion de secretos/credenciales
   - Baseline: .secrets.baseline

7. **Hook Custom - no-emojis**:
   - Script: `python scripts/check_no_emojis.py`
   - Files: .md, .txt, .py, .js, .ts, .yaml, .json, .sh
   - Descripcion: "Prevenir uso de emojis en documentacion y codigo"

**Fortalezas**:
- Configuracion exhaustiva y profesional
- Incluye seguridad (bandit, detect-secrets)
- Hook custom no-emojis (alineado con requisitos)
- Integracion pre-commit.ci

**Gaps Identificados**:
- Solo cubre API (Python/Django)
- UI (React/JS) no tiene pre-commit equivalente
- No valida coherencia cross-stack (UI llamando API correctamente)

#### 1.2.3 Scripts de Validacion Existentes

**Analisis de `scripts/` (40+ scripts)**:

**Scripts Testing**:
- `run_all_tests.sh`: Ejecuta todos los tests
- `run_integration_tests.sh`: Tests integracion

**Scripts Validacion**:
- `validate_security_config.sh`: Seguridad
- `validate_database_router.sh`: Database routing
- `validate_critical_restrictions.sh`: Restricciones criticas
- `validar_estructura_docs.sh`: Estructura documentacion
- `clean_emojis.sh`: Limpiar emojis (¡ya existe!)

**Scripts DevOps**:
- `deploy.sh`: Deployment automatizado
- `health_check.sh`: Health checks
- `complete_sync.sh`: Sincronizacion completa
- `cleanup_branches.sh`: Limpieza ramas
- `cleanup_sessions.sh`: Limpieza sesiones

**Scripts Analisis**:
- `analyze_backend.py`: Analisis backend
- `dora_metrics.py`: Metricas DORA
- `generate_dora_report.sh`: Reportes DORA
- `completeness_analysis_agent.py`: Analisis completitud

**Gaps Identificados**:
- Scripts dispersos, no hay orquestacion central
- Falta pipeline CI/CD local unificado que los ejecute todos
- No hay sistema que valide cumplimiento de principios (constitucion)

#### 1.2.4 Herramientas Auxiliares de Desarrollo (Capa Separada)

**IMPORTANTE**: Diferenciacion entre scripts de automatizacion vs herramientas auxiliares

**Herramientas Auxiliares** (NO parte del sistema automatizacion core):
- **Agentes de Analisis**:
  - `completeness_analysis_agent.py`: Analiza completitud documentacion
  - `analyze_backend.py`: Analisis arquitectura backend
  - `test_documentation_alignment.py`: Verifica alineacion docs

- **Metricas y Reportes**:
  - `dora_metrics.py`: Calcula metricas DORA (DevOps Research & Assessment)
  - `generate_dora_report.sh`: Genera reportes DORA
  - Scripts benchmarking

- **Herramientas Reorganizacion**:
  - `reorganizar_docs_por_dominio.sh`: Reorganizacion documentacion
  - Otros scripts de migracion/transformacion

**Diferencia Clave**:
- **Automatizacion Core** (hooks, CI, validaciones): Se ejecutan AUTOMATICAMENTE en eventos (commit, push, build)
- **Herramientas Auxiliares**: Se ejecutan MANUALMENTE por desarrolladores para analisis/reportes/reorganizacion

**Separacion en Documentacion**:
- Automatizacion Core → `docs/devops/automatizacion/` (este HLD)
- Herramientas Auxiliares → `docs/devops/herramientas_desarrollo/` (separado)

**Razon**: Las herramientas auxiliares son valiosas pero no son parte del flujo automatico de desarrollo. Son ad-hoc, manuales, y usadas para tareas especificas de analisis/reportes.

---

### 1.3 Componentes NUEVOS a Agregar

Basado en analisis de sistema existente y modelo TFG-Server:

**N1: Sistema de Constitucion**
- Codificar principios arquitectonicos en YAML
- Validar decisiones contra constitucion
- Sistema de evolucion de reglas (warning → error)
- Integracion con hooks existentes

**N2: CI/CD Local Unificado**
- Pipeline que ejecute TODAS las validaciones UI+API
- Stages: lint, test, build, validate, security
- Ejecutable offline (sin GitHub Actions)
- Orquestacion de scripts existentes

**N3: Integracion DevContainer**
- Hooks en lifecycle DevContainer
- Validaciones en onCreateCommand, postCreateCommand
- Verificacion entorno en postStartCommand

**N4: Documentacion Sistema Completo**
- Guia instalacion hooks
- Guia uso constitucion
- Guia CI local
- Troubleshooting
- Contribucion

**N5: Dashboarding y Observabilidad**
- Logs centralizados (.automation-logs/)
- Metricas de conformidad constitucion
- Reportes de validaciones

---

## 2. Arquitectura del Sistema COMPLETO (Existente + Nuevo)

### 2.1 Diagrama de Arquitectura Integrada

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DESARROLLADOR LOCAL                                │
│                                                                              │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐             │
│  │  git commit  │      │   git push   │      │ npm run ci   │             │
│  └──────┬───────┘      └──────┬───────┘      └──────┬───────┘             │
│         │ trigger             │ trigger             │ invoca              │
│         ▼                     ▼                     ▼                      │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │              GIT HOOKS LAYER (.git/hooks/)                           │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐ │  │
│  │  │  pre-commit   commit-msg   pre-push   pre-rebase               │ │  │
│  │  │  (YA EXISTE)  (YA EXISTE)  (YA EXISTE) (YA EXISTE)             │ │  │
│  │  └───────┬────────────┬────────────┬────────────┬──────────────────┘ │  │
│  │          │            │            │            │                     │  │
│  │          │ delega     │ delega     │ delega     │ delega              │  │
│  │          ▼            ▼            ▼            ▼                     │  │
│  │  ┌────────────────────────────────────────────────────────────────┐  │  │
│  │  │          PRE-COMMIT FRAMEWORK (API Python)                     │  │  │
│  │  │          (.pre_commit_config.yaml - YA EXISTE)                 │  │  │
│  │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │  │  │
│  │  │  │   Ruff   │ │  MyPy    │ │  Bandit  │ │  Custom  │          │  │  │
│  │  │  │ Lint+Fmt │ │TypeCheck │ │ Security │ │NoEmojis  │          │  │  │
│  │  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘          │  │  │
│  │  └────────────────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│         ▼ invoca scripts                                                   │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │         AUTOMATION SCRIPTS LAYER (scripts/ - YA EXISTEN)             │  │
│  │                                                                       │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────────┐  │  │
│  │  │run_all_tests │ │validate_     │ │validate_     │ │clean_      │  │  │
│  │  │    .sh       │ │security_     │ │database_     │ │emojis.sh   │  │  │
│  │  │              │ │config.sh     │ │router.sh     │ │            │  │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘ └────────────┘  │  │
│  │                                                                       │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                │  │
│  │  │  deploy.sh   │ │ health_      │ │ dora_        │                │  │
│  │  │              │ │ check.sh     │ │ metrics.py   │                │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘                │  │
│  │                                                                       │  │
│  │  [40+ scripts adicionales...]                                        │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│         ▼ usa                                ▼ orquesta (NUEVO)            │
│  ┌──────────────────────────────┐  ┌───────────────────────────────────┐  │
│  │  CONFIGURATION LAYER         │  │  CI/CD LOCAL PIPELINE (NUEVO)     │  │
│  │                              │  │                                    │  │
│  │  pyproject.toml (API)        │  │  scripts/ci-local.sh              │  │
│  │  package.json (UI)           │  │  ┌─────────────────────────────┐  │  │
│  │  .pre_commit_config.yaml     │  │  │ STAGE 1: Lint UI + API      │  │  │
│  │  .eslintrc (UI)              │  │  │  - ESLint (UI)              │  │  │
│  │  jest.config.cjs (UI)        │  │  │  - Ruff (API)               │  │  │
│  │  pytest.ini (API)            │  │  ├─────────────────────────────┤  │  │
│  │                              │  │  │ STAGE 2: Test UI + API      │  │  │
│  │  .constitucion.yaml (NUEVO)  │◄─┤  │  - Jest (UI)                │  │  │
│  │  .ci-local.yaml (NUEVO)      │  │  │  - Pytest (API)             │  │  │
│  └──────────────────────────────┘  │  ├─────────────────────────────┤  │  │
│                                     │  │ STAGE 3: Build UI + API     │  │  │
│                                     │  │  - Webpack build (UI)       │  │  │
│                                     │  │  - Django collectstatic     │  │  │
│                                     │  ├─────────────────────────────┤  │  │
│                                     │  │ STAGE 4: Validate           │  │  │
│                                     │  │  - Security (bandit)        │  │  │
│                                     │  │  - DB router                │  │  │
│                                     │  │  - Constitucion (NUEVO)     │  │  │
│                                     │  │  - Docs estructura          │  │  │
│                                     │  └─────────────────────────────┘  │  │
│                                     └───────────────────────────────────┘  │
│                                                                             │
│         ▼ registra                                                          │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │              LOGGING & OBSERVABILITY LAYER (NUEVO)                   │  │
│  │                                                                       │  │
│  │  .automation-logs/                                                   │  │
│  │    ├── pre-commit/            # Logs pre-commit                      │  │
│  │    ├── pre-push/              # Logs pre-push                        │  │
│  │    ├── ci-local/              # Logs CI local                        │  │
│  │    └── constitucion/          # Reportes conformidad                 │  │
│  │                                                                       │  │
│  │  Metricas:                                                            │  │
│  │    - Conformidad constitucion (% reglas cumplidas)                   │  │
│  │    - Tiempo ejecucion validaciones                                   │  │
│  │    - Tests pass rate                                                 │  │
│  │    - Coverage trends                                                 │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                   DEVCONTAINER LIFECYCLE HOOKS (EXISTENTE)                   │
│                                                                              │
│  initializeCommand (HOST) ──┐                                               │
│  onCreateCommand (CONTAINER)──┤ Ejecutan scripts infrastructure/devcontainer│
│  updateContentCommand ────────┤                                              │
│  postCreateCommand ───────────┤ EXTENSION: Validar con constitucion (NUEVO) │
│  postStartCommand ────────────┘                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        SERVICIOS INFRAESTRUCTURA                             │
│                                                                              │
│  ┌───────────────┐      ┌───────────────┐      ┌───────────────┐           │
│  │  PostgreSQL   │      │   MariaDB     │      │  Django App   │           │
│  │  (port 5432)  │      │  (port 3306)  │      │  (port 8000)  │           │
│  └───────────────┘      └───────────────┘      └───────────────┘           │
│                                                                              │
│  Validado por: validate_database_router.sh (YA EXISTE)                      │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 2.2 Flujos de Datos Principales

#### 2.2.1 FLUJO EXISTENTE: Pre-Commit en API

```
DESARROLLADOR edita archivo Python en api/

↓ git add api/callcentersite/users/models.py
↓ git commit -m "feat(users): add email verification"
↓

.git/hooks/pre-commit (instalado via install_hooks.sh)
  │
  ├─ Validaciones rapidas (scripts/git-hooks/pre-commit):
  │   ├─ Buscar emojis
  │   ├─ Check syntax Python basico
  │   ├─ Detectar debug statements (pdb.set_trace, console.log)
  │   └─ Verificar file size < limite
  │
  ├─ Invoca: pre-commit run (framework Python)
  │   │
  │   ├─ Ruff (lint + format):
  │   │   ├─ 70+ reglas Python (E, W, F, Django, Security, etc.)
  │   │   ├─ Auto-fix donde posible
  │   │   └─ Exit 1 si errores no auto-fixeables
  │   │
  │   ├─ MyPy (type checking):
  │   │   ├─ Verificar tipos estaticos
  │   │   ├─ Plugin django-stubs
  │   │   └─ Skip migrations, tests
  │   │
  │   ├─ Bandit (security):
  │   │   ├─ Scan vulnerabilidades (SQL injection, hardcoded passwords, etc.)
  │   │   └─ Exclude tests/
  │   │
  │   ├─ detect-secrets:
  │   │   ├─ Buscar API keys, tokens, passwords
  │   │   └─ Compare contra .secrets.baseline
  │   │
  │   └─ check_no_emojis.py (custom):
  │       ├─ Regex emojis Unicode
  │       ├─ Scan archivos staged .py, .md, .js, etc.
  │       └─ Exit 1 si encuentra emojis
  │
  └─ Si TODO pasa → Commit permitido
      Si ALGO falla → Commit bloqueado, mostrar errores

.git/hooks/commit-msg (instalado via install_hooks.sh)
  │
  ├─ Leer mensaje commit
  ├─ Validar Conventional Commits:
  │   Regex: ^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+
  └─ Exit 0 si valido, Exit 1 si invalido

COMMIT CREADO (si ambos hooks pasan)
```

**Duracion Total**: 3-10 segundos (rapido gracias a Ruff)

---

#### 2.2.2 FLUJO NUEVO: Validacion Constitucion en Pre-Push

```
DESARROLLADOR hace push

↓ git push origin feature/new-dashboard
↓

.git/hooks/pre-push (YA EXISTE - EXTENDER)
  │
  ├─ Validaciones existentes:
  │   ├─ Ejecutar tests (run_all_tests.sh)
  │   ├─ Linting completo
  │   └─ Validaciones seguridad
  │
  ├─ NUEVO: Validacion Constitucion
  │   │
  │   ├─ scripts/constitucion.sh --mode=pre-push
  │   │   │
  │   │   ├─ Cargar .constitucion.yaml
  │   │   │
  │   │   ├─ REGLA 1: No push directo main/master
  │   │   │   if branch_destino == "main": EXIT 1
  │   │   │
  │   │   ├─ REGLA 2: Branch naming convention
  │   │   │   if !match(feature|bugfix|hotfix|refactor|docs): EXIT 1
  │   │   │
  │   │   ├─ REGLA 3: Tests deben pasar
  │   │   │   Ejecuta: ./scripts/run_all_tests.sh
  │   │   │   if exit_code != 0: EXIT 1
  │   │   │
  │   │   ├─ REGLA 4: UI y API coherentes
  │   │   │   Validar: Si cambios en API endpoints, hay tests UI?
  │   │   │   Severity: WARNING (permite push con advertencia)
  │   │   │
  │   │   ├─ REGLA 5: Database migrations sincronizadas
  │   │   │   if hay migration sin squash y >10 migrations: WARNING
  │   │   │
  │   │   └─ Log resultado: .automation-logs/constitucion/pre-push-*.log
  │   │
  │   └─ Mostrar reporte:
  │       CONSTITUCION: 4/5 reglas PASS, 1 WARNING
  │       [WARNING] R4: UI y API coherentes
  │       Cambios en API endpoints sin tests UI correspondientes
  │       Recomendacion: Agregar tests UI en ui/src/__tests__/
  │
  └─ Exit 0 si severity != ERROR (permite push con warnings)
      Exit 1 si violation ERROR

PUSH PERMITIDO/BLOQUEADO segun resultado
```

**Duracion**: 10-60 segundos (depende de tests)

---

#### 2.2.3 FLUJO NUEVO: CI/CD Local Unificado UI+API

```
DESARROLLADOR ejecuta manualmente

↓ npm run ci:local
↓ (o ./scripts/ci-local.sh)
↓

scripts/ci-local.sh (NUEVO - Orquestador)
  │
  ├─ Cargar .ci-local.yaml
  ├─ Detectar cambios: git diff main...HEAD
  ├─ Determinar stages a ejecutar (UI changed? API changed? Both?)
  │
  ├─ STAGE 1: LINT (Paralelo)
  │   ├─ LINT UI:
  │   │   cd ui/
  │   │   npm run lint (ESLint)
  │   │   Exit code → $LINT_UI_STATUS
  │   │
  │   └─ LINT API:
  │       cd api/callcentersite/
  │       ruff check .
  │       Exit code → $LINT_API_STATUS
  │
  │   Si fail_fast=true && (LINT_UI_STATUS != 0 || LINT_API_STATUS != 0):
  │     ABORT pipeline, mostrar errores
  │
  ├─ STAGE 2: TEST (Paralelo)
  │   ├─ TEST UI:
  │   │   cd ui/
  │   │   npm run test:coverage
  │   │   Jest ejecuta tests React
  │   │   Coverage threshold: 80%
  │   │   Exit code → $TEST_UI_STATUS
  │   │
  │   └─ TEST API:
  │       cd api/callcentersite/
  │       pytest --cov --cov-report=term
  │       Coverage threshold: 80% (pyproject.toml)
  │       Exit code → $TEST_API_STATUS
  │
  │   Si alguno falla → ABORT (fail_fast)
  │
  ├─ STAGE 3: BUILD (Paralelo)
  │   ├─ BUILD UI:
  │   │   cd ui/
  │   │   npm run build (Webpack production)
  │   │   Genera bundle optimizado
  │   │   Exit code → $BUILD_UI_STATUS
  │   │
  │   └─ BUILD API:
  │       cd api/callcentersite/
  │       python manage.py collectstatic --noinput
  │       python manage.py check --deploy
  │       Exit code → $BUILD_API_STATUS
  │
  ├─ STAGE 4: VALIDATE (Secuencial)
  │   ├─ Security:
  │   │   ./scripts/validate_security_config.sh
  │   │   bandit -r api/ (ya en pre-commit, pero full scan)
  │   │
  │   ├─ Database:
  │   │   ./scripts/validate_database_router.sh
  │   │   Verificar PostgreSQL + MariaDB routing correcto
  │   │
  │   ├─ Constitucion (NUEVO):
  │   │   ./scripts/constitucion.sh --validate-all
  │   │   Validar TODAS las reglas (no solo pre-push)
  │   │   Generar reporte conformidad
  │   │
  │   ├─ Docs:
  │   │   ./scripts/validar_estructura_docs.sh
  │   │   Verificar estructura docs/devops/ correcta
  │   │
  │   └─ Critical Restrictions:
  │       ./scripts/validate_critical_restrictions.sh
  │
  ├─ STAGE 5: REPORT
  │   ├─ Generar resumen:
  │   │   CI Local Pipeline: PASSED
  │   │   ├─ Lint UI:    PASS (0 errors)
  │   │   ├─ Lint API:   PASS (0 errors)
  │   │   ├─ Test UI:    PASS (85% coverage, 42/50 tests)
  │   │   ├─ Test API:   PASS (87% coverage, 156/180 tests)
  │   │   ├─ Build UI:   PASS (bundle 2.3MB)
  │   │   ├─ Build API:  PASS (static collected)
  │   │   └─ Validate:   PASS (2 warnings)
  │   │
  │   │   Warnings:
  │   │     [W1] Constitucion R4: UI/API coherence - 3 API endpoints sin tests UI
  │   │     [W2] DORA metrics: Deploy frequency bajo (target: >1/day)
  │   │
  │   │   Duracion total: 3m 42s
  │   │
  │   ├─ Guardar log:
  │   │   .automation-logs/ci-local/2025-11-13-23-15-00.log
  │   │
  │   └─ Guardar artifacts:
  │       .ci-artifacts/
  │         ├─ ui-bundle/
  │         ├─ coverage-ui.html
  │         ├─ coverage-api.html
  │         └─ constitucion-report.json
  │
  └─ Exit 0 si todo PASS (warnings permitidos)
      Exit 1 si alguna stage FAILED

RESULTADO mostrado al desarrollador
```

**Duracion**: 2-5 minutos (full pipeline)
**Uso**: Antes de crear PR, o como check local completo

---

#### 2.2.4 FLUJO EXTENSION: DevContainer Lifecycle con Validacion

```
DESARROLLADOR abre DevContainer en VSCode

↓

infrastructure/devcontainer/devcontainer.json lifecycle

initializeCommand (HOST):
  bash infrastructure/devcontainer/scripts/init_host.sh
  - Validaciones pre-build
  - Check Docker running
  - Check disk space

onCreateCommand (CONTAINER - primera vez):
  bash infrastructure/devcontainer/scripts/on_create.sh
  - Setup Python CPython custom
  - Configurar Git
  - Crear directorios

updateContentCommand (CONTAINER - primera vez):
  bash infrastructure/devcontainer/scripts/update_content.sh
  - pip install -r requirements.txt
  - npm install (en ui/)

postCreateCommand (CONTAINER - primera vez):
  bash infrastructure/devcontainer/scripts/post_create.sh
  ├─ Database migrations
  ├─ Seed data (si dev)
  │
  ├─ NUEVO: Validacion Constitucion Entorno
  │   scripts/constitucion.sh --mode=devcontainer-init
  │   ├─ Verificar PostgreSQL + MariaDB conectables
  │   ├─ Verificar CPython version correcta (3.12.6)
  │   ├─ Verificar Git hooks instalados
  │   └─ Ejecutar health check basico

postStartCommand (CONTAINER - cada start):
  bash infrastructure/devcontainer/scripts/post_start.sh
  ├─ Quick verification
  ├─ Check services (PostgreSQL, MariaDB)
  │
  └─ NUEVO: Recordatorio
      echo "Hooks Git instalados. Run 'npm run ci:local' para CI completo."
      echo "Constitucion activa. Ver: docs/devops/automatizacion/constitucion/"

DEVCONTAINER READY
```

**Duracion**:
- Primera vez: 5-10 minutos (build + deps)
- Starts subsecuentes: 10-30 segundos

---

## 3. Componentes NUEVOS - Especificacion Detallada

### 3.1 Sistema de Constitucion

#### 3.1.1 Proposito

Codificar **principios arquitectonicos y de gobernanza** del proyecto IACT en formato declarativo (YAML), permitiendo:
- Validacion automatica de decisiones contra principios establecidos
- Evolucion gradual de reglas (warning → error)
- Auditoria de conformidad
- Documentacion viva de "como hacemos las cosas aqui"

#### 3.1.2 Estructura .constitucion.yaml

```yaml
---
# Sistema de Constitucion IACT
version: "1.0"
metadata:
  project: IACT---project
  last_updated: 2025-11-13
  maintained_by: "Tech Lead"

# Principios fundamentales (NO cambian frecuentemente)
principles:
  - id: P1_separation_concerns_ui_api
    title: "Separacion UI/API"
    description: |
      UI (React) y API (Django) son aplicaciones separadas que se comunican via REST API.
      UI NO debe acceder directamente a base de datos.
      API NO debe contener logica de presentacion.
    rationale: |
      - Permite escalar UI y API independientemente
      - Facilita testing (mock API en UI tests)
      - Cumple arquitectura 3-tier
    applies_to: [ui, api]
    established: 2024-01-15

  - id: P2_dual_database_routing
    title: "Database Routing PostgreSQL + MariaDB"
    description: |
      IACT usa 2 bases de datos:
      - PostgreSQL: Modelos principales (Users, Calls, Analytics)
      - MariaDB: Legacy data, reporting
      Database router debe mantener esta separacion.
    rationale: |
      - PostgreSQL: Performance para operaciones transaccionales
      - MariaDB: Compatibilidad con sistema legacy
      - Router validado: validate_database_router.sh
    applies_to: [api]
    established: 2023-06-20

  - id: P3_no_emojis_in_code_docs
    title: "Sin Emojis en Codigo y Documentacion"
    description: |
      Emojis NO permitidos en:
      - Codigo fuente (.py, .js, .ts, .jsx, .tsx)
      - Documentacion (.md, .txt)
      - Configuracion (.yaml, .json, .toml)
      Usar texto descriptivo: NOTA:, ADVERTENCIA:, IMPORTANTE:
    rationale: |
      - Compatibilidad encodings (algunos sistemas no soportan Unicode completo)
      - Accesibilidad (screen readers)
      - Profesionalismo
      - Grep/search mas facil
    applies_to: [ui, api, docs, infrastructure]
    established: 2024-03-10

  - id: P4_conventional_commits
    title: "Conventional Commits"
    description: |
      Formato commits: type(scope): description
      Tipos: feat, fix, docs, style, refactor, test, chore
      Scope opcional: (auth), (dashboard), (api), (ui)
    rationale: |
      - Changelog automatico
      - Semantic versioning
      - Clarity en historia Git
    applies_to: [all]
    established: 2024-01-01

  - id: P5_tdd_for_critical_features
    title: "TDD para Funcionalidades Criticas"
    description: |
      Features criticas (auth, payments, data integrity) deben desarrollarse con TDD:
      1. RED: Escribir test que falla
      2. GREEN: Implementar minimo para pasar test
      3. REFACTOR: Mejorar codigo manteniendo tests verdes
    rationale: |
      - Reduce bugs en produccion (90%+ detectados en dev)
      - Documenta comportamiento esperado
      - Facilita refactoring
    applies_to: [ui, api]
    established: 2024-02-15

# Reglas derivadas de principios (PUEDEN evolucionar)
rules:
  - id: R1_no_direct_push_main
    principle: P4_conventional_commits
    severity: error
    scope: pre-push
    condition: |
      branch_destino == "main" || branch_destino == "master"
    action: block
    message: |
      CONSTITUCION VIOLADA: Push directo a main/master prohibido.

      Principio: P4 - Conventional Commits y code review
      Razon: Main debe reflejar estado production-ready validado via PR.

      Accion requerida:
        1. Crea PR: gh pr create --base main --head $(git branch --show-current)
        2. Solicita review de 1+ desarrollador
        3. Merge tras aprobacion y CI passing

      Bypass NO recomendado. Para emergencias contactar Tech Lead.
    metrics:
      violations_last_30_days: 0
      target: 0

  - id: R2_no_emojis_anywhere
    principle: P3_no_emojis_in_code_docs
    severity: error
    scope: pre-commit
    condition: |
      grep -P "[\x{1F600}-\x{1F64F}]|..." archivos_staged
    action: block
    message: |
      CONSTITUCION VIOLADA: Emojis detectados.

      Archivo(s): {archivos_con_emojis}
      Linea(s): {lineas}

      Principio: P3 - No Emojis
      Razon: Compatibilidad, accesibilidad, profesionalismo

      Reemplazos sugeridos:
        ✅ → "COMPLETADO:" o "OK:"
        ⚠️  → "ADVERTENCIA:"
        ❌ → "ERROR:" o "FALLO:"
        📘 → "NOTA:" o "REFERENCIA:"
        🚀 → "DEPLOY:" o descripcion textual

      Accion: Ejecuta ./scripts/clean_emojis.sh para auto-fix
    automation:
      script: scripts/check_no_emojis.py
      auto_fix: scripts/clean_emojis.sh
    metrics:
      violations_last_30_days: 2
      target: 0

  - id: R3_ui_api_coherence
    principle: P1_separation_concerns_ui_api
    severity: warning  # WARNING, no ERROR (permite push)
    scope: pre-push
    condition: |
      archivos_modificados incluye "api/**/*.py" (views, serializers, urls)
      Y NO incluye "ui/src/**/*.test.js" correspondiente
    action: warn
    message: |
      CONSTITUCION ADVERTENCIA: Cambios API sin tests UI.

      Principio: P1 - Separacion UI/API
      Detalle: Modificaste API endpoints pero no agregaste/modificaste tests UI.

      Archivos API modificados: {archivos_api}
      Tests UI esperados: {tests_ui_sugeridos}

      Recomendacion:
        1. Agrega tests en ui/src/__tests__/api/ que verifiquen:
           - Llamadas a nuevos endpoints
           - Manejo de respuestas
           - Manejo de errores
        2. Ejecuta: cd ui/ && npm run test

      PUSH PERMITIDO con esta advertencia, pero considera agregar tests.
    automation:
      script: scripts/check_ui_api_coherence.sh  # A CREAR
    metrics:
      violations_last_30_days: 5
      target: 2

  - id: R4_database_router_validated
    principle: P2_dual_database_routing
    severity: error
    scope: pre-push
    condition: |
      archivos_modificados incluye "api/**/models.py" o "api/**/db_router.py"
    action: block_if_validation_fails
    message: |
      CONSTITUCION: Cambios en modelos o database router.

      Principio: P2 - Dual Database Routing
      Validacion: Ejecutando validate_database_router.sh...

      [output del script]

      Si falla: PUSH BLOQUEADO hasta que router sea valido.
      Documentacion: docs/backend/database/DATABASE_ROUTING.md
    automation:
      script: scripts/validate_database_router.sh  # YA EXISTE
    metrics:
      violations_last_30_days: 0
      target: 0

  - id: R5_tests_must_pass
    principle: P5_tdd_for_critical_features
    severity: error
    scope: pre-push
    condition: |
      run_all_tests.sh exit_code != 0
    action: block
    message: |
      CONSTITUCION VIOLADA: Tests fallando.

      Principio: P5 - TDD para features criticas
      Razon: Codigo con tests rotos no debe llegar a remote.

      Tests fallando: {count}
      Detalle: Ver output arriba

      Accion:
        1. Fix tests: cd api && pytest -v (o cd ui && npm test)
        2. Verifica localmente: ./scripts/run_all_tests.sh
        3. Reintenta push

      Para ver detalles: .automation-logs/pre-push/latest.log
    automation:
      script: scripts/run_all_tests.sh  # YA EXISTE
    metrics:
      violations_last_30_days: 1
      target: 0

  - id: R6_devcontainer_compatibility
    principle: P1_separation_concerns_ui_api  # Infrastructure concern
    severity: warning
    scope: devcontainer-init
    condition: |
      CPython version != 3.12.6
      O PostgreSQL no conectable
      O MariaDB no conectable
    action: warn
    message: |
      CONSTITUCION ADVERTENCIA: Entorno DevContainer no optimo.

      Problemas detectados: {issues}

      Recomendaciones:
        - CPython: Debe ser 3.12.6 (ver infrastructure/cpython/)
        - PostgreSQL: Port 5432 debe estar accesible
        - MariaDB: Port 3306 debe estar accesible

      DevContainer puede funcionar con warnings, pero rendimiento/compatibilidad no garantizados.
    automation:
      script: scripts/validate_devcontainer_env.sh  # A CREAR
    metrics:
      violations_last_30_days: 0
      target: 0

# Sistema de evolucion de reglas
evolution:
  process: |
    1. Identificar patron recurrente (ej: PRs con UI/API desincronizado)
    2. Proponer nueva regla en issue/discussion
    3. Aprobar en reunión equipo (mayoria simple)
    4. Agregar regla con severity: warning
    5. Observar adopcion 2 semanas (target: 80%+ compliance)
    6. Si compliance OK: cambiar a severity: error
    7. Si compliance bajo: refinar regla o descartarla
    8. Regla se vuelve parte permanente de constitucion

  changelog:
    - date: 2025-11-13
      change: "Constitucion inicial con 6 reglas"
      rules_added: [R1, R2, R3, R4, R5, R6]
      author: "DevOps Team / SDLC Agent"

    # Ejemplo futuro:
    # - date: 2025-12-01
    #   change: "Agregar regla R7: Branch debe tener issue asociado"
    #   rules_added: [R7]
    #   severity: warning
    #   author: "Tech Lead"

# Metricas y reportes
metrics:
  collection:
    frequency: daily
    retention: 90_days

  kpis:
    - name: constitucion_compliance_rate
      description: "% commits/pushes que cumplen todas las reglas ERROR"
      target: 95
      current: null  # Calculado diariamente

    - name: warning_rate
      description: "% commits/pushes con warnings (severity: warning)"
      target: 20  # Acceptable tener algunos warnings
      current: null

    - name: avg_violations_per_developer
      description: "Promedio violaciones ERROR por desarrollador/mes"
      target: 1
      current: null

  reports:
    daily:
      - constitucion_violations_summary.json
    weekly:
      - constitucion_compliance_trends.html
    monthly:
      - constitucion_evolution_report.pdf
```

#### 3.1.3 Script Validador: scripts/constitucion.sh

**Ubicacion**: `scripts/constitucion.sh` (NUEVO)
**Proposito**: Validar conformidad con constitucion en diferentes contextos
**Lenguaje**: Bash + Python (para logica compleja)

**Firma**:
```bash
#!/bin/bash
# scripts/constitucion.sh
# Validador del Sistema de Constitucion IACT

Usage:
  ./constitucion.sh --mode=pre-commit
  ./constitucion.sh --mode=pre-push
  ./constitucion.sh --mode=devcontainer-init
  ./constitucion.sh --validate-all
  ./constitucion.sh --report

Modes:
  pre-commit:         Valida reglas scope=pre-commit
  pre-push:           Valida reglas scope=pre-push
  devcontainer-init:  Valida reglas scope=devcontainer-init
  validate-all:       Valida TODAS las reglas (CI local)
  report:             Genera reporte conformidad
```

**Logica** (pseudocodigo):
```python
def constitucion_validate(mode):
    config = load_yaml(".constitucion.yaml")
    rules = [r for r in config["rules"] if r["scope"] == mode or mode == "validate-all"]

    violations_error = []
    violations_warning = []

    for rule in rules:
        result = evaluate_rule(rule)
        if not result.passed:
            if rule["severity"] == "error":
                violations_error.append((rule, result))
            else:
                violations_warning.append((rule, result))

    # Log violations
    log_to_file(f".automation-logs/constitucion/{mode}-{timestamp}.log", violations_error + violations_warning)

    # Display violations
    if violations_error:
        print_error_violations(violations_error)
        exit(1)  # Block action
    elif violations_warning:
        print_warning_violations(violations_warning)
        exit(0)  # Allow action with warnings
    else:
        print("CONSTITUCION: All rules passed")
        exit(0)

def evaluate_rule(rule):
    # Ejecutar condition (puede ser script externo)
    if rule.get("automation", {}).get("script"):
        exit_code = run_script(rule["automation"]["script"])
        return RuleResult(passed=(exit_code == 0))
    else:
        # Evaluar condition inline (bash o Python)
        return evaluate_condition(rule["condition"])
```

---

### 3.2 CI/CD Local Unificado

#### 3.2.1 Proposito

Orquestador centralizado que ejecuta **todas las validaciones** UI+API en pipeline local, replicando lo que GitHub Actions haria pero ejecutable offline.

**Beneficios**:
- Detectar errores ANTES de push
- Validacion completa en <5 minutos
- No consume GitHub Actions minutes
- Funciona sin internet (DevContainer offline)

#### 3.2.2 Estructura Configuracion: .ci-local.yaml

```yaml
---
# CI/CD Local Pipeline Configuration
version: "1.0"

pipeline:
  name: "IACT Local CI"
  description: "Pipeline unificado UI (React) + API (Django)"
  fail_fast: true        # Detener en primer error
  parallel: true         # Stages independientes en paralelo
  timeout: 600           # 10 min timeout total

# Stages del pipeline
stages:
  # STAGE 1: LINT
  - name: lint
    description: "Linting UI (ESLint) + API (Ruff)"
    parallel: true
    jobs:
      - name: lint_ui
        working_dir: ui/
        command: "npm run lint"
        continue_on_error: false
        timeout: 60

      - name: lint_api
        working_dir: api/callcentersite/
        command: "ruff check ."
        continue_on_error: false
        timeout: 60

      - name: lint_markdown
        working_dir: docs/
        command: "markdownlint **/*.md --config .markdownlint.json"
        continue_on_error: true  # Warnings no bloquean
        timeout: 30

  # STAGE 2: TEST
  - name: test
    description: "Tests UI (Jest) + API (Pytest)"
    parallel: true
    jobs:
      - name: test_ui
        working_dir: ui/
        command: "npm run test:coverage"
        coverage_threshold: 80
        coverage_file: coverage/coverage-summary.json
        continue_on_error: false
        timeout: 120

      - name: test_api
        working_dir: api/callcentersite/
        command: "pytest --cov --cov-report=json --cov-report=term"
        coverage_threshold: 80
        coverage_file: coverage.json
        continue_on_error: false
        timeout: 180

  # STAGE 3: BUILD
  - name: build
    description: "Build UI (Webpack) + API (collectstatic)"
    parallel: true
    jobs:
      - name: build_ui
        working_dir: ui/
        command: "npm run build"
        artifacts:
          - dist/
        continue_on_error: false
        timeout: 120

      - name: build_api
        working_dir: api/callcentersite/
        command: |
          python manage.py collectstatic --noinput &&
          python manage.py check --deploy
        artifacts:
          - staticfiles/
        continue_on_error: false
        timeout: 60

  # STAGE 4: VALIDATE
  - name: validate
    description: "Validaciones especificas IACT"
    parallel: false  # Secuencial
    jobs:
      - name: validate_security
        command: "./scripts/validate_security_config.sh"
        continue_on_error: false
        timeout: 60

      - name: validate_database_router
        command: "./scripts/validate_database_router.sh"
        continue_on_error: false
        timeout: 30

      - name: validate_constitucion
        command: "./scripts/constitucion.sh --validate-all"
        continue_on_error: true  # Warnings permitidos
        timeout: 60

      - name: validate_docs_structure
        command: "./scripts/validar_estructura_docs.sh"
        continue_on_error: true
        timeout: 30

      - name: validate_critical_restrictions
        command: "./scripts/validate_critical_restrictions.sh"
        continue_on_error: false
        timeout: 30

# Configuracion de reportes
reporting:
  format: text  # text | json | html
  verbosity: normal  # quiet | normal | verbose
  save_artifacts: true
  artifacts_dir: .ci-artifacts
  retention_days: 7

# Configuracion de logs
logging:
  enabled: true
  directory: .automation-logs/ci-local
  retention_days: 30
  format: text

# Notificaciones (opcional)
notifications:
  on_success:
    message: "CI Local: All stages passed"
    sound: false

  on_failure:
    message: "CI Local: Failed at stage {stage_name}"
    sound: true

# Hooks (opcional - ejecutar antes/despues pipeline)
hooks:
  pre_pipeline:
    - command: "git fetch origin main"  # Actualizar ref main
      continue_on_error: true

  post_pipeline:
    - command: "./scripts/generate_dora_report.sh"  # Actualizar metricas
      continue_on_error: true
```

#### 3.2.3 Script Orquestador: scripts/ci-local.sh

**Ubicacion**: `scripts/ci-local.sh` (NUEVO)
**Lenguaje**: Bash
**Responsabilidad**: Ejecutar pipeline completo segun .ci-local.yaml

**Estructura** (simplificado):
```bash
#!/bin/bash
# scripts/ci-local.sh
# CI/CD Local Pipeline Orchestrator

set -euo pipefail

readonly CONFIG_FILE=".ci-local.yaml"
readonly LOG_DIR=".automation-logs/ci-local"
readonly ARTIFACTS_DIR=".ci-artifacts"
readonly TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
readonly LOG_FILE="$LOG_DIR/$TIMESTAMP.log"

# Cargar configuracion
config=$(yq eval '.' "$CONFIG_FILE")

# Ejecutar pipeline
for stage in $(echo "$config" | yq eval '.stages[].name' -); do
    echo "========================================" | tee -a "$LOG_FILE"
    echo "STAGE: $stage" | tee -a "$LOG_FILE"
    echo "========================================" | tee -a "$LOG_FILE"

    # Ejecutar jobs del stage
    if is_parallel_stage "$stage"; then
        run_jobs_parallel "$stage"
    else
        run_jobs_sequential "$stage"
    fi

    # Check fail_fast
    if $FAIL_FAST && stage_failed "$stage"; then
        echo "FAIL_FAST enabled, aborting pipeline" | tee -a "$LOG_FILE"
        exit 1
    fi
done

# Generar reporte
generate_report
exit $PIPELINE_STATUS
```

---

### 3.3 Integracion DevContainer

**Modificacion**: `infrastructure/devcontainer/scripts/post_create.sh` (EXTENDER existente)

**Agregar al final**:
```bash
# ======================================================================
# VALIDACION CONSTITUCION DEVCONTAINER
# ======================================================================

echo ""
echo "Validando entorno DevContainer contra constitucion..."

if [ -f "/workspaces/${WORKSPACE_NAME}/scripts/constitucion.sh" ]; then
    /workspaces/${WORKSPACE_NAME}/scripts/constitucion.sh --mode=devcontainer-init || {
        echo "ADVERTENCIA: Constitucion reporto problemas en entorno."
        echo "DevContainer funcional pero puede tener degradacion."
        echo "Ver: .automation-logs/constitucion/devcontainer-init-*.log"
    }
else
    echo "ADVERTENCIA: scripts/constitucion.sh no encontrado, skip validacion"
fi

# Instalar Git hooks si no estan
if [ ! -f "/workspaces/${WORKSPACE_NAME}/.git/hooks/pre-commit" ]; then
    echo "Instalando Git hooks..."
    cd "/workspaces/${WORKSPACE_NAME}"
    ./scripts/install_hooks.sh
fi

echo ""
echo "========================================"
echo "DevContainer Setup: COMPLETO"
echo "========================================"
echo ""
echo "Proximos pasos:"
echo "  1. API: cd api/callcentersite && python manage.py runserver"
echo "  2. UI: cd ui && npm start"
echo "  3. CI Local: npm run ci:local"
echo "  4. Docs: docs/devops/README.md"
echo ""
```

---

### 3.4 Documentacion Sistema Completo

**Ubicacion**: `docs/devops/automatizacion/`

**Archivos a Crear** (en FASE 5 - Deployment):

1. **README.md**: Overview sistema automatizacion
2. **INSTALLATION.md**: Como instalar hooks, pre-commit, CI local
3. **USAGE.md**: Como usar constitucion, CI local, hooks
4. **CONSTITUCION_GUIDE.md**: Guia completa sistema constitucion
5. **TROUBLESHOOTING.md**: Problemas comunes
6. **CONTRIBUTING.md**: Como agregar nuevas validaciones/reglas
7. **ARCHITECTURE.md**: Link a este HLD

---

## 4. Decisiones de Diseno Arquitectonico (ADRs)

### ADR-AUTO-001: Extender Sistema Existente vs Reemplazar

**Contexto**: IACT ya tiene sistema hooks y validaciones robusto.

**Opciones**:
- A: Reemplazar todo con nuevo sistema
- B: Extender sistema existente
- C: Hibrido (mantener algunos, reemplazar otros)

**Decision**: OPCION B - Extender existente

**Razon**:
- Sistema actual funciona bien (pre-commit, hooks, scripts)
- Reemplazar romperia workflows desarrolladores
- Extension permite adopcion gradual
- Mantiene inversion en configuracion actual

**Consecuencias**:
- Pros: Continuidad, adopcion incremental, bajo riesgo
- Contras: Complejidad mantener compatibilidad

---

### ADR-AUTO-002: Sistema Constitucion en YAML vs Base de Datos

**Contexto**: Necesitamos almacenar reglas gobernanza.

**Opciones**:
- A: YAML versionado en Git
- B: Base de datos (PostgreSQL)
- C: API externa (SaaS)

**Decision**: OPCION A - YAML en Git

**Razon**:
- Versionable (track cambios constitucion en Git)
- Code review (PRs para cambiar reglas)
- No requiere servicio adicional
- Facil leer y editar

**Consecuencias**:
- Pros: Simple, versionable, portable
- Contras: No permite cambios dinamicos sin commit

---

### ADR-AUTO-003: CI Local vs Solo GitHub Actions

**Contexto**: Validaciones antes de push.

**Opciones**:
- A: Solo hooks locales ligeros
- B: CI local completo + GitHub Actions
- C: Solo GitHub Actions (validar en remoto)

**Decision**: OPCION B - CI local + GitHub Actions

**Razon**:
- CI local detecta errores antes de push (ahorra tiempo)
- GitHub Actions como validacion final (no se puede bypassear)
- DevContainer puede estar offline (CI local funciona)
- Desarrolladores prefieren feedback rapido local

**Consecuencias**:
- Pros: Feedback rapido, offline-capable, doble validacion
- Contras: Duplicacion configuracion (mitigado con .ci-local.yaml reutilizable)

---

### ADR-AUTO-004: Pre-commit Framework (Python) vs Hooks Shell Puros

**Contexto**: API ya usa pre-commit framework, UI no.

**Opciones**:
- A: Migrar UI a pre-commit framework tambien
- B: Mantener hooks shell para UI
- C: Usar ambos

**Decision**: OPCION C - Mantener hibrido (API usa pre-commit, UI usa hooks shell)

**Razon**:
- Pre-commit excelente para Python (ruff, mypy, etc.)
- UI (JS/React) tiene menos beneficio (ESLint CLI suficiente)
- No forzar cambio workflow UI innecesariamente
- CI local unifica ambos de todas formas

**Consecuencias**:
- Pros: Cada stack usa mejor herramienta, no disruptivo
- Contras: Desarrolladores fullstack deben conocer ambos

---

## 5. Plan de Implementacion (High-Level)

### FASE 1: Fundaciones (1 semana) - COMPLETA
- Planning (ISSUE)
- Feasibility (GO decision)
- Analisis estructura (devops/)
- HLD (este documento)

### FASE 2: Implementacion Core (2 semanas)
1. **Sistema Constitucion** (1 semana):
   - Crear .constitucion.yaml inicial (6 reglas)
   - Implementar scripts/constitucion.sh
   - Integrar en pre-push hook existente
   - Tests

2. **CI Local Unificado** (1 semana):
   - Crear .ci-local.yaml
   - Implementar scripts/ci-local.sh
   - Integrar scripts existentes
   - Tests

### FASE 3: Integracion y Docs (1 semana)
- Integracion DevContainer lifecycle
- Documentacion completa (7 docs)
- Guia troubleshooting
- Video tutorial (opcional)

### FASE 4: Rollout Gradual (2 semanas)
- Beta testing con 2-3 desarrolladores
- Fix issues reportados
- Rollout equipo completo
- Monitoreo metricas conformidad

**TOTAL ESTIMADO**: 6 semanas (incluyendo testing y ajustes)

---

## 6. Metricas de Exito

**M1: Conformidad Constitucion**
- Target: 95% commits cumplen reglas ERROR
- Medicion: .automation-logs/constitucion/daily-report.json

**M2: Reduccion Errores en CI Remoto**
- Target: -40% fallos GitHub Actions (vs baseline)
- Medicion: GitHub Actions logs

**M3: Time-to-Feedback**
- Target: <5 min para CI local completo
- Medicion: Timestamps logs CI local

**M4: Adopcion Desarrolladores**
- Target: 100% equipo usa hooks + CI local
- Medicion: Survey + git logs

**M5: Satisfaccion Equipo**
- Target: >8/10 satisfaccion con sistema automatizacion
- Medicion: Survey trimestral

---

## 7. Riesgos y Mitigaciones

**R1: Resistencia Equipo a Sistema Constitucion**
- Riesgo: Desarrolladores ven constitucion como burocracia
- Probabilidad: Media | Impacto: Alto
- Mitigacion:
  - Empezar con pocas reglas (6), solo criticas
  - Reglas inicialmente warnings, evolucionar a errors
  - Involucrar equipo en definicion reglas
  - Mostrar metricas (ej: bugs encontrados por constitucion)

**R2: CI Local Lento (>10 min)**
- Riesgo: Pipeline local tarda mucho, desarrolladores lo saltan
- Probabilidad: Media | Impacto: Medio
- Mitigacion:
  - Paralelizacion agresiva (lint UI + API simultaneo)
  - Cache de dependencias (npm, pip)
  - Opcion --quick que skip stages no criticos
  - Target <5 min para pipeline completo

**R3: Mantenimiento Constitucion Abandonado**
- Riesgo: .constitucion.yaml no evoluciona, reglas obsoletas
- Probabilidad: Media | Impacto: Medio
- Mitigacion:
  - Asignar owner (Tech Lead)
  - Review trimestral reglas
  - Metricas auto-reportadas (% compliance)
  - Evolucion gradual documentada

**R4: Compatibilidad DevContainer Rota**
- Riesgo: Cambios hooks rompen workflow DevContainer
- Probabilidad: Baja | Impacto: Alto
- Mitigacion:
  - Tests automaticos en DevContainer (GitHub Actions)
  - Validacion post_create reporta problemas temprano
  - Rollback facil (Git revert)

---

## 8. Proximos Pasos

### Inmediato:
1. ✓ HLD completo (ESTE DOCUMENTO)
2. Crear LLD (Low-Level Design) con:
   - Especificacion scripts linea por linea
   - Algoritmos validacion constitucion
   - Estructura exacta .constitucion.yaml y .ci-local.yaml
   - Integracion hooks existentes detallada

### Corto Plazo:
3. FASE 4 - Testing Plan (TDD RED)
4. FASE 5 - Deployment Plan (implementacion)
5. FASE 6 - Maintenance Plan

---

**Status**: HLD v2.0 COMPLETO - Esperando revision y aprobacion
**Autor**: SDLC Agent / DevOps Team
**Fecha**: 2025-11-13
**Proxima Revision**: Post-aprobacion Tech Lead

---

**CAMBIOS vs v1.0**:
- Documentada arquitectura REAL de IACT (UI React, API Django, 2 DBs)
- Analisis sistema automatizacion EXISTENTE (hooks, pre-commit, 40+ scripts)
- Diseno EXTIENDE sistema actual (no reemplaza)
- Componentes nuevos claramente diferenciados
- Integracion con DevContainer lifecycle
- Validaciones especificas UI+API
- Sistema constitucion adaptado a IACT

**Metodologia Aplicada**:
- Auto-CoT: Descomposicion sistematica en componentes
- Self-Consistency: Validacion multi-enfoque (Feasibility, Analisis)
- SDLC 6 Fases: FASE 3 HLD en progreso
- TDD: Testing antes de implementacion (siguiente fase)
