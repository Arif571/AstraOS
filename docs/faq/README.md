# FAQ and Troubleshooting

---

## General Questions

What is AstraOS based on?

    Debian Stable (Bookworm). This means AstraOS inherits Debian's package
    ecosystem, APT package manager, and long-term stability guarantees.
    If something works on Debian, it works on AstraOS.

Is AstraOS free?

    Yes, completely. The source is on GitHub and the ISO is free to
    download, use, and distribute.

Can I run AstraOS alongside Windows?

    Yes. The installer supports dual boot. You will need to shrink your
    Windows partition to free up space before running astra-install.
    See the Installation Guide for the full dual boot process.

Does AstraOS support UEFI?

    Yes. AstraOS boots on both UEFI and Legacy BIOS systems. The
    installer configures the appropriate bootloader automatically.

What desktop environment does AstraOS use?

    KDE Plasma. It was chosen for its balance of visual polish,
    performance, and configurability.

Can I install AstraOS on ARM devices?

    The current release only targets x86_64. ARM support is not
    available yet.

---

## Profile Modes

Can I switch modes after installation?

    Yes, at any time:

    astra switch --mode devmode

    Your home directory and personal files are never affected
    by a mode switch.

What happens when I switch modes?

    The switcher installs the new mode package list via APT and writes
    the active mode to /etc/astraos/active-mode. It does not remove
    packages from the previous mode. Tools accumulate unless you
    manually remove them.

Can I use tools from multiple modes at the same time?

    Yes. There is nothing preventing you from using nmap in a DevMode
    session. The mode system determines what gets installed by default,
    not what you are allowed to run.

How do I check which mode is currently active?

    cat /etc/astraos/active-mode

---

## Troubleshooting

Black screen after boot:

    This usually means the display server failed to start.
    Boot into Safe Mode from the GRUB menu, then:

    # Check what failed
    journalctl -b -p err

    # Reinstall the display manager
    sudo apt install --reinstall sddm

    # Or try starting it manually
    sudo systemctl start sddm

    If you have an NVIDIA GPU, you may need the proprietary driver:

    sudo apt install nvidia-driver
    sudo reboot

No internet connection after boot:

    NetworkManager handles networking. If it is not working:

    # Check its status
    sudo systemctl status NetworkManager

    # Restart it
    sudo systemctl restart NetworkManager

    # Check your interface
    ip addr

    # Try bringing the interface up manually
    sudo ip link set eth0 up
    sudo dhclient eth0

    For Wi-Fi, check that your firmware is installed:

    sudo apt install firmware-linux-nonfree firmware-iwlwifi
    sudo reboot

Cannot log in to the desktop:

    If you are stuck at the SDDM login screen and your credentials
    are not working, boot into Safe Mode and reset your password:

    passwd astra

    If SDDM itself is crashing, check its logs:

    journalctl -u sddm -n 50

astra switch fails partway through:

    If the mode switcher fails during a package installation,
    run the following to recover:

    sudo apt --fix-broken install
    sudo apt autoremove

    Then try switching again.

Disk full after switching modes:

    Mode switching installs new packages without removing the old ones.
    To reclaim space:

    # Remove packages you no longer need
    sudo apt autoremove

    # Clear the package cache
    sudo apt clean

    # Check what is taking up space
    du -sh /* 2>/dev/null | sort -rh | head -20

GRUB does not show Windows in dual boot:

    sudo apt install os-prober
    sudo os-prober
    sudo update-grub

    If os-prober returns nothing, mount your Windows partition first:

    sudo mkdir -p /mnt/windows
    sudo mount /dev/sdXY /mnt/windows
    sudo os-prober
    sudo update-grub

Package installation fails with broken packages:

    sudo apt --fix-broken install
    sudo dpkg --configure -a
    sudo apt update
    sudo apt upgrade

    If a specific package is causing the problem, hold it and continue:

    sudo apt-mark hold <package-name>
    sudo apt upgrade

---

## Contributing

Bug reports, feature requests, and pull requests are welcome at:

    https://github.com/Arif571/AstraOS

When reporting a bug, include:

    - AstraOS version: astra --version
    - Active mode: cat /etc/astraos/active-mode
    - What you did, what you expected, and what actually happened
    - Relevant logs: journalctl -b -p err

---

## Contact

Maintainer : Arif571
GitHub     : https://github.com/Arif571
Issues     : https://github.com/Arif571/AstraOS/issues
