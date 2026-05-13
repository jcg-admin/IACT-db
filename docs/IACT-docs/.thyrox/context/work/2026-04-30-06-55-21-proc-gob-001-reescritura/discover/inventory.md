```yml
created_at: 2026-04-30 06:55:21
project: IACT-docs
work_package: 2026-04-30-06-55-21-proc-gob-001-reescritura
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inventario completo de proc-gob-001-mapeo-procesos-templates

> Cuantos artefactos menciona, cuáles existen migrados, cuáles
> faltan. Base para Phase 5 STRATEGY.

## Métricas del archivo

| Métrica | Valor |
|---------|-------|
| Líneas totales | 1409 |
| Refs `.md` | 179 |
| Secciones principales | 10 |
| Artefactos únicos mencionados | 95+ |

## Procedimientos operativos (9 mencionados / 9 migrados — 100%)

| Mención original | Doc migrado | Estado |
|-------------------|-------------|--------|
| `procedimiento_qa.md` | `proc-qa-001-actividades-garantia-documental.rst` | ✓ |
| `procedimiento_release.md` | `proc-devops-002-release.rst` | ✓ |
| `procedimiento_diseno_tecnico.md` | `proc-dev-004-diseno-tecnico.rst` | ✓ |
| `procedimiento_desarrollo_local.md` | `proc-dev-003-desarrollo-local.rst` | ✓ |
| `procedimiento_gestion_cambios.md` | `proc-gob-011-gestion-cambios.rst` | ✓ |
| `procedimiento_trazabilidad_requisitos.md` | `proc-req-019-trazabilidad-requisitos.rst` | ✓ |
| `procedimiento_instalacion_entorno.md` | `proc-ops-003-instalacion-entorno.rst` | ✓ |
| `procedimiento_revision_documental.md` | `proc-gob-012-revision-documental.rst` | ✓ |
| `procedimiento_analisis_seguridad.md` | `proc-qa-003-analisis-seguridad.rst` | ✓ |

**Acción:** los 9 mapean directamente a `:doc:` existente.

## Templates / Plantillas (35 únicos / 20 migrados — 57%)

### Existen migrados (20)

| Mención original | Plantilla migrada |
|-------------------|-------------------|
| `template_caso_uso.md` | `tpl-uc-casos-de-uso.rst` |
| `template_necesidad.md` | `tpl-breq-objetivos-negocio.rst` |
| `template_requisito_funcional.md` | `tpl-fr-requisitos-funcionales.rst` |
| `template_requisito_negocio.md` | `tpl-br-business-rules.rst` |
| `template_requisito_no_funcional.md` | `tpl-nfr-no-funcionales.rst` |
| `plantilla_caso_de_uso.md` | `tpl-uc-casos-de-uso.rst` |
| `plantilla_caso_prueba.md` | `tpl-tst-pruebas.rst` |
| `plantilla_plan_pruebas.md` | `tpl-tst-pruebas.rst` |
| `plantilla_qa_report.md` | `tpl-tst-pruebas.rst` |
| `plantilla_tdd.md` | `tpl-tst-pruebas.rst` |
| `plantilla_database_design.md` | `tpl-mod-modulos.rst` |
| `plantilla_api_reference.md` | `tpl-api-documentacion-api.rst` |
| `plantilla_sad.md` | `tpl-sad-arquitectura-software.rst` |
| `plantilla_srs.md` | `tpl-srs-software-requirements-spec.rst` |
| `plantilla_spec.md` | `tpl-fr-requisitos-funcionales.rst` |
| `plantilla_release_plan.md` | `tpl-release-plan-release-management.rst` |
| `plantilla_deployment_guide.md` | `tpl-deployment-guide-deployment.rst` |
| `plantilla_runbook.md` | `tpl-troubleshooting-runbook.rst` |
| `plantilla_troubleshooting.md` | `tpl-troubleshooting-runbook.rst` |
| `plantilla_regla_negocio.md` | `tpl-br-business-rules.rst` |

### Sin equivalente migrado (15)

| Mención | Notas |
|---------|-------|
| `plantilla_business_case` | Caso de negocio — pendiente |
| `plantilla_changelog` | Changelog — pendiente |
| `plantilla_django_app` | Específico tech-stack — quizás no aplica |
| `plantilla_etl_job` | Específico tech-stack — quizás no aplica |
| `plantilla_manual_usuario` | Manual usuario — pendiente |
| `plantilla_project_charter` | PMBOK — pendiente |
| `plantilla_project_management_plan` | PMBOK — pendiente |
| `plantilla_rollback_plan` | Rollback — pendiente |
| `plantilla_setup_entorno` | Setup — pendiente |
| `plantilla_setup_qa` | Setup QA — pendiente |
| `plantilla_stakeholder_analysis` | Análisis stakeholder — pendiente |
| `plantilla_ui_ux` | UI/UX — pendiente |
| `template_mapping` | Mapping (meta) — quizás concepto |
| `template_metadata` | Metadata (meta) — quizás concepto |
| `template_requisito_stakeholder` | RS — pendiente |

## Checklists (6 únicos / 4 migrados)

| Mención | Migrado |
|---------|---------|
| `checklist_desarrollo` | `gestion/pm/checklists/checklist-desarrollo.rst` ✓ |
| `checklist_testing` | `gestion/pm/checklists/checklist-testing.rst` ✓ |
| `checklist_trazabilidad_requisitos` | `gestion/pm/checklists/checklist-trazabilidad-requisitos.rst` ✓ |
| `checklist_cambios_documentales` | `gestion/pm/checklists/checklist-cambios-documentales.rst` ✓ |
| `checklist_cam` | typo (truncado) → `checklist-cambios-documentales` |
| `checklist_trazab` | typo (truncado) → `checklist-trazabilidad-requisitos` |

## Runbooks (mencionados en sección "Runbooks")

| Mención | Estado |
|---------|--------|
| `verificar_servicios.md` | ✓ migrado a `devops/runbooks/runbook-verificar-servicios.rst` |
| `reprocesar_etl_fallido.md` | ✓ migrado a `devops/runbooks/runbook-reprocesar-etl-fallido.rst` |
| `claude_code.md` | ✗ no migrado — es referencia a uso de Claude Code (¿aplica?) |
| `github_copilot_codespaces.md` | ✗ no migrado — herramienta externa |

## Workflows YAML (12 mencionados, 8 únicos válidos)

| Workflow | Tipo |
|----------|------|
| `backend-ci.yml` | CI/CD |
| `frontend-ci.yml` | CI/CD |
| `test-pyramid.yml` | CI/CD |
| `deploy.yml` | CI/CD |
| `migrations.yml` | CI/CD |
| `infrastructure-ci.yml` | CI/CD |
| `security-scan.yml` | CI/CD |
| `incident-response.yml` | CI/CD |

NOTA: 4 entradas adicionales (`curity-scan.yml`, `est-pyramid.yml`,
`nt-response.yml`, `tructure-ci.yml`) son **artefactos del grep**
por wrapping de líneas — no son archivos reales.

**Acción:** los workflows .yml NO son docs Sphinx — son archivos
de CI/CD reales del repo. Mantener como literales en backticks.

## Agentes SDLC (6 mencionados)

| Agente | Función |
|--------|---------|
| `SDLCPlannerAgent` | Genera planning artifacts |
| `SDLCFeasibilityAgent` | Evalúa factibilidad |
| `SDLCDesignAgent` | Genera HLD/LLD |
| `SDLCTestingAgent` | Genera tests |
| `SDLCDeploymentAgent` | Coordina deploy |
| `SDLCOrchestratorAgent` | Coordina otros agentes |

**Acción:** son **conceptos arquitectónicos**, no archivos. NO
deben tener extensión. Mantener nombres tal cual.

## Scripts Shell (4 mencionados)

| Script | Propósito |
|--------|-----------|
| `backend_test.sh` | Tests backend |
| `frontend_test.sh` | Tests frontend |
| `test_pyramid_check.sh` | Validar pirámide tests |
| `security_scan.sh` | Scan seguridad |

**Acción:** son archivos `.sh` reales del repo. Mantener literales.

## Estructura del archivo (10 secciones)

1. Propósito (líneas 21-31)
2. Tabla de Contenidos (líneas 35-45)
3. Visión General del Ecosistema (líneas 49-78) — diagrama ASCII
4. Matriz de Trazabilidad Completa (líneas 81-228)
   - 4.1 Matriz Principal: Proceso → Workflow → Template
   - 4.2 Matriz de Templates por Categoría
   - 4.3 Matriz de Workflows CI/CD
5. Mapeo por Fase SDLC (líneas 231-621)
   - FASE 1: Planning & Requirements
   - FASE 2: Feasibility & Design
   - FASE 3: Implementation
   - FASE 4-7: Testing, Deployment, Monitoring
6. Decision Tree: Qué Template Usar (líneas 622-665)
7. Flujos End-to-End (líneas 666-840)
   - **5.1 Flujo Completo: Nueva Feature (Dark Mode)** — saga de 179 refs
   - 5.2 otros flujos
8. Referencias Cruzadas (líneas 841-920)
9. Operaciones e Incidentes (líneas 921-1100)
10. Conclusiones / Apéndices (líneas 1100-1409)

## Próximo paso

Phase 5 STRATEGY — decidir approach por sección, presentar al
ejecutor para aprobación antes de transformar.
