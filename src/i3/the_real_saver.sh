#!/bin/sh

myname="${0##*/}"

VIDEO_DIR="${LOCK_VIDEO_DIR:-${HOME}/Videos}"
VIDEO_EXTS="mp4 mkv avi mov webm flv"

saver_pids=""

SAVER_LOG="${HOME}/.cache/saver.log"
log() { printf '%s %s: %s\n' "$(date '+%F %T')" "$myname" "$1" >> "$SAVER_LOG"; }

find_video() {
    found=""
    for ext in $VIDEO_EXTS; do
        results=$(find "$VIDEO_DIR" -type f -iname "*.${ext}" 2>/dev/null)
        found="${found}${results}
"
    done
    printf '%s' "$found" | grep -v '^$' | shuf -n 1
}


stop_savers() {
    if [ -n "$saver_pids" ]; then
        for pid in $saver_pids; do
            kill "$pid" 2>/dev/null
        done
        saver_pids=""
    fi
}

start_savers() {
    video=$(find_video)
    if [ -z "$video" ]; then
        log "no videos found in $VIDEO_DIR — showing black screen"
        sleep 2147483647 &
        saver_pids="$!"
        return
    fi
    log "playing: $video"

    if ! command -v mpv >/dev/null 2>&1; then
        log "mpv not found — cannot play video"
        sleep 2147483647 &
        saver_pids="$!"
        return
    fi

    mpv \
        --no-input-terminal \
        --loop=inf \
        --no-stop-screensaver \
        --wid="${XSCREENSAVER_WINDOW}" \
        --no-config \
        --hwdec=auto \
        --really-quiet \
        --no-audio \
        --vo=gpu \
        --no-border \
        "$video" >> "$SAVER_LOG" 2>&1 &
    saver_pids="$!"
    log "mpv pid $saver_pids playing $video"
}

sig_handler() {
    log "USR1 received — switching video"
    stop_savers
    start_savers
}

cleanup() {
    stop_savers
}

trap 'sig_handler' USR1
trap 'cleanup' EXIT INT TERM

while [ "$#" -gt 0 ]; do
    case "$1" in
        -root) : ;;
        *) log "unknown arg: $1" ;;
    esac
    shift
done

start_savers

wait
