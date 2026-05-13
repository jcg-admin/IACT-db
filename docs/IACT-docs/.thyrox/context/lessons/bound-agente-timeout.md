---
id: L-004
titulo: Instrucciones de agente sin scope bound causan timeouts por expansión ilimitada
categoria: Agentes
origen_wp: 2026-04-14-09-13-51-context-migration
origen_fase: FASE 35
fecha: 2026-04-14
---

## Contexto

Se lanzaron 13 agentes `deep-review` en paralelo para complementar los docs
de plataforma en `.claude/references/`. El agente de `hook-authoring.md`
recibió la instrucción: *"leer TODOS los scripts de ejemplo en
`/tmp/reference/claude-howto/06-hooks/`"*.

## Qué Pasó

El agente falló dos veces con stream idle timeout (~296-303s), siendo el
único de los 13 que falló. Los síntomas:
- `tool_uses: 45` (primer intento) — muy por encima del promedio
- `total_tokens: 7060` — bajo para el trabajo realizado
- El directorio fuente tenía 11 scripts bash (vs 1-3 para otros agentes)

El análisis Ishikawa identificó la causa raíz: la instrucción "leer TODOS"
sin un bound determinista llevó al agente a leer los 11 scripts secuencialmente,
acumulando contexto hasta que la generación de la respuesta final causó
un período de stream idle > 120s.

## Causa Raíz

Las instrucciones con alcance ilimitado (`todos`, `cada uno`, `cualquier`,
`sin límite`) no tienen punto de parada para el agente. El modelo aplica
la instrucción literalmente, expandiéndose hasta agotar el tiempo disponible.

**En un conjunto grande de archivos fuente, "leer todos" es equivalente
a "no termines hasta haberlo leído todo" — y el timeout llega antes.**

## Solución Aplicada

1. **Inmediata:** Aumentar `CLAUDE_STREAM_IDLE_TIMEOUT_MS` (L-003 — no funcionó
   por el problema de propagación en sesión activa)

2. **Correcta:** Acotar la instrucción a máximo 5 scripts priorizados:
   ```
   "leer únicamente estos 5 scripts: pre-tool-check.sh, log-bash.sh,
   validate-prompt.sh, notify-team.sh, security-scan.sh"
   ```
   El retry también falló (mismo timeout) — el timeout era de sesión activa.

3. **Estructural:** Crear `bound-detector.py` como `PreToolUse` hook que
   bloquea instrucciones sin bound antes de ejecutarlas y presenta opciones.

## Clave del Aprendizaje

**Toda instrucción de agente que contenga "todos", "cada uno", "cualquier"
o equivalentes necesita un bound explícito: número máximo, lista específica
o criterio de parada determinista.**

Sin bound = tiempo de ejecución potencialmente ilimitado.

## Aplicación Futura

Opciones de bound para cada tipo de instrucción ilimitada:

| Instrucción sin bound | Con bound correcto |
|-----------------------|-------------------|
| "leer todos los scripts" | "leer máximo 5 scripts: [lista]" |
| "analiza todos los archivos" | "analiza hasta 10 archivos, prioriza los más recientes" |
| "revisa todas las referencias" | "revisa estas 3 referencias: X, Y, Z" |
| "complementa todos los docs" | "complementa máximo N docs por sesión" |

El `bound-detector.py` en `PreToolUse` ahora bloquea automáticamente
instrucciones sin bound antes de que lleguen al agente.

## Referencias

- WP: `.thyrox/context/work/2026-04-14-09-13-51-context-migration/`
- Análisis Ishikawa: sesión FASE 35
- Script: `.claude/scripts/bound-detector.py`
- Commit: `feat(hooks): bound-detector — bloquear Agent calls sin scope bound`
- Relacionado: L-003 (env vars de sesión), P-002 (patrón bound explícito)
