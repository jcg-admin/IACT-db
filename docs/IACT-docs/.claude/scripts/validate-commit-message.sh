#!/usr/bin/env bash
# validate-commit-message.sh — PreToolUse hook para Bash(git commit *)
# Valida que git commit use Conventional Commits (I-005)
# Input: JSON via stdin con tool_name y tool_input.command
# Output: JSON via stdout con permissionDecision

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null || echo "")

if [ "$TOOL_NAME" != "Bash" ]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# Solo interceptar git commit
if ! echo "$COMMAND" | grep -qE "git commit"; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

# Extraer mensaje del commit (dobles comillas o simples)
MSG=$(echo "$COMMAND" | grep -oP '(?<=-m ")[^"]+' 2>/dev/null || true)
if [ -z "$MSG" ]; then
  MSG=$(echo "$COMMAND" | grep -oP "(?<=-m ')[^']+" 2>/dev/null || true)
fi

if [ -z "$MSG" ]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

# Validar formato Conventional Commits
PATTERN='^(feat|fix|refactor|docs|chore|test|perf)(\(.+\))?: .{1,72}$'
FIRST_LINE=$(echo "$MSG" | head -1)

if ! echo "$FIRST_LINE" | grep -qP "$PATTERN"; then
  REASON="Commit message no cumple Conventional Commits (I-005). Formato requerido: type(scope): description (max 72 chars). Tipos validos: feat|fix|refactor|docs|chore|test|perf. Mensaje recibido: \"$FIRST_LINE\""
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"reason\":\"$REASON\"}}"
  exit 0
fi

echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
