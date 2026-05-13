```yml
type: Referencia — Gestión de Estado de Sesión
category: Cross-phase
version: 2.0.0
purpose: Define cuándo y cómo actualizar los archivos de estado del proyecto
updated_at: 2026-04-17 20:00:00
owner: thyrox (cross-phase)
```

# State Management — Archivos de Estado del Proyecto

## Los 3 archivos de estado

| Archivo | Pregunta que responde | Quién lo lee |
|---------|----------------------|-------------|
| `context/now.md` | ¿Qué WP está activo y en qué Stage? | `session-start.sh` (hook), Claude al iniciar sesión |
| `context/focus.md` | ¿En qué estamos trabajando y qué se completó? | Claude al iniciar sesión, `validate-session-close.sh` |
| `context/project-state.md` | ¿Qué hay en el sistema hoy? | Claude al necesitar contexto del proyecto |

---

## Tabla de triggers

| Evento | `now.md` | `focus.md` | `project-state.md` |
|--------|---------|-----------|-------------------|
| **Stage 1: WP creado** | +Actualizar `current_work` + `stage: Stage 1` | +Mencionar WP abierto | — |
| **Transición de Stage (1→2, 2→3…)** | +Actualizar `stage: Stage N` | — | — |
| **Coordinator activo** | +Actualizar `flow:` + `methodology_step:` | — | — |
| **Stage 11/12: WP cerrado** | +`current_work: null`, `stage: null`, `flow: null`, `methodology_step: null` | +ÉPICA completada + próximo paso | +Ejecutar `update-state.sh` |
| **Nuevo agente añadido** | — | — | +Ejecutar `update-state.sh` |
| **Nueva versión en CHANGELOG** | — | — | +Ejecutar `update-state.sh` |

---

## Campos YAML de `now.md`

| Campo | Tipo | Valores válidos | Gestionado por |
|-------|------|-----------------|---------------|
| `type` | fijo | `Estado de Sesión` | — |
| `version` | fijo | `1.1` | — |
| `updated_at` | timestamp | `YYYY-MM-DD HH:MM:SS` | `close-wp.sh` / edición manual |
| `cold_boot` | bool | `true` / `false` | `session-start.sh` |
| `last_session` | date | `YYYY-MM-DD` | `session-start.sh` |
| `current_work` | path | `work/TIMESTAMP-nombre/` o `null` | manual / `close-wp.sh` |
| `stage` | string | `Stage N — NOMBRE` o `null` | manual / `close-wp.sh` |
| `flow` | string | `dmaic` `pdca` `pmbok` `babok` `rup` `rm` `lean` `bpa` `pps` `sp` `cp` o `null` | coordinator al activarse |
| `methodology_step` | string | `namespace:paso` o `null` (ver tabla abajo) | coordinator en cada transición |
| `blockers` | list | `[]` o lista de strings | manual |
| `coordinators` | map | tracking multi-coordinator (ver formato en now.md) | coordinator |

---

## Contenido mínimo por archivo

### `now.md` — al crear WP (Stage 1)
```yaml
current_work: work/{timestamp}-{nombre}/
stage: Stage 1 — DISCOVER
flow: null
methodology_step: null
updated_at: YYYY-MM-DD HH:MM:SS
```

> `current_work` es relativo a `.thyrox/context/` — NO al repo root.
> `validate-session-close.sh` construye: `CONTEXT_DIR + "/" + current_work`.
> Si escribes `context/work/...` el path queda duplicado: `.thyrox/context/context/work/...` (roto).

### `now.md` — al cerrar WP (Stage 11/12)
```yaml
current_work: null
stage: null
flow: null
methodology_step: null
updated_at: YYYY-MM-DD HH:MM:SS
```

### `now.md` — con coordinator activo
```yaml
flow: dmaic
methodology_step: dmaic:analyze
```

### `focus.md` — al abrir WP (Stage 1)
```markdown
## WP activo
{nombre-wp} — Stage 1: DISCOVER en curso

## Completado recientemente
ÉPICA N-1: {descripción breve}
```

### `focus.md` — al cerrar WP
```markdown
## Completado
ÉPICA N: {nombre-wp} — {descripción de qué se logró}

## Sin WP activo
Framework en v{version}. Próximo paso: {siguiente item en ROADMAP o "sin pendientes"}
```

### `project-state.md` — generado por script
Ejecutar: `bash .claude/scripts/update-state.sh`
El script lee el estado real del repo y sobreescribe `project-state.md`.

---

## `# Contexto` body — sección LLM-managed

El bloque `# Contexto` al final de `now.md` es texto libre gestionado por el LLM.
No forma parte del YAML — es narrativa de sesión.

**Cuándo se escribe:** Claude lo actualiza al cierre de sesión (Stage 11: TRACK/EVALUATE) resumiendo el estado del WP activo.

**Cuándo se resetea:** `close-wp.sh` lo limpia al cerrar un WP usando el patrón bash-puro:
```bash
CONTEXTO_LINE=$(grep -n "^# Contexto" "$NOW_FILE" | head -1 | cut -d: -f1)
KEEP=$((CONTEXTO_LINE - 1))
head -n "$KEEP" "$NOW_FILE" > "${NOW_FILE}.tmp"
printf '# Contexto\n\n' >> "${NOW_FILE}.tmp"
mv "${NOW_FILE}.tmp" "$NOW_FILE"
```

**Formato canónico:**
```markdown
# Contexto

ÉPICA N {nombre-wp} — **Stage N NOMBRE**. {Estado breve}. Próximo: {tarea}.

## Historial reciente

- ÉPICA N-2: {wp} — Stage N completado
- ÉPICA N-1: {wp} — COMPLETADO YYYY-MM-DD
```

---

## `methodology_step` — namespacing por coordinator

Formato: `{namespace}:{paso}`. El namespace identifica el coordinator; el paso es el nombre
exacto de la fase/etapa de esa metodología. Campo interno en los YAMLs de registry: `steps:`.

| Namespace | Coordinator | Pasos válidos | Tipo de flujo |
|-----------|-------------|---------------|---------------|
| `dmaic` | dmaic-coordinator | `define` `measure` `analyze` `improve` `control` | secuencial |
| `pdca` | pdca-coordinator | `plan` `do` `check` `act` | cíclico |
| `pm` | pm-coordinator | `initiating` `planning` `executing` `monitoring` `closing` | secuencial |
| `ba` | ba-coordinator | `planning` `elicitation` `requirements-lifecycle` `strategy` `requirements-analysis` `solution-evaluation` | no-secuencial |
| `rup` | rup-coordinator | `inception` `elaboration` `construction` `transition` | iterativo (milestones LCO/LCA/IOC/PD) |
| `rm` | rm-coordinator | `elicitation` `analysis` `specification` `validation` `management` | state-machine (retornos condicionales) |
| `lean` | lean-coordinator | `define` `measure` `analyze` `improve` `control` | secuencial |
| `bpa` | bpa-coordinator | `identify` `map` `analyze` `design` `implement` `monitor` | secuencial |
| `pps` | pps-coordinator | `clarify` `analyze` `target` `countermeasures` `implement` `evaluate` | state-machine (retornos condicionales) |
| `sp` | sp-coordinator | `context` `analysis` `formulate` `plan` `execute` `monitor` `gaps` `adjust` | cíclico (sp:adjust→sp:analysis) |
| `cp` | cp-coordinator | `initiation` `structure` `diagnosis` `plan` `recommend` `implement` `evaluate` | secuencial |

**Ejemplos:**
```yaml
flow: dmaic
methodology_step: dmaic:analyze

flow: rm
methodology_step: rm:validation   # puede retornar a rm:analysis si falla

flow: ba
methodology_step: ba:elicitation   # BABOK: orden libre, no secuencial
```

---

## Script de actualización automática

```bash
# Generar project-state.md desde el repo real:
bash .claude/scripts/update-state.sh

# Ver qué escribiría sin modificar el archivo:
bash .claude/scripts/update-state.sh --dry-run
```

---

## Comportamiento del sistema de permisos sobre archivos de estado

Con `defaultMode: acceptEdits`, Edit sobre estos archivos es **automático**:
- `context/now.md` — auto
- `context/focus.md` — auto
- `context/project-state.md` — auto (o vía `update-state.sh` que también es auto)

No requieren confirmación adicional después del gate de fase. Ver [permission-model](permission-model.md).

---

## Reglas de oro

> `now.md` es la fuente de verdad para `session-start.sh`.
> Si `now.md::current_work` es incorrecto, el hook arranca con el WP equivocado.
> Actualizar `now.md` es la operación de mayor impacto en la continuidad de sesión.

> `current_work` es siempre relativo a `.thyrox/context/` — usar `work/TIMESTAMP-nombre/`, nunca `context/work/TIMESTAMP-nombre/`.

> `stage:` toma precedencia sobre `phase:` (retrocompat). Los scripts leen `stage:` primero con fallback a `phase:`.
