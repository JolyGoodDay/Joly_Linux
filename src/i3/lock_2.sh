#https://github.com/eylles/betterxsecurelock/tree/master?tab=readme-ov-file
start_xsecurelock () {
    XSECURELOCK_FONT="Noto Sans CJK JP" \
    XSECURELOCK_PASSWORD_PROMPT="disco" \
    XSECURELOCK_SAVER=~/.local/bin/saver.sh \
    XSECURELOCK_SAVER_RESET_ON_AUTH_CLOSE=1 \
    XSECURELOCK_SHOW_HOSTNAME=0 \
    XSECURELOCK_SHOW_USERNAME=1 \
    XSECURELOCK_DATETIME_FORMAT='%A      %T' \
    XSECURELOCK_COMPOSITE_OBSCURER=0 \
    XSECURELOCK_NO_COMPOSITE=1 \
    XSECURELOCK_AUTH_TIMEOUT=120 \
    XSECURELOCK_BLANK_TIMEOUT=-1 \
    XSECURELOCK_SAVER_STOP_ON_BLANK=1 \
    XSECURELOCK_BURNIN_MITIGATION=50 \
    XSECURELOCK_BURNIN_MITIGATION_DYNAMIC=1 \
    XSECURELOCK_AUTH_BACKGROUND_COLOR=$AuthBgColor \
    XSECURELOCK_AUTH_FOREGROUND_COLOR=$AuthFgColor \
    XSECURELOCK_BLANK_DPMS_STATE=off \
    xsecurelock 2>/dev/null &
    xsecurelock_pid=$!
    sleep 1
    if ps -p "$xsecurelock_pid" -o cmd | grep -q "xsecurelock" ; then
        printf '%s %s: xsecurelock %s launched.\n' "$(date +"%F %T")" "${myname}" "$xsecurelock_pid" >> "${HOME}/.cache/xsecurelock"
        printf '%s %s: launched %s PID: %s \n' "$(date +"%F %T")" "${myname}" "$(ps -p $xsecurelock_pid -o command=)" "$xsecurelock_pid"
    else
        printf '%s %s: xsecurelock start failed, trying again.\n' "$(date +"%F %T")" "${myname}"
        start_xsecurelock
    fi
}

if pidof xsecurelock >/dev/null ; then
    instance_pid=$(pidof xsecurelock)
    printf '%s %s: xsecurelock instance %s already running, no new instance will be launched.\n' "$(date +"%F %T")" "${myname}" "$instance_pid"
    printf '%s %s: xsecurelock %s already running.\n' "$(date +"%F %T")" "${myname}" "$instance_pid" >> "${HOME}/.cache/xsecurelock"
    exit
else
    printf '%s %s: no xsecurelock instance running.\n' "$(date +"%F %T")" "${myname}"
    printf '%s %s: starting screenlocking.\n' "$(date +"%F %T")" "${myname}"
    . "${HOME}/.cache/wal/colors.sh"
    export SAVER_OPT="$COLO_OPT"
    case "${COLO_OPT}" in
        0)  export AuthBgColor="$color0" ;;
        2)  export AuthBgColor="$color2" ;;
        8)  export AuthBgColor="$color8" ;;
        10) export AuthBgColor="$color10" ;;
        15) export AuthBgColor="$color15" ;;
    esac
    case "${COLO_OPT}" in
        0)  export AuthFgColor="$color12" ;;
        2)  export AuthFgColor="$color15" ;;
        8)  export AuthFgColor="$color15" ;;
        10) export AuthFgColor="$color0" ;;
        15) export AuthFgColor="$color8" ;;
    esac

    start_xsecurelock

    kill_dangling_dimmers
    # auth watcher
    while pidof xsecurelock >/dev/null; do
        if pgrep auth_x11 >/dev/null; then
            # kill_dangling_dimmers
            if kill -0 "$dimmer_pid" 2>/dev/null; then
                dimmer_comm=$(ps -p "$dimmer_pid" -o command=)
                kill "$dimmer_pid"
                printf '%s %s: "%s" PID: %s killed.\n' "$(date +"%F %T")" "${myname}" "${dimmer_comm##*/}" "$dimmer_pid"
            fi
        else
            if ! pgrep dim-screen.sh >/dev/null; then
                sleep 1
                dim-screen.sh -step-time 0.2 &
                dimmer_pid=$!
            fi
        fi
        sleep 0.1
    done
    kill_dangling_dimmers
fi
printf '%s %s: screen unlocked.\n' "$(date +"%F %T")" "${myname}"
#printf '%s %s: screen unlocked.\n' "$(date +"%F %T")" "${myname}" >> "${HOME}/.cache/xsecurelock"