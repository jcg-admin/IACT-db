---
id: PROC-GOB-001
tipo: proceso
categoria: gobernanza
subcategoria: mapeo-plantillas
estado: activo
version: 1.0.0
fecha_creacion: 2025-11-06
autor: equipo-gobernanza
relacionados: ["PROC-001", "PROC-004", "GUIA-002"]
---

# MAPEO: Procedimientos <-> Workflows <-> Templates

**VERSION:** 1.0.0
**FECHA:** 2025-11-06
**PROPOSITO:** Documentar la relacion entre procedimientos, workflows CI/CD, templates y agentes SDLC

---

## Proposito

Este documento mapea explicitamente como se relacionan:
- **Procedimientos operativos** (11)
- **Workflows CI/CD** (8)
- **Templates/Plantillas** (34)
- **Agentes SDLC** (6)
- **Scripts locales** (4)
- **Checklists** (4)
- **Runbooks** (6)

**Uso:** Permite a cualquier miembro del equipo saber exactamente que proceso seguir, que template usar, y que workflow se ejecutara automaticamente en cada fase del ciclo de vida.

---

## Tabla de Contenidos

1. [Vision General del Ecosistema](#1-vision-general-del-ecosistema)
2. [Matriz de Trazabilidad Completa](#2-matriz-de-trazabilidad-completa)
3. [Mapeo por Fase SDLC](#3-mapeo-por-fase-sdlc)
4. [Decision Tree: Que Template Usar](#4-decision-tree-que-template-usar)
5. [Flujos End-to-End](#5-flujos-end-to-end)
6. [Referencias Cruzadas](#6-referencias-cruzadas)

---

## 1. Vision General del Ecosistema

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ECOSISTEMA IACT                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  PROCEDIMIENTOS (Manual)    AGENTES (AI)       WORKFLOWS (Auto)     │
│       │                          │                    │             │
│       │                          │                    │             │
│       v                          v                    v             │
│  CHECKLISTS ────────────> TEMPLATES <────────── SCRIPTS             │
│       │                          │                    │             │
│       │                          │                    │             │
│       v                          v                    v             │
│  RUNBOOKS (Ops)          DOCUMENTACION          ARTEFACTOS          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘

FLUJO TIPICO:
1. Developer sigue PROCEDIMIENTO
2. Usa TEMPLATE para crear artefacto
3. Valida con CHECKLIST
4. Push → WORKFLOW se ejecuta automaticamente
5. WORKFLOW ejecuta SCRIPT local
6. AGENTE genera documentacion adicional (opcional)
7. Si deploy → usa RUNBOOK
```

---

## 2. Matriz de Trazabilidad Completa

### 2.1 Matriz Principal: Proceso → Workflow → Template

| ID | Procedimiento | Workflow CI/CD | Template Principal | Script Local | Agente SDLC | Checklist |
|----|---------------|----------------|-------------------|--------------|-------------|-----------|
| **SDLC-01** | procedimiento_trazabilidad_requisitos | - | template_necesidad, template_requisito_* | - | Planner | checklist_trazabilidad_requisitos |
| **SDLC-02** | procedimiento_diseno_tecnico | - | plantilla_sad, plantilla_spec, plantilla_srs | - | Design | - |
| **SDLC-03** | procedimiento_instalacion_entorno | - | plantilla_setup_entorno | - | - | - |
| **SDLC-04** | procedimiento_desarrollo_local | backend-ci, frontend-ci | plantilla_django_app, plantilla_etl_job | backend_test.sh, frontend_test.sh | - | checklist_desarrollo |
| **SDLC-05** | guia_completa_desarrollo_features | backend-ci, test-pyramid | plantilla_tdd | backend_test.sh, test_pyramid_check.sh | - | checklist_desarrollo |
| **SDLC-06** | procedimiento_qa | test-pyramid | plantilla_plan_pruebas, plantilla_caso_prueba | test_pyramid_check.sh | Testing | checklist_testing |
| **SDLC-07** | procedimiento_release | deploy, migrations | plantilla_release_plan, plantilla_deployment_guide | - | Deployment | - |
| **SDLC-08** | procedimiento_gestion_cambios | - | plantilla_release_plan | - | - | checklist_cambios_documentales |
| **SDLC-09** | procedimiento_analisis_seguridad | security-scan | - | security_scan.sh | - | - |
| **SDLC-10** | procedimiento_revision_documental | - | plantilla_api_reference, plantilla_manual_usuario | - | - | checklist_cambios_documentales |
| **OPS-01** | runbooks/verificar_servicios | - | - | - | - | - |
| **OPS-02** | runbooks/reprocesar_etl_fallido | incident-response | plantilla_troubleshooting | - | - | - |

### 2.2 Matriz de Templates por Categoria

| Categoria | Templates (34 total) | Usado en Fase | Workflow Asociado |
|-----------|---------------------|---------------|-------------------|
| **Requisitos (5)** | template_necesidad, template_requisito_negocio, template_requisito_funcional, template_requisito_no_funcional, template_requisito_stakeholder | Planning | - |
| **Desarrollo (10)** | plantilla_django_app, plantilla_etl_job, plantilla_regla_negocio, plantilla_spec, plantilla_srs, plantilla_tdd, plantilla_troubleshooting, plantilla_plan, plantilla_sad, plantilla_ui_ux | Development | backend-ci, frontend-ci |
| **Testing (2)** | plantilla_plan_pruebas, plantilla_caso_prueba | Testing | test-pyramid |
| **Diseno (2)** | plantilla_database_design, plantilla_caso_de_uso | Design | - |
| **Documentacion (4)** | plantilla_api_reference, plantilla_espacio_documental, plantilla_manual_usuario, plantilla_seccion_limitaciones | Operations | - |
| **Infrastructure (4)** | plantilla_runbook, plantilla_deployment_guide, plantilla_setup_entorno, plantilla_setup_qa | Deployment | deploy, migrations |
| **Gestion (6)** | plantilla_release_plan, plantilla_business_case, plantilla_project_charter, plantilla_project_management_plan, plantilla_stakeholder_analysis, plantilla_registro_actividad | Planning/Release | deploy |

### 2.3 Matriz de Workflows CI/CD

| Workflow | Script Local | Templates Relacionados | Validaciones |
|----------|--------------|------------------------|--------------|
| **backend-ci.yml** | backend_test.sh | plantilla_django_app | RNF-002, tests, coverage ≥80%, lint |
| **frontend-ci.yml** | frontend_test.sh | - | tests, lint, build |
| **test-pyramid.yml** | test_pyramid_check.sh | plantilla_plan_pruebas | 60% Unit / 30% Integration / 10% E2E |
| **deploy.yml** | - | plantilla_deployment_guide | blue-green, health checks, rollback |
| **migrations.yml** | - | plantilla_database_design | dry-run, conflicts, backwards compatibility |
| **infrastructure-ci.yml** | - | plantilla_setup_entorno | terraform validate, ansible lint |
| **security-scan.yml** | security_scan.sh | - | Bandit, secrets, SQL injection, RNF-002 |
| **incident-response.yml** | - | plantilla_troubleshooting | auto-rollback, alertas, post-mortem |

---

## 3. Mapeo por Fase SDLC

### FASE 1: Planning & Requirements

**Responsable:** Business Analyst, Product Owner

**Flujo:**
```
1. Identificar Business Need
   ├─> Usar: template_necesidad.md
   └─> Checklist: checklist_trazabilidad_requisitos.md

2. Analisis de Stakeholders
   ├─> Usar: plantilla_stakeholder_analysis.md
   └─> Procedimiento: (ninguno especifico)

3. Derivar Requisitos de Negocio
   ├─> Usar: template_requisito_negocio.md
   └─> Procedimiento: procedimiento_trazabilidad_requisitos.md

4. Derivar Requisitos Funcionales/No Funcionales
   ├─> Usar: template_requisito_funcional.md, template_requisito_no_funcional.md
   └─> Checklist: checklist_trazabilidad_requisitos.md

5. Justificar con Business Case (opcional)
   └─> Usar: plantilla_business_case.md
```

**Workflows CI/CD:** Ninguno (fase pre-desarrollo)

**Agentes SDLC:**
- SDLCPlannerAgent: Genera planning artifacts

**Artefactos generados:**
- `BN-001-nombre-business-need.md`
- `RN-001-nombre-requisito-negocio.md`
- `RF-001-nombre-requisito-funcional.md`
- `RNF-001-nombre-requisito-no-funcional.md`

---

### FASE 2: Feasibility & Design

**Responsable:** Architect, Tech Lead, BA

**Flujo:**
```
1. Analisis de Factibilidad
   ├─> Agente: SDLCFeasibilityAgent
   └─> Output: feasibility_report.md (generado por agente)

2. Diseno de Alto Nivel (HLD)
   ├─> Procedimiento: procedimiento_diseno_tecnico.md
   ├─> Usar: plantilla_sad.md (Software Architecture Document)
   └─> Agente: SDLCDesignAgent (genera HLD automaticamente)

3. Casos de Uso
   ├─> Usar: plantilla_caso_de_uso.md
   └─> Procedimiento: procedimiento_diseno_tecnico.md

4. Diseno de Base de Datos
   ├─> Usar: plantilla_database_design.md
   └─> Workflow posterior: migrations.yml (validara migraciones)

5. Diseno de Bajo Nivel (LLD)
   ├─> Usar: plantilla_spec.md, plantilla_srs.md
   └─> Agente: SDLCDesignAgent (genera LLD automaticamente)

6. Reglas de Negocio
   └─> Usar: plantilla_regla_negocio.md

7. Diseno UI/UX (si aplica)
   └─> Usar: plantilla_ui_ux.md
```

**Workflows CI/CD:** Ninguno (fase de diseno)

**Agentes SDLC:**
- SDLCFeasibilityAgent: Go/No-Go decision, risk assessment
- SDLCDesignAgent: HLD, LLD, ADRs, Mermaid diagrams

**Artefactos generados:**
- `feasibility_report.md` (agente)
- `HLD-nombre-feature.md` (agente + template SAD)
- `LLD-nombre-feature.md` (agente + template SRS)
- `ADR-001-decision.md` (agente)
- `UC-001-caso-de-uso.md` (template)
- `DB-design-nombre.md` (template)

---

### FASE 3: Development & Implementation

**Responsable:** Developer

**Flujo:**
```
1. Setup Inicial (primera vez)
   ├─> Procedimiento: procedimiento_instalacion_entorno.md
   └─> Template: plantilla_setup_entorno.md

2. Desarrollo Local (diario)
   ├─> Procedimiento: procedimiento_desarrollo_local.md
   ├─> Guia: guia_completa_desarrollo_features.md
   └─> Checklist: checklist_desarrollo.md

3. Crear Django App
   ├─> Template: plantilla_django_app.md
   └─> Workflow: backend-ci.yml (se ejecuta al push)

4. Crear ETL Job
   ├─> Template: plantilla_etl_job.md
   └─> Workflow: backend-ci.yml

5. Test Driven Development
   ├─> Template: plantilla_tdd.md
   ├─> Workflow: backend-ci.yml, test-pyramid.yml
   └─> Script: backend_test.sh

6. Pre-Commit
   ├─> Checklist: checklist_desarrollo.md
   └─> Validaciones: black, isort, flake8, tests

7. Push a GitHub
   ├─> Workflow: backend-ci.yml (automatico)
   │   └─> Ejecuta: backend_test.sh
   │       └─> Valida: RNF-002, tests, coverage ≥80%, lint
   └─> Workflow: frontend-ci.yml (si frontend)
       └─> Ejecuta: frontend_test.sh
```

**Workflows CI/CD:**
- backend-ci.yml
- frontend-ci.yml

**Scripts locales:**
- backend_test.sh
- frontend_test.sh

**Agentes SDLC:** Ninguno (desarrollo manual)

**Artefactos generados:**
- Apps Django en `api/callcentersite/apps/`
- ETL jobs en `scripts/etl/`
- Tests en `tests/`

---

### FASE 4: Testing & QA

**Responsable:** QA Engineer, Developer

**Flujo:**
```
1. Crear Plan de Pruebas
   ├─> Template: plantilla_plan_pruebas.md
   ├─> Procedimiento: procedimiento_qa.md
   └─> Agente: SDLCTestingAgent (genera test plan)

2. Crear Casos de Prueba
   ├─> Template: plantilla_caso_prueba.md
   └─> Agente: SDLCTestingAgent (genera test cases)

3. Setup QA Environment
   └─> Template: plantilla_setup_qa.md

4. Ejecutar Tests
   ├─> Procedimiento: procedimiento_qa.md
   └─> Checklist: checklist_testing.md

5. Validar Test Pyramid
   ├─> Workflow: test-pyramid.yml (automatico)
   ├─> Script: test_pyramid_check.sh
   └─> Validacion: 60% Unit / 30% Integration / 10% E2E

6. Validar Coverage
   ├─> Target: ≥80%
   └─> Workflow: backend-ci.yml (incluye coverage check)
```

**Workflows CI/CD:**
- test-pyramid.yml
- backend-ci.yml (incluye coverage)

**Scripts locales:**
- test_pyramid_check.sh

**Agentes SDLC:**
- SDLCTestingAgent: Genera test plan, test cases, test pyramid strategy

**Artefactos generados:**
- `test_plan_nombre_feature.md` (agente + template)
- `TC-001-caso-prueba.md` (template)
- Coverage reports (HTML)

---

### FASE 5: Deployment & Release

**Responsable:** DevOps, Tech Lead

**Flujo:**
```
1. Crear Release Plan
   ├─> Template: plantilla_release_plan.md
   ├─> Procedimiento: procedimiento_release.md
   └─> Agente: SDLCDeploymentAgent (genera deployment plan)

2. Crear Deployment Guide
   ├─> Template: plantilla_deployment_guide.md
   └─> Agente: SDLCDeploymentAgent

3. Crear Runbooks (si necesario)
   └─> Template: plantilla_runbook.md

4. Gestion de Cambios
   ├─> Procedimiento: procedimiento_gestion_cambios.md
   └─> Template: plantilla_release_plan.md

5. Pre-Deployment
   ├─> Runbook: verificar_servicios.md
   └─> Checklist: (incluido en plantilla_deployment_guide)

6. Deploy a Staging
   ├─> Workflow: deploy.yml (automatico)
   └─> Strategy: blue-green deployment

7. Validar Migraciones
   ├─> Workflow: migrations.yml
   └─> Validaciones: dry-run, conflicts, backwards compatibility

8. Deploy a Production
   ├─> Workflow: deploy.yml
   ├─> Health checks
   └─> Auto rollback si falla

9. Post-Deployment
   ├─> Runbook: verificar_servicios.md
   └─> Monitoring
```

**Workflows CI/CD:**
- deploy.yml
- migrations.yml

**Scripts locales:** Ninguno

**Agentes SDLC:**
- SDLCDeploymentAgent: Genera deployment plan, rollback plan, checklists

**Runbooks:**
- verificar_servicios.md
- merge_y_limpieza_ramas.md

**Artefactos generados:**
- `release_plan_v1.5.0.md` (template)
- `deployment_guide_staging.md` (agente + template)
- `rollback_plan.md` (agente)

---

### FASE 6: Operations & Maintenance

**Responsable:** DevOps, Support

**Flujo:**
```
1. Monitoreo Continuo
   └─> Workflow: incident-response.yml (si hay incidente)

2. Security Scanning
   ├─> Workflow: security-scan.yml (automatico, periodico)
   └─> Script: security_scan.sh
       └─> Validaciones: Bandit, secrets, SQL injection, RNF-002

3. Troubleshooting
   ├─> Template: plantilla_troubleshooting.md
   └─> Runbooks:
       ├─> reprocesar_etl_fallido.md
       └─> claude_code.md

4. Documentacion de API
   ├─> Template: plantilla_api_reference.md
   └─> Procedimiento: procedimiento_revision_documental.md

5. Manual de Usuario
   └─> Template: plantilla_manual_usuario.md

6. Revision Documental
   ├─> Procedimiento: procedimiento_revision_documental.md
   └─> Checklist: checklist_cambios_documentales.md

7. Incident Response
   └─> Workflow: incident-response.yml (automatico)
       └─> Auto-rollback, alertas, post-mortem
```

**Workflows CI/CD:**
- security-scan.yml
- incident-response.yml

**Scripts locales:**
- security_scan.sh

**Agentes SDLC:**
- SDLCOrchestratorAgent: Coordina respuesta a incidentes

**Runbooks:**
- reprocesar_etl_fallido.md
- claude_code.md
- github_copilot_codespaces.md

**Artefactos generados:**
- `api_reference.md` (template)
- `troubleshooting_guide.md` (template)
- Security scan reports

---

## 4. Decision Tree: Que Template Usar

### 4.1 Decision Tree Principal

```
PREGUNTA: Que quiero hacer?
│
├─> "Definir una necesidad de negocio"
│   └─> Usar: template_necesidad.md
│
├─> "Derivar requisitos"
│   ├─> Requisito de Negocio → template_requisito_negocio.md
│   ├─> Requisito Funcional → template_requisito_funcional.md
│   ├─> Requisito No Funcional → template_requisito_no_funcional.md
│   └─> Requisito Stakeholder → template_requisito_stakeholder.md
│
├─> "Disenar arquitectura"
│   ├─> Alto nivel → plantilla_sad.md
│   ├─> Bajo nivel → plantilla_srs.md, plantilla_spec.md
│   ├─> Base de datos → plantilla_database_design.md
│   └─> Casos de uso → plantilla_caso_de_uso.md
│
├─> "Implementar codigo"
│   ├─> Django App → plantilla_django_app.md
│   ├─> ETL Job → plantilla_etl_job.md
│   ├─> TDD → plantilla_tdd.md
│   └─> Reglas de negocio → plantilla_regla_negocio.md
│
├─> "Crear tests"
│   ├─> Plan de pruebas → plantilla_plan_pruebas.md
│   └─> Casos de prueba → plantilla_caso_prueba.md
│
├─> "Hacer deployment"
│   ├─> Release plan → plantilla_release_plan.md
│   ├─> Deployment guide → plantilla_deployment_guide.md
│   └─> Runbook → plantilla_runbook.md
│
├─> "Documentar"
│   ├─> API → plantilla_api_reference.md
│   ├─> Manual usuario → plantilla_manual_usuario.md
│   └─> Troubleshooting → plantilla_troubleshooting.md
│
└─> "Gestionar proyecto"
    ├─> Business case → plantilla_business_case.md
    ├─> Project charter → plantilla_project_charter.md
    ├─> Stakeholders → plantilla_stakeholder_analysis.md
    └─> Project plan → plantilla_project_management_plan.md
```

### 4.2 Decision Tree: Que Procedimiento Seguir

```
PREGUNTA: Que fase estoy ejecutando?
│
├─> "Setup inicial del proyecto"
│   └─> Seguir: procedimiento_instalacion_entorno.md
│
├─> "Desarrollo diario"
│   ├─> Seguir: procedimiento_desarrollo_local.md
│   └─> Guia completa: guia_completa_desarrollo_features.md
│
├─> "Disenar solucion tecnica"
│   └─> Seguir: procedimiento_diseno_tecnico.md
│
├─> "Validar trazabilidad de requisitos"
│   └─> Seguir: procedimiento_trazabilidad_requisitos.md
│
├─> "Ejecutar QA"
│   └─> Seguir: procedimiento_qa.md
│
├─> "Hacer release"
│   └─> Seguir: procedimiento_release.md
│
├─> "Gestionar cambios"
│   └─> Seguir: procedimiento_gestion_cambios.md
│
├─> "Analizar seguridad"
│   └─> Seguir: procedimiento_analisis_seguridad.md
│
└─> "Revisar documentacion"
    └─> Seguir: procedimiento_revision_documental.md
```

### 4.3 Decision Tree: Que Workflow se Ejecuta

```
EVENTO: Que accion realice?
│
├─> "Push a branch con codigo backend"
│   └─> Se ejecuta: backend-ci.yml
│       └─> Ejecuta: backend_test.sh
│           └─> Valida: RNF-002, tests, coverage, lint
│
├─> "Push a branch con codigo frontend"
│   └─> Se ejecuta: frontend-ci.yml
│       └─> Ejecuta: frontend_test.sh
│           └─> Valida: tests, lint, build
│
├─> "PR abierto/actualizado"
│   └─> Se ejecutan: backend-ci.yml, frontend-ci.yml, test-pyramid.yml
│       └─> Valida: todo + test pyramid
│
├─> "Tag vX.Y.Z creado"
│   └─> Se ejecuta: deploy.yml
│       └─> Deploy a staging automatico
│
├─> "Merge a main"
│   └─> Se ejecutan: migrations.yml, security-scan.yml
│       └─> Valida: migraciones, seguridad
│
├─> "Scheduled (diario)"
│   └─> Se ejecuta: security-scan.yml
│       └─> Ejecuta: security_scan.sh
│
└─> "Error rate > threshold"
    └─> Se ejecuta: incident-response.yml
        └─> Auto-rollback, alertas
```

---

## 5. Flujos End-to-End

### 5.1 Flujo Completo: Nueva Feature (Dark Mode)

**Fase 1: Planning (BA)**
```
1. Identificar necesidad
   └─> Crear: BN-001-dark-mode.md (template_necesidad.md)

2. Derivar requisito de negocio
   └─> Crear: RN-001-dark-mode.md (template_requisito_negocio.md)

3. Derivar requisitos funcionales
   └─> Crear: RF-001-dark-mode-toggle.md (template_requisito_funcional.md)
   └─> Crear: RF-002-dark-mode-persistence.md

4. Validar trazabilidad
   └─> Seguir: procedimiento_trazabilidad_requisitos.md
   └─> Checklist: checklist_trazabilidad_requisitos.md
```

**Fase 2: Feasibility (Architect)**
```
5. Analisis de factibilidad
   └─> Ejecutar: SDLCFeasibilityAgent
   └─> Output: feasibility_report_dark_mode.md
   └─> Decision: GO

6. Casos de uso
   └─> Crear: UC-001-activar-dark-mode.md (plantilla_caso_de_uso.md)
```

**Fase 3: Design (Tech Lead)**
```
7. Diseno de alto nivel
   └─> Seguir: procedimiento_diseno_tecnico.md
   └─> Ejecutar: SDLCDesignAgent
   └─> Crear: HLD-dark-mode.md (plantilla_sad.md)

8. Diseno de bajo nivel
   └─> Ejecutar: SDLCDesignAgent
   └─> Crear: LLD-dark-mode.md (plantilla_srs.md)
   └─> Output: Mermaid diagrams (agente)

9. Diseno de base de datos (si necesario)
   └─> Crear: DB-user-preferences.md (plantilla_database_design.md)
```

**Fase 4: Development (Developer)**
```
10. Setup (si primera vez)
    └─> Seguir: procedimiento_instalacion_entorno.md

11. Crear Django app
    └─> Usar: plantilla_django_app.md
    └─> Crear: api/callcentersite/apps/preferences/

12. Desarrollo TDD
    └─> Seguir: guia_completa_desarrollo_features.md
    └─> Usar: plantilla_tdd.md
    └─> Checklist: checklist_desarrollo.md

13. Pre-commit
    └─> Checklist: checklist_desarrollo.md
    └─> Ejecutar: black, isort, flake8, tests

14. Push a GitHub
    └─> Workflow: backend-ci.yml (automatico)
        └─> Ejecuta: backend_test.sh
        └─> Valida: PASS
```

**Fase 5: Testing (QA)**
```
15. Plan de pruebas
    └─> Ejecutar: SDLCTestingAgent
    └─> Crear: test_plan_dark_mode.md (plantilla_plan_pruebas.md)

16. Casos de prueba
    └─> Ejecutar: SDLCTestingAgent
    └─> Crear: TC-001-toggle-dark-mode.md (plantilla_caso_prueba.md)

17. Ejecutar tests
    └─> Seguir: procedimiento_qa.md
    └─> Checklist: checklist_testing.md

18. Validar test pyramid
    └─> Workflow: test-pyramid.yml (automatico)
    └─> Validacion: PASS (60/30/10)
```

**Fase 6: Deployment (DevOps)**
```
19. Release plan
    └─> Ejecutar: SDLCDeploymentAgent
    └─> Crear: release_plan_v1.5.0.md (plantilla_release_plan.md)

20. Deployment guide
    └─> Ejecutar: SDLCDeploymentAgent
    └─> Crear: deployment_guide_staging.md (plantilla_deployment_guide.md)

21. Pre-deployment
    └─> Seguir: procedimiento_release.md
    └─> Runbook: verificar_servicios.md

22. Deploy staging
    └─> Workflow: deploy.yml (automatico al crear tag v1.5.0-rc1)
    └─> Strategy: blue-green
    └─> Health checks: PASS

23. Validar migraciones
    └─> Workflow: migrations.yml
    └─> Validacion: PASS

24. Deploy production
    └─> Workflow: deploy.yml (automatico al crear tag v1.5.0)
    └─> Health checks: PASS

25. Post-deployment
    └─> Runbook: verificar_servicios.md
    └─> Runbook: merge_y_limpieza_ramas.md
```

**Fase 7: Operations (DevOps/Support)**
```
26. Documentacion API (si aplica)
    └─> Crear: api_reference_preferences.md (plantilla_api_reference.md)

27. Security scan
    └─> Workflow: security-scan.yml (automatico diario)
    └─> Validacion: PASS

28. Monitoreo continuo
    └─> Si incident → Workflow: incident-response.yml
```

**Total time:** ~3-5 dias (dependiendo de complejidad)

---

### 5.2 Flujo Completo: Bugfix Critico (Production Down)

**Fase 1: Detection (Automatico)**
```
1. Error rate > threshold
   └─> Workflow: incident-response.yml (automatico)
   └─> Alertas enviadas

2. Diagnostico inicial
   └─> Runbook: verificar_servicios.md
   └─> Identificado: MySQL crashed
```

**Fase 2: Resolution (DevOps)**
```
3. Solucion inmediata
   └─> Runbook: verificar_servicios.md
   └─> Accion: Restart MySQL
   └─> Health checks: PASS

4. Validar servicios
   └─> Runbook: verificar_servicios.md
   └─> Status: Operacional
```

**Fase 3: Post-Incident (Tech Lead)**
```
5. Post-mortem
   └─> Crear: troubleshooting_mysql_crash.md (plantilla_troubleshooting.md)
   └─> Root cause: Disk full

6. Acciones preventivas
   └─> Crear: RNF-005-disk-monitoring.md (template_requisito_no_funcional.md)
```

**Total MTTR:** ~15 minutos

---

### 5.3 Flujo Completo: ETL Job Fallido (Reprocesar)

**Fase 1: Detection (Manual o Automatico)**
```
1. ETL job fallo
   └─> Log: ERROR in process_customer_data()
```

**Fase 2: Resolution (Developer/DevOps)**
```
2. Troubleshooting
   └─> Runbook: reprocesar_etl_fallido.md
   └─> Diagnostico: Datos corruptos en fuente

3. Corregir datos fuente
   └─> Procedimiento: (especifico del ETL)

4. Reprocesar ETL
   └─> Runbook: reprocesar_etl_fallido.md
   └─> Script: ./scripts/etl/reprocess.py --job-id 12345
   └─> Status: SUCCESS
```

**Fase 3: Documentation (Developer)**
```
5. Documentar solucion
   └─> Actualizar: troubleshooting_etl.md (plantilla_troubleshooting.md)
```

**Total time:** ~30 minutos

---

## 6. Referencias Cruzadas

### 6.1 De Procedimiento a Templates

| Procedimiento | Templates Relacionados |
|---------------|------------------------|
| procedimiento_instalacion_entorno | plantilla_setup_entorno |
| procedimiento_desarrollo_local | plantilla_django_app, plantilla_etl_job, plantilla_tdd |
| procedimiento_diseno_tecnico | plantilla_sad, plantilla_spec, plantilla_srs, plantilla_caso_de_uso, plantilla_database_design |
| procedimiento_trazabilidad_requisitos | template_necesidad, template_requisito_* |
| procedimiento_qa | plantilla_plan_pruebas, plantilla_caso_prueba, plantilla_setup_qa |
| procedimiento_release | plantilla_release_plan, plantilla_deployment_guide |
| procedimiento_gestion_cambios | plantilla_release_plan |
| procedimiento_analisis_seguridad | (ninguno - usa security_scan.sh) |
| procedimiento_revision_documental | plantilla_api_reference, plantilla_manual_usuario |
| guia_completa_desarrollo_features | plantilla_django_app, plantilla_tdd |

### 6.2 De Workflow a Procedimientos

| Workflow | Procedimientos Relacionados |
|----------|----------------------------|
| backend-ci.yml | procedimiento_desarrollo_local, guia_completa_desarrollo_features |
| frontend-ci.yml | procedimiento_desarrollo_local |
| test-pyramid.yml | procedimiento_qa |
| deploy.yml | procedimiento_release |
| migrations.yml | procedimiento_diseno_tecnico (database design) |
| infrastructure-ci.yml | procedimiento_instalacion_entorno |
| security-scan.yml | procedimiento_analisis_seguridad |
| incident-response.yml | (runbooks) |

### 6.3 De Agente SDLC a Templates

| Agente | Templates que Usa/Genera |
|--------|--------------------------|
| SDLCPlannerAgent | template_necesidad, template_requisito_* |
| SDLCFeasibilityAgent | (genera feasibility_report.md - no template) |
| SDLCDesignAgent | plantilla_sad, plantilla_srs (como base) |
| SDLCTestingAgent | plantilla_plan_pruebas, plantilla_caso_prueba |
| SDLCDeploymentAgent | plantilla_deployment_guide, plantilla_release_plan |
| SDLCOrchestratorAgent | (orquesta todos los anteriores) |

### 6.4 De Checklist a Procedimientos

| Checklist | Procedimientos Relacionados |
|-----------|----------------------------|
| checklist_desarrollo | procedimiento_desarrollo_local, guia_completa_desarrollo_features |
| checklist_testing | procedimiento_qa |
| checklist_trazabilidad_requisitos | procedimiento_trazabilidad_requisitos |
| checklist_cambios_documentales | procedimiento_revision_documental, procedimiento_gestion_cambios |

### 6.5 Indice Rapido: "Estoy en X, que debo usar"

**Situacion 1: "Voy a implementar una nueva feature"**
```
├─> Procedimiento: guia_completa_desarrollo_features.md
├─> Templates:
│   ├─> template_necesidad.md (BA define primero)
│   ├─> plantilla_django_app.md (desarrollo)
│   └─> plantilla_tdd.md (tests)
├─> Checklists:
│   ├─> checklist_trazabilidad_requisitos.md (BA)
│   └─> checklist_desarrollo.md (Developer)
├─> Workflows: backend-ci.yml, test-pyramid.yml (automatico)
└─> Agentes: Todos (orchestrator coordina)
```

**Situacion 2: "Voy a hacer un deployment a production"**
```
├─> Procedimiento: procedimiento_release.md
├─> Templates:
│   ├─> plantilla_release_plan.md
│   └─> plantilla_deployment_guide.md
├─> Runbooks:
│   ├─> verificar_servicios.md (pre/post)
│   └─> merge_y_limpieza_ramas.md (post)
├─> Workflows: deploy.yml, migrations.yml (automatico)
└─> Agentes: SDLCDeploymentAgent
```

**Situacion 3: "Hubo un incidente en production"**
```
├─> Workflow: incident-response.yml (automatico)
├─> Runbooks:
│   ├─> verificar_servicios.md (diagnostico)
│   ├─> reprocesar_etl_fallido.md (si ETL)
│   └─> (runbook especifico del servicio)
├─> Template: plantilla_troubleshooting.md (post-mortem)
└─> Agentes: SDLCOrchestratorAgent (coordina respuesta)
```

**Situacion 4: "Necesito escribir tests"**
```
├─> Procedimiento: procedimiento_qa.md
├─> Templates:
│   ├─> plantilla_plan_pruebas.md
│   ├─> plantilla_caso_prueba.md
│   └─> plantilla_tdd.md
├─> Checklist: checklist_testing.md
├─> Workflow: test-pyramid.yml (automatico)
└─> Agentes: SDLCTestingAgent
```

**Situacion 5: "Voy a disenar una nueva arquitectura"**
```
├─> Procedimiento: procedimiento_diseno_tecnico.md
├─> Templates:
│   ├─> plantilla_sad.md (HLD)
│   ├─> plantilla_srs.md (LLD)
│   ├─> plantilla_database_design.md (DB)
│   └─> plantilla_caso_de_uso.md
├─> Agentes: SDLCDesignAgent
└─> Workflows: (ninguno - fase de diseno)
```

### 6.6 Automatizacion: Sistema de Consulta Programatica

Para facilitar la consulta automatica de asociaciones entre workflows, templates, procedimientos y agentes, se ha implementado un sistema de consulta programatica.

#### Archivos del Sistema

**1. Configuracion JSON: `.claude/workflow_template_mapping.json`**

Archivo de configuracion centralizado que contiene:

- **mappings**: Mapeo forward de workflows a templates, procedimientos, scripts, agentes
- **reverse_mappings**: Mapeo inverso para consultas rapidas
  - by_template: template -> workflows
  - by_procedimiento: procedimiento -> workflows
  - by_agente: agente -> workflows
  - by_fase_sdlc: fase -> workflows
- **template_metadata**: Metadata de cada template (categoria, prioridad, fase_sdlc, workflows_requeridos)
- **workflow_generation_rules**: Reglas de cuando usar cada template/workflow

**2. Script de Consulta: `scripts/generate_workflow_from_template.py`**

Script Python para consultar y validar asociaciones.

**Funcionalidades:**
- Listar todos los mapeos disponibles
- Consultar workflows asociados a un template
- Consultar templates asociados a un workflow
- Sugerir workflow basado en path de archivo
- Validar integridad de todos los mapeos
- Modo interactivo para exploracion

#### Como Usar

**Ejemplo 1: Listar todos los mapeos**
```bash
python scripts/generate_workflow_from_template.py --list-mappings
```

Output:
```
MAPEOS DISPONIBLES: TEMPLATE -> WORKFLOW
================================================================================

Template: plantilla_django_app.md
  Workflows: backend-ci
  Fase SDLC: development
  Categoria: desarrollo
  Genera: Django app en api/callcentersite/apps/
```

**Ejemplo 2: Consultar workflows para un template**
```bash
python scripts/generate_workflow_from_template.py --template plantilla_django_app.md
```

Output:
```
Workflows para template 'plantilla_django_app.md':
  - backend-ci.yml
    Validaciones: RNF-002, tests, coverage>=80, lint
```

**Ejemplo 3: Consultar templates para un workflow**
```bash
python scripts/generate_workflow_from_template.py --workflow backend-ci
```

Output:
```
Templates para workflow 'backend-ci':
  - plantilla_django_app.md
  - plantilla_etl_job.md
  - plantilla_tdd.md
```

**Ejemplo 4: Sugerir workflow basado en archivo**
```bash
python scripts/generate_workflow_from_template.py --file api/callcentersite/apps/myapp/models.py
```

Output:
```
Archivo: api/callcentersite/apps/myapp/models.py
Workflows sugeridos:
  - backend-ci.yml
    Validaciones: RNF-002, tests, coverage>=80, lint
    Templates relacionados: plantilla_django_app.md, plantilla_etl_job.md, plantilla_tdd.md
```

**Ejemplo 5: Validar todos los mapeos**
```bash
python scripts/generate_workflow_from_template.py --validate
```

Output:
```
VALIDANDO MAPEOS
================================================================================
[OK] Todos los mapeos son validos
```

**Ejemplo 6: Modo interactivo**
```bash
python scripts/generate_workflow_from_template.py --interactive
```

Output:
```
MODO INTERACTIVO - Consulta de Mapeos
================================================================================

Comandos:
  template <nombre>    - Buscar workflows para un template
  workflow <nombre>    - Buscar templates para un workflow
  procedimiento <nombre> - Buscar info de procedimiento
  file <path>          - Sugerir workflow para archivo
  list                 - Listar todos los mapeos
  quit                 - Salir

>>> template plantilla_tdd
Workflows para 'plantilla_tdd': backend-ci, test-pyramid

>>> quit
```

#### Integracion en Flujo de Trabajo

**Caso de Uso 1: Developer crea nueva Django app**
```bash
# 1. Consultar template a usar
python scripts/generate_workflow_from_template.py --template plantilla_django_app

# Output: backend-ci.yml se ejecutara al push

# 2. Crear app usando template
cp docs/plantillas/plantilla_django_app.md api/callcentersite/apps/myapp/design.md

# 3. Desarrollar app siguiendo plantilla
# ...

# 4. Push a repo
git add . && git commit -m "feat: nueva app myapp" && git push

# 5. Workflow backend-ci.yml se ejecuta automaticamente
# Valida: RNF-002, tests, coverage>=80, lint
```

**Caso de Uso 2: BA identifica archivo sin workflow asociado**
```bash
# Consultar si archivo tiene workflow
python scripts/generate_workflow_from_template.py --file docs/nuevo_documento.md

# Si no hay sugerencia -> consultar Tech Lead
# Si hay sugerencia -> verificar que workflow existe
```

**Caso de Uso 3: Validar integridad antes de deployment**
```bash
# En CI/CD pipeline
python scripts/generate_workflow_from_template.py --validate

# Si falla -> bloquear deployment
# Si OK -> continuar con deployment
```

#### Mantenimiento del Sistema

**Cuando actualizar `.claude/workflow_template_mapping.json`:**

1. **Nuevo workflow creado**: Agregar entrada en `mappings` con templates, procedimientos, scripts
2. **Nuevo template creado**: Agregar a workflow existente + actualizar `reverse_mappings.by_template`
3. **Nuevo procedimiento**: Agregar a workflow + actualizar `reverse_mappings.by_procedimiento`
4. **Cambio en asociacion**: Actualizar ambos forward y reverse mappings

**Validar cambios:**
```bash
# Despues de modificar JSON
python scripts/generate_workflow_from_template.py --validate

# Si hay errores, corregir antes de commit
```

**Commit de cambios:**
```bash
git add .claude/workflow_template_mapping.json
git commit -m "docs(mapeo): actualizar asociaciones workflow-template"
git push
```

#### Referencias

- **Configuracion**: `.claude/workflow_template_mapping.json`
- **Script**: `scripts/generate_workflow_from_template.py`
- **Documentacion**: Este documento (seccion 6.6)

---

## 7. Metricas y Validacion

### 7.1 Como Validar que Estoy Usando Correctamente

**Checklist de Auto-Validacion:**

- [ ] He consultado este documento MAPEO antes de empezar
- [ ] Identifique la fase SDLC en la que estoy
- [ ] Seleccione el procedimiento correcto para mi fase
- [ ] Use el template correcto para el artefacto que necesito
- [ ] Valide con el checklist correspondiente
- [ ] Confirme que el workflow automatico se ejecuto (si aplica)
- [ ] Revise que el agente SDLC genero la documentacion esperada (si aplica)

**Señales de que algo esta mal:**

- [ ] No se cual template usar
- [ ] El workflow CI/CD fallo y no se por que
- [ ] No hay procedimiento que describa lo que estoy haciendo
- [ ] El agente SDLC no genero lo que esperaba
- [ ] No se como validar que lo hice correctamente

**Accion:** Si alguna señal esta presente, consultar este documento o preguntar al Tech Lead.

---

## 8. Actualizaciones y Mantenimiento

**Responsable:** Equipo Gobernanza

**Cuando actualizar este documento:**
- Al agregar nuevos procedimientos
- Al crear nuevos templates
- Al implementar nuevos workflows CI/CD
- Al modificar agentes SDLC
- Al identificar nuevos flujos end-to-end
- Cambios en la estructura SDLC

**Proceso de actualizacion:**
1. Actualizar secciones relevantes
2. Validar mapeos y referencias cruzadas
3. Actualizar version en metadata
4. Commit: `docs(mapeo): actualizar MAPEO_PROCESOS_TEMPLATES.md - <descripcion>`
5. Notificar al equipo

---

## 9. Recursos Adicionales

**Documentos Relacionados:**
- [INDICE.md](../../INDICE.md) - Indice general de documentacion
- [AGENTES_SDLC.md](AGENTES_SDLC.md) - Documentacion completa de agentes
- [procedimientos/README.md](procedimientos/README.md) - Indice de procedimientos
- [../ci_cd/INDICE.md](../ci_cd/INDICE.md) - Indice de workflows CI/CD
- [../../plantillas/README.md](../../plantillas/README.md) - Indice de plantillas

**Workflows CI/CD:**
- `.github/workflows/backend-ci.yml`
- `.github/workflows/frontend-ci.yml`
- `.github/workflows/test-pyramid.yml`
- `.github/workflows/deploy.yml`
- `.github/workflows/migrations.yml`
- `.github/workflows/security-scan.yml`
- `.github/workflows/incident-response.yml`
- `.github/workflows/infrastructure-ci.yml`

**Scripts Locales:**
- `scripts/ci/backend_test.sh`
- `scripts/ci/frontend_test.sh`
- `scripts/ci/test_pyramid_check.sh`
- `scripts/ci/security_scan.sh`

**Agentes SDLC:**
- `scripts/ai/agents/sdlc_planner.py`
- `scripts/ai/agents/sdlc_feasibility.py`
- `scripts/ai/agents/sdlc_design.py`
- `scripts/ai/agents/sdlc_testing.py`
- `scripts/ai/agents/sdlc_deployment.py`
- `scripts/ai/agents/sdlc_orchestrator.py`

---

## Changelog

| Version | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.1.0 | 2025-11-06 | Agregada seccion 6.6: Sistema de consulta programatica workflow-template | Equipo Gobernanza |
| 1.0.0 | 2025-11-06 | Creacion inicial del documento de mapeo completo | Equipo Gobernanza |

---

**FIN DEL DOCUMENTO**

**Para navegar:** Usa Ctrl+F para buscar procedimientos, templates, o workflows especificos.
**Para preguntas:** Consultar al Tech Lead o Equipo Gobernanza.
