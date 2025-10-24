#!/bin/bash

# prevent double inclusion
if [[ -n "${INSTALLS_MACOS_FILE_INCLUDED:-}" ]]; then
    return 0
fi
INSTALLS_MACOS_FILE_INCLUDED=1
# prevent double inclusion

macos_install_openvpn_client() {
    echo "'macos_install_openvpn_client'not implemented."
}
