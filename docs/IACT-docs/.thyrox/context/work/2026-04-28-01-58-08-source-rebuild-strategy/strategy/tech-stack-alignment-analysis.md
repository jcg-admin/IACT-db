```yml
created_at: 2026-04-28 04:50:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 5 — STRATEGY (re-evaluación post tech-stack)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis de alineación con stack técnico real de IACT

## 0. Re-framing del ejecutor (2026-04-28)

> "Debes pensar que la documentación que se está haciendo es para
> un proyecto de software que tiene frontend (React, Webpack),
> backend (Django REST Framework), infraestructura (Ubuntu,
> Apache), database (MySQL y PostgreSQL)."

Este re-framing **invalida parcialmente** el análisis previo
`iact-docs-v2-applicability-analysis.md` que recomendaba descartar
la mayor parte del modelo "12 cajones" de v2.0. Con la información
de que IACT-docs documenta un **proyecto de software multi-tier**,
los cajones técnicos (backend, frontend, infrastructure, operations)
**sí aplican** y son necesarios.

## 1. Stack técnico verificado vs. estructura actual de source/

### 1.1 Stack real (declarado por ejecutor)

| Capa | Tecnología |
|------|------------|
| Frontend | React + Webpack |
| Backend | Django REST Framework (DRF) |
| Infraestructura | Ubuntu + Apache |
| Bases de datos | MySQL + PostgreSQL |

### 1.2 Cobertura actual en source/ (verificado)

| Capa | ¿Tiene cajón propio? | Dónde está documentado |
|------|----------------------|-------------------------|
| Frontend | **NO** | Disperso: `normativa/gobernanza/ADR-FRONT-*.rst`, `normativa/gobernanza/Gobernanza del Frontend-README.rst`, `gestion/pm/Planificación y releases del frontend-README.rst`, `normativa/procedimientos/Procedimientos - frontend-README.rst` |
| Backend (DRF) | **NO** | Disperso: `normativa/procedimientos/Deployment del Backend IACT- README.rst`, ADRs en `normativa/gobernanza/` |
| Infraestructura | **NO** | Disperso: `normativa/restricciones/CNST_008_Infraestructura_Deployment.rst`, ADRs `ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC.rst`, `ADR-DEVOPS-003-wasi-style-virtualization--IMPORTANTE-DB.rst` |
| Databases | **NO** | Sin sección dedicada; CNST_003 (Base_Datos_Dual_Inmutable) toca el tema desde restricciones |
| Operations / Deployment | **NO** | Disperso: `normativa/procedimientos/PROC-OPS-001-deployment.rst`, `PROCED-DEVOPS-001-deploy_staging.rst`, `PROC-DEVOPS-001-devops_automation.rst`, `PROC-OPS-002-setup-entorno-desarrollo.rst`, `gestion/pm/deployment_plan.rst` |
| Testing / QA | (parcial) | Implícito en algunos PROC y FR |
| Onboarding (dev) | **NO** | Sin cajón dedicado (esto es lo que el WP `bootstrap-hardening` empezó a abordar para el repo de docs, pero NO existe para el producto IACT) |

**Conclusión:** el stack técnico está **completamente disperso**.
Un dev de backend que quiera entender DRF en IACT tiene que buscar
en 3+ dominios. Un dev de frontend tiene que abrir `normativa/`,
`gestion/` y `arquitectura_tecnica/` para reconstruir el cuadro.

## 2. Hallazgo adicional — mismatch de tech-skill registrado

`.thyrox/guidelines/` declara las siguientes guidelines activas
(cargadas en CLAUDE.md como `@imports`):

```
backend-nodejs.instructions.md     ← MISMATCH: el backend real es Django (Python)
db-mysql.instructions.md            ← OK
db-postgresql.instructions.md       ← OK
frontend-react.instructions.md      ← OK
frontend-webpack.instructions.md    ← OK
python-mcp.instructions.md          ← OK (server MCP)
agentic-python.instructions.md      ← OK (Python agentic)
```

**F-NEW-8:** la guideline `backend-nodejs` está activa siendo que
el stack es Django REST Framework. Toda sugerencia de Claude sobre
backend hereda convenciones Node.js incorrectas (Express middleware,
package.json, npm scripts) en vez de Django (urls.py, viewsets,
serializers, requirements.txt o pyproject, manage.py).

**Acción requerida:** generar `backend-django.instructions.md` y
desactivar `backend-nodejs`. Esto vive fuera del WP de rebuild
de source/ — abordar en spinoff WP o como parte de `bootstrap-
hardening`.

## 3. Re-evaluación del modelo "12 cajones" v2.0

### 3.1 Mapeo de cajones v2.0 a IACT real

| Cajón v2.0 | Aplica a IACT (proyecto SW) | Cobertura actual en source/ | Recomendación |
|------------|------------------------------|------------------------------|----------------|
| **specifications/** (UCs, FRs, NFRs, BRs, AC) | SÍ — IACT tiene UCs, FRs, BRs, NFRs | `requisitos/` (158 archivos) | Mantener `requisitos/` con su nombre actual |
| **planning/** (project plan, sprints, risks, milestones) | SÍ | `gestion/pm/` parcial | Reorganizar dentro de `gestion/` o renombrar |
| **architecture/** (system overview, components, design, decisions) | SÍ | `arquitectura_tecnica/` (15 archivos) | Mantener; expandir |
| **backend/** | **SÍ — DRF** | DISPERSO | **AGREGAR cajón nuevo** `source/backend/` |
| **frontend/** | **SÍ — React + Webpack** | DISPERSO | **AGREGAR cajón nuevo** `source/frontend/` |
| **infrastructure/** | **SÍ — Ubuntu + Apache** | DISPERSO | **AGREGAR cajón nuevo** `source/infrastructure/` |
| **databases/** (no en v2.0 explícito, pero implícito) | **SÍ — MySQL + PostgreSQL** | DISPERSO | **AGREGAR cajón nuevo** `source/databases/` |
| **operations/** (deployment, monitoring, runbooks) | SÍ | DISPERSO en `normativa/procedimientos/` | **AGREGAR cajón nuevo** `source/operations/` |
| **onboarding/** (dev quickstart) | SÍ | NO existe | **AGREGAR cajón nuevo** `source/onboarding/` |
| **quality-scenarios/** (testing strategy, coverage) | SÍ | Parcial | **AGREGAR cajón nuevo** `source/quality/` |
| **risks-technical-debt/** | SÍ | NO existe en source/ (sí en `.thyrox/`) | **AGREGAR cajón nuevo** `source/risks-technical-debt/` |
| **crosscutting-concepts/** | SÍ | `base_cognitiva/` cubre conceptos | Mantener `base_cognitiva/` o renombrar |
| **glossary/** | SÍ | `base_cognitiva/IACT_Glossary*` cubre glosario | Mantener |

### 3.2 Mapeo de dominios actuales que NO están en v2.0

| Dominio actual | ¿Equivalente en v2.0? | Recomendación |
|----------------|------------------------|----------------|
| `normativa/` (estandares, procedimientos, restricciones, gobernanza) | Parcial: v2.0 lo divide en `policies/` (corp) + `procedures/` (corp) + governance dispersa | Mantener `normativa/` — es project-internal governance, no corp policies. Los STDs (STD_007, etc.) son standards específicos del proyecto IACT-docs. |
| `gestion/` | Parcial: v2.0 lo divide en `planning/` (PM) + `teams/` (corp HR) | Mantener `gestion/` con scope de PM del proyecto IACT, no corp HR. |

## 4. Estructura propuesta — modelo HÍBRIDO IACT

Combina dominios metodológicos (project-internal) con cajones
técnicos (implementation):

```
source/
  # ═══════════════════════════════════════════════════════════
  # CAPA METODOLÓGICA (existente — governance, spec, glossary)
  # ═══════════════════════════════════════════════════════════
  base_cognitiva/             # conceptos + glosario (= crosscutting + glossary v2.0)
  normativa/                  # governance del proyecto IACT
    estandares/               #   - STDs + plantillas
    procedimientos/           #   - PROCs (incluye los DEVOPS, OPS, etc — pueden migrar)
    restricciones/            #   - CNSTs
    gobernanza/               #   - ADRs + políticas internas
  requisitos/                 # specifications (UCs, FRs, NFRs, BRs)
  arquitectura_tecnica/       # architecture overview + decisions
  gestion/                    # project management (planning, releases)

  # ═══════════════════════════════════════════════════════════
  # CAPA TÉCNICA (NUEVA — implementación por tier)
  # ═══════════════════════════════════════════════════════════
  backend/                    # NEW: Django REST Framework
    overview.rst              #   - alcance, módulos, settings
    api/                      #   - endpoints, serializers, viewsets
    models/                   #   - modelos de datos
    auth/                     #   - autenticación, permisos
    integrations/             #   - servicios externos
    conventions.rst           #   - PEP 8, naming, organización
    troubleshooting.rst       #   - FAQ común
  frontend/                   # NEW: React + Webpack
    overview.rst
    components/               #   - components reutilizables
    state-management/         #   - Redux/Context/etc
    routing/
    styling/                  #   - CSS/SASS conventions
    build/                    #   - Webpack config explicado
    conventions.rst
    troubleshooting.rst
  infrastructure/             # NEW: Ubuntu + Apache
    overview.rst
    server-setup/             #   - Ubuntu configuración base
    apache/                   #   - vhost, mod_wsgi, mod_ssl
    networking/
    security/                 #   - firewall, hardening
    monitoring/               #   - logs, alertas
  databases/                  # NEW: MySQL + PostgreSQL
    overview.rst
    mysql/
      schema.rst
      conventions.rst
      backup-restore.rst
    postgresql/
      schema.rst
      conventions.rst
      backup-restore.rst
    migrations/               #   - Django migrations workflow
  operations/                 # NEW: deployment, runbooks, monitoring
    deployment/               #   - staging, production checklists
    monitoring/               #   - dashboards, alertas
    incident-response/        #   - runbooks por tipo de incidente
    backup-recovery/
  onboarding/                 # NEW: developer onboarding
    quickstart.rst            #   - clone → setup → run dev
    local-dev-setup.rst
    first-contribution.rst
    team-tooling.rst
  quality/                    # NEW: testing strategy
    test-strategy.rst
    unit-tests/
    integration-tests/
    e2e-tests/
    coverage/
  risks-technical-debt/       # NEW: tech debt log
    technical-debt.rst        #   - lista de TD con prioridad
    risks-register.rst        #   - riesgos técnicos abiertos

  # ═══════════════════════════════════════════════════════════
  # ASSETS Y SOPORTE (existente)
  # ═══════════════════════════════════════════════════════════
  _static/                    # Sphinx assets
  _templates/                 # Sphinx templates
  conf.py
  index.rst
```

## 5. Impacto sobre la strategy v1.2

### 5.1 Cambios al orden de WPs (de 8 a 16, o agrupados)

**Opción granular (16 WPs):**
1. base_cognitiva
2. normativa/estandares (STDs + templates)
3. normativa/procedimientos
4. normativa/restricciones
5. normativa/gobernanza
6. requisitos
7. arquitectura_tecnica
8. backend (NEW)
9. frontend (NEW)
10. infrastructure (NEW)
11. databases (NEW)
12. operations (NEW)
13. onboarding (NEW)
14. quality (NEW)
15. risks-technical-debt (NEW)
16. gestion

**Opción agrupada (10 WPs):**
1. base_cognitiva
2. normativa/estandares
3. normativa/procedimientos + restricciones (juntos por gobernanza temática) — o mantener restricciones separado
4. normativa/gobernanza
5. requisitos
6. arquitectura_tecnica
7. **tech-stack** (backend + frontend + databases combinados — un mega-WP)
8. **infrastructure-operations** (infrastructure + operations combinados)
9. **dev-experience** (onboarding + quality + risks-technical-debt combinados)
10. gestion

Decisión a tomar: granular (más control, más overhead) vs.
agrupado (menos overhead, menos granularidad).

### 5.2 Nuevas Ideas para strategy v1.3 / v2.0

- **Idea 10 (NEW):** IACT documenta un proyecto de software
  multi-tier — la estructura debe reflejar el stack técnico, no
  solo la metodología.
- **Idea 11 (NEW):** Dominios metodológicos (governance) y
  dominios técnicos (implementation) coexisten — son ortogonales.
  Los metodológicos definen reglas; los técnicos describen el
  cómo se implementa.

### 5.3 Nuevas Decisions

- **Decision 9 (NEW):** Estructura híbrida confirmada — agregar
  los 8 cajones técnicos (backend, frontend, infrastructure,
  databases, operations, onboarding, quality, risks-technical-
  debt) sin eliminar los dominios metodológicos.
- **Decision 10 (NEW):** Migración de contenido técnico disperso
  a sus cajones — los ADRs de frontend, deployment procs, etc.
  se mueven o referencian desde los nuevos cajones técnicos.
- **Decision 11 (NEW):** Tech-skill mismatch (F-NEW-8) — generar
  `backend-django.instructions.md` y desactivar `backend-nodejs`.
  Acción fuera del WP de rebuild de source/ (abordar en
  bootstrap-hardening WP o nuevo spinoff).
- **Decision 12 (NEW):** El v2.0 análisis previo
  (`iact-docs-v2-applicability-analysis.md`) se re-clasifica:
  los items "no aplican (multi-proyecto)" siguen sin aplicar,
  pero los "12 cajones" pasan de "descartar" a "adaptar" — son
  los cajones técnicos que ahora se incorporan.

## 6. Decisiones para el ejecutor

### D-TECH-1: ¿Estructura granular (16 WPs) o agrupada (10 WPs)?

- A) Granular: control fino, cada cajón es WP propio. Más overhead.
- B) Agrupada: tech-stack + infrastructure-operations + dev-experience como mega-WPs.
- C) Híbrida: backend, frontend, infrastructure y databases granulares (4 WPs); operations + onboarding + quality + risks como un mega-WP "dev-experience".

### D-TECH-2: ¿Migrar contenido técnico disperso o duplicar/linkear?

- A) Migrar: mover los ADRs de frontend de `normativa/gobernanza/` a `frontend/decisions/`. Limpia, pero rompe refs históricas.
- B) Linkear: dejar el ADR donde está y crear stub en `frontend/decisions/` que linkea. Menos limpio, refs intactas.
- C) Mixto: ADRs activos migran; ADRs históricos quedan donde están con índice consolidado.

### D-TECH-3: ¿Crear `databases/` como cajón propio o como sub-cajón de `backend/`?

- A) Propio (alineado con v2.0 split): IACT tiene 2 DBs distintas (MySQL + PostgreSQL) por razones específicas — merece sección propia.
- B) Sub-cajón de `backend/`: las DBs son consumidas por DRF; podría ser `backend/databases/`.

Recomendación: A.

### D-TECH-4: ¿Plan de retiro de la tech-skill incorrecta (backend-nodejs)?

- A) En este WP (alcance bootstrap): generar backend-django, deshabilitar backend-nodejs.
- B) En spinoff WP nuevo: `tech-stack-alignment` o ampliar `bootstrap-hardening`.

Recomendación: B (mantener scope del WP actual).

### D-TECH-5: ¿Profundidad de los nuevos cajones técnicos?

- A) Inicial mínima: solo `overview.rst` + `conventions.rst` por cajón. Expandir cuando haya contenido real.
- B) Estructura completa al inicio: todas las sub-secciones del modelo propuesto desde el primer WP.

Recomendación: A. Crear estructura mínima y dejar que cada
sub-WP de cajón técnico la expanda según contenido real.

## 6.bis Re-framing adicional del ejecutor (2026-04-28 04:55)

> "Es por eso que lo anterior se está como intranet, porque
> nosotros también documentamos los planes de trabajo, las
> épicas, etc."

Esto **completa el cuadro**: IACT-docs no es solo documentación
técnica del producto — también documenta el **ciclo de vida del
proyecto** (planes, épicas, sprints, releases, retrospectivas).
Por eso la propuesta v2.0 incluía `planning/`, `news/`,
`knowledge/`, etc. — porque cubre esa tercera dimensión.

### IACT-docs cubre TRES dimensiones (no dos)

| Dimensión | Qué cubre | Dónde está hoy |
|-----------|-----------|----------------|
| **1. Methodology / Governance** | Standards, procedures, restrictions, ADRs, plantillas | `normativa/` + `base_cognitiva/` |
| **2. Product spec + Tech implementation** | UCs, FRs, NFRs, architecture, backend, frontend, infra, db, ops | `requisitos/`, `arquitectura_tecnica/` (parcial); resto disperso o ausente |
| **3. Project lifecycle** | Charter, roadmap, OKRs, épicas, sprint plans, release notes, retros, team org | `gestion/` (parcial); resto en `.thyrox/context/work/` (no publicado) o `ROADMAP.md` (raíz) |

### Hallazgo crítico — el ciclo de vida vive FUERA de source/

Los work packages (épicas) viven en `.thyrox/context/work/YYYY-MM-DD-HH-MM-SS-*/`.
NO se publican como parte del sitio Sphinx. Esto significa:

- Un dev/stakeholder que consulta el sitio publicado **NO ve**
  qué épica está activa, qué WPs se han completado, cuáles son
  las decisiones tomadas en cada uno.
- ROADMAP.md vive en raíz del repo, fuera de `source/` — tampoco
  se publica.
- Los `track/{wp}-changelog.md` quedan dentro del WP pero no son
  visibles públicamente.

**Decisión a tomar:** ¿el ciclo de vida del proyecto (épicas,
WPs, decisiones) **debe ser parte del sitio publicado** o queda
como tooling interno fuera del sitio?

### Estructura propuesta v2.0 actualizada (3 capas)

```
source/
  # ═══════════════════════════════════════════════════════════
  # CAPA 1 — METHODOLOGY / GOVERNANCE
  # ═══════════════════════════════════════════════════════════
  base_cognitiva/             # crosscutting concepts + glossary
  normativa/
    estandares/               # STDs + plantillas
    procedimientos/           # PROCs operacionales
    restricciones/            # CNSTs
    gobernanza/               # ADRs + políticas internas

  # ═══════════════════════════════════════════════════════════
  # CAPA 2 — PRODUCT SPEC + TECH IMPLEMENTATION
  # ═══════════════════════════════════════════════════════════
  requisitos/                 # specifications (UCs, FRs, NFRs, BRs)
  arquitectura_tecnica/       # architecture overview + decisions
  backend/                    # NEW: Django REST Framework
  frontend/                   # NEW: React + Webpack
  infrastructure/             # NEW: Ubuntu + Apache
  databases/                  # NEW: MySQL + PostgreSQL
  operations/                 # NEW: deployment, monitoring, runbooks
  onboarding/                 # NEW: dev quickstart
  quality/                    # NEW: testing strategy
  risks-technical-debt/       # NEW: tech debt log

  # ═══════════════════════════════════════════════════════════
  # CAPA 3 — PROJECT LIFECYCLE (NEW DIMENSION)
  # ═══════════════════════════════════════════════════════════
  gestion/                    # existing — expandir
    charter/                  #   - charter del proyecto
    roadmap/                  #   - referencia o copia de ROADMAP.md
    okrs/                     #   - OKRs por trimestre
    epicas/                   # NEW — vista PUBLICADA de las ÉPICAs
                              #   - Cada ÉPICA tiene su archivo .rst que
                              #     resume: scope, decisiones clave,
                              #     resultados, link al WP en .thyrox/
    sprints/                  #   - sprint plans (si aplica)
    releases/                 # NEW — release notes técnicas
                              #   - Diferente de news/announcements;
                              #     son notas de versión técnicas
    retrospectives/           # NEW — lecciones aprendidas
    team/                     # NEW — organización, roles
  news/                       # NEW (opcional) — announcements al equipo
                              #   - Mensajes a stakeholders, no técnicos
                              #   - Decidir si es scope del producto
                              #     o solo de management
```

### Nueva Decision (D-TECH-6): ¿cómo se relaciona source/gestion/epicas/ con .thyrox/context/work/?

- A) **Espejo manual:** cada vez que se cierra un WP, se crea/actualiza
  un .rst en `gestion/epicas/` que resume el WP. Doble mantenimiento.
- B) **Generación automática:** script que lee `.thyrox/context/work/*/wp-state.md`
  y genera los .rst de `gestion/epicas/` en el build (extension Sphinx).
  Single source of truth, autogenerado.
- C) **Solo referencias:** `gestion/epicas/index.rst` lista las ÉPICAs
  con links externos al `.thyrox/` (no se renderiza el WP en el sitio).
  Mantiene scope, sin duplicación.
- D) **No publicar épicas:** las épicas son tooling interno; el sitio
  publicado solo documenta el producto y el proyecto a alto nivel
  (charter, roadmap, releases). Las épicas viven fuera.

Recomendación: **B** (generación automática) si hay capacidad para
implementar la extension Sphinx; **C** como fallback. **A** rechazada
(violaría I-002 — duplicación). **D** rechazada porque el ejecutor
explicitó que "documentamos los planes de trabajo, las épicas".

### Nueva Decision (D-TECH-7): ¿news/ y knowledge/ aplican?

- **news/**: si IACT tiene comunicación regular a stakeholders (releases,
  cambios, anuncios), sí. Si solo es comm interna del equipo dev,
  puede ir como `gestion/comunicaciones/` o vivir fuera del sitio.
- **knowledge/**: en v2.0 cubre how-to-guides, best-practices,
  lessons-learned, architecture-patterns, faqs. Para IACT:
  - how-to-guides → `onboarding/` y `operations/runbooks/`
  - best-practices → `normativa/estandares/` y conventions de cada
    cajón técnico
  - lessons-learned → `gestion/retrospectives/`
  - architecture-patterns → `arquitectura_tecnica/`
  - faqs → distribuir por dominio o un único `faqs.rst` top-level
  Conclusión: **knowledge/** se distribuye, NO se crea como cajón.

## 7. Próximos pasos

1. Ejecutor responde D-TECH-1..5.
2. Si confirma incorporación de cajones técnicos:
   - Bumpear strategy a **v2.0** (MAJOR — cambia la estructura
     macro de source/, no solo agrega ideas).
   - Reordenar/ampliar WPs según D-TECH-1.
3. Tech-skill fix (D-TECH-4) se resuelve en paralelo.
4. Phase 5 STRATEGY se cierra cuando v2.0 esté aprobada.
5. Phase 6 PLAN traduce los cambios a tareas ejecutables.

## 8. Evidencia de respaldo

| Claim | Tipo | Fuente | Confianza |
|-------|------|--------|-----------|
| source/ no tiene `backend/`, `frontend/`, `infrastructure/`, `databases/`, `operations/` como cajones top-level | PROVEN | `find source -maxdepth 1 -type d` → solo arquitectura_tecnica, base_cognitiva, gestion, normativa, plantuml-guide, requisitos, _static, _templates | alta |
| Contenido técnico está disperso en dominios metodológicos | PROVEN | 14+ archivos encontrados con grep en `normativa/gobernanza/`, `normativa/procedimientos/`, `gestion/pm/` referenciando frontend/backend/devops | alta |
| `backend-nodejs.instructions.md` activo siendo que stack es Django | PROVEN | `ls .thyrox/guidelines/` muestra `backend-nodejs.instructions.md` (no `backend-django`) | alta |
| Stack real: React+Webpack / DRF / Ubuntu+Apache / MySQL+PostgreSQL | TESTIMONIAL | Declaración del ejecutor 2026-04-28 | alta (testimonial directo) |
