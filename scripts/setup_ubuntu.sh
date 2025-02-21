#!/bin/bash

# prepare apt package manager
sudo apt update -y
sudo apt upgrade -y

echo "Install nerd fonts: https://medium.com/@almatins/install-nerdfont-or-any-fonts-using-the-command-line-in-debian-or-other-linux-f3067918a88c"

# install git
sudo apt install -y git

#install cmake
sudo apt install -y cmake

# install vim
sudo apt install -y vim

# install xclip to allow copy/paste to clipboard
sudo apt install -y xclip

# install ruby
sudo apt install -y ruby

# install luarocks (package manager used by neovim)
sudo apt install -y luarocks

# install
sudo apt install -y tree-sitter-cli

# install ripgrep (tool used by the telescope fuzzy finder)
sudo apt install -y ripgrep

# install fd-find (tool used by the telescope fuzzy finder)
sudo apt install -y fd-find
#create a symlink for fd to be used
rm /usr/bin/fd
sudo ln -s "$(which fdfind)" /usr/bin/fd

# install pip3
sudo apt install -y python3-pip

# install npm
sudo apt install -y npm

# install python3 venv
sudo apt install -y python3-venv

# install golang
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt install -y golang-go

# install curl
sudo apt install -y curl

# install wget
sudo app install -y wget

# install zsh
sudo apt install -y zsh

# install jq
sudo apt install -y jq

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/dracula/zsh.git

export ZSH="$HOME/.oh-my-zsh"

rm -rf "$HOME/.dracula-zsh/"
sudo mv ./zsh/ "$HOME/.dracula-zsh/"
rm -rf "$HOME/.themes/dracula.zsh-theme"
sudo ln -s "$HOME/.dracula-zsh/dracula.zsh-theme" "$ZSH/themes/dracula.zsh-theme"

sed -i 's/robbyrussell/dracula/g' ~/.zshrc

# install kitty
sudo apt install -y kitty

# make neovim the git commit ediot by default
git config --global core.editor "nvim"
