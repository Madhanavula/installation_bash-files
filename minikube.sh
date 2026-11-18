#!/bin/bash

set -e

echo "======================================"
echo " Installing Minikube + Docker + Kubectl"
echo "======================================"

# Update package list
sudo apt update

# Install Minikube
echo "Installing Minikube..."
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install -y docker.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to Docker group
sudo usermod -aG docker "$USER"

# Apply Docker group without logout
newgrp docker <<EOF
echo "Docker version:"
docker --version

echo "Testing Docker:"
docker ps
EOF

# Install kubectl
echo "Installing kubectl..."

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify kubectl
echo "kubectl version:"
kubectl version --client

# Start Minikube
echo "Starting Minikube..."
minikube start

echo "======================================"
echo " Installation completed successfully!"
echo "======================================"

echo "Minikube status:"
minikube status

echo "Kubectl version:"
kubectl version --client

echo "Docker version:"
docker --version
