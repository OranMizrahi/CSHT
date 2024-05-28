#!/bin/bash

set -e

# Variables
TERRAFORM_VERSION="1.5.7"
REGION="us-east-1"
CLUSTER_NAME="demo-eks"
EKS_DIR="certified-kubernetes-administrator-course/managed-clusters/eks"

# Function to destroy infrastructure with Terraform
destroy_infrastructure() {
    echo "Destroying infrastructure with Terraform..."
    cd ${EKS_DIR}
    terraform destroy -auto-approve
}

# Function to clean up files and directories
cleanup() {
    echo "Cleaning up files and directories..."
    cd ~
    rm -rf certified-kubernetes-administrator-course
    rm -rf ~/bin/terraform
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    echo "Cleanup completed."
}

# Main function to orchestrate the cleanup
main() {
    destroy_infrastructure
    cleanup
    echo "Uninstallation completed successfully."
}

main
