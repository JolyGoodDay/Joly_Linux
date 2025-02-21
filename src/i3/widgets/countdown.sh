#!/bin/bash

generate() {
    local date_to_target="$1"

    date_to_seconds() {
        local date="$1"
        date -d "$date" +%s 2>/dev/null || { echo "Invalid date format: $date"; exit 1; }
    }

    declare -A excluded_dates
    for date in "2025-5-26" "2025-7-3" "2025-7-4" "2025-9-1" "2025-11-11" "2025-11-27" "2025-11-28"; do
        excluded_dates["$date"]=1
    done

    is_excluded() {
        [[ -n "${excluded_dates[$1]}" ]]
    }

    calculate_original_countdown() {
        echo $((target_date - current_date))
    }

    calculate_adjusted_countdown() {
        local total_seconds=0
        local time_cursor=$current_date

        while [ "$time_cursor" -lt "$target_date" ]; do
            local current_day
            current_day=$(date -d "@$time_cursor" +%Y-%m-%d)

            if ! is_excluded "$current_day"; then
                local business_start=$(date -d "$current_day 09:00:00" +%s)
                local business_end=$(date -d "$current_day 17:00:00" +%s)

                if [ "$time_cursor" -lt "$business_start" ]; then
                    time_cursor=$business_start
                fi

                if [ "$time_cursor" -lt "$business_end" ]; then
                    total_seconds=$((total_seconds + business_end - time_cursor))
                fi
            fi

            time_cursor=$((time_cursor + 86400))
        done

        echo "$total_seconds"
    }

    calculate_subtracted_days_countdown() {
        local excluded_days=0
        local time_cursor=$current_date

        while [ "$time_cursor" -lt "$target_date" ]; do
            local current_day
            current_day=$(date -d "@$time_cursor" +%Y-%m-%d)
            local day_of_week
            day_of_week=$(date -d "$current_day" +%u)

            if is_excluded "$current_day" || [ "$day_of_week" -gt 5 ]; then
                ((excluded_days++))
            fi

            time_cursor=$((time_cursor + 86400))
        done

        echo $(( (target_date - current_date) - (excluded_days * 86400) ))
    }

    format_time() {
        local seconds=$1
        (( seconds < 0 )) && echo "0-D 0-H 0-M 0-S" && return
        printf "%d-D %d-H %d-M %d-S\n" $((seconds / 86400)) $(((seconds % 86400) / 3600)) $(((seconds % 3600) / 60)) $((seconds % 60))
    }

    format_hours() {
        local seconds=$1
        (( seconds < 0 )) && echo "0 Hours" && return
        printf "%d Hours %d Minutes\n" $((seconds / 3600)) $(((seconds % 3600) / 60))
    }

    target_date=$(date_to_seconds "$date_to_target")
    current_date=$(date +%s)

    (( target_date < current_date )) && { echo "The date provided is in the past."; exit 1; }

    original_seconds=$(calculate_original_countdown)
    adjusted_seconds=$(calculate_adjusted_countdown)
    subtracted_days_seconds=$(calculate_subtracted_days_countdown)
}

interactive_mode() {
    source ~/.config/i3/src/colors.sh
    dates_to_count=("2025-5-16" "2025-7-18" "2025-11-15")

    tput civis
    trap "tput cnorm; exit" INT
    printf "Current Date:\n"
    for block in "${dates_to_count[@]}"; do
        printf "Countdown Date:\nCountdown:\nW Day Countdown:\nW Hours left:\n----------------------------------------------------\n"
    done
    printf "\nPress Ctrl+C to exit or q to quit.\n"

    while true; do
        tput cup 0 14
        printf "${RED}$(date)${RESET}"

        x=1
        for gen_date in "${dates_to_count[@]}"; do
            generate "$gen_date"
            tput cup $x 16
            printf "${GREEN}$gen_date${RESET}"
            ((x++))
            tput cup $x 11
            printf "${CYAN}$(format_time "$original_seconds")${RESET}"
            ((x++))
            tput cup $x 17
            printf "${YELLOW}$(format_time "$subtracted_days_seconds")${RESET}"
            ((x++))
            tput cup $x 14
            printf "${MAGENTA}$(format_hours "$adjusted_seconds")${RESET}"

            ((x+=2))
        done

        read -t 1 -n 1 key
        [[ $key == "q" ]] && { tput cnorm; break; }
    done
}

if [[ $BLOCK_BUTTON == 1 ]]; then
    alacritty --class "Widget" --title "Countdown Timer" -e bash -c "$(declare -f generate interactive_mode); interactive_mode"
fi

generate "2025-11-15"
echo "Time left: $(format_time "$subtracted_days_seconds")"
