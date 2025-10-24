#!/bin/bash

# prevent double inclusion
if [[ -n "${INSTALLS_UBUNTU_FILE_INCLUDED:-}" ]]; then
    return 0
fi
INSTALLS_UBUNTU_FILE_INCLUDED=1
# prevent double inclusion

ubuntu_install_openvpn_client() {
    # install required tools for installation
    sudo apt install -y apt-transport-https curl

    # make sure the directory to store the apt repository exists
    mkdir -p /etc/apt/keyrings
    # download the openvpn apt repository
    sudo curl -sSfL https://packages.openvpn.net/packages-repo.gpg | sudo tee /etc/apt/keyrings/openvpn.asc

    # determine the distribution to use
    DISTRIBUTION=$(lsb_release -a | grep Codename | cut --field 2)

    echo "Installing OpenVPN for ubuntu $DISTRIBUTION distribution."

    sudo echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian $DISTRIBUTION main" | sudo tee -a /etc/apt/sources.list.d/openvpn3.list

    sudo apt update -y

    sudo apt install -y openvpn3
}
