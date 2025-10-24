#!/bin/bash

NVIM_CGF_DIR=~/.config/nvim
NVIM_SCRIPTS_DIR=$NVIM_CGF_DIR/scripts

source "${NVIM_SCRIPTS_DIR}/utils/utils.sh"
source "${NVIM_SCRIPTS_DIR}/installs/installs_macos.sh"
source "${NVIM_SCRIPTS_DIR}/installs/installs_ubuntu.sh"
source "${NVIM_SCRIPTS_DIR}/installs/installs_windows.sh"

install_openvpn_client() {
    exec_os_specific macos_install_openvpn_client ubuntu_install_openvpn_client windows_install_openvpn_client
}

install_all() {
    install_openvpn_client
}
