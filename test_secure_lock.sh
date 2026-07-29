#!/bin/bash

LOCK_SCRIPT="$(dirname "$(readlink -f "$0")")/src/i3/lock.sh"

setsid "$LOCK_SCRIPT" &
LOCK_PID=$!

sleep 30
kill -- -$LOCK_PID
