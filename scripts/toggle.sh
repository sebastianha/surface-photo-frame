#!/usr/bin/env bash

# Detect if start.sh has just ended and if button pressed again shutdown
ps axu | grep "sleep 1.2345" | grep -v grep && sudo shutdown -h now

# stop is not really needed (legacy) as impressive binds power key
pgrep -x impressive &>/dev/null && /home/user/bin/stop.sh || /home/user/bin/start.sh
