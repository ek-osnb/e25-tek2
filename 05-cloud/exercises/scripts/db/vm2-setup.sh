#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# User to be created (change as needed)
USERNAME="appuser"

# Update and install packages
apt update
apt install net-tools -y
# Create a new user
useradd -m -s /bin/bash $USERNAME
# Add user to sudo group and allow passwordless sudo
usermod -aG sudo $USERNAME
echo "$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup SSH directory and authorized_keys with proper permissions
mkdir -p /home/$USERNAME/.ssh
touch /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# Print a completion message
echo "Setup completed. User '$USERNAME' created with sudo privileges."
echo "Add SSH keys to /home/$USERNAME/.ssh/authorized_keys to enable SSH access."

# Run setup docker script
./docker-setup.yml