#!/bin/bash

# Update system
sudo dnf update -y

# Install Java 21 (Corretto)
sudo dnf install java-21-amazon-corretto -y

# Verify Java
java -version

# Install fontconfig (required by Jenkins)
sudo dnf install fontconfig -y

# Add Jenkins stable repo
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade packages
sudo dnf upgrade -y

# Install Jenkins
sudo dnf install jenkins -y

# Enable Jenkins at boot and start it
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Confirm it's running
sudo systemctl status jenkins

# Print initial admin password
echo "===== INITIAL ADMIN PASSWORD ====="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword