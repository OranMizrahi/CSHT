#!/bin/bash

# Update package list
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Install Docker
sudo apt install -y docker.io

# Install Docker Compose
sudo apt install -y docker-compose

# Install Terraform (latest version)
LATEST_TERRAFORM_VERSION=$(curl -s https://checkpoint.hashicorp.com/latest)
wget "https://releases.hashicorp.com/terraform/${LATEST_TERRAFORM_VERSION}/terraform_${LATEST_TERRAFORM_VERSION}_linux_amd64.zip"
unzip "terraform_${LATEST_TERRAFORM_VERSION}_linux_amd64.zip"
chmod +x terraform
sudo mv terraform /usr/local/bin
rm "terraform_${LATEST_TERRAFORM_VERSION}_linux_amd64.zip"

# Install Ansible
sudo apt install -y ansible

# Install VirtualBox
sudo apt install -y virtualbox

# Install Minikube and kubectl
MINIKUBE_VERSION="latest"  # Replace with the desired version or "latest"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
curl -Lo kubectl https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Start Minikube cluster (optional)
# minikube start

echo "All applications have been installed successfully."

# You can uncomment the 'minikube start' line if you want to start a Minikube cluster as well.
