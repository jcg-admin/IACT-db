# Análisis de Estructura y Plan de Reorganización - Infraestructura

## 1. Contexto y objetivos
- Alinear `docs/infraestructura/` con la estructura, navegación y convenciones usadas en `docs/gobernanza/` (READMEs/INDEX, plantillas, QA, trazabilidad y registros de decisiones).
- Resolver las brechas identificadas: falta de plan QA visible, escasez de análisis específicos por dominio de infraestructura y ausencia de rutas/plantillas equivalentes a las de Gobernanza.
- Garantizar que toda automatización o runbook nuevo siga TDD (tests antes del código) con cobertura mínima de 80% y commits convencionales.

## 2. Observaciones actuales
### 2.1 Inventario resumido (profundidad ≤2)
- `docs/infraestructura/` incluye 22 carpetas principales (p. ej., `qa/`, `adr/`, `checklists/`, `devops/`, `diseno/`, `plan/`, `requisitos/`, `specs/`, `vagrant-dev/`).
- `docs/gobernanza/` expone una estructura más granular: QA con subcarpetas (`testing/`, `registros/`, `QA-ANALISIS-*`), trazabilidad (`trazabilidad/`, matrices), plantillas (`plantillas/`, `templates/`), planes (`plans/`), procesos (`procesos/qa`, `procesos/checklists`) y guías especializadas.
- En infraestructura, `qa/` sólo contiene `README.md`, `tareas_activas.md`, `tareas/` y `QA-ANALISIS-ESTRUCTURA-INFRA-001/`, sin subcarpetas para testing ni registros históricos.

### 2.2 Brechas frente a la referencia de Gobernanza
- **Navegación y consistencia**: faltan enlaces recíprocos y secciones de estado en `README.md`/`INDEX.md` equivalentes a las de Gobernanza (páginas padre/hija, estados de cumplimiento, responsables y métricas).
- **QA y registros**: no existen análisis segmentados por dominio (provisión, hardening, observabilidad, continuidad) ni carpetas de `testing/` y `registros/` dentro de `qa/` para historizar hallazgos o suites.
- **Plantillas y checklists**: falta una librería de plantillas QA y checklists homóloga a `docs/gobernanza/plantillas` y `docs/gobernanza/checklists`, incluyendo frontmatter unificado y estados (pendiente/en progreso/hecho/bloqueado).
- **Trazabilidad y ADR**: aunque existe `adr/`, no hay matriz que vincule decisiones de infraestructura con planes y QA; falta un índice similar a `INDICE_ADRs.md` y vínculos a `tareas_activas.md`.
- **Planes y procesos**: `plan/` y `procedimientos/` no siguen la estructura de `plans/` y `procesos/` de Gobernanza (falta de fases, criterios de salida, responsables, métricas de adopción).
- **Automatización y validaciones**: no hay pipeline documentada para validar documentación y scripts de infraestructura (lint/build/tests) ni se listan comandos de verificación en `qa/`.

## 3. Plan de acción prioritizado
Las tareas deben reflejarse explícitamente en `qa/tareas_activas.md` y usar IDs únicos para trazabilidad. Cada entregable clave del plan de acción se vincula con tareas P1 existentes o nuevas subtareas P0/P1 para evitar que el checklist quede huérfano. El registro y ejecución deben gestionarse con Task tool en paralelo para evitar desalineaciones entre el checklist y la planeación.
### 3.1 Ejecución y evidencias iniciales
- Inventario de estructura ejecutado: 32 archivos `README.md` y 1 `INDEX.md` en `docs/infraestructura/` (ver `qa/registros/EVIDENCIAS_TASK_INFRA_QA.md`).
- Librería de plantillas QA creada en `qa/plantillas/` con checklists para provisión, hardening, observabilidad y continuidad.
- Capas de testing y registros habilitadas en `qa/testing/` y `qa/registros/`, con catálogo de comandos y política de evidencia documentada.
- Cadencia semanal registrada para seguimiento de entregables QA.
### 3.2 Normalización de navegación y plantillas
- Actualizar `docs/infraestructura/README.md` e `INDEX.md` para reflejar secciones padre/hija, estado de cumplimiento, responsables y enlaces cruzados con QA, siguiendo el modelo de `docs/gobernanza/README.md` e `INDEX.md`.
- Crear una librería de plantillas QA en `docs/infraestructura/qa/plantillas/` con frontmatter estándar (estado, responsable, fecha, métricas) y checklists por dominio (provisión, hardening, observabilidad, continuidad) alineadas con `docs/gobernanza/plantillas/` y `docs/gobernanza/checklists/`.

### 3.3 Fortalecimiento de QA y trazabilidad
- Ampliar `docs/infraestructura/qa/` con subcarpetas `testing/` (suites, comandos, coverage), `registros/` (hallazgos, reportes fechados) y `QA-ANALISIS-*` específicos por dominio, registrando cada entrega como TASK-INFRA-QA-002/003 en Task tool y `tareas_activas.md`.
- Incorporar una matriz de trazabilidad que conecte ADRs de infraestructura (`adr/`) con tareas activas y planes; crear un `INDICE_ADRs.md` equivalente y enlazarlo desde `qa/` y `qa/tareas_activas.md` mediante IDs (TASK-INFRA-QA-004).
- Registrar nuevas decisiones de automatización o IaC mediante ADRs, incluyendo motivaciones y alternativas descartadas.

### 3.4 Planificación y procesos
- Reestructurar `plan/` y `procedimientos/` para reflejar fases, criterios de salida y métricas, tomando como referencia `docs/gobernanza/plans/` y `docs/gobernanza/procesos/qa`.
- Integrar `tareas_activas.md` con IDs, responsables, story points (SP) y fechas objetivo; enlazar cada tarea con entregables y ADRs correspondientes, asegurando que el checklist de arranque quede cubierto por tareas activas y sincronizado con Task tool.

### 3.5 Automatización y validaciones
- Definir comandos de validación en `qa/testing/` (build de docs, lint, pruebas de scripts) y dejar documentado el ciclo Red → Green → Refactor con cobertura mínima del 80% (TASK-INFRA-QA-006 en Task tool y `tareas_activas.md`).
- Asociar los comandos de validación a pipelines existentes (`scripts/`, `infrastructure/` o CI) y documentar entradas/salidas esperadas.

## 4. Entregables y responsables sugeridos
| Entregable | Ruta | Responsable sugerido | Fecha objetivo |
|------------|------|----------------------|----------------|
| Inventario detallado y métricas (conteo de README/INDEX, profundidad, QA faltante) | `qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/` | @arquitecto-senior | 2025-11-20 |
| README/INDEX alineados a Gobernanza | `docs/infraestructura/README.md`, `docs/infraestructura/INDEX.md` | @tech-writer | 2025-11-21 |
| Librería de plantillas QA y checklists por dominio | `docs/infraestructura/qa/plantillas/`, `docs/infraestructura/checklists/` | @qa-lead | 2025-11-22 |
| Análisis QA por dominio y registro histórico | `docs/infraestructura/qa/QA-ANALISIS-*`, `docs/infraestructura/qa/registros/` | @qa-lead | 2025-11-23 |
| Matriz de trazabilidad ADR-planes-tareas | `docs/infraestructura/qa/` y `docs/infraestructura/adr/INDICE_ADRs.md` | @arquitecto-senior | 2025-11-24 |
| Procesos y planes con fases y métricas | `docs/infraestructura/plan/`, `docs/infraestructura/procedimientos/` | @devops-lead | 2025-11-25 |
| Validaciones automáticas con cobertura mínima | `docs/infraestructura/qa/testing/`, pipelines en `scripts/` | @devops-lead | 2025-11-26 |

## 5. Riesgos y supuestos
- **Riesgo:** Falta de responsables asignados retrasa la normalización de QA. **Mitigación:** asignar owners en `tareas_activas.md` y revisar semanalmente.
- **Riesgo:** Nombres inconsistentes entre carpetas nuevas y existentes. **Mitigación:** usar snake_case y validar enlaces relativos mediante builds de documentación.
- **Riesgo:** Sin pipeline de validación, los cambios podrían romper automatizaciones. **Mitigación:** definir comandos de build/lint/test y exigir evidencia de cobertura ≥80%.
- **Supuesto:** `docs/gobernanza/` es la referencia obligatoria para navegación, plantillas y trazabilidad.

## 6. Checklist de arranque
- [x] TASK-INFRA-QA-001: Completar inventario y métricas de estructura (README/INDEX, QA faltante, profundidad de carpetas) en este análisis.
  - Evidencia en `qa/registros/EVIDENCIAS_TASK_INFRA_QA.md` con comandos y conteos.
- [x] TASK-INFRA-QA-002/TASK-INFRA-QA-003: Crear `qa/plantillas/`, `qa/testing/` y `qa/registros/` con frontmatter estándar y checklists por dominio.
  - Plantillas publicadas y catálogo de comandos listo para uso, sincronizados en `qa/tareas_activas.md` y Task tool.
- [ ] TASK-INFRA-QA-004: Actualizar `README.md` e `INDEX.md` de infraestructura con navegación, estados y responsables.
  - Reflejar en `qa/tareas_activas.md` como dependencia del P1 **Plan de reorganización docs/infraestructura (QA)** y mantener sincronización con Task tool.
- [ ] TASK-INFRA-QA-005: Publicar matriz de trazabilidad ADR-planes-tareas y enlazarla con `tareas_activas.md`.
  - Añadir subtarea P1 en `qa/tareas_activas.md` que entregue `adr/INDICE_ADRs.md` y la matriz en `qa/`, creada también en Task tool.
- [x] TASK-INFRA-QA-006: Documentar comandos de validación (build, lint, tests) y asociarlos al pipeline con cobertura mínima del 80 %.
  - Catálogo de comandos en `qa/testing/comandos_validacion.md` y política de evidencia publicada.
- [x] TASK-INFRA-QA-007: Programar revisión semanal de avance hasta completar los entregables.
  - Agenda de seguimiento registrada en `qa/registros/EVIDENCIAS_TASK_INFRA_QA.md` y enlazada en `qa/tareas_activas.md`.
