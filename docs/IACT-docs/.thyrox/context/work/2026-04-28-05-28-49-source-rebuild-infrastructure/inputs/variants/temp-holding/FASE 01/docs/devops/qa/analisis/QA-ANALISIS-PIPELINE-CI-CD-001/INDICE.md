# Índice de tareas – QA-ANALISIS-PIPELINE-CI-CD-001

| Tarea | Objetivo | Evidencia esperada | Ruta |
| --- | --- | --- | --- |
| TASK-001 | Inventariar workflows de `.github/workflows`, ramas y paths vigilados. Confirmar alineación con stacks (backend, frontend, docs, infraestructura). | Listado de workflows con triggers y repositorio de artefactos por job. | `evidencias/TASK-001/` |
| TASK-002 | Comparar `scripts/ci-local.sh` y `scripts/ci/run-all-checks.sh` contra jobs remotos para detectar brechas (linters, seguridad, cobertura). | Matriz de comparaciones y flags detectados (p. ej., `ruff`, `pytest`, `bandit`, `codeql`). | `evidencias/TASK-002/` |
| TASK-003 | Validar umbrales y configuraciones de cobertura (Codecov, `MINIMUM_GREEN`, reportes HTML) y su coherencia con la meta ≥ 80 %. | Capturas o reportes con configuraciones de cobertura y resultados recientes. | `evidencias/TASK-003/` |
| TASK-004 | Revisar controles de seguridad y cumplimiento (Bandit, dependency review, `security-scan.yml`, escaneos npm) y su secuencia. | Evidencia de ejecuciones recientes o dry-runs de los jobs de seguridad. | `evidencias/TASK-004/` |
| TASK-005 | Verificar la generación y publicación de artefactos (coverage, benchmarks, documentación sincronizada) y rutas de retención. | Listado de artefactos publicados y configuración de `upload-artifact` o Codecov. | `evidencias/TASK-005/` |
| TASK-006 | Revisar manejo de secretos y variables (`.env`, tokens de Codecov/deploy) y consistencia entre entornos (Codespaces, runners). | Checklist de variables requeridas y ubicación de valores seguros o placeholders. | `evidencias/TASK-006/` |

Cada tarea debe documentar hallazgos, riesgos y acciones sugeridas dentro de su carpeta de evidencias.
