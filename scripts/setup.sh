#!/bin/bash

# prevent double inclusion
if [[ -n "${ROOT_SETUP_FILE_INCLUDED:-}" ]]; then
    return 0
fi
ROOT_SETUP_FILE_INCLUDED=1
# prevent double inclusion

NVIM_CGF_DIR=~/.config/nvim
NVIM_SCRIPTS_DIR=$NVIM_CGF_DIR/scripts

source "${NVIM_SCRIPTS_DIR}/setup/setup.sh"
source "${NVIM_SCRIPTS_DIR}/installs/installs.sh"

# setup the computer
setup

# install all dependencies
install_all
