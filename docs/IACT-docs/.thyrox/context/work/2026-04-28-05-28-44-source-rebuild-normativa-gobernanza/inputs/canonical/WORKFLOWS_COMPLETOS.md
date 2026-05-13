---
id: DOC-DEV-WORKFLOWS
tipo: documentacion
categoria: desarrollo
version: 1.0.0
fecha_creacion: 2025-11-05
propietario: equipo-desarrollo
date: 2025-11-13
---

# Workflows Completos del Proyecto IACT

Análisis exhaustivo de todos los workflows, pipelines, scripts y procesos automatizados disponibles en el proyecto.

## Tabla de Contenidos

1. [GitHub Actions Workflows](#github-actions-workflows)
2. [Scripts de Automatización](#scripts-de-automatizacion)
3. [Makefile - Comandos de Desarrollo](#makefile-comandos-de-desarrollo)
4. [Procesos de Gobernanza](#procesos-de-gobernanza)
5. [Workflows de Infraestructura](#workflows-de-infraestructura)
6. [Workflows de Desarrollo Local](#workflows-de-desarrollo-local)
7. [Matriz de Workflows](#matriz-de-workflows)

---

## GitHub Actions Workflows

El proyecto cuenta con 5 workflows principales de CI/CD automatizados.

### 1. Python CI/CD (`.github/workflows/python-ci.yml`)

**Trigger**:
- Push a: `main`, `develop`, `feature/**`, `claude/**`
- Pull requests a: `main`, `develop`
- Paths: `api/**`, `.github/workflows/python-ci.yml`
- Manual: `workflow_dispatch`

**Jobs**:

#### Job 1: Code Quality (code-quality)
**Duración estimada**: ~2 minutos

Ejecuta:
- Ruff linter (lint + format check)
- MyPy type checking (continue-on-error)
- Bandit security checks

Genera:
- `bandit-report.json` (artifact, 30 días)

#### Job 2: Tests (tests)
**Duración estimada**: ~5-8 minutos

Ejecuta:
- Tests con pytest (paralelo con `-n auto`)
- Coverage con pytest-cov
- PostgreSQL service container
- Upload a Codecov

Genera:
- `coverage.xml` y `htmlcov/` (artifact, 30 días)
- Comentario de coverage en PR

**Umbrales**:
- Coverage mínimo verde: 80%
- Coverage mínimo naranja: 60%

#### Job 3: Performance (performance)
**Duración estimada**: ~3 minutos
**Solo**: Pull Requests

Ejecuta:
- pytest-benchmark
- memory-profiler

Genera:
- `benchmark.json` (artifact, 30 días)

#### Job 4: Dependency Check (dependency-check)
**Duración estimada**: ~2 minutos

Ejecuta:
- Safety check (vulnerabilidades)
- pip-audit (CVE scan)

Genera:
- `safety-report.json`
- `pip-audit-report.json` (artifacts, 30 días)

#### Job 5: Build Status (build-status)
**Duración estimada**: <1 minuto

Valida que code-quality y tests pasaron exitosamente.

**Total workflow**: ~10-15 minutos

---

### 2. Lint and Code Quality (`.github/workflows/lint.yml`)

**Trigger**:
- Push a: `main`, `develop`, `feature/**`, `claude/**`
- Pull requests a: `main`, `develop`

**Jobs**:

#### Job 1: Markdown Linting (markdown-lint)
**Duración**: ~1 minuto

Ejecuta:
- markdownlint-cli en `docs/**/*.md`
- Configuración custom (MD013, MD033, MD041 disabled)

#### Job 2: YAML Linting (yaml-lint)
**Duración**: <1 minuto

Ejecuta:
- yamllint en todos los `.yml` y `.yaml`
- Line length: max 120

#### Job 3: Docs Structure Check (docs-structure-check)
**Duración**: ~2 minutos

Ejecuta:
- Validación de enlaces internos rotos
- Validación de frontmatter YAML

#### Job 4: Requirements Frontmatter (requirements-frontmatter-check)
**Duración**: ~2 minutos

Ejecuta:
- Validación ISO 29148 compliance
- Campos requeridos por tipo de requisito:
  - Necesidades: id, tipo, titulo, prioridad, estado
  - Negocio: + dominio
  - Funcionales: + owner, trazabilidad_upward
  - No funcionales: + owner

#### Job 5: Summary (summary)
**Duración**: <1 minuto

Valida que todos los lint checks pasaron.

**Total workflow**: ~5-7 minutos

---

### 3. Deploy Documentation (`.github/workflows/docs.yml`)

**Trigger**:
- Push a: `main`, `develop`
- Paths: `docs/**`, `docs/mkdocs.yml`
- Pull requests (paths)
- Manual: `workflow_dispatch`

**Permissions**: pages, contents read

**Jobs**:

#### Job 1: Build (build)
**Duración**: ~3 minutos

Ejecuta:
- MkDocs build con plugins:
  - mkdocs-material
  - mkdocs-git-revision-date-localized-plugin
  - mkdocs-minify-plugin
  - pymdown-extensions
- Validación con `--strict`

Genera:
- `docs/site/` (upload a GitHub Pages)

#### Job 2: Deploy (deploy)
**Duración**: ~1 minuto
**Solo**: Push a `main`

Ejecuta:
- Deploy a GitHub Pages

**URL**: https://2-coatl.github.io/IACT---project/

#### Job 3: Check Links (check-links)
**Duración**: ~2 minutos
**Solo**: Pull Requests

Ejecuta:
- linkchecker en `docs/site/`
- Comentario en PR con resultados

**Total workflow**: ~4-6 minutos

---

### 4. Generate Requirements Index (`.github/workflows/requirements-index.yml`)

**Trigger**:
- Push a: `main`, `develop`
- Paths: `implementaci../gobernanza/marco_integrado/**/*.md`
- Pull requests (paths)
- Manual: `workflow_dispatch`

**Permissions**: contents write

**Jobs**:

#### Job 1: Generate Indices (generate-indices)
**Duración**: ~3 minutos

Ejecuta:
- Script Node.js para generar índices ISO 29148:
  - BRS (Business Requirements Specification - ISO 9.3)
  - StRS (Stakeholder Requirements - ISO 9.4)
  - SyRS (System Requirements - ISO 9.5)
  - SRS (Software Requirements - ISO 9.6)
  - RTM (Traceability Matrix)

Genera:
- `docs/requisitos/brs_business_requirements.md`
- `docs/requisitos/README.md`
- Commit automático (si hay cambios)

#### Job 2: Validate Traceability (validate-traceability)
**Duración**: ~2 minutos

Ejecuta:
- Validación de referencias upward/downward
- Detección de IDs huérfanos
- Validación de consistencia

**Total workflow**: ~5 minutos

---

### 5. Release Management (`.github/workflows/release.yml`)

**Trigger**:
- Push de tags: `v*.*.*`
- Manual: `workflow_dispatch` (con input de versión)

**Permissions**: contents write, pull-requests write, issues write

**Jobs**:

#### Job 1: Validate Version (validate-version)
**Duración**: <1 minuto

Ejecuta:
- Validación de formato `vX.Y.Z`
- Check si release ya existe

#### Job 2: Generate Changelog (generate-changelog)
**Duración**: ~2 minutos

Ejecuta:
- Script para generar release notes
- Análisis de commits desde último tag

Genera:
- `CHANGELOG-vX.Y.Z.md`

#### Job 3: Create Release Packages (create-release-packages)
**Duración**: ~3 minutos

Ejecuta:
- Script para crear paquetes de release
- Compresión de artefactos

**Total workflow**: ~6 minutos

**Scripts asociados**:
- `check-release-exists.sh`
- `generate-release-notes.sh`
- `create-release-packages.sh`
- `create-github-release.sh`
- `update-version.sh`
- `get-next-version.sh`

---

## Scripts de Automatización

El proyecto cuenta con múltiples categorías de scripts.

### A. Scripts de Validación (3 scripts)

#### 1. `validate_critical_restrictions.sh`
**Ubicación**: `scripts/validate_critical_restrictions.sh`

**Propósito**: Validar restricciones críticas del proyecto

**Valida**:
1. NO uso de email (send_mail, EmailMessage, smtp)
2. NO uso de Sentry (sentry_sdk imports, requirements)
3. NO uso de Redis para sesiones
4. Configuración de seguridad correcta

**Exit codes**:
- 0: Todas las validaciones pasaron
- 1+: Número de validaciones fallidas

**Uso**:
```bash
./scripts/validate_critical_restrictions.sh
```

#### 2. `validate_security_config.sh`
**Ubicación**: `scripts/validate_security_config.sh`

**Propósito**: Validar configuración de seguridad Django

**Valida**:
- DEBUG = False en producción
- SECRET_KEY desde variables de entorno
- SESSION_ENGINE configurado correctamente
- JWT settings válidos
- ALLOWED_HOSTS configurado

**Uso**:
```bash
./scripts/validate_security_config.sh
```

#### 3. `validate_database_router.sh`
**Ubicación**: `scripts/validate_database_router.sh`

**Propósito**: Validar router de base de datos

**Valida**:
- Lectura en IVR (readonly)
- Escritura bloqueada en IVR
- Migraciones bloqueadas en IVR
- Tests del router

**Uso**:
```bash
./scripts/validate_database_router.sh
```

---

### B. Scripts de Requisitos (3 scripts)

#### 1. `generar_indices.py`
**Ubicación**: `scripts/requisitos/generar_indices.py`

**Propósito**: Generar índices de requisitos ISO 29148

**Funcionalidad**:
- Escanea `implementaci../gobernanza/marco_integrado/**/*.md`
- Extrae frontmatter YAML
- Genera BRS, StRS, SyRS, SRS
- Crea matriz de trazabilidad

**Uso**:
```bash
python3 scripts/requisitos/generar_indices.py
```

#### 2. `validar_frontmatter.py`
**Ubicación**: `scripts/requisitos/validar_frontmatter.py`

**Propósito**: Validar frontmatter de requisitos

**Valida**:
- Campos requeridos según tipo
- Formato YAML válido
- IDs únicos
- Trazabilidad consistente

**Uso**:
```bash
python3 scripts/requisitos/validar_frontmatter.py
```

#### 3. `listar_requisitos.sh` / `contar_requisitos.sh`
**Ubicación**: `scripts/requisitos/`

**Propósito**: Listado y conteo rápido de requisitos

**Uso**:
```bash
./scripts/requisitos/listar_requisitos.sh
./scripts/requisitos/contar_requisitos.sh
```

---

### C. Scripts de Generación de Tests con LLM (8 scripts + 7 agentes)

#### Pipeline Principal

##### 1. `test_generation_orchestrator.py`
**Ubicación**: `scripts/ai/test_generation_orchestrator.py`

**Propósito**: Orquestador principal del pipeline de 7 agentes

**Agentes**:
1. CoverageAnalyzer
2. TestPlanner
3. LLMGenerator
4. SyntaxValidator
5. TestRunner
6. CoverageVerifier
7. PRCreator

**Uso**:
```bash
python3 scripts/ai/test_generation_orchestrator.py \
  --project-path ../../api/callcentersite \
  --config config/test_generation.json
```

**Opciones**:
- `--dry-run`: Simulación sin modificar código
- `--config`: Archivo de configuración custom

**Output**:
- `output/test_generation/01_CoverageAnalyzer.json`
- `output/test_generation/02_TestPlanner.json`
- ...hasta 07_PRCreator.json

##### 2. `run_test_generation.sh`
**Ubicación**: `scripts/ai/run_test_generation.sh`

**Propósito**: Wrapper bash para ejecutar orquestador

**Uso**:
```bash
./scripts/ai/run_test_generation.sh
```

#### Scripts de Ejemplo

##### 3. `quickstart.sh`
**Ubicación**: `scripts/ai/examples/quickstart.sh`

**Propósito**: Inicio rápido interactivo

**Modos**:
- `check`: Validar entorno
- `demo`: Demo en dry-run
- `basic`: Ejecución básica
- `aggressive`: Configuración agresiva (90% cobertura)
- `conservative`: Configuración conservadora (80% cobertura)

**Uso**:
```bash
cd scripts/ai/examples
./quickstart.sh check
./quickstart.sh demo
./quickstart.sh basic
```

##### 4. `validate_environment.sh`
**Ubicación**: `scripts/ai/examples/validate_environment.sh`

**Propósito**: Validación exhaustiva del entorno

**Valida**:
1. Python 3.10+ y dependencias
2. API keys (ANTHROPIC_API_KEY)
3. Herramientas externas (git, gh)
4. Estructura del proyecto
5. Permisos y acceso
6. Conectividad con API Anthropic

**Output**:
```
[OK] Python 3.12.0
[OK] pytest 8.0.0
[OK] ANTHROPIC_API_KEY configurada
[OK] Conexión exitosa con API
TODO OK - Entorno completamente configurado
```

##### 5. `example_single_file.sh`
**Ubicación**: `scripts/ai/examples/example_single_file.sh`

**Propósito**: Generar tests para un archivo específico

**Uso**:
```bash
./example_single_file.sh ../../api/app/models.py
```

##### 6. `example_specific_module.py`
**Ubicación**: `scripts/ai/examples/example_specific_module.py`

**Propósito**: Uso programático con configuración avanzada

**Características**:
- Configuración completamente custom
- Filtros por patrones (include/exclude)
- System prompts personalizados
- Few-shot examples

**Uso**:
```bash
python3 scripts/ai/examples/example_specific_module.py
```

##### 7. `example_ci_integration.sh`
**Ubicación**: `scripts/ai/examples/example_ci_integration.sh`

**Propósito**: Integración con CI/CD

**Comportamiento inteligente**:
1. Analiza cobertura actual
2. Si < objetivo → genera tests
3. Si >= objetivo → sale (conserva recursos)
4. Crea PR automático

**Uso en CI**:
```bash
export ANTHROPIC_API_KEY="$SECRET_KEY"
./scripts/ai/examples/example_ci_integration.sh
```

---

### D. Scripts de Infraestructura

#### DevContainer Scripts (6 scripts)

**Ubicación**: `infrastructure/devcontainer/scripts/`

##### 1. `on_create.sh`
**Propósito**: Setup inicial del devcontainer

**Ejecuta**:
- Instalación de dependencias del sistema
- Configuración de Python
- Setup de PostgreSQL
- Configuración de git

##### 2. `post_create.sh`
**Propósito**: Post-instalación

**Ejecuta**:
- pip install de requirements
- Migraciones de Django
- Fixtures de datos de prueba
- Configuración de shell

##### 3. `post_start.sh`
**Propósito**: Al iniciar container

**Ejecuta**:
- Verificación de servicios
- Actualización de dependencias
- Limpieza de archivos temporales

##### 4. `update_content.sh`
**Propósito**: Actualización de contenido

**Ejecuta**:
- git pull
- pip install -U
- Django migrations
- collectstatic

##### 5. `check_no_emojis.sh`
**Propósito**: Validar ausencia de emojis

**Uso**:
```bash
./check_no_emojis.sh
```

##### 6. `init_host.sh`
**Propósito**: Inicialización del host

**Ejecuta**:
- Instalación de Docker
- Configuración de permisos
- Setup de networking

#### Vagrant Scripts (5 scripts)

**Ubicación**: `infrastructure/vagrant/scripts/`

##### 1. `system-prepare.sh`
**Propósito**: Preparación del sistema Vagrant

**Ejecuta**:
- Actualización de paquetes
- Instalación de dependencias base
- Configuración de firewall

##### 2. `postgres-install.sh`
**Propósito**: Instalación de PostgreSQL

**Ejecuta**:
- PostgreSQL 16 installation
- Configuración de pg_hba.conf
- Setup de databases
- User creation

##### 3. `mariadb-install.sh`
**Propósito**: Instalación de MariaDB

**Ejecuta**:
- MariaDB 10.11 installation
- Configuración de my.cnf
- Setup de databases
- User creation

##### 4. `setup-postgres-database.sh`
**Propósito**: Setup específico de bases PostgreSQL

##### 5. `setup-mariadb-database.sh`
**Propósito**: Setup específico de bases MariaDB

---

## Makefile - Comandos de Desarrollo

**Ubicación**: `Makefile` (raíz del proyecto)

### Categorías de Comandos

#### Documentación

```bash
make docs-install     # Instalar MkDocs y plugins
make docs-build       # Construir docs estáticas
make docs-serve       # Servidor local (http://127.0.0.1:8000)
make docs-clean       # Limpiar archivos generados
make docs-deploy      # Deploy a GitHub Pages
make docs-check       # Verificar enlaces y estructura
```

**Shortcuts**:
```bash
make docs    # Alias para docs-build
make serve   # Alias para docs-serve
make deploy  # Alias para docs-deploy
```

#### Desarrollo con Vagrant

```bash
make vagrant-up       # Levantar VM (PostgreSQL + MariaDB)
make vagrant-down     # Apagar VM
make vagrant-ssh      # Conectar por SSH
make vagrant-destroy  # Destruir VM completamente
make check-services   # Verificar conexiones de DB
```

**Servicios**:
- PostgreSQL: `127.0.0.1:15432`
- MariaDB: `127.0.0.1:13306`

#### Testing

```bash
make test            # Ejecutar tests (cuando disponible)
```

#### Limpieza

```bash
make clean           # Limpiar archivos generados
                     # - __pycache__
                     # - *.pyc, *.pyo
                     # - *.egg-info
                     # - docs/site
```

#### Setup Completo

```bash
make setup           # Configuración completa
                     # - docs-install
                     # - Guía de siguientes pasos
```

---

## Procesos de Gobernanza

**Ubicación**: `docs/gobernanza/procesos/`

El proyecto tiene **10 procedimientos estandarizados** documentados.

### 1. Diseño Técnico Detallado
**Archivo**: `procedimiento_diseno_tecnico.md`

**Cuándo usar**:
- Nueva funcionalidad con ≥ 3 requisitos funcionales
- Modificación arquitectónica
- Componentes críticos de seguridad/RBAC

**Estándares**:
- UML 2.5
- C4 Model
- ISO/IEC/IEEE 42010:2011

**Artefactos**:
- `DISENO_TECNICO_{COMPONENTE}.md`
- Diagramas Mermaid (secuencia, flujo, estados, ER)
- Matriz de trazabilidad

**Roles**:
- Tech Lead / Arquitecto (owner)
- BA Lead (validación)
- QA Lead (criterios de aceptación)

---

### 2. Análisis de Seguridad y Modelado de Amenazas
**Archivo**: `procedimiento_analisis_seguridad.md`

**Cuándo usar**:
- Componentes de autenticación/autorización
- Sistemas con datos sensibles (PII)
- APIs públicas
- Implementación RBAC/ABAC

**Metodologías**:
- STRIDE (Spoofing, Tampering, Repudiation, etc.)
- PASTA (Attack Simulation)
- LINDDUN (Privacy)
- OWASP Top 10 2021

**Artefactos**:
- `ANALISIS_SEGURIDAD_AMENAZAS_{COMPONENTE}.md`
- Catálogo de amenazas (T-XXX IDs)
- Matriz de riesgos (Probabilidad × Impacto)
- DFD (Data Flow Diagrams)
- Controles preventivos/detectivos/correctivos

**Roles**:
- Security Lead (owner)
- Tech Lead (factibilidad)
- Compliance Officer (regulatorio)

---

### 3. Trazabilidad de Requisitos (ISO 29148)
**Archivo**: `procedimiento_trazabilidad_requisitos.md`

**Cuándo usar**:
- Nuevo requisito de cualquier tipo
- Modificación de requisitos existentes
- Auditorías de conformidad

**Estándares**:
- ISO/IEC/IEEE 29148:2018 (Full Conformance Clause 4.2)
- BABOK v3
- PMBOK Guide 7th Ed

**Clasificación**:
- N-XXX: Necesidades de Negocio
- RN-XXX: Requisitos de Negocio
- RS-XXX: Requisitos de Stakeholders
- RF-XXX: Requisitos Funcionales
- RNF-XXX: Requisitos No Funcionales

**Artefactos**:
- Archivos en `implementacion/{domain}/requisitos/{tipo}/`
- RTM (Requirements Traceability Matrix)
- Índices ISO 29148 (BRS, StRS, SyRS, SRS)

**Roles**:
- BA Lead (owner)
- Product Owner (priorización)
- QA Lead (verificación)

---

### 4. Revisión Documental
**Archivo**: `procedimiento_revision_documental.md`

**Cuándo usar**:
- Documento técnico nuevo
- Actualización mayor de documentos
- Cambios en procesos/lineamientos

**Tipos de revisión**:
- Formal (documentos críticos)
- Informal (cambios menores)
- Peer review (técnicos)

**Artefactos**:
- Checklist de revisión
- Comentarios estructurados
- Aprobación formal

**Roles**:
- Autor (owner)
- Reviewers (técnicos/funcionales)
- Approver (decisión final)

---

### 5. Gestión de Cambios
**Archivo**: `procedimiento_gestion_cambios.md`

**Cuándo usar**:
- Cambio en arquitectura
- Cambio en procesos establecidos
- Cambio de dependencias críticas
- Cambio de configuración de producción

**Proceso**:
1. Request (RFC - Request for Change)
2. Analysis (impacto, riesgos, esfuerzo)
3. Approval (CAB - Change Advisory Board)
4. Implementation
5. Verification
6. Post-implementation review

**Artefactos**:
- RFC document
- Impact assessment
- Rollback plan
- Post-implementation report

**Roles**:
- Change Manager (coordinación)
- CAB (aprobación)
- Implementer (ejecución)

---

### 6. Quality Assurance (QA)
**Archivo**: `procedimiento_qa.md`

**Cuándo usar**:
- Nueva funcionalidad lista para QA
- Antes de cada release
- Después de fix crítico

**Niveles de testing**:
1. Unit tests (pytest)
2. Integration tests
3. System tests
4. Acceptance tests (UAT)

**Estrategias**:
- Test-Driven Development (TDD)
- Behavior-Driven Development (BDD)
- Exploratory testing
- Regression testing

**Artefactos**:
- Test plans
- Test cases
- Test reports
- Bug reports

**Roles**:
- QA Lead (estrategia)
- QA Engineers (ejecución)
- Developers (unit tests)

---

### 7. Release Management
**Archivo**: `procedimiento_release.md`

**Cuándo usar**:
- Nuevo release planificado
- Hotfix urgente
- Release candidate

**Proceso**:
1. Planning (scope, fecha, changelog)
2. Build (CI/CD pipeline)
3. Testing (QA completo)
4. Staging deployment
5. Production deployment
6. Monitoring
7. Post-release review

**Versionado**:
- Semantic Versioning (SemVer)
- MAJOR.MINOR.PATCH
- Tags git: `v1.2.3`

**Artefactos**:
- Release notes
- Changelog
- Migration guides
- Rollback procedures

**Roles**:
- Release Manager (coordinación)
- Tech Lead (aprobación técnica)
- Product Owner (aprobación negocio)

---

### 8. Desarrollo Local
**Archivo**: `procedimiento_desarrollo_local.md`

**Cuándo usar**:
- Nuevo desarrollador
- Setup de entorno nuevo
- Troubleshooting de entorno

**Opciones de entorno**:
1. DevContainer (recomendado)
2. Vagrant VM
3. Manual local
4. Docker Compose

**Proceso**:
1. Clone del repositorio
2. Setup de entorno (opción elegida)
3. Instalación de dependencias
4. Configuración de bases de datos
5. Ejecución de migraciones
6. Verificación de setup

**Artefactos**:
- `.env` configurado
- Databases creadas
- Tests pasando

**Roles**:
- Developer (ejecución)
- Tech Lead (soporte)

---

### 9. Instalación de Entorno
**Archivo**: `procedimiento_instalacion_entorno.md`

**Cuándo usar**:
- Nuevo servidor
- Nueva instancia
- Disaster recovery

**Ambientes**:
- Development
- Staging
- Production

**Proceso**:
1. Provisioning (infraestructura)
2. OS setup
3. Dependencies installation
4. Application deployment
5. Database setup
6. Configuration
7. Smoke tests
8. Monitoring setup

**Artefactos**:
- Runbooks
- Configuration files
- Deployment checklist

**Roles**:
- DevOps Lead (ejecución)
- Tech Lead (validación)
- SysAdmin (infraestructura)

---

### 10. Trazabilidad de Requisitos (ampliado)
**Archivo**: `procedimiento_trazabilidad_requisitos.md`

Ver sección 3 arriba. Documenta específicamente:
- Bidirectional traceability
- Forward traceability (N → RN → RS → RF/RNF)
- Backward traceability (Tests → RF → RN → N)
- Change impact analysis
- Coverage analysis

---

## Workflows de Infraestructura

### DevContainer Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVCONTAINER WORKFLOW                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. onCreate                                                 │
│     └─ on_create.sh                                         │
│        ├─ Instalar deps sistema                             │
│        ├─ Configurar Python                                 │
│        ├─ Setup PostgreSQL                                  │
│        └─ Configurar git                                    │
│                                                              │
│  2. postCreate                                               │
│     └─ post_create.sh                                       │
│        ├─ pip install -r requirements                       │
│        ├─ Django migrations                                 │
│        ├─ Load fixtures                                     │
│        └─ Shell config                                      │
│                                                              │
│  3. postStart (cada vez que inicia)                         │
│     └─ post_start.sh                                        │
│        ├─ Verificar servicios                               │
│        ├─ Actualizar deps (si cambió requirements)         │
│        └─ Limpiar temporales                                │
│                                                              │
│  4. updateContent (git pull)                                │
│     └─ update_content.sh                                    │
│        ├─ git pull                                          │
│        ├─ pip install -U                                    │
│        ├─ Django migrations                                 │
│        └─ collectstatic                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Vagrant Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                      VAGRANT WORKFLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. vagrant up                                               │
│     └─ Ejecuta en orden:                                    │
│        ├─ system-prepare.sh                                 │
│        │  ├─ apt update && upgrade                          │
│        │  ├─ Instalar build-essential                       │
│        │  └─ Configurar firewall                            │
│        │                                                     │
│        ├─ postgres-install.sh                               │
│        │  ├─ PostgreSQL 16 install                          │
│        │  ├─ Configurar pg_hba.conf                         │
│        │  └─ Create databases/users                         │
│        │                                                     │
│        ├─ mariadb-install.sh                                │
│        │  ├─ MariaDB 10.11 install                          │
│        │  ├─ Configurar my.cnf                              │
│        │  └─ Create databases/users                         │
│        │                                                     │
│        ├─ setup-postgres-database.sh                        │
│        │  └─ Setup específico de schemas                    │
│        │                                                     │
│        └─ setup-mariadb-database.sh                         │
│           └─ Setup específico de schemas                    │
│                                                              │
│  2. make check-services                                      │
│     └─ Verificar conectividad:                              │
│        ├─ PostgreSQL (127.0.0.1:15432)                      │
│        └─ MariaDB (127.0.0.1:13306)                         │
│                                                              │
│  3. vagrant halt / vagrant destroy                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Workflows de Desarrollo Local

### Workflow Típico de Desarrollo

```
┌─────────────────────────────────────────────────────────────┐
│              WORKFLOW DE DESARROLLO DIARIO                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Setup Inicial (Primera vez)                             │
│     ├─ git clone                                            │
│     ├─ make setup                                           │
│     ├─ make vagrant-up (o DevContainer)                     │
│     └─ make check-services                                  │
│                                                              │
│  2. Desarrollo de Feature                                   │
│     ├─ git checkout -b feature/mi-feature                   │
│     ├─ Desarrollo...                                        │
│     ├─ pytest (tests)                                       │
│     ├─ ruff check . (lint)                                  │
│     └─ mypy . (type check)                                  │
│                                                              │
│  3. Pre-commit                                               │
│     ├─ make test (si configurado)                          │
│     ├─ ./scripts/validate_critical_restrictions.sh         │
│     ├─ git add .                                            │
│     └─ git commit -m "feat: ..."                           │
│                                                              │
│  4. Push y PR                                                │
│     ├─ git push origin feature/mi-feature                   │
│     ├─ Crear PR en GitHub                                   │
│     └─ Esperar CI/CD (Python CI + Lint)                    │
│                                                              │
│  5. Post-Merge                                               │
│     ├─ git checkout main                                    │
│     ├─ git pull                                             │
│     └─ Repetir desde paso 2                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Workflow de Documentación

```
┌─────────────────────────────────────────────────────────────┐
│           WORKFLOW DE DOCUMENTACIÓN                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Desarrollo Local                                         │
│     ├─ make docs-serve                                      │
│     ├─ Editar archivos .md                                  │
│     ├─ Ver cambios en http://127.0.0.1:8000                │
│     └─ Ctrl+C para detener                                 │
│                                                              │
│  2. Validación                                               │
│     ├─ make docs-check                                      │
│     ├─ ./scripts/requisitos/validar_frontmatter.py         │
│     └─ markdownlint docs/**/*.md                           │
│                                                              │
│  3. Commit                                                   │
│     ├─ git add docs/                                        │
│     └─ git commit -m "docs: ..."                           │
│                                                              │
│  4. CI/CD Automático (después de push)                      │
│     ├─ Lint workflow (markdown + yaml)                     │
│     ├─ Docs workflow (build + deploy si main)              │
│     └─ Requirements index (si cambió requisitos)           │
│                                                              │
│  5. Deploy Automático (push a main)                         │
│     └─ GitHub Pages actualizado automáticamente            │
│        https://2-coatl.github.io/IACT---project/           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Workflow de Tests con LLM

```
┌─────────────────────────────────────────────────────────────┐
│           WORKFLOW GENERACIÓN DE TESTS                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Primera Vez                                              │
│     ├─ cd scripts/ai/examples                               │
│     ├─ ./validate_environment.sh                           │
│     ├─ export ANTHROPIC_API_KEY="sk-ant-..."              │
│     └─ ./quickstart.sh demo                                │
│                                                              │
│  2. Generación Básica                                        │
│     ├─ ./quickstart.sh basic                               │
│     ├─ Esperar ~5-10 minutos                               │
│     └─ Revisar PR creado                                   │
│                                                              │
│  3. Generación para Archivo Específico                      │
│     ├─ ./example_single_file.sh ../../api/app/models.py   │
│     └─ Revisar tests en tests/test_models_generated.py    │
│                                                              │
│  4. Revisar y Ajustar                                        │
│     ├─ Revisar tests generados                             │
│     ├─ Editar si necesario                                 │
│     ├─ pytest tests/test_*_generated.py                    │
│     └─ git commit (si OK)                                  │
│                                                              │
│  5. Integración en CI (opcional)                            │
│     └─ Configurar example_ci_integration.sh en GitHub      │
│        Actions                                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Matriz de Workflows

Tabla completa de todos los workflows disponibles.

| # | Workflow | Tipo | Trigger | Duración | Output Principal |
|---|----------|------|---------|----------|------------------|
| **GitHub Actions** |
| 1 | Python CI/CD | CI/CD | Push/PR a api/ | ~10-15 min | Coverage reports, test results |
| 2 | Lint | CI/CD | Push/PR | ~5-7 min | Lint reports |
| 3 | Deploy Docs | CD | Push a docs/ | ~4-6 min | GitHub Pages |
| 4 | Requirements Index | CI | Push a requisitos/ | ~5 min | BRS, RTM, índices |
| 5 | Release Management | Release | Tag v*.*.* | ~6 min | GitHub Release |
| **Scripts de Validación** |
| 6 | Critical Restrictions | Validación | Manual | <1 min | Exit code 0/1 |
| 7 | Security Config | Validación | Manual | <1 min | Exit code 0/1 |
| 8 | Database Router | Validación | Manual | <1 min | Exit code 0/1 |
| **Scripts de Requisitos** |
| 9 | Generar Índices | Generación | Manual | ~2 min | BRS, StRS, SyRS, SRS |
| 10 | Validar Frontmatter | Validación | Manual | <1 min | Lista de errores |
| 11 | Listar Requisitos | Utilidad | Manual | <10s | Lista en stdout |
| 12 | Contar Requisitos | Utilidad | Manual | <10s | Count en stdout |
| **Scripts LLM Tests** |
| 13 | Test Generation Pipeline | Generación | Manual | ~5-10 min | Tests + PR |
| 14 | Quickstart | Wrapper | Manual | Variable | Depende del modo |
| 15 | Validate Environment | Validación | Manual | ~1 min | Report completo |
| 16 | Single File Tests | Generación | Manual | ~3 min | Test file |
| 17 | Specific Module | Generación | Manual | ~5 min | Tests custom |
| 18 | CI Integration | CI/CD | CI | ~5-10 min | Tests + PR si necesario |
| **Makefile Commands** |
| 19 | docs-install | Setup | Manual | ~2 min | MkDocs instalado |
| 20 | docs-build | Build | Manual | ~30s | docs/site/ |
| 21 | docs-serve | Dev | Manual | Continuo | HTTP server |
| 22 | docs-deploy | Deploy | Manual | ~1 min | GitHub Pages |
| 23 | vagrant-up | Infra | Manual | ~5-10 min | VM con DBs |
| 24 | vagrant-down | Infra | Manual | ~1 min | VM stopped |
| 25 | check-services | Validación | Manual | <10s | Status de servicios |
| 26 | clean | Limpieza | Manual | <30s | Archivos borrados |
| **DevContainer Scripts** |
| 27 | on_create | Lifecycle | Auto | ~3 min | Container setup |
| 28 | post_create | Lifecycle | Auto | ~2 min | Deps instaladas |
| 29 | post_start | Lifecycle | Auto | <30s | Servicios verificados |
| 30 | update_content | Update | Manual | ~1 min | Código actualizado |
| 31 | check_no_emojis | Validación | Manual | <10s | Exit code 0/1 |
| 32 | init_host | Setup | Manual | ~5 min | Host configurado |
| **Vagrant Scripts** |
| 33 | system-prepare | Setup | Auto (vagrant up) | ~2 min | Sistema preparado |
| 34 | postgres-install | Setup | Auto (vagrant up) | ~3 min | PostgreSQL instalado |
| 35 | mariadb-install | Setup | Auto (vagrant up) | ~3 min | MariaDB instalado |
| 36 | setup-postgres-db | Setup | Auto (vagrant up) | <1 min | DB configurada |
| 37 | setup-mariadb-db | Setup | Auto (vagrant up) | <1 min | DB configurada |
| **Procesos de Gobernanza** |
| 38 | Diseño Técnico | Proceso | Manual | Días | Documentos de diseño |
| 39 | Análisis Seguridad | Proceso | Manual | Días | Análisis de amenazas |
| 40 | Trazabilidad Requisitos | Proceso | Manual | Horas | RTM, índices |
| 41 | Revisión Documental | Proceso | Manual | Días | Documento aprobado |
| 42 | Gestión de Cambios | Proceso | Manual | Días | RFC implementado |
| 43 | Quality Assurance | Proceso | Manual | Días | Test reports |
| 44 | Release Management | Proceso | Manual | Días | Release completado |
| 45 | Desarrollo Local | Proceso | Manual | Horas | Entorno funcional |
| 46 | Instalación Entorno | Proceso | Manual | Horas | Servidor configurado |

**Total**: 46 workflows documentados

---

## Resumen por Categoría

| Categoría | Cantidad | Automatización |
|-----------|----------|----------------|
| **GitHub Actions** | 5 | 100% Automático |
| **Scripts de Validación** | 3 | Manual/CI |
| **Scripts de Requisitos** | 4 | Manual/CI |
| **Scripts LLM Tests** | 8 | Manual/CI |
| **Makefile Commands** | 8 | Manual |
| **DevContainer Scripts** | 6 | Auto + Manual |
| **Vagrant Scripts** | 5 | Auto |
| **Procesos de Gobernanza** | 9 | Manual |
| **TOTAL** | **48** | Mixto |

---

## Cómo Usar Este Documento

### Por Rol

**Developer**:
- Workflows: 1, 2, 6-8, 13-18, 19-26, 27-37
- Foco: CI/CD, desarrollo local, validaciones

**QA Engineer**:
- Workflows: 1, 6-8, 13-18, 43
- Foco: Testing, validaciones, generación de tests

**DevOps/SRE**:
- Workflows: 1-5, 19-26, 27-37, 45-46
- Foco: CI/CD, infraestructura, deploy

**Business Analyst**:
- Workflows: 9-12, 38-44
- Foco: Requisitos, trazabilidad, gobernanza

**Tech Lead**:
- Todos los workflows
- Foco: Supervisión, aprobaciones, decisiones

### Por Necesidad

**"Necesito configurar mi entorno"**:
→ Workflows 27-37, 45

**"Necesito generar tests"**:
→ Workflows 13-18

**"Necesito validar mi código antes de commit"**:
→ Workflows 6-8, 31

**"Necesito hacer un release"**:
→ Workflows 5, 44

**"Necesito documentar requisitos"**:
→ Workflows 9-12, 40

**"Necesito actualizar documentación"**:
→ Workflows 3, 19-22, 41

---

## Mejoras Futuras

### Workflows Sugeridos (No Implementados)

1. **Mutation Testing Nightly**
   - mutmut en schedule nocturno
   - Report de mutation score

2. **Performance Regression Tests**
   - pytest-benchmark continuo
   - Alertas de degradación

3. **Security Scanning Scheduled**
   - Trivy, Snyk scheduled
   - CVE monitoring

4. **Dependency Updates**
   - Dependabot o Renovate
   - Auto-PR de updates

5. **API Contract Testing**
   - Schemathesis en CI
   - OpenAPI validation

6. **E2E Tests**
   - Playwright/Cypress
   - Tests de flujos completos

7. **Infrastructure as Code**
   - Terraform workflows
   - Automated provisioning

8. **Monitoring & Alerting**
   - Prometheus + Grafana
   - Alerting rules

---

**Última actualización**: 2025-11-05
**Mantenido por**: Equipo de Desarrollo IACT
**Versión**: 1.0.0
