#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1
source ./scripts/helpers.sh
root_dir=$(pwd)

# Dwall

sudo pacman -Syu yay || exit 1

op 'Installing dwall dependencies...' \
  "sudo pacman -Sy xorg-xrandr feh cronie" \
  'Dependencies installed successfully.' \
  'Failed to install dependencies.' || exit 1

op 'Installing dwall...' \
  " git clone https://github.com/adi1090x/dynamic-wallpaper.git
    cd dynamic-wallpaper                                       
    chmod +x install.sh                                        
    ./install.sh || exit 1                                     
  " \
  'Successfully installed dwall.' \
  'Failed to install dwall.' || exit 1

op 'Enabling cronie...' \
  "sudo systemctl enable cronie.service --now" \
  'Successfully enabled cronie.' \
  'Failed to enable cronie.' || exit 1

cron_job="0 * * * * $SHELL PATH=$PATH DISPLAY=$DISPLAY DESKTOP_SESSION=$DESKTOP_SESSION DBUS_SESSION_BUS_ADDRESS=\"$DBUS_SESSION_BUS_ADDRESS\" /usr/bin/dwall -s firewatch"
op 'Adding dwall cron job...' \
  " (                                
      crontab -l                     
      echo \"$cron_job\"             
    ) | sort - | uniq - | crontab -  
  " \
  "Successfully added \"$cron_job\"" \
  "Failed to add \"$cron_job\"" || exit 1

# Alacritty

op 'Installing alacritty deps...' \
  'pacman -S --noconfirm cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python' \
  'Successfully installed alacritty deps.' \
  'Failed to install alacritty deps.' || exit 1

op 'Installing rust...' \
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" \
  'Successfully installed rust.' \
  'Failed to install rust.' || exit 1

source "$HOME/.cargo/env" || exit 1

op 'Installing alacritty...' \
  'cargo install alacritty' \
  'Successfully installed alacritty.' \
  'Failed to install alacritty.' || exit 1

if [ -d alacritty ]; then
  yes | rm -r alacritty
fi

op 'Cloning alacritty repo...' \
  'git clone https://github.com/alacritty/alacritty.git && cd alacritty' \
  'Successfully copied alacritty repo.' \
  'Failed to copy alacritty repo.' || exit 1

op 'Installing alacritty terminfo...' \
  'infocmp alacritty || sudo tic -xe alacritty,alacritty-direct extra/alacritty.info' \
  'Successfully installed alacritty terminfo.' \
  'Failed to install alacritty terminfo.' || exit 1

op 'Installing alacritty zsh completions...' \
  " mkdir -p ${ZDOTDIR:-~}/.zsh_functions                                   
    echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc      
    cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty 
  " \
  'Successfully installed alacritty zsh completions.' \
  'Failed to install alacritty zsh completions.' || exit 1

op 'Installing alacritty bash completions...' \
  " mkdir -p ~/.bash_completion                                      
    cp extra/completions/alacritty.bash ~/.bash_completion/alacritty 
    echo \"source ~/.bash_completion/alacritty\" >> ~/.bashrc        
  " \
  'Successfully installed alacritty zsh completions.' \
  'Failed to install alacritty zsh completions.' || exit 1

cd "$root_dir" || exit 1

# rofi

op 'Installing rofi...' \
  'sudo pacman -Syu rofi' \
  'Successfully installed rofi.' \
  'Failed to install rofi.' || exit 1

# picom
cd "$root_dir" || exit 1
op 'Installing picom...' \
  'sudo pacman -S picom' \
  'Successfully installed picom' \
  'Failed to install picom' || exit 1

op 'Copying picom config...' \
  'yes | cp ./picom.conf ..' \
  'Successfully copied picom config.' \
  'Failed to copy picom config.' || exit 1

# Further packages
cd "$root_dir" || exit 1
op 'Installing remaining pacman packages...' \
  'yes | head -n1 | sudo pacman -Sy - < packages.txt' \
  'Successfully installed remaining packages.' \
  'Failed to install remaining packages.' || exit 1

op 'Installing remaining aur packages...' \
  'yay -S --needed --noconfirm - < aur-packages.txt' \
  'Successfully installed remaining aur packages.' \
  'Failed to install remaining aur packages.' || exit 1

echo 0 | sudo tee /proc/sys/vm/dirty_expire_centisecs
echo 0 | sudo tee /proc/sys/vm/dirty_writeback_centisecs
echo 1 | sudo tee /proc/sys/vm/drop_caches
