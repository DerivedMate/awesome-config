#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1
source ./scripts/helpers.sh

op 'Installing dwall dependencies...' \
  "sudo pacman -Sy xorg-xrandr feh cronie" \
  'Dependencies installed successfully.' \
  'Failed to install dependencies.' || exit 1

op 'Installing dwall...' \
  " git clone https://github.com/adi1090x/dynamic-wallpaper.git \
    cd dynamic-wallpaper                                        \
    chmod +x install.sh                                         \
    ./install.sh || exit 1                                      \
  " \
  'Successfully installed dwall.' \
  'Failed to install dwall.' || exit 1

op 'Enabling cronie...' \
  "sudo systemctl enable cronie.service --now" \
  'Successfully enabled cronie.' \
  'Failed to enable cronie.' || exit 1

cron_job="0 * * * * $SHELL PATH=$PATH DISPLAY=$DISPLAY DESKTOP_SESSION=$DESKTOP_SESSION DBUS_SESSION_BUS_ADDRESS=\"$DBUS_SESSION_BUS_ADDRESS\" /usr/bin/dwall -s firewatch"
op 'Adding dwall cron job...' \
  " (                                \
      crontab -l                     \
      echo \"$cron_job\"             \
    ) | sort - | uniq - | crontab -  \
  " \
  "Successfully added \"$cron_job\"" \
  "Failed to add \"$cron_job\"" || exit 1
