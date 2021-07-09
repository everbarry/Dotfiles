#!/bin/bash

# does full system update
echo "Doing a system update..."
sudo pacman --noconfirm -Syy
sudo pacman --noconfirm -Syu

# install base-devel if not installed
sudo pacman -S --noconfirm --needed base-devel wget git

# install video drivers
echo "1) intel 	2)nvidia 3) Skip"
read -r -p "Choose you video card driver(default 1)(will not re-install): " vid

case $vid in 
[1])
	DRI='xf86-video-intel mesa'
	;;

[2])
	DRI='nvidia nvidia-settings nvidia-utils'
	;;
[3])
	DRI=""
	;;
[*])
	DRI='xf86-video-intel'
	;;
esac



# install xorg if not installed
sudo pacman -S --noconfirm --needed acpi feh $DRI xmonad zsh rofi xmonad-contrib xorg-server xorg-xinit xorg-xrandr

# install fonts, window manager and terminal
mkdir -p ~/.local/share/fonts
mkdir -p ~/.srcs

# git clone $CLIENT/$FONT 
cp -r ./fonts/* ~/.local/share/fonts/
fc-cache -f
clear 

# install yay
read -r -p "Would you like to install yay? Say no if you already have it [yes/no]: " yay 
sleep 3

case $yay in
[yY][eE][sS]|[yY])
	git clone https://aur.archlinux.org/yay.git ~/.srcs/yay
	(cd ~/.srcs/yay/ && makepkg -si )

	yay -S picom-jonaburg-git acpi rofi-git candy-icons-git wmctrl alacritty playerctl dunst xmonad-contrib jq xclip maim
	;;

[nN][oO]|[nN])
	yay -S picom-jonaburg-git acpi rofi-git candy-icons-git wmctrl alacritty playerctl dunst xmonad-contrib jq xclip maim
	;;

[*])
	echo "Abort, Ctrl+C to quit" 
	sleep 100000
	;;
esac

#install custom picom config file 
mkdir -p ~/.config/
    if [ -d ~/.config/rofi ]; then
        echo "Rofi configs detected, backing up..."
        mkdir ~/.config/rofi.old && mv ~/.config/rofi/* ~/.config/rofi.old/
        cp -r ./config/rofi/* ~/.config/rofi;
    else
        echo "Installing rofi configs..."
        mkdir ~/.config/rofi && cp -r ./config/rofi/* ~/.config/rofi;
    fi
    if [ -f ~/.config/picom.conf ]; then
        echo "Picom configs detected, backing up..."
        cp ~/.config/picom.conf ~/.config/picom.conf.old;
        cp ./config/picom.conf ~/.config/picom.conf;
    else
        echo "Installing picom configs..."
         cp ./config/picom.conf ~/.config/picom.conf;
    fi
    if [ -f ~/.config/alacritty.yml ]; then
        echo "Alacritty configs detected, backing up..."
        cp ~/.config/alacritty.yml ~/.config/alacritty.yml.old;
        cp ./config/alacritty.yml ~/.config/alacritty.yml;
    else
        echo "Installing alacritty configs..."
         cp ./config/alacritty.yml ~/.config/alacritty.yml;
    fi
    if [ -d ~/.config/dunst ]; then
        echo "Dunst configs detected, backing up..."
        mkdir ~/.config/dunst.old && mv ~/.config/dunst/* ~/.config/dunst.old/
        cp -r ./config/dunst/* ~/.config/dunst;
    else
        echo "Installing dunst configs..."
        mkdir ~/.config/dunst && cp -r ./config/dunst/* ~/.config/dunst;
    fi
    if [ -d ~/wallpapers ]; then
        echo "Adding wallpaper to ~/wallpapers..."
        cp ./wallpapers/wallpaper.jpg ~/wallpapers/;
    else
        echo "Installing wallpaper..."
        mkdir ~/wallpapers && cp -r ./wallpapers/* ~/wallpapers/;
    fi
    if [ -d ~/.xmonad ]; then
        echo "XMonad configs detected, backing up..."
        mkdir ~/.xmonad.old && mv ~/.xmonad/* ~/.xmonad.old/
        cp -r ./xmonad/* ~/.xmonad/;
    else
        echo "Installing xmonad configs..."
        mkdir ~/.xmonad && cp -r ./xmonad/* ~/.xmonad;
    fi
    if [ -d ~/bin ]; then
        echo "~/bin detected, backing up..."
        mkdir ~/bin.old && mv ~/bin/* ~/bin.old/
        cp -r ./bin/* ~/bin;
	clear
    else
        echo "Installing bin scripts..."
        mkdir ~/bin && cp -r ./bin/* ~/bin/;
	clear
        echo "Please add: export PATH='\$PATH:/home/{Your_user}/bin' to your .zshrc. Replace {Your_user} with your username."
    fi
    


# add xorg desktop entry
touch ~/.xinitrc
echo "exec xmonad" >> ~/xinitrc


# done 
echo "PLEASE MAKE .xinitrc TO LAUNCH, or just use your dm" | tee ~/Note.txt
echo "run 'p10k configure' to set up your zsh" | tee -a ~/Note.txt
echo "after you this -> 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'" | tee -a ~/Note.txt
printf "\n" >> ~/Note.txt
echo "Please add: export PATH='\$PATH:/home/{Your_user}/bin' to your .zshrc if not done already. Replace {Your_user} with your username." | tee -a ~/Note.txt
echo "For startpage, copy the startpage directory into wherever you want, and set it as new tab in firefox settings." | tee -a ~/Note.txt
echo "For more info on startpage (Which is a fork of Prismatic Night), visit https://github.com/dbuxy218/Prismatic-Night#Firefoxtheme" | tee -a ~/Note.txt
echo "ALL DONE! Issue 'xmonad --recompile' and then re-login for all changes to take place!" | tee -a ~/Note.txt
echo "Make sure your default shell is ZSH too..." | tee -a ~/Note.txt
echo "Open issues on github or ask me on discord or whatever if you face issues." | tee -a ~/Note.txt
echo "Install Museo Sans as well. Frome Adobe I believe." | tee -a ~/Note.txt
echo "If the bar doesn't work, use tint2conf and set stuff up, if you're hopelessly lost(which you probably are not), open an issue." | tee -a ~/Note.txt
echo "These instructions have been saved to ~/Note.txt. Make sure to go through them."
sleep 5
xmonad --recompile

mkdir ~/zsh
cd ~/zsh

# install zsh and make it default
sudo pacman --noconfirm --needed -S zsh
#OhMyZsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
