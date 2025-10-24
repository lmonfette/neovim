#!/bin/bash

# prevent double inclusion
if [[ -n "${INSTALLS_WINDOWS_FILE_INCLUDED:-}" ]]; then
    return 0
fi
INSTALLS_WINDOWS_FILE_INCLUDED=1
# prevent double inclusion

windows_install_openvpn_client() {
    echo "'windows_install_openvpn_client'not implemented."
}
