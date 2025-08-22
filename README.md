# macOS-tweaks

A collection of scripts and configurations to enhance, secure, and optimize your macOS experience.

## Overview

This repository contains various tools and scripts for macOS system configuration, security hardening, and maintenance. The tools are organized into separate directories, each focusing on a specific aspect of system management.

## macOS Tweaks Manager

We've included a centralized management script (`macos-tweaks-manager.sh`) that provides an easy-to-use interface for all the tools in this repository.

### Features

- 🛡️ **Security Hardening**: Apply security configurations from Blackhat MacOS Config
- ⚙️ **System Configuration**: Customize system settings and preferences
- 📦 **Dependency Management**: Install required system dependencies
- 🧹 **Maintenance Tools**: Run system cleanup and optimization scripts
- 🔄 **Update System**: Keep all tools and packages up-to-date

### Prerequisites

- macOS 10.15 (Catalina) or later
- Administrator privileges (for system-level changes)
- Internet connection (for downloading dependencies)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/macOS-tweaks.git
   cd macOS-tweaks
   ```

2. Make the manager script executable:
   ```bash
   chmod +x macos-tweaks-manager.sh
   ```

### Usage

Run the manager with root privileges:

```bash
sudo ./macos-tweaks-manager.sh
```

You'll see a menu with the following options:

1. **Security Hardening**: Apply security configurations
2. **System Configuration**: Customize system settings
3. **Install Dependencies**: Install required system packages
4. **Run Maintenance**: Execute cleanup and optimization scripts
5. **Update Tools**: Update all tools and dependencies
6. **Exit**: Quit the manager

## Available Tools

### 1. Blackhat-MacOS-Config
Security-focused configuration for privacy-conscious users.

### 2. MacForensics
Tools for macOS forensic analysis and system inspection.

### 3. MacOS-Config
Personal system configuration scripts and preferences.

### 4. MacOS-Maid
System maintenance and cleanup utilities.

### 5. MacOS-Privileges
Privilege management and access control tools.

### 6. MacOS-Security-Baseline
Security hardening scripts and configurations.

### 7. nudge
macOS update enforcement tool.

### 8. osx-optimizer
System optimization scripts.

### 9. randomMAC
MAC address randomization tool for enhanced privacy.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

These scripts are provided as-is, without any warranties. Use them at your own risk. Always back up your system before making changes.
