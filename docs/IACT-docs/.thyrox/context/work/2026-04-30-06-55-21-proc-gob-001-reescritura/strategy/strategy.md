```yml
created_at: 2026-04-30 07:30:00
project: IACT-docs
work_package: 2026-04-30-06-55-21-proc-gob-001-reescritura
phase: Phase 5 — STRATEGY
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Strategy: reescritura proc-gob-001 desde cero

> Decisiones aprobadas por el ejecutor para la reescritura.

## Decisiones aprobadas

### D-1: 15 templates faltantes

**Búsqueda en temp-holding completada.** Hallazgos:

**Existen en temp-holding (12) — adaptar:**

| Template | Origen temp-holding |
|----------|---------------------|
| `plantilla_business_case` | `FASE 01/docs/gobernanza/plantillas/plantilla_business_case.md` |
| `plantilla_django_app` | `FASE 01/docs/gobernanza/plantillas/plantilla_django_app.md` |
| `plantilla_etl_job` | `FASE 01/docs/gobernanza/plantillas/plantilla_etl_job.md` |
| `plantilla_manual_usuario` | `FASE 01/docs/gobernanza/plantillas/plantilla_manual_usuario.md` |
| `plantilla_project_charter` | `FASE 01/docs/gobernanza/plantillas/plantilla_project_charter.md` |
| `plantilla_project_management_plan` | `FASE 01/docs/gobernanza/plantillas/plantilla_project_management_plan.md` |
| `plantilla_setup_entorno` | `FASE 01/docs/gobernanza/plantillas/plantilla_setup_entorno.md` |
| `plantilla_setup_qa` | `FASE 01/docs/gobernanza/plantillas/plantilla_setup_qa.md` |
| `plantilla_stakeholder_analysis` | `FASE 01/docs/gobernanza/plantillas/plantilla_stakeholder_analysis.md` |
| `plantilla_ui_ux` | `FASE 01/docs/frontend/plantilla_ui_ux.md` |
| `plantilla_changelog` | parcial — usar GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/CHANGELOG.md como referencia |
| `template_requisito_stakeholder` | `FASE 01/docs/gobernanza/plantillas/template_requisito_stakeholder.md` |

**No existen (3) — eliminar mención:**

| Template | Razón |
|----------|-------|
| `plantilla_rollback_plan` | Concepto cubierto por `tpl-deployment-guide-deployment.rst` § 3.5 Rollback |
| `template_mapping` | Meta-template, N/A en este corpus |
| `template_metadata` | Meta-template, ya cubierto por convención `:artefacto:` en metadata YAML |

**Acción concreta:** crear los 12 templates como `tpl-*-{descripcion}.rst` en
`source/normativa/estandares/plantillas/`, adaptando el contenido de
temp-holding al schema canónico STD-007 (kebab-lowercase, metadata
`:artefacto: TPL_*`).

### D-2: Workflows YAML

**Hallazgo:** existe `proc-devops-001-devops-automation.rst` que cubre la
automatización DevOps del proyecto IACT (con scripts locales, sin Redis,
con buzón interno per CNST-002).

**Acción:** los workflows `.yml` se mantienen como **literales en
backticks** (ej. `` ``backend-ci.yml`` ``) porque son archivos reales del
CI/CD del repo, NO docs Sphinx. La referencia conceptual mapea a
`:doc:` `/normativa/procedimientos/proc-devops-001-devops-automation`.

### D-3: Agentes SDLC

**Decisión:** **ELIMINAR todas las menciones** de:
- `SDLCPlannerAgent`, `SDLCFeasibilityAgent`, `SDLCDesignAgent`,
  `SDLCTestingAgent`, `SDLCDeploymentAgent`, `SDLCOrchestratorAgent`.

Los agentes son conceptos especulativos no implementados — no aportan
trazabilidad documental. Sus columnas en las matrices se eliminan.

### D-4: Scripts Shell

**Decisión:** los scripts (`backend_test.sh`, `frontend_test.sh`,
`test_pyramid_check.sh`, `security_scan.sh`) son **archivos reales**
del repo. Mantener como literales en backticks (`` ``backend_test.sh`` ``).

Su descripción operacional vive en `proc-devops-001-devops-automation`.
Las menciones en proc-gob-001 son **referencias nominales** (qué scripts
existen), no procedimentales.

### D-5: Sección Dark Mode

**Decisión:** reemplazar la sección 5.1 "Flujo Completo: Nueva Feature
(Dark Mode)" por una `.. admonition:: Ejemplo SDLC end-to-end` con un
link a la saga real:

```rst
.. admonition:: Ejemplo SDLC end-to-end
   :class: tip

   El flujo completo aplicado a una feature concreta vive en la saga
   pedagógica :doc:`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/index`.

   Esta saga muestra los 14 artefactos generados desde la necesidad
   inicial (BN-001) hasta el deployment a staging, con cada artefacto
   declarando la skill aplicada y la fase SDLC correspondiente.
```

Esto elimina **~250 refs `.md` de un solo golpe** (los listados
pedagógicos del bloque dark-mode).

### D-6: Approach general

**Decisión:** **reescribir desde cero**. La preservación de la historia
git no compensa el costo de mantener nomenclatura legacy.

## Estructura propuesta del nuevo archivo

```
proc-gob-001-mapeo-procesos-templates.rst (NEW)

1. Propósito
2. Inventario del ecosistema documental
   - Procedimientos (9 con :doc:)
   - Templates (32 con :doc: cuando existen)
   - Checklists (4 con :doc:)
   - Runbooks (2 con :doc:)
   - Workflows YAML (8 literales)
   - Scripts shell (4 literales)
3. Mapeo por Fase SDLC
   - 7 fases: Planning, Feasibility, Design, Implementation,
     Testing, Deployment, Maintenance
   - Cada fase: artefactos generados, procedimiento aplicable,
     templates a usar, checklists
4. Decision Tree: qué template usar
5. Ejemplo end-to-end (admonition con link a saga dark-mode)
6. Trazabilidad y referencias cruzadas
```

**Sin secciones:**
- Agentes SDLC (eliminados)
- Flujos pedagógicos extensos (reemplazados por admonition)

**Métricas esperadas:**
- Líneas: ~400-500 (vs 1409 actual = -65%)
- Refs `.md`: 0 (vs 179 actual)
- Refs `:doc:`: 50+ (mapeo trazable real)

## Plan de tareas

1. **T-001:** Importar 12 templates de temp-holding a
   `source/normativa/estandares/plantillas/`. Adaptación mínima al
   schema STD-007.
2. **T-002:** Actualizar `index.rst` de plantillas con los 12 nuevos.
3. **T-003:** Reescribir `proc-gob-001-mapeo-procesos-templates.rst`
   desde cero siguiendo la estructura propuesta.
4. **T-004:** Build verify (sin warnings nuevos).
5. **T-005:** Commit + push.

## Aprobación

Plan documentado para ejecución. Phase 8 EXECUTE comenzando.
