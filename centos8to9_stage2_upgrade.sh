#!/bin/bash
set -e

LOGFILE="/var/log/centos8to9-upgrade.log"

log_msg() {
    local TIMESTAMP
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "$TIMESTAMP - $1" | tee -a "$LOGFILE"
}

run_cmd() {
    local CMD="$1"
    log_msg "Executing: $CMD"
    eval "$CMD" >>"$LOGFILE" 2>&1
    local EXIT_CODE=$?
    if [[ $EXIT_CODE -ne 0 ]]; then
        log_msg "❌ ERROR: Command failed with exit code $EXIT_CODE"
    else
        log_msg "✅ SUCCESS: Command completed successfully"
    fi
}

log_msg "[Stage 2] Performing the CentOS 9 Stream upgrade..."

run_cmd "rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial"

run_cmd "dnf module disable python36 virt -y"

# Ensure we have the latest CentOS 9 repositories installed
run_cmd "dnf install -y \
    https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/centos-stream-release-9.0-22.el9.noarch.rpm \
    https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-9.0-22.el9.noarch.rpm \
    https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-9.0-22.el9.noarch.rpm"

# Upgrade systemd first to avoid transaction failures
log_msg "Upgrading systemd separately to avoid transaction failures..."
run_cmd "dnf update -y systemd selinux-policy*"

# Upgrade the system to CentOS 9 Stream
log_msg "Syncing packages to CentOS 9 Stream..."
run_cmd "dnf --releasever=9 --allowerasing --setopt=deltarpm=false distro-sync -y"

# Rebuild RPM database
log_msg "Rebuilding the RPM database..."
run_cmd "rpm --rebuilddb"

# Restart systemd services if they were upgraded
log_msg "Restarting systemd and related services before reboot..."
run_cmd "systemctl daemon-reexec"

log_msg "🚀 System needs to reboot after this stage. Please run 'sudo reboot' and proceed to Stage 3."
