#!/usr/bin/env bash

echo "...user: install background and config"
cd /home/user/
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/bg.png
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/config/bilderrahmen.env
wget https://github.com/sebastianha/surface-photo-frame/blob/main/config/xbindkeysrc
mv bilderrahmen.env .bilderrahmen.env
mv xbindkeysrc .xbindkeysrc

echo "...user: configure icewm"
mkdir -p /home/user/.icewm
cd /home/user/.icewm
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/icewm/prefoverride
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/icewm/startup
wget https://github.com/sebastianha/surface-photo-frame/blob/main/icewm/theme
chmod +x /home/user/.icewm/startup

echo "...user: installing slide show scripts"
mkdir -p /home/user/bin
cd /home/user/bin
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/scripts/autodim.sh
wget https://raw.githubusercontent.com/sebastianha/surface-photo-frame/main/scripts/start.sh
wget https://github.com/sebastianha/surface-photo-frame/blob/main/scripts/status.sh
wget https://github.com/sebastianha/surface-photo-frame/blob/main/scripts/stop.sh
wget https://github.com/sebastianha/surface-photo-frame/blob/main/scripts/sync_photos.sh
wget https://github.com/sebastianha/surface-photo-frame/blob/main/scripts/toggle.sh
chmod +x /home/user/bin/*.sh

echo "...user: create contab entries"
(crontab -l 2>/dev/null; echo "* * * * * /home/user/bin/autodim.sh &>/dev/null") | crontab -
(crontab -l 2>/dev/null; echo "0 */4 * * * /home/user/bin/sync_photos.sh") | crontab -
(crontab -l 2>/dev/null; echo "#0 21 * * * /home/user/bin/stop.sh") | crontab -
(crontab -l 2>/dev/null; echo "#0 8 * * * /home/user/bin/start.sh") | crontab -

echo "...user: please set variables"
vi .bilderrahmen.env

echo "...user: syncing photos"
/home/user/bin/sync_photos.sh
