#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "### Phase 1: Provisioning Infrastructure with Terraform... ###"
cd ../terraform
terraform init
terraform apply -auto-approve

# Get the output IPs from Terraform
# Note: Parsing JSON output is more robust, but this is simpler for the script
MANAGER_IP=$(terraform output -raw swarm_nodes_public_ips | grep manager | awk -F '"' '{print $4}')
WORKER_A_IP=$(terraform output -raw swarm_nodes_public_ips | grep workerA | awk -F '"' '{print $4}')

echo "Manager IP: $MANAGER_IP"
echo "Worker A IP: $WORKER_A_IP"
cd .. # Back to project root

# --- Normally Ansible runs from a dedicated controller ---
# --- In our 2-node setup, we'll run it from the Manager ---
# --- This script assumes you have SSH access to the Manager ---
# --- and Ansible installed there, or you run it locally via WSL ---

echo "### Phase 2: Configuring Servers with Ansible (Run from Manager or WSL)... ###"

# Create Ansible inventory dynamically
echo "[manager]" > ansible/inventory.ini
echo "$MANAGER_IP" >> ansible/inventory.ini
echo "" >> ansible/inventory.ini
echo "[workers]" >> ansible/inventory.ini
echo "$WORKER_A_IP" >> ansible/inventory.ini
echo "" >> ansible/inventory.ini
echo "[all:vars]" >> ansible/inventory.ini
echo "ansible_user=ubuntu" >> ansible/inventory.ini
# IMPORTANT: Adjust this path if running Ansible from WSL vs. directly on Manager
echo "ansible_ssh_private_key_file=~/.ssh/ubuntupass.pem" >> ansible/inventory.ini
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ansible/inventory.ini

echo "Created ansible/inventory.ini"
cat ansible/inventory.ini

# --- Option A: Run Ansible directly from WSL (if Ansible is installed there) ---
echo "Running Ansible playbooks from local WSL..."
ansible-playbook -i ansible/inventory.ini ansible/install-docker.yml
ansible-playbook -i ansible/inventory.ini ansible/swarm-init.yml # Will re-run but ignore errors

# --- Option B: If this script were running ON the Manager node ---
# echo "Running Ansible playbooks on the Manager node..."
# ansible-playbook -i /home/ubuntu/aws-devops-project/ansible/inventory.ini /home/ubuntu/aws-devops-project/ansible/install-docker.yml
# ansible-playbook -i /home/ubuntu/aws-devops-project/ansible/inventory.ini /home/ubuntu/aws-devops-project/ansible/swarm-init.yml

echo "### Phase 3: Initial Deployment (Handled by CI/CD on first push) ###"
echo "Ansible configuration complete. The CI/CD pipeline (GitHub Actions) will handle application deployment."
echo "Push your code to the ITB735 branch on GitHub to trigger the deployment."

echo "### Bootstrap Complete! ###"