#!/usr/bin/env bash
# bin/thyrox-loop.sh
# Loop externo de Phase 10 EXECUTE usando claude -p.
# Alternativa a /loop cuando ScheduleWakeup no está disponible (no Desktop App).
#
# Uso:
#   bash bin/thyrox-loop.sh              # Loop hasta gate o completitud
#   bash bin/thyrox-loop.sh --max 10    # Máximo 10 iteraciones
#   ANTHROPIC_API_KEY=sk-... bash bin/thyrox-loop.sh
#
# Requisito: claude CLI instalado y ANTHROPIC_API_KEY configurada.

set -euo pipefail

MAX_ITERATIONS=${2:-50}
DELAY_SECONDS=5
ITERATION=0

log() { echo "[thyrox-loop] $*"; }

# Verificar CLI disponible
if ! command -v claude &>/dev/null; then
    log "ERROR: claude CLI no encontrado. Instalar con: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

# Verificar API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    log "ERROR: ANTHROPIC_API_KEY no configurada."
    exit 1
fi

# Verificar WP activo
WP_DIR=$(ls -t .thyrox/context/work/ 2>/dev/null | head -1)
if [ -z "$WP_DIR" ]; then
    log "ERROR: No hay work package activo en .thyrox/context/work/"
    exit 1
fi

TASK_PLAN=$(ls .thyrox/context/work/"$WP_DIR"/*-task-plan.md 2>/dev/null | head -1)
if [ -z "$TASK_PLAN" ]; then
    log "ERROR: No se encontró task-plan.md en $WP_DIR"
    exit 1
fi

log "WP activo: $WP_DIR"
log "Task plan: $TASK_PLAN"
log "Máximo iteraciones: $MAX_ITERATIONS"
log "Iniciando loop..."

PROMPT="Ejecuta la siguiente tarea pendiente del task-plan de Phase 10 EXECUTE.
Task plan: $TASK_PLAN
WP activo: .thyrox/context/work/$WP_DIR/

Reglas:
- Tomar la primera línea con '- [ ] [T-' del task-plan
- Si la tarea tiene [GATE] en su descripción: imprimir 'GATE_REACHED: <descripción>' y parar
- Si no hay tareas pendientes: imprimir 'ALL_DONE' y parar
- Si hay error: imprimir 'ERROR: <descripción>' y parar
- De lo contrario: ejecutar la tarea, marcar [x], hacer commit, imprimir 'TASK_DONE: T-NNN'

Output esperado en la última línea: GATE_REACHED | ALL_DONE | ERROR | TASK_DONE"

while [ $ITERATION -lt "$MAX_ITERATIONS" ]; do
    ITERATION=$((ITERATION + 1))
    log "Iteración $ITERATION/$MAX_ITERATIONS..."

    OUTPUT=$(claude -p \
        --max-turns 8 \
        --permission-mode acceptEdits \
        "$PROMPT" 2>&1)

    # Detectar estado de salida
    if echo "$OUTPUT" | grep -q "^ALL_DONE"; then
        log "Todas las tareas completadas. Loop terminado."
        exit 0
    elif echo "$OUTPUT" | grep -q "^GATE_REACHED"; then
        GATE_MSG=$(echo "$OUTPUT" | grep "^GATE_REACHED" | head -1)
        log "Gate detectado: $GATE_MSG"
        log "Loop pausado. Revisar y aprobar manualmente, luego volver a ejecutar."
        exit 0
    elif echo "$OUTPUT" | grep -q "^ERROR"; then
        ERR_MSG=$(echo "$OUTPUT" | grep "^ERROR" | head -1)
        log "Error detectado: $ERR_MSG"
        exit 1
    elif echo "$OUTPUT" | grep -q "^TASK_DONE"; then
        TASK_MSG=$(echo "$OUTPUT" | grep "^TASK_DONE" | head -1)
        log "Completado: $TASK_MSG"
        sleep "$DELAY_SECONDS"
    else
        log "Output inesperado en iteración $ITERATION. Continuando..."
        sleep "$DELAY_SECONDS"
    fi
done

log "Máximo de iteraciones alcanzado ($MAX_ITERATIONS). Parar y revisar estado."
exit 0
