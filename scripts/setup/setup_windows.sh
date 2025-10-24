#!/bin/bash

# prevent double inclusion
if [[ -n "${SETUP_WINDOWS_FILE_INCLUDED:-}" ]]; then
    return 0
fi
SETUP_WINDOWS_FILE_INCLUDED=1
# prevent double inclusion

windows_setup() {
    echo "'windows_setup' not implemented."
}
