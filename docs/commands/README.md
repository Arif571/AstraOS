# Commands Reference

---

## astra

The main AstraOS CLI tool. Handles profile switching and system info.

Synopsis:

    astra <command> [options]

---

### astra switch

Switch the active profile mode. Installs the mode package set and
applies its configuration.

    astra switch --mode <modename>

Valid mode names: devmode, shieldmode, desktopmode, labmode

Examples:

    astra switch --mode devmode
    astra switch --mode shieldmode
    astra switch --mode labmode

---

### astra --version

Print the installed AstraOS version.

    astra --version

---

## astra-install

The disk installer. Run this from a live session to install AstraOS
to a physical or virtual disk.

    sudo astra-install

Must be run as root. Fully interactive -- prompts for all required
input and confirms before making any destructive changes.

What it does:

    1. Lists available disks and asks you to select a target
    2. Asks for confirmation before erasing the disk
    3. Asks which profile mode to set as default
    4. Creates your user account (username and password)
    5. Sets the system hostname
    6. Partitions the disk (EFI partition + root partition)
    7. Formats and mounts the partitions
    8. Copies the live system to disk
    9. Writes /etc/fstab with correct UUIDs
    10. Installs and configures GRUB bootloader
    11. Reboots (optional)

---

## Package Management

AstraOS uses APT, the standard Debian package manager.

    # Refresh the package index
    sudo apt update

    # Upgrade all installed packages
    sudo apt upgrade

    # Install a package
    sudo apt install <package>

    # Remove a package (keep config files)
    sudo apt remove <package>

    # Remove a package and its config files
    sudo apt purge <package>

    # Remove packages no longer needed
    sudo apt autoremove

    # Clear the local package cache
    sudo apt clean

    # Search for a package
    apt search <keyword>

    # Show details about a package
    apt show <package>

    # List installed packages
    apt list --installed

Keep the system updated:

    sudo apt update && sudo apt upgrade

---

## System Services

AstraOS uses systemd for service management.

    # Check the status of a service
    sudo systemctl status <service>

    # Start a service
    sudo systemctl start <service>

    # Stop a service
    sudo systemctl stop <service>

    # Restart a service
    sudo systemctl restart <service>

    # Enable a service to start at boot
    sudo systemctl enable <service>

    # Disable a service from starting at boot
    sudo systemctl disable <service>

    # View logs for a service
    journalctl -u <service> -f

Key services in AstraOS:

| Service           | Description                              |
|-------------------|------------------------------------------|
| NetworkManager    | Network connectivity                     |
| sddm              | Login screen (display manager)           |
| ufw               | Firewall (active in ShieldMode)          |
| fail2ban          | Intrusion prevention (ShieldMode)        |
| tor               | Tor anonymity network (ShieldMode)       |
| docker            | Container runtime (DevMode)              |
| clamav-daemon     | Antivirus scanner (ShieldMode)           |

---

## Networking

    # Show all network interfaces and IP addresses
    ip addr

    # Show routing table
    ip route

    # Test connectivity
    ping -c 4 8.8.8.8

    # DNS lookup
    dig example.com
    nslookup example.com

    # Show open ports
    ss -tlnp

    # Firewall management (ShieldMode)
    sudo ufw status
    sudo ufw allow 22/tcp
    sudo ufw deny 23/tcp

---

## User Management

    # Add a new user
    sudo useradd -m -s /bin/bash <username>

    # Set password for a user
    sudo passwd <username>

    # Add user to a group
    sudo usermod -aG sudo <username>

    # List groups a user belongs to
    groups <username>

    # Switch to another user
    su - <username>

---

## File Operations

    # Copy files
    cp source destination
    cp -r sourcedir destdir

    # Move or rename
    mv source destination

    # Delete
    rm filename
    rm -rf directory

    # Create directory
    mkdir -p path/to/dir

    # Check disk usage
    df -h
    du -sh /path/to/dir

    # Find files
    find /path -name "filename"
    find /path -name "*.log" -mtime +7

    # Archive and compress
    tar -czf archive.tar.gz directory/
    tar -xzf archive.tar.gz

    # Check file permissions
    ls -la
    chmod 755 script.sh
    chown user:group file
