#!/bin/bash
# IACT DevBox - Network Utilities
# Version: 0.1.0
# Description: Network operations and connectivity tests

set -euo pipefail

# =============================================================================
# DEPENDENCIES
# =============================================================================

# Load required dependencies
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${UTILS_DIR}/logging.sh"

# =============================================================================
# CONNECTIVITY TESTS
# =============================================================================

is_online() {
    ping -c 1 -W 2 8.8.8.8 &>/dev/null
}

can_reach_host() {
    local host=$1
    local timeout=${2:-5}

    ping -c 1 -W "$timeout" "$host" &>/dev/null
}

can_reach_port() {
    local host=$1
    local port=$2
    local timeout=${3:-5}

    timeout "$timeout" bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" 2>/dev/null
}

wait_for_host() {
    local host=$1
    local timeout=${2:-30}
    local elapsed=0

    log_info "Waiting for host ${host} to be reachable..."

    while ! can_reach_host "$host" 2; do
        [[ $elapsed -ge $timeout ]] && {
            log_error "Host not reachable after ${timeout}s: ${host}"
            return 1
        }
        sleep 1
        ((elapsed++))
    done

    log_success "Host is reachable: ${host}"
}

wait_for_port() {
    local host=$1
    local port=$2
    local timeout=${3:-30}
    local elapsed=0

    log_info "Waiting for ${host}:${port} to be available..."

    while ! can_reach_port "$host" "$port" 2; do
        [[ $elapsed -ge $timeout ]] && {
            log_error "Port not available after ${timeout}s: ${host}:${port}"
            return 1
        }
        sleep 1
        ((elapsed++))
    done

    log_success "Port is available: ${host}:${port}"
}

# =============================================================================
# HTTP/HTTPS TESTS
# =============================================================================

http_get() {
    local url=$1
    local timeout=${2:-10}

    curl -sf --max-time "$timeout" "$url"
}

http_status() {
    local url=$1
    local timeout=${2:-10}

    curl -sf --max-time "$timeout" -o /dev/null -w "%{http_code}" "$url"
}

is_url_accessible() {
    local url=$1
    local expected_status=${2:-200}

    local status
    status=$(http_status "$url" 2>/dev/null)

    [[ "$status" == "$expected_status" ]]
}

wait_for_url() {
    local url=$1
    local timeout=${2:-30}
    local expected_status=${3:-200}
    local elapsed=0

    log_info "Waiting for URL to be accessible: ${url}"

    while ! is_url_accessible "$url" "$expected_status"; do
        [[ $elapsed -ge $timeout ]] && {
            log_error "URL not accessible after ${timeout}s: ${url}"
            return 1
        }
        sleep 1
        ((elapsed++))
    done

    log_success "URL is accessible: ${url}"
}

# =============================================================================
# DNS OPERATIONS
# =============================================================================

resolve_hostname() {
    local hostname=$1

    getent hosts "$hostname" | awk '{print $1}' | head -1
}

has_dns_record() {
    local hostname=$1

    resolve_hostname "$hostname" &>/dev/null
}

# =============================================================================
# PORT OPERATIONS
# =============================================================================

get_listening_ports() {
    netstat -tlnp 2>/dev/null | awk '/LISTEN/ {print $4}' | sed 's/.*://' | sort -n | uniq
}

is_port_listening() {
    local port=$1
    netstat -tlnp 2>/dev/null | grep -q ":${port} .*LISTEN"
}

find_process_on_port() {
    local port=$1

    netstat -tlnp 2>/dev/null | grep ":${port} " | awk '{print $7}' | cut -d'/' -f1
}

kill_process_on_port() {
    local port=$1

    local pid
    pid=$(find_process_on_port "$port")

    if [[ -n "$pid" ]]; then
        log_info "Killing process ${pid} on port ${port}"
        kill "$pid" 2>/dev/null || return 1
        return 0
    else
        log_warn "No process found on port ${port}"
        return 1
    fi
}

# =============================================================================
# NETWORK INTERFACE OPERATIONS
# =============================================================================

get_default_interface() {
    ip route | grep default | awk '{print $5}' | head -1
}

get_interface_ip() {
    local interface=$1

    ip addr show "$interface" 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1 | head -1
}

get_default_ip() {
    local interface
    interface=$(get_default_interface)

    [[ -n "$interface" ]] && get_interface_ip "$interface"
}

# =============================================================================
# FIREWALL OPERATIONS (ufw)
# =============================================================================

is_firewall_active() {
    ufw status 2>/dev/null | grep -q "Status: active"
}

firewall_allow_port() {
    local port=$1
    local protocol=${2:-tcp}

    log_info "Allowing port ${port}/${protocol} in firewall"
    ufw allow "${port}/${protocol}" &>/dev/null || true
    log_success "Port allowed: ${port}/${protocol}"
}

firewall_deny_port() {
    local port=$1
    local protocol=${2:-tcp}

    log_info "Denying port ${port}/${protocol} in firewall"
    ufw deny "${port}/${protocol}" &>/dev/null || true
    log_success "Port denied: ${port}/${protocol}"
}

firewall_allow_from() {
    local ip=$1

    log_info "Allowing connections from ${ip}"
    ufw allow from "$ip" &>/dev/null || true
    log_success "Connections allowed from: ${ip}"
}

# =============================================================================
# DOWNLOAD OPERATIONS
# =============================================================================

download_file() {
    local url=$1
    local output=$2
    local timeout=${3:-300}

    log_info "Downloading: ${url}"

    if curl -sfL --max-time "$timeout" -o "$output" "$url"; then
        log_success "Downloaded: ${output}"
        return 0
    else
        log_error "Download failed: ${url}"
        return 1
    fi
}

download_with_retry() {
    local url=$1
    local output=$2
    local max_attempts=${3:-3}

    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        log_info "Download attempt ${attempt}/${max_attempts}"

        if download_file "$url" "$output"; then
            return 0
        fi

        ((attempt++))
        [[ $attempt -le $max_attempts ]] && sleep 5
    done

    log_error "Download failed after ${max_attempts} attempts"
    return 1
}

# =============================================================================
# NETWORK INFO
# =============================================================================

show_network_info() {
    log_header "NETWORK INFORMATION"

    echo "Default Interface: $(get_default_interface)"
    echo "Default IP: $(get_default_ip)"
    echo ""

    echo "Listening Ports:"
    get_listening_ports | while read -r port; do
        echo "  - ${port}"
    done
    echo ""

    if is_firewall_active; then
        echo "Firewall: ACTIVE"
    else
        echo "Firewall: INACTIVE"
    fi

    log_separator
}

# =============================================================================
# EXPORTS
# =============================================================================

export -f is_online can_reach_host can_reach_port
export -f wait_for_host wait_for_port
export -f http_get http_status is_url_accessible wait_for_url
export -f resolve_hostname has_dns_record
export -f get_listening_ports is_port_listening
export -f find_process_on_port kill_process_on_port
export -f get_default_interface get_interface_ip get_default_ip
export -f is_firewall_active firewall_allow_port firewall_deny_port firewall_allow_from
export -f download_file download_with_retry
export -f show_network_info