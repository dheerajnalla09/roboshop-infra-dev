#!/bin/bash

set -e   # ✅ stop on error

component=$1
environment=$2

echo "Starting bootstrap for $component in $environment"

# Install ansible only if not present
if ! command -v ansible &> /dev/null
then
    echo "Installing Ansible..."
    dnf install ansible -y
fi

cd /home/ec2-user

# Clone only if repo not exists
if [ ! -d "ansible-roboshop-roles-tf" ]; then
    git clone https://github.com/dheerajnalla09/ansible-roboshop-roles-tf.git
fi

cd ansible-roboshop-roles-tf
git pull

# Run playbook
ansible-playbook -e component=$component -e env=$environment roboshop.yaml

echo "Bootstrap completed for $component"