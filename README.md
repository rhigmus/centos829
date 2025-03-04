# centos829
# Upgrade CentOS 8 Stream to CentOS 9 Stream

## Overview
This repository contains a set of Bash scripts to facilitate the upgrade of **CentOS 8 Stream** to **CentOS 9 Stream** in a structured and controlled manner. Since an in-place upgrade is not officially supported, this method is designed to minimize risk by breaking the process into three distinct stages, ensuring stability at each step.

## **Disclaimer**
:warning: **This upgrade process is NOT officially supported by CentOS.** While these scripts aim to make the transition smoother, **it is highly recommended to test in a non-production environment first and ensure full backups are taken before proceeding.**

## **Upgrade Approach**
The upgrade process is divided into three **stages**, each executed separately, allowing manual verification and reboots between steps:

### **Stage 1: Preparation**
- Updates all CentOS 8 Stream packages.
- Disables incompatible modules.
- Instructs the user to reboot the system.

### **Stage 2: Upgrade Execution**
- Installs the necessary CentOS 9 Stream repositories.
- Synchronizes all installed packages to CentOS 9 Stream.
- Rebuilds the RPM database.
- Checks and installs the latest kernel if needed.
- Instructs the user to reboot the system.

### **Stage 3: Post-Upgrade Cleanup**
- Verifies that CentOS 9 Stream is installed.
- Ensures the latest kernel is set as the default.
- Regenerates GRUB configuration.
- Removes outdated kernels.

## **Usage Instructions**

### **1. Clone the Repository**
```bash
git clone <your-github-repo-url>
cd <repository-name>
```

### **2. Run Stage 1: Preparation**
```bash
chmod +x centos8to9_stage1_prep.sh
sudo ./centos8to9_stage1_prep.sh
```
- **After completion, reboot the system manually**:
  ```bash
  sudo reboot
  ```

### **3. Run Stage 2: Upgrade Execution**
```bash
chmod +x centos8to9_stage2_upgrade.sh
sudo ./centos8to9_stage2_upgrade.sh
```
- **After completion, reboot the system manually**:
  ```bash
  sudo reboot
  ```

### **4. Run Stage 3: Post-Upgrade Cleanup**
```bash
chmod +x centos8to9_stage3_cleanup.sh
sudo ./centos8to9_stage3_cleanup.sh
```

## **Post-Upgrade Verification**
After completing all three stages, confirm the upgrade was successful:
```bash
cat /etc/centos-release
```
It should output something like:
```
CentOS Stream release 9
```
Check the kernel version:
```bash
uname -r
```
Ensure all services are functioning as expected and address any missing dependencies that may arise due to the upgrade.

## **Troubleshooting**
- **Missing or broken dependencies?**
  ```bash
  sudo dnf distro-sync -y
  ```
- **Old packages causing issues?**
  ```bash
  sudo dnf autoremove -y
  ```
- **Network issues preventing repository installation?**
  Ensure you have a working internet connection and can reach the CentOS mirrors.

## **License**
This project is provided under the **MIT License**. Use at your own risk, and contributions are welcome!

