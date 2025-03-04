#!/bin/bash

set -e  # Exit immediately if a command fails

echo -e "\n\e[1;34m[Stage 3] Performing post-upgrade cleanup and verification...\e[0m\n"

# Verify CentOS version
echo -e "\n\e[1;33mVerifying CentOS Stream release version...\e[0m"
cat /etc/centos-release

# Check the current kernel version
echo -e "\n\e[1;33mChecking kernel version...\e[0m"
uname -r

# Set latest kernel as default
echo -e "\n\e[1;33mSetting latest kernel as default...\e[0m"
latest_kernel=$(sudo grubby --info=ALL | grep -E '^kernel=' | head -n 1 | cut -d= -f2)
sudo grubby --set-default="$latest_kernel"

# Regenerate GRUB configuration
echo -e "\n\e[1;33mRegenerating GRUB configuration...\e[0m"
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Remove old kernels
echo -e "\n\e[1;33mRemoving old kernels...\e[0m"
sudo dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)

echo -e "\n\e[1;32mUpgrade to CentOS 9 Stream completed successfully!\e[0m\n"

#EOF