#!/usr/bin/env bash

export DISPLAY=:0

# Disable Touchscreen
xinput disable "ELAN9038:00 04F3:261A touch"

# Turn off screen
xset -display :0 dpms force off

# Stop slideshow
killall impressive &>/dev/null

