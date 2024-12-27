!#/bin/bash

K3D_INSTALL_CMD='curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash'
KUBECTL_INSTALL_CMD='curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"'

# color codes
RED="\e[31m"
GREEN="\e[1;32m"
RESET="\e[0m"

install_dependencies(){
    # install kubectl
    output=$(KUBECTL_INSTALL_CMD)
    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed to install kubectl, cannot proceed further..${RESET}"
        exit 1
    fi
    echo -e "${GREEN}Dependencies installed successfully...${RESET}"
}

install(){
    # install k3d
    output=$(K3D_INSTALL_CMD)
    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed to install K3d...quitting${RESET}"
        exit 1
    fi
    echo -e "${GREEN}K3d installation complete...${RESET}"
}

install_dependencies
install