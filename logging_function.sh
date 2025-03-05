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
