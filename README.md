<div align="center">

# ⭐ AstraOS

### *As high as stars, illuminating all users*

[

![Release](https://img.shields.io/github/v/release/Arif571/AstraOS?color=00d4ff&label=Latest%20Release&style=for-the-badge)

](https://github.com/Arif571/AstraOS/releases)
[

![Build](https://img.shields.io/github/actions/workflow/status/Arif571/AstraOS/build-iso.yml?style=for-the-badge&label=Build)

](https://github.com/Arif571/AstraOS/actions)
[

![License](https://img.shields.io/badge/License-GPL%20v3-blue?style=for-the-badge)

](LICENSE)
[

![Base](https://img.shields.io/badge/Base-Debian%20Bookworm-red?style=for-the-badge)

](https://www.debian.org)

**[Download](https://github.com/Arif571/AstraOS/releases) · [Documentation](docs/README.md) · [Report Bug](https://github.com/Arif571/AstraOS/issues)**

</div>

---

AstraOS is a Debian Stable-based Linux distribution built around a
multi-profile architecture. One installation ships four distinct
environments, each pre-configured for a specific type of work.
Switch between them with a single command.

---

## Profiles

| Mode | Target | Core Tools |
|------|--------|------------|
| DevMode | Developers | Python, Node.js, Go, Rust, GCC, Docker, Git |
| ShieldMode | Security researchers | Nmap, Tor, OpenVPN, UFW, Fail2ban, ClamAV |
| DesktopMode | General users | KDE Plasma, Firefox ESR, Dolphin, Kate |
| LabMode | Data scientists | NumPy, Pandas, Matplotlib, Scikit-learn |

---

## Quick Start

Download the ISO from the releases page and write it to USB:

    sudo dd if=astraos.iso of=/dev/sdX bs=4M status=progress oflag=sync

Boot from USB. Default live credentials: astra / astra

Install to disk from the live session:

    sudo astra-install

Switch profile at any time:

    astra switch --mode devmode
    astra switch --mode shieldmode
    astra switch --mode desktopmode
    astra switch --mode labmode

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Architecture | x86_64 | x86_64 |
| RAM | 2 GB | 4 GB |
| Storage | 20 GB | 50 GB |
| Boot | UEFI or Legacy | UEFI |

---

## Built With

- Base: Debian Stable (Bookworm)
- Kernel: Linux 6.1 LTS
- Desktop: KDE Plasma
- Init: systemd
- Build: debootstrap + GitHub Actions
- Installer: Custom astra-install script

---

## Documentation

- [Installation Guide](docs/installation/README.md)
- [Profile Modes](docs/modes/README.md)
- [Commands Reference](docs/commands/README.md)
- [FAQ and Troubleshooting](docs/faq/README.md)

---

## Build It Yourself

    git clone https://github.com/Arif571/AstraOS
    cd AstraOS
    sudo bash build/build.sh

The ISO will be written to output/astraos.iso

---

## License

GPL v3. Built by Arif571.
