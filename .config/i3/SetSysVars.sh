#!/usr/bin/env bash
#  ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗    ██╗   ██╗ █████╗ ██████╗ ███████╗
#  ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║    ██║   ██║██╔══██╗██╔══██╗██╔════╝
#  ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║    ██║   ██║███████║██████╔╝███████╗
#  ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║    ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║
#  ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║     ╚████╔╝ ██║  ██║██║  ██║███████║
#  ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝      ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝


CONFIG_FILE="$HOME/.config/polybar/system.ini"
SFILE="$HOME/.config/polybar/.sys"

# Check if the .sys file already exists
[[ -f "$SFILE" ]] && exit 0 # The file exists, exit without doing anything

# Function to get and set values
function setup_system_vars() {
    # Network interfaces (primary and secondary)
    # readarray -t ALL_NET < <(ip -o link show up | awk -F': ' '{print $2}' | grep -vE '^(lo|docker|veth|br-)')

	PRIMARY_NET=$(ip -o route get 1 | awk '{print $5; exit}')
	#SECONDARY_NET=$(printf '%s\n' "${ALL_NET[@]}" | grep -v "$PRIMARY_NET" | head -n1)

    [[ -n "$PRIMARY_NET" ]] && sed -i "s/sys_network_interface = .*/sys_network_interface = $PRIMARY_NET/" "$CONFIG_FILE"
    # [[ -n "$SECONDARY_NET" ]] && sed -i "s/sys_network_interface2 = .*/sys_network_interface2 = $SECONDARY_NET/" "$CONFIG_FILE"

    # Graphics card (backlight)
    CARD=$(find /sys/class/backlight -maxdepth 1 -type l | head -n1 | xargs basename)
    [[ -n "$CARD" ]] && sed -i "s/sys_graphics_card = .*/sys_graphics_card = $CARD/" "$CONFIG_FILE"

    # Battery and adapter
    BATTERY=$(find /sys/class/power_supply -maxdepth 1 -type l -name "BAT*" | head -n1 | xargs basename)
    ADAPTER=$(find /sys/class/power_supply -maxdepth 1 -type l -name "A[CD]*" | head -n1 | xargs basename)

    [[ -n "$BATTERY" ]] && sed -i "s/sys_battery = .*/sys_battery = $BATTERY/" "$CONFIG_FILE"
    [[ -n "$ADAPTER" ]] && sed -i "s/sys_adapter = .*/sys_adapter = $ADAPTER/" "$CONFIG_FILE"

    # trying to determine the best font size, based on your resolution.
    read -r screen_width screen_height < <(xdpyinfo | awk '/dimensions:/ {print $2}' | tr 'x' ' ')

    if [ "$screen_width" -le 1366 ] && [ "$screen_height" -le 768 ]; then
		font_size=9
	elif [ "$screen_width" -le 1600 ] && [ "$screen_height" -le 900 ]; then
		font_size=10
	elif [ "$screen_width" -le 1920 ] && [ "$screen_height" -le 1080 ]; then
		font_size=10
	elif [ "$screen_width" -le 2560 ] && [ "$screen_height" -le 1440 ]; then
		font_size=11
	elif [ "$screen_width" -le 3840 ] && [ "$screen_height" -le 2160 ]; then
		font_size=12
	else
		font_size=10
	fi

    sed -i "s/size = [0-9]*/size = $font_size/" ~/.config/alacritty/fonts.toml
}

# Ejecutar la configuración
setup_system_vars

# Crear el archivo .sys para indicar que la configuración ya se ha realizado
touch "$SFILE"
