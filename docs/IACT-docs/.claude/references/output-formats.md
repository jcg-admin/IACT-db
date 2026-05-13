```yml
type: Reference
title: Output Formats — Formatos de Salida y Structured Output
category: Claude Code Platform — I/O
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: --output-format, --json-schema, jq patterns y structured output en Claude Code
```

# Output Formats — Formatos de Salida y Structured Output

Referencia de los formatos de output de Claude Code, `--output-format`, `--json-schema`, `--bare`, y patrones con `jq`.

---

## Print Mode (`-p` / `--print`)

Print mode ejecuta Claude de forma no interactiva: lee el prompt, genera la respuesta, y termina.

```bash
# Uso básico
claude -p "¿Cuántas líneas tiene src/index.ts?"

# Con piping
echo "Revisa este código:" | cat - src/main.py | claude -p

# Con archivo como input
claude -p "$(cat prompt.txt)"
```

**Diferencia con modo interactivo:**

| | Print mode (`-p`) | Interactivo |
|--|------------------|-------------|
| Duración | Una query, termina | Sesión continua |
| Estado | Sin persistencia | Historial de sesión |
| Output | stdout | UI completa |
| Uso típico | CI/CD, scripts, piping | Desarrollo, exploración |

**`run_in_background` vs Print mode** (diferencia crítica):

| | `run_in_background=true` (Agent tool) | Print mode (`-p`) |
|--|--------------------------------------|------------------|
| Tipo | Agente completo con herramientas | Query única no-interactiva |
| Herramientas | Todas las del agente | Sin herramientas de Claude Code |
| Asincronía | Async del padre, sincrónico internamente | Sincrónico |
| Uso | Sub-tareas paralelas largas | Pipelines CI/CD, batch queries |

---

## `--output-format`

Controla el formato del output en print mode:

```bash
claude -p "query" --output-format text         # Default — texto plano
claude -p "query" --output-format json         # JSON estructurado
claude -p "query" --output-format stream-json  # JSON por línea (streaming)
```

### `text` (default)

Output directo como texto. Útil para lectura humana, no para parsing programático.

```bash
claude -p "Suma 2 + 2" --output-format text
# → 4
```

### `json`

Output completo como JSON. Incluye metadata del proceso:

```json
{
  "type": "result",
  "subtype": "success",
  "result": "El resultado es 4",
  "session_id": "sess_abc123",
  "total_cost_usd": 0.001,
  "num_turns": 1,
  "usage": {
    "input_tokens": 45,
    "output_tokens": 12
  }
}
```

**Campos clave:**
- `result`: La respuesta de Claude
- `session_id`: Para reanudar con `-c <session_id>`
- `total_cost_usd`: Costo de la llamada
- `usage.input_tokens` / `usage.output_tokens`

### `stream-json`

Emite un objeto JSON por línea (JSONL) conforme Claude genera:

```bash
claude -p "Explica el código" --output-format stream-json
# → {"type":"text","text":"Este código"}
# → {"type":"text","text":" implementa..."}
# → {"type":"result","result":"..."}
```

Útil para mostrar progreso en tiempo real en pipelines.

---

## `--json-schema` — Structured Output

Fuerza a Claude a generar output que valide contra un JSON Schema:

```bash
claude -p "Extrae las tareas de este texto: $(cat tasks.txt)" \
  --output-format json \
  --json-schema '{
    "type": "array",
    "items": {
      "type": "object",
      "properties": {
        "title": {"type": "string"},
        "priority": {"type": "string", "enum": ["high", "medium", "low"]},
        "done": {"type": "boolean"}
      },
      "required": ["title", "priority"]
    }
  }'
```

**Casos de uso:**
- Extracción estructurada de datos de documentos
- APIs internas que necesitan JSON validado
- Pipelines de procesamiento de texto
- Integración con otras herramientas que consumen JSON

---

## `--bare` — Sin chrome de UI

Elimina todo el chrome de interfaz (spinners, headers, separadores):

```bash
claude -p "Responde solo el número: cuánto es 2+2" --bare
# → 4
# (sin spinner, sin formatting adicional)
```

**Combinaciones útiles:**

```bash
# Para scripting limpio
claude -p "..." --bare --output-format text

# Para JSON en scripts
claude -p "..." --bare --output-format json

# Para piping a herramientas
claude -p "List files to delete" --bare | xargs rm
```

---

## `--include-partial-messages` — Recuperar trabajo de sesiones fallidas

Cuando una sesión termina abruptamente (timeout, Ctrl+C), recupera los mensajes parciales:

```bash
claude -c <session_id> --include-partial-messages
```

Útil para recuperar respuestas parciales de una sesión que terminó con stream timeout.

---

## jq patterns — Procesar output JSON

### Extraer solo el resultado

```bash
claude -p "query" --output-format json | jq -r '.result'
```

### Extraer costo y tokens

```bash
claude -p "query" --output-format json | jq '{cost: .total_cost_usd, tokens: .usage}'
```

### Guardar session_id para reanudación

```bash
SESSION=$(claude -p "primera tarea" --output-format json | jq -r '.session_id')
claude -p "segunda tarea" -c "$SESSION" --output-format json
```

### Procesar stream-json

```bash
claude -p "query" --output-format stream-json | jq -r 'select(.type == "text") | .text'
```

### Extraer resultado o manejar error

```bash
RESULT=$(claude -p "query" --output-format json)
if echo "$RESULT" | jq -e '.subtype == "success"' > /dev/null; then
  echo "$RESULT" | jq -r '.result'
else
  echo "Error: $(echo "$RESULT" | jq -r '.error // "unknown"')"
fi
```

---

## Patrones de automatización

### Batch processing

```bash
# Procesar múltiples archivos
for file in src/*.ts; do
  claude -p "Review this file for security issues: $(cat $file)" \
    --output-format json \
    --max-turns 2 | jq -r '"## $file\n" + .result'
done > security-report.md
```

### JSON API interna

```bash
# Microservicio que usa Claude como backend
REQUEST='{"code": "function add(a,b){return a+b}", "task": "Add TypeScript types"}'
claude -p "$(echo $REQUEST | jq -r '.task + ": " + .code')" \
  --output-format json \
  --bare
```

### CI/CD con reporte estructurado

```bash
# GitHub Actions: generar reporte en GITHUB_STEP_SUMMARY
REVIEW=$(claude -p "Review PR: $(git diff origin/main)" \
  --output-format json \
  --max-turns 3 | jq -r '.result')

echo "## Code Review" >> $GITHUB_STEP_SUMMARY
echo "$REVIEW" >> $GITHUB_STEP_SUMMARY
```

---

## Anti-patrones

### ❌ Parsear output de text mode

```bash
# MAL — frágil, el formato puede cambiar
claude -p "Cuántos archivos hay?" | grep -o "[0-9]*"

# BIEN — usar json mode
claude -p "Retorna un JSON con count de archivos" \
  --output-format json | jq -r '.result | fromjson | .count'
```

### ❌ Mezclar --bare con modo interactivo

`--bare` solo aplica a print mode (`-p`). En modo interactivo no tiene efecto.

### ❌ Depender del formato exacto del text output

El formato del texto puede cambiar entre versiones. Usar `--output-format json` para parsing programático.

### ❌ `--json-schema` sin `--output-format json`

```bash
# MAL — --json-schema requiere --output-format json
claude -p "..." --json-schema '{...}'

# BIEN
claude -p "..." --output-format json --json-schema '{...}'
```
