---
title: LLD - Scripts Helpers y Utilidades
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: design
subfase: lld_scripts_helpers
proyecto: IACT---project
parent_doc: LLD_00_OVERVIEW.md
status: in_progress
version: 1.0
---

# Low-Level Design: Scripts Helpers y Utilidades

**Issue**: IACT-AUTO-001
**Fase**: FASE 3 - DESIGN (Low-Level Design)
**Fecha**: 2025-11-13
**Parent**: LLD_00_OVERVIEW.md v1.0

---

## Proposito

Este documento especifica:
1. **Scripts nuevos** a crear para el sistema de automatizacion
2. **Modificaciones** a scripts existentes para integracion
3. **Utilidades compartidas** para logging, colores, validaciones

**Audiencia**: Desarrollador implementando scripts auxiliares

---

## 1. Scripts Nuevos a Crear

### 1.1 check_ui_api_coherence.sh

**Ubicacion**: `scripts/check_ui_api_coherence.sh`
**Proposito**: Detectar cambios en API sin tests UI correspondientes (Regla R3)
**Invocado por**: constitucion.sh (regla R3_ui_api_coherence)

#### 1.1.1 Especificacion Funcional

**Input**:
- Git diff desde branch base (main o develop)
- Archivos modificados en `api/` y `ui/`

**Output**:
- Exit code 0: Coherencia OK
- Exit code 1: Incoherencia detectada (warning, no bloquea)
- JSON report con detalles

**Logica**:
```
SI cambios en api/callcentersite/views.py O api/callcentersite/serializers.py:
    ENTONCES verificar:
        - Existen tests nuevos/modificados en ui/src/__tests__/?
        - Existen archivos modificados en ui/src/services/?
    SI NO:
        RETURN warning "API modificada sin tests UI"
```

#### 1.1.2 Codigo Completo

```bash
#!/usr/bin/env bash
# scripts/check_ui_api_coherence.sh
# Detecta cambios en API sin tests UI correspondientes
# Exit: 0=coherente, 1=incoherente (warning)

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils/logging.sh"
source "$SCRIPT_DIR/utils/colors.sh"

# Configuration
BASE_BRANCH="${1:-main}"
OUTPUT_JSON="${2:-/tmp/ui_api_coherence.json}"

main() {
    log_info "Verificando coherencia UI/API..."

    local api_changes
    local ui_changes
    local incoherent=0

    # Detect API changes
    api_changes=$(git diff --name-only "$BASE_BRANCH"...HEAD | grep -E '^api/callcentersite/(views|serializers|urls)\.py$' || true)

    if [ -z "$api_changes" ]; then
        log_success "No hay cambios en API"
        write_report "coherent" "No API changes detected"
        exit 0
    fi

    log_warn "Cambios detectados en API:"
    echo "$api_changes" | while read -r file; do
        echo "  - $file"
    done

    # Check UI tests
    ui_test_changes=$(git diff --name-only "$BASE_BRANCH"...HEAD | grep -E '^ui/src/__tests__/.*\.(test|spec)\.(js|jsx|ts|tsx)$' || true)

    # Check UI services (API integration)
    ui_service_changes=$(git diff --name-only "$BASE_BRANCH"...HEAD | grep -E '^ui/src/services/.*\.(js|jsx|ts|tsx)$' || true)

    if [ -z "$ui_test_changes" ] && [ -z "$ui_service_changes" ]; then
        log_warn "ADVERTENCIA: Cambios en API sin tests o servicios UI"
        write_report "incoherent" "API changes without UI tests or services"
        incoherent=1
    else
        log_success "Coherencia verificada: tests/servicios UI encontrados"
        write_report "coherent" "UI tests or services updated alongside API"
    fi

    exit $incoherent
}

write_report() {
    local status="$1"
    local message="$2"

    cat > "$OUTPUT_JSON" <<EOF
{
  "check": "ui_api_coherence",
  "status": "$status",
  "message": "$message",
  "timestamp": "$(date -Iseconds)",
  "api_changes": $(git diff --name-only "$BASE_BRANCH"...HEAD | grep -E '^api/' | jq -R . | jq -s . || echo "[]"),
  "ui_changes": $(git diff --name-only "$BASE_BRANCH"...HEAD | grep -E '^ui/' | jq -R . | jq -s . || echo "[]")
}
EOF
}

main "$@"
```

**Permisos**: `chmod +x scripts/check_ui_api_coherence.sh`

**Dependencias**:
- git
- jq (JSON processing)
- scripts/utils/logging.sh
- scripts/utils/colors.sh

---

### 1.2 validate_devcontainer_env.sh

**Ubicacion**: `scripts/validate_devcontainer_env.sh`
**Proposito**: Validar entorno DevContainer completo (Regla R6)
**Invocado por**:
- constitucion.sh (regla R6_devcontainer_compatibility)
- infrastructure/devcontainer/scripts/post_create.sh

#### 1.2.1 Especificacion Funcional

**Input**: Ninguno
**Output**:
- Exit code 0: Entorno valido
- Exit code 1: Entorno invalido (warning, no bloquea)
- JSON report con checks

**Validaciones**:
1. Databases disponibles (PostgreSQL 5432, MariaDB 3306)
2. Python 3.12.x disponible
3. Node 18.x disponible
4. Dependencias sistema (yq, jq, git)
5. Permisos scripts (ejecutables)

#### 1.2.2 Codigo Completo

```bash
#!/usr/bin/env bash
# scripts/validate_devcontainer_env.sh
# Valida entorno DevContainer completo
# Exit: 0=valido, 1=invalido

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/utils/logging.sh"
source "$SCRIPT_DIR/utils/colors.sh"

OUTPUT_JSON="${1:-/tmp/devcontainer_validation.json}"

declare -a CHECKS_PASSED=()
declare -a CHECKS_FAILED=()

main() {
    log_info "Validando entorno DevContainer..."

    check_databases
    check_python_version
    check_node_version
    check_dependencies
    check_script_permissions

    # Generate report
    local total=$((${#CHECKS_PASSED[@]} + ${#CHECKS_FAILED[@]}))
    local passed=${#CHECKS_PASSED[@]}

    write_report

    if [ ${#CHECKS_FAILED[@]} -gt 0 ]; then
        log_error "Validacion fallida: $passed/$total checks pasaron"
        exit 1
    else
        log_success "Validacion completa: $passed/$total checks pasaron"
        exit 0
    fi
}

check_databases() {
    log_info "Verificando bases de datos..."

    # PostgreSQL
    if nc -z localhost 5432 2>/dev/null; then
        CHECKS_PASSED+=("postgresql:5432")
        log_success "  PostgreSQL (5432): OK"
    else
        CHECKS_FAILED+=("postgresql:5432")
        log_error "  PostgreSQL (5432): FAIL"
    fi

    # MariaDB
    if nc -z localhost 3306 2>/dev/null; then
        CHECKS_PASSED+=("mariadb:3306")
        log_success "  MariaDB (3306): OK"
    else
        CHECKS_FAILED+=("mariadb:3306")
        log_error "  MariaDB (3306): FAIL"
    fi
}

check_python_version() {
    log_info "Verificando Python..."

    if command -v python3 &>/dev/null; then
        local py_version=$(python3 --version | awk '{print $2}')
        if [[ "$py_version" =~ ^3\.12\. ]]; then
            CHECKS_PASSED+=("python:$py_version")
            log_success "  Python $py_version: OK"
        else
            CHECKS_FAILED+=("python:$py_version")
            log_warn "  Python $py_version: ADVERTENCIA (esperado 3.12.x)"
        fi
    else
        CHECKS_FAILED+=("python:missing")
        log_error "  Python: NO ENCONTRADO"
    fi
}

check_node_version() {
    log_info "Verificando Node.js..."

    if command -v node &>/dev/null; then
        local node_version=$(node --version | sed 's/v//')
        if [[ "$node_version" =~ ^18\. ]]; then
            CHECKS_PASSED+=("node:$node_version")
            log_success "  Node.js $node_version: OK"
        else
            CHECKS_FAILED+=("node:$node_version")
            log_warn "  Node.js $node_version: ADVERTENCIA (esperado 18.x)"
        fi
    else
        CHECKS_FAILED+=("node:missing")
        log_error "  Node.js: NO ENCONTRADO"
    fi
}

check_dependencies() {
    log_info "Verificando dependencias sistema..."

    local deps=("git" "jq" "yq" "nc")
    for dep in "${deps[@]}"; do
        if command -v "$dep" &>/dev/null; then
            CHECKS_PASSED+=("dep:$dep")
            log_success "  $dep: OK"
        else
            CHECKS_FAILED+=("dep:$dep")
            log_error "  $dep: NO ENCONTRADO"
        fi
    done
}

check_script_permissions() {
    log_info "Verificando permisos scripts..."

    local scripts=(
        "scripts/constitucion.sh"
        "scripts/ci-local.sh"
        "scripts/install_hooks.sh"
    )

    for script in "${scripts[@]}"; do
        local full_path="$PROJECT_ROOT/$script"
        if [ -f "$full_path" ]; then
            if [ -x "$full_path" ]; then
                CHECKS_PASSED+=("perm:$script")
                log_success "  $script: EJECUTABLE"
            else
                CHECKS_FAILED+=("perm:$script")
                log_error "  $script: NO EJECUTABLE"
            fi
        else
            CHECKS_FAILED+=("missing:$script")
            log_warn "  $script: NO EXISTE (pendiente instalacion)"
        fi
    done
}

write_report() {
    cat > "$OUTPUT_JSON" <<EOF
{
  "check": "devcontainer_environment",
  "timestamp": "$(date -Iseconds)",
  "summary": {
    "total": $((${#CHECKS_PASSED[@]} + ${#CHECKS_FAILED[@]})),
    "passed": ${#CHECKS_PASSED[@]},
    "failed": ${#CHECKS_FAILED[@]}
  },
  "checks_passed": $(printf '%s\n' "${CHECKS_PASSED[@]}" | jq -R . | jq -s .),
  "checks_failed": $(printf '%s\n' "${CHECKS_FAILED[@]}" | jq -R . | jq -s .)
}
EOF
}

main "$@"
```

**Permisos**: `chmod +x scripts/validate_devcontainer_env.sh`

---

### 1.3 validate_constitution_schema.sh

**Ubicacion**: `scripts/validate_constitution_schema.sh`
**Proposito**: Validar estructura .constitucion.yaml contra schema
**Invocado por**: constitucion.sh (auto-validacion)

#### 1.3.1 Especificacion Funcional

**Input**: Path a .constitucion.yaml
**Output**:
- Exit code 0: Schema valido
- Exit code 1: Schema invalido
- Lista de errores validacion

**Validaciones**:
1. Sintaxis YAML correcta
2. Campos requeridos presentes (version, principles, rules)
3. Tipos correctos (severity: error/warning)
4. Referencias validas (rule.principle_id existe)

#### 1.3.2 Codigo Completo

```bash
#!/usr/bin/env bash
# scripts/validate_constitution_schema.sh
# Valida .constitucion.yaml contra schema
# Exit: 0=valido, 1=invalido

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/utils/logging.sh"
source "$SCRIPT_DIR/utils/colors.sh"

CONSTITUTION_FILE="${1:-$PROJECT_ROOT/.constitucion.yaml}"

declare -a ERRORS=()

main() {
    log_info "Validando schema .constitucion.yaml..."

    if [ ! -f "$CONSTITUTION_FILE" ]; then
        log_error "Archivo no encontrado: $CONSTITUTION_FILE"
        exit 1
    fi

    validate_yaml_syntax
    validate_required_fields
    validate_principles
    validate_rules
    validate_references

    if [ ${#ERRORS[@]} -gt 0 ]; then
        log_error "Validacion fallida con ${#ERRORS[@]} errores:"
        for error in "${ERRORS[@]}"; do
            echo "  - $error"
        done
        exit 1
    else
        log_success "Schema valido"
        exit 0
    fi
}

validate_yaml_syntax() {
    if ! yq eval '.' "$CONSTITUTION_FILE" &>/dev/null; then
        ERRORS+=("Sintaxis YAML invalida")
    fi
}

validate_required_fields() {
    local version=$(yq eval '.version' "$CONSTITUTION_FILE")
    if [ "$version" = "null" ]; then
        ERRORS+=("Campo 'version' faltante")
    fi

    local principles=$(yq eval '.principles' "$CONSTITUTION_FILE")
    if [ "$principles" = "null" ]; then
        ERRORS+=("Campo 'principles' faltante")
    fi

    local rules=$(yq eval '.rules' "$CONSTITUTION_FILE")
    if [ "$rules" = "null" ]; then
        ERRORS+=("Campo 'rules' faltante")
    fi
}

validate_principles() {
    local count=$(yq eval '.principles | length' "$CONSTITUTION_FILE")

    for ((i=0; i<count; i++)); do
        local id=$(yq eval ".principles[$i].id" "$CONSTITUTION_FILE")
        local name=$(yq eval ".principles[$i].name" "$CONSTITUTION_FILE")

        if [ "$id" = "null" ]; then
            ERRORS+=("Principle $i: campo 'id' faltante")
        fi

        if [ "$name" = "null" ]; then
            ERRORS+=("Principle $i ($id): campo 'name' faltante")
        fi
    done
}

validate_rules() {
    local count=$(yq eval '.rules | length' "$CONSTITUTION_FILE")

    for ((i=0; i<count; i++)); do
        local id=$(yq eval ".rules[$i].id" "$CONSTITUTION_FILE")
        local severity=$(yq eval ".rules[$i].severity" "$CONSTITUTION_FILE")

        if [ "$id" = "null" ]; then
            ERRORS+=("Rule $i: campo 'id' faltante")
        fi

        if [ "$severity" != "error" ] && [ "$severity" != "warning" ]; then
            ERRORS+=("Rule $i ($id): severity debe ser 'error' o 'warning', encontrado: '$severity'")
        fi
    done
}

validate_references() {
    # Extract all principle IDs
    local principle_ids=$(yq eval '.principles[].id' "$CONSTITUTION_FILE")

    # Check each rule references valid principle
    local rule_count=$(yq eval '.rules | length' "$CONSTITUTION_FILE")

    for ((i=0; i<rule_count; i++)); do
        local rule_id=$(yq eval ".rules[$i].id" "$CONSTITUTION_FILE")
        local principle_id=$(yq eval ".rules[$i].principle_id" "$CONSTITUTION_FILE")

        if [ "$principle_id" != "null" ]; then
            if ! echo "$principle_ids" | grep -qx "$principle_id"; then
                ERRORS+=("Rule $rule_id: referencia a principle_id '$principle_id' no existe")
            fi
        fi
    done
}

main "$@"
```

**Permisos**: `chmod +x scripts/validate_constitution_schema.sh`

---

## 2. Modificaciones a Scripts Existentes

### 2.1 scripts/install_hooks.sh

**Archivo**: `scripts/install_hooks.sh`
**Modificacion**: Agregar mensaje sobre sistema constitucion

#### 2.1.1 Cambio a Aplicar

**Ubicacion**: Despues de linea 63 (mensaje hooks instalados)

**Agregar**:
```bash
echo "Sistema de Constitucion:"
echo "  - Archivo:       .constitucion.yaml"
echo "  - Validador:     scripts/constitucion.sh"
echo "  - Integracion:   pre-push hook"
echo "  - Validar:       ./scripts/constitucion.sh --mode=manual"
echo ""
```

**Resultado**: Usuario informado sobre sistema constitucion al instalar hooks

---

### 2.2 scripts/git-hooks/pre-push

**Archivo**: `scripts/git-hooks/pre-push`
**Modificacion**: Invocar constitucion.sh antes de tests

#### 2.2.1 Codigo a Agregar

**Ubicacion**: Antes de ejecutar tests (antes de run_all_tests.sh)

```bash
# Validate constitution
echo "Validando constitucion..."
if [ -f "$PROJECT_ROOT/scripts/constitucion.sh" ]; then
    if ! "$PROJECT_ROOT/scripts/constitucion.sh" --mode=pre-push; then
        echo "ERROR: Validacion constitucion fallida"
        echo "Review: $PROJECT_ROOT/.constitucion.yaml"
        echo ""
        echo "Bypass (NO recomendado): git push --no-verify"
        exit 1
    fi
else
    echo "ADVERTENCIA: scripts/constitucion.sh no encontrado, saltando validacion"
fi
echo ""
```

**Exit codes**:
- constitucion.sh exit 0: Continua con tests
- constitucion.sh exit 1: Bloquea push (severity=error)
- constitucion.sh exit 2: Continua con warning (severity=warning)

---

## 3. Utilidades Compartidas

### 3.1 scripts/utils/logging.sh

**Ubicacion**: `scripts/utils/logging.sh`
**Proposito**: Funciones logging estandarizadas para todos los scripts

#### 3.1.1 Codigo Completo

```bash
#!/usr/bin/env bash
# scripts/utils/logging.sh
# Shared logging utilities
# Usage: source scripts/utils/logging.sh

# Enable colors if terminal supports it
if [ -t 1 ]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[0;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m' # No Color
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_debug() {
    if [ "${DEBUG:-0}" = "1" ]; then
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
    fi
}

# Log with timestamp
log_timestamp() {
    local level="$1"
    shift
    local timestamp=$(date -Iseconds)
    echo "[$timestamp] [$level] $*"
}

# Log to file
log_to_file() {
    local logfile="$1"
    shift
    echo "[$(date -Iseconds)] $*" >> "$logfile"
}

# Progress bar
progress_bar() {
    local current="$1"
    local total="$2"
    local width=50

    local percent=$((current * 100 / total))
    local filled=$((current * width / total))

    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%$((width - filled))s" | tr ' ' ' '
    printf "] %3d%%" "$percent"
}
```

**Uso**:
```bash
source scripts/utils/logging.sh
log_info "Iniciando proceso..."
log_success "Proceso completado"
log_warn "Advertencia: recurso limitado"
log_error "Error fatal"
```

---

### 3.2 scripts/utils/colors.sh

**Ubicacion**: `scripts/utils/colors.sh`
**Proposito**: Constantes colores terminal (DEPRECATED - usar logging.sh)

**NOTA**: Este archivo existe para compatibilidad con scripts antiguos. Scripts nuevos deben usar `logging.sh` directamente.

#### 3.2.1 Codigo

```bash
#!/usr/bin/env bash
# scripts/utils/colors.sh
# Terminal color constants (DEPRECATED - use logging.sh)

if [ -t 1 ]; then
    export COLOR_RED='\033[0;31m'
    export COLOR_GREEN='\033[0;32m'
    export COLOR_YELLOW='\033[0;33m'
    export COLOR_BLUE='\033[0;34m'
    export COLOR_RESET='\033[0m'
else
    export COLOR_RED=''
    export COLOR_GREEN=''
    export COLOR_YELLOW=''
    export COLOR_BLUE=''
    export COLOR_RESET=''
fi
```

---

## 4. Directorio scripts/utils/

### 4.1 Estructura Propuesta

```
scripts/
├── utils/
│   ├── logging.sh              # Funciones logging (NUEVO)
│   ├── colors.sh               # Colores terminal (LEGACY)
│   ├── validators.sh           # Validadores comunes (FUTURO)
│   └── git_helpers.sh          # Git utilities (FUTURO)
├── constitucion.sh             # Sistema constitucion
├── ci-local.sh                 # Orquestador CI
├── check_ui_api_coherence.sh  # Helper R3
├── validate_devcontainer_env.sh # Helper R6
├── validate_constitution_schema.sh # Helper constitucion
└── install_hooks.sh            # Instalador hooks (EXISTENTE)
```

### 4.2 Crear Directorio

```bash
mkdir -p scripts/utils
```

---

## 5. Integracion con Sistema Existente

### 5.1 Compatibilidad con Scripts Existentes (40+)

**Principio**: NO modificar scripts existentes que funcionan

**Scripts existentes** (40+):
- Mantienen su estructura actual
- NO requieren utilidades compartidas
- Continuan funcionando independientemente

**Scripts nuevos** (constitucion, CI, helpers):
- DEBEN usar utilidades compartidas
- DEBEN seguir convenciones logging
- DEBEN tener exit codes estandarizados

### 5.2 Exit Codes Estandarizados

**Convencion para scripts nuevos**:
```
0 = Success
1 = Error (bloquea proceso)
2 = Warning (no bloquea, solo informa)
3 = Skipped (condicion no aplica)
```

**Ejemplo**:
```bash
# constitucion.sh
exit 0  # Todas las reglas pasaron
exit 1  # Al menos 1 regla severity=error fallo
exit 2  # Solo warnings, no errores
```

---

## 6. Testing de Scripts

### 6.1 Estrategia Testing

**Scripts a testear** (FASE 4 - Testing Plan):
1. check_ui_api_coherence.sh
2. validate_devcontainer_env.sh
3. validate_constitution_schema.sh
4. logging.sh (unit tests funciones)

**Metodo**:
- Bash unit testing con `bats` (Bash Automated Testing System)
- Mocks para git, nc, yq, jq
- Test exit codes
- Test outputs (JSON reports)

**Ejemplo test**:
```bash
# tests/check_ui_api_coherence.bats
@test "Detecta API change sin UI test" {
  # Setup: mock git diff
  # Run: check_ui_api_coherence.sh
  # Assert: exit code 1, JSON incoherent
}
```

**NOTA**: Testing detallado en FASE 4 (Testing Plan)

---

## 7. Dependencias Externas

### 7.1 Herramientas Requeridas

**Instaladas en DevContainer**:
- bash 5.x
- git 2.x
- jq (JSON processor)
- yq (YAML processor)
- nc (netcat - check ports)
- Python 3.12.x
- Node 18.x

**Verificacion**:
```bash
# Durante post_create.sh
./scripts/validate_devcontainer_env.sh
```

### 7.2 Instalacion yq (si falta)

**En DevContainer**:
```bash
# Post create script should install
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
chmod +x /usr/local/bin/yq
```

---

## 8. Permisos y Seguridad

### 8.1 Permisos Scripts

**Todos los scripts ejecutables**:
```bash
chmod +x scripts/constitucion.sh
chmod +x scripts/ci-local.sh
chmod +x scripts/check_ui_api_coherence.sh
chmod +x scripts/validate_devcontainer_env.sh
chmod +x scripts/validate_constitution_schema.sh
chmod +x scripts/utils/logging.sh
```

### 8.2 Consideraciones Seguridad

**Inputs**:
- NUNCA ejecutar `eval` con input usuario
- Validar paths (no ../ traversal)
- Sanitizar inputs antes de usar en comandos

**Secrets**:
- Scripts NO deben contener credenciales
- Variables sensibles via environment (.env)
- NO logear secrets

**Ejemplo validacion path**:
```bash
validate_path() {
    local path="$1"
    if [[ "$path" =~ \.\. ]]; then
        log_error "Path invalido: $path"
        exit 1
    fi
}
```

---

## 9. Logging y Debugging

### 9.1 Niveles Logging

**Estandar**:
- INFO: Informacion general proceso
- SUCCESS: Operacion exitosa
- WARN: Advertencia (no bloquea)
- ERROR: Error (bloquea proceso)
- DEBUG: Solo si DEBUG=1

**Ejemplo**:
```bash
DEBUG=1 ./scripts/constitucion.sh --mode=manual
# Output incluye [DEBUG] messages
```

### 9.2 Logs a Archivo

**Para CI local**:
```bash
./scripts/ci-local.sh 2>&1 | tee logs/ci-local-$(date +%Y%m%d_%H%M%S).log
```

**Rotacion logs**: Manual (no automatico inicialmente)

---

## 10. Resumen Archivos a Crear/Modificar

### 10.1 Archivos NUEVOS a Crear

```
scripts/
├── check_ui_api_coherence.sh          # 120 lineas
├── validate_devcontainer_env.sh       # 180 lineas
├── validate_constitution_schema.sh    # 130 lineas
└── utils/
    ├── logging.sh                      # 80 lineas
    └── colors.sh                       # 15 lineas (legacy)
```

**Total**: 525 lineas codigo nuevo

### 10.2 Archivos a MODIFICAR

```
scripts/
├── install_hooks.sh                   # +6 lineas (mensaje constitucion)
└── git-hooks/
    └── pre-push                        # +15 lineas (invocar constitucion)
```

**Total**: 21 lineas modificaciones

---

## 11. Checklist Implementacion

**Para desarrollador implementando**:

- [ ] Crear directorio `scripts/utils/`
- [ ] Crear `scripts/utils/logging.sh`
- [ ] Crear `scripts/utils/colors.sh`
- [ ] Crear `scripts/check_ui_api_coherence.sh`
- [ ] Crear `scripts/validate_devcontainer_env.sh`
- [ ] Crear `scripts/validate_constitution_schema.sh`
- [ ] Modificar `scripts/install_hooks.sh` (agregar mensaje)
- [ ] Modificar `scripts/git-hooks/pre-push` (invocar constitucion)
- [ ] Aplicar permisos ejecutables (chmod +x)
- [ ] Validar sintaxis bash (`shellcheck`)
- [ ] Test manual cada script
- [ ] Commit cambios

---

## 12. Referencias Cruzadas

**Desde otros LLDs**:
- LLD_01_CONSTITUCION.md: Invoca check_ui_api_coherence.sh, validate_devcontainer_env.sh
- LLD_02_CI_LOCAL.md: Usa logging.sh para reportes
- LLD_03_DEVCONTAINER.md: Invoca validate_devcontainer_env.sh en post_create.sh

**Hacia Testing Plan** (FASE 4):
- Unit tests para logging.sh
- Integration tests para helpers
- Mocks para dependencias externas

**Hacia Deployment** (FASE 5):
- Procedimientos instalacion scripts
- Validacion permisos
- Verificacion dependencias

---

## Estado Actual

**Completado**:
- [x] Especificacion check_ui_api_coherence.sh
- [x] Especificacion validate_devcontainer_env.sh
- [x] Especificacion validate_constitution_schema.sh
- [x] Especificacion logging.sh
- [x] Modificaciones install_hooks.sh
- [x] Modificaciones pre-push hook
- [x] Checklist implementacion

**Estimado tiempo implementacion**: 2-3 horas

---

**Metodologia**:
- Auto-CoT: Scripts descompuestos en funciones especificas
- Self-Consistency: Validacion multiple (sintaxis, schema, runtime)
- DRY: Utilidades compartidas evitan duplicacion

**Status**: LLD_04 COMPLETO
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team
