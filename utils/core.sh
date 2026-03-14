#!/bin/bash
# IACT DevBox - Core Utilities
# Version: 0.1.0
# Description: Core functions for all provisioning scripts

set -euo pipefail

# =============================================================================
# FILE SYSTEM OPERATIONS
# =============================================================================

exists_dir() {
    [[ -d "$1" ]]
}

exists_file() {
    [[ -f "$1" ]]
}

is_executable() {
    [[ -x "$1" ]]
}

is_readable() {
    [[ -r "$1" ]]
}

is_writable() {
    [[ -w "$1" ]]
}

# =============================================================================
# DIRECTORY MANAGEMENT
# =============================================================================

ensure_dir() {
    local dir=$1
    [[ -d "$dir" ]] && return 0
    mkdir -p "$dir" || return 1
}

remove_dir() {
    local dir=$1
    [[ ! -d "$dir" ]] && return 0
    rm -rf "$dir" || return 1
}

# =============================================================================
# FILE MANAGEMENT
# =============================================================================

ensure_file() {
    local file=$1
    [[ -f "$file" ]] && return 0
    touch "$file" || return 1
}

remove_file() {
    local file=$1
    [[ ! -f "$file" ]] && return 0
    rm -f "$file" || return 1
}

backup_file() {
    local file=$1
    [[ ! -f "$file" ]] && return 1

    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup" || return 1
}

# =============================================================================
# PERMISSIONS
# =============================================================================

make_exec() {
    local file=$1
    [[ -x "$file" ]] && return 0
    chmod +x "$file" || return 1
}

make_readable() {
    local file=$1
    [[ -r "$file" ]] && return 0
    chmod +r "$file" || return 1
}

set_perms() {
    local file=$1
    local perms=$2
    chmod "$perms" "$file" || return 1
}

set_owner() {
    local file=$1
    local owner=$2
    chown "$owner" "$file" || return 1
}

# =============================================================================
# PATH OPERATIONS
# =============================================================================

get_abs_path() {
    local path=$1
    cd "$(dirname "$path")" && pwd -P
}

get_script_dir() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local dir
        dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}

# =============================================================================
# STRING OPERATIONS
# =============================================================================

trim() {
    local str=$1
    echo "$str" | xargs
}

lower() {
    local str=$1
    echo "$str" | tr '[:upper:]' '[:lower:]'
}

upper() {
    local str=$1
    echo "$str" | tr '[:lower:]' '[:upper:]'
}

contains() {
    local haystack=$1
    local needle=$2
    [[ "$haystack" == *"$needle"* ]]
}

starts_with() {
    local str=$1
    local prefix=$2
    [[ "$str" == "$prefix"* ]]
}

ends_with() {
    local str=$1
    local suffix=$2
    [[ "$str" == *"$suffix" ]]
}

# =============================================================================
# PROCESS OPERATIONS
# =============================================================================

is_running() {
    local process=$1
    pgrep -x "$process" &>/dev/null
}

wait_for_process() {
    local process=$1
    local timeout=${2:-30}
    local elapsed=0

    while ! is_running "$process"; do
        [[ $elapsed -ge $timeout ]] && return 1
        sleep 1
        ((elapsed++))
    done
    return 0
}

kill_process() {
    local process=$1
    local signal=${2:-TERM}
    pkill -"$signal" "$process" 2>/dev/null || true
}

# =============================================================================
# SERVICE OPERATIONS
# =============================================================================

is_service_active() {
    local service=$1
    systemctl is-active --quiet "$service"
}

is_service_enabled() {
    local service=$1
    systemctl is-enabled --quiet "$service"
}

start_service() {
    local service=$1
    systemctl start "$service" || return 1
}

stop_service() {
    local service=$1
    systemctl stop "$service" || return 1
}

restart_service() {
    local service=$1
    systemctl restart "$service" || return 1
}

enable_service() {
    local service=$1
    systemctl enable "$service" || return 1
}

# =============================================================================
# COMMAND AVAILABILITY
# =============================================================================

command_exists() {
    local cmd=$1
    command -v "$cmd" &>/dev/null
}

require_command() {
    local cmd=$1
    command_exists "$cmd" || {
        echo "[ERROR] Required command not found: ${cmd}"
        return 1
    }
}

# =============================================================================
# PACKAGE OPERATIONS
# =============================================================================

is_package_installed() {
    local package=$1
    dpkg -l "$package" 2>/dev/null | grep -q "^ii"
}

install_package() {
    local package=$1
    is_package_installed "$package" && return 0
    apt-get install -y "$package" || return 1
}

remove_package() {
    local package=$1
    is_package_installed "$package" || return 0
    apt-get remove -y "$package" || return 1
}

# =============================================================================
# SYSTEM INFO
# =============================================================================

get_os_version() {
    lsb_release -rs 2>/dev/null || cat /etc/os-release | grep VERSION_ID | cut -d'"' -f2
}

get_os_codename() {
    lsb_release -cs 2>/dev/null || cat /etc/os-release | grep VERSION_CODENAME | cut -d'=' -f2
}

get_cpu_count() {
    nproc
}

get_total_memory() {
    free -m | awk '/^Mem:/{print $2}'
}

# =============================================================================
# RETRY LOGIC
# =============================================================================

retry() {
    local max_attempts=$1
    shift
    local cmd=("$@")
    local attempt=1

    while [[ $attempt -le $max_attempts ]]; do
        if "${cmd[@]}"; then
            return 0
        fi

        echo "[WARN] Command failed (attempt ${attempt}/${max_attempts})"
        ((attempt++))
        [[ $attempt -le $max_attempts ]] && sleep 2
    done

    return 1
}

# =============================================================================
# EXPORTS
# =============================================================================

# Export all functions
export -f exists_dir exists_file is_executable is_readable is_writable
export -f ensure_dir remove_dir
export -f ensure_file remove_file backup_file
export -f make_exec make_readable set_perms set_owner
export -f get_abs_path get_script_dir
export -f trim lower upper contains starts_with ends_with
export -f is_running wait_for_process kill_process
export -f is_service_active is_service_enabled
export -f start_service stop_service restart_service enable_service
export -f command_exists require_command
export -f is_package_installed install_package remove_package
export -f get_os_version get_os_codename get_cpu_count get_total_memory
export -f retry