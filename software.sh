#!/usr/bin/env bash
#
# software.sh
# Package installation and system hardening for AWS EC2 instances.
# Part of aws-ec2-fresh-install bootstrap suite.
#
# Usage:
#   chmod +x software.sh
#   ./software.sh
#
# Logging:
#   All output is timestamped and goes to both stdout and a log file.
#

set -euo pipefail

# =============================================================================
# CONFIGURATION
# =============================================================================

LOG_FILE="/var/log/fresh_install_$(date +%Y%m%d_%H%M%S).log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# LOGGING
# =============================================================================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@"; }

# =============================================================================
# INITIALIZATION
# =============================================================================

log_info "Starting fresh install script"
log_info "Log file: $LOG_FILE"
log_info "Script directory: $SCRIPT_DIR"
log_info "Running as user: $(whoami)"
log_info "Hostname: $(hostname)"

# Ensure we can sudo without password (should be pre-configured on AMI)
if ! sudo -n true 2>/dev/null; then
    log_error "sudo requires a password — aborting"
    exit 1
fi
log_info "sudo access confirmed (passwordless)"

# =============================================================================
# BASE UTILITIES
# =============================================================================
# Essential command-line tools for day-to-day server management.

log_info "Installing base utilities..."

PACKAGES_BASE=(
    curl wget git rsync unzip zip p7zip-full
    tree jq build-essential
    python3 python3-pip
)

for pkg in "${PACKAGES_BASE[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log_info "$pkg already installed"
    else
        log_info "Installing $pkg..."
        sudo apt-get install -y "$pkg"
    fi
done

# =============================================================================
# HELIX EDITOR
# =============================================================================
# https://helix-editor.com/
# Modal editor, fast and modern.

log_info "Installing Helix editor..."

if command -v hx >/dev/null 2>&1; then
    log_info "Helix already installed: $(hx --version)"
else
    log_info "Downloading latest Helix release..."
    curl -s https://api.github.com/repos/helix-editor/helix/releases/latest \
        | grep "browser_download_url.*x86_64-linux.tar.xz" \
        | cut -d '"' -f 4 \
        | xargs curl -LO

    log_info "Extracting Helix..."
    tar -xf helix-*-x86_64-linux.tar.xz

    log_info "Installing Helix to /opt/helix..."
    sudo rm -rf /opt/helix
    sudo mv helix-*-x86_64-linux /opt/helix

    log_info "Creating symlink /usr/local/bin/hx..."
    sudo ln -sf /opt/helix/hx /usr/local/bin/hx

    log_info "Helix installed: $(hx --version)"
fi

# =============================================================================
# MICRO EDITOR
# =============================================================================
# https://micro-editor.github.io/
# Simple, intuitive terminal editor.

log_info "Installing micro editor..."

if command -v micro >/dev/null 2>&1; then
    log_info "micro already installed: $(micro --version)"
else
    log_info "Downloading and installing micro..."
    curl https://getmic.ro | bash

    log_info "Moving micro to /opt/micro..."
    sudo rm -rf /opt/micro
    sudo mv micro /opt/micro/

    log_info "Creating symlink /usr/local/bin/micro..."
    sudo ln -sf /opt/micro/micro /usr/local/bin/micro

    log_info "micro installed: $(micro --version)"
fi

# =============================================================================
# SECURITY & HARDENING
# =============================================================================
# Firewall (UFW), intrusion prevention (fail2ban), and automatic security updates.

log_info "Installing security packages..."

PACKAGES_SECURITY=(
    ufw fail2ban unattended-upgrades apt-listchanges
)

for pkg in "${PACKAGES_SECURITY[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log_info "$pkg already installed"
    else
        log_info "Installing $pkg..."
        sudo apt-get install -y "$pkg"
    fi
done

log_info "Configuring UFW (firewall)..."

if sudo ufw status | grep -q "Status: active"; then
    log_info "UFW already active"
else
    log_info "Setting UFW defaults (deny incoming, allow outgoing)..."
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    log_info "Enabling UFW..."
    sudo ufw --force enable
    log_info "UFW enabled and configured"
fi

log_info "Configuring fail2ban..."

if systemctl is-active --quiet fail2ban; then
    log_info "fail2ban already running"
else
    log_info "Enabling and starting fail2ban..."
    sudo systemctl enable --now fail2ban
    log_info "fail2ban enabled and started"
fi

log_info "Configuring unattended-upgrades..."

if systemctl is-active --quiet unattended-upgrades; then
    log_info "unattended-upgrades already running"
else
    log_info "Enabling and starting unattended-upgrades..."
    sudo systemctl enable --now unattended-upgrades
    log_info "unattended-upgrades enabled and started"
fi

# =============================================================================
# SYSTEM MONITORING & DIAGNOSTICS
# =============================================================================
# Resource monitoring and disk usage tools.

log_info "Installing monitoring and diagnostic tools..."

PACKAGES_MONITOR=(
    btop ncdu duf iotop
    mtr traceroute dnsutils whois netcat-openbsd
)

for pkg in "${PACKAGES_MONITOR[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log_info "$pkg already installed"
    else
        log_info "Installing $pkg..."
        sudo apt-get install -y "$pkg"
    fi
done

# =============================================================================
# MODERN CLI TOOLS
# =============================================================================
# Fast search, navigation, and terminal multiplexing.

log_info "Installing modern CLI tools..."

PACKAGES_CLI=(
    ripgrep fd-find bat fzf tmux
)

for pkg in "${PACKAGES_CLI[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log_info "$pkg already installed"
    else
        log_info "Installing $pkg..."
        sudo apt-get install -y "$pkg"
    fi
done

# =============================================================================
# COMPLETION
# =============================================================================

log_info "Fresh install script completed successfully"
log_info "Log saved to: $LOG_FILE"
