---
name: workflow-discover
description: "Use when starting a new work package or exploring a problem. Phase 1 DISCOVER — contextualiza stakeholders, síntomas y síntesis del problema. Crear WP + risk register."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 1'"
updated_at: 2026-04-16 00:00:00
---

# /workflow-discover — Phase 1: DISCOVER

Inicia o retoma Phase 1 DISCOVER del work package activo.

---

## Escalabilidad

Determinar qué fases son obligatorias antes de empezar el análisis:

| Tamaño | Duración | Fases activas | Qué omitir |
|--------|----------|---------------|------------|
| Micro | <30 min | 1, 10, 11 | Phases 2-9 |
| Pequeño | 30 min – 2h | 1, 3, 10, 11 | Phases 2, 4-9 |
| Mediano | 2h – 8h | 1, 3, 5, 6, 8, 10, 11 | Phases 2, 4, 7, 9, 12 |
| Grande | >8h | 1–12 completo | Ninguna — usar epic.md para agrupar features |

Ver [escalabilidad](references/scalability.md) para detalles y casos de borde.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer `context/now.md` — verificar `phase` y `current_work`
3. Listar tech skills activos: `ls .claude/skills/ | grep -v thyrox`
4. Verificar si ya existe `*-analysis.md` en el WP:
   - `ls .thyrox/context/work/[WP-activo]/discover/ 2>/dev/null`
   - Si existe sin `[NEEDS CLARIFICATION]` → Phase 1 ya completó. Proponer `/thyrox:measure`.
   - Si no existe → iniciar Phase 1.

---

## Step 0 — Contexto del usuario final (TD-007)

Antes de analizar: preguntar brevemente al usuario:
- ¿Quién usará el sistema? (rol, contexto)
- ¿Qué quieren lograr en concreto?
- ¿Hay restricciones o contexto no obvio?

Documentar en `{nombre-wp}-analysis.md` sección "Contexto del usuario final". Omitir si el usuario ya lo explicó en el mensaje inicial.

---

## Fase a ejecutar: Phase 1 DISCOVER

Entender el problema antes de proponer soluciones evita construir lo incorrecto.

1. Investigar estos **8 aspectos** — preguntar al usuario lo que no esté claro:
   - **Objetivo/Por qué** — ¿qué se quiere lograr y por qué importa?
   - **Stakeholders** — ¿quiénes son los usuarios y qué necesitan?
   - **Uso operacional** — ¿cómo se usará el sistema en la práctica?
   - **Atributos de calidad** — ¿qué importa más: velocidad, seguridad, confiabilidad?
   - **Restricciones** — ¿qué limita la solución (tech, tiempo, presupuesto)?
   - **Contexto/sistemas vecinos** — ¿dónde se sitúa, qué lo rodea?
   - **Fuera de alcance** — ¿qué NO se va a hacer?
   - **Criterios de éxito** — ¿cómo sabremos que está bien hecho?

### 1.5 ⏸ STOP pre-creación — Gate obligatorio

Antes de crear el directorio del WP o cualquier archivo:

1. Presentar al usuario el nombre propuesto del WP y el timestamp.
2. Esperar confirmación explícita (sí/no).
3. NO crear ningún archivo hasta recibir respuesta.

Excepción: si el WP ya existe (retomar work package), saltar este gate.

2. Crear work package — obtener timestamp real del sistema:
   - Directorio: `date +%Y-%m-%d-%H-%M-%S` → `context/work/{timestamp}-nombre/`
   - Metadata: `date '+%Y-%m-%d %H:%M:%S'` → ISO 8601 para `created_at`
   - NUNCA inventar ni estimar el timestamp
   - REQUERIDO: actualizar `context/now.md` con `current_work` y `phase: Phase 1`
   - Clasificar reversibilidad: `documentation` | `reversible` | `irreversible`

3. REQUERIDO: Crear `work/.../discover/{nombre-wp}-analysis.md` usando `assets/introduction.md.template`
   - El nombre debe revelar QUÉ se analiza: `skill-activation-analysis.md`, no `introduction.md`

4. REQUERIDO: Crear `work/../{nombre-wp}-risk-register.md` usando `assets/risk-register.md.template`

5. Si el análisis es complejo: crear sub-documentos en los cajones de fase correspondientes:
   - `discover/` → stakeholders, contexto, síntomas adicionales
   - `analyze/` → sub-análisis de causa raíz por dominio (con subdomains libres)
   - `constraints/` → restricciones técnicas, organizacionales, regulatorias
   (Estructura plana por fase — NO usar carpeta `analysis/` genérica)

6. Para proyectos medianos/grandes: Crear `work/../{nombre-wp}-exit-conditions.md` usando `assets/exit-conditions.md.template`

7. Si hay principios arquitectónicos globales: crear/actualizar `constitution.md` en la raíz

8. ADR: crear solo si aplica (cambio de stack, nuevo patrón arquitectónico, decisión que afecta todos los WPs futuros). Path: `adr_path` en CLAUDE.md → `.thyrox/context/decisions/`

9. REQUERIDO: Añadir `## Stopping Point Manifest` al final del `*-analysis.md`:
   - Registrar gates obligatorios: 1→2, 2→3, 3→4, 4→5, 5→6, 6→7, 7→8, 8→9, 9→10, 10→11, 11→12
   - Si hay agentes async: añadir SP-NNN por cada agente background
   - Si hay ambigüedades de scope: añadir gate-decision
   - Formato: `ID | Fase | Tipo | Evento | Acción requerida`
   - Tipos: `gate-fase` | `async-completion` | `gate-operacion` | `gate-decision`

Tech skills activos: si hay `frontend-react` investigar componentes; `backend-nodejs` investigar endpoints; `db-postgresql` investigar tablas y relaciones.

---

## Validaciones pre-gate (TD-029, TD-031, TD-033)

Antes de presentar el gate 1→2:
- **TD-031 deep review**: revisar `{nombre-wp}-analysis.md` — ¿cubre los 8 aspectos sin [NEEDS CLARIFICATION]?
- **TD-029 criterios**: `{nombre-wp}-risk-register.md` existe · Stopping Point Manifest documentado · `now.md::phase = Phase 1`
- **TD-033 now.md**: `git add .thyrox/context/now.md` antes de commits y gates

## Gate humano

⏸ STOP — Presentar resumen de hallazgos (objetivos, gaps, riesgos, criterios de éxito).
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar: actualizar `context/now.md::phase` a `Phase 2`.

---

## Exit criteria

Phase 1 completa cuando:
- `work/.../discover/{nombre-wp}-analysis.md` existe sin `[NEEDS CLARIFICATION]`
- `{nombre-wp}-risk-register.md` existe
- Stopping Point Manifest documentado
- Usuario confirmó los hallazgos explícitamente en esta sesión

**Detectar:** Si `work/.../discover/` tiene `*-analysis.md` sin `[NEEDS CLARIFICATION]`, Phase 1 ya completó.
Al terminar: proponer `/thyrox:measure` para Phase 2 o `/thyrox:analyze` para Phase 3 (según tamaño del WP).
