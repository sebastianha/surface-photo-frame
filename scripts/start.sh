#!/usr/bin/env bash

# Load config
source $HOME/.bilderrahmen.env

# Stop impressive
killall impressive &>/dev/null

export DISPLAY=:0

# Turn on Display
xset -display :0 dpms force on

# Disable screensaver
xset dpms 60 60 60
xset s 60 60
xset -dpms
xset s off

# Hide mouse cursor
#unclutter -idle 0 -root &

# Enable Touchscreen
[[ ${IMPRESSIVE_ENABLE_TOUCH} == "true" ]] && xinput enable "ELAN9038:00 04F3:261A touch"

curl "${CURL_ON}" &>/dev/null &

# Bind power to F12 because impressive does not recognize power
xmodmap -e "keycode 124 = F12"

# Start slideshow
impressive \
	--shuffle --auto ${IMPRESSIVE_TIME} --wrap --transition ${IMPRESSIVE_TRANSITION} \
	--fullscreen --scale --nocursor --nologo --nooverview --noquit \
	--cache compressed --bind clearall --bind f12=quit --bind lmb=goto-next \
	"${IMPRESSIVE_PHOTODIR}"

# Disable Touchscreen
xinput disable "ELAN9038:00 04F3:261A touch"

# Turn off display
xset -display :0 dpms force off

curl "${CURL_OFF}" &>/dev/null &

# Sleep for exactly 1.2345s so that toggle script can detect double click to shutdown
sleep 1.2345
