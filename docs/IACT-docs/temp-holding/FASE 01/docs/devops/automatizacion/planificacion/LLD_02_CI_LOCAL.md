---
title: LLD - Pipeline CI/CD Local Unificado
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: design
subfase: lld_ci_local
proyecto: IACT---project
parent_doc: HLD_SISTEMA_AUTOMATIZACION.md
status: in_progress
version: 1.0
---

# Low-Level Design: Pipeline CI/CD Local Unificado UI+API

**Issue**: IACT-AUTO-001
**Fase**: FASE 3 - DESIGN (Low-Level Design - Módulo 2)
**Fecha**: 2025-11-13
**Parent**: HLD_SISTEMA_AUTOMATIZACION.md v2.0, LLD_00_OVERVIEW.md

---

## 1. Archivo Configuracion: .ci-local.yaml

**Ubicacion**: `/home/user/IACT---project/.ci-local.yaml` (raiz repo)
**Proposito**: Configurar pipeline CI/CD ejecutable localmente (offline-capable)

**Especificacion Completa**:

```yaml
---
# ===================================================================
# CI/CD LOCAL PIPELINE CONFIGURATION - IACT Project
# Pipeline unificado UI (React) + API (Django)
# ===================================================================
version: "1.0"

metadata:
  project: "IACT---project"
  description: "Pipeline CI/CD local ejecutable offline"
  maintained_by: "DevOps Team"
  documentation: "docs/devops/automatizacion/ci_cd/"

# ===================================================================
# PIPELINE CONFIGURATION
# ===================================================================
pipeline:
  name: "IACT Local CI"
  description: "Validacion completa UI + API antes de push"

  # Comportamiento pipeline
  fail_fast: true         # Detener en primer error de stage
  parallel: true          # Ejecutar stages independientes en paralelo
  timeout: 600            # 10 min timeout total pipeline

  # Deteccion cambios inteligente
  smart_detection:
    enabled: true
    strategy: git_diff    # Detectar que cambio: UI, API, o ambos
    base_branch: main

# ===================================================================
# STAGES DEL PIPELINE
# ===================================================================
stages:
  # ─────────────────────────────────────────────────────────────────
  # STAGE 1: LINT
  # Linting de codigo UI (ESLint) + API (Ruff)
  # ─────────────────────────────────────────────────────────────────
  - name: lint
    description: "Linting UI (ESLint) + API (Ruff) + Markdown"
    parallel: true        # Jobs en paralelo
    depends_on: []        # Sin dependencias

    jobs:
      # Lint UI (JavaScript/React)
      - name: lint_ui
        description: "ESLint en UI (React/JS)"
        working_dir: ui/
        command: "npm run lint"
        continue_on_error: false
        timeout: 60       # 1 min

        # Ejecucion condicional (solo si UI cambio)
        condition:
          type: files_changed
          pattern: 'ui/**/*.(js|jsx|ts|tsx)'

        # Artifacts
        artifacts: []

        # Metricas
        metrics:
          - name: lint_errors_count
            extract_from: stdout
            regex: '(\d+) error'

      # Lint API (Python/Django)
      - name: lint_api
        description: "Ruff en API (Django/Python)"
        working_dir: api/callcentersite/
        command: "ruff check ."
        continue_on_error: false
        timeout: 60

        condition:
          type: files_changed
          pattern: 'api/**/*.py'

        artifacts: []

        metrics:
          - name: ruff_errors_count
            extract_from: stdout
            regex: 'Found (\d+) error'

      # Lint Markdown (docs)
      - name: lint_markdown
        description: "Markdownlint en documentacion"
        working_dir: docs/
        command: "markdownlint **/*.md --config ../.markdownlint.json"
        continue_on_error: true  # Warnings no bloquean
        timeout: 30

        condition:
          type: files_changed
          pattern: 'docs/**/*.md'

  # ─────────────────────────────────────────────────────────────────
  # STAGE 2: TEST
  # Tests UI (Jest) + API (Pytest) con coverage
  # ─────────────────────────────────────────────────────────────────
  - name: test
    description: "Tests UI (Jest) + API (Pytest) con coverage"
    parallel: true
    depends_on:
      - lint              # Solo ejecutar si lint paso

    jobs:
      # Tests UI (Jest + React Testing Library)
      - name: test_ui
        description: "Jest tests UI con coverage"
        working_dir: ui/
        command: "npm run test:coverage"
        continue_on_error: false
        timeout: 120      # 2 min

        condition:
          type: files_changed
          pattern: 'ui/**/*.(js|jsx|ts|tsx)'

        # Coverage threshold
        coverage:
          enabled: true
          threshold: 80
          file: coverage/coverage-summary.json
          format: json
          extract_path: '$.total.lines.pct'

        # Artifacts
        artifacts:
          - path: coverage/
            name: ui-coverage
            retention: 7    # days

        # Metricas
        metrics:
          - name: ui_tests_passed
            extract_from: stdout
            regex: 'Tests:.*?(\d+) passed'
          - name: ui_tests_failed
            extract_from: stdout
            regex: 'Tests:.*?(\d+) failed'
          - name: ui_coverage_pct
            extract_from: file
            file: coverage/coverage-summary.json
            path: '$.total.lines.pct'

      # Tests API (Pytest + Coverage)
      - name: test_api
        description: "Pytest tests API con coverage"
        working_dir: api/callcentersite/
        command: "pytest --cov --cov-report=json --cov-report=term --tb=short"
        continue_on_error: false
        timeout: 180      # 3 min

        condition:
          type: files_changed
          pattern: 'api/**/*.py'

        # Coverage threshold
        coverage:
          enabled: true
          threshold: 80
          file: coverage.json
          format: json
          extract_path: '$.totals.percent_covered'

        # Artifacts
        artifacts:
          - path: coverage.json
            name: api-coverage
            retention: 7
          - path: .coverage
            name: api-coverage-db
            retention: 7

        # Metricas
        metrics:
          - name: api_tests_passed
            extract_from: stdout
            regex: '(\d+) passed'
          - name: api_tests_failed
            extract_from: stdout
            regex: '(\d+) failed'
          - name: api_coverage_pct
            extract_from: file
            file: coverage.json
            path: '$.totals.percent_covered'

  # ─────────────────────────────────────────────────────────────────
  # STAGE 3: BUILD
  # Build UI (Webpack) + API (collectstatic)
  # ─────────────────────────────────────────────────────────────────
  - name: build
    description: "Build UI (Webpack production) + API (collectstatic)"
    parallel: true
    depends_on:
      - test

    jobs:
      # Build UI (Webpack production)
      - name: build_ui
        description: "Webpack build production"
        working_dir: ui/
        command: "npm run build"
        continue_on_error: false
        timeout: 120

        condition:
          type: files_changed
          pattern: 'ui/**/*.(js|jsx|ts|tsx|css|html)'

        # Artifacts
        artifacts:
          - path: dist/
            name: ui-bundle
            retention: 7

        # Metricas
        metrics:
          - name: bundle_size_kb
            extract_from: stdout
            regex: 'main\..*?\.js.*?(\d+) KiB'

      # Build API (Django collectstatic + check --deploy)
      - name: build_api
        description: "Django collectstatic + deployment checks"
        working_dir: api/callcentersite/
        command: |
          python manage.py collectstatic --noinput --clear &&
          python manage.py check --deploy
        continue_on_error: false
        timeout: 60

        condition:
          type: files_changed
          pattern: 'api/**/*.(py|html|css|js)'

        # Artifacts
        artifacts:
          - path: staticfiles/
            name: api-static
            retention: 7

  # ─────────────────────────────────────────────────────────────────
  # STAGE 4: VALIDATE
  # Validaciones especificas IACT (security, DB, constitucion, docs)
  # ─────────────────────────────────────────────────────────────────
  - name: validate
    description: "Validaciones especificas IACT"
    parallel: false       # Secuencial (algunas validaciones pesadas)
    depends_on:
      - build

    jobs:
      # Validacion seguridad
      - name: validate_security
        description: "Validar configuracion seguridad"
        working_dir: .
        command: "./scripts/validate_security_config.sh"
        continue_on_error: false
        timeout: 60

        condition:
          type: files_changed
          pattern: 'api/**/settings/**/*.py'

      # Validacion database router
      - name: validate_database_router
        description: "Validar database routing PostgreSQL+MariaDB"
        working_dir: .
        command: "./scripts/validate_database_router.sh"
        continue_on_error: false
        timeout: 30

        condition:
          type: files_changed
          pattern: 'api/**/(models|db_router)\.py'

      # Validacion constitucion (NUEVO)
      - name: validate_constitucion
        description: "Validar conformidad con constitucion"
        working_dir: .
        command: "./scripts/constitucion.sh --mode=validate-all"
        continue_on_error: true   # Warnings permitidos
        timeout: 60

        # Artifacts
        artifacts:
          - path: .automation-logs/constitucion/validate-all-*.log
            name: constitucion-report
            retention: 30

      # Validacion estructura docs
      - name: validate_docs_structure
        description: "Validar estructura documentacion"
        working_dir: .
        command: "./scripts/validar_estructura_docs.sh"
        continue_on_error: true
        timeout: 30

        condition:
          type: files_changed
          pattern: 'docs/**/*.md'

      # Validacion restricciones criticas
      - name: validate_critical_restrictions
        description: "Validar restricciones criticas proyecto"
        working_dir: .
        command: "./scripts/validate_critical_restrictions.sh"
        continue_on_error: false
        timeout: 30

# ===================================================================
# REPORTING CONFIGURATION
# ===================================================================
reporting:
  # Formato output
  format: text            # text | json | html
  verbosity: normal       # quiet | normal | verbose

  # Colores (solo si terminal soporta)
  colors: auto            # auto | always | never

  # Guardado artifacts
  save_artifacts: true
  artifacts_dir: .ci-artifacts
  retention_days: 7

  # Resumen final
  summary:
    enabled: true
    sections:
      - stage_results     # Resultado cada stage
      - metrics           # Metricas agregadas
      - coverage          # Coverage UI + API
      - timing            # Duracion stages
      - artifacts         # Artifacts generados

# ===================================================================
# LOGGING CONFIGURATION
# ===================================================================
logging:
  enabled: true
  directory: .automation-logs/ci-local
  retention_days: 30
  format: text

  # Niveles log
  level: INFO             # DEBUG | INFO | WARNING | ERROR

  # Log por stage
  per_stage: true

  # Timestamps
  timestamps: true

# ===================================================================
# NOTIFICATIONS (OPCIONAL)
# ===================================================================
notifications:
  # Notificacion exito
  on_success:
    enabled: true
    message: "CI Local: All stages passed"
    sound: false

  # Notificacion fallo
  on_failure:
    enabled: true
    message: "CI Local: Failed at stage {stage_name}"
    sound: true

  # Notificacion warnings
  on_warning:
    enabled: true
    message: "CI Local: Completed with {warning_count} warnings"
    sound: false

# ===================================================================
# HOOKS (PRE/POST PIPELINE)
# ===================================================================
hooks:
  # Pre-pipeline: ejecutar antes de pipeline
  pre_pipeline:
    enabled: true
    jobs:
      - name: fetch_main
        description: "Actualizar referencia main"
        command: "git fetch origin main"
        continue_on_error: true
        timeout: 10

  # Post-pipeline: ejecutar despues de pipeline
  post_pipeline:
    enabled: true
    jobs:
      - name: update_dora_metrics
        description: "Actualizar metricas DORA"
        command: "./scripts/generate_dora_report.sh"
        continue_on_error: true
        timeout: 30
```

---

## 2. Script Orquestador: scripts/ci-local.sh

**Ubicacion**: `/home/user/IACT---project/scripts/ci-local.sh`
**Proposito**: Orquestar ejecucion completa pipeline CI/CD local
**Lenguaje**: Bash
**Permisos**: `chmod +x scripts/ci-local.sh`

**Especificacion Completa**:

```bash
#!/usr/bin/env bash
# ===================================================================
# scripts/ci-local.sh
# CI/CD Local Pipeline Orchestrator - IACT Project
# ===================================================================
# Uso:
#   ./ci-local.sh
#   ./ci-local.sh --verbose
#   ./ci-local.sh --stage=lint
#   ./ci-local.sh --skip-stage=build
# ===================================================================

set -euo pipefail

# ===================================================================
# CONSTANTS
# ===================================================================
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly CONFIG_FILE="$PROJECT_ROOT/.ci-local.yaml"
readonly LOG_DIR="$PROJECT_ROOT/.automation-logs/ci-local"
readonly ARTIFACTS_DIR="$PROJECT_ROOT/.ci-artifacts"
readonly TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
readonly LOG_FILE="$LOG_DIR/$TIMESTAMP.log"

# Colors
if [ -t 1 ]; then
    readonly RED='\033[0;31m'
    readonly YELLOW='\033[1;33m'
    readonly GREEN='\033[0;32m'
    readonly BLUE='\033[0;34m'
    readonly CYAN='\033[0;36m'
    readonly BOLD='\033[1m'
    readonly NC='\033[0m'
else
    readonly RED=''
    readonly YELLOW=''
    readonly GREEN=''
    readonly BLUE=''
    readonly CYAN=''
    readonly BOLD=''
    readonly NC=''
fi

# ===================================================================
# GLOBAL VARIABLES
# ===================================================================
VERBOSE=false
DRY_RUN=false
SPECIFIC_STAGE=""
SKIP_STAGES=()

# Pipeline state
PIPELINE_START_TIME=$(date +%s)
PIPELINE_STATUS=0
STAGES_PASSED=0
STAGES_FAILED=0
STAGES_SKIPPED=0

# Results tracking
declare -A STAGE_RESULTS
declare -A STAGE_DURATIONS
declare -A JOB_RESULTS

# ===================================================================
# FUNCTIONS
# ===================================================================

#####################################################################
# Print usage
#####################################################################
usage() {
    cat <<EOF
CI/CD LOCAL PIPELINE - IACT Project

Ejecuta pipeline CI/CD completo localmente (offline-capable)

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --verbose               Output detallado
    --dry-run               Simular sin ejecutar
    --stage=STAGE          Ejecutar solo este stage
    --skip-stage=STAGE     Saltar este stage
    --help                  Mostrar esta ayuda

STAGES DISPONIBLES:
    lint      Linting UI + API + Markdown
    test      Tests UI (Jest) + API (Pytest)
    build     Build UI (Webpack) + API (collectstatic)
    validate  Validaciones IACT (security, DB, constitucion, docs)

EXAMPLES:
    $0                      # Ejecutar pipeline completo
    $0 --verbose            # Con output detallado
    $0 --stage=lint         # Solo linting
    $0 --skip-stage=build   # Saltar build

EXIT CODES:
    0   Pipeline completo exitoso
    1   Al menos un stage fallo
    2   Error configuracion o ejecucion

DOCUMENTATION:
    docs/devops/automatizacion/ci_cd/

EOF
    exit 0
}

#####################################################################
# Initialize: create dirs, validate config
#####################################################################
initialize() {
    # Create directories
    mkdir -p "$LOG_DIR"
    mkdir -p "$ARTIFACTS_DIR"

    # Validate config exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}ERROR: Config not found: $CONFIG_FILE${NC}" >&2
        exit 2
    fi

    # Validate yq installed
    if ! command -v yq &> /dev/null; then
        echo -e "${RED}ERROR: yq not installed${NC}" >&2
        echo "Install: sudo apt-get install yq OR brew install yq" >&2
        exit 2
    fi

    # Log pipeline start
    {
        echo "========================================"
        echo "CI/CD LOCAL PIPELINE - IACT"
        echo "========================================"
        echo "Date: $(date)"
        echo "Config: $CONFIG_FILE"
        echo "Log: $LOG_FILE"
        echo "========================================"
        echo ""
    } | tee -a "$LOG_FILE"
}

#####################################################################
# Load config value
# Args: yq_query
# Returns: value
#####################################################################
get_config() {
    local query="$1"
    yq eval "$query" "$CONFIG_FILE"
}

#####################################################################
# Check if files changed (smart detection)
# Args: pattern
# Returns: 0 if changed, 1 if not
#####################################################################
files_changed() {
    local pattern="$1"
    local base_branch
    base_branch=$(get_config '.pipeline.smart_detection.base_branch')

    # Get changed files vs base branch
    local changed_files
    changed_files=$(git diff --name-only "$base_branch"...HEAD 2>/dev/null || \
                    git diff --name-only HEAD 2>/dev/null || \
                    echo "")

    if [ -z "$changed_files" ]; then
        return 1  # No changes
    fi

    # Check if any file matches pattern
    if echo "$changed_files" | grep -qE "$pattern"; then
        return 0  # Files changed
    else
        return 1  # No matching files
    fi
}

#####################################################################
# Execute job
# Args: stage_name, job_name
# Returns: exit code of job
#####################################################################
execute_job() {
    local stage_name="$1"
    local job_name="$2"
    local job_start_time=$(date +%s)

    # Load job config
    local job_index
    job_index=$(yq eval ".stages[] | select(.name == \"$stage_name\") | .jobs[] | select(.name == \"$job_name\")" "$CONFIG_FILE" -o=json | jq -s 'length - 1')

    local working_dir
    working_dir=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[$job_index].working_dir")

    local command
    command=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[$job_index].command")

    local timeout
    timeout=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[$job_index].timeout")

    local continue_on_error
    continue_on_error=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[$job_index].continue_on_error")

    # Check condition
    local condition_type
    condition_type=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[$job_index].condition.type")

    if [ "$condition_type" = "files_changed" ]; then
        local condition_pattern
        condition_pattern=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[$job_index].condition.pattern")

        if ! files_changed "$condition_pattern"; then
            echo -e "  ${CYAN}SKIP${NC} (no files changed matching: $condition_pattern)" | tee -a "$LOG_FILE"
            return 0  # Skip job
        fi
    fi

    # Execute command
    echo -e "${BLUE}Executing job: $job_name${NC}" | tee -a "$LOG_FILE"
    echo "  Working dir: $working_dir" | tee -a "$LOG_FILE"
    echo "  Command: $command" | tee -a "$LOG_FILE"
    echo "  Timeout: ${timeout}s" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Change to working directory
    pushd "$PROJECT_ROOT/$working_dir" > /dev/null 2>&1 || {
        echo -e "${RED}ERROR: Cannot cd to $working_dir${NC}" | tee -a "$LOG_FILE"
        return 1
    }

    # Execute with timeout
    set +e
    timeout "${timeout}s" bash -c "$command" &>> "$LOG_FILE"
    local exit_code=$?
    set -e

    # Return to project root
    popd > /dev/null 2>&1

    # Calculate duration
    local job_end_time=$(date +%s)
    local job_duration=$((job_end_time - job_start_time))

    # Check result
    if [ $exit_code -eq 0 ]; then
        echo -e "  ${GREEN}PASS${NC} (${job_duration}s)" | tee -a "$LOG_FILE"
        JOB_RESULTS["$stage_name:$job_name"]="PASS"
        return 0
    elif [ $exit_code -eq 124 ]; then
        echo -e "  ${RED}TIMEOUT${NC} (>${timeout}s)" | tee -a "$LOG_FILE"
        JOB_RESULTS["$stage_name:$job_name"]="TIMEOUT"
        return 1
    else
        echo -e "  ${RED}FAIL${NC} (exit code: $exit_code, ${job_duration}s)" | tee -a "$LOG_FILE"
        JOB_RESULTS["$stage_name:$job_name"]="FAIL"

        if [ "$continue_on_error" = "true" ]; then
            echo -e "  ${YELLOW}Continuing despite error (continue_on_error=true)${NC}" | tee -a "$LOG_FILE"
            return 0  # Treat as success
        else
            return $exit_code
        fi
    fi
}

#####################################################################
# Execute stage
# Args: stage_name
# Returns: 0 if passed, 1 if failed
#####################################################################
execute_stage() {
    local stage_name="$1"
    local stage_start_time=$(date +%s)

    echo "" | tee -a "$LOG_FILE"
    echo -e "${BOLD}=======================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${BOLD}STAGE: $stage_name${NC}" | tee -a "$LOG_FILE"
    echo -e "${BOLD}=======================================${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Check if should skip
    for skip_stage in "${SKIP_STAGES[@]}"; do
        if [ "$skip_stage" = "$stage_name" ]; then
            echo -e "${CYAN}SKIPPED${NC} (--skip-stage specified)" | tee -a "$LOG_FILE"
            STAGE_RESULTS["$stage_name"]="SKIPPED"
            STAGES_SKIPPED=$((STAGES_SKIPPED + 1))
            return 0
        fi
    done

    # Get jobs for stage
    local jobs
    jobs=$(get_config ".stages[] | select(.name == \"$stage_name\") | .jobs[].name")

    if [ -z "$jobs" ]; then
        echo -e "${YELLOW}WARNING: No jobs found for stage${NC}" | tee -a "$LOG_FILE"
        STAGE_RESULTS["$stage_name"]="SKIPPED"
        STAGES_SKIPPED=$((STAGES_SKIPPED + 1))
        return 0
    fi

    # Check if parallel
    local parallel
    parallel=$(get_config ".stages[] | select(.name == \"$stage_name\") | .parallel")

    local stage_failed=false

    # Execute jobs
    if [ "$parallel" = "true" ]; then
        echo "Executing jobs in PARALLEL" | tee -a "$LOG_FILE"
        echo "" | tee -a "$LOG_FILE"

        # Execute jobs in parallel (background)
        local pids=()
        while IFS= read -r job_name; do
            execute_job "$stage_name" "$job_name" &
            pids+=($!)
        done <<< "$jobs"

        # Wait for all jobs
        local any_failed=false
        for pid in "${pids[@]}"; do
            if ! wait "$pid"; then
                any_failed=true
            fi
        done

        if $any_failed; then
            stage_failed=true
        fi
    else
        echo "Executing jobs SEQUENTIALLY" | tee -a "$LOG_FILE"
        echo "" | tee -a "$LOG_FILE"

        # Execute jobs sequentially
        while IFS= read -r job_name; do
            if ! execute_job "$stage_name" "$job_name"; then
                stage_failed=true

                # Check fail_fast
                local fail_fast
                fail_fast=$(get_config '.pipeline.fail_fast')

                if [ "$fail_fast" = "true" ]; then
                    echo -e "${RED}FAIL_FAST enabled, stopping stage${NC}" | tee -a "$LOG_FILE"
                    break
                fi
            fi
        done <<< "$jobs"
    fi

    # Calculate stage duration
    local stage_end_time=$(date +%s)
    local stage_duration=$((stage_end_time - stage_start_time))
    STAGE_DURATIONS["$stage_name"]=$stage_duration

    # Record result
    if $stage_failed; then
        echo "" | tee -a "$LOG_FILE"
        echo -e "${RED}Stage FAILED${NC} (${stage_duration}s)" | tee -a "$LOG_FILE"
        STAGE_RESULTS["$stage_name"]="FAILED"
        STAGES_FAILED=$((STAGES_FAILED + 1))
        return 1
    else
        echo "" | tee -a "$LOG_FILE"
        echo -e "${GREEN}Stage PASSED${NC} (${stage_duration}s)" | tee -a "$LOG_FILE"
        STAGE_RESULTS["$stage_name"]="PASSED"
        STAGES_PASSED=$((STAGES_PASSED + 1))
        return 0
    fi
}

#####################################################################
# Print summary
#####################################################################
print_summary() {
    local pipeline_end_time=$(date +%s)
    local pipeline_duration=$((pipeline_end_time - PIPELINE_START_TIME))

    echo "" | tee -a "$LOG_FILE"
    echo -e "${BOLD}=======================================${NC}" | tee -a "$LOG_FILE"
    echo -e "${BOLD}PIPELINE SUMMARY${NC}" | tee -a "$LOG_FILE"
    echo -e "${BOLD}=======================================${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Stage results
    echo "Stage Results:" | tee -a "$LOG_FILE"
    for stage_name in "${!STAGE_RESULTS[@]}"; do
        local result="${STAGE_RESULTS[$stage_name]}"
        local duration="${STAGE_DURATIONS[$stage_name]:-0}"

        case "$result" in
            PASSED)
                echo -e "  ${GREEN}[PASS]${NC} $stage_name (${duration}s)" | tee -a "$LOG_FILE"
                ;;
            FAILED)
                echo -e "  ${RED}[FAIL]${NC} $stage_name (${duration}s)" | tee -a "$LOG_FILE"
                ;;
            SKIPPED)
                echo -e "  ${CYAN}[SKIP]${NC} $stage_name" | tee -a "$LOG_FILE"
                ;;
        esac
    done

    echo "" | tee -a "$LOG_FILE"

    # Overall stats
    echo "Overall Statistics:" | tee -a "$LOG_FILE"
    echo "  Stages Passed:  $STAGES_PASSED" | tee -a "$LOG_FILE"
    echo "  Stages Failed:  $STAGES_FAILED" | tee -a "$LOG_FILE"
    echo "  Stages Skipped: $STAGES_SKIPPED" | tee -a "$LOG_FILE"
    echo "  Total Duration: ${pipeline_duration}s ($(($pipeline_duration / 60))m $(($pipeline_duration % 60))s)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Final result
    if [ $PIPELINE_STATUS -eq 0 ]; then
        echo -e "${GREEN}${BOLD}PIPELINE: PASSED${NC}" | tee -a "$LOG_FILE"
    else
        echo -e "${RED}${BOLD}PIPELINE: FAILED${NC}" | tee -a "$LOG_FILE"
    fi

    echo "" | tee -a "$LOG_FILE"
    echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
    echo "Artifacts: $ARTIFACTS_DIR" | tee -a "$LOG_FILE"
    echo -e "${BOLD}=======================================${NC}" | tee -a "$LOG_FILE"
}

#####################################################################
# Main pipeline execution
#####################################################################
run_pipeline() {
    # Execute pre-pipeline hooks
    if [ "$(get_config '.hooks.pre_pipeline.enabled')" = "true" ]; then
        echo -e "${CYAN}Executing pre-pipeline hooks...${NC}" | tee -a "$LOG_FILE"
        # TODO: implement hook execution
    fi

    # Get stages
    local stages
    if [ -n "$SPECIFIC_STAGE" ]; then
        stages="$SPECIFIC_STAGE"
    else
        stages=$(get_config '.stages[].name')
    fi

    # Execute stages
    local fail_fast
    fail_fast=$(get_config '.pipeline.fail_fast')

    while IFS= read -r stage_name; do
        if ! execute_stage "$stage_name"; then
            PIPELINE_STATUS=1

            if [ "$fail_fast" = "true" ]; then
                echo -e "${RED}FAIL_FAST enabled, stopping pipeline${NC}" | tee -a "$LOG_FILE"
                break
            fi
        fi
    done <<< "$stages"

    # Execute post-pipeline hooks
    if [ "$(get_config '.hooks.post_pipeline.enabled')" = "true" ]; then
        echo -e "${CYAN}Executing post-pipeline hooks...${NC}" | tee -a "$LOG_FILE"
        # TODO: implement hook execution
    fi
}

#####################################################################
# MAIN
#####################################################################
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose)
                VERBOSE=true
                set -x
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --stage=*)
                SPECIFIC_STAGE="${1#*=}"
                shift
                ;;
            --skip-stage=*)
                SKIP_STAGES+=("${1#*=}")
                shift
                ;;
            --help)
                usage
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
    done

    # Initialize
    initialize

    # Run pipeline
    run_pipeline

    # Print summary
    print_summary

    # Exit
    exit $PIPELINE_STATUS
}

# Entry point
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
```

---

## 3. Integracion con Scripts Existentes

### 3.1 scripts/run_all_tests.sh

**Como se invoca desde CI local**:

En `.ci-local.yaml` stage `validate`:
```yaml
- name: run_all_tests
  command: "./scripts/run_all_tests.sh"
```

**Modificaciones necesarias** (si alguna):
- Asegurar que script retorna exit code correcto (0=pass, 1=fail)
- Asegurar que output es parseable

### 3.2 scripts/validate_security_config.sh

**Como se invoca**:
```yaml
- name: validate_security
  command: "./scripts/validate_security_config.sh"
```

### 3.3 scripts/validate_database_router.sh

**Como se invoca**:
```yaml
- name: validate_database_router
  command: "./scripts/validate_database_router.sh"
```

---

## 4. Metricas y Observabilidad

### 4.1 Extraccion Metricas de Output

Ejemplo en `.ci-local.yaml` job `test_ui`:
```yaml
metrics:
  - name: ui_tests_passed
    extract_from: stdout
    regex: 'Tests:.*?(\d+) passed'
```

**Implementacion en ci-local.sh**:
```bash
# Extract metric from stdout
extract_metric() {
    local metric_name="$1"
    local regex="$2"
    local stdout_file="$3"

    local value
    value=$(grep -oP "$regex" "$stdout_file" | head -1)

    echo "$metric_name=$value" >> "$ARTIFACTS_DIR/metrics.txt"
}
```

---

## 5. Algoritmos Clave

### 5.1 Algoritmo: Smart Detection (Deteccion Cambios)

```
FUNCTION files_changed(pattern):
    base_branch = get_config(".pipeline.smart_detection.base_branch")  # "main"

    # Get changed files vs base
    changed_files = git diff --name-only base_branch...HEAD

    IF changed_files is empty:
        RETURN false  # No changes

    # Check if any file matches pattern
    FOR each file IN changed_files:
        IF file matches regex pattern:
            RETURN true  # Files changed

    RETURN false  # No matching files
```

**Ejemplo**:
- Pattern: `ui/**/*.(js|jsx|ts|tsx)`
- Changed files: `ui/src/Dashboard.jsx`, `api/views.py`
- Result: `true` (Dashboard.jsx matches pattern)

### 5.2 Algoritmo: Parallel Execution

```
FUNCTION execute_stage_parallel(stage_name):
    jobs = get_jobs_for_stage(stage_name)

    pids = []

    # Launch jobs in background
    FOR each job IN jobs:
        execute_job(job) &      # Background
        pids.append(PID)

    # Wait for all jobs
    any_failed = false
    FOR each pid IN pids:
        IF wait(pid) != 0:
            any_failed = true

    IF any_failed:
        RETURN FAIL
    ELSE:
        RETURN PASS
```

---

## 6. Proximos Pasos

1. Completar implementacion hooks (pre_pipeline, post_pipeline)
2. Implementar extraccion metricas de outputs
3. Implementar generacion reportes HTML (opcional)
4. Testing (FASE 4)

---

**Status**: LLD CI LOCAL COMPLETO
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team
