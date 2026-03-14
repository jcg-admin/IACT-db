#!/bin/bash
# IACT DevBox - Provisioning Framework
# Version: 0.1.3
# Description: Orchestration framework for all provisioners (DRY principle)
# Changes: Removed vars.conf dependency - Vagrantfile is the ONLY source of truth

set -euo pipefail

# =============================================================================
# ENVIRONMENT INITIALIZATION
# =============================================================================

init_env() {
    # Detect PROJECT_ROOT (works from any location)
    if [[ -n "${PROJECT_ROOT:-}" ]]; then
        return 0
    fi

    # Try to detect from Vagrant
    if [[ -d "/vagrant" ]]; then
        export PROJECT_ROOT="/vagrant"
        return 0
    fi

    # Fallback: find git root
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
    if [[ -n "$git_root" ]]; then
        export PROJECT_ROOT="$git_root"
        return 0
    fi

    # Last resort: current directory
    export PROJECT_ROOT="$(pwd)"
}

# load_config() REMOVED - vars.conf is deprecated
# All configuration variables now come from Vagrantfile exports
# This function has been removed in v0.1.3

load_utils() {
    init_env

    local utils_dir="${PROJECT_ROOT}/utils"

    if [[ ! -d "$utils_dir" ]]; then
        echo "[ERROR] Utils directory not found: ${utils_dir}"
        return 1
    fi

    # Source all utility modules in CORRECT dependency order
    # shellcheck disable=SC1090
    source "${utils_dir}/core.sh"
    # shellcheck disable=SC1090
    source "${utils_dir}/logging.sh"
    # shellcheck disable=SC1090
    source "${utils_dir}/network.sh"      # BEFORE validation (validation depends on network)
    # shellcheck disable=SC1090
    source "${utils_dir}/database.sh"
    # shellcheck disable=SC1090
    source "${utils_dir}/validation.sh"   # AFTER network (uses is_port_listening)

    export UTILS_LOADED=true
}

init_all() {
    init_env
    load_utils
}

# =============================================================================
# VALIDATION HELPERS (wrappers for convenience)
# =============================================================================

# Simple wrapper for validate_var (for backward compatibility)
validate() {
    validate_var "$@"
}

# NOTE: check_required_vars() and check_required_dirs() have been removed
# Use check_vars() and check_dirs() from utils/validation.sh instead
# Or use require_vars() and require_dirs() for fatal errors

# =============================================================================
# STEP EXECUTION (for multi-step provisioning)
# =============================================================================

run_step() {
    local step_name=$1
    local step_func=$2

    log_info "Running step: ${step_name}"

    if "$step_func"; then
        log_success "Step completed: ${step_name}"
        return 0
    else
        log_error "Step failed: ${step_name}"
        return 1
    fi
}

run_all() {
    local -a steps=("$@")
    local failed=0
    local total=${#steps[@]}
    local current=0

    for step in "${steps[@]}"; do
        ((current++))
        log_step "$current" "$total" "Executing: ${step}"

        if ! "$step"; then
            log_error "Failed: ${step}"
            ((failed++))
        fi
    done

    if [[ $failed -eq 0 ]]; then
        log_success "All steps completed successfully"
        return 0
    else
        log_error "Failed steps: ${failed}/${total}"
        return 1
    fi
}

# =============================================================================
# STANDARD PROVISIONING STEPS
# =============================================================================

step_header() {
    local vm_name=$1
    local vm_description=${2:-""}

    log_header "PROVISIONING: ${vm_name}"

    if [[ -n "$vm_description" ]]; then
        echo "$vm_description"
        echo ""
    fi

    echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo ""

    log_separator
}

step_system() {
    local system_script="${PROJECT_ROOT}/utils/system.sh"

    if [[ ! -f "$system_script" ]]; then
        log_error "System script not found: ${system_script}"
        return 1
    fi

    log_info "Running system preparation"

    bash "$system_script" || {
        log_error "System preparation failed"
        return 1
    }

    log_success "System preparation completed"
}

step_install() {
    local install_script=${1:-}

    if [[ -z "$install_script" ]]; then
        log_error "Install script path required"
        log_error "Usage: step_install <script_path>"
        return 1
    fi

    if [[ ! -f "$install_script" ]]; then
        log_error "Install script not found: ${install_script}"
        return 1
    fi

    log_info "Running installation: ${install_script}"

    bash "$install_script" || {
        log_error "Installation failed: ${install_script}"
        return 1
    }

    log_success "Installation completed"
}

step_setup() {
    local setup_script=${1:-}

    if [[ -z "$setup_script" ]]; then
        log_error "Setup script path required"
        log_error "Usage: step_setup <script_path>"
        return 1
    fi

    if [[ ! -f "$setup_script" ]]; then
        log_error "Setup script not found: ${setup_script}"
        return 1
    fi

    log_info "Running setup: ${setup_script}"

    bash "$setup_script" || {
        log_error "Setup failed: ${setup_script}"
        return 1
    }

    log_success "Setup completed"
}

# =============================================================================
# RESULTS DISPLAY
# =============================================================================

show_results() {
    local vm_name=$1
    shift
    local -a info=("$@")

    log_header "PROVISIONING COMPLETE: ${vm_name}"

    for line in "${info[@]}"; do
        echo "$line"
    done

    echo ""
    log_separator
}

show_connection_info() {
    local service=$1
    local host=$2
    local port=$3
    local database=${4:-}
    local username=${5:-}

    log_header "CONNECTION INFORMATION"

    echo "Service:  ${service}"
    echo "Host:     ${host}"
    echo "Port:     ${port}"

    if [[ -n "$database" ]]; then
        echo "Database: ${database}"
    fi

    if [[ -n "$username" ]]; then
        echo "Username: ${username}"
    fi

    echo ""
    log_separator
}

# =============================================================================
# ERROR HANDLING
# =============================================================================

handle_error() {
    local exit_code=$1
    local message=${2:-"An error occurred"}

    log_error "$message"
    log_error "Exit code: ${exit_code}"

    return "$exit_code"
}

ensure_success() {
    local cmd=("$@")

    if ! "${cmd[@]}"; then
        local exit_code=$?
        handle_error "$exit_code" "Command failed: ${cmd[*]}"
        return "$exit_code"
    fi
}

# =============================================================================
# IDEMPOTENCY HELPERS
# =============================================================================

# NOTE: These functions are designed for future use (v0.2.0+)
# They provide idempotency tracking using marker files in /var/lib/iact-devbox/
# Currently not used in install.sh scripts but available for implementation

needs_install() {
    local service=$1
    local required_version=${2:-}

    # Check if service exists
    if ! command_exists "$service"; then
        return 0  # Needs install
    fi

    # If no version check required, already installed
    if [[ -z "$required_version" ]]; then
        return 1  # Already installed
    fi

    # Check version (implementation depends on service)
    return 1  # Already installed (simplified)
}

mark_installed() {
    local service=$1
    local version=$2
    local marker_file="/var/lib/iact-devbox/${service}.installed"

    ensure_dir "$(dirname "$marker_file")"
    echo "$version" > "$marker_file"
}

is_installed() {
    local service=$1
    local marker_file="/var/lib/iact-devbox/${service}.installed"

    [[ -f "$marker_file" ]]
}

get_installed_version() {
    local service=$1
    local marker_file="/var/lib/iact-devbox/${service}.installed"

    if [[ -f "$marker_file" ]]; then
        cat "$marker_file"
    fi
}

# =============================================================================
# EXPORTS
# =============================================================================

export -f init_env load_utils init_all
export -f validate
export -f run_step run_all
export -f step_header step_system step_install step_setup
export -f show_results show_connection_info
export -f handle_error ensure_success
export -f needs_install mark_installed is_installed get_installed_version