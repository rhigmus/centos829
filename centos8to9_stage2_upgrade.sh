#!/bin/bash

set -e  # Exit immediately if a command fails

echo -e "\n\e[1;34m[Stage 2] Performing the CentOS 9 Stream upgrade...\e[0m\n"

# Disable conflicting modules
echo -e "\n\e[1;33mDisabling Python36 and Virt modules...\e[0m"
sudo dnf module disable python36 virt -y

# Install CentOS 9 Stream repositories
echo -e "\n\e[1;33mInstalling CentOS 9 Stream repositories...\e[0m"
sudo dnf install -y \
    https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/centos-stream-release-9.0-22.el9.noarch.rpm \
    https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-9.0-22.el9.noarch.rpm \
    https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-9.0-22.el9.noarch.rpm

# Upgrade system to CentOS 9
echo -e "\n\e[1;33mSyncing packages to CentOS 9 Stream...\e[0m"
sudo dnf --releasever=9 --allowerasing --setopt=deltarpm=false distro-sync -y

# Rebuild RPM database
echo -e "\n\e[1;33mRebuilding the RPM database...\e[0m"
sudo rpm --rebuilddb

# Kernel check
echo -e "\n\e[1;33mChecking if kernel update is required...\e[0m"
if [[ $(uname -r | cut -d. -f1) -lt 5 ]] || [[ $(uname -r | cut -d. -f2) -lt 14 ]]; then
    echo -e "\e[1;31mKernel is outdated. Installing the latest kernel...\e[0m"
    sudo dnf install kernel -y
fi

echo -e "\n\e[1;33mSystem will need a reboot after this stage.\e[0m"
echo -e "\e[1;32mOnce rebooted, run Stage 3: centos8to9_stage3_cleanup.sh\e[0m\n"

#EOF