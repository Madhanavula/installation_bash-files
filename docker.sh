
#!/bin/bash

set -e

echo "===================================="
echo " Installing Docker Engine"
echo "===================================="

# Update packages
sudo apt update

# Install prerequisites
sudo apt install -y ca-certificates curl

# Add Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
-o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker official repository
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update package list
sudo apt update

# Install Docker Engine and plugins
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to Docker group
sudo usermod -aG docker "$USER"

# Verify installation
echo "Docker version:"
sudo docker --version

echo "Docker service status:"
sudo systemctl status docker --no-pager

echo "===================================="
echo " Docker installation completed!"
echo "===================================="

echo "IMPORTANT: Log out and reconnect SSH to apply Docker group permissions."
