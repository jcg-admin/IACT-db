```yml
type: Contexto Persistente
version: 3.7
updated_at: 2026-04-27 04:50:00
```

# CLAUDE.md — THYROX

**Level 2 — Puente entre [SKILL](skills/thyrox/SKILL.md) (Level 1) y proyecto.**

## Locked Decisions (no revisitar)

Estas son reglas del framework de metodologia — NO son ADRs del proyecto.
Los ADRs del proyecto viven en el path declarado por `adr_path` en este archivo (ver sección Configuración del Proyecto).

1. **ANALYZE first** — No planificar sin entender primero
2. **Anatomía oficial** — SKILL.md + scripts/ + references/ + assets/
3. **Git as persistence** — Zero archivos backup, historial en git
4. **Markdown only** — Sin bases de datos, sin formatos propietarios
5. **Single skill** — Un `thyrox` con references, no 15 skills separados
   *Addendum FASE 22:* Los `workflow-*` skills son la excepción intencional: son herramientas de ejecución por fase, no skills de dominio tecnológico. Esta excepción está documentada en ADR-016. La regla original sigue vigente para tech skills (python, react, etc.).
   *Addendum FASE 23:* Nomenclatura resuelta a kebab-case hyphens — `workflow-*/SKILL.md`. TD-019 cerrado (FASE 23).
   *Addendum FASE 29:* Skill renombrado → `thyrox` (prefijo `pm-` eliminado — no es PM de PMI, es la metodología THYROX misma). TD-020 cerrado (FASE 29).
   *Addendum FASE 31:* Interfaz pública del sistema → `/thyrox:*` (plugin namespace via `.claude-plugin/plugin.json`). Los `workflow-*` skills permanecen como implementación interna. Capa de presentación complementa ADR-016. Ver ADR-019. TD-036 cerrado (FASE 31).
   *Addendum FASE 35:* Estado de sesión y work packages migrados a `.thyrox/context/` — fuera de `.claude/` (zona de configuración de Claude Code). Ver ADR en `.thyrox/context/decisions/`.
   *Addendum FASE 39:* 12 fases THYROX propias (DISCOVER → STANDARDIZE). `workflow-analyze` renombrado a `workflow-discover`. 12 skills workflow-* totales: workflow-discover, workflow-measure, workflow-analyze, workflow-constraints, workflow-strategy, workflow-plan, workflow-structure, workflow-decompose, workflow-pilot, workflow-execute, workflow-track, workflow-standardize. Sistema `.claude/rules/` creado para invariantes globales.
6. **Work packages with timestamp** — `.thyrox/context/work/YYYY-MM-DD-HH-MM-SS-nombre/`
7. **Tim Pope commit style** — Subject imperativo (≤72 ch, capitalizado, sin punto) + línea en blanco + body con QUÉ y POR QUÉ, wrapped a 72 ch. Reemplaza Conventional Commits desde ÉPICA 4 (repository-diagnostics). Ver `.claude/rules/commit-conventions.md`.
8. **Changelog en dos niveles** — `track/{wp}-changelog.md` se actualiza siempre durante el WP. `CHANGELOG.md` raíz **solo** se modifica en merge a `main` con bump de versión. Ver `.claude/rules/changelog-policy.md`.

## SKILL vs ADR — Regla de uso

|                  | SKILL.md                                     | ADR en {adr_path}                              |
|------------------|----------------------------------------------|--------------------------------------------------------|
| Que es           | Instrucciones de metodologia (como trabajar) | Registro de decision tomada (por que se eligio X)      |
| Quien lo escribe | Mantenedor del sistema                       | Claude en Phase 1-2, cuando hay decision permanente    |
| Cuando modificar | Solo si cambia la metodologia de gestion     | Al tomar una decision arquitectonica del proyecto      |
| Duracion         | Vive con el sistema                          | Inmutable una vez aprobado                             |

REGLA: Si la duda es "documento esto en SKILL.md o en un ADR?":
- Cambia COMO se trabaja en general -> SKILL.md
- Registra POR QUE se eligio algo en este proyecto -> ADR en {adr_path}

## Estructura

```
.claude/                       ← Configuración y extensiones de Claude Code (solo esto)
├── CLAUDE.md                  ← Este archivo (Level 2)
├── agents/                    ← Agentes nativos Claude Code (ver references/agent-spec.md)
├── commands/                  ← Comandos slash disponibles (sin frontmatter, sin disparo automático)
├── memory/                    ← Memoria persistente entre sesiones
├── references/                ← Documentación global de plataforma Claude Code (on-demand)
├── scripts/                   ← Scripts de infraestructura Claude Code (hooks, utilidades)
└── skills/                    ← Skills del sistema (thyrox + workflow-*)
    └── thyrox/                ← El SKILL (Level 1): SKILL.md + references/ + scripts/ + assets/

.thyrox/                       ← Estado de trabajo + tooling del proyecto
├── context/                   ← Estado de sesión y artefactos de trabajo
│   ├── project-state.md       ← Metadata del proyecto
│   ├── focus.md               ← Dirección actual
│   ├── now.md                 ← Estado de sesión single-agent
│   ├── now-{agent-id}.md      ← Estado por agente (ejecución paralela)
│   ├── decisions/             ← ADRs (adr-{tema}.md — sin números)
│   ├── errors/                ← Registros de errores ({descripcion}.md — sin números)
│   ├── research/              ← Investigaciones y sandboxes
│   ├── technical-debt.md      ← Backlog de deuda técnica
│   └── work/                  ← Paquetes de trabajo (YYYY-MM-DD-HH-MM-SS-nombre/)
├── guidelines/                ← Directivas tech-stack (generadas por registry/_generator.sh)
│   └── {layer}-{framework}.instructions.md  ← cargadas vía @imports abajo
└── registry/                  ← Fuente de verdad y generadores
    ├── agents/                ← Definiciones YML de agentes (Flujo A)
    ├── {layer}/               ← Templates de metodología (Flujo B)
    ├── mcp/                   ← Servidores MCP de runtime (Flujo C)
    ├── bootstrap.py           ← Genera .claude/agents/ desde agents/*.yml
    └── _generator.sh          ← Genera .claude/skills/ + .thyrox/guidelines/ desde templates
```

## Tech-stack guidelines — @imports

Directivas siempre activas para el stack del proyecto. Generadas por `registry/_generator.sh`.

@.thyrox/guidelines/backend-nodejs.instructions.md
@.thyrox/guidelines/db-mysql.instructions.md
@.thyrox/guidelines/db-postgresql.instructions.md
@.thyrox/guidelines/frontend-react.instructions.md
@.thyrox/guidelines/frontend-webpack.instructions.md
@.thyrox/guidelines/python-mcp.instructions.md
<!-- python-mcp: guideline manual — no generada por _generator.sh. Ver adr-python-mcp-manual-skill.md -->
@.thyrox/guidelines/agentic-python.instructions.md

**Por qué `.thyrox/` y no `.claude/context/`:**
`.claude/` está protegido por una safety invariant del binario de Claude Code — genera un prompt
de confirmación en cada escritura, incluso con `acceptEdits`. El estado de sesión (now.md, work packages)
se escribe frecuentemente: la solución correcta es moverlo fuera de `.claude/`. Ver FASE 35 y ADR al respecto.

## Reglas de edición — OBLIGATORIO

Aplicar en TODA edición de archivo, sin excepción:

1. **`updated_at` es automático** — Si el archivo que se está editando tiene `updated_at` en su frontmatter, actualizarlo al timestamp actual (`date '+%Y-%m-%d %H:%M:%S'`) en el mismo Edit. No es un paso separado, no requiere que el usuario lo pida, no requiere GATE OPERACIÓN. Es una edición consecuencia — ocurre siempre.

2. **Un solo Edit por archivo** — Nunca hacer dos Edits separados al mismo archivo: uno para el contenido y otro para `updated_at`. Ambos cambios van en la misma llamada.

3. **`updated_at` no aplica a artefactos WP** — Los archivos en `.thyrox/context/work/` tienen `created_at` en su frontmatter y no se actualizan como documentos vivos. No agregar `updated_at` donde no existía.

## Flujo de sesión — OBLIGATORIO

SIEMPRE seguir este flujo. NO omitir pasos.

1. **Inicio** — Leer `.thyrox/context/focus.md` + `.thyrox/context/now.md` + ROADMAP.md.
2. **Activar SKILL** — ANTES de responder cualquier tarea: invocar Skill tool → thyrox.
   Si el Skill tool no está disponible: leer [SKILL.md](skills/thyrox/SKILL.md) completo y seguirlo paso a paso.
3. **Identificar fase activa** — Revisar `.thyrox/context/work/`:
   - Hay work package activo → continuar en la fase donde quedó.
   - No hay work package → empezar Phase 1: DISCOVER.
4. **Trabajar** — Seguir cada fase hasta su exit criteria. NO saltarse fases. Commits convencionales. Actualizar ROADMAP.md.
5. **Cierre** — Actualizar `.thyrox/context/focus.md` + `.thyrox/context/now.md`.

### Protocolo de Completación de Fase (I-015: Invariante Crítica)

**REGLA INVIOLABLE:** Antes de reportar cualquier phase/WP como "complete", "done", o "finished":

```bash
bash .claude/scripts/validate-phase-completion.sh
```

El script valida 5 condiciones:
1. Working tree clean (sin cambios unstaged)
2. No staged changes (nada pendiente de commit)
3. Remote sync (todos los commits pusheados)
4. Build success (make html exit 0)
5. Recent commits (hay historial)

**Resultado:**
- Exit code 0 = SEGURO reportar completación
- Exit code 1 = NO reportar hasta fijar los problemas

**Nunca** reportar completación sin este check. Ver ADR-phase-completion-validation-protocol.md para detalles y motivación.

## Multi-skill orchestration

Reglas cuando hay más de un skill activo en la misma sesión.

- **Máximo simultáneos:** 2-3 skills. Por encima de ese límite, el budget de context window para descripciones se satura y el triggering de todos se degrada.
- **Cuándo secuenciar:** Si skill B necesita output de skill A (e.g. tech-detector → python-mcp), ejecutar A hasta completar y commitear antes de activar B.
- **Section owners disjuntos:** Cada skill escribe en archivos distintos. Si dos skills necesitan tocar el mismo archivo, uno lo hace y el otro espera (o usa una sección marcada con `<!-- SECTION OWNER: {skill} -->`).
- **Naming de state files por skill:**
  - Orquestador / estado compartido → `.thyrox/context/now.md`
  - Agente nativo en ejecución → `.thyrox/context/now-{agent-name}.md` (e.g. `now-task-executor.md`)
  - Skill especializado → `.thyrox/context/now-{skill-name}-{wp-id}.md` (e.g. `now-security-audit-wp-auth.md`)
  - Gate evaluador (paralelo) → `.thyrox/context/gate-{stage}-eval-{n}.json` (e.g. `gate-3-eval-1.json`)
  - Gate Merger output → `.thyrox/context/gate-{stage}-merged.json` (e.g. `gate-3-merged.json`)
- **Campos requeridos en state files de agentes paralelos:** `agent_id`, `status` (running/completed/failed), `output_key`, `started_at`, `timeout_at`. Ver detalle: `.claude/references/parallel-agent-state-files.md`

## Convenciones de escritura — OBLIGATORIO

Estas convenciones aplican a TODO el código y texto generado por Claude en esta sesión
y en sesiones de agentes hijos. CLAUDE.md es el único artefacto cargado automáticamente
en todas las sesiones y heredado por agentes — por eso las convenciones universales viven aquí,
no en references/ (on-demand) ni en guidelines/ (on-demand).

### Preparación de inputs para análisis (input.md de textos externos)

**Regla:** Cuando se prepara un documento `input.md` que estructura un capítulo, paper o texto externo para análisis por agentes (`deep-dive`, `agentic-reasoning`, etc.), NO comprimir.

**Qué preservar verbatim:**
- Todo párrafo que contenga un claim técnico, arquitectónico, cuantitativo o de calidad
- Conclusiones completas (no solo la última frase)
- Párrafos de cierre de secciones (suelen contener las afirmaciones más fuertes)
- Código completo (no pseudocódigo ni resumen del código)
- Frases que niegan un defecto ("no meramente X") — son claims de calidad implícitos

**Qué puede estructurarse/comprimirse:**
- Introducción narrativa sin claims verificables
- Repeticiones de afirmaciones ya capturadas
- Ejemplos ilustrativos cuando el claim principal ya está captado

**Por qué esta regla existe:**
Las elecciones editoriales de qué comprimir son elecciones de qué NO analizar. Los agentes solo pueden evaluar lo que reciben. Si el input.md está incompleto, el análisis lo estará también — y el error será del orquestador, no del agente.

**Anti-patrón específico documentado:** En la sesión ÉPICA 42 (2026-04-18), al preparar el input de Cap.6 Planning v2.0.0, se comprimió la sección DeepResearch perdiendo: (1) integración de documentos privados, (2) "no mera concatenación" como garantía implícita de calidad, (3) párrafo de cierre de casos de uso. Cada uno generó claims adicionales no analizados inicialmente.

---

### Parámetro `description` del Agent tool

**Convención:** minúscula consistente (sentence case — primera palabra y nombres propios).

```python
# Correcto
Agent(description="deep-review de permisos en claude-howto", ...)
Agent(description="análisis de cobertura Phase 3 → Phase 4", ...)

# Incorrecto
Agent(description="Deep-review de permisos...", ...)
Agent(description="ANÁLISIS DE COBERTURA...", ...)
```

**Respaldo documental:**
- claude-howto `STYLE_GUIDE.md:144` — P3.1: sentence case para todos los encabezados y labels
- claude-code-ultimate-guide — ningún repo documenta explícitamente este parámetro,
  pero el ecosistema usa minúsculas para todos los valores de configuración
  (model names: `sonnet`, effort values: `low/medium/high`, kebab-case names)
- Fuente: `conventions-review-claude-howto.md` y `conventions-review-ultimate-guide.md`
  en WP `2026-04-14-09-13-51-context-migration/`

## Configuración del Proyecto

adr_path: .thyrox/context/decisions/   # THYROX: retrocompat. Nuevos proyectos: usar subdirectorios por capa (global/, api/, db/, ui/, deploy/, framework/)

## Glosario

| Término | Significado | Ejemplo |
|---------|-------------|---------|
| **ÉPICA N** | Iniciativa de trabajo del proyecto — número secuencial global. Cada WP ocupa una ÉPICA. Antes llamado "FASE N" (retrocompat). | ÉPICA 39: plugin-distribution · ÉPICA 40: multi-methodology |
| **Stage N** | Etapa del ciclo THYROX dentro de un WP (1-DISCOVER … 12-STANDARDIZE). Se reinicia en cada ÉPICA. Antes llamado "Phase N". | ÉPICA 40 está en Stage 5: STRATEGY |
| **WP** | Work package — directorio `.thyrox/context/work/YYYY-MM-DD-HH-MM-SS-nombre/` que contiene todos los artefactos de una ÉPICA | `.thyrox/context/work/2026-04-16-18-54-38-multi-methodology/` |
| **flow** | Metodología activa dentro de un WP (pdca, dmaic, pmbok, babok, rup, rm) | `flow: pdca` en now.md |
| **methodology_step** | Paso actual de la metodología activa, con prefijo namespace | `pdca:do`, `dmaic:analyze`, `pm:executing` |
| **SP-NNN** | Stopping Point — punto de parada explícito definido en el Stopping Point Manifest de Stage 1 | SP-06: gate 6→7, esperar aprobación humana |

**Regla mnemotécnica:** ÉPICA es el "qué proyecto", Stage es el "en qué etapa del proyecto".
Un proyecto con 40 ÉPICAs tiene 40 WPs; cada WP recorre hasta 12 Stages internamente.

**Stages con renaming (desambiguación con metodologías):**
Stage 2 BASELINE (antes MEASURE) · Stage 3 DIAGNOSE (antes ANALYZE) ·
Stage 6 SCOPE (antes PLAN) · Stage 10 IMPLEMENT (antes EXECUTE)

**Retrocompatibilidad:** Los documentos históricos que usan "FASE N" y "Phase N" son válidos — se leen como sinónimos de ÉPICA y Stage respectivamente.

## Restricciones de fórmulas probabilísticas

Las siguientes fórmulas están prohibidas en artefactos THYROX:

1. **Forma simple:** `P₀ × e^(-r×d)` — decay exponencial sin calibración empírica propia
2. **Forma multiparámetro Part B:** `P(correct) = P₀ × e^(-Σλᵢxᵢ)` con 5+ parámetros — ratio de calibración 8%, calibración circular (misma observación para ajuste y validación)

**Por qué:** Estas fórmulas proyectan precisión cuantitativa sin derivación empírica verificable. Constituyen realismo performativo (ÉPICA 42).

**Alternativa válida:** afirmaciones calibradas con evidencia observable (`PROVEN/INFERRED/SPECULATIVE`) o estimaciones explícitamente marcadas como hipótesis.

## Para más contexto

- Metodología completa: [SKILL](skills/thyrox/SKILL.md)
- Estado del proyecto: [project-state](../.thyrox/context/project-state.md)
- Decisiones: [decisions](../.thyrox/context/decisions.md)
- Convenciones: [conventions](references/conventions.md)
