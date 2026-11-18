#!/bin/bash

# Update package repository
sudo apt update

# Install Java 21 (Required for Jenkins)
sudo apt install openjdk-21-jdk -y

# Verify Java installation
java -version

# Install Maven
sudo apt install maven -y

# Add Jenkins GPG key
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package repository
sudo apt update

# Install Jenkins
sudo apt install jenkins -y

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check Jenkins status
sudo systemctl status jenkins --no-pager

echo "Java, Maven and Jenkins installation completed!"
