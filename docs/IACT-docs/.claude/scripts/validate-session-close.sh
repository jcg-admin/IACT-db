#!/usr/bin/env bash
# validate-session-close.sh — Valida estado del WP y agentes antes de cerrar sesión
# TD-001: detecta timestamps incompletos (created_at sin hora)
# T-034: detecta gate eval files huérfanos (sin merged correspondiente)
# Uso: bash .claude/scripts/validate-session-close.sh
# Exit 0 → todo OK (advertencias no bloquean Stop hook)

ERRORS=0
BLOCK_COUNT=0

# ── Directorios con soporte de migración ──────────────────────────────────────
# Durante la migración .claude/context/ → .thyrox/context/ ambos pueden coexistir.
WORK_DIRS=()
[ -d ".claude/context/work" ]  && WORK_DIRS+=(".claude/context/work")
[ -d ".thyrox/context/work" ]  && WORK_DIRS+=(".thyrox/context/work")

CONTEXT_DIRS=()
[ -d ".claude/context" ]       && CONTEXT_DIRS+=(".claude/context")
[ -d ".thyrox/context" ]       && CONTEXT_DIRS+=(".thyrox/context")

# ── Check 1: TD-001 — timestamps incompletos (created_at sin hora) ─────────────
for WORK_DIR in "${WORK_DIRS[@]}"; do
  INCOMPLETE=$(grep -rlE "^created_at: [0-9]{4}-[0-9]{2}-[0-9]{2}$" "$WORK_DIR" 2>/dev/null)
  if [ -n "$INCOMPLETE" ]; then
    echo "[WARN] TD-001: timestamps incompletos en $WORK_DIR (fecha sin hora):"
    echo "$INCOMPLETE" | sed 's/^/  /'
    echo "  Corregir: created_at: YYYY-MM-DD → created_at: YYYY-MM-DD HH:MM:SS"
    ERRORS=$((ERRORS + 1))
  fi
done

# ── Check 2: Agentes en background — now-{agent-id}.md huérfanos ──────────────
# Si exists now-{agent-id}.md al cerrar sesión, el agente puede:
#   a) Seguir corriendo — sus notificaciones se pierden si la sesión se compacta
#   b) Haber terminado con status: completed — auto-limpiable
#   c) Haber terminado sin limpiar su archivo — WARN
# Referencia: subagent-patterns.md — "Limitaciones de notificación y compactación"
# Fix: now los agentes DEBEN incluir status: running|completed en su state file.
#   status: completed → auto-cleanup silencioso (no es riesgo real)
#   sin status o status: running → WARN (riesgo real de pérdida de resultado)
ORPHANED=()
AUTO_CLEANED=()
for CTX_DIR in "${CONTEXT_DIRS[@]}"; do
  while IFS= read -r -d '' f; do
    STATUS=$(grep -m1 "^status:" "$f" 2>/dev/null | sed 's/^status:[[:space:]]*//')
    if [ "$STATUS" = "completed" ]; then
      AUTO_CLEANED+=("$f")
      rm -f "$f"
    else
      ORPHANED+=("$f")
    fi
  done < <(find "$CTX_DIR" -maxdepth 1 -name "now-*.md" -print0 2>/dev/null)
done

if [ ${#AUTO_CLEANED[@]} -gt 0 ]; then
  echo "[INFO] AGENTES COMPLETADOS: ${#AUTO_CLEANED[@]} state file(s) con status:completed eliminados:"
  for f in "${AUTO_CLEANED[@]}"; do
    echo "  $f"
  done
fi

if [ ${#ORPHANED[@]} -gt 0 ]; then
  echo "[WARN] AGENTES EN BACKGROUND: ${#ORPHANED[@]} state file(s) de agente sin cerrar:"
  for f in "${ORPHANED[@]}"; do
    STATUS=$(grep -m1 "^status:" "$f" 2>/dev/null | sed 's/^status:[[:space:]]*//')
    echo "  $f  [status: ${STATUS:-ausente}]"
  done
  echo ""
  echo "  Riesgo: si la sesión se compacta antes de que el agente complete,"
  echo "  las notificaciones se pierden (bug documentado v2.1.83)."
  echo "  Antes de cerrar: verificar que el artefacto de resultado existe."
  echo "  Si el agente ya terminó: actualizar status: completed — el script lo eliminará solo."
  ERRORS=$((ERRORS + 1))
fi

# ── Check 3: Consistencia now.md — current_work vs WPs en disco ───────────────
NOW_FILE=""
[ -f ".thyrox/context/now.md" ] && NOW_FILE=".thyrox/context/now.md"
[ -f ".claude/context/now.md" ] && NOW_FILE=".claude/context/now.md"

if [ -n "$NOW_FILE" ]; then
  CURRENT_WORK=$(grep "^current_work:" "$NOW_FILE" | sed 's/^current_work:[[:space:]]*//')
  # Retrocompat: reconocer stage: (nuevo) o phase: (legacy)
  NOW_STAGE=$(grep "^stage:" "$NOW_FILE" 2>/dev/null | sed 's/^stage:[[:space:]]*//')
  [ -z "$NOW_STAGE" ] && NOW_STAGE=$(grep "^phase:" "$NOW_FILE" 2>/dev/null | sed 's/^phase:[[:space:]]*//')

  # Un WP se considera ACTIVO si tiene un *-task-plan.md con tareas pendientes (- [ ]).
  # WPs sin task-plan (abandonados en Phase 1-4) o con todas las tareas [x] no se cuentan.
  # Este criterio es más preciso que buscar lessons-learned, que depende de estructura de fases.
  THYROX_WPS=0
  THYROX_WP_LIST=""
  if [ -d ".thyrox/context/work" ]; then
    ACTIVE_LIST=""
    ACTIVE_COUNT=0
    while IFS= read -r -d '' wp_dir; do
      # Completado = tiene *-lessons-learned.md en cualquier nivel (raíz o track/)
      has_lessons=$(find "$wp_dir" -maxdepth 2 -name "*-lessons-learned.md" 2>/dev/null | head -1)
      [ -n "$has_lessons" ] && continue
      # Activo = sin lessons-learned Y con tareas pendientes en task-plan
      task_plan=$(find "$wp_dir" -maxdepth 2 -name "*-task-plan.md" 2>/dev/null | head -1)
      if [ -n "$task_plan" ] && grep -q "^- \[ \]" "$task_plan" 2>/dev/null; then
        ACTIVE_LIST="${ACTIVE_LIST}${wp_dir}"$'\n'
        ACTIVE_COUNT=$((ACTIVE_COUNT + 1))
      fi
    done < <(find ".thyrox/context/work" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
    THYROX_WPS=$ACTIVE_COUNT
    THYROX_WP_LIST="$ACTIVE_LIST"
  fi

  # now.md dice null pero hay WPs incompletos en .thyrox/context/work/
  if [ "$CURRENT_WORK" = "null" ] && [ "$THYROX_WPS" -gt 0 ]; then
    echo "[WARN] INCONSISTENCIA: $NOW_FILE::current_work es null pero existen $THYROX_WPS WP(s) activo(s):"
    echo "$THYROX_WP_LIST" | sed 's/^/  /'
    echo "  Actualizar current_work en $NOW_FILE antes de cerrar sesión."
    ERRORS=$((ERRORS + 1))
  fi

  # now.md apunta a WP que no existe en disco
  if [ -n "$CURRENT_WORK" ] && [ "$CURRENT_WORK" != "null" ]; then
    if [ ! -d "$CURRENT_WORK" ]; then
      # BLOCK messages a stderr para que el modelo los vea (exit 2 relaya stderr).
      # Si fueran a stdout, el modelo solo ve "No stderr output" y entra en loop
      # de respuestas vacias sin saber la causa. Ver WP
      # 2026-04-29-06-43-02-stop-hook-loop-investigation.
      {
        echo "[BLOCK] INCONSISTENCIA: $NOW_FILE::current_work apunta a directorio inexistente:"
        echo "  $CURRENT_WORK"
        echo "  Corregir la ruta o actualizar current_work a null si el WP cerró."
        echo "  Si no hay WP activo, es OK terminar la sesion explicitamente."
      } >&2
      ERRORS=$((ERRORS + 1))
      BLOCK_COUNT=$((BLOCK_COUNT + 1))
    fi
  fi
fi

# ── Check 4: Gate files huérfanos — eval sin merged (T-034) ──────────────────
# gate-{stage}-eval-*.json sin gate-{stage}-merged.json → evaluadores sin consolidar
# Ver: .claude/references/parallel-agent-state-files.md
for CTX_DIR in "${CONTEXT_DIRS[@]}"; do
  GATE_EVALS=$(find "$CTX_DIR" -name "gate-*-eval-*.json" 2>/dev/null | wc -l)
  if [ "$GATE_EVALS" -gt 0 ]; then
    echo "[WARN] $GATE_EVALS gate eval file(s) huérfanos detectados en $CTX_DIR:"
    find "$CTX_DIR" -name "gate-*-eval-*.json" 2>/dev/null | sed 's/^/  /'
    echo "  El Merger puede no haber consolidado estos evaluadores."
    echo "  Ver: .claude/references/parallel-agent-state-files.md"
    ERRORS=$((ERRORS + 1))
  fi
done

# ── Resumen ───────────────────────────────────────────────────────────────────
if [ "$ERRORS" -eq 0 ]; then
  echo "✓ validate-session-close: sin problemas detectados"
else
  echo ""
  if [ "$BLOCK_COUNT" -gt 0 ]; then
    echo "  ($BLOCK_COUNT bloqueo(s) BLOCK, $((ERRORS - BLOCK_COUNT)) advertencia(s) WARN — sesion BLOQUEADA)"
  else
    echo "  ($ERRORS advertencia(s) WARN — el Stop hook no se bloquea, pero revisar antes de cerrar)"
  fi
fi

[ "$BLOCK_COUNT" -gt 0 ] && exit 2 || exit 0
