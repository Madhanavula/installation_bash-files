#!/bin/bash

# Update package repository
sudo apt update

# Install software-properties-common
sudo apt install -y software-properties-common

# Add Ansible PPA
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt install ansible -y

# Verify Ansible installation
ansible --version

echo "Ansible installation completed!"
