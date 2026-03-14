#!/bin/bash
# IACT DevBox - System Preparation
# Version: 0.1.0
# Description: Common system preparation for all VMs

set -euo pipefail

# =============================================================================
# INITIALIZATION
# =============================================================================

# Detect script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Load provisioning framework
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/provisioning.sh"

# Initialize environment
init_all

# =============================================================================
# SYSTEM UPDATE
# =============================================================================

update_system() {
    log_info "Updating package lists"

    export DEBIAN_FRONTEND=noninteractive

    # Configure APT to be more resilient to network issues
    # Increase timeout from default 120s to 300s (5 minutes)
    # Retry failed downloads 3 times
    local apt_config=(
        -o Acquire::http::Timeout=300
        -o Acquire::https::Timeout=300
        -o Acquire::ftp::Timeout=300
        -o Acquire::Retries=3
    )

    # Try update with retries
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if [ $attempt -gt 1 ]; then
            log_warn "Retry attempt $attempt of $max_attempts"
            sleep 5  # Brief pause before retry
        fi

        if apt-get update "${apt_config[@]}" -qq; then
            log_success "Package lists updated"
            return 0
        fi

        ((attempt++))
    done

    log_error "Failed to update package lists after $max_attempts attempts"
    return 1
}

# NOTE: This function is available but not executed by default in main()
# to keep provisioning fast. Call manually if full system upgrade is needed.
upgrade_system() {
    log_info "Upgrading system packages"

    export DEBIAN_FRONTEND=noninteractive

    apt-get upgrade -y -qq || {
        log_error "Failed to upgrade packages"
        return 1
    }

    log_success "System packages upgraded"
}

# =============================================================================
# ESSENTIAL PACKAGES
# =============================================================================

install_essentials() {
    log_info "Installing essential packages"

    local packages=(
        curl
        wget
        git
        vim
        nano
        htop
        net-tools
        dnsutils
        iputils-ping
        ca-certificates
        gnupg
        lsb-release
        software-properties-common
        apt-transport-https
    )

    export DEBIAN_FRONTEND=noninteractive

    for package in "${packages[@]}"; do
        if ! is_package_installed "$package"; then
            log_info "Installing: ${package}"
            apt-get install -y -qq "$package" || {
                log_warn "Failed to install: ${package}"
            }
        fi
    done

    log_success "Essential packages installed"
}

# =============================================================================
# TIMEZONE CONFIGURATION
# =============================================================================

configure_timezone() {
    local timezone=${1:-UTC}

    log_info "Configuring timezone: ${timezone}"

    if [[ -f /etc/timezone ]] && [[ "$(cat /etc/timezone)" == "$timezone" ]]; then
        log_info "Timezone already set to: ${timezone}"
        return 0
    fi

    timedatectl set-timezone "$timezone" 2>/dev/null || {
        echo "$timezone" > /etc/timezone
        ln -sf "/usr/share/zoneinfo/${timezone}" /etc/localtime
    }

    log_success "Timezone configured: ${timezone}"
}

# =============================================================================
# LOCALE CONFIGURATION
# =============================================================================

configure_locale() {
    local locale=${1:-en_US.UTF-8}

    log_info "Configuring locale: ${locale}"

    # Install locales package if not present
    if ! is_package_installed "locales"; then
        apt-get install -y -qq locales
    fi

    # Generate locale
    locale-gen "$locale" 2>/dev/null || true

    # Set as default
    update-locale LANG="$locale" 2>/dev/null || {
        echo "LANG=${locale}" > /etc/default/locale
    }

    log_success "Locale configured: ${locale}"
}

# =============================================================================
# CLEANUP
# =============================================================================

cleanup_system() {
    log_info "Cleaning up system"

    apt-get autoremove -y -qq 2>/dev/null || true
    apt-get autoclean -y -qq 2>/dev/null || true
    apt-get clean -y -qq 2>/dev/null || true

    log_success "System cleaned up"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    log_header "SYSTEM PREPARATION"

    start_timer

    # Validate root
    validate_root || {
        log_fatal "This script must be run as root"
        return 1
    }

    # Execute steps
    local steps=(
        update_system
        install_essentials
        configure_timezone
        configure_locale
        cleanup_system
    )

    run_all "${steps[@]}" || {
        log_error "System preparation failed"
        return 1
    }

    local elapsed
    elapsed=$(show_elapsed)

    log_success "System preparation completed in ${elapsed}"

    return 0
}

# Execute main if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi