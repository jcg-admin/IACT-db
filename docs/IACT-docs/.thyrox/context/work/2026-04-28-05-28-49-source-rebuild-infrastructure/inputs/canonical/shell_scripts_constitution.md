---
id: DOC-SHELL-SCRIPTS-CONSTITUTION
tipo: constitution
estado: activo
propietario: equipo-infraestructura
ultima_actualizacion: 2025-11-09
version: 1.0.0
date: 2025-11-13
---

# Shell Scripts Constitution

**Principios Inmutables para Shell Scripts en el Proyecto IACT**

Este documento define 8 reglas inmutables que TODOS los shell scripts deben seguir, siguiendo el mismo patrón que `TDD_CONSTITUTION.py`.

---

## FUNDAMENTO

**Uncle Bob (Clean Code)**: "The only way to go fast is to go well."

Los shell scripts son código de infraestructura crítica. Errores en scripts pueden:
- Destruir datos (rm -rf sin validación)
- Romper builds (syntax errors no detectados)
- Crear deuda técnica (código difícil de mantener)
- Bloquear desarrolladores (errores silenciosos)

**Solución**: Constitution con reglas inmutables.

---

## LAS 8 REGLAS INMUTABLES

### CRITICAL RULES (NUNCA VIOLAR)

#### RULE 1: Single Responsibility Principle

**Enunciado**: Cada módulo shell tiene UNA y solo UNA responsabilidad claramente definida.

**Razón**: Alta cohesión, bajo acoplamiento, mantenibilidad.

**Violación**:
```bash
# utils/mixed.sh - VIOLACIÓN
download_file() { ... }        # Network responsibility
validate_checksum() { ... }    # Validation responsibility
log_info() { ... }            # Logging responsibility
# 3 responsabilidades en 1 módulo = VIOLACIÓN
```

**Correcto**:
```bash
# utils/network.sh - UNA responsabilidad
download_file() { ... }
download_with_retry() { ... }

# utils/validator.sh - UNA responsabilidad
validate_checksum() { ... }
validate_file_exists() { ... }

# utils/logger.sh - UNA responsabilidad
log_info() { ... }
log_error() { ... }
```

**Validación**:
```bash
# Contar dominios de funciones en módulo
domains=$(grep -oP '^[a-z_]+(?=\()' module.sh | cut -d'_' -f1 | sort -u | wc -l)
if [ "$domains" -gt 1 ]; then
    echo "VIOLATION: Module has $domains responsibilities (max: 1)"
    exit 1
fi
```

---

#### RULE 2: Backward Compatibility

**Enunciado**: Cambios a funciones públicas NO rompen código existente. Deprecation antes de removal.

**Razón**: Estabilidad, migración gradual, confianza en la API.

**Violación**:
```bash
# Version 1.0
validate_dir_exists() { ... }

# Version 2.0 - VIOLACIÓN (breaking change)
# Función eliminada sin deprecation
# validate_directory_exists() { ... }  # Nuevo nombre
```

**Correcto**:
```bash
# Version 2.0 - Correcto
validate_directory_exists() {
    # Nueva implementación
    ...
}

# Backward compatibility wrapper (DEPRECATED)
validate_dir_exists() {
    log_warning "DEPRECATED: validate_dir_exists() will be removed in v3.0"
    log_warning "Use validate_directory_exists() instead"
    validate_directory_exists "$@"
}
```

**Validación**:
```bash
# Tests de regresión
test_deprecated_function_still_works() {
    # Old function name must still work
    if validate_dir_exists "/tmp"; then
        echo "PASS: Backward compatibility maintained"
    else
        echo "FAIL: Breaking change detected"
        exit 1
    fi
}
```

---

#### RULE 3: Explicit Error Handling

**Enunciado**: TODOS los errores son manejados explícitamente. NO errores silenciosos. `set -euo pipefail` obligatorio.

**Razón**: Debugging, confiabilidad, claridad.

**Violación**:
```bash
#!/bin/bash
# NO set -e - VIOLACIÓN

download_file() {
    curl -O "$url" || true  # Silencia error - VIOLACIÓN
}

mkdir "$dir"  # Sin validar éxito - VIOLACIÓN
```

**Correcto**:
```bash
#!/bin/bash
set -euo pipefail  # OBLIGATORIO

download_file() {
    local url="$1"

    if ! curl -fsSL "$url" -o file.tar.gz; then
        log_error "Failed to download: $url"
        return 1
    fi

    return 0
}

# Validar operaciones críticas
if ! mkdir -p "$dir"; then
    log_error "Failed to create directory: $dir"
    exit 1
fi
```

**Validación**:
```bash
# Check 1: set -e presente
if ! grep -q 'set -e' "$script"; then
    echo "VIOLATION: Missing set -e"
    exit 1
fi

# Check 2: NO errores silenciados con || true
if grep -P '\|\|\s*true' "$script"; then
    echo "VIOLATION: Silent error with || true"
    exit 1
fi

# Check 3: NO || sin manejo explícito
if grep -P '\|\|(?!\s+(echo|log_error|return|exit))' "$script"; then
    echo "VIOLATION: Error not explicitly handled"
    exit 1
fi
```

---

#### RULE 4: Tests Without External Dependencies

**Enunciado**: Tests ejecutables sin dependencias externas (internet, databases, APIs). Mocks/stubs obligatorios.

**Razón**: Tests confiables, CI/CD rápido, offline development.

**Violación**:
```bash
# test_download.sh - VIOLACIÓN
test_download_file() {
    # Requiere internet - VIOLACIÓN
    download_file "https://python.org/file.tar.gz"

    # Requiere filesystem real - VIOLACIÓN
    [ -f "file.tar.gz" ]
}
```

**Correcto**:
```bash
# test_download.sh - Correcto
test_download_file() {
    # Mock: curl
    curl() {
        echo "mocked download" > "$2"
        return 0
    }

    # Test con mock (sin internet)
    download_file "https://example.com/file.tar.gz"

    # Validar comportamiento
    [ -f "file.tar.gz" ]
    grep -q "mocked download" file.tar.gz
}
```

**Validación**:
```bash
# Tests deben pasar sin internet
unset http_proxy https_proxy
ifconfig eth0 down 2>/dev/null || true

if bash tests/unit/test_download.sh; then
    echo "PASS: Tests run without external dependencies"
else
    echo "FAIL: Tests require external dependencies"
    exit 1
fi
```

---

### HIGH PRIORITY RULES

#### RULE 5: Clean Code Naming

**Enunciado**: Nombres revelan intención. NO abreviaciones. NO encodings. Pronunciables y buscables.

**Razón**: Legibilidad, mantenibilidad, onboarding.

**Violación**:
```bash
# Malos nombres
validate_dir() { ... }           # Abreviación - VIOLACIÓN
proc_usr_data() { ... }          # Impronunciable - VIOLACIÓN
t() { ... }                      # No buscable - VIOLACIÓN
str_name="John"                  # Encoding hungaro - VIOLACIÓN
```

**Correcto**:
```bash
# Buenos nombres
validate_directory_exists() { ... }         # Claro, pronunciable
process_user_authentication() { ... }       # Descriptivo
execute_with_retry() { ... }               # Buscable
name="John"                                # Sin encoding
```

**Principios Clean Code aplicados**:
1. Names Reveal Intention
2. Avoid Disinformation
3. Meaningful Distinctions
4. Pronounceable Names
5. Searchable Names
6. Avoid Encodings
7. Avoid Mental Mapping
8. One Word Per Concept
9. Architecture Reveals Intent

**Validación**:
```bash
# Check abreviaciones comunes
if grep -E '\b(dir|usr|proc|exec|val|chk|tmp|str|int)\(' "$script"; then
    echo "WARNING: Possible abbreviations found"
fi

# Check nombres muy cortos (< 3 chars)
short_names=$(grep -oP '^[a-z_]{1,2}(?=\()' "$script")
if [ -n "$short_names" ]; then
    echo "VIOLATION: Function names too short: $short_names"
    exit 1
fi
```

---

#### RULE 6: Size Limits

**Enunciado**: Módulos < 200 líneas. Funciones < 50 líneas.

**Razón**: Complejidad manejable, code reviews fáciles, testing simple.

**Violación**:
```bash
# utils/massive.sh - 450 líneas - VIOLACIÓN
process_everything() {
    # 150 líneas en una función - VIOLACIÓN
    ...
}
```

**Correcto**:
```bash
# utils/logger.sh - 120 líneas - OK
log_info() {
    # 15 líneas - OK
    ...
}

log_error() {
    # 18 líneas - OK
    ...
}
```

**Validación**:
```bash
# Check tamaño de módulo
lines=$(wc -l < "$module")
if [ "$lines" -gt 200 ]; then
    echo "VIOLATION: Module too large: $lines lines (max: 200)"
    exit 1
fi

# Check tamaño de funciones
function_sizes=$(awk '
    /^[a-z_]+\(\)/ { fname=$1; start=NR }
    /^}$/ && fname {
        size=NR-start
        if (size > 50) print fname ": " size " lines"
        fname=""
    }
' "$module")

if [ -n "$function_sizes" ]; then
    echo "VIOLATION: Functions too large:"
    echo "$function_sizes"
    exit 1
fi
```

---

### MEDIUM PRIORITY RULES

#### RULE 7: Inline Documentation

**Enunciado**: Todas las funciones públicas documentadas con: propósito, args, returns, ejemplo.

**Razón**: Self-documentation, onboarding, API clarity.

**Violación**:
```bash
# Sin documentación - VIOLACIÓN
validate_directory_exists() {
    local dir="$1"
    [ -d "$dir" ]
}
```

**Correcto**:
```bash
# Validates that a directory exists
# Args:
#   $1 - directory path to validate
# Returns:
#   0 if directory exists
#   1 if directory does not exist
# Example:
#   validate_directory_exists "/tmp" || exit 1
validate_directory_exists() {
    local dir="$1"

    if [ -z "$dir" ]; then
        log_error "Directory path required"
        return 1
    fi

    if [ -d "$dir" ]; then
        return 0
    else
        log_error "Directory not found: $dir"
        return 1
    fi
}
```

**Validación**:
```bash
# Check documentación
functions=$(grep -cE '^[a-z_]+\(\)' "$module")
documented=$(grep -cE '^# (Args:|Returns:|Example:)' "$module")

coverage=$((documented * 100 / functions))
if [ "$coverage" -lt 80 ]; then
    echo "WARNING: Documentation coverage: $coverage% (target: 80%)"
fi
```

---

#### RULE 8: Idempotence Where Applicable

**Enunciado**: Operaciones idempotentes cuando sea posible. Múltiples ejecuciones = mismo resultado.

**Razón**: Confiabilidad, reintentos seguros, desarrollo iterativo.

**Violación**:
```bash
# NO idempotente - VIOLACIÓN
create_directory() {
    mkdir "$dir"  # Falla en segunda ejecución
}

append_to_file() {
    echo "line" >> file  # Duplica en cada ejecución
}
```

**Correcto**:
```bash
# Idempotente - Correcto
ensure_directory_exists() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
    # Segunda ejecución: no-op, retorna 0
}

ensure_line_in_file() {
    local line="$1"
    local file="$2"

    if ! grep -qF "$line" "$file" 2>/dev/null; then
        echo "$line" >> "$file"
    fi
    # Segunda ejecución: no duplica
}
```

**Validación**:
```bash
# Test idempotencia
test_idempotence() {
    # Primera ejecución
    result1=$(ensure_directory_exists "/tmp/test")

    # Segunda ejecución
    result2=$(ensure_directory_exists "/tmp/test")

    # Resultados deben ser idénticos
    if [ "$result1" = "$result2" ]; then
        echo "PASS: Idempotent"
    else
        echo "FAIL: Not idempotent"
        exit 1
    fi
}
```

---

## SEVERIDAD DE VIOLACIONES

### CRITICAL (bloquea merge):
- RULE 1: Single Responsibility
- RULE 2: Backward Compatibility
- RULE 3: Explicit Error Handling
- RULE 4: Tests Without Dependencies

### HIGH (requiere justificación):
- RULE 5: Clean Code Naming
- RULE 6: Size Limits

### MEDIUM (warning, no bloquea):
- RULE 7: Inline Documentation
- RULE 8: Idempotence

---

## ENFORCEMENT

### Validación Automatizada

```bash
# scripts/validation/quality/validate_shell_constitution.sh

#!/bin/bash
set -euo pipefail

validate_all_rules() {
    local script="$1"
    local failed=0

    echo "Validating: $script"

    # RULE 1: Single Responsibility
    validate_rule_1_single_responsibility "$script" || failed=$((failed + 1))

    # RULE 2: Backward Compatibility (tests de regresión)
    validate_rule_2_backward_compatibility "$script" || failed=$((failed + 1))

    # RULE 3: Explicit Error Handling
    validate_rule_3_explicit_error_handling "$script" || failed=$((failed + 1))

    # RULE 4: Tests Without Dependencies (check imports/network)
    validate_rule_4_tests_without_deps "$script" || failed=$((failed + 1))

    # RULE 5: Clean Code Naming
    validate_rule_5_clean_code_naming "$script" || failed=$((failed + 1))

    # RULE 6: Size Limits
    validate_rule_6_size_limits "$script" || failed=$((failed + 1))

    # RULE 7: Inline Documentation
    validate_rule_7_inline_documentation "$script" || failed=$((failed + 1))

    # RULE 8: Idempotence (si aplica)
    validate_rule_8_idempotence "$script" || failed=$((failed + 1))

    return $failed
}
```

### Pre-commit Hook Integration

```bash
# .git/hooks/pre-commit

# Validar constitution en shell scripts staged
STAGED_SHELL=$(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$')

for script in $STAGED_SHELL; do
    if ! bash scripts/validation/quality/validate_shell_constitution.sh "$script"; then
        echo "VIOLATION: $script violates Shell Scripts Constitution"
        exit 1
    fi
done
```

### CI/CD Integration

```yaml
# .github/workflows/shell-constitution-validation.yml
- name: Validate Shell Scripts Constitution
  run: |
    for script in $(find utils scripts -name "*.sh"); do
      bash scripts/validation/quality/validate_shell_constitution.sh "$script"
    done
```

---

## EXCEPCIONES

### Cuándo NO aplicar reglas:

**RULE 4 (Tests sin dependencias)**:
- Tests de integración E2E (requieren vagrant, docker)
- Smoke tests en producción

**RULE 6 (Size limits)**:
- Scripts generados automáticamente
- Scripts de migración one-time

**RULE 8 (Idempotence)**:
- Scripts de deployment (intencionales side-effects)
- Scripts de logging/metrics

**Proceso para excepciones**:
```bash
# En el script:
# CONSTITUTION EXCEPTION: RULE 6 (Size Limits)
# Justification: Generated migration script, one-time use
# Approved by: team-lead
# Date: 2025-11-09
```

---

## EJEMPLOS COMPLETOS

### Ejemplo 1: Módulo Compliant

```bash
#!/bin/bash
# utils/validator.sh - File and directory validation utilities
# Reference: SHELL_SCRIPTS_CONSTITUTION.md
# Version: 1.0.0

set -euo pipefail  # RULE 3

# Source dependencies
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/logger.sh"

# =============================================================================
# PUBLIC FUNCTIONS (RULE 7: Documentation)
# =============================================================================

# Validates that a directory exists
# Args:
#   $1 - directory path to validate
# Returns:
#   0 if directory exists
#   1 if directory does not exist
# Example:
#   validate_directory_exists "/tmp" || exit 1
validate_directory_exists() {  # RULE 5: Clean name
    local directory="$1"

    # RULE 3: Explicit validation
    if [ -z "$directory" ]; then
        log_error "Directory path required"
        return 1
    fi

    # RULE 8: Idempotent check
    if [ -d "$directory" ]; then
        return 0
    else
        log_error "Directory not found: $directory"
        return 1
    fi
}

# Validates SHA256 checksum of a file
# Args:
#   $1 - file path
#   $2 - expected checksum
# Returns:
#   0 if checksum matches
#   1 if checksum does not match
# Example:
#   validate_sha256_checksum "file.tar.gz" "abc123..." || exit 1
validate_sha256_checksum() {  # RULE 5: Full name (no abbreviation)
    local file="$1"
    local expected_checksum="$2"

    # RULE 3: Explicit validation
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi

    local actual_checksum
    actual_checksum=$(sha256sum "$file" | awk '{print $1}')

    if [ "$actual_checksum" = "$expected_checksum" ]; then
        log_info "Checksum valid: $file"
        return 0
    else
        log_error "Checksum mismatch for $file"
        log_error "  Expected: $expected_checksum"
        log_error "  Actual:   $actual_checksum"
        return 1
    fi
}

# RULE 2: Backward compatibility (deprecated function)
# DEPRECATED: Use validate_directory_exists() instead
validate_dir_exists() {
    log_warning "DEPRECATED: validate_dir_exists() will be removed in v2.0"
    log_warning "Use validate_directory_exists() instead"
    validate_directory_exists "$@"
}
```

**Constitution Compliance**:
- RULE 1: Single responsibility (validation only)
- RULE 2: Backward compatible (deprecated wrapper)
- RULE 3: Explicit error handling (set -e, validations)
- RULE 4: Testable sin deps (no network/filesystem required)
- RULE 5: Clean Code names (validate_directory_exists)
- RULE 6: 80 líneas (< 200 OK), funciones < 30 (< 50 OK)
- RULE 7: All functions documented
- RULE 8: Idempotent checks

---

### Ejemplo 2: Test Compliant

```bash
#!/bin/bash
# tests/unit/test_validator.sh
# Unit tests for validator.sh (RULE 4: without external deps)

set -euo pipefail

# Source module under test
source utils/validator.sh

# Mock logger (RULE 4: no external dependency)
log_error() { echo "ERROR: $*" >&2; }
log_warning() { echo "WARNING: $*" >&2; }
log_info() { echo "INFO: $*"; }

# =============================================================================
# TESTS
# =============================================================================

test_validate_directory_exists_success() {
    # Setup: create temp directory
    local test_dir="/tmp/test_$$"
    mkdir -p "$test_dir"

    # Test
    if validate_directory_exists "$test_dir"; then
        echo "PASS: validate_directory_exists returns 0 for existing dir"
    else
        echo "FAIL: validate_directory_exists should return 0"
        return 1
    fi

    # Cleanup
    rm -rf "$test_dir"
}

test_validate_directory_exists_failure() {
    # Test with non-existent directory
    if validate_directory_exists "/nonexistent_$$"; then
        echo "FAIL: Should return 1 for non-existent directory"
        return 1
    else
        echo "PASS: Returns 1 for non-existent directory"
    fi
}

test_backward_compatibility_deprecated_function() {
    # Test RULE 2: deprecated function still works
    local test_dir="/tmp/test_$$"
    mkdir -p "$test_dir"

    # Old function name should work (with warning)
    if validate_dir_exists "$test_dir" 2>/dev/null; then
        echo "PASS: Deprecated function still works"
    else
        echo "FAIL: Backward compatibility broken"
        return 1
    fi

    rm -rf "$test_dir"
}

test_idempotence() {
    # Test RULE 8: multiple calls give same result
    local test_dir="/tmp/test_$$"
    mkdir -p "$test_dir"

    # First call
    validate_directory_exists "$test_dir" > /dev/null
    local result1=$?

    # Second call
    validate_directory_exists "$test_dir" > /dev/null
    local result2=$?

    if [ "$result1" -eq "$result2" ]; then
        echo "PASS: Idempotent (both calls return same)"
    else
        echo "FAIL: Not idempotent"
        return 1
    fi

    rm -rf "$test_dir"
}

# Run all tests
main() {
    local failed=0

    test_validate_directory_exists_success || failed=$((failed + 1))
    test_validate_directory_exists_failure || failed=$((failed + 1))
    test_backward_compatibility_deprecated_function || failed=$((failed + 1))
    test_idempotence || failed=$((failed + 1))

    echo ""
    if [ $failed -eq 0 ]; then
        echo "ALL TESTS PASSED"
        return 0
    else
        echo "TESTS FAILED: $failed"
        return 1
    fi
}

main
```

---

## MIGRATION GUIDE

### Para Scripts Existentes

**Paso 1**: Ejecutar validator
```bash
bash scripts/validation/quality/validate_shell_constitution.sh utils/old_script.sh
```

**Paso 2**: Arreglar violaciones CRITICAL primero
```bash
# Add set -euo pipefail
# Split multi-responsibility modules
# Add backward compatibility wrappers
```

**Paso 3**: Arreglar violaciones HIGH
```bash
# Rename functions (Clean Code)
# Split large functions/modules
```

**Paso 4**: Arreglar violaciones MEDIUM
```bash
# Add documentation
# Make idempotent where possible
```

**Paso 5**: Validar y commitear
```bash
bash scripts/validation/quality/validate_shell_constitution.sh utils/old_script.sh
git add utils/old_script.sh
git commit -m "refactor(utils): comply with Shell Scripts Constitution"
```

---

## CHANGELOG

### Version 1.0.0 (2025-11-09)
- Initial constitution release
- 8 immutable rules defined (4 CRITICAL, 2 HIGH, 2 MEDIUM)
- Validation automation framework
- Examples and migration guide

---

## REFERENCES

- Clean Code by Robert Martin
- POSIX Shell Programming
- Google Shell Style Guide
- TDD Constitution (proyecto IACT)
- ESTRATEGIA_MIGRACION_SHELL_SCRIPTS.md
- ANALISIS_REFACTORING_CPYTHON.md

---

**Generated**: 2025-11-09
**Version**: 1.0.0
**Status**: ACTIVE
**Compliance**: MANDATORY for all shell scripts
