#!/bin/bash

# Linux installers
K3D_INSTALL_CMD_LINUX='curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash'
KUBECTL_INSTALL_CMD_LINUX='curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"'
AWS_INSTALL_CMD_LINUX='curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"; sudo installer -pkg AWSCLIV2.pkg -target /'
AZURE_INSTALL_CMD_LINUX='brew install azure-cli'
GCLOUD_INSTALL_CMD_MAC='./google-cloud-sdk/install.sh'
KUBECTX_INSTALL_CMD_MAC='sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens'


# MAC installers
K3D_INSTALL_CMD_MAC='curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash'
KUBECTL_INSTALL_CMD_MAC='curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"'
AWS_INSTALL_CMD_MAC='curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"; sudo installer -pkg AWSCLIV2.pkg -target /'
AZURE_INSTALL_CMD_MAC='brew install azure-cli'
GCLOUD_INSTALL_CMD_MAC='./google-cloud-sdk/install.sh'
KUBECTX_INSTALL_CMD_MAC='sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens'

# color codes
# RED="\e[31m"
# GREEN="\e[32m"
# RESET="\e[0m"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

OS_TYPE=$(uname)
if [ "$OS_TYPE" == "Darwin" ]; then
    OS_TYPE="MAC"
elif [ "$OS_TYPE" == "Linux" ]; then
    OS_TYPE="LINUX"
fi

install_dependencies(){
    # install kubectl
    INSTALL_CMD="$KUBECTL_INSTALL_CMD_$OS_TYPE"
    echo -e "${YELLOW} Installing kubectl latest version ...${RESET}"
    eval ${!INSTALL_CMD}

    if [[ $? -ne 0 && -f "kubectl" ]]; then

        echo -e "${RED} Failed to install kubectl, cannot proceed further..${RESET}"
        #exit 1
    fi
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
    kubectl version --client
    echo -e "${GREEN}Kubectl installed successfully...${RESET}"

    # kubectx
    echo -e "${YELLOW} Installing kubectx/kubens latest version ...${RESET}"
    eval "$KUBECTX_INSTALL_CMD_MAC"

    if [ ! -f "kubectx" ]; then
        echo -e "${RED} Failed to install kubectx/kubens ...${RESET}"
    else
        echo -e "${GREEN} Kubectx/kubens installed successfully..${RESET}"

    fi

}

deploy_cluster(){
    # install k3d

    INSTALL_CMD="$K3D_INSTALL_CMD_$OS_TYPE"
    eval ${!INSTALL_CMD}

    #sudo mv k3d /usr/local/bin/k3d
    eval "k3d --version"
    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed to install K3d...quitting${RESET}"
        exit 1
    fi
    echo -e "$GREEN K3d installation complete...$RESET"
}

install_clis(){
    # aws cli
    INSTALL_CMD="$AWS_INSTALL_CMD_$OS_TYPE"
    eval ${!INSTALL_CMD}

    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed to install aws cli..exiting ${RESET}"
    fi

    INSTALL_CMD="$AZURE_INSTALL_CMD_$OS_TYPE"
    eval ${!INSTALL_CMD}

    if [ $? -ne 0 ]; then
        echo -e "${RED} Failed to install azure cli..exting ${RESET}"
    fi

    INSTALL_CMD="$GCLOUD_INSTALL_CMD_$OS_TYPE"
    eval ${!INSTALL_CMD}

    echo "================================================="
    output=$(aws --version)
    echo -e "${YELLOW} AWS CLI Version: ${output} ${RESET}"
    output=$(az version)
    echo -e "${YELLOW} AZURE CLI Version: ${output} ${RESET}"
    output=$(gcloud version)
    echo -e "${YELLOW} GCLOUD CLI Version: ${output} ${RESET}"
    echo "================================================="
}

install_dependencies
deploy_cluster
install_clis