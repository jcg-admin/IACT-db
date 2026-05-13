```yml
type: Architectural Decision Record
category: Calidad de instrucciones — prevención de timeouts
status: Aprobado
fecha: 2026-04-14
updated_at: 2026-04-14 22:23:22
origen_fase: FASE 35
```

# ADR: bound-detector — PreToolUse hook sobre Agent tool

## Contexto

Durante FASE 35 se detectó que instrucciones de agente con alcance ilimitado
("todos los scripts", "cada archivo") causaban stream idle timeouts. El análisis
Ishikawa identificó la causa raíz: sin un bound explícito, el agente expande la
tarea hasta agotar el tiempo disponible.

Ver análisis completo: `work/2026-04-14-09-13-51-context-migration/hook-authoring-timeout-ishikawa.md`

Se necesitaba un mecanismo que interceptara instrucciones sin bound **antes de
ejecutarlas** y bloqueara hasta que el usuario especificara un límite.

## Decisión

Implementar `bound-detector.py` como **`PreToolUse` hook con matcher `Agent`**,
registrado en `settings.json`.

```json
"PreToolUse": [
  {
    "matcher": "Agent",
    "hooks": [{"type": "command", "command": "python3 .claude/scripts/bound-detector.py"}]
  }
]
```

## Por qué PreToolUse sobre Agent (no UserPromptSubmit)

| Alternativa | Problema |
|-------------|----------|
| `UserPromptSubmit` | Intercepta todos los mensajes del usuario, la mayoría son conversación o preguntas — demasiado amplio y ruidoso |
| `PostToolUse` sobre `Agent` | Llega tarde — el agente ya se ejecutó |
| `PreToolUse` sobre `Agent` | Intercepta exactamente el momento en que Claude invoca un subagente con una tarea — el punto correcto |

```
Usuario → Claude → [decide lanzar Agent] → PreToolUse hook ← AQUÍ interceptamos
                                                 ↓
                                         ¿Tiene bound?
                                        /             \
                                      Sí               No
                                   pass-through    bloquear + opciones
```

## Algoritmo de detección

Sin LLM — debe ser rápido (es un hook síncrono en el camino crítico).

### Señales

```python
UNBOUNDED_SIGNALS = [
    "todos los", "todas las", "todo el", "toda la",
    "cada uno", "cada archivo", "cada script",
    "cualquier", "exhaustivamente", "completamente",
    "sin límite", "leer todos", "analiza todo", ...
]

BOUND_SIGNALS = [
    "máximo", "máx", "solo estos", "únicamente",
    "no más de", "primeros N", "hasta N", "límite de N", ...
]

DIFFUSE_SIGNALS = [
    "relevantes", "importantes", "necesarios",
    "apropiados", "representativos", "los más", ...
]
```

### Lógica de decisión

```
1. ¿Hay UNBOUNDED_SIGNAL?  No → allow silencioso
                           Sí ↓
2. ¿Hay BOUND_SIGNAL?      Sí → allow silencioso (bound claro compensa)
                           No ↓
3. ¿Hay DIFFUSE_SIGNAL?    Sí → deny con opciones de precisión
                           No ↓
4. deny con 5 opciones de bound
```

No hay scoring numérico — es match first-found por prioridad de capa.

## Los tres escenarios de respuesta

| Escenario | Ejemplo | Acción | Output del hook |
|-----------|---------|--------|-----------------|
| Bound claro | `"máximo 5 scripts"` | Pass-through silencioso | `permissionDecision: "allow"` |
| Bound difuso | `"archivos relevantes"` | Deny + opciones de precisión | `permissionDecision: "deny"` + `reason` |
| Sin bound | `"todos los scripts"` | Deny + 5 opciones concretas | `permissionDecision: "deny"` + `reason` |

### Formato del deny con opciones

```
⚠ INSTRUCCIÓN SIN BOUND DETECTADO

Patrón detectado: {matched}
Fragmento: «{snippet}»

El Agent tool call fue bloqueado. Especifica un bound antes de continuar.

OPCIONES:
  A) Número máximo:       "máximo N archivos/secciones/elementos"
  B) Selección explícita: "solo estos: [item1, item2, item3]"
  C) Criterio de parada:  "hasta encontrar N instancias de X"
  D) Representatividad:   "los 3-5 más representativos de [criterio concreto]"
  E) Tiempo/profundidad:  "máximo N tool_uses / N lecturas de archivo"
```

Claude recibe el `deny` + `reason` y se lo comunica al usuario — el Agent tool
no se ejecuta hasta que se reformule la instrucción.

## Consecuencias

### Positivas

- Prevención proactiva de timeouts por instrucciones ilimitadas
- El usuario recibe opciones concretas en lugar de un bloqueo sin guía
- No añade latencia al flujo normal (allow es inmediato, sin LLM)
- Detección sin LLM → reproducible y predecible

### Negativas / Trade-offs

- Puede generar falsos positivos: instrucciones como "todos los archivos de
  este directorio" con un scope naturalmente pequeño (3-4 archivos) serán
  bloqueadas aunque no representen riesgo real
- Las señales UNBOUNDED son en español — instrucciones en inglés pueden evadir
  la detección (mitigación parcial: `"read ALL"` y `"leer todos"` están incluidos)
- No detecta unboundedness implícita ("procesa el directorio" sin indicar cuántos
  archivos hay) — requiere señal léxica explícita

## Archivos

- Script: `.claude/scripts/bound-detector.py`
- Configuración: `.claude/settings.json` → `PreToolUse[matcher=Agent]`
- Lección derivada: `.thyrox/context/lessons/bound-agente-timeout.md`
- Patrón derivado: `.thyrox/context/patterns/bound-explicito-agente.md`
