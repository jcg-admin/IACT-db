# Metadata Standards — WP Documents

> Cargado automáticamente. Aplica a TODO documento creado en context/work/.

## Regla principal

TODOS los documentos en `.thyrox/context/work/` usan bloques \`\`\`yml\`\`\` para metadata.
NUNCA usar `---` YAML frontmatter en artefactos WP.

## Terminología oficial

| Término | Qué es | Ejemplo |
|---------|--------|---------|
| **Stage directory** | Directorio de primer nivel dentro del WP — delimita el espacio de artefactos de un stage THYROX | `analyze/`, `discover/`, `plan-execution/` |
| **Domain subdirectory** | Subdirectorio dentro de un stage directory — agrupa artefactos por eje temático cuando hay múltiples análisis | `analyze/coverage/`, `analyze/naming/`, `analyze/architecture-patterns/` |
| **Artifact** | Documento `.md` que vive dentro de la jerarquía | `analyze/coverage/audit-coverage-review.md` |

## Taxonomía de 3 niveles

```
{stage-directory}/{domain-subdirectory}/{content}-{subtype}.md
     └── discover/
              └── references/
                       └── references-relevance-review.md
     └── analyze/
              └── coverage/
                       ├── audit-coverage-review.md
                       └── task-plan-coverage-review.md
              └── naming/
                       └── naming-ishikawa.md
```

**Cuándo usar cada nivel:**

| Situación | Estructura correcta |
|-----------|---------------------|
| 1 síntesis obligatoria por fase | `{stage-dir}/{wp-name}-{tipo}.md` (prefijo WP identifica la síntesis) |
| ≤2 sub-análisis, dominio claro | Plano en el stage directory: `{stage-dir}/{content}-{subtype}.md` |
| ≥3 sub-análisis o múltiples dominios | Domain subdirectory: `{stage-dir}/{domain}/{content}-{subtype}.md` |

## Naming de artefactos en stage directories

**Principio:** el stage directory ya provee el tipo — el nombre del archivo describe solo el contenido.

```
CORRECTO:   analyze/use-cases-analysis.md          ← contenido
CORRECTO:   analyze/discover-to-diagnose-coverage.md  ← contenido-subtipo
PROHIBIDO:  analyze/deep-review-use-cases-analysis.md ← tipo-contenido (invertido)
PROHIBIDO:  analyze/final-validation-review.md        ← término temporal ("final")
```

**Patrón:** `{contenido-descriptivo}.md` o `{contenido}-{subtipo}.md`

El subtipo (review, coverage, analysis, ishikawa) va **al final**, nunca al principio.
Usar stage names en lugar de números: `discover-to-diagnose`, no `stage1-to-stage3`.
No usar términos temporales relativos: no "final", no "last", no "v2" en el nombre.

**Síntesis de fase (documento principal):** usa el prefijo del WP para distinguirla de los sub-análisis:
```
CORRECTO:   discover/goto-problem-fix-analysis.md       ← síntesis (prefijo WP)
CORRECTO:   analyze/goto-problem-fix-diagnose.md        ← síntesis (prefijo WP)
CORRECTO:   discover/use-cases-analysis.md              ← sub-análisis (sin prefijo WP)
```

**Problema del flat namespace collapse:** cuando un WP genera múltiples análisis desde diferentes
ejes temáticos, los nombres planos pierden contexto. Solución: domain subdirectories.

```
PROBLEMA (plano — ambiguo):          SOLUCIÓN (con dominio — claro):
analyze/                             analyze/
├── audit-coverage-review.md         ├── coverage/
├── task-plan-coverage-review.md     │   ├── audit-coverage-review.md
├── discover-to-plan-coverage.md     │   └── task-plan-coverage-review.md
└── naming-ishikawa.md               └── naming/
                                         └── naming-ishikawa.md
```

## Templates por tipo de documento

### 1. Artefactos principales del WP (en raíz del WP)

```yml
project: THYROX
work_package: YYYY-MM-DD-HH-MM-SS-nombre
created_at: YYYY-MM-DD HH:MM:SS
current_phase: Phase N — PHASE_NAME
author: NestorMonroy
```

*Ejemplos: risk-register.md, exit-conditions.md*
*`updated_at` SOLO en documentos vivos (risk-register, exit-conditions)*

### 2. Síntesis de fase (`discover/{wp-name}-analysis.md`)

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: THYROX
author: NestorMonroy
status: Borrador
version: 1.0.0
```

### 3. Documentos en stage directories (`{stage-dir}/{domain}/{nombre}.md`)

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: THYROX
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase N — PHASE_NAME
author: NestorMonroy
status: Borrador
```

*Ejemplos: analyze/coverage/audit-coverage-review.md*
*analyze/architecture-patterns/multi-flow-detection-analysis.md*

## Reglas de campos

| Campo | Obligatorio | Formato |
|-------|-------------|---------|
| `created_at` | Siempre | `YYYY-MM-DD HH:MM:SS` (timestamp real del sistema) |
| `updated_at` | Solo en doc. vivos | `YYYY-MM-DD HH:MM:SS` — actualizar en cada Edit |
| `status` | Siempre | `Borrador` al crear → `Aprobado` cuando gate lo valida |
| `project` | Siempre | Nombre del proyecto (THYROX para este repo) |
| `phase` | En stage directories | `Phase N — PHASE_NAME` (ej: `Phase 3 — ANALYZE`) |
| `author` | Siempre | Nombre del autor |
| `version` | En docs con revisiones | SemVer 2.0.0 (`MAJOR.MINOR.PATCH`) — ver regla abajo |

## Versionado de documentos — SemVer 2.0.0

Los documentos que evolucionan (reviews, análisis iterativos, guías) usan `version:` con
Semantic Versioning 2.0.0. Los archivos nunca se duplican con sufijo `-v2`, `-old`, etc. (I-002):
el número vive en el metadata del archivo canónico.

| Incremento | Cuándo | Ejemplo |
|------------|--------|---------|
| **MAJOR** (X.0.0) | La premisa, estructura o conclusiones cambian incompatiblemente — el doc contradice su versión anterior | Corregir error arquitectónico fundamental: `1.0.0 → 2.0.0` |
| **MINOR** (x.Y.0) | Se agregan secciones o hallazgos nuevos sin contradecir los existentes | Agregar sección de artefactos: `2.0.0 → 2.1.0` |
| **PATCH** (x.y.Z) | Correcciones menores: typos, clarificaciones, links rotos | Fix de typo: `2.0.0 → 2.0.1` |

**Versión inicial:** `1.0.0` al crear. Omitir el campo si el documento no tiene revisiones previstas.

**Nombres de archivo:** NUNCA incluir el número de versión en el nombre. El nombre es
auto-descriptivo del contenido; la versión vive en el metadata.

```
PROHIBIDO: deep-review-use-cases-v2.md, analysis-v3.md
CORRECTO:  deep-review-use-cases-analysis.md  (con version: 2.0.0 en metadata)
```

## Stage directories — lista completa

| Stage directory | Stage | Código phase |
|-----------------|-------|-------------|
| `discover/` | Stage 1 | `Phase 1 — DISCOVER` |
| `measure/` | Stage 2 | `Phase 2 — MEASURE` |
| `analyze/` | Stage 3 | `Phase 3 — ANALYZE` |
| `constraints/` | Stage 4 | `Phase 4 — CONSTRAINTS` |
| `strategy/` | Stage 5 | `Phase 5 — STRATEGY` |
| `plan/` | Stage 6 | `Phase 6 — PLAN` |
| `design/` | Stage 7 | `Phase 7 — DESIGN/SPECIFY` |
| `plan-execution/` | Stage 8 | `Phase 8 — PLAN EXECUTION` |
| `pilot/` | Stage 9 | `Phase 9 — PILOT/VALIDATE` |
| `execute/` | Stage 10 | `Phase 10 — EXECUTE` |
| `track/` | Stage 11 | `Phase 11 — TRACK/EVALUATE` |
| `standardize/` | Stage 12 | `Phase 12 — STANDARDIZE` |

## Reglas de colocación en stage directories

Cuando se crea o solicita un documento para un WP activo, colocarlo en el stage directory
correspondiente a su fase según la tabla anterior. Reglas críticas:

| Tipo de documento solicitado | Stage directory correcto | Template |
|------------------------------|--------------------------|----------|
| Plan estratégico, solución, scope, roadmap | `plan/` | — |
| Task plan con T-NNN checkboxes | `plan-execution/` | `workflow-decompose/assets/plan-execution.md.template` |
| Análisis, causa raíz, diagnóstico | `analyze/` | — |
| Restricciones, constraints | `constraints/` | — |
| Artefactos de cierre (lessons, changelog) | `track/` | — |

**Regla para `plan-execution/`:** TODO task plan creado en este stage directory DEBE usar
`plan-execution.md.template`. El nombre del archivo es descriptivo: `{iniciativa}-task-plan.md`
(ej: `skill-anatomy-task-plan.md`, no `task-plan.md`).

**Regla para `plan/`:** Documentos en `plan/` son planes estratégicos o de solución —
describen QUÉ y POR QUÉ, no T-NNN. Si el usuario pide "un plan para X" y el resultado
tiene checkboxes T-NNN → va en `plan-execution/`, no en `plan/`.

## Claims y afirmaciones en artefactos

Todo claim en un artefacto WP debe clasificarse como:
- **PROVEN** — producido por tool_use ejecutado en este WP (Bash, Read, Grep output)
- **INFERRED** — derivado de observables con razonamiento explícito documentado
- **SPECULATIVE** — sin observable de origen (hipótesis pendiente de validación)

Claims SPECULATIVE no pueden ser fundamento de decisiones de arquitectura o diseño.
Claims SPECULATIVE bloquean el gate Stage→Stage si aparecen en sección "Evidencia de respaldo".

Ver: `.claude/skills/thyrox/references/evidence-classification.md`

## Anti-patrones prohibidos

```markdown
<!-- PROHIBIDO: title inventado como campo metadata -->
---
title: "Mi análisis"
type: analysis
domain: architecture
---

<!-- CORRECTO: solo los campos estándar en bloque yml -->
\`\`\`yml
created_at: 2026-04-15 09:30:00
project: THYROX
work_package: 2026-04-15-08-29-58-plugin-distribution
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
\`\`\`
```
