#!/bin/bash

# Get the master and worker IPs from Terraform output, stripping quotes
master_ips=$(terraform output -json master_ips | jq -r '.[] | @sh' | tr -d "'")
worker_ips=$(terraform output -json worker_ips | jq -r '.[] | @sh' | tr -d "'")

# Check if any IPs were retrieved
if [[ -z "$master_ips" ]]; then
    echo "No master IPs found!"
    exit 1
fi

if [[ -z "$worker_ips" ]]; then
    echo "No worker IPs found!"
    exit 1
fi

# Set permissions for the SSH key
chmod 600 ~/.ssh/aws_key

# Create an Ansible inventory file
inventory_file="ansible/inventory"
echo "[masters]" > "$inventory_file"
for ip in $master_ips; do
    echo "master ansible_host=$ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/aws_key" >> "$inventory_file"
done

echo "[workers]" >> "$inventory_file"
index=1  # Start the index at 1
for ip in $worker_ips; do
    echo "worker-$index ansible_host=$ip ansible_user=root ansible_ssh_private_key_file=~/.ssh/aws_key" >> "$inventory_file"
    index=$((index + 1))  # Increment the index
done


echo "Inventory file '$inventory_file' created with the following entries:"
cat "$inventory_file"
