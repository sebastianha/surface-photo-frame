#!/usr/bin/env bash

echo "...installing packages"
zypper install x11vnc htop xinput xbindkeys xev jq impressive

echo "...ignore power key"
echo "HandlePowerKey=ignore" >> /etc/systemd/logind.conf

echo "...allow shutdown for user"
echo "user ALL=NOPASSWD: /usr/sbin/shutdown" >> /etc/sudoers

echo "...allow brightness control for user"
echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"' > /etc/udev/rules.d/backlight.rules


echo "...switch to user"
cd /tmp/
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/install_user.sh
su - user -c ./install_user.sh

reboot

