#!/bin/bash
# IACT DevBox - Logging Utilities
# Version: 0.1.0
# Description: Professional logging system without emojis

set -euo pipefail

# =============================================================================
# LOG LEVELS
# =============================================================================

LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_SUCCESS=2
LOG_LEVEL_WARN=3
LOG_LEVEL_ERROR=4
LOG_LEVEL_FATAL=5

# Current log level (can be overridden)
CURRENT_LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# =============================================================================
# COLORS (optional, respects NO_COLOR)
# =============================================================================

if [[ -n "${NO_COLOR:-}" ]] || [[ "${TERM:-}" == "dumb" ]]; then
    COLOR_RESET=""
    COLOR_DEBUG=""
    COLOR_INFO=""
    COLOR_SUCCESS=""
    COLOR_WARN=""
    COLOR_ERROR=""
    COLOR_FATAL=""
else
    COLOR_RESET="\033[0m"
    COLOR_DEBUG="\033[0;36m"    # Cyan
    COLOR_INFO="\033[0;34m"     # Blue
    COLOR_SUCCESS="\033[0;32m"  # Green
    COLOR_WARN="\033[0;33m"     # Yellow
    COLOR_ERROR="\033[0;31m"    # Red
    COLOR_FATAL="\033[1;31m"    # Bold Red
fi

# =============================================================================
# LOG FILE
# =============================================================================

LOG_FILE="${LOG_FILE:-}"
LOG_TO_FILE=${LOG_TO_FILE:-false}

set_log_file() {
    local file=$1
    LOG_FILE="$file"
    LOG_TO_FILE=true

    # Ensure directory exists
    local dir
    dir="$(dirname "$file")"
    mkdir -p "$dir"
}

init_log() {
    local script_name=$1
    local log_dir="${2:-/vagrant/logs}"

    # Set log file
    set_log_file "${log_dir}/${script_name}.log"

    # Write header (directly to file, no timestamp prefix)
    {
        echo "=================================================================="
        echo "Log iniciado: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Script: ${script_name}"
        echo "Host: $(hostname)"
        echo "User: $(whoami)"
        echo "=================================================================="
        echo ""
    } >> "$LOG_FILE"
}

# =============================================================================
# CORE LOGGING FUNCTIONS
# =============================================================================

log_message() {
    local level=$1
    local prefix=$2
    local color=$3
    local message=$4

    # Check log level
    [[ $level -lt $CURRENT_LOG_LEVEL ]] && return 0

    # Format timestamp
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Format message
    local formatted
    formatted="${timestamp} [${prefix}] ${message}"

    # Console output (with color)
    if [[ -n "$color" ]]; then
        echo -e "${color}${formatted}${COLOR_RESET}"
    else
        echo "$formatted"
    fi

    # File output (no color)
    if [[ "$LOG_TO_FILE" == "true" ]] && [[ -n "$LOG_FILE" ]]; then
        echo "$formatted" >> "$LOG_FILE"
    fi
}

# =============================================================================
# PUBLIC LOG FUNCTIONS (without emojis - professional)
# =============================================================================

log_debug() {
    log_message "$LOG_LEVEL_DEBUG" "DEBUG  " "$COLOR_DEBUG" "$1"
}

log_info() {
    log_message "$LOG_LEVEL_INFO" "INFO   " "$COLOR_INFO" "$1"
}

log_success() {
    log_message "$LOG_LEVEL_SUCCESS" "SUCCESS" "$COLOR_SUCCESS" "$1"
}

log_warn() {
    log_message "$LOG_LEVEL_WARN" "WARN   " "$COLOR_WARN" "$1"
}

log_error() {
    log_message "$LOG_LEVEL_ERROR" "ERROR  " "$COLOR_ERROR" "$1"
}

log_fatal() {
    log_message "$LOG_LEVEL_FATAL" "FATAL  " "$COLOR_FATAL" "$1"
}

# =============================================================================
# STEP LOGGING (for multi-step processes)
# =============================================================================

log_step() {
    local current=$1
    local total=$2
    local message=$3

    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    local formatted
    formatted="${timestamp} [STEP ${current}/${total}] ${message}"

    if [[ -n "$COLOR_INFO" ]]; then
        echo -e "${COLOR_INFO}${formatted}${COLOR_RESET}"
    else
        echo "$formatted"
    fi

    if [[ "$LOG_TO_FILE" == "true" ]] && [[ -n "$LOG_FILE" ]]; then
        echo "$formatted" >> "$LOG_FILE"
    fi
}

# =============================================================================
# HEADER LOGGING (for section titles)
# =============================================================================

log_header() {
    local message=$1
    local width=${2:-60}

    local line
    line=$(printf '=%.0s' $(seq 1 "$width"))

    echo ""
    echo "$line"
    echo "$message"
    echo "$line"
    echo ""

    if [[ "$LOG_TO_FILE" == "true" ]] && [[ -n "$LOG_FILE" ]]; then
        {
            echo ""
            echo "$line"
            echo "$message"
            echo "$line"
            echo ""
        } >> "$LOG_FILE"
    fi
}

# =============================================================================
# SEPARATOR
# =============================================================================

log_separator() {
    local width=${1:-60}
    local char=${2:--}

    local line
    # Use printf with -- to prevent char being interpreted as option
    line=$(printf -- "${char}%.0s" $(seq 1 "$width"))

    echo "$line"

    if [[ "$LOG_TO_FILE" == "true" ]] && [[ -n "$LOG_FILE" ]]; then
        echo "$line" >> "$LOG_FILE"
    fi
}

# =============================================================================
# COMMAND LOGGING (log command and output)
# =============================================================================

log_command() {
    local cmd=("$@")

    log_debug "Executing: ${cmd[*]}"

    local output
    local exit_code

    if output=$("${cmd[@]}" 2>&1); then
        exit_code=0
        log_debug "Command succeeded"
    else
        exit_code=$?
        log_error "Command failed with exit code: ${exit_code}"
        log_error "Output: ${output}"
    fi

    return $exit_code
}

# =============================================================================
# PROGRESS INDICATOR
# =============================================================================

show_progress() {
    local current=$1
    local total=$2
    local width=${3:-50}

    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    local bar
    # Use ASCII-safe characters for maximum compatibility
    bar=$(printf "#%.0s" $(seq 1 "$filled"))
    bar+=$(printf -- "-%.0s" $(seq 1 "$empty"))

    printf "\r[%s] %3d%%" "$bar" "$percent"

    [[ $current -eq $total ]] && echo ""
}

# =============================================================================
# ELAPSED TIME
# =============================================================================

declare -g START_TIME

start_timer() {
    START_TIME=$(date +%s)
}

show_elapsed() {
    local end_time
    end_time=$(date +%s)

    local elapsed=$((end_time - START_TIME))
    local minutes=$((elapsed / 60))
    local seconds=$((elapsed % 60))

    if [[ $minutes -gt 0 ]]; then
        echo "${minutes}m ${seconds}s"
    else
        echo "${seconds}s"
    fi
}

# =============================================================================
# EXPORTS
# =============================================================================

export -f log_message
export -f log_debug log_info log_success log_warn log_error log_fatal
export -f log_step log_header log_separator
export -f log_command
export -f show_progress
export -f start_timer show_elapsed
export -f set_log_file