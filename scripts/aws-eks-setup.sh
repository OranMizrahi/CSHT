#!/bin/bash

set -e

# Variables
TERRAFORM_VERSION="1.5.7"
REGION="us-east-1"
CLUSTER_NAME="demo-eks"
REPO_URL="https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git"
EKS_DIR="certified-kubernetes-administrator-course/managed-clusters/eks"

# Function to install Terraform
install_terraform() {
    echo "Installing Terraform..."
    curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    mkdir -p ~/bin
    mv terraform ~/bin/
    export PATH=$PATH:~/bin
    echo "Terraform version: $(terraform version)"
}

# Function to clone the repository
clone_repo() {
    echo "Cloning repository..."
    git clone ${REPO_URL}
}

# Function to provision infrastructure with Terraform
provision_infrastructure() {
    echo "Provisioning infrastructure with Terraform..."
    cd ${EKS_DIR}
    terraform init
    terraform apply -auto-approve
}

# Function to configure EKS and join worker nodes
configure_eks() {
    echo "Configuring EKS cluster..."
    # Update kubeconfig
    aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}

    # Get the NodeInstanceRole ARN from Terraform output
    NODE_INSTANCE_ROLE=$(terraform output -raw NodeInstanceRole)

    # Download the aws-auth ConfigMap
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/aws-auth-cm.yaml

    # Update the ConfigMap with the NodeInstanceRole ARN
    sed -i "s|<ARN of instance role (not instance profile)>|${NODE_INSTANCE_ROLE}|g" aws-auth-cm.yaml

    # Apply the ConfigMap to join the nodes
    kubectl apply -f aws-auth-cm.yaml

    # Wait for nodes to join
    echo "Waiting for nodes to join..."
    sleep 180

    # Check node status
    kubectl get nodes -o wide
}

# Main function to orchestrate the setup
main() {
    install_terraform
    clone_repo
    provision_infrastructure
    configure_eks
    echo "EKS Cluster setup completed successfully."
}

main
