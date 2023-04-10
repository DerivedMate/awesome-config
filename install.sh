#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1
source ./scripts/helpers.sh

# Dwall

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

op 'Installing rust...' \
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" \
  'Successfully installed rust.' \
  'Failed to install rust.' || exit 1

source "$HOME/.cargo/env" || exit 1

op 'Installing alacritty...' \
  'cargo install alacritty' \
  'Successfully installed alacritty.' \
  'Failed to install alacritty.' || exit 1

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
