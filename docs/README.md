# AstraOS Documentation

Version: 1.0.0 Nova
Base: Debian Stable (Bookworm)
Repo: https://github.com/Arif571/AstraOS

---

AstraOS is a Debian-based Linux distribution built around a multi-profile
architecture. Instead of shipping a generic OS and leaving users to configure
everything themselves, AstraOS comes with four ready-to-use environment
profiles, each tuned for a specific workflow. One installation, four
personalities.

---

## Table of Contents

- Installation Guide    -> docs/installation/README.md
- Profile Modes         -> docs/modes/README.md
- Commands Reference    -> docs/commands/README.md
- FAQ and Troubleshooting -> docs/faq/README.md

---

## System Requirements

| Component    | Minimum        | Recommended       |
|--------------|----------------|-------------------|
| Architecture | x86_64         | x86_64            |
| RAM          | 2 GB           | 4 GB or more      |
| Storage      | 20 GB          | 50 GB or more     |
| CPU          | Dual-core 64bit| Quad-core or better|
| Boot         | UEFI or Legacy | UEFI              |

---

## What Makes AstraOS Different

Most distros ship one environment and expect users to adapt. AstraOS
flips that -- the OS adapts to what you need to do. Whether you are
compiling code, running a penetration test, doing data analysis, or
just browsing the web, you switch profiles and the system is already
configured for that context.

The profile switcher installs the relevant toolset and applies the
appropriate system configuration automatically.

    astra switch --mode devmode

---

## Project Structure

    AstraOS/
    |-- build/
    |   `-- build.sh              # Main ISO build script
    |-- configs/                  # System configuration files
    |-- profiles/
    |   |-- devmode/              # Developer profile packages
    |   |-- shieldmode/           # Security profile packages
    |   |-- desktopmode/          # Desktop profile packages
    |   `-- labmode/              # Data science profile packages
    |-- branding/
    |   |-- logo/                 # SVG logo assets
    |   |-- wallpaper/            # Default wallpaper
    |   |-- sddm-theme/           # Login screen theme
    |   |-- grub-theme/           # Boot menu theme
    |   `-- motd/                 # Terminal welcome message
    |-- scripts/
    |   |-- astra                 # Profile switcher CLI
    |   `-- astra-install         # Disk installer
    |-- docs/                     # This documentation
    `-- .github/
        `-- workflows/
            |-- build-iso.yml     # CI build on every push
            `-- release.yml       # Release builder on git tag

---

## Build System

AstraOS ISO is built automatically via GitHub Actions using debootstrap
to bootstrap a minimal Debian Bookworm system, then layering KDE Plasma,
profile tools, and custom branding on top.

Every push to main triggers a test build.
Every git tag triggers a full release build with the ISO published to
GitHub Releases.

To trigger a release:

    git tag -a v1.x.x -m "Release message"
    git push origin v1.x.x
