#!/bin/bash

CONFIG_FILE_PATH=$CONFIG_FILE_PATH
INVENTORY_FILE_PATH=$INVENTORY_FILE_PATH
PLAYBOOK_DIR=$PLAYBOOK_DIR
HOST_GROUP=$HOST_GROUP

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Ansible is not installed. Installing..."
    
    # Install Ansible using the package manager (for Debian-based systems)
    sudo apt update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y ansible 
    echo "Ansible has been installed."
else
    echo "Ansible is already installed."
fi

# Use find to get only playbook files and sort them
for PLAYBOOK in $(find "$PLAYBOOK_DIR" -type f -name "*.yaml" | sort); do
    ansible-playbook -i "$INVENTORY_FILE_PATH" -e "ANSIBLE_CONFIG=$CONFIG_FILE_PATH" -e "host_group=$HOST_GROUP" "$PLAYBOOK"
done