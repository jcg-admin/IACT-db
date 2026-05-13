```yml
project: IACT-docs
work_package: 2026-04-30-06-55-21-proc-gob-001-reescritura
sub_wp_of: 2026-04-30-04-11-28-md-references-audit
program_id: REW-001
created_at: 2026-04-30 06:55:21
current_phase: Phase 1 — DISCOVER
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: Activo
```

# WP — Reescritura de proc-gob-001-mapeo-procesos-templates.rst

## Origen

Hallazgo del WP padre `md-references-audit`: el archivo
`source/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates.rst`
concentra **179 refs `.md` (22% del total del corpus)**. El
ejecutor identificó que el archivo **fue copiado de
temp-holding sin adaptación**, manteniendo nomenclatura
pre-migración.

Las refs `.md` no son problema cosmético — el archivo declara
un MAPEO entre procedimientos, workflows, templates, agentes,
scripts, checklists y runbooks que **debería estar trazable
con `:doc:` refs reales** al corpus migrado.

## Propósito del archivo (intención original)

`proc-gob-001` es la **matriz maestra** del proyecto que mapea:

- 9 procedimientos operativos (`procedimiento_*`)
- 37 templates/plantillas (`plantilla_*`, `template_*`)
- 6 checklists (`checklist_*`)
- 8+ workflows CI/CD (`*.yml`)
- 6 agentes SDLC (`SDLC*Agent`)
- 4 scripts shell (`*.sh`)
- 6+ runbooks operativos
- ~15 artefactos generados (BN/RN/RF/RNF/UC/HLD/LLD)

Es el **mapa de la galaxia documental** del proyecto. Si está
desactualizado, todo el ecosistema apunta a archivos
inexistentes.

## Hallazgos del análisis

### Inventario verificado (ver discover/inventory.md)

| Categoría | Mencionados | Existen migrados | Faltan |
|-----------|-------------|-------------------|--------|
| Procedimientos | 9 | **9 (100%)** | 0 |
| Templates | 35 | **20 (57%)** | 15 |
| Checklists | 6 | 4 (67%) | 2 (typos) |
| Runbooks | 4 | 2 (50%) | 2 |
| Workflows YAML | 8 | 0 (no aplican a sitio) | — |
| Agentes SDLC | 6 | 0 (conceptos, no docs) | — |
| Scripts shell | 4 | 0 (no aplican a sitio) | — |

**Conclusión:** los procedimientos y la mayoría de templates
ya existen. Solo faltan ~15 templates que el ejecutor
explícitamente pidió crear o no crear.

### 15 templates mencionados sin equivalente migrado

```
plantilla_business_case
plantilla_changelog
plantilla_django_app
plantilla_etl_job
plantilla_manual_usuario
plantilla_project_charter
plantilla_project_management_plan
plantilla_rollback_plan
plantilla_setup_entorno
plantilla_setup_qa
plantilla_stakeholder_analysis
plantilla_ui_ux
plantilla_ux               (variante)
template_mapping
template_metadata
template_requisito_stakeholder
```

Decisión a tomar: ¿crear estos 15 templates, eliminar las
menciones, o documentar como "futuros pendientes"?

## Plan del WP

### Phase 1 DISCOVER ✓

Inventario completo de qué menciona el archivo y qué existe
en source.

### Phase 3 ANALYZE (siguiente)

Por cada uno de los 179 refs en el archivo, decidir:

- A) Mapear a `:doc:` existente (procedimientos, templates
  migrados, checklists)
- B) Marcar como "ejemplo pedagógico" via `.. admonition::`
  (sección 5.1 dark-mode)
- C) Mantener como literal sin extensión (workflows, agentes,
  scripts — no son docs sphinx)
- D) Marcar como "templates futuros" o eliminar (los 15 sin
  equivalente)

### Phase 5 STRATEGY

Aprobar approach por sección del archivo (10 secciones
identificadas: Visión General, Matriz Trazabilidad, Mapeo
por Fase SDLC, Decision Tree, Flujos End-to-End, Referencias
Cruzadas, etc.).

### Phase 6 PLAN

Decomposicion en tareas T-NNN: una por cada bloque del archivo
a transformar.

### Phase 10 EXECUTE

Reescribir el archivo bloque por bloque. Build verify al
final.

### Phase 11 TRACK

Métricas: 179 refs `.md` → 0. Build sin warnings nuevos.
Trazabilidad documental restaurada.

## Métricas del archivo

- 1409 líneas total.
- 179 refs `.md`.
- 10 secciones principales.
- ~80 sub-secciones (FASE 1-12, matrices, etc.).

## Decisiones por aprobar antes de Phase 5 STRATEGY

1. **Templates faltantes (15):** ¿crear, eliminar mención, o marcar como futuros pendientes?
2. **Workflows YAML:** ¿mantener como literales (no son docs migrados) o quitar mención?
3. **Agentes SDLC:** ¿mantener nombres conceptuales o quitar?
4. **Scripts shell:** ¿mantener literales en code-blocks?
5. **Sección 5.1 dark-mode:** ¿wrap en admonition + link a saga existente, o reemplazar bloque completo por link a saga?
6. **Estructura general:** ¿reescribir desde cero, o transformar in-place?

## Próximo paso

Cuando se reanude: leer proc-gob-001 sección por sección para
clasificar los 179 refs y producir Phase 5 STRATEGY con plan
detallado.
