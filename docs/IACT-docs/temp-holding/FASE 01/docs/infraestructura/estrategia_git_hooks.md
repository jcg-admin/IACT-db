---
id: DOC-ESTRATEGIA-GIT-HOOKS
tipo: estrategia
estado: activo
propietario: equipo-infraestructura
ultima_actualizacion: 2025-11-09
date: 2025-11-13
---

# Estrategia de Git Hooks para Validación Local

**Objetivo**: Crear sistema de hooks Git que validen calidad ANTES de push, reduciendo dependencia de CI/CD remoto.

**Inspiración**: Hook pre-rebase de Git (ejemplo proporcionado) + pre-commit hook de emojis (funcionando).

---

## CONTEXTO: Por Qué Hooks Git

### Problema Actual

**GitHub Actions (CI/CD remoto)**:
- Desarrollador hace commit → push → espera 5-10 minutos → CI falla
- Ciclo lento: commit → push → wait → fail → fix → repeat
- Desperdicia tiempo y recursos de GitHub Actions

**Solución: Validación Local con Hooks**:
- Desarrollador intenta commit → hook valida → falla INMEDIATAMENTE
- Ciclo rápido: write → validate local → fix → commit
- Ahorra tiempo (segundos vs minutos)

### Ejemplo Real (funcionó hoy):

```bash
# Intenté commitear con emojis (checkmarks)
git commit -m "..."

# Pre-commit hook detectó:
ERROR: Emojis detectados en ANALISIS_REFACTORING_CPYTHON.md
  Línea 71: checkmark
  Línea 72: checkmark
  Línea 73: checkmark

COMMIT RECHAZADO

# Arreglé inmediatamente, commit OK
# AHORRO: ~5-10 min esperando GitHub Actions
```

---

## ESTRATEGIA: Sistema de Hooks en Cascada

### Hooks por Etapa del Desarrollo

```
pre-commit          → Validaciones rápidas (emojis, syntax, formato)
    ↓
commit-msg          → Conventional Commits format
    ↓
pre-push            → Validaciones pesadas (tests, linting completo)
    ↓
pre-rebase          → Proteger branches publicadas (como ejemplo)
```

---

## HOOKS PROPUESTOS

### 1. pre-commit (YA EXISTE - mejorar)

**Estado**: Funcional (solo emojis)

**Mejoras propuestas**:
```bash
#!/bin/bash
# .git/hooks/pre-commit
# Validaciones RÁPIDAS antes de commit

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common functions
source "$PROJECT_ROOT/scripts/lib/common.sh"
source "$PROJECT_ROOT/scripts/lib/exit_codes.sh"

FAILED=0

echo ""
echo "PRE-COMMIT VALIDATIONS"
echo "======================"
echo ""

# Validation 1: NO emojis (CRITICAL - ya funciona)
echo "[1/5] Checking for emojis..."
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -n "$STAGED_FILES" ]; then
    if python "$PROJECT_ROOT/scripts/workflows/check_no_emojis.py" $STAGED_FILES; then
        log_success "No emojis found"
    else
        log_error "Emojis detected (see above)"
        FAILED=$((FAILED + 1))
    fi
fi

# Validation 2: Shell script syntax (NUEVO)
echo ""
echo "[2/5] Checking shell script syntax..."
for file in $STAGED_FILES; do
    if [[ "$file" == *.sh ]]; then
        if ! bash -n "$file" 2>/dev/null; then
            log_error "Syntax error in $file"
            FAILED=$((FAILED + 1))
        fi
    fi
done
log_success "Shell syntax OK"

# Validation 3: Python syntax (NUEVO)
echo ""
echo "[3/5] Checking Python syntax..."
for file in $STAGED_FILES; do
    if [[ "$file" == *.py ]]; then
        if ! python -m py_compile "$file" 2>/dev/null; then
            log_error "Syntax error in $file"
            FAILED=$((FAILED + 1))
        fi
    fi
done
log_success "Python syntax OK"

# Validation 4: NO debug statements (NUEVO)
echo ""
echo "[4/5] Checking for debug statements..."
for file in $STAGED_FILES; do
    if [[ "$file" == *.py ]]; then
        if grep -n "import pdb\|breakpoint()" "$file" 2>/dev/null; then
            log_error "Debug statement found in $file"
            FAILED=$((FAILED + 1))
        fi
    fi
    if [[ "$file" == *.sh ]]; then
        if grep -n "set -x" "$file" 2>/dev/null; then
            log_warning "Debug mode (set -x) found in $file"
        fi
    fi
done
log_success "No debug statements"

# Validation 5: File size check (NUEVO)
echo ""
echo "[5/5] Checking file sizes..."
for file in $STAGED_FILES; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        if [ "$size" -gt 1048576 ]; then  # 1MB
            log_error "File too large: $file ($(($size / 1024))KB)"
            FAILED=$((FAILED + 1))
        fi
    fi
done
log_success "File sizes OK"

echo ""
echo "======================"
if [ $FAILED -eq 0 ]; then
    log_success "PRE-COMMIT PASSED"
    exit 0
else
    log_error "PRE-COMMIT FAILED: $FAILED validation(s) failed"
    echo ""
    echo "Fix the issues above and try again."
    exit 1
fi
```

**Tiempo ejecución**: <5 segundos
**Validaciones**: 5 checks rápidos

---

### 2. commit-msg (NUEVO - crítico)

**Propósito**: Validar formato Conventional Commits

```bash
#!/bin/bash
# .git/hooks/commit-msg
# Valida formato de commit message

set -euo pipefail

readonly COMMIT_MSG_FILE="$1"
readonly COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Conventional Commits format
# tipo(scope): descripción
#
# Tipos válidos: feat, fix, docs, refactor, test, chore, perf
PATTERN='^(feat|fix|docs|refactor|test|chore|perf|style|ci|build)(\([a-z0-9\-]+\))?: .{1,72}'

if ! echo "$COMMIT_MSG" | head -1 | grep -qE "$PATTERN"; then
    echo ""
    echo "=========================================="
    echo "COMMIT MESSAGE FORMAT ERROR"
    echo "=========================================="
    echo ""
    echo "Commit message must follow Conventional Commits format:"
    echo ""
    echo "  tipo(scope): descripción breve"
    echo ""
    echo "Valid types:"
    echo "  - feat:     New feature"
    echo "  - fix:      Bug fix"
    echo "  - docs:     Documentation"
    echo "  - refactor: Code refactoring"
    echo "  - test:     Tests"
    echo "  - chore:    Maintenance"
    echo "  - perf:     Performance"
    echo ""
    echo "Examples:"
    echo "  feat(auth): implement JWT authentication"
    echo "  fix(api): correct user validation logic"
    echo "  docs(readme): update installation instructions"
    echo ""
    echo "Your message:"
    echo "  $COMMIT_MSG"
    echo ""
    exit 1
fi

# Check for NO emojis in commit message
if echo "$COMMIT_MSG" | python -c "
import sys
import re
emojis = re.compile(r'[\U0001F300-\U0001F9FF]')
text = sys.stdin.read()
if emojis.search(text):
    print('ERROR: Emojis found in commit message')
    sys.exit(1)
"; then
    :  # OK
else
    echo ""
    echo "ERROR: Emojis detected in commit message"
    echo "The project does NOT allow emojis anywhere."
    echo ""
    exit 1
fi

exit 0
```

**Tiempo**: <1 segundo
**Beneficio**: Commits consistentes, changelog automático posible

---

### 3. pre-push (NUEVO - importante)

**Propósito**: Validaciones pesadas ANTES de push (evita esperar GitHub Actions)

```bash
#!/bin/bash
# .git/hooks/pre-push
# Validaciones completas antes de push

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/lib/common.sh"

FAILED=0

echo ""
echo "PRE-PUSH VALIDATIONS"
echo "===================="
echo ""

# Validation 1: Run tests
echo "[1/4] Running tests..."
if pytest tests/ -q --tb=no 2>/dev/null; then
    log_success "Tests passed"
else
    log_error "Tests failed"
    FAILED=$((FAILED + 1))
fi

# Validation 2: Linting (if applicable)
echo ""
echo "[2/4] Running linters..."
if command -v ruff >/dev/null 2>&1; then
    if ruff check scripts/ --quiet 2>/dev/null; then
        log_success "Linting passed"
    else
        log_error "Linting failed"
        FAILED=$((FAILED + 1))
    fi
else
    log_warning "Ruff not installed, skipping linting"
fi

# Validation 3: Shell scripts constitution (NUEVO - relacionado con refactoring)
echo ""
echo "[3/4] Validating shell scripts constitution..."
if [ -f "$PROJECT_ROOT/scripts/validation/quality/validate_shell_constitution.sh" ]; then
    if bash "$PROJECT_ROOT/scripts/validation/quality/validate_shell_constitution.sh"; then
        log_success "Shell constitution OK"
    else
        log_error "Shell constitution violations"
        FAILED=$((FAILED + 1))
    fi
else
    log_warning "Shell constitution validator not found (will be created in refactoring)"
fi

# Validation 4: Check for large files
echo ""
echo "[4/4] Checking for large files..."
LARGE_FILES=$(find . -type f -size +1M -not -path "./.git/*" 2>/dev/null | head -5)
if [ -n "$LARGE_FILES" ]; then
    log_warning "Large files detected (may slow down repo):"
    echo "$LARGE_FILES"
fi

echo ""
echo "===================="
if [ $FAILED -eq 0 ]; then
    log_success "PRE-PUSH PASSED"
    echo ""
    echo "Pushing to remote..."
    exit 0
else
    log_error "PRE-PUSH FAILED: $FAILED validation(s) failed"
    echo ""
    echo "Fix the issues and try again."
    echo ""
    echo "To bypass (NOT recommended):"
    echo "  git push --no-verify"
    echo ""
    exit 1
fi
```

**Tiempo**: 30-60 segundos (tests completos)
**Beneficio**: Detecta problemas ANTES de push (ahorra 5-10 min de CI/CD)

---

### 4. pre-rebase (OPCIONAL - como ejemplo)

**Propósito**: Proteger branches publicadas de rebase (similar al ejemplo)

```bash
#!/bin/bash
# .git/hooks/pre-rebase
# Previene rebase de branches ya publicadas

set -euo pipefail

# Branches protegidas (no se pueden rebase)
readonly PROTECTED_BRANCHES="main develop"

basebranch="$1"
topic="${2:-HEAD}"

# Obtener branch actual
current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")

echo ""
echo "PRE-REBASE CHECK"
echo "================"
echo "Rebasing: $current_branch onto $basebranch"
echo ""

# Check 1: NO rebase de branches protegidas
for protected in $PROTECTED_BRANCHES; do
    if [ "$current_branch" = "$protected" ]; then
        echo "ERROR: Cannot rebase protected branch: $protected"
        echo ""
        echo "Protected branches should not be rebased."
        echo "Create a feature branch instead:"
        echo "  git checkout -b feature/my-feature"
        echo ""
        exit 1
    fi
done

# Check 2: Verificar si branch ya fue pusheada
if git branch -r | grep -q "origin/$current_branch"; then
    echo "WARNING: Branch '$current_branch' exists on remote"
    echo ""
    echo "Rebasing a published branch rewrites history and may"
    echo "cause issues for other developers."
    echo ""
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Rebase cancelled."
        exit 1
    fi
fi

echo "Rebase allowed. Proceeding..."
exit 0
```

**Beneficio**: Evita problemas de historia reescrita en branches compartidas

---

## COMPARACIÓN: Hooks vs GitHub Actions

| Aspecto | Git Hooks (Local) | GitHub Actions (Remote) |
|---------|-------------------|-------------------------|
| **Velocidad** | <5 seg (pre-commit) | 5-10 min |
| **Feedback** | INMEDIATO | Esperar push + queue |
| **Costo** | Gratis (CPU local) | Minutos de GitHub |
| **Offline** | Funciona | NO funciona |
| **Bypass** | --no-verify | Difícil |
| **Coverage** | Básico (rápido) | Completo (lento) |

**Estrategia óptima**: AMBOS
- Hooks: Validaciones rápidas, feedback inmediato
- GitHub Actions: Validaciones completas, gatekeeper final

---

## INTEGRACIÓN CON ESTRATEGIAS DOCUMENTADAS

### 1. Con Migración GitHub Actions → Shell Scripts

```bash
# Los scripts que migremos de GitHub Actions pueden reutilizarse en hooks

# GitHub Actions usa:
.github/workflows/emoji-validation.yml
  → scripts/workflows/check_no_emojis.py

# Pre-commit hook usa:
.git/hooks/pre-commit
  → scripts/workflows/check_no_emojis.py  # MISMO SCRIPT

# Beneficio: DRY (Don't Repeat Yourself)
```

### 2. Con Refactoring CPython Builder

```bash
# Shell scripts refactorizados pueden validarse en pre-push

# pre-push hook usa:
.git/hooks/pre-push
  → scripts/validation/quality/validate_shell_constitution.sh
      → valida utils/logger.sh
      → valida utils/validator.sh
      → etc.

# Beneficio: Constitution enforcement local
```

### 3. Con Shell Scripts Constitution

```bash
# Constitution principles se validan en hooks

CONSTITUTION RULES:
1. Single responsibility    → validate_shell_constitution.sh (pre-push)
2. Backward compatible      → test_regression.sh (pre-push)
3. Explicit error handling  → validate_shell_constitution.sh
4. NO emojis                → check_no_emojis.py (pre-commit)
```

---

## INSTALACIÓN AUTOMATIZADA

### Problema: Hooks no se commitean

Git hooks están en `.git/hooks/` (no tracked por Git).

**Solución**: Script de instalación

```bash
#!/bin/bash
# scripts/install_hooks.sh
# Instala hooks de Git automáticamente

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
readonly HOOKS_TEMPLATES="$PROJECT_ROOT/scripts/git-hooks"

echo "Installing Git hooks..."
echo ""

# Crear directorio si no existe
mkdir -p "$HOOKS_DIR"

# Copiar hooks
for hook in pre-commit commit-msg pre-push pre-rebase; do
    if [ -f "$HOOKS_TEMPLATES/$hook" ]; then
        echo "Installing $hook..."
        cp "$HOOKS_TEMPLATES/$hook" "$HOOKS_DIR/$hook"
        chmod +x "$HOOKS_DIR/$hook"
        echo "  - Installed: $HOOKS_DIR/$hook"
    fi
done

echo ""
echo "Git hooks installed successfully!"
echo ""
echo "To test:"
echo "  - Make a commit (pre-commit will run)"
echo "  - Push changes (pre-push will run)"
echo ""
echo "To bypass (NOT recommended):"
echo "  git commit --no-verify"
echo "  git push --no-verify"
echo ""
```

**Estructura**:
```
scripts/
├── git-hooks/           # Templates de hooks (committed a Git)
│   ├── pre-commit
│   ├── commit-msg
│   ├── pre-push
│   └── pre-rebase
└── install_hooks.sh     # Script de instalación
```

**Uso**:
```bash
# Después de clonar repo:
bash scripts/install_hooks.sh

# Hooks instalados automáticamente
```

---

## PLAN DE IMPLEMENTACIÓN

### FASE 0: Hooks Básicos (1 hora)

```bash
# Tareas:
1. Crear scripts/git-hooks/ directory
2. Mover pre-commit actual a template
3. Mejorar pre-commit (5 validaciones)
4. Crear commit-msg hook
5. Crear install_hooks.sh
6. Documentar en CONTRIBUTING.md

# Criterio éxito:
- [x] bash scripts/install_hooks.sh funciona
- [x] Hooks se instalan automáticamente
- [x] Pre-commit valida 5 cosas
- [x] Commit-msg valida Conventional Commits
```

### FASE 1: Hooks Avanzados (2 horas)

```bash
# Tareas:
1. Crear pre-push hook (tests + linting)
2. Crear pre-rebase hook (protección branches)
3. Integrar con shell constitution validator
4. Agregar a GitHub Actions (validar que hooks estén instalados)

# Criterio éxito:
- [x] Pre-push ejecuta tests completos
- [x] Pre-rebase protege main/develop
- [x] Shell constitution se valida localmente
```

### FASE 2: Optimización (1 hora)

```bash
# Tareas:
1. Caché de resultados (skip si no hay cambios)
2. Parallel execution (validaciones independientes)
3. Mensajes de error mejorados
4. Timing info (cuánto tardó cada validación)

# Criterio éxito:
- [x] Hooks más rápidos (>30% mejora)
- [x] Mensajes claros y accionables
```

---

## MÉTRICAS DE ÉXITO

**Antes (solo GitHub Actions)**:
```
Developer workflow:
1. Write code
2. Commit
3. Push
4. Wait 5-10 minutes
5. CI fails (emoji detected)
6. Fix locally
7. Commit + push again
8. Wait 5-10 minutes
9. CI passes

TOTAL: 10-20 minutos por ciclo
```

**Después (con Git Hooks)**:
```
Developer workflow:
1. Write code
2. Attempt commit
3. Pre-commit fails IMMEDIATELY (<5 sec)
4. Fix locally
5. Commit success
6. Attempt push
7. Pre-push runs tests (<60 sec)
8. Push success
9. GitHub Actions valida (5 min, pero async)

TOTAL: <2 minutos + async validation
AHORRO: 80-90% en tiempo de feedback
```

---

## BENEFICIOS ESPERADOS

### 1. Desarrollo Más Rápido
- Feedback inmediato (<5 seg vs 5-10 min)
- Menos context switching
- Menos espera en GitHub Actions queue

### 2. Menos Uso de GitHub Actions
- Menos commits fallidos en CI
- Ahorro de minutos de GitHub Actions
- CI/CD solo para validaciones exhaustivas

### 3. Mejor Calidad de Código
- Commits limpios desde el principio
- Constitution enforcement automático
- NO emojis garantizado

### 4. Mejor Developer Experience
- Errores detectados ANTES de push
- Mensajes de error claros y locales
- Trabaja offline

---

## RELACIÓN CON EJEMPLO DE pre-rebase

**Tu ejemplo** (pre-rebase de Git):
```bash
# Previene rebase de branches publicadas
# Usa lógica compleja de rev-list
# Protege workflow de desarrollo
```

**Mi propuesta** (simplificada pero efectiva):
```bash
# Mismo objetivo: proteger branches publicadas
# Lógica más simple (branches protegidas + check remoto)
# Adaptada a workflow del proyecto
```

**Similitudes**:
- Ambos previenen operaciones peligrosas
- Ambos protegen historia publicada
- Ambos son educativos (explican por qué fallan)

**Diferencias**:
- Tu ejemplo: complejo (Perl + rev-list)
- Mi propuesta: simple (bash + git branch -r)
- Tu ejemplo: workflow next/master/topic
- Mi propuesta: workflow main/develop/feature

---

## RESPUESTA DIRECTA A TU PREGUNTA

**"¿Estás considerando hacer algo así?"**

**SÍ**, pero adaptado al proyecto:

1. **pre-commit**: YA EXISTE (emojis) → MEJORAR (5 validaciones)
2. **commit-msg**: CREAR (Conventional Commits)
3. **pre-push**: CREAR (tests + constitution)
4. **pre-rebase**: CREAR (protección branches, inspirado en tu ejemplo)

**PERO** más simple y mantenible que el ejemplo complejo de Git.

---

## PRÓXIMOS PASOS

¿Quieres que proceda a implementar esta estrategia de hooks?

**Orden recomendado**:
1. HOY: Mejorar pre-commit (5 validaciones)
2. HOY: Crear commit-msg (Conventional Commits)
3. MAÑANA: Crear pre-push (tests)
4. MAÑANA: Crear install_hooks.sh
5. OPCIONAL: pre-rebase (protección branches)

**Tiempo total**: 3-4 horas
**Beneficio**: Ahorro 80-90% tiempo de feedback

¿Procedo?
