---
id: DOC-ESTRATEGIA-SHELL-MIGRATION
tipo: estrategia
estado: activo
propietario: equipo-infraestructura
ultima_actualizacion: 2025-11-09
date: 2025-11-13
---

# Estrategia de Migración: GitHub Actions a Shell Scripts

**Objetivo**: Reducir dependencia de GitHub Actions, migrar lógica de validación a shell scripts ejecutables localmente y en CI/CD.

**Aplicación de Técnicas de Prompt Engineering**: Este documento utiliza técnicas avanzadas de ingeniería de prompts para estructurar una migración sistemática y validada.

---

## Tabla de Contenidos

1. [Análisis del Estado Actual](#análisis-del-estado-actual)
2. [Técnicas de Prompt Engineering Aplicadas](#técnicas-de-prompt-engineering-aplicadas)
3. [Arquitectura Propuesta](#arquitectura-propuesta)
4. [Estrategia de Migración en Fases](#estrategia-de-migración-en-fases)
5. [Constitution: Principios Inmutables](#constitution-principios-inmutables)
6. [Implementación Detallada](#implementación-detallada)
7. [Validación y Testing](#validación-y-testing)
8. [Roadmap de Ejecución](#roadmap-de-ejecución)

---

## Análisis del Estado Actual

### Métricas de Dependencia en GitHub Actions

```
Workflows totales:              18 archivos YAML
Líneas totales en workflows:    4,911 líneas
Lógica embebida (5 workflows):  416 líneas (~70% extraíble)
Scripts shell existentes:       42 archivos

Ratio actual:
  - GitHub Actions (YAML):      4,911 líneas (92%)
  - Shell Scripts:              ~2,000 líneas (8%)
```

### Workflows con Mayor Lógica Embebida

| Workflow | Líneas Embebidas | Complejidad | Prioridad |
|----------|------------------|-------------|-----------|
| security-scan.yml | 164 | CRITICAL | P0 |
| lint.yml | 86 | HIGH | P0 |
| backend-ci.yml | 85 | HIGH | P1 |
| emoji-validation.yml | 81 | MEDIUM | P2 |
| python_ci.yml | 20 | LOW | P3 |

### Problemas Identificados

**P0 - CRITICAL:**
- Lógica de seguridad dispersa en 9 jobs separados (security-scan.yml)
- Validación de YAML parsing manual en GitHub Actions (lint.yml)
- Imposible ejecutar validaciones localmente sin GitHub
- No hay versionado independiente de scripts de validación

**P1 - HIGH:**
- Duplicación de validaciones entre workflows
- Lógica de negocio mezclada con orquestación
- Testing de validaciones requiere commits/PRs

**P2 - MEDIUM:**
- Dificultad para compartir scripts entre proyectos
- Mantenimiento distribuido en múltiples archivos YAML

---

## Técnicas de Prompt Engineering Aplicadas

### 1. Chain of Thought (CoT) - Razonamiento Paso a Paso

**Aplicación**: Descomponer la migración en fases lógicas con validación incremental.

```
Fase 1: Identificar → Fase 2: Extraer → Fase 3: Validar → Fase 4: Reemplazar
    ↓                     ↓                  ↓                 ↓
 Análisis de        Scripts shell      Tests pasan      GitHub Actions
 workflows          standalone         localmente       llama scripts
```

**Beneficio**: Reducción de riesgo, rollback fácil, validación continua.

### 2. Constitutional AI - Principios Inmutables

**Aplicación**: Definir reglas de diseño que NUNCA se violan (similar a TDD Constitution del proyecto).

```python
# 8 Principios Inmutables para Scripts de Validación
CONSTITUTION = [
    "RULE 1: Script ejecutable localmente sin GitHub",      # CRITICAL
    "RULE 2: Exit code 0=éxito, 1=fallo, 2=warning",       # CRITICAL
    "RULE 3: Output parseable (JSON/plain text)",          # CRITICAL
    "RULE 4: Idempotente (múltiples ejecuciones=mismo)",   # CRITICAL
    "RULE 5: Versionado independiente de workflows",       # HIGH
    "RULE 6: Documentación inline (--help flag)",          # HIGH
    "RULE 7: Testing unitario obligatorio",                # MEDIUM
    "RULE 8: Backward compatible con workflows actuales",  # MEDIUM
]
```

**Beneficio**: Calidad consistente, mantenibilidad, testabilidad.

### 3. Tree of Thoughts - Exploración de Alternativas

**Aplicación**: Evaluar múltiples arquitecturas antes de decidir.

```
Arquitectura A: Python monolítico
├─ Pro: Reutilización de código
├─ Pro: Type hints y testing robusto
└─ Con: Dependencias Python requeridas

Arquitectura B: Shell scripts POSIX
├─ Pro: Sin dependencias externas
├─ Pro: Portabilidad máxima
└─ Con: Testing más complejo

Arquitectura C: HÍBRIDA (RECOMENDADA)
├─ Shell scripts: Orquestación y validaciones simples
├─ Python modules: Lógica compleja y parsing
├─ Pro: Lo mejor de ambos mundos
└─ Pro: Flexibilidad según necesidad
```

**Decisión**: Arquitectura C (Híbrida) - Scripts shell orquestan, Python valida.

### 4. Least-to-Most Prompting - Incrementalidad

**Aplicación**: Resolver problemas simples primero, escalar gradualmente.

```
Nivel 1: Extraer validación simple (emoji check) → HECHO
Nivel 2: Extraer validación YAML (lint.yml)      → Fase 1
Nivel 3: Extraer validaciones de seguridad       → Fase 2
Nivel 4: Consolidar validaciones duplicadas      → Fase 3
Nivel 5: Orquestador maestro (run_all_checks.sh) → Fase 4
```

**Beneficio**: Complejidad creciente, aprendizaje continuo.

### 5. Skeleton-of-Thought - Estructura Primero

**Aplicación**: Crear estructura de directorios ANTES de migrar lógica.

```bash
scripts/
├── validation/              # Validaciones de código y políticas
│   ├── security/            # Seguridad (SQL injection, XSS, CSRF)
│   ├── quality/             # Calidad de código (linting, formatting)
│   ├── compliance/          # Compliance con restricciones IACT
│   └── infrastructure/      # Validación de infraestructura
├── ci/                      # Scripts específicos de CI/CD
│   ├── pre-commit/          # Hooks pre-commit
│   ├── pre-push/            # Hooks pre-push
│   └── pipeline/            # Pipeline completo
├── testing/                 # Scripts de testing
│   ├── unit/                # Tests unitarios de scripts
│   └── integration/         # Tests de integración
└── lib/                     # Librerías compartidas
    ├── common.sh            # Funciones shell comunes
    ├── validators.py        # Validadores Python
    └── reporters.py         # Generadores de reportes
```

**Beneficio**: Arquitectura clara, separación de concerns, escalabilidad.

### 6. Self-Refine - Iteración Validada

**Aplicación**: Cada script se valida contra constitution antes de merge.

```bash
# Proceso de refinamiento para cada script
1. Escribir script inicial
2. Validar contra 8 principios de constitution
3. Ejecutar tests unitarios
4. Ejecutar en CI/CD (GitHub Actions llama script)
5. Verificar exit codes correctos
6. Si falla: Refinar y volver a paso 2
7. Si pasa: Merge y continuar
```

**Beneficio**: Calidad garantizada, no hay scripts sin validar.

### 7. ReAct Pattern - Reasoning + Acting

**Aplicación**: Scripts que razonan antes de actuar.

```python
# Ejemplo: Security validator con ReAct pattern
def validate_sql_injection_risk():
    # REASONING: Analizar contexto
    patterns = detect_sql_patterns()
    false_positives = filter_django_orm_safe_patterns(patterns)
    risk_level = calculate_risk_score(patterns - false_positives)

    # ACTING: Decidir acción basada en razonamiento
    if risk_level == "CRITICAL":
        report_critical_findings()
        return EXIT_CODE_FAIL
    elif risk_level == "WARNING":
        report_warnings()
        return EXIT_CODE_WARNING
    else:
        return EXIT_CODE_SUCCESS
```

**Beneficio**: Validaciones inteligentes, reducción de falsos positivos.

### 8. Metacognitive Prompting - Razonar Sobre el Proceso

**Aplicación**: Scripts que reportan su propio proceso de validación.

```bash
# Ejemplo: Script con metacognición
echo "[METACOGNITION] Iniciando validación de restricciones..."
echo "[METACOGNITION] Estrategia: Grep patterns + Python AST parsing"
echo "[METACOGNITION] Archivos a validar: 247 archivos .py detectados"

# ... validación ...

echo "[METACOGNITION] Método usado: Pattern matching con 8 reglas"
echo "[METACOGNITION] Falsos positivos eliminados: 3"
echo "[METACOGNITION] Confianza en resultado: 95%"
```

**Beneficio**: Debugging fácil, transparencia, confiabilidad.

---

## Arquitectura Propuesta

### Principio: "Thin YAML, Fat Scripts"

**ANTES (Fat YAML)**:
```yaml
# .github/workflows/security-scan.yml
- name: SQL Injection Check
  run: |
    # 18 líneas de bash embebidas
    echo "Checking SQL injection..."
    PATTERNS=$(grep -rn "execute\|executemany" api/ ...)
    # ... 15 líneas más ...
```

**DESPUÉS (Thin YAML)**:
```yaml
# .github/workflows/security-scan.yml
- name: SQL Injection Check
  run: scripts/validation/security/check_sql_injection.py --output json
```

### Estructura de Directorios Detallada

```bash
scripts/
├── validation/                          # Todas las validaciones
│   ├── security/                        # P0: Migrar desde security-scan.yml
│   │   ├── check_sql_injection.py       # Extrae 18 líneas de YAML
│   │   ├── check_xss_protection.py      # Extrae 16 líneas de YAML
│   │   ├── check_csrf_protection.py     # Extrae 17 líneas de YAML
│   │   ├── check_django_security.py     # Extrae 19 líneas de YAML
│   │   ├── parse_npm_audit.py           # Extrae 18 líneas de YAML
│   │   ├── generate_security_report.py  # Extrae 44 líneas de YAML
│   │   └── run_all_security_checks.sh   # Orquestador
│   ├── quality/                         # P0: Migrar desde lint.yml
│   │   ├── validate_frontmatter.py      # Extrae 86 líneas de YAML
│   │   ├── validate_clean_code.py       # Validar naming principles
│   │   └── run_quality_checks.sh        # Orquestador
│   ├── compliance/                      # P1: Migrar desde backend-ci.yml
│   │   ├── check_no_redis.sh            # Extrae 14 líneas de YAML
│   │   ├── check_no_email.sh            # Extrae 9 líneas de YAML
│   │   ├── check_session_backend.sh     # Extrae 8 líneas de YAML
│   │   ├── check_no_emojis.py           # YA EXISTE (mantener)
│   │   └── run_compliance_checks.sh     # Orquestador
│   └── infrastructure/                  # P2: Nuevas validaciones
│       ├── check_dependencies.py        # Validar requirements.txt
│       └── check_migrations.py          # Validar migraciones Django
├── ci/                                  # Hooks y pipeline
│   ├── pre-commit/
│   │   ├── run_pre_commit_checks.sh     # Orquestador de hooks
│   │   └── hooks.d/                     # Hooks modulares
│   │       ├── 01-emojis.sh             # Llama check_no_emojis.py
│   │       ├── 02-formatting.sh         # Black, isort
│   │       └── 03-linting.sh            # Ruff, mypy
│   ├── pre-push/
│   │   └── run_pre_push_checks.sh       # Tests + validaciones
│   └── pipeline/
│       ├── run_full_pipeline.sh         # Pipeline completo local
│       └── run_security_pipeline.sh     # Solo seguridad
├── testing/                             # Tests de scripts
│   ├── unit/
│   │   ├── test_check_sql_injection.py
│   │   ├── test_validate_frontmatter.py
│   │   └── ...
│   └── integration/
│       ├── test_full_pipeline.sh
│       └── test_pre_commit_flow.sh
├── lib/                                 # Librerías compartidas
│   ├── common.sh                        # Funciones bash comunes
│   │   # set_colors(), log_info(), log_error(), etc.
│   ├── validators.py                    # Validadores Python
│   │   # BaseValidator, FileValidator, PatternValidator
│   ├── reporters.py                     # Generadores reportes
│   │   # JSONReporter, MarkdownReporter, GitHubReporter
│   └── exit_codes.sh                    # Exit codes estandarizados
│       # EXIT_SUCCESS=0, EXIT_FAIL=1, EXIT_WARNING=2
└── README.md                            # Documentación de arquitectura
```

### Exit Codes Estandarizados

```bash
# scripts/lib/exit_codes.sh
# Constitution Rule 2: Exit codes estandarizados

# Exit codes principales
EXIT_SUCCESS=0      # Validación pasó sin issues
EXIT_FAIL=1         # Validación falló (bloquea CI/CD)
EXIT_WARNING=2      # Warnings encontrados (no bloquea)

# Exit codes específicos (opcionales, para debugging)
EXIT_INVALID_ARGS=10    # Argumentos inválidos
EXIT_FILE_NOT_FOUND=11  # Archivo no encontrado
EXIT_PERMISSION=12      # Permiso denegado
EXIT_TIMEOUT=13         # Timeout excedido
```

### Output Format Estandarizado

**Opción 1: JSON (parseable, para CI/CD)**:
```json
{
  "validator": "check_sql_injection",
  "version": "1.0.0",
  "timestamp": "2025-11-09T10:30:00Z",
  "status": "FAIL",
  "exit_code": 1,
  "summary": {
    "files_checked": 247,
    "issues_found": 3,
    "warnings": 1
  },
  "findings": [
    {
      "file": "api/views.py",
      "line": 45,
      "severity": "CRITICAL",
      "message": "SQL injection risk: raw SQL without parameterization",
      "pattern": "cursor.execute(f\"SELECT * FROM {table}\")"
    }
  ]
}
```

**Opción 2: Plain Text (human-readable, para local)**:
```
[INFO] SQL Injection Check v1.0.0
[INFO] Checking 247 Python files...
========================================

[CRITICAL] api/views.py:45
  SQL injection risk: raw SQL without parameterization
  Pattern: cursor.execute(f"SELECT * FROM {table}")

[WARNING] api/utils.py:120
  Potential SQL injection (false positive?)
  Pattern: execute() with complex query

========================================
SUMMARY:
  Files checked: 247
  Critical issues: 1
  Warnings: 1

[FAIL] Validation failed with 1 critical issue(s)
Exit code: 1
```

### Template de Script Validador

```python
#!/usr/bin/env python3
"""
Template para validadores siguiendo Constitution Principles.

Este template cumple con los 8 principios de constitution:
1. Ejecutable localmente sin GitHub
2. Exit codes estandarizados (0=OK, 1=FAIL, 2=WARN)
3. Output parseable (JSON/plain text)
4. Idempotente
5. Versionado independiente
6. Documentación inline (--help)
7. Testing unitario
8. Backward compatible
"""

import sys
import json
import argparse
from pathlib import Path
from typing import List, Dict, Any
from datetime import datetime

# Version del validador (Principle 5: Versionado independiente)
VERSION = "1.0.0"

# Exit codes (Principle 2: Exit codes estandarizados)
EXIT_SUCCESS = 0
EXIT_FAIL = 1
EXIT_WARNING = 2

class ValidatorResult:
    """Resultado de validación."""
    def __init__(self):
        self.status = "PASS"
        self.findings: List[Dict[str, Any]] = []
        self.summary = {
            "files_checked": 0,
            "issues_found": 0,
            "warnings": 0
        }

class BaseValidator:
    """Base class for all validators (Principle 7: Testing)."""

    def __init__(self, output_format: str = "text"):
        self.output_format = output_format
        self.result = ValidatorResult()

    def validate(self, paths: List[Path]) -> ValidatorResult:
        """
        Ejecuta validación (Principle 4: Idempotente).

        Múltiples ejecuciones con mismos inputs = mismo output.
        """
        raise NotImplementedError("Subclass must implement validate()")

    def report(self, result: ValidatorResult) -> None:
        """Genera reporte (Principle 3: Output parseable)."""
        if self.output_format == "json":
            self._report_json(result)
        else:
            self._report_text(result)

    def _report_json(self, result: ValidatorResult) -> None:
        """JSON output for CI/CD parsing."""
        output = {
            "validator": self.__class__.__name__,
            "version": VERSION,
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "status": result.status,
            "exit_code": self._get_exit_code(result),
            "summary": result.summary,
            "findings": result.findings
        }
        print(json.dumps(output, indent=2))

    def _report_text(self, result: ValidatorResult) -> None:
        """Plain text output for humans."""
        print(f"[INFO] {self.__class__.__name__} v{VERSION}")
        print(f"[INFO] Checked {result.summary['files_checked']} files")
        print("=" * 50)

        for finding in result.findings:
            severity = finding.get("severity", "INFO")
            print(f"\n[{severity}] {finding['file']}:{finding.get('line', '?')}")
            print(f"  {finding['message']}")

        print("\n" + "=" * 50)
        print("SUMMARY:")
        print(f"  Files checked: {result.summary['files_checked']}")
        print(f"  Issues: {result.summary['issues_found']}")
        print(f"  Warnings: {result.summary['warnings']}")
        print(f"\n[{result.status}] Exit code: {self._get_exit_code(result)}")

    def _get_exit_code(self, result: ValidatorResult) -> int:
        """Determina exit code basado en resultado."""
        if result.status == "FAIL":
            return EXIT_FAIL
        elif result.status == "WARNING":
            return EXIT_WARNING
        else:
            return EXIT_SUCCESS

def main():
    """
    Entry point (Principle 1: Ejecutable localmente).

    Principle 6: Documentación inline (--help flag).
    """
    parser = argparse.ArgumentParser(
        description="Validator template following Constitution Principles",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Validate single file
  %(prog)s --file api/views.py

  # Validate directory
  %(prog)s --path api/ --output json

  # Show version
  %(prog)s --version
        """
    )
    parser.add_argument("--file", help="Single file to validate")
    parser.add_argument("--path", help="Directory to validate")
    parser.add_argument("--output", choices=["text", "json"], default="text",
                        help="Output format (default: text)")
    parser.add_argument("--version", action="version", version=f"%(prog)s {VERSION}")

    args = parser.parse_args()

    # Principle 1: Ejecutable localmente (validar args)
    if not args.file and not args.path:
        parser.error("Either --file or --path is required")
        return EXIT_FAIL

    # Crear validador
    validator = BaseValidator(output_format=args.output)

    # Ejecutar validación
    paths = []
    if args.file:
        paths.append(Path(args.file))
    if args.path:
        paths.extend(Path(args.path).rglob("*.py"))

    result = validator.validate(paths)

    # Reportar resultados
    validator.report(result)

    # Exit code (Principle 2)
    return validator._get_exit_code(result)

if __name__ == "__main__":
    sys.exit(main())
```

### Template de Script Shell Orquestador

```bash
#!/bin/bash
# Template para scripts shell orquestadores
# Cumple con Constitution Principles 1, 2, 4, 6, 8

set -euo pipefail  # Strict mode

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common functions (Principle 8: Backward compatible)
if [ -f "$SCRIPT_DIR/../lib/common.sh" ]; then
    source "$SCRIPT_DIR/../lib/common.sh"
fi

# Source exit codes
if [ -f "$SCRIPT_DIR/../lib/exit_codes.sh" ]; then
    source "$SCRIPT_DIR/../lib/exit_codes.sh"
else
    # Fallback if not available
    EXIT_SUCCESS=0
    EXIT_FAIL=1
    EXIT_WARNING=2
fi

# Version (Principle 5: Versionado independiente)
VERSION="1.0.0"

# ============================================================================
# FUNCTIONS
# ============================================================================

show_help() {
    # Principle 6: Documentación inline (--help)
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Description:
  Orchestrator script template following Constitution Principles.

Options:
  -h, --help       Show this help message
  -v, --version    Show version
  -o, --output     Output format (text|json) [default: text]
  -q, --quiet      Quiet mode (only errors)

Examples:
  # Run with text output
  $(basename "$0")

  # Run with JSON output
  $(basename "$0") --output json

  # Quiet mode
  $(basename "$0") --quiet

Exit Codes:
  0    Success (all checks passed)
  1    Failure (one or more checks failed)
  2    Warning (checks passed with warnings)
EOF
}

log_info() {
    if [ "${QUIET:-0}" -eq 0 ]; then
        echo "[INFO] $*"
    fi
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_warning() {
    if [ "${QUIET:-0}" -eq 0 ]; then
        echo "[WARNING] $*" >&2
    fi
}

# ============================================================================
# MAIN LOGIC
# ============================================================================

main() {
    # Principle 1: Ejecutable localmente
    log_info "Starting validation orchestrator v$VERSION"
    log_info "Project root: $PROJECT_ROOT"

    local failed=0
    local warned=0

    # Run validations (customize for specific orchestrator)
    log_info "Running validation 1..."
    if ! run_validation_1; then
        failed=$((failed + 1))
    fi

    log_info "Running validation 2..."
    if ! run_validation_2; then
        failed=$((failed + 1))
    fi

    # Summary
    echo ""
    echo "========================================"
    if [ $failed -eq 0 ] && [ $warned -eq 0 ]; then
        log_info "ALL VALIDATIONS PASSED"
        return $EXIT_SUCCESS
    elif [ $failed -gt 0 ]; then
        log_error "FAILURES: $failed validation(s) failed"
        return $EXIT_FAIL
    else
        log_warning "WARNINGS: $warned validation(s) had warnings"
        return $EXIT_WARNING
    fi
}

# ============================================================================
# ENTRY POINT
# ============================================================================

# Parse arguments
OUTPUT_FORMAT="text"
QUIET=0

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "$(basename "$0") version $VERSION"
            exit 0
            ;;
        -o|--output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=1
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main (Principle 4: Idempotente)
main
exit $?
```

---

## Constitution: Principios Inmutables

### Regla 1: Ejecutable Localmente (CRITICAL)

**Definición**: Todo script DEBE ser ejecutable en máquina local sin dependencias de GitHub Actions.

**Validación**:
```bash
# Test: Script se ejecuta sin variables de GitHub
unset GITHUB_ACTIONS GITHUB_WORKSPACE
./scripts/validation/security/check_sql_injection.py --path api/
echo $?  # Debe funcionar y retornar exit code válido
```

**Razón**: Debugging local, desarrollo sin commits, CI/CD agnóstico.

### Regla 2: Exit Codes Estandarizados (CRITICAL)

**Definición**:
- `0` = Success (validación pasó)
- `1` = Failure (validación falló, bloquea CI/CD)
- `2` = Warning (issues no críticos, no bloquea)

**Validación**:
```bash
# Test: Exit codes correctos
./script.sh
[ $? -eq 0 ] && echo "OK: Exit code correcto para success"

./script.sh --fail-mode
[ $? -eq 1 ] && echo "OK: Exit code correcto para failure"
```

**Razón**: Integración con CI/CD, scripting bash, pipelines.

### Regla 3: Output Parseable (CRITICAL)

**Definición**: Soporte para `--output json` y output text human-readable.

**Validación**:
```bash
# Test: JSON válido
OUTPUT=$(./script.py --output json)
echo "$OUTPUT" | jq . > /dev/null
[ $? -eq 0 ] && echo "OK: JSON válido"
```

**Razón**: Automatización, reportes, integración con herramientas.

### Regla 4: Idempotente (CRITICAL)

**Definición**: Múltiples ejecuciones con mismos inputs producen mismo output.

**Validación**:
```bash
# Test: Idempotencia
RESULT1=$(./script.sh --path api/)
RESULT2=$(./script.sh --path api/)
[ "$RESULT1" == "$RESULT2" ] && echo "OK: Idempotente"
```

**Razón**: Confiabilidad, debugging, caching de resultados.

### Regla 5: Versionado Independiente (HIGH)

**Definición**: Cada script tiene versión independiente, versionado semántico.

**Validación**:
```bash
# Test: Flag --version existe
./script.py --version
# Output esperado: "check_sql_injection v1.2.3"
```

**Razón**: Compatibilidad, deprecación gradual, changelog por script.

### Regla 6: Documentación Inline (HIGH)

**Definición**: Flag `--help` con descripción, ejemplos, exit codes.

**Validación**:
```bash
# Test: Help completo
HELP=$(./script.sh --help)
echo "$HELP" | grep -q "Examples:"
echo "$HELP" | grep -q "Exit Codes:"
```

**Razón**: Autodocumentación, onboarding, reducción de soporte.

### Regla 7: Testing Unitario (MEDIUM)

**Definición**: Scripts Python tienen tests en `scripts/testing/unit/`.

**Validación**:
```bash
# Test: Tests existen y pasan
pytest scripts/testing/unit/test_check_sql_injection.py -v
```

**Razón**: Calidad, refactoring seguro, CI/CD confidence.

### Regla 8: Backward Compatible (MEDIUM)

**Definición**: Cambios mantienen compatibilidad con workflows actuales.

**Validación**:
```bash
# Test: GitHub Actions workflow sigue funcionando
git checkout old-workflow-version
.github/workflows/security-scan.yml  # Debe seguir funcionando
```

**Razón**: Migración gradual, no breaking changes, rollback fácil.

---

## Estrategia de Migración en Fases

### FASE 0: Preparación (1-2 días)

**Objetivo**: Crear estructura de directorios y templates.

**Tareas**:
- [x] Crear `ESTRATEGIA_MIGRACION_SHELL_SCRIPTS.md` (este documento)
- [ ] Crear estructura de directorios `scripts/validation/`, `scripts/lib/`, etc.
- [ ] Crear templates: `validator_template.py`, `orchestrator_template.sh`
- [ ] Crear `scripts/lib/common.sh` con funciones compartidas
- [ ] Crear `scripts/lib/exit_codes.sh` con exit codes estandarizados
- [ ] Crear `scripts/testing/unit/` para tests

**Criterio de Éxito**:
```bash
tree scripts/
# Estructura completa creada
ls scripts/lib/common.sh scripts/lib/exit_codes.sh
# Templates disponibles
```

### FASE 1: Extraer Validación de YAML (P0) (3-5 días)

**Objetivo**: Migrar lint.yml (86 líneas embebidas → script Python).

**Tareas**:
- [ ] Crear `scripts/validation/quality/validate_frontmatter.py`
- [ ] Copiar lógica de lint.yml líneas 27-112
- [ ] Aplicar constitution principles (8 reglas)
- [ ] Crear tests: `scripts/testing/unit/test_validate_frontmatter.py`
- [ ] Ejecutar tests: `pytest -v`
- [ ] Modificar lint.yml para llamar script:
  ```yaml
  - name: Validate frontmatter
    run: scripts/validation/quality/validate_frontmatter.py --path implementacion/ --output json
  ```
- [ ] Validar en GitHub Actions
- [ ] Si pasa: Merge, si falla: Refinar

**Criterio de Éxito**:
```bash
# Local execution funciona
./scripts/validation/quality/validate_frontmatter.py --path implementacion/
echo $?  # Exit code correcto

# GitHub Actions usa script
git push && gh run watch  # Workflow pasa
```

**Estimación**: 3-5 días (desarrollo + testing + validación CI/CD)

### FASE 2: Extraer Validaciones de Seguridad (P0) (5-7 días)

**Objetivo**: Migrar security-scan.yml (164 líneas → 6 scripts Python).

**Subtareas**:

**2.1. Crear scripts individuales**:
```bash
scripts/validation/security/check_sql_injection.py       # 18 líneas de YAML
scripts/validation/security/check_xss_protection.py      # 16 líneas
scripts/validation/security/check_csrf_protection.py     # 17 líneas
scripts/validation/security/check_django_security.py     # 19 líneas
scripts/validation/security/parse_npm_audit.py           # 18 líneas
scripts/validation/security/generate_security_report.py  # 44 líneas
```

**2.2. Crear orquestador**:
```bash
scripts/validation/security/run_all_security_checks.sh
# Ejecuta los 6 scripts, agrega resultados, genera reporte consolidado
```

**2.3. Crear tests unitarios**:
```bash
scripts/testing/unit/test_check_sql_injection.py
scripts/testing/unit/test_check_xss_protection.py
# ... etc
```

**2.4. Modificar security-scan.yml**:
```yaml
# ANTES: 9 jobs con lógica embebida
# DESPUÉS: 1 job que llama orquestador
- name: Run Security Checks
  run: scripts/validation/security/run_all_security_checks.sh --output json
```

**Criterio de Éxito**:
```bash
# Todos los scripts ejecutan localmente
./scripts/validation/security/check_sql_injection.py --path api/
./scripts/validation/security/run_all_security_checks.sh

# Tests pasan
pytest scripts/testing/unit/test_check_*.py -v

# GitHub Actions pasa
git push && gh run watch
```

**Estimación**: 5-7 días (6 scripts + orquestador + tests + integración)

### FASE 3: Extraer Validaciones de Compliance (P1) (3-4 días)

**Objetivo**: Migrar backend-ci.yml validaciones de restricciones IACT.

**Tareas**:
- [ ] Analizar `scripts/validate_critical_restrictions.sh` (YA EXISTE)
- [ ] Crear scripts modulares desde backend-ci.yml:
  ```bash
  scripts/validation/compliance/check_no_redis.sh
  scripts/validation/compliance/check_no_email.sh
  scripts/validation/compliance/check_session_backend.sh
  ```
- [ ] Consolidar con `validate_critical_restrictions.sh`
- [ ] Crear orquestador: `run_compliance_checks.sh`
- [ ] Modificar backend-ci.yml para usar scripts

**Criterio de Éxito**:
```bash
# Orquestador ejecuta todas las validaciones
./scripts/validation/compliance/run_compliance_checks.sh
echo $?  # 0 si pasa, 1 si falla

# GitHub Actions usa orquestador
# backend-ci.yml tiene <10 líneas de bash (solo llamadas a scripts)
```

**Estimación**: 3-4 días

### FASE 4: Optimizar emoji-validation.yml (P2) (2-3 días)

**Objetivo**: Mejorar emoji-validation.yml (81 líneas → script integrado).

**Tareas**:
- [ ] Analizar `scripts/workflows/check_no_emojis.py` (YA EXISTE)
- [ ] Integrar lógica de detección de archivos cambiados en Python
- [ ] Añadir modo `--github-pr` que detecta archivos de PR automáticamente
- [ ] Modificar emoji-validation.yml:
  ```yaml
  - name: Check for emojis
    run: |
      if [ "${{ github.event_name }}" = "pull_request" ]; then
        scripts/workflows/check_no_emojis.py --github-pr --output json
      else
        scripts/workflows/check_no_emojis.py --all --output json
      fi
  ```

**Criterio de Éxito**:
```bash
# Script detecta archivos de PR automáticamente
./scripts/workflows/check_no_emojis.py --github-pr

# YAML reducido a <20 líneas
wc -l .github/workflows/emoji-validation.yml  # <50 líneas totales
```

**Estimación**: 2-3 días

### FASE 5: Crear Pipeline Local Completo (P2) (3-4 días)

**Objetivo**: Pipeline completo ejecutable localmente sin GitHub.

**Tareas**:
- [ ] Crear `scripts/ci/pipeline/run_full_pipeline.sh`:
  ```bash
  #!/bin/bash
  # Pipeline completo: quality + security + compliance + tests

  echo "Running Quality Checks..."
  scripts/validation/quality/run_quality_checks.sh || exit 1

  echo "Running Security Checks..."
  scripts/validation/security/run_all_security_checks.sh || exit 1

  echo "Running Compliance Checks..."
  scripts/validation/compliance/run_compliance_checks.sh || exit 1

  echo "Running Tests..."
  pytest tests/ --cov || exit 1

  echo "All checks passed!"
  ```
- [ ] Crear `scripts/ci/pre-commit/run_pre_commit_checks.sh`
- [ ] Crear `scripts/ci/pre-push/run_pre_push_checks.sh`
- [ ] Documentar en CONTRIBUTING.md

**Criterio de Éxito**:
```bash
# Pipeline local ejecuta TODO sin GitHub
./scripts/ci/pipeline/run_full_pipeline.sh
# Output: Quality OK, Security OK, Compliance OK, Tests OK

# Desarrollador puede validar ANTES de commit
./scripts/ci/pre-commit/run_pre_commit_checks.sh
```

**Estimación**: 3-4 días

### FASE 6: Consolidar y Optimizar (P3) (2-3 días)

**Objetivo**: Eliminar duplicación, optimizar performance.

**Tareas**:
- [ ] Identificar validaciones duplicadas entre workflows
- [ ] Consolidar en scripts compartidos
- [ ] Añadir caching de resultados (hash-based)
- [ ] Optimizar performance (parallel execution)
- [ ] Crear `scripts/lib/validators.py` con clases base compartidas
- [ ] Refactorizar scripts para usar lib compartida

**Criterio de Éxito**:
```bash
# Sin duplicación de lógica
# Performance: Pipeline local <2 minutos (vs >5 minutos en GitHub)
time ./scripts/ci/pipeline/run_full_pipeline.sh  # <120 segundos
```

**Estimación**: 2-3 días

---

## Implementación Detallada

### Script 1: validate_frontmatter.py (Ejemplo Completo)

```python
#!/usr/bin/env python3
"""
Validates YAML frontmatter in Markdown requirement files.

Migrated from: .github/workflows/lint.yml (lines 27-112)
Constitution: Complies with all 8 principles
Version: 1.0.0
"""

import os
import re
import sys
import json
import argparse
from pathlib import Path
from typing import List, Dict, Any, Tuple
from datetime import datetime

VERSION = "1.0.0"

EXIT_SUCCESS = 0
EXIT_FAIL = 1
EXIT_WARNING = 2

# Required frontmatter fields
REQUIRED_FIELDS = [
    'id', 'tipo', 'titulo', 'dominio',
    'owner', 'prioridad', 'estado', 'fecha_creacion'
]

# Valid ID format regex
ID_PATTERN = re.compile(r'^(N|RN|RS|RF|RNF)-\d{3}$')

class FrontmatterValidator:
    """Validates YAML frontmatter in Markdown files."""

    def __init__(self, output_format: str = "text", base_path: str = "."):
        self.output_format = output_format
        self.base_path = Path(base_path)
        self.errors: List[Dict[str, Any]] = []
        self.warnings: List[Dict[str, Any]] = []
        self.valid_count = 0

    def validate_directory(self, directory: Path) -> Tuple[int, int, int]:
        """
        Validates all .md files in directory.

        Returns: (valid_count, error_count, warning_count)
        """
        md_files = self._find_markdown_files(directory)

        for md_file in md_files:
            self._validate_file(md_file)

        return (self.valid_count, len(self.errors), len(self.warnings))

    def _find_markdown_files(self, directory: Path) -> List[Path]:
        """Find all requirement markdown files."""
        files = []
        for root, dirs, filenames in os.walk(directory):
            # Skip if not in requisitos directory
            if 'requisitos' not in root:
                continue

            for filename in filenames:
                # Skip special files
                if filename.endswith('.md') and not filename.startswith('_'):
                    files.append(Path(root) / filename)

        return files

    def _validate_file(self, filepath: Path) -> None:
        """Validate single markdown file."""
        try:
            content = filepath.read_text(encoding='utf-8')
        except Exception as e:
            self.errors.append({
                "file": str(filepath),
                "severity": "ERROR",
                "message": f"Failed to read file: {e}"
            })
            return

        # Check frontmatter exists
        match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
        if not match:
            self.errors.append({
                "file": str(filepath),
                "severity": "ERROR",
                "message": "No frontmatter found"
            })
            return

        yaml_content = match.group(1)
        fields = self._parse_simple_yaml(yaml_content)

        # Check required fields
        missing = [f for f in REQUIRED_FIELDS if f not in fields or not fields[f]]

        if missing:
            self.errors.append({
                "file": str(filepath),
                "severity": "ERROR",
                "message": f"Missing required fields: {', '.join(missing)}",
                "missing_fields": missing
            })
        else:
            self.valid_count += 1

        # Check ID format
        if 'id' in fields:
            req_id = fields['id']
            if not ID_PATTERN.match(req_id):
                self.warnings.append({
                    "file": str(filepath),
                    "severity": "WARNING",
                    "message": f"ID '{req_id}' does not follow standard format (N|RN|RS|RF|RNF)-XXX"
                })

    def _parse_simple_yaml(self, yaml_content: str) -> Dict[str, str]:
        """Simple YAML parser for frontmatter."""
        fields = {}
        for line in yaml_content.split('\n'):
            if ':' in line and not line.startswith(' '):
                key, value = line.split(':', 1)
                fields[key.strip()] = value.strip()
        return fields

    def report(self) -> int:
        """Generate report and return exit code."""
        if self.output_format == "json":
            return self._report_json()
        else:
            return self._report_text()

    def _report_json(self) -> int:
        """JSON report for CI/CD."""
        output = {
            "validator": "validate_frontmatter",
            "version": VERSION,
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "summary": {
                "valid_files": self.valid_count,
                "errors": len(self.errors),
                "warnings": len(self.warnings)
            },
            "errors": self.errors,
            "warnings": self.warnings
        }

        if len(self.errors) > 0:
            output["status"] = "FAIL"
            output["exit_code"] = EXIT_FAIL
        elif len(self.warnings) > 0:
            output["status"] = "WARNING"
            output["exit_code"] = EXIT_WARNING
        else:
            output["status"] = "PASS"
            output["exit_code"] = EXIT_SUCCESS

        print(json.dumps(output, indent=2))
        return output["exit_code"]

    def _report_text(self) -> int:
        """Human-readable text report."""
        print(f"[INFO] Frontmatter Validator v{VERSION}")
        print("=" * 80)
        print()

        # Print errors
        if self.errors:
            print("ERRORS:")
            for error in self.errors:
                print(f"  [{error['severity']}] {error['file']}")
                print(f"    {error['message']}")
            print()

        # Print warnings
        if self.warnings:
            print("WARNINGS:")
            for warning in self.warnings:
                print(f"  [{warning['severity']}] {warning['file']}")
                print(f"    {warning['message']}")
            print()

        # Print summary
        print("Validation Results:")
        print(f"  Valid files: {self.valid_count}")
        print(f"  Errors: {len(self.errors)}")
        print(f"  Warnings: {len(self.warnings)}")
        print()

        if len(self.errors) > 0:
            print("[FAIL] VALIDATION FAILED")
            return EXIT_FAIL
        elif len(self.warnings) > 0:
            print("[WARNING] VALIDATION PASSED WITH WARNINGS")
            return EXIT_WARNING
        else:
            print("[PASS] VALIDATION PASSED")
            return EXIT_SUCCESS

def main():
    """Entry point with argument parsing."""
    parser = argparse.ArgumentParser(
        description="Validate YAML frontmatter in requirement Markdown files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Validate requirements directory
  %(prog)s --path implementacion/

  # Validate with JSON output
  %(prog)s --path implementacion/ --output json

  # Show version
  %(prog)s --version

Exit Codes:
  0    All files valid
  1    Errors found (missing required fields)
  2    Warnings found (ID format issues)
        """
    )
    parser.add_argument("--path", required=True,
                        help="Base path to search for requirement files")
    parser.add_argument("--output", choices=["text", "json"], default="text",
                        help="Output format (default: text)")
    parser.add_argument("--version", action="version", version=f"%(prog)s {VERSION}")

    args = parser.parse_args()

    # Validate path exists
    path = Path(args.path)
    if not path.exists():
        print(f"[ERROR] Path does not exist: {args.path}", file=sys.stderr)
        return EXIT_FAIL

    # Run validation
    validator = FrontmatterValidator(
        output_format=args.output,
        base_path=args.path
    )

    validator.validate_directory(path)
    return validator.report()

if __name__ == "__main__":
    sys.exit(main())
```

### Modificación de lint.yml (ANTES vs DESPUÉS)

**ANTES (86 líneas embebidas)**:
```yaml
# .github/workflows/lint.yml
- name: Validate frontmatter
  run: |
    python3 << 'EOF'
    import os
    import re
    import sys

    print("Validating requirements frontmatter...")
    # ... 86 líneas más ...
    EOF
```

**DESPUÉS (1 línea)**:
```yaml
# .github/workflows/lint.yml
- name: Validate frontmatter
  run: scripts/validation/quality/validate_frontmatter.py --path implementacion/ --output json
```

**Reducción**: 86 líneas → 1 línea (98.8% reducción)

---

## Validación y Testing

### Estrategia de Testing

**Nivel 1: Tests Unitarios** (para cada script Python):
```python
# scripts/testing/unit/test_validate_frontmatter.py
import pytest
from pathlib import Path
from scripts.validation.quality.validate_frontmatter import FrontmatterValidator

def test_valid_frontmatter():
    """Test file with valid frontmatter."""
    validator = FrontmatterValidator(output_format="json")
    # ... test implementation ...
    assert validator.valid_count == 1

def test_missing_required_fields():
    """Test file missing required fields."""
    validator = FrontmatterValidator(output_format="json")
    # ... test implementation ...
    assert len(validator.errors) == 1

def test_invalid_id_format():
    """Test file with invalid ID format."""
    validator = FrontmatterValidator(output_format="json")
    # ... test implementation ...
    assert len(validator.warnings) == 1
```

**Nivel 2: Tests de Integración** (para orquestadores):
```bash
# scripts/testing/integration/test_full_pipeline.sh
#!/bin/bash

set -e

echo "Testing full pipeline integration..."

# Test 1: Pipeline runs without errors
./scripts/ci/pipeline/run_full_pipeline.sh
if [ $? -ne 0 ]; then
    echo "FAIL: Pipeline failed"
    exit 1
fi

# Test 2: Individual validators work
./scripts/validation/quality/validate_frontmatter.py --path implementacion/
./scripts/validation/security/check_sql_injection.py --path api/

echo "PASS: All integration tests passed"
```

**Nivel 3: Tests de GitHub Actions** (CI/CD):
```yaml
# .github/workflows/test-scripts.yml
name: Test Validation Scripts

on: [pull_request]

jobs:
  test-scripts:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: pip install pytest pytest-cov

      - name: Run unit tests
        run: pytest scripts/testing/unit/ -v --cov=scripts/validation

      - name: Run integration tests
        run: bash scripts/testing/integration/test_full_pipeline.sh
```

### Validación de Constitution Compliance

**Script de auto-validación**:
```python
# scripts/testing/validate_constitution_compliance.py
"""
Validates that all scripts comply with Constitution Principles.
"""

def check_principle_1_local_execution(script_path):
    """Principle 1: Ejecutable localmente."""
    # Test: Can run without GitHub env vars
    env = os.environ.copy()
    env.pop('GITHUB_ACTIONS', None)
    env.pop('GITHUB_WORKSPACE', None)

    result = subprocess.run([script_path, '--help'], env=env)
    assert result.returncode == 0, "Script requires GitHub environment"

def check_principle_2_exit_codes(script_path):
    """Principle 2: Exit codes estandarizados."""
    # Test: Returns 0, 1, or 2
    result = subprocess.run([script_path, '--version'])
    assert result.returncode in [0, 1, 2], f"Invalid exit code: {result.returncode}"

def check_principle_6_help_flag(script_path):
    """Principle 6: Documentación inline."""
    result = subprocess.run([script_path, '--help'], capture_output=True, text=True)
    assert "Examples:" in result.stdout, "Missing examples in --help"
    assert "Exit Codes:" in result.stdout, "Missing exit codes in --help"

# ... más validaciones ...
```

---

## Roadmap de Ejecución

### Timeline Estimado

```
Semana 1:
  - Días 1-2: FASE 0 (Preparación)
  - Días 3-5: FASE 1 (validate_frontmatter.py)

Semana 2:
  - Días 1-5: FASE 2 (Security scripts - 6 scripts)

Semana 3:
  - Días 1-4: FASE 3 (Compliance scripts)
  - Día 5: FASE 4 (Optimizar emoji-validation)

Semana 4:
  - Días 1-3: FASE 5 (Pipeline local completo)
  - Días 4-5: FASE 6 (Consolidar y optimizar)

TOTAL: 4 semanas (20 días laborables)
```

### Métricas de Éxito

**Meta Final**:
```
Ratio objetivo:
  - GitHub Actions (YAML):      1,500 líneas (30%) - Solo orquestación
  - Shell/Python Scripts:       3,500 líneas (70%) - Lógica de validación

Reducción de lógica embebida: 416 líneas → <50 líneas (88% reducción)

Scripts creados:
  - Validadores Python:         12 scripts
  - Orquestadores Shell:        6 scripts
  - Tests unitarios:            15 archivos
  - Tests integración:          5 archivos

Ejecutabilidad local:         100% de validaciones
Coverage de tests:            >80%
```

### Indicadores de Progreso

**KPIs por Fase**:

| Fase | Métrica | Objetivo |
|------|---------|----------|
| 0 | Estructura creada | 100% directorios |
| 1 | YAML lines reducidas | lint.yml: 86→1 líneas |
| 2 | Scripts security creados | 6/6 scripts |
| 3 | Scripts compliance creados | 4/4 scripts |
| 4 | emoji-validation optimizado | <20 líneas bash |
| 5 | Pipeline local funcional | Exit code 0 |
| 6 | Duplicación eliminada | 0 validaciones duplicadas |

---

## Beneficios Esperados

### Beneficios Técnicos

1. **Ejecutabilidad Local**:
   - Desarrolladores validan ANTES de commit
   - Debugging sin necesidad de GitHub
   - CI/CD agnóstico (Jenkins, GitLab CI, etc.)

2. **Mantenibilidad**:
   - Lógica centralizada en scripts
   - Versionado independiente
   - Testing unitario robusto

3. **Reutilización**:
   - Scripts compartibles entre proyectos
   - Librerías comunes (`scripts/lib/`)
   - Patterns replicables

4. **Performance**:
   - Ejecución paralela posible
   - Caching de resultados
   - Pipeline local <2 minutos

### Beneficios de Proceso

1. **Onboarding**:
   - Nuevos desarrolladores ejecutan `./scripts/ci/pipeline/run_full_pipeline.sh`
   - Auto-documentación con `--help`
   - Menos dependencia de CI/CD

2. **Debugging**:
   - Errores reproducibles localmente
   - Logs detallados
   - Iteración rápida

3. **Flexibilidad**:
   - CI/CD agnóstico
   - Migración a otras plataformas fácil
   - No lock-in con GitHub Actions

---

## Riesgos y Mitigaciones

### Riesgo 1: Aumento de complejidad inicial

**Mitigación**:
- Fase 0 crea templates claros
- Documentación exhaustiva
- Self-Refine: Validación continua

### Riesgo 2: Breaking changes en workflows

**Mitigación**:
- Constitution Principle 8: Backward compatibility
- Testing en cada fase
- Rollback fácil (git revert)

### Riesgo 3: Falta de adopción por equipo

**Mitigación**:
- CONTRIBUTING.md actualizado
- Demos de pipeline local
- Beneficios claros documentados

### Riesgo 4: Mantenimiento de scripts duplicado

**Mitigación**:
- FASE 6 elimina duplicación
- Librerías compartidas (`scripts/lib/`)
- Tests previenen regresiones

---

## Conclusión

Esta estrategia aplica **8 técnicas avanzadas de Prompt Engineering** para migrar sistemáticamente de GitHub Actions embebido a shell scripts standalone:

1. **Chain of Thought**: Migración en 6 fases validadas
2. **Constitutional AI**: 8 principios inmutables
3. **Tree of Thoughts**: Arquitectura híbrida Shell+Python
4. **Least-to-Most**: Complejidad incremental
5. **Skeleton-of-Thought**: Estructura antes que implementación
6. **Self-Refine**: Validación continua contra constitution
7. **ReAct Pattern**: Scripts que razonan antes de actuar
8. **Metacognitive Prompting**: Scripts auto-documentados

**Resultado esperado**:
- 88% reducción de lógica embebida en YAML
- 100% de validaciones ejecutables localmente
- Pipeline local completo en <2 minutos
- CI/CD agnóstico y mantenible

**Timeline**: 4 semanas (20 días laborables)

**Próximo paso inmediato**: Ejecutar FASE 0 (Preparación).

---

**Generado**: 2025-11-09
**Versión**: 1.0.0
**Autor**: Análisis estratégico con técnicas de Prompt Engineering
