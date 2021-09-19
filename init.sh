#!/bin/bash

# touchpad settings
xinput --set-prop "ELAN071A:00 04F3:30FD Touchpad" "libinput Natural Scrolling Enabled" 1
xinput --set-prop "ELAN071A:00 04F3:30FD Touchpad" "libinput Tapping Enabled" 1

# dwall
dwall -s firewatch

# picom

picom