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

log_msg "[Stage 3] Performing post-upgrade cleanup and verification..."

run_cmd "cat /etc/centos-release"

run_cmd "uname -r"

log_msg "Checking latest kernel..."
latest_kernel=$(grubby --info=ALL | grep -E '^kernel=' | head -n 1 | cut -d= -f2)
run_cmd "grubby --set-default='$latest_kernel'"

run_cmd "grub2-mkconfig -o /boot/grub2/grub.cfg"

run_cmd "dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)"

log_msg "🎉 Upgrade to CentOS 9 Stream completed successfully!"

#EOF