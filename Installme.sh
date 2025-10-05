#!/bin/sh
# Adding Colors
CRE=$(tput setaf 1)    # Red
CYE=$(tput setaf 3)    # Yellow
CGR=$(tput setaf 2)    # Green
CBL=$(tput setaf 4)    # Blue
BLD=$(tput bold)       # Bold
CNC=$(tput sgr0)       # Reset colors

# Error log file
ERROR_LOG="$HOME/install_error.log"

if [ "$(id -u)" = 0 ]; then
    printf "%b\n"  "${BLD}${WCRE}[-] This script doesnt require root privileges!${CNC}"
    exit 1
fi

if [ "$PWD" != "$HOME" ]; then
    printf "%b\n"  "${BLD}${WCRE}[-] This script must be run from the \$HOME directory${CNC}"
    exit 1
fi



add_chaotic_repo() {
    clear
    repo_name="chaotic-aur"
    key_id="3056513887B78AEB"
    sleep 2

    printf "%b\n" "${BLD}${CYE}Installing ${CBL}${repo_name}${CYE} repository...${CNC}"

    # Verifying if repo was already added
    if grep -q "\[${repo_name}\]" /etc/pacman.conf; then
        printf "%b\n" "\n${BLD}${CYE}Repository already exists in pacman.conf${CNC}"
        sleep 3
        return 0
    fi

    # Zuerst die Schlüssel-Repository hinzufügen
    printf "%b\n" "${BLD}${CYE}Adding chaotic-aur keyring...${CNC}"
    
    # Chaotic-AUR Schlüssel manuell installieren
    sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key FBA220DFC880C036
    
    # Alternativen Schlüssel versuchen
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB

    # Keyring manuell installieren
    printf "%b\n" "${BLD}${CYE}Installing keyring packages...${CNC}"
    sudo pacman -U --noconfirm https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst
    sudo pacman -U --noconfirm https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst

    # Repository zu pacman.conf hinzufügen
    printf "\n%b\n" "${BLD}${CYE}Adding repository to pacman.conf...${CNC}"
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf

    # Pacman Datenbank aktualisieren
    printf "%b\n" "${BLD}${CYE}Updating pacman database...${CNC}"
    sudo pacman -Sy

    printf "%b\n" "\n${BLD}${CBL}${repo_name} ${CGR}Repository configured successfully!${CNC}"
    sleep 3
}



installed() {
    pacman -Qq "$1" >/dev/null 2>&1
}

log_error() {
    echo "$(date): $1" >> "$ERROR_LOG"
}

install_dependencies() {
    dependencies="alacritty base-devel bat brightnessctl bspwm clipcat dunst eza feh fzf thunar tumbler gvfs-mtp firefox geany git imagemagick jq jgmenu kitty libwebp maim mpc mpd mpv neovim ncmpcpp npm pamixer pacman-contrib papirus-icon-theme picom playerctl polybar lxsession-gtk3 python-gobject redshift rofi rustup sxhkd tmux xclip xdg-user-dirs xdo xdotool xsettingsd xorg-xdpyinfo xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot xorg-xwininfo yazi zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-terminus-nerd ttf-ubuntu-mono-nerd webp-pixbuf-loader"
    missing_pkgs=""
    
    # Check for missing packages
    for pkg in $dependencies; do
        if ! installed "$pkg"; then
            printf "\n%b" "${BLD}${CYE} $pkg not installed ${CNC}"
            missing_pkgs="$missing_pkgs $pkg"
        else
            printf "\n%b" "${BLD}${CBL} $pkg already installed ${CNC}"
        fi
    done
    
    # If there are missing packages, install them
    if [ -n "$missing_pkgs" ]; then
        printf "\n%b\n\n" "${BLD}${CYE}Installing packages, please wait...${CNC}"
        
        if sudo pacman -S --noconfirm $missing_pkgs 2>&1 | tee -a "$ERROR_LOG" >/dev/null; then
            # Verify complete installation
            failed_pkgs=""
            for pkg in $missing_pkgs; do
                if ! installed "$pkg"; then
                    failed_pkgs="$failed_pkgs $pkg"
                    log_error "Failed to install: $pkg"
                fi
            done
            
            # Show final results
            if [ -z "$failed_pkgs" ]; then
                printf "%b\n\n" "${BLD}${CGR}All packages installed successfully!${CNC}"
            else
                fail_count=$(echo "$failed_pkgs" | wc -w)
                printf "%b\n" "${BLD}${WCRE}Failed to install $fail_count packages:${CNC}"
                printf "%b\n\n" "  ${BLD}${CYE}$failed_pkgs${CNC}"
            fi
        else
            log_error "Critical error during batch installation"
            printf "%b\n" "${BLD}${WCRE}Installation failed! Check log for details${CNC}"
            return 1
        fi
    else
        printf "%b\n" "\n${BLD}${CGR}All dependencies are already installed!${CNC}"
    fi
}

backup_config() {
    printf "%b\n" "Backing up previous .config files"
    config_folders="alacritty dunst nvim polybar rofi dconf i3 picom ranger walls"
    date=$(date +%Y%m%d-%H%M%S)
    backup_folder="$HOME/backup_config_$date"
    mkdir $backup_folder
    for folder in $config_folders; do
        if mv $folder $backup_folder 2>> "$ERROR_LOG"; then
            printf "%b\n" "${CRE} ERROR Copying folder $folder to BackupFolder! ${CNC}..exiting"
	    exit 1
        fi
    done
    printf "%b\n" "${CYE} done copying files to backup folder ${CNC}"
    sleep 1
}

cloning_repo() {
     printf "%b\n" "${CBL} Cloning repo now... ${CNC}"
     if git clone "https://github.com/spizzl/dotfiles.git" "fuzzywood_dotfiles" >> "$ERROR_LOG" 2>&1; then
	printf "%b\n" "${CGR} Cloning repo was successfull! ${CNC}"
	sleep 1
     else
         printf "%b\n" "${CRE} ERROR cloning repo ${CNC}..exiting"
	exit 1
    fi

}
copy_config_files() {
     printf "%b\n" "${CBL} Now trying to copy config files to .config folder ${CNC}"
     config_folders="alacritty dunst nvim polybar rofi dconf i3 picom ranger walls"
     for folder in $config_folders; do
         cp "$HOME/fuzzywood_dotfiles/$folder" "$HOME/.config/"
     done
    printf "%b\n" "${CYE} done copying files to .config folder ${CNC}"
    sleep 1
}

add_chaotic_repo
install_dependencies
cloning_repo
backup_config
copy_config_files
