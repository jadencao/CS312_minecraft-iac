#!/bin/bash
# ----------------------------------------------------------------------------
# deploy.sh — One-command deployment of the entire Minecraft server.
#
# Runs the full pipeline with zero AWS Console interaction:
#   1. Terraform provisions all AWS infrastructure (VPC, SG, key, EC2)
#   2. Wait for the new instance's SSH port to come up
#   3. Ansible configures the instance into a running Minecraft server
#
# Requirements: terraform, ansible, aws cli configured (~/.aws/credentials),
# and nc (netcat, preinstalled).
# ----------------------------------------------------------------------------

# Exit immediately if ANY command fails — never continue a half-broken deploy.
set -e

# Always operate from the repository root, no matter where the script was
# called from. $0 is this script's path; dirname gets its folder (scripts/);
# .. goes up to the repo root.
cd "$(dirname "$0")/.."

echo "=== 1/3 AWS infrastructure (Terraform) ==="
# -chdir tells terraform which folder holds the .tf files.
# -input=false  -> never prompt interactively, this is an automated pipeline
# -auto-approve -> skip the "Enter a value: yes" confirmation
terraform -chdir=terraform init -input=false
terraform -chdir=terraform apply -auto-approve

# Read the new instance's public IP from Terraform's outputs.
# -raw prints just the bare value, with no quotes or formatting.
PUBLIC_IP=$(terraform -chdir=terraform output -raw instance_public_ip)
echo "Instance public IP: $PUBLIC_IP"

echo "=== 2/3 Waiting for SSH to come up ==="
# A  created instance takes ~30-60s before SSH answers. nc -z tries a
# bare TCP connection to port 22 (-w 5 = 5s timeout). Loop until it succeeds.
until nc -z -w 5 "$PUBLIC_IP" 22; do
  echo "  ...not up yet, retrying in 5s"
  sleep 5
done

sleep 10

echo "=== 3/3 Configuring the server (Ansible) ==="
# Run from ansible/ so ansible.cfg (and the Terraform-generated inventory.ini)

cd ansible
ansible-playbook minecraft.yml

echo ""
echo "=== Deployment complete ==="
echo "Verify the server from your machine with:"
echo "  nmap -sV -Pn -p T:25565 $PUBLIC_IP"