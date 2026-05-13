```yml
created_at: 2026-04-30 06:15:00
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 5 — STRATEGY
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Mapeo definitivo: ubicación canónica por tipo de archivo

> Análisis exhaustivo de la estructura `source/` para determinar
> dónde va cada nueva categoría de archivo. **Hallazgo clave:** la
> mayoría de los `.md` referenciados YA están migrados con
> kebab-lowercase. Solo unos pocos requieren creación nueva.

## Estructura completa de source/ (línea base)

| Carpeta | # archivos | Categoría dominante |
|---------|------------|---------------------|
| `arquitectura-tecnica/modulos/` | 9 | Módulos arquitectónicos `arq-mod-*` |
| `arquitectura-tecnica/rbac/` | 3 | Modelo + RACI + ADR RBAC |
| `backend/` | 9 | ADRs `adr-back-*` |
| `base-cognitiva/_fundamentos-conceptuales/` | 9 | `fnd-*` |
| `base-cognitiva/_metadata/` | 6 | `meta-*` |
| `base-cognitiva/_ontologia-sbvr/` | 6 | `sbvr-*` |
| `base-cognitiva/_taxonomias-y-metamodelos/` | 8 | taxonomías + metamodelos |
| `base-cognitiva/_ejemplos-pedagogicos/` | 16 | NUEVA — saga dark-mode |
| `databases/` | 3 | ADRs DB |
| `devops/` | 3 + 3 runbooks | ADRs devops + runbooks |
| `frontend/` | 8 | ADRs `adr-front-*` |
| `gestion/` | 3 + subcarpetas | git-workflow, plantilla-adr, evidencia, manuales-usuarios, pm |
| `gestion/pm/checklists/` | 7 | `checklist-*` |
| `normativa/estandares/` | 10 | `std-*`, estandares-codigo, guia-estilo |
| `normativa/estandares/plantillas/` | 29 | `tpl-*` |
| `normativa/gobernanza/` | 10 | ADRs `adr-gob-*` |
| `normativa/procedimientos/` | 74 | `proc-*` |
| `normativa/restricciones/` | 34 | `cnst-*` |
| `onboarding/` | 4 | docs onboarding |
| `plantuml-guide/` | 4 + 4 ejemplos | guía + ejemplos UML |
| `quality/` | 4 | estrategia testing, framework calidad, ADR-QA |
| `requisitos/casos-uso/` | 70 (8 módulos) | `uc-{módulo}-NN-*` |
| `requisitos/reglas-negocio/` | 20 | `br-NNN-*` |
| `requisitos/requisitos-funcionales/` | 50 | `fr-*` por UC |
| `requisitos/requisitos-no-funcionales/` | 3 | `rnf-*` |
| `risks-technical-debt/` | 3 | riesgos + deuda |

## Mapeo de tipos de archivo a su carpeta canónica

### 1. ADRs (Architecture Decision Records)

| Dominio | Carpeta canónica | Naming |
|---------|------------------|--------|
| Backend | `source/backend/` | `adr-back-NNN-{tema}.rst` |
| Frontend | `source/frontend/` | `adr-front-NNN-{tema}.rst` |
| Databases | `source/databases/` | `adr-db-NNN-{tema}.rst` |
| DevOps | `source/devops/` | `adr-devops-NNN-{tema}.rst` |
| QA | `source/quality/` | `adr-qa-NNN-{tema}.rst` |
| Gobernanza (transversal) | `source/normativa/gobernanza/` | `adr-gob-NNN-{tema}.rst` |
| RBAC (estructural) | `source/arquitectura-tecnica/rbac/` | `adr-rbac-NNN-{tema}.rst` |

**Regla:** ADR vive donde su decisión tiene impacto primario. Si la
decisión es transversal a múltiples dominios, va en `gobernanza/`.

### 2. Casos de Uso (UC)

`source/requisitos/casos-uso/{modulo}/uc-{modulo-prefix}-NN-{descripcion}.rst`

Módulos existentes: `auth`, `users`, `access`, `permissions`, `pipeline`,
`reports`, `alerts`, `audit`, `logs`.

**Naming pattern:** prefijo del módulo en español, número de 2 dígitos:
- `uc-auth-01-iniciar-sesion.rst`
- `uc-rpt-04-exportar-reporte.rst`

### 3. Requisitos Funcionales (FR)

`source/requisitos/requisitos-funcionales/{modulo}/{uc-id}/fr-{uc-id}-NN-{descripcion}.rst`

**Patrón jerárquico:** RF se anida bajo UC al que pertenece. Ej:
- `requisitos-funcionales/auth/uc-001-iniciar-sesion/fr-001-01-validar-credenciales.rst`

### 4. Requisitos No Funcionales (RNF)

`source/requisitos/requisitos-no-funcionales/rnf-{categoria}-NNN-{descripcion}.rst`

Categorías observadas: `proc`, etc.

### 5. Reglas de Negocio (BR)

`source/requisitos/reglas-negocio/br-NNN-{descripcion}.rst`

20 BRs ya existentes con esta convención.

### 6. Constraints (CNST)

`source/normativa/restricciones/cnst-NNN-{descripcion}.rst`

34 CNSTs con esta convención.

### 7. Estándares (STD)

`source/normativa/estandares/std-NNN-{descripcion}.rst`

Plus archivos sin numeración para guías generales:
- `estandares-codigo.rst`
- `guia-estilo.rst`
- `shell-scripting-guide.rst`

### 8. Plantillas / Templates

`source/normativa/estandares/plantillas/tpl-{tipo}-{descripcion}.rst`

29 plantillas existentes con prefijo `tpl-`. Tipos:
- `tpl-adr-`, `tpl-api-`, `tpl-br-`, `tpl-breq-`, `tpl-cnst-`,
  `tpl-fd-`, `tpl-fr-`, `tpl-mod-`, `tpl-nfr-`, `tpl-pol-`,
  `tpl-proc-`, `tpl-std-`, `tpl-trz-`, `tpl-tst-`, `tpl-uc-*`,
  `tpl-view-`.

**No mover plantillas a otra carpeta** — la convención es estable.

### 9. Procedimientos

`source/normativa/procedimientos/proc-{categoria}-NNN-{descripcion}.rst`

Categorías existentes: `gob`, `qa`, `dev`, `devops`, `doc`, `req`, `ops`.

74 procedimientos ya migrados con esta convención.

### 10. Checklists

`source/gestion/pm/checklists/checklist-{descripcion}.rst`

7 checklists ya migrados:
- `checklist-cambios-documentales.rst`
- `checklist-desarrollo.rst`
- `checklist-testing.rst`
- `checklist-trazabilidad-requisitos.rst`
- `checklists-pm.rst` (índice)
- `checklists-backend.rst` (índice por dominio)

### 11. Runbooks

`source/devops/runbooks/runbook-{descripcion}.rst`

Carpeta nueva creada en este WP. 2 runbooks creados:
- `runbook-verificar-servicios.rst`
- `runbook-reprocesar-etl-fallido.rst`

### 12. Ejemplos pedagógicos (sagas)

`source/base-cognitiva/_ejemplos-pedagogicos/ejemplo-{nombre}/`

Carpeta nueva creada en este WP. 1 saga: dark-mode (15 archivos).

### 13. Catálogos

**Propuesta nueva:** `source/arquitectura-tecnica/catalogos/catalogo-{tipo}.rst`

NO existen aún. Para refs `CATALOGO_*.md` que requieran creación.

### 14. Matrices

**Propuesta:** `source/gestion/pm/matrices/matriz-{tipo}.rst` (nueva
carpeta).

Aprovechando que `gestion/pm/` ya tiene `checklists/`, la simetría
sugiere `gestion/pm/matrices/`.

### 15. Guías técnicas

**Patrón observado:** las guías viven cerca del dominio:
- `normativa/estandares/guia-estilo.rst` — guía de estilo documental
- `normativa/estandares/shell-scripting-guide.rst` — guía técnica shell
- `plantuml-guide/` — guía de PlantUML

**Para nuevas guías técnicas:**
- Si es transversal/normativa → `normativa/estandares/guia-{tema}.rst`
- Si es específica de tech stack → `{dominio}/guia-{tema}.rst`

### 16. Reportes / Análisis históricos

NO importar a source. Viven en `temp-holding/` o `.thyrox/context/work/`.

### 17. README / INDICE / CHANGELOG del repo

NO importar a source. Viven en raíz del repo. Cuando referenciados
en source, usar URL absoluta a GitHub o texto plano descriptivo.

### 18. Reportes de proceso (efímeros)

Como `feasibility_report_dark_mode.md`, `Notas_Entrevista_Maria.md`,
`REPORTE_*.md`, `TASK-*.md`. Si forman parte de saga pedagógica →
incluir en la saga. Si son artefactos privados → NO crear.

## Aplicación a refs `.md` aún no resueltas

### Hallazgo: la mayoría YA tienen destino canónico

| Ref histórica `.md` | Estado | Destino canónico existente |
|---------------------|--------|------------------------------|
| `checklist_desarrollo.md` | ✓ existe | `gestion/pm/checklists/checklist-desarrollo.rst` |
| `checklist_testing.md` | ✓ existe | `gestion/pm/checklists/checklist-testing.rst` |
| `checklist_trazabilidad_requisitos.md` | ✓ existe | `gestion/pm/checklists/checklist-trazabilidad-requisitos.rst` |
| `checklist_cambios_documentales.md` | ✓ existe | `gestion/pm/checklists/checklist-cambios-documentales.rst` |
| `plantilla_adr.md` | ✓ existe | `gestion/plantilla-adr.rst` o `normativa/estandares/plantillas/tpl-adr-decisiones-arquitectonicas.rst` |
| `template_necesidad.md` | ✓ existe | `normativa/estandares/plantillas/tpl-breq-objetivos-negocio.rst` |
| `template_requisito_funcional.md` | ✓ existe | `normativa/estandares/plantillas/tpl-fr-requisitos-funcionales.rst` |
| `template_requisito_negocio.md` | ✓ existe | `normativa/estandares/plantillas/tpl-br-business-rules.rst` |
| `template_requisito_no_funcional.md` | ✓ existe | `normativa/estandares/plantillas/tpl-nfr-no-funcionales.rst` |
| `plantilla_caso_de_uso.md` | ✓ existe | `normativa/estandares/plantillas/tpl-uc-casos-de-uso.rst` |
| `plantilla_caso_prueba.md` | ✓ existe | `normativa/estandares/plantillas/tpl-tst-pruebas.rst` (parcial) |
| `plantilla_plan_pruebas.md` | ✓ existe | `normativa/estandares/plantillas/tpl-tst-pruebas.rst` |
| `plantilla_sad.md` | parcial | (no hay `tpl-sad-*` específico, mapea a tpl-mod) |
| `plantilla_srs.md` | parcial | (no hay `tpl-srs-*`) |
| `plantilla_database_design.md` | parcial | (no hay tpl específico) |
| `plantilla_release_plan.md` | ✗ no existe | crear `tpl-release-plan-release-management.rst` |
| `plantilla_deployment_guide.md` | parcial | (no hay tpl específico) |
| `plantilla_api_reference.md` | ✓ existe | `normativa/estandares/plantillas/tpl-api-documentacion-api.rst` |
| `plantilla_troubleshooting.md` | ✗ no existe | crear `tpl-troubleshooting-runbook.rst` |
| `plantilla_django_app.md` | ✗ no existe | si aplica, crear en `backend/` o `normativa/estandares/plantillas/` |
| `plantilla_tdd.md` | ✗ no existe (proc-gob-009 cubre tema) | mantener como referencia a proc existente |

### Archivos genuinamente faltantes a crear

Tras este análisis, los archivos NUEVOS a crear son **muy pocos**:

| Archivo a crear | Carpeta destino | Justificación |
|----------------|-----------------|---------------|
| `tpl-release-plan-release-management.rst` | `normativa/estandares/plantillas/` | Plantilla referenciada 5+ veces |
| `tpl-troubleshooting-runbook.rst` | `normativa/estandares/plantillas/` | Plantilla referenciada 3+ veces |
| `tpl-sad-arquitectura-software.rst` | `normativa/estandares/plantillas/` | Plantilla SAD referenciada |
| `tpl-srs-software-requirements-spec.rst` | `normativa/estandares/plantillas/` | Plantilla SRS referenciada |
| `tpl-deployment-guide-deployment.rst` | `normativa/estandares/plantillas/` | Plantilla deployment referenciada |
| Posibles ADRs faltantes (revisar caso por caso) | `{dominio}/adr-*-NNN-*.rst` | Solo si tema no cubierto |

### Archivos NO crear (mapean a existente o no aplican)

- Todos los `procedimiento_*.md` → ya existen como `proc-*-*.rst`
- Todos los `checklist_*.md` → ya existen como `checklist-*.rst`
- La mayoría de `template_*.md` / `plantilla_*.md` → ya existen como `tpl-*.rst`
- Todos los `UC-BACK-*.md`, `UC-FRONT-*.md` → ejemplos pedagógicos en
  procesos, mapear conceptualmente a saga dark-mode existente
- `BN-*.md`, `RF-*.md`, `RN-*.md`, `HLD-*.md`, `LLD-*.md`, etc.
  específicos a "dark-mode", "stock", "autenticación" → ejemplos
  pedagógicos. La saga dark-mode los cubre conceptualmente.
- README, CHANGELOG, INDICE → externos al sitio
- Placeholders (`{dominio}`, `YYYYMMDD`, etc.) → literales backticks

## Plan de implementación residual

Tras este análisis, lo que queda hacer:

### Sprint 2 (refinamiento) — 8-12h

1. **Mapeo masivo de literales `.md` a `:doc:` refs existentes:**
   - 18 plantillas que ya existen pero se refieren como `.md`
   - 4 checklists que ya existen
   - Todos los procedimientos ya mapeados en Sprint 1

2. **Creación de 5 plantillas faltantes:**
   - tpl-release-plan
   - tpl-troubleshooting
   - tpl-sad
   - tpl-srs
   - tpl-deployment-guide

3. **Convertir literales pedagógicos** (BN-001-dark-mode.md
   dentro de blockes ::) a backticks o referencias a la saga
   dark-mode ya creada.

### Sprint 3 (cierre) — 2-3h

- Build con nitpicky.
- Update STD-007 con regla "NO refs .md en source/".
- Validador en CI/pre-commit.

## Decisiones para el ejecutor

1. ¿Apruebas crear las **5 plantillas faltantes**
   (release-plan, troubleshooting, sad, srs, deployment-guide)
   en `normativa/estandares/plantillas/`?
2. ¿Los conceptos pedagógicos `BN-001-dark-mode.md` etc. dentro
   de bloques `::` se mantienen como literales (formato
   tutorial) o se actualizan a `:doc:` a la saga?
3. ¿Crear las 2 carpetas faltantes (`gestion/pm/matrices/`,
   `arquitectura-tecnica/catalogos/`) si surge necesidad real,
   o esperar primer caso de uso?
4. ¿Empezamos Sprint 2 (mapeo masivo de plantillas existentes)
   ahora?
