#!/bin/bash

# prevent double inclusion
if [[ -n "${SETUP_MACOS_FILE_INCLUDED:-}" ]]; then
    return 0
fi
SETUP_MACOS_FILE_INCLUDED=1
# prevent double inclusion

macos_setup() {
    echo "'macos_setup' not implemented."
}
