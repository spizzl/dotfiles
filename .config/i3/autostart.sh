#!/bin/bash

feh --no-fehbg --bg-fill "$HOME/.config/walls/wall-04.webp"
PATH="$HOME/.config/i3:$PATH"
polybar -q main -c "$HOME/.config/polybar/config.ini" &	
picom --config "$HOME/.config/picom/picom.conf" &
setxkbmap -model apple -layout de -variant mac_nodeadkeys -option
