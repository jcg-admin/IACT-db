#!/bin/bash
# IACT DevBox - Validation Utilities
# Version: 0.1.0
# Description: Validation functions for environment, variables, and system

set -euo pipefail

# =============================================================================
# DEPENDENCIES
# =============================================================================

# Load required dependencies
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${UTILS_DIR}/logging.sh"
# shellcheck disable=SC1091
source "${UTILS_DIR}/network.sh"

# =============================================================================
# VARIABLE VALIDATION
# =============================================================================

is_set() {
    local var_name=$1
    [[ -n "${!var_name:-}" ]]
}

is_empty() {
    local var_name=$1
    [[ -z "${!var_name:-}" ]]
}

validate_var() {
    local var_name=$1
    local error_msg=${2:-"Variable not set: ${var_name}"}

    is_set "$var_name" || {
        log_error "$error_msg"
        return 1
    }
}

validate_not_empty() {
    local var_name=$1
    local error_msg=${2:-"Variable is empty: ${var_name}"}

    is_empty "$var_name" && {
        log_error "$error_msg"
        return 1
    }
}

# =============================================================================
# MULTIPLE VARIABLE VALIDATION
# =============================================================================

check_vars() {
    local errors=0

    for var in "$@"; do
        if ! is_set "$var"; then
            log_error "Missing variable: ${var}"
            ((errors++))
        fi
    done

    return $errors
}

require_vars() {
    check_vars "$@" || {
        log_fatal "Required variables not set"
        return 1
    }
}

# =============================================================================
# DIRECTORY VALIDATION
# =============================================================================

validate_dir_exists() {
    local dir=$1
    local error_msg=${2:-"Directory not found: ${dir}"}

    [[ -d "$dir" ]] || {
        log_error "$error_msg"
        return 1
    }
}

validate_dir_readable() {
    local dir=$1
    local error_msg=${2:-"Directory not readable: ${dir}"}

    [[ -r "$dir" ]] || {
        log_error "$error_msg"
        return 1
    }
}

validate_dir_writable() {
    local dir=$1
    local error_msg=${2:-"Directory not writable: ${dir}"}

    [[ -w "$dir" ]] || {
        log_error "$error_msg"
        return 1
    }
}

check_dirs() {
    local errors=0

    for dir in "$@"; do
        if [[ ! -d "$dir" ]]; then
            log_error "Missing directory: ${dir}"
            ((errors++))
        fi
    done

    return $errors
}

# =============================================================================
# FILE VALIDATION
# =============================================================================

validate_file_exists() {
    local file=$1
    local error_msg=${2:-"File not found: ${file}"}

    [[ -f "$file" ]] || {
        log_error "$error_msg"
        return 1
    }
}

validate_file_readable() {
    local file=$1
    local error_msg=${2:-"File not readable: ${file}"}

    [[ -r "$file" ]] || {
        log_error "$error_msg"
        return 1
    }
}

validate_file_executable() {
    local file=$1
    local error_msg=${2:-"File not executable: ${file}"}

    [[ -x "$file" ]] || {
        log_error "$error_msg"
        return 1
    }
}

check_files() {
    local errors=0

    for file in "$@"; do
        if [[ ! -f "$file" ]]; then
            log_error "Missing file: ${file}"
            ((errors++))
        fi
    done

    return $errors
}

# =============================================================================
# NUMERIC VALIDATION
# =============================================================================

is_integer() {
    local value=$1
    [[ "$value" =~ ^-?[0-9]+$ ]]
}

is_positive() {
    local value=$1
    is_integer "$value" && [[ $value -gt 0 ]]
}

is_in_range() {
    local value=$1
    local min=$2
    local max=$3

    is_integer "$value" && [[ $value -ge $min ]] && [[ $value -le $max ]]
}

validate_integer() {
    local value=$1
    local var_name=${2:-"value"}

    is_integer "$value" || {
        log_error "${var_name} must be an integer: ${value}"
        return 1
    }
}

validate_positive() {
    local value=$1
    local var_name=${2:-"value"}

    is_positive "$value" || {
        log_error "${var_name} must be positive: ${value}"
        return 1
    }
}

validate_range() {
    local value=$1
    local min=$2
    local max=$3
    local var_name=${4:-"value"}

    is_in_range "$value" "$min" "$max" || {
        log_error "${var_name} must be between ${min} and ${max}: ${value}"
        return 1
    }
}

# =============================================================================
# STRING VALIDATION
# =============================================================================

is_valid_ip() {
    local ip=$1
    [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
}

is_valid_port() {
    local port=$1
    is_integer "$port" && is_in_range "$port" 1 65535
}

is_valid_hostname() {
    local hostname=$1
    [[ "$hostname" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]
}

validate_ip() {
    local ip=$1
    local var_name=${2:-"IP address"}

    is_valid_ip "$ip" || {
        log_error "Invalid ${var_name}: ${ip}"
        return 1
    }
}

validate_port() {
    local port=$1
    local var_name=${2:-"port"}

    is_valid_port "$port" || {
        log_error "Invalid ${var_name}: ${port}"
        return 1
    }
}

validate_hostname() {
    local hostname=$1
    local var_name=${2:-"hostname"}

    is_valid_hostname "$hostname" || {
        log_error "Invalid ${var_name}: ${hostname}"
        return 1
    }
}

# =============================================================================
# COMMAND VALIDATION
# =============================================================================

validate_command() {
    local cmd=$1
    local error_msg=${2:-"Command not found: ${cmd}"}

    command -v "$cmd" &>/dev/null || {
        log_error "$error_msg"
        return 1
    }
}

check_commands() {
    local errors=0

    for cmd in "$@"; do
        if ! command -v "$cmd" &>/dev/null; then
            log_error "Missing command: ${cmd}"
            ((errors++))
        fi
    done

    return $errors
}

# =============================================================================
# USER VALIDATION
# =============================================================================

is_root() {
    [[ $EUID -eq 0 ]]
}

validate_root() {
    is_root || {
        log_error "This script must be run as root"
        return 1
    }
}

validate_not_root() {
    is_root && {
        log_error "This script must NOT be run as root"
        return 1
    }
}

# =============================================================================
# PORT VALIDATION
# =============================================================================
# Note: is_port_listening() is provided by network.sh

validate_port_free() {
    local port=$1

    is_port_listening "$port" && {
        log_error "Port already in use: ${port}"
        return 1
    }
}

validate_port_listening() {
    local port=$1

    is_port_listening "$port" || {
        log_error "Port not listening: ${port}"
        return 1
    }
}

# =============================================================================
# EXPORTS
# =============================================================================

export -f is_set is_empty validate_var validate_not_empty
export -f check_vars require_vars
export -f validate_dir_exists validate_dir_readable validate_dir_writable check_dirs
export -f validate_file_exists validate_file_readable validate_file_executable check_files
export -f is_integer is_positive is_in_range
export -f validate_integer validate_positive validate_range
export -f is_valid_ip is_valid_port is_valid_hostname
export -f validate_ip validate_port validate_hostname
export -f validate_command check_commands
export -f is_root validate_root validate_not_root
export -f validate_port_free validate_port_listening