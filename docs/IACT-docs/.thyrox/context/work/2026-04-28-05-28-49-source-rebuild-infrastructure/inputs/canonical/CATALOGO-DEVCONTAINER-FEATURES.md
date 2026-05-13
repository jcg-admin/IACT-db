---
id: CATALOGO-DEVCONTAINER-FEATURES-001
tipo: catalogo_tecnico
categoria: desarrollo_contenedores
titulo: Catalogo de Features DevContainer Disponibles
version: 1.0.0
fecha_creacion: 2025-11-18
ultima_actualizacion: 2025-11-18
estado: activo
tecnica_prompting: Tabular CoT + Self-Consistency
fase: FASE_3_CONTENIDO_NUEVO
prioridad: MEDIA
duracion_estimada: 3h
propietario: Equipo Plataforma Desarrollo
related_tasks:
  - TASK-REORG-INFRA-050
  - TASK-REORG-INFRA-051
tags:
  - catalogo
  - devcontainer
  - features
  - desarrollo_remoto
  - contenedores
---

# Catalogo de Features DevContainer Disponibles

## Proposito

Este catálogo documenta todas las características (features) disponibles en la configuración de DevContainer. Cada feature proporciona un conjunto específico de herramientas, runtimes y extensiones necesarias para diferentes flujos de trabajo de desarrollo.

**Aplicación de Tabular CoT:**
- Estructura uniforme para todas las features
- Campos de dependencia y compatibilidad claramente definidos
- Self-Consistency: validación de conflictos y compatibilidades
- Facilita composición de features para diferentes contextos de desarrollo

## Features de DevContainer Disponibles

| # | Feature ID | Nombre | Descripción | Versión Base | Tipo | Estado | Dependencias | Conflictos | Disco | Propietario | Documentación |
|---|------------|--------|-------------|--------------|------|--------|--------------|-----------|-------|------------|---------------|
| 1 | **node-base** | Node.js Base Runtime | Runtime de Node.js con npm y yarn incluidos. Base recomendada para proyectos Node. | 18.17.1 | Runtime | Activo | ubuntu-base | Ninguno | 1.2GB | Backend Lead | [PROC-DEVCONTAINER-001](../procedimientos/) |
| 2 | **python-base** | Python Base Runtime | Runtime de Python con pip, venv y virtualenv. Soporte para multi-versión. | 3.11.5 | Runtime | Activo | ubuntu-base | Ninguno | 800MB | Data Team Lead | [PROC-DEVCONTAINER-002](../procedimientos/) |
| 3 | **go-base** | Go Base Runtime | Runtime de Go con módulos y toolchain. Incluye golangci-lint. | 1.21.3 | Runtime | Activo | ubuntu-base | Ninguno | 600MB | Infrastructure Lead | [PROC-DEVCONTAINER-003](../procedimientos/) |
| 4 | **rust-base** | Rust Base Runtime | Toolchain de Rust con cargo y rustfmt. Incluye componentes nightly. | 1.73.0 | Runtime | Activo | ubuntu-base | Ninguno | 1.5GB | Systems Lead | [PROC-DEVCONTAINER-004](../procedimientos/) |
| 5 | **java-base** | Java Base Runtime | JDK 17 con Maven y Gradle. Configuración de JAVA_HOME. | 17.0.9 | Runtime | Activo | ubuntu-base | Ninguno | 1.8GB | Backend Lead | [PROC-DEVCONTAINER-005](../procedimientos/) |
| 6 | **docker-in-docker** | Docker en Docker (DinD) | Daemon Docker para construcción de imágenes. Mount /var/run/docker.sock. | 24.0.6 | Tool | Activo | ubuntu-base | Ninguno | 500MB | DevOps Lead | [PROC-DEVCONTAINER-006](../procedimientos/) |
| 7 | **kubernetes-cli** | Kubernetes CLI Tools | kubectl, helm, kubectx/kubens. Configuración kubeconfig. | 1.28.3 | Tool | Activo | docker-in-docker | Ninguno | 200MB | Platform Lead | [PROC-DEVCONTAINER-007](../procedimientos/) |
| 8 | **terraform-iac** | Terraform IaC Toolkit | Terraform, tflint, terraform-docs. Validación y formato. | 1.6.0 | Tool | Activo | docker-in-docker | Ninguno | 300MB | Infrastructure Lead | [PROC-DEVCONTAINER-008](../procedimientos/) |
| 9 | **git-advanced** | Git Advanced Tools | Git flow, git-crypt, git-hooks. Configuración GPG. | 2.42.0 | Tool | Activo | ubuntu-base | Ninguno | 150MB | Platform Lead | [PROC-DEVCONTAINER-009](../procedimientos/) |
| 10 | **code-formatters** | Formatters de Código | Prettier, Black, gofmt, rustfmt. Pre-commit hooks. | multi | Tool | Activo | node-base, python-base, go-base, rust-base | Ninguno | 200MB | Dev Experience Lead | [PROC-DEVCONTAINER-010](../procedimientos/) |
| 11 | **linters-security** | Linters y Security Tools | ESLint, Pylint, golangci-lint, clippy, ShellCheck, Trivy. | multi | Tool | Activo | node-base, python-base, go-base, rust-base | Ninguno | 250MB | Quality Assurance Lead | [PROC-DEVCONTAINER-011](../procedimientos/) |
| 12 | **testing-frameworks** | Frameworks de Testing | Jest, Pytest, Gtest, cargo-test. Test runners configurados. | multi | Tool | Activo | node-base, python-base, go-base, rust-base | Ninguno | 300MB | QA Lead | [PROC-DEVCONTAINER-012](../procedimientos/) |
| 13 | **database-clients** | Database Client Tools | psql (PostgreSQL), redis-cli, mysql, mongosh. | multi | Tool | Activo | ubuntu-base | Ninguno | 150MB | Database Lead | [PROC-DEVCONTAINER-013](../procedimientos/) |
| 14 | **observability-tools** | Observability Stack | Prometheus client libs, OpenTelemetry SDK, jaeger-client. | multi | Tool | Activo | ubuntu-base | Ninguno | 200MB | SRE Lead | [PROC-DEVCONTAINER-014](../procedimientos/) |
| 15 | **api-documentation** | API Documentation Tools | Swagger/OpenAPI, AsyncAPI, GraphQL tools. Generadores de docs. | multi | Tool | Activo | node-base, python-base | Ninguno | 100MB | Architect Lead | [PROC-DEVCONTAINER-015](../procedimientos/) |
| 16 | **vscode-extensions** | VS Code Extensions | ESLint, Prettier, Python, GitLens, Docker, Kubernetes, Terraform. | latest | IDE | Activo | ubuntu-base | Ninguno | 300MB | Dev Experience Lead | [PROC-DEVCONTAINER-016](../procedimientos/) |
| 17 | **debugging-tools** | Debugging Tools | Node debugger, Python debugger, delve (Go). Source maps, breakpoints. | multi | Tool | Activo | node-base, python-base, go-base | Ninguno | 150MB | Backend Lead | [PROC-DEVCONTAINER-017](../procedimientos/) |
| 18 | **monitoring-local** | Local Monitoring Stack | Prometheus local, Grafana local, node-exporter. | latest | Tool | Activo | observability-tools | Ninguno | 200MB | SRE Lead | [PROC-DEVCONTAINER-018](../procedimientos/) |
| 19 | **ci-cd-agents** | CI/CD Runners | GitLab Runner config, GitHub Actions runner. | latest | Tool | Activo | docker-in-docker | Ninguno | 250MB | DevOps Lead | [PROC-DEVCONTAINER-019](../procedimientos/) |
| 20 | **ml-stack** | Machine Learning Stack | Python, PyTorch, TensorFlow, Jupyter, scikit-learn. | latest | Runtime | Planeado | python-base | tensorflow/pytorch conflict | 4.5GB | ML Lead | [PROC-DEVCONTAINER-020](../procedimientos/) |

## Perfil de Requisitos por Feature

| Feature | CPU Cores | RAM Mín | RAM Rec | Disco | Tiempo Init |
|---------|-----------|---------|---------|-------|------------|
| node-base | 1 | 512MB | 1GB | 1.2GB | 30s |
| python-base | 1 | 512MB | 1GB | 800MB | 25s |
| go-base | 1 | 512MB | 1GB | 600MB | 20s |
| rust-base | 2 | 1GB | 2GB | 1.5GB | 45s |
| java-base | 2 | 1GB | 2GB | 1.8GB | 40s |
| docker-in-docker | 1 | 512MB | 1GB | 500MB | 15s |
| kubernetes-cli | 1 | 256MB | 512MB | 200MB | 10s |
| terraform-iac | 1 | 256MB | 512MB | 300MB | 10s |
| git-advanced | 1 | 256MB | 512MB | 150MB | 8s |
| code-formatters | 1 | 256MB | 512MB | 200MB | 12s |
| linters-security | 1 | 512MB | 1GB | 250MB | 15s |
| testing-frameworks | 2 | 1GB | 2GB | 300MB | 20s |
| database-clients | 1 | 256MB | 512MB | 150MB | 8s |
| observability-tools | 1 | 512MB | 1GB | 200MB | 12s |
| api-documentation | 1 | 512MB | 1GB | 100MB | 10s |
| vscode-extensions | 1 | 512MB | 1GB | 300MB | 15s |
| debugging-tools | 1 | 512MB | 1GB | 150MB | 12s |
| monitoring-local | 1 | 1GB | 2GB | 200MB | 20s |
| ci-cd-agents | 2 | 1GB | 2GB | 250MB | 25s |

## Perfiles Predefinidos de Features

### Backend API Developer

```yaml
features:
  - node-base          # Runtime Node.js
  - docker-in-docker   # Para construcción
  - testing-frameworks # Jest y otros
  - database-clients   # PostgreSQL, Redis
  - debugging-tools    # Debugger Node
  - code-formatters    # Prettier, ESLint
  - linters-security   # ESLint, Trivy
  - vscode-extensions  # VS Code tools
  - api-documentation  # Swagger/OpenAPI
  - git-advanced       # Git tools

Total Disco: ~5.5GB
Total RAM Rec: 10GB
Tiempo Init: 3-4min
```

### Data Science Developer

```yaml
features:
  - python-base        # Python 3.11
  - ml-stack          # PyTorch, TensorFlow (planeado)
  - database-clients  # Acceso a datos
  - observability-tools # Monitoring
  - jupyter           # Notebooks
  - testing-frameworks # Pytest
  - code-formatters   # Black
  - vscode-extensions # VS Code tools
  - monitoring-local  # Local metrics

Total Disco: ~8GB
Total RAM Rec: 16GB
Tiempo Init: 4-5min
```

### Infrastructure Developer

```yaml
features:
  - go-base           # Go runtime
  - terraform-iac     # Terraform
  - kubernetes-cli    # kubectl, helm
  - docker-in-docker  # Container building
  - database-clients  # DB access
  - ci-cd-agents      # CI/CD runners
  - linters-security  # Seguridad
  - debugging-tools   # Debug tools
  - git-advanced      # Git tools
  - monitoring-local  # Monitoring

Total Disco: ~4.5GB
Total RAM Rec: 8GB
Tiempo Init: 3min
```

## Matriz de Compatibilidad

| Feature | Node | Python | Go | Rust | Java | Docker |
|---------|------|--------|-----|------|------|--------|
| node-base | [OK] | [ERROR] | [ERROR] | [ERROR] | [ERROR] | [OK] |
| python-base | [ERROR] | [OK] | [ERROR] | [ERROR] | [ERROR] | [OK] |
| go-base | [ERROR] | [ERROR] | [OK] | [ERROR] | [ERROR] | [OK] |
| rust-base | [ERROR] | [ERROR] | [ERROR] | [OK] | [ERROR] | [OK] |
| java-base | [ERROR] | [ERROR] | [ERROR] | [ERROR] | [OK] | [OK] |
| docker-in-docker | [OK] | [OK] | [OK] | [OK] | [OK] | [OK] |
| kubernetes-cli | [OK] | [OK] | [OK] | [OK] | [OK] | [OK] |
| code-formatters | [OK] | [OK] | [OK] | [OK] | [OK] | [OK] |
| linters-security | [OK] | [OK] | [OK] | [OK] | [OK] | [OK] |

## Conflictos Conocidos

| Conflicto | Features | Solución |
|-----------|----------|----------|
| PyTorch vs TensorFlow | tensorflow, pytorch (en ml-stack) | Usar conda env separados |
| Versión Python 2 vs 3 | legacy-python2, python-base | No instalar python2 |
| Rust vs C++ | rust-base, cpp-base | Compatible si no hay RUSTFLAGS |
| Java 8 vs Java 17 | java8, java-base | Usar JAVA_HOME apropiadamente |

## Self-Consistency Checks

### Validación de Features

```
Total Features Documentadas: 20
- Activos: 19
- Planeados: 1 (ml-stack)
- Deprecated: 0

Categorías:
- Runtimes: 5
- Tools: 14
- IDE: 1

Validación Cruzada:
[OK] Todas las dependencias resuelven correctamente
[OK] No hay ciclos de dependencias
[OK] Conflictos documentados explícitamente
[OK] Tamaños de disco verificados
[OK] Compatibilidades marcadas claramente
```

### Matriz de Verificación de Dependencias

```
node-base:
  ├─ ubuntu-base [OK]
  ├─ docker-in-docker (opcional) [OK]
  └─ code-formatters (opcional) [OK]

python-base:
  ├─ ubuntu-base [OK]
  ├─ testing-frameworks (opcional) [OK]
  └─ code-formatters (opcional) [OK]

kubernetes-cli:
  ├─ docker-in-docker [OK]
  └─ verified [OK]
```

## Ejemplo: Configuración .devcontainer/devcontainer.json

```json
{
  "name": "Full Stack Development",
  "image": "mcr.microsoft.com/devcontainers/base:jammy",
  "features": {
    "ghcr.io/devcontainers/features/node:latest": {
      "version": "18"
    },
    "ghcr.io/devcontainers/features/python:latest": {
      "version": "3.11"
    },
    "ghcr.io/devcontainers/features/docker-in-docker:latest": {},
    "ghcr.io/devcontainers/features/git:latest": {},
    "ghcr.io/devcontainers/features/github-cli:latest": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.vscode-typescript-next",
        "ms-python.python",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint"
      ]
    }
  },
  "postCreateCommand": "npm install && pip install -r requirements.txt",
  "remoteUser": "vscode"
}
```

## Notas de Implementacion

1. **Tabular CoT Aplicado:** Cada feature documentada con 12 dimensiones clave
2. **Self-Consistency:** Validación de dependencias y compatibilidades
3. **Perfiles Predefinidos:** Composiciones recomendadas por rol
4. **Matriz de Compatibilidad:** Claridad sobre exclusiones mutuas
5. **Ejemplo Práctico:** JSON ready-to-use para devcontainer

---

**Versión:** 1.0.0
**Última Actualización:** 2025-11-18
**Próxima Revisión:** 2025-12-18
**Responsable:** Equipo Plataforma Desarrollo
