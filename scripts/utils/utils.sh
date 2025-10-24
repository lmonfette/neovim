#!/bin/bash

# prevent double inclusion
if [[ -n "${UTILS_FILE_INCLUDED:-}" ]]; then
    return 0
fi
UTILS_FILE_INCLUDED=1
# prevent double inclusion

MACOS_OS_NAME="MacOS"
UBUNTU_OS_NAME="Ubuntu"
WINDOWS_OS_NAME="Windows"

get_os() {
    UNAME_OUTPUT="$(uname -s)"

    if [ "${UNAME_OUTPUT}" = "Linux" ]; then
        # detect if we have WSL
        if grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
            echo "$WINDOWS_OS_NAME"
        elif grep -qiE "Ubuntu" /proc/version 2>/dev/null; then
            echo "$UBUNTU_OS_NAME"
        fi
    elif [ "${UNAME_OUTPUT}" = "Darwin" ]; then
        echo "$MACOS_OS_NAME"
    elif [ "${UNAME_OUTPUT}" = "CYGWIN" ]; then
        echo "$WINDOWS_OS_NAME"
    elif [ "${UNAME_OUTPUT}" = "MINGW" ]; then
        echo "$WINDOWS_OS_NAME"
    elif [ "${UNAME_OUTPUT}" = "MSYS" ]; then
        echo "$WINDOWS_OS_NAME"
    else
        echo "Unknown"
    fi
}

# parameter 1: MacOS function
# parameter 2: Linux function
# parameter 3: Windows function
exec_os_specific() {
    MACOS_FUNCTION=$1
    UBUNTU_FUNCTION=$2
    WINDOWS_FUNCTION=$3

    OS=$(get_os)

    if [ "$OS" = "$MACOS_OS_NAME" ]; then
        $MACOS_FUNCTION
    elif [ "$OS" = "$UBUNTU_OS_NAME" ]; then
        $UBUNTU_FUNCTION
    elif [ "$OS" = "$WINDOWS_OS_NAME" ]; then
        $WINDOWS_FUNCTION
    else
        echo "No suitable OS was found. Execution cancelled."
    fi
}
