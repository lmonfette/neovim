#!/bin/bash

# prevent double inclusion
if [[ -n "${INCLUDE_FILE_INCLUDED:-}" ]]; then
    return 0
fi
INCLUDE_FILE_INCLUDED=1
# prevent double inclusion

NVIM_CGF_DIR=~/.config/nvim
NVIM_SCRIPTS_DIR=$NVIM_CGF_DIR/scripts

source "${NVIM_SCRIPTS_DIR}/utils/utils.sh"
source "${NVIM_SCRIPTS_DIR}/installs/installs.sh"
source "${NVIM_SCRIPTS_DIR}/setup/setup.sh"
