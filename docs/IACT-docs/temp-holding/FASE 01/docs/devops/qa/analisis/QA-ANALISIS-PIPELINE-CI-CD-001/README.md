# QA-ANALISIS-PIPELINE-CI-CD-001

Análisis de verificación integral del pipeline CI/CD de IACT, alineando flujos locales (`scripts/ci-local.sh` y `scripts/ci/`) con los workflows de GitHub Actions. El objetivo es confirmar cobertura de checks, dependencias y artefactos para todos los módulos (backend, frontend, infraestructura, docs y agentes) sin depender de Docker en hosts físicos.

## Objetivo y alcance
- Mapear extremo a extremo los puntos de control del pipeline: hooks locales, pipelines locales y workflows remotos.
- Priorizar verificaciones sobre calidad de código, seguridad, cobertura y despliegue para ramas `main`, `develop` y `feature/**`.
- Centralizar hallazgos y evidencias en tareas trazables (`TASK-00X`) con rutas de evidencia dedicadas.

## Inventario inicial del pipeline
- **Flujo local**: `scripts/ci-local.sh` orquesta los checks agrupados en `scripts/ci/run-all-checks.sh`, `scripts/ci/run-all-gates.sh`, validadores de infraestructura (`scripts/ci/infrastructure/*.sh`) y gates de documentación/seguridad (`scripts/ci/gate-*.sh`).
- **Workflows GitHub Actions** (carpeta `.github/workflows`):
  - `python_ci.yml`, `backend-ci.yml`, `frontend-ci.yml` para validación de código y tests por stack.
  - `code-quality.yml`, `lint.yml`, `test-pyramid.yml` y `codeql.yml` refuerzan calidad, estática y seguridad.
  - `infrastructure-ci.yml`, `deploy.yml`, `release.yml` y `security-scan.yml` cubren despliegue e infraestructura.
  - Documentación y trazabilidad: `docs.yml`, `docs-validation.yml`, `sync-docs.yml`, `requirements_index.yml`, `requirements_validate_traceability.yml`, `validate-guides.yml`.
  - Observabilidad y governance: `emoji-validation.yml`, `dependency-review.yml`, `incident-response.yml`.
- **Entregables**: artefactos de cobertura (Codecov, HTML), reportes de Bandit, benchmarks, y validaciones de documentación; todos deben quedar vinculados a las tareas y evidencias.

## Diagrama de flujo
`diagramas.puml` modela el recorrido: hooks locales → pipeline local (`scripts/ci-local.sh`) → workflows de GitHub Actions → artefactos y gates finales.

## Organización y trazabilidad
- `INDICE.md`: define las tareas `TASK-001` a `TASK-006` con resultado esperado y evidencias.
- `evidencias/`: subcarpetas por tarea para logs, capturas y reportes.
- `diagramas.puml`: referencia visual del pipeline.

## Riesgos y focos de validación
- Divergencia entre scripts locales y workflows (versiones de dependencias o flags de cobertura).
- Credenciales sensibles en jobs (tokens de Codecov y despliegue) y variaciones de variables de entorno entre pipelines.
- Gates no alineados con cobertura mínima ≥ 80 % o linters obligatorios (Ruff/MyPy/Bandit) ejecutándose de forma opcional.

## Próximos pasos sugeridos
- Ejecutar cada tarea del índice y adjuntar evidencias (logs, reportes) en `evidencias/`.
- Incorporar validaciones automáticas que comparen los scripts locales con los steps de workflows clave (Python, frontend, docs).
- Publicar un reporte consolidado del pipeline al completar las tareas, enlazándolo desde `docs/devops/qa/INDICE.md`.
