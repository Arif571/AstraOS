# Installation Guide

This guide covers everything from downloading the ISO to having a fully
working AstraOS installation on your machine.

---

## Step 1 - Download the ISO

Go to the releases page and grab the latest astraos.iso:

    https://github.com/Arif571/AstraOS/releases

The ISO is a hybrid image. It boots from both USB and optical drives,
and supports both UEFI and Legacy BIOS systems.

---

## Step 2 - Write to USB

You need a USB drive with at least 2 GB of space. This process will
erase everything on the drive.

On Linux or macOS:

    # Find your USB drive first
    lsblk

    # Write the ISO (replace sdX with your actual drive, e.g. sdb)
    sudo dd if=astraos.iso of=/dev/sdX bs=4M status=progress oflag=sync

Do not append a partition number. Write to the whole disk (/dev/sdb,
not /dev/sdb1).

On Windows:

Use Rufus (https://rufus.ie) or Balena Etcher (https://etcher.balena.io).
In Rufus, select the ISO, pick your USB drive, leave everything else at
default, and click Start.

---

## Step 3 - Boot from USB

Restart your machine and enter the boot menu. The key varies by
manufacturer:

| Manufacturer | Boot Menu Key     |
|--------------|-------------------|
| Lenovo       | F12               |
| Dell         | F12               |
| HP           | F9 or Esc         |
| ASUS         | F8 or Esc         |
| Acer         | F12               |
| MSI          | F11               |
| Generic      | F12 or Del        |

Select your USB drive from the list. You will land on the AstraOS
GRUB menu.

---

## Step 4 - Choose a Boot Mode

The GRUB menu gives you five options:

| Option                        | Description                              |
|-------------------------------|------------------------------------------|
| AstraOS Live - DesktopMode    | Default live session with KDE Plasma     |
| AstraOS Live - DevMode        | Live session with dev tools active       |
| AstraOS Live - ShieldMode     | Live session with security tools active  |
| AstraOS Live - LabMode        | Live session with data science tools     |
| Safe Mode                     | Minimal boot, useful for debugging       |

Default live credentials:

    Username: astra
    Password: astra

---

## Step 5 - Install to Disk

Once you are in the live session, open Konsole and run:

    sudo astra-install

The installer will walk you through:

    1. Disk selection   -- lists all available disks with their sizes
    2. Confirmation     -- you must type yes to confirm erasure
    3. Profile selection -- choose which mode to install as default
    4. User account     -- set your username and password
    5. Hostname         -- name your machine (default: astraos)
    6. Installation     -- copies the system and installs GRUB

The whole process typically takes 5 to 15 minutes depending on disk speed.

---

## Installing in a Virtual Machine

AstraOS works in VirtualBox, VMware, and QEMU.

VirtualBox recommended settings:

    Type    : Linux
    Version : Debian (64-bit)
    RAM     : 2048 MB minimum, 4096 recommended
    Disk    : 20 GB dynamically allocated
    Display : 128 MB video memory

Mount astraos.iso as the optical drive, start the VM, and follow the
same steps above.

---

## Partition Layout

The installer creates a GPT partition table with two partitions:

| Partition   | Size       | Filesystem | Mount     |
|-------------|------------|------------|-----------|
| EFI System  | 512 MB     | FAT32      | /boot/efi |
| Root        | Remaining  | ext4       | /         |

---

## After Installation

On first boot you will land on the SDDM login screen. Log in with the
credentials you set during installation.

Switch your active profile at any time:

    astra switch --mode devmode
    astra switch --mode shieldmode
    astra switch --mode desktopmode
    astra switch --mode labmode

Keep the system updated:

    sudo apt update && sudo apt upgrade

---

## Dual Boot with Windows

AstraOS supports dual booting. Before proceeding:

    1. Back up your data
    2. Shrink your Windows partition using Disk Management
    3. Disable Fast Startup in Windows
       (Control Panel > Power Options > Choose what the power buttons do)
    4. Disable Secure Boot in UEFI firmware if needed

During astra-install, select the free space on your disk rather than
the Windows partition. GRUB will detect Windows automatically.
