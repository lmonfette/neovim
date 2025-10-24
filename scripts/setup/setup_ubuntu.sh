#!/bin/bash

# prevent double inclusion
if [[ -n "${SETUP_UBUNTU_FILE_INCLUDED:-}" ]]; then
    return 0
fi
SETUP_UBUNTU_FILE_INCLUDED=1
# prevent double inclusion

ubuntu_setup() {
    # prepare apt package manager
    sudo apt update -y
    sudo apt upgrade -y

    echo "Install nerd fonts: https://medium.com/@almatins/install-nerdfont-or-any-fonts-using-the-command-line-in-debian-or-other-linux-f3067918a88c"

    # install neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

    rm nvim-linux-x86_64.tar.gz

    # install git
    sudo apt install -y git

    #install cmake
    sudo apt install -y cmake

    # install vim
    sudo apt install -y vim

    # install wl-clipboard to allow copy/paste to clipboard (with Wayland, consider xsel for other setup)
    sudo apt install wl-clipboard

    # install ruby
    sudo apt install -y ruby

    # install luarocks (package manager used by neovim)
    sudo apt install -y luarocks

    # install tree-sitter-cli
    sudo apt install -y tree-sitter-cli

    # install ripgrep (tool used by the telescope fuzzy finder)
    sudo apt install -y ripgrep

    # install fd-find (tool used by the telescope fuzzy finder)
    sudo apt install -y fd-find
    #create a symlink for fd to be used
    rm /usr/bin/fd
    sudo ln -s "$(which fdfind)" /usr/bin/fd

    # install xournal (PDF editing)
    sudo apt install -y xournalpp

    # install pip3
    sudo apt install -y python3-pip

    # install npm
    sudo apt install -y npm

    # install node
    # Download and install nvm:
    # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    #
    # # in lieu of restarting the shell
    # \. "$HOME/.nvm/nvm.sh"
    #
    # # Download and install Node.js:
    # nvm install 22
    #
    # # Verify the Node.js version:
    # node -v # Should print "v22.17.0".
    # nvm current # Should print "v22.17.0".
    #
    # # Verify npm version:
    # npm -v # Should print "10.9.2".
    # install node done

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

    # install tmux
    sudo apt install -y tmux

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

    # install everything needed for sway (tiling window manager)
    sudo apt install -y alacritty light sway swaybg swayidle swayimg swaylock waybar wofi fonts-font-awesome
    sudo apt install -y xdg-desktop-portal-wlr pipewire wireplumber
}
