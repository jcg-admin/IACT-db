#!/bin/bash
# swap.sh
# Swap configuration script
# Version: 1.0.0

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/validation.sh

# Main function
main() {
    log_header "Swap Configuration"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars SWAP_SIZE

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Check if swap already exists
    if check_swap_exists; then
        log_warn "Swap already configured, skipping"
        return 0
    fi

    # Create swap file
    if ! create_swap_file; then
        log_error "Failed to create swap file"
        return 1
    fi

    # Configure swap
    if ! configure_swap; then
        log_error "Failed to configure swap"
        return 1
    fi

    # Enable swap
    if ! enable_swap; then
        log_error "Failed to enable swap"
        return 1
    fi

    # Make swap permanent
    if ! make_swap_permanent; then
        log_error "Failed to make swap permanent"
        return 1
    fi

    # Optimize swap usage
    if ! optimize_swap; then
        log_error "Failed to optimize swap settings"
        return 1
    fi

    log_success "Swap configuration completed"
    return 0
}

# Check if swap already exists
check_swap_exists() {
    log_info "Checking if swap is already configured"

    if swapon --show | grep -q "/swapfile"; then
        log_info "Swap file already exists and is active"
        return 0
    fi

    if [[ -f /swapfile ]]; then
        log_warn "Swap file exists but is not active"
        return 0
    fi

    log_info "No swap configured"
    return 1
}

# Create swap file
create_swap_file() {
    log_info "Creating swap file of size ${SWAP_SIZE}"

    local swap_file="/swapfile"

    # Create swap file using fallocate
    if ! fallocate -l "$SWAP_SIZE" "$swap_file" 2>/dev/null; then
        log_warn "fallocate failed, trying dd"

        # Fallback to dd if fallocate fails
        local size_mb
        case "$SWAP_SIZE" in
            *G)
                size_mb=$((${SWAP_SIZE%G} * 1024))
                ;;
            *M)
                size_mb=${SWAP_SIZE%M}
                ;;
            *)
                log_error "Invalid SWAP_SIZE format: $SWAP_SIZE"
                return 1
                ;;
        esac

        if ! dd if=/dev/zero of="$swap_file" bs=1M count="$size_mb" status=none 2>/dev/null; then
            log_error "Failed to create swap file with dd"
            return 1
        fi
    fi

    # Verify file was created
    if ! validate_file_exists "$swap_file"; then
        log_error "Swap file was not created"
        return 1
    fi

    log_success "Swap file created: $swap_file"
    return 0
}

# Configure swap file permissions and format
configure_swap() {
    log_info "Configuring swap file"

    local swap_file="/swapfile"

    # Set correct permissions (only root can read/write)
    log_info "Setting permissions on swap file"
    if ! chmod 600 "$swap_file"; then
        log_error "Failed to set permissions on swap file"
        return 1
    fi

    # Format as swap
    log_info "Formatting swap file"
    if ! mkswap "$swap_file" >/dev/null 2>&1; then
        log_error "Failed to format swap file"
        return 1
    fi

    log_success "Swap file configured"
    return 0
}

# Enable swap
enable_swap() {
    log_info "Enabling swap"

    local swap_file="/swapfile"

    # Enable swap
    if ! swapon "$swap_file" 2>/dev/null; then
        log_error "Failed to enable swap"
        return 1
    fi

    # Verify swap is active
    if ! swapon --show | grep -q "$swap_file"; then
        log_error "Swap is not active after enabling"
        return 1
    fi

    # Show swap status
    local swap_info=$(swapon --show | grep "$swap_file")
    log_success "Swap enabled: $swap_info"

    return 0
}

# Make swap permanent across reboots
make_swap_permanent() {
    log_info "Making swap permanent"

    local fstab="/etc/fstab"
    local swap_entry="/swapfile none swap sw 0 0"

    # Backup fstab
    if ! backup_file "$fstab"; then
        log_warn "Failed to backup fstab, continuing anyway"
    fi

    # Check if entry already exists
    if grep -q "^/swapfile" "$fstab"; then
        log_warn "Swap entry already exists in fstab"
        return 0
    fi

    # Add swap entry to fstab
    log_info "Adding swap entry to fstab"
    if ! echo "$swap_entry" >> "$fstab"; then
        log_error "Failed to add swap entry to fstab"
        return 1
    fi

    log_success "Swap made permanent"
    return 0
}

# Optimize swap settings
optimize_swap() {
    log_info "Optimizing swap settings"

    # Set swappiness (how aggressively to use swap)
    # 10 means only use swap when necessary
    log_info "Setting swappiness to 10"
    if ! sysctl vm.swappiness=10 >/dev/null 2>&1; then
        log_warn "Failed to set swappiness"
    else
        log_success "Swappiness set to 10"
    fi

    # Make swappiness setting permanent
    local sysctl_conf="/etc/sysctl.conf"

    if ! grep -q "^vm.swappiness" "$sysctl_conf"; then
        log_info "Adding swappiness to sysctl.conf"
        echo "vm.swappiness=10" >> "$sysctl_conf"
    fi

    # Set vfs_cache_pressure
    # Higher value means kernel will prefer to reclaim dentries and inodes
    log_info "Setting vfs_cache_pressure to 50"
    if ! sysctl vm.vfs_cache_pressure=50 >/dev/null 2>&1; then
        log_warn "Failed to set vfs_cache_pressure"
    else
        log_success "vfs_cache_pressure set to 50"
    fi

    # Make vfs_cache_pressure setting permanent
    if ! grep -q "^vm.vfs_cache_pressure" "$sysctl_conf"; then
        log_info "Adding vfs_cache_pressure to sysctl.conf"
        echo "vm.vfs_cache_pressure=50" >> "$sysctl_conf"
    fi

    log_success "Swap settings optimized"
    return 0
}

# Note: main() is called by bootstrap.sh, not auto-executed