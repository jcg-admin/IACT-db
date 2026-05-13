# Documentación del Proyecto IACT

Bienvenido a la documentación del proyecto IACT (Intelligent Agent Coordination Technology).

## Tabla de Contenidos

- [Navegación por Roles](#navegación-por-roles)
- [Dominios del Proyecto](#dominios-del-proyecto)
- [Documentación Transversal](#documentación-transversal)
- [Técnicas y Frameworks](#técnicas-y-frameworks)
- [Setup Inicial](#setup-inicial)
- [Convenciones](#convenciones)

---

## Navegación por Roles

Encuentra rápidamente la documentación según tu rol:

### Para AI Engineers
Comienza en [AI/ML](ai/) y [Definiciones de Agentes](../.github/agents/)
- Sistema de agentes (30+ agentes)
- Técnicas de prompting (120+ catalogadas, 20+ implementadas)
- Tests TDD de agentes
- Ejemplos de uso

### Para Desarrolladores Backend
Comienza en [Backend](backend/)
- Código Python backend
- SDLC completo (Planning, Feasibility, Design, Testing, Deployment)
- Tests de técnicas de prompting
- Arquitectura de agentes

### Para Desarrolladores Frontend
Comienza en [Frontend](frontend/)
- Código React/TypeScript
- Componentes UI
- State management
- Tests de UI

### Para DevOps Engineers
Comienza en [DevOps](devops/)
- CI/CD automation
- Scripts de automatización
- Git hooks
- Workflows

### Para SRE/Operaciones
Comienza en [Operaciones](operaciones/)
- Runbooks
- Procedimientos operacionales
- Health checks
- Incident response
- Backups

### Para Ingenieros de Infraestructura
Comienza en [Infraestructura](infraestructura/)
- Terraform/IaC
- Kubernetes manifests
- Cassandra schemas
- Load testing
- Disaster recovery planning

### Para QA/Testing
Comienza en [QA](qa/)
- Scripts de validación
- Tests automatizados
- Quality gates
- Compliance checks

### Para Product Managers/Arquitectos
Comienza en [Visión y Alcance](vision_y_alcance/) y [Planificación](planificacion_y_releases/)
- Visión del proyecto
- Roadmap y releases
- Features y solicitudes
- ADRs arquitectónicos

### Para Compliance/Gobernanza
Comienza en [Gobernanza](gobernanza/)
- Políticas y estándares de alto nivel
- Compliance
- Matriz de relación con gobernanzas de dominios

---

## Dominios del Proyecto

IACT está organizado en 8 dominios autónomos. Cada dominio tiene su propia estructura completa (gobernanza, ADRs, procedimientos, testing, README).

### 1. [AI/ML](ai/)
Sistema de agentes AI/ML y técnicas de prompting

**Contenido principal:**
- 30+ agentes (SDLC, automation, quality, documentation, etc.)
- 120+ técnicas de prompting catalogadas
- 20+ técnicas implementadas (Auto-CoT, Self-Consistency, ReAct, ToT, etc.)
- Tests TDD completos
- Arquitectura de agentes con Constitutional AI

**Scripts relacionados:**
- `scripts/coding/ai/` - Código de agentes
- `scripts/examples/` - Ejemplos de uso

### 2. [Backend](backend/)
Código Python backend y documentación SDLC

**Contenido principal:**
- SDLC completo (Planning, Feasibility, Design, Testing, Deployment)
- Arquitectura de sistema backend
- Tests de código backend
- Design patterns

**Scripts relacionados:**
- `scripts/coding/` - Código backend
- `api/` - API Django

### 3. [Frontend](frontend/)
Código React/TypeScript y componentes UI

**Contenido principal:**
- Arquitectura de componentes
- State management
- Tests de UI
- Guías de desarrollo frontend

**Scripts relacionados:**
- `ui/`, `frontend/` - Código frontend

### 4. [Infraestructura](infraestructura/)
Infraestructura como código y arquitectura de sistemas (DISEÑO y CONSTRUCCIÓN)

**Contenido principal:**
- Terraform/IaC
- Kubernetes manifests
- Cassandra schemas
- Load testing y benchmarking
- Disaster recovery planning

**Scripts relacionados:**
- `scripts/infrastructure/` - Scripts de infraestructura
- `infrastructure/` - IaC

### 5. [DevOps](devops/)
CI/CD, automatización y pipelines

**Contenido principal:**
- Pipeline CI/CD completo
- Git hooks automáticos
- Scripts de automatización
- Workflows

**Scripts relacionados:**
- `scripts/ci/` - CI/CD scripts
- `scripts/git-hooks/` - Git hooks
- `scripts/ci-local.sh` - Pipeline local

### 6. [Operaciones](operaciones/)
Runbooks y procedimientos operacionales (USO y MANTENIMIENTO - SRE)

**Contenido principal:**
- Runbooks de incident response
- Procedimientos operacionales día a día
- Health checks execution
- Backups execution
- Monitoring y alertas

**Scripts relacionados:**
- `scripts/health_check.sh`
- `scripts/backup_data_centralization.sh`
- `scripts/verificar_servicios.sh`
- `scripts/deploy.sh`

**Diferencia con Infraestructura**: Infraestructura es DISEÑO/CONSTRUCCIÓN, Operaciones es USO/MANTENIMIENTO

### 7. [QA](qa/)
Quality Assurance, testing y validación

**Contenido principal:**
- Estrategias de testing
- Scripts de validación
- Quality gates
- Compliance checks

**Scripts relacionados:**
- `scripts/validation/` - Scripts de validación
- `scripts/tests/` - Tests
- `scripts/run_all_tests.sh`

### 8. [DORA](dora/)
Métricas DORA (DevOps Research and Assessment)

**Contenido principal:**
- Deployment frequency
- Lead time for changes
- Mean time to recovery
- Change failure rate

**Scripts relacionados:**
- `scripts/dora_metrics.py`
- `scripts/generate_dora_report.sh`

---

## Documentación Transversal

Documentación de alto nivel que aplica a todos los dominios:

### [Gobernanza](gobernanza/)
Gobernanza de nivel padre con matriz de relación a gobernanzas de dominios

**Contenido:**
- Políticas corporativas
- Estándares de desarrollo
- Compliance de alto nivel
- Matriz de relación con gobernanzas de cada dominio

### [ADRs](adr/)
Architecture Decision Records de alto nivel

**Contenido:**
- Decisiones arquitectónicas transversales
- ADRs que afectan múltiples dominios
- Referencia a ADRs específicos de dominios

### [Análisis](analisis/)
Análisis de requisitos y negocio

**Contenido:**
- Business requirements
- Stakeholder requirements
- System requirements
- Software requirements

### [Visión y Alcance](vision_y_alcance/)
Visión del proyecto y alcance

**Contenido:**
- Visión del proyecto IACT
- Objetivos estratégicos
- Alcance y límites

### [Planificación y Releases](planificacion_y_releases/)
Planificación general y gestión de releases

**Contenido:**
- Roadmap del proyecto
- Planning de releases
- Milestones

### [Guías](guias/)
Guías transversales de desarrollo

**Contenido:**
- Guías de contribución
- Guías de desarrollo
- Best practices

### [Anexos](anexos/)
Material complementario y referencias

**Contenido:**
- Glosarios
- Referencias bibliográficas
- Diagramas
- FAQ

---

## Técnicas y Frameworks

IACT integra múltiples técnicas y frameworks:

| Técnica/Framework | Aplicación en IACT |
|-------------------|-------------------|
| **TDD** | 100% de agentes siguen TDD estricto |
| **Constitutional AI** | Guardrails en todos los agentes SDLC |
| **Auto-CoT** | Generación automática de cadenas de razonamiento |
| **Self-Consistency** | Validación de múltiples paths de razonamiento |
| **ReAct** | Reasoning + Acting en agentes |
| **Tree of Thoughts** | Exploración de árbol de decisiones |
| **RAG** | Retrieval-Augmented Generation |
| **SDLC Pipeline** | 5 fases (Planning, Feasibility, Design, Testing, Deployment) |
| **Prompting Techniques** | 120+ técnicas catalogadas, 20+ implementadas |
| **DORA Metrics** | Métricas de performance DevOps |

Ver catálogo completo en [.github/agents/](../.github/agents/)

---

## Setup Inicial

### Prerequisitos

- Python 3.8+
- Node.js 16+
- Git 2.30+
- Docker 20+

### Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/2-Coatl/IACT---project.git
cd IACT---project

# 2. Instalar dependencias Python
pip install -e .

# 3. Instalar dependencias frontend (si aplica)
npm install

# 4. Verificar prerequisitos del sistema
./scripts/check-prerequisites.sh

# 5. Instalar git hooks de automatización
./scripts/install_hooks.sh

# 6. Ejecutar validación completa
./scripts/ci-local.sh
```

### Verificación de Instalación

```bash
# Debe pasar sin errores
./scripts/ci-local.sh

# Verificar agentes AI
python -m scripts.coding.ai.agents.documentation.documentation_analysis_agent --help

# Ejecutar tests
./scripts/run_all_tests.sh
```

### Comandos Útiles

```bash
# Linting
./scripts/validation/quality/validate_shell_constitution.sh

# Tests
./scripts/run_all_tests.sh

# Generar reportes DORA
./scripts/generate_dora_report.sh

# Health check
./scripts/health_check.sh

# Validar estructura de documentación
./scripts/validar_estructura_docs.sh
```

---

## Convenciones

IACT sigue convenciones estrictas para mantener consistencia:

### Nomenclatura
- Carpetas: `snake_case`
- Archivos: `snake_case.md`
- Sin números en nombres de documentos
- Sin emojis en documentación

### Estructura de Dominios
Cada dominio puede tener:
- `{dominio}/gobernanza/` - Gobernanza específica
- `{dominio}/adr/` - ADRs del dominio
- `{dominio}/procedimientos/` - Procedimientos del dominio
- `{dominio}/testing/` - Tests del dominio
- `{dominio}/README.md` - Índice del dominio

### Commits
Seguir [Conventional Commits](https://www.conventionalcommits.org/):
- `feat: nueva funcionalidad`
- `fix: corrección de bug`
- `docs: cambios en documentación`
- `test: agregar tests`
- `refactor: refactorización de código`

### Documentación Completa
Ver [.github/agents/CONVENTIONS_AND_LESSONS_LEARNED.md](../.github/agents/CONVENTIONS_AND_LESSONS_LEARNED.md)

---

## Contribuir

Para contribuir al proyecto:

1. **Fork** el repositorio
2. **Crear branch** para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Validar localmente** con `./scripts/ci-local.sh`
4. **Commit** tus cambios siguiendo conventional commits
5. **Push** al branch (`git push origin feature/AmazingFeature`)
6. **Abrir Pull Request**

Ver guía completa: [CONTRIBUTING.md](../CONTRIBUTING.md)

---

## Soporte y Contacto

- **Issues**: [GitHub Issues](https://github.com/2-Coatl/IACT---project/issues)
- **Documentación de Agentes**: [.github/agents/](../.github/agents/)
- **Convenciones**: [.github/agents/CONVENTIONS_AND_LESSONS_LEARNED.md](../.github/agents/CONVENTIONS_AND_LESSONS_LEARNED.md)

---

**Estado del Proyecto**: En desarrollo activo

**Última actualización**: 2025-11-18

**Versión de la estructura**: 2.1.0 (Estructura validada y consolidada)
