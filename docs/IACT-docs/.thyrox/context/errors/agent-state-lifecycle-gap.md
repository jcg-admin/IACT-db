```yml
created_at: 2026-04-20 18:16:28
project: THYROX
work_package: 2026-04-18-07-12-50-methodology-calibration
phase: Phase 10 — EXECUTE
author: NestorMonroy
status: Resuelto
```

# Error: Gap de lifecycle en state files de agente

## Síntoma

`validate-session-close.sh` emitía:
```
[WARN] AGENTES EN BACKGROUND: 1 state file(s) de agente sin cerrar:
  .thyrox/context/now-task-executor.md
```
…después de que el agente `task-executor` completó su trabajo y la sesión cerró.

## Causa raíz — 3 gaps acumulados

**Gap 1 — Schema incompleto (task-executor.md:22-27):**
El schema declarado tenía `tarea_activa`, `proximo_paso`, `wp` — sin campo `status`.
Sin `status`, `validate-session-close.sh` no podía distinguir "agente en curso" de "agente terminado".
*Tipo: PROVEN — ausencia textual verificable.*

**Gap 2 — Ausencia de paso de cleanup (task-executor.md:30-37):**
El flujo de ejecución tenía 6 pasos. Ninguno incluía eliminar `now-task-executor.md` al terminar.
El agente creaba el archivo al inicio pero no tenía instrucción de cerrarlo.
*Tipo: PROVEN — ausencia textual verificable.*

**Gap 3 — Check 2 ciego al status (validate-session-close.sh:40-41):**
`find "$CTX_DIR" -maxdepth 1 -name "now-*.md"` emitía WARN por la mera existencia del archivo.
No leía el contenido ni evaluaba `status`. Esto generaba falsos positivos para agentes completados.
*Tipo: PROVEN — el find en línea 40-41 no invoca grep ni lectura de campos.*

## Diagnóstico

**Diseño incompleto, no incorrecto.** El diseño de `parallel-agent-state-files.md` era correcto
para gate evaluators (Tipo A). El problema fue que `task-executor` adoptó el naming `now-{agent}.md`
como bookmark de sesión (Tipo B) sin adoptar el schema completo ni el ciclo de vida.
`validate-session-close.sh` implementó la detección asumiendo que el cleanup ocurriría,
pero `task-executor` nunca recibió esa instrucción.

Gap de **omisión de sincronización entre documentos** — no de lógica incorrecta en ninguno individualmente.

## Correcciones aplicadas

| # | Archivo | Cambio | Commit |
|---|---------|--------|--------|
| C1 | `task-executor.md` | Schema ampliado: `status: running` + `started_at` requeridos | fix(agents): agent state lifecycle gap |
| C2 | `task-executor.md` | Paso 7 agregado: `status: completed` → eliminar file al terminar | fix(agents): agent state lifecycle gap |
| C3 | `validate-session-close.sh` | Check 2: lee `status` — `completed` → auto-cleanup, `running`/ausente → WARN | fix(agents): agent state lifecycle gap |
| C4 | `parallel-agent-state-files.md` | Documenta Tipo A (gate evaluadores) vs Tipo B (bookmark) con lifecycle explícito | fix(agents): agent state lifecycle gap |

## Verificación

Después de la corrección:
- Agente con `status: completed` → script lo elimina silenciosamente (`[INFO]`)
- Agente con `status: running` o sin status → WARN genuino (riesgo real)
- `validate-session-close.sh` cero falsos positivos para agentes completados correctamente
