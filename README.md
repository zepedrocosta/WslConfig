# WSL2 Ubuntu Setup & Configuration Tool

A comprehensive automation script for setting up WSL2 Ubuntu with development tools, databases, and services. This tool provides an interactive interface to install and configure your development environment with minimal effort.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [WSL Configuration](#wsl-configuration)
- [Initial Ubuntu Setup](#initial-ubuntu-setup)
- [Installation](#installation)
- [Available Commands](#available-commands)
  - [Installing Software](#installing-software)
  - [Installing Services](#installing-services)
  - [Configuring Software](#configuring-software)
  - [Managing Services](#managing-services)
  - [LaTeX Dependencies](#latex-dependencies)
- [Available Aliases](#available-aliases)
- [Additional Documentation](#additional-documentation)
- [Important Notes](#important-notes)

## Overview

This repository provides automation scripts to:
- Install development tools (Java, Node.js, Python, C/C++, etc.)
- Set up database systems (MySQL, PostgreSQL, MongoDB, Redis, etc.)
- Configure services (Syncthing, GitHub CLI)
- Manage database services (start/stop)
- Configure development environments

## Quick Start

The simplest way to get started:

```bash
# 1. Clone this repository
git clone https://github.com/zepedrocosta/WslConfig.git
cd WslConfig

# 2. Make the installation script executable and run it
chmod u+x init.sh
./init.sh

# 3. Reboot your WSL distro
# In Windows PowerShell or Command Prompt:
wsl -t <distro-name>

# 4. Start using the script with the 'system' alias
system install
```

## WSL Configuration

For optimal performance, configure WSL resource limits. Create or edit `%UserProfile%\.wslconfig` in Windows:

```ini
[wsl2]
memory=20GB
processors=12
swap=50GB
swapfile=C:\\Users\\{YourUsername}\\wsl-swap.vhdx
```

**Note:** Adjust values based on your system resources.

## Initial Ubuntu Setup

Before installing the script, set proper permissions for your user directory:

```bash
cd /home
sudo chown -R {username} ./{username}
```

Replace `{username}` with your actual username.

## Installation

### Automated Installation (Recommended)

The `init.sh` script handles installation automatically:

```bash
chmod u+x init.sh
./init.sh
```

This script will:
- Copy scripts to `~/.script/`
- Make them executable
- Fix line endings
- Create the `system` alias in your shell configuration
- Support bash, zsh, and fish shells

### Manual Installation (Alternative)

If you prefer manual installation:

1. Copy the script files to a permanent location (e.g., `~/.script/`):
   ```bash
   mkdir -p ~/.script
   cp script.sh ~/.script/
   ```

2. Make the script executable:
   ```bash
   chmod u+x ~/.script/script.sh
   ```

3. Fix line endings (if needed):
   ```bash
   sed -i 's/\r$//' ~/.script/script.sh
   ```

4. Add alias to your shell configuration (`~/.bashrc`, `~/.zshrc`, etc.):
   ```bash
   echo "alias system='$HOME/.script/script.sh'" >> ~/.bashrc
   ```

5. Reload your shell configuration:
   ```bash
   source ~/.bashrc
   ```

### Reboot WSL

After installation, reboot your WSL distro from Windows:

```powershell
# List distros to find your distro name
wsl -l -v

# Terminate your distro (reboot)
wsl -t <distro-name>
```

**Important:** Close all WSL-related applications (terminal, VSCode, File Explorer) before rebooting.

## Available Commands

All commands use the `system` alias. The general syntax is:

```bash
system <command>
```

### Installing Software

Install development tools and programming languages:

```bash
system install
```

**Available Software:**
- Java 17 (JDK)
- Java 17 Sources
- Maven
- Node Version Manager (nvm)
- pnpm
- GCC & GDB (C/C++ development)
- Make
- uv (Python package manager - see [uv Cheat Sheet](uv_cheat_sheet.md))
- TeX Live
- shfmt (shell script formatter)

**Note:** Some software (Maven, nvm/npm) requires a WSL reboot after installation.

### Installing Services

Install databases and services:

```bash
system install-services
```

**Available Services:**
- **Databases:** MySQL, PostgreSQL, SQLite, Apache Cassandra, MongoDB, Redis, Neo4j
- **Tools:** Syncthing (file synchronization), GitHub CLI

**Related Documentation:**
- [Syncthing Setup Guide](syncthing_setup.md) - Complete setup for WSL→Windows synchronization
- [Syncthing Backup](syncthing_backup/README.md) - Automatic backup configuration

### Configuring Software

Configure installed software:

```bash
system config
```

**Configuration Options:**
1. **NVM** - Install the latest stable npm version
2. **MySQL** - Run secure installation and set up root password
3. **PostgreSQL** - Set up postgres user password
4. **MariaDB** - Configure database access
5. **Syncthing Auto-Export** - Set up automatic backups on WSL startup

**MySQL Configuration Guide:**
After selecting MySQL configuration, you'll be guided through:
- VALIDATE PASSWORD setup (recommended: **no** for local development)
- Root password creation
- Remove Anonymous Users (recommended: **yes**)
- Disallow remote login (recommended: **no** for WSL)
- Remove test database (optional)
- Reload privilege tables (recommended: **yes**)
- Set root authentication string

### Managing Services

**Start all installed services:**
```bash
system start
```

**Stop all running services:**
```bash
system stop
```

These commands will start/stop all installed database services:
- MySQL
- PostgreSQL
- MongoDB
- Apache Cassandra
- Redis
- Neo4j
- Syncthing

### LaTeX Dependencies

If you installed TeX Live, install additional LaTeX packages:

```bash
system latex-deps
```

**Available Options:**
- Base version (~216MB)
- Extra version (~452MB)
- Full version (~5358MB)

## Available Aliases

### System Alias

The main alias created by the installation script:

```bash
system    # Main script alias (points to ~/.script/script.sh)
```

### uv Aliases (Optional)

If you installed `uv` and chose to add aliases, these are available:

```bash
uvp       # uv run python - Run Python directly
uvr       # uv run - Run a command in venv
uva       # uv add - Add dependency
uvrm      # uv remove - Remove dependency
uvs       # uv sync - Install/update dependencies
uvpl      # uv pip list - List packages
uvl       # uv lock - Generate lockfile
uvpy      # uv python list - List Python versions
```

For detailed uv usage, see the [uv Cheat Sheet](uv_cheat_sheet.md).

## Additional Documentation

This repository includes several guides for specific topics:

- **[uv Cheat Sheet](uv_cheat_sheet.md)** - Quick reference guide for using the `uv` Python package manager, including installation, project management, virtual environments, and useful aliases.

- **[Syncthing Setup](syncthing_setup.md)** - Comprehensive guide for setting up Syncthing to synchronize code projects from WSL to Windows. Includes configuration for optimal performance with many small files.

- **[Syncthing Backup](syncthing_backup/README.md)** - Automatic backup system for Syncthing configuration on WSL startup. Ensures your Syncthing setup can be easily restored or migrated.

## Important Notes

### WSL Reboot Procedure

Some installations require a WSL reboot. **Always follow this procedure:**

1. Close all WSL-related applications:
   - Terminal windows
   - VSCode
   - Windows Explorer (if browsing WSL files)

2. Open Windows PowerShell or Command Prompt

3. Terminate the distro:
   ```powershell
   wsl -t <distro-name>
   ```

4. Restart your WSL environment

### Dialog UI Issues

The interactive selection dialogs may have display issues in full-screen mode. If the UI appears corrupted, **resize the window** to fix it.

### Software Requiring Reboot

These packages require a WSL reboot after installation:
- Maven
- Node Version Manager (nvm/npm)

### Service Configuration

Some services need additional configuration after installation. The script will warn you with:
> "This needs further configuration. Check the tutorial README."

Refer to the [Configuring Software](#configuring-software) section for details.

---

**Authors:**
- [@zepedrocosta](https://github.com/zepedrocosta)
- [@GoncaloAC](https://github.com/GoncaloAC)
