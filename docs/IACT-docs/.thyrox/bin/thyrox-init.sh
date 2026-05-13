#!/usr/bin/env bash
# bin/thyrox-init.sh
# Inicializa la estructura THYROX en el proyecto destino.
# Reemplaza setup-template.sh. Idempotente: seguro ejecutar múltiples veces.
#
# Ejecutado por hooks/hooks.json en SessionStart cuando .thyrox/context/ no existe.
# También puede ejecutarse manualmente: bash bin/thyrox-init.sh

set -euo pipefail

THYROX_CTX=".thyrox/context"
CLAUDE_DIR=".claude"

log() { echo "[thyrox-init] $*"; }

# Guard de idempotencia
if [ -d "$THYROX_CTX" ]; then
    log "Ya inicializado — .thyrox/context/ existe. Nada que hacer."
    exit 0
fi

log "Inicializando estructura THYROX en $(pwd)..."

# T-007: Crear .thyrox/context/ con subdirectorios
mkdir -p "$THYROX_CTX/work"
mkdir -p "$THYROX_CTX/decisions"
mkdir -p "$THYROX_CTX/errors"
mkdir -p "$THYROX_CTX/research"
log "Creado: .thyrox/context/ y subdirectorios"

TODAY=$(date +%Y-%m-%d)
NOW=$(date '+%Y-%m-%d %H:%M:%S')

# T-008: now.md, focus.md, project-state.md
cat > "$THYROX_CTX/now.md" << EOF
\`\`\`yml
type: Estado de Sesión
version: 1.0
updated_at: $NOW
cold_boot: true
last_session: null
current_work: null
phase: null
blockers: []
\`\`\`

# Contexto

Primera sesión. THYROX inicializado. Listo para Phase 1: DISCOVER.
EOF
log "Creado: .thyrox/context/now.md"

cat > "$THYROX_CTX/focus.md" << EOF
\`\`\`yml
type: Dirección Actual
version: 1.0
updated_at: $NOW
\`\`\`

# Focus

Proyecto recién inicializado con THYROX.

## Siguiente paso

Invocar \`/thyrox:discover\` para empezar Phase 1 del primer work package.
EOF
log "Creado: .thyrox/context/focus.md"

cat > "$THYROX_CTX/project-state.md" << EOF
\`\`\`yml
type: Estado del Proyecto
version: 0.1.0
updated_at: $NOW
\`\`\`

# Project State

**Versión:** 0.1.0
**Estado:** Inicialización
**Plugin:** thyrox

## Setup completado

- [x] THYROX inicializado ($TODAY)
- [ ] Phase 1 DISCOVER — definir primer work package
EOF
log "Creado: .thyrox/context/project-state.md"

cat > "$THYROX_CTX/technical-debt.md" << EOF
\`\`\`yml
type: Backlog de Deuda Técnica
version: 1.0
updated_at: $NOW
\`\`\`

# Technical Debt

Sin entradas. Registrar TDs aquí a medida que se identifiquen.
EOF
log "Creado: .thyrox/context/technical-debt.md"

# T-009: ROADMAP.md y CHANGELOG.md (solo si no existen)
if [ ! -f "ROADMAP.md" ]; then
cat > "ROADMAP.md" << EOF
\`\`\`yml
type: Plan Maestro
version: 0.1.0
updated_at: $NOW
\`\`\`

# ROADMAP

## Convenciones

- \`[ ]\` = Pendiente
- \`[-]\` = En Progreso
- \`[x]\` = Completado (YYYY-MM-DD)

---

## FASE 1 — (por definir)

- [ ] Phase 1 DISCOVER — definir el problema

---

**Última actualización:** $TODAY
EOF
log "Creado: ROADMAP.md"
fi

if [ ! -f "CHANGELOG.md" ]; then
cat > "CHANGELOG.md" << EOF
\`\`\`yml
type: Changelog
version: 0.1.0
updated_at: $NOW
\`\`\`

# Changelog

## [0.1.0] - $TODAY

### Added
- Inicializado con THYROX plugin
EOF
log "Creado: CHANGELOG.md"
fi

# T-010: .claude/settings.json con permisos mínimos (solo si no existe)
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    mkdir -p "$CLAUDE_DIR"
cat > "$CLAUDE_DIR/settings.json" << EOF
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Edit(/ROADMAP.md)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git push *)",
      "Bash(git status)",
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(git fetch *)",
      "Bash(git branch *)",
      "Bash(date *)",
      "Bash(mkdir *)",
      "Bash(ls *)",
      "Bash(echo *)"
    ],
    "ask": [
      "Edit(/.claude/settings.json)"
    ],
    "deny": [
      "Bash(git push --force *)",
      "Bash(git push --force-with-lease *)",
      "Bash(git reset --hard *)",
      "Bash(rm -rf *)"
    ]
  }
}
EOF
log "Creado: .claude/settings.json"
fi

log "Inicialización completa."
log "Abre Claude Code y ejecuta /thyrox:discover para empezar."
