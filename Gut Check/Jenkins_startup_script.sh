#!/bin/bash
#--------------------------------------
#Update all installed packages
#--------------------------------------
sudo yum update -y

#--------------------------------------
#Add the Jenkins repository to yum sources
#--------------------------------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

#--------------------------------------
#Import the Jenkins GPG key to verify packages
#--------------------------------------
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#--------------------------------------
#Upgrade all packages (including those from the new Jenkins repo)
#--------------------------------------
sudo yum upgrade -y

#--------------------------------------
#Install Amazon Corretto 21 (required Java version for Jenkins)
#--------------------------------------
sudo yum install java-21-amazon-corretto -y

#--------------------------------------
#Install Python
#--------------------------------------
sudo yum install -y python3 python3-pip

#--------------------------------------
#Install AWS CLI v2
#--------------------------------------
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install

#--------------------------------------
#Add HashiCorp repo for Terraform
#--------------------------------------
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

#--------------------------------------
#Install Terraform
#--------------------------------------
sudo yum install -y terraform

#--------------------------------------
#Install Jenkins
#--------------------------------------
sudo yum install jenkins -y

#--------------------------------------
#Enable Jenkins to start at boot
#--------------------------------------
sudo systemctl enable jenkins

#--------------------------------------
#Start the Jenkins service
#--------------------------------------
sudo systemctl start jenkins

#---------------------------------------
#Install Git
#---------------------------------------
sudo yum install git -y

#---------------------------------------
#Update Jenkins memory settings
#---------------------------------------
df -h /tmp
mount | grep /tmp
sudo mount -o remount,size=4G /tmp
sudo systemctl restart jenkins