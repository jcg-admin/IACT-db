---
id: DOC-ARQ-PIPELINE-DEVCONTAINER-HOST-VAGRANT
estado: propuesta
propietario: equipo-plataforma-devops
ultima_actualizacion: 2025-11-21
relacionados:
  - DOC-ARQ-DEVCONTAINER-HOST-VAGRANT
  - DOC-INFRA-INDEX
  - DOC-DEVOPS-INDEX
---
# Canvas de Arquitectura — Pipeline CI/CD sobre DevContainer Host con Vagrant (sin Docker en el host físico)

Diseño de pipeline CI/CD que reutiliza la imagen de DevContainer sobre una VM gestionada por Vagrant, sin instalar Docker en la workstation. El objetivo es asegurar consistencia ambiental entre desarrollo y CI/CD usando un runner self-hosted dentro de la misma VM.

## 1. Identificación del artefacto
- **Nombre:** Arquitectura de Pipeline CI/CD sobre DevContainer Host con Vagrant
- **Proyecto:** IACT
- **Versión:** 1.0
- **Tipo:** Diseño de Arquitectura CI/CD
- **Responsable:** Equipo de Plataforma / DevOps
- **Estado:** Propuesta técnica

## 2. Objetivo del pipeline
El pipeline debe:
1. Ejecutar lint, pruebas y builds en contenedores basados en la misma imagen del DevContainer usado en desarrollo.
2. Usar la VM creada por Vagrant como DevContainer Host y nodo de ejecución del runner CI/CD.
3. Mantener **environmental consistency**, **operational equivalence** y **deterministic execution** entre desarrollo (DevContainer en VS Code) y CI/CD (jobs en contenedores dentro de la VM).
4. Evitar instalar Docker en el host físico del desarrollador.

## 3. Alcance
Incluye:
- Diseño conceptual y lógico del pipeline CI/CD.
- Etapas: checkout, static analysis (lint/format), unit tests, integration tests, build artifacts y security scan opcional.
- Diagramas UML: Use Case, Activity, Component, Deployment y Sequence.

Excluye configuraciones específicas de herramientas, reglas de linters o detalles de credenciales/secrets.

## 4. Flujo CI/CD
### 4.1 Descripción
1. `git push` a rama principal o feature en el repositorio remoto (GitHub/GitLab).
2. El servidor CI/CD dispara el pipeline usando un runner self-hosted en la VM `iact-devcontainer-host`.
3. El runner, dentro de la VM, ejecuta:
   - `checkout` del código
   - `build_devcontainer_image` (si cambia la definición)
   - Jobs en contenedores basados en la imagen DevContainer: `lint`, `unit_tests`, `integration_tests`, `build_artifacts`, `security_scan` (opcional)
4. Los resultados se reportan al servidor CI/CD y se almacenan como artefactos/reportes.

## 5. UML — Activity Diagram del pipeline
```plantuml
@startuml
start

:Developer pushes code to remote repo;
:CI Server receives webhook / trigger;

if (Branch matches CI rules?) then (yes)
  :Select runner on DevContainer Host (Vagrant VM);
  :Start pipeline;

  partition "Stage: Checkout" {
    :Clone repository into VM workspace;
  }

  partition "Stage: Build DevContainer Image" {
    if (DevContainer image up-to-date?) then (yes)
      :Skip image build;
    else (no)
      :Build DevContainer image from devcontainer.json/Dockerfile;
      :Tag image as iact-devcontainer:latest;
    endif
  }

  partition "Stage: Lint" {
    :Run container from iact-devcontainer:latest;
    :Execute linters (Python, JS, etc);
    :Collect reports;
  }

  partition "Stage: Unit Tests" {
    :Run container;
    :Execute unit test suite;
    :Collect reports;
  }

  partition "Stage: Integration Tests" {
    :Run container with integration services;
    :Execute integration test suite;
    :Collect reports;
  }

  partition "Stage: Build Artifacts" {
    :Run container;
    :Build application artifacts;
    :Store artifacts in CI server;
  }

  partition "Stage: Security Scan (optional)" {
    :Run container;
    :Execute security tools (SAST/Dependency scan);
    :Collect reports;
  }

  :Publish pipeline results (success/failure);
else (no)
  :Ignore push (no pipeline triggered);
endif

stop
@enduml
```

## 6. UML — Use Case Diagram
### 6.1 Actores
- Developer
- CI Server (GitHub Actions / GitLab CI)
- DevContainer Host (VM Vagrant con runner)

```plantuml
@startuml
left to right direction

actor Developer
actor "CI Server" as CI
actor "DevContainer Host (VM)" as Host

rectangle "CI/CD System" {
  usecase "Trigger Pipeline" as UC1
  usecase "Run Jobs in DevContainer" as UC2
  usecase "Generate Reports and Artifacts" as UC3
  usecase "Notify Pipeline Status" as UC4
}

Developer --> UC1
CI --> UC1
CI --> UC2
Host --> UC2
CI --> UC3
Developer --> UC4
CI --> UC4

@enduml
```

## 7. UML — Component Diagram
### 7.1 Componentes principales
- Git Repository (Remote)
- CI Server
- Runner self-hosted en la VM
- Runtime de contenedores (Podman / Docker en VM)
- DevContainer image
- Job containers (lint, tests, build)
- Artifact/Report storage

```plantuml
@startuml
rectangle "Git Remote" as GitRepo {
  [Source Code Repository]
}

rectangle "CI Server" as CIServer {
  [Pipeline Orchestrator]
}

node "DevContainer Host (Vagrant VM)" as VM {
  component "Self-Hosted Runner" as Runner
  component "Container Runtime" as Runtime
  component "DevContainer Image\\n(iact-devcontainer:latest)" as DevImg
  component "Job Container: Lint" as C_Lint
  component "Job Container: UnitTests" as C_UT
  component "Job Container: IntegrationTests" as C_IT
  component "Job Container: Build" as C_Build
}

rectangle "Artifacts/Reports Storage" as Store {
  [Artifacts]
  [Test Reports]
  [Logs]
}

GitRepo --> CIServer : Webhook / Polling
CIServer --> Runner : Assign pipeline
Runner --> Runtime : Start containers
Runtime --> DevImg : Pull/Build image
DevImg --> C_Lint
DevImg --> C_UT
DevImg --> C_IT
DevImg --> C_Build

Runner --> Store : Upload artifacts/reports
CIServer --> Store : Persist metadata

@enduml
```

## 8. UML — Deployment Diagram
### 8.1 Nodos de despliegue
- Developer Workstation
- CI Server (SaaS u on-prem)
- DevContainer Host (VM Vagrant)

```plantuml
@startuml
node "Developer Workstation" {
  artifact "VS Code" as VSCode
  artifact "Git CLI" as GitCLI
}

node "CI Server" {
  artifact "CI Orchestrator" as Orchestrator
}

node "DevContainer Host\\n(Vagrant VM: iact-devcontainer-host)" as DevHost {
  node "OS: Ubuntu" {
    artifact "Self-Hosted Runner" as Runner
    artifact "Container Runtime (Podman/Docker)" as CR
    artifact "DevContainer Image" as DevImage
    artifact "Job Containers" as Jobs
  }
}

node "Remote Git Service" as GitService {
  artifact "Git Repository" as Repo
}

VSCode --> GitCLI
GitCLI --> Repo : git push/pull
Repo --> Orchestrator : webhook/trigger
Orchestrator --> Runner : assign job
Runner --> CR : manage containers
CR --> Jobs

@enduml
```

## 9. UML — Sequence Diagram (push → pipeline → DevContainer)
```plantuml
@startuml
actor Developer
participant "Git Repo" as Git
participant "CI Server" as CI
participant "Runner (VM)" as Runner
participant "Container Runtime" as CR
participant "DevContainer Image" as Img
participant "Job Container" as Job

Developer -> Git : git push
Git -> CI : Trigger webhook

CI -> Runner : Assign pipeline
Runner -> Git : Checkout source code

Runner -> CR : Ensure DevContainer image
CR -> Img : Build/Update image if needed

loop For each stage (lint, tests, build)
  Runner -> CR : Run container from Img
  CR -> Job : Start container with stage command
  Job -> Runner : Return logs and status
end

Runner -> CI : Pipeline result (success/failure)
CI -> Developer : Notify status (UI / notifications)

@enduml
```

## 10. Definición conceptual del pipeline (YAML genérico)
Plantilla conceptual para orquestadores CI/CD (no específica de proveedor).

```yaml
pipeline:
  name: iact-devcontainer-ci
  trigger:
    branches:
      include:
        - main
        - feature/*
  agent:
    type: self-hosted
    label: iact-devcontainer-host

  variables:
    DEVCONTAINER_IMAGE: iact-devcontainer:latest

  stages:
    - checkout
    - build_devcontainer_image
    - lint
    - unit_tests
    - integration_tests
    - build_artifacts
    - security_scan

  jobs:
    checkout:
      stage: checkout
      script:
        - git clone <repo-url> .
        - git checkout $CI_COMMIT_SHA

    build_devcontainer_image:
      stage: build_devcontainer_image
      script:
        - if image_outdated; then
        -   podman build -t $DEVCONTAINER_IMAGE -f .devcontainer/Dockerfile .
        - fi

    lint:
      stage: lint
      script:
        - podman run --rm -v $PWD:/workspace $DEVCONTAINER_IMAGE ./scripts/run_lint.sh

    unit_tests:
      stage: unit_tests
      script:
        - podman run --rm -v $PWD:/workspace $DEVCONTAINER_IMAGE ./scripts/run_unit_tests.sh

    integration_tests:
      stage: integration_tests
      script:
        - podman run --rm --network=host -v $PWD:/workspace \
            $DEVCONTAINER_IMAGE ./scripts/run_integration_tests.sh

    build_artifacts:
      stage: build_artifacts
      script:
        - podman run --rm -v $PWD:/workspace $DEVCONTAINER_IMAGE ./scripts/build_artifacts.sh
      artifacts:
        paths:
          - dist/
          - build/

    security_scan:
      stage: security_scan
      script:
        - podman run --rm -v $PWD:/workspace $DEVCONTAINER_IMAGE ./scripts/run_security_scan.sh
      when: manual
```

## 11. Calidad y criterios de aceptación
- Todos los jobs se ejecutan en contenedores basados en la misma imagen del DevContainer.
- El runner corre únicamente dentro de la VM `iact-devcontainer-host`.
- No hay dependencia de Docker en el host físico.
- Pipeline determinista: mismo commit → mismo resultado, salvo cambios explícitos en dependencias externas.
- Los diagramas UML reflejan flujo funcional, componentes, despliegue e interacción entre actores.

## 12. Riesgos y mitigaciones
- **Recursos insuficientes en la VM:** dimensionar RAM/CPU; escalar a múltiples DevContainer Hosts si se requiere.
- **Desincronización entre DevContainer de desarrollo y CI/CD:** la definición vive en `.devcontainer/`; el pipeline siempre construye y usa esa imagen.
- **Latencia entre CI Server y DevContainer Host:** ubicar el host en la misma red/región que el CI Server cuando sea posible.

## 13. Checklist de implementación
- [ ] Registrar un runner self-hosted en la VM `iact-devcontainer-host`.
- [ ] Parametrizar la imagen de DevContainer (`DEVCONTAINER_IMAGE`) en el orquestador.
- [ ] Construir/actualizar la imagen en la etapa `build_devcontainer_image`.
- [ ] Estandarizar scripts de etapa (`run_lint.sh`, `run_unit_tests.sh`, etc.) dentro del repositorio.
- [ ] Publicar artefactos y reportes en el servidor CI/CD.
- [ ] Documentar troubleshooting y flujos de actualización de imagen.
