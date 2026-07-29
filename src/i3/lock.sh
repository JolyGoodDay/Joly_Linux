#!/bin/bash

myname="${0##*/}"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SAVER_SCRIPT="${SCRIPT_DIR}/the_real_saver.sh"
LOG_FILE="${HOME}/.cache/lock.log"

mkdir -p "$(dirname "$LOG_FILE")"
log() { printf '%s %s: %s\n' "$(date '+%F %T')" "$myname" "$1" | tee -a "$LOG_FILE"; }

get_colors() {
    AuthBgColor="#1a1a2e"
    AuthFgColor="#e0e0e0"
    if command -v xrdb >/dev/null 2>&1; then
        bg=$(xrdb -query 2>/dev/null | awk '/\*\.background|^\*background/{print $2; exit}')
        fg=$(xrdb -query 2>/dev/null | awk '/\*\.foreground|^\*foreground/{print $2; exit}')
        [ -n "$bg" ] && AuthBgColor="$bg"
        [ -n "$fg" ] && AuthFgColor="$fg"
    fi
}

check_deps() {
    if ! command -v xsecurelock >/dev/null 2>&1 && ! command -v i3lock >/dev/null 2>&1; then
        log "ERROR: neither xsecurelock nor i3lock found — cannot lock screen"
        exit 1
    fi
    if [ ! -f "$SAVER_SCRIPT" ]; then
        log "WARNING: saver not found at $SAVER_SCRIPT — using xsecurelock default"
        SAVER_SCRIPT=""
    elif [ ! -x "$SAVER_SCRIPT" ]; then
        log "WARNING: $SAVER_SCRIPT is not executable — fixing"
        chmod +x "$SAVER_SCRIPT"
    fi
}

do_lock() {
    if command -v xsecurelock >/dev/null 2>&1; then
        log "launching xsecurelock"
        [ -n "$SAVER_SCRIPT" ] && export XSECURELOCK_SAVER="$SAVER_SCRIPT"
        XSECURELOCK_FONT="Noto Sans CJK JP" \
        XSECURELOCK_PASSWORD_PROMPT="disco" \
        XSECURELOCK_SHOW_HOSTNAME=0 \
        XSECURELOCK_SHOW_USERNAME=1 \
        XSECURELOCK_DATETIME_FORMAT='%A  %T' \
        XSECURELOCK_COMPOSITE_OBSCURER=0 \
        XSECURELOCK_NO_COMPOSITE=1 \
        XSECURELOCK_AUTH_TIMEOUT=120 \
        XSECURELOCK_BLANK_TIMEOUT=-1 \
        XSECURELOCK_BLANK_DPMS_STATE=off \
        XSECURELOCK_SAVER_RESET_ON_AUTH_CLOSE=1 \
        XSECURELOCK_BURNIN_MITIGATION=50 \
        XSECURELOCK_BURNIN_MITIGATION_DYNAMIC=1 \
        XSECURELOCK_AUTH_BACKGROUND_COLOR="$AuthBgColor" \
        XSECURELOCK_AUTH_FOREGROUND_COLOR="$AuthFgColor" \
        xsecurelock 2>/dev/null
    else
        log "xsecurelock not found — falling back to i3lock"
        i3lock -c 1a1a2e
    fi
}

# --- main ---

if pgrep -x xsecurelock >/dev/null 2>&1; then
    instance_pid=$(pgrep -x xsecurelock)
    log "xsecurelock already running (PID $instance_pid) — aborting"
    exit 0
fi

log "starting screen lock"
get_colors
check_deps
do_lock
log "screen unlocked"
