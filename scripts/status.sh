#!/usr/bin/env bash

export DISPLAY=:0
echo ""
echo -e "Uptime:\t\t`uptime | cut -d "," -f 1`"
echo -e "Load:\t\t`uptime | cut -d ":" -f 5`"
echo -e "Power:\t\t `cat /sys/class/power_supply/BAT1/status`"
echo -e "Battery:\t `cat /sys/class/power_supply/BAT1/capacity` %"
#echo -e "WiFi:\t\t `nmcli -f BARS device wifi | grep -v BARS`"
echo -e "Monitor:\t `xset q | grep "Monitor is Off" &>/dev/null && echo Off || echo On`"
echo -e "Brightness:\t `cat /sys/class/backlight/intel_backlight/brightness`/1500"
echo -e "Slideshow:\t `ps axu | grep impressive | grep -v grep &>/dev/null && echo Running || echo Off`"
echo ""
