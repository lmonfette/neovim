#!/bin/bash

NVIM_CGF_DIR=~/.config/nvim
NVIM_SCRIPTS_DIR=$NVIM_CGF_DIR/scripts

source "${NVIM_SCRIPTS_DIR}/utils/utils.sh"
source "${NVIM_SCRIPTS_DIR}/setup/setup_macos.sh"
source "${NVIM_SCRIPTS_DIR}/setup/setup_ubuntu.sh"
source "${NVIM_SCRIPTS_DIR}/setup/setup_windows.sh"

setup() {
    exec_os_specific macos_setup ubuntu_setup windows_setup
}
