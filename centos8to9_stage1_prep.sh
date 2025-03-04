#!/bin/bash

set -e  # Exit immediately if a command fails

echo -e "\n\e[1;34m[Stage 1] Updating CentOS 8 Stream and preparing for upgrade...\e[0m\n"

# Update all packages
sudo dnf update -y

echo -e "\n\e[1;33mSystem will need a reboot after this stage.\e[0m"
echo -e "\e[1;32mOnce rebooted, run Stage 2: centos8to9_stage2_upgrade.sh\e[0m\n"

#EOF