#!/bin/bash

# Update package repository
sudo apt update -y

# Install Java 21
sudo apt install openjdk-21-jdk -y

# Install Maven
sudo apt install maven -y

echo "Java and Maven installation completed!"
