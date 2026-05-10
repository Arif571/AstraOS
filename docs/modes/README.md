# Profile Modes

AstraOS ships with four profile modes. Each mode is a curated environment
for a specific type of work. You can switch between them at any time without
reinstalling -- the switcher handles package installation and system
configuration automatically.

    astra switch --mode <modename>

---

## DevMode

For: Software developers, system programmers, and anyone who writes code
for a living or as a serious hobby.

DevMode gives you a complete build environment out of the box. Languages,
compilers, editors, version control, containers -- everything is installed
and ready. No hunting down dependencies or configuring toolchains manually.

Included Tools:

| Category            | Tools                                    |
|---------------------|------------------------------------------|
| Languages           | Python 3, Node.js, npm, Go, Rust, GCC   |
| Build Systems       | Make, CMake, Build-essential             |
| Editors             | Neovim, Kate                             |
| Version Control     | Git                                      |
| Terminal Multiplexer| Tmux                                     |
| Shell               | Zsh                                      |
| Debugger            | GDB                                      |
| Containers          | Docker                                   |
| Utilities           | Curl, Wget, Htop                         |

Activate:

    astra switch --mode devmode

Common workflows:

    # Python virtual environment
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt

    # Node project
    npm init -y
    npm install

    # Go module
    go mod init myproject
    go build ./...

    # Rust project
    cargo new myproject
    cd myproject && cargo build

    # Docker
    sudo systemctl start docker
    docker run -it debian:bookworm bash

---

## ShieldMode

For: Security researchers, penetration testers, CTF players, and system
administrators who need network visibility and privacy tools.

ShieldMode provides a curated set of security and network tools. UFW
firewall is active by default and Fail2ban is running to protect the system.

Included Tools:

| Category            | Tools                                    |
|---------------------|------------------------------------------|
| Network Scanning    | Nmap                                     |
| Packet Analysis     | Tcpdump                                  |
| Network Utilities   | Netcat, Net-tools, Whois, Dnsutils       |
| Anonymity           | Tor, ProxyChains4                        |
| VPN                 | OpenVPN, WireGuard                       |
| Firewall            | UFW                                      |
| Intrusion Prevention| Fail2ban                                 |
| Antivirus           | ClamAV                                   |

Activate:

    astra switch --mode shieldmode

Common workflows:

    # Quick network scan
    nmap -sV -O 192.168.1.0/24

    # Capture packets on interface
    sudo tcpdump -i eth0 -w capture.pcap

    # Route traffic through Tor
    sudo systemctl start tor
    proxychains4 curl https://check.torproject.org

    # Update ClamAV and scan
    sudo freshclam
    clamscan -r /home

    # Check firewall status
    sudo ufw status verbose

---

## DesktopMode

For: General users who want a clean, functional desktop experience without
anything unnecessary installed.

DesktopMode is what most people would call a normal Linux desktop. KDE
Plasma provides a polished, customizable interface. The application selection
covers the essentials without bloating the system.

Included Applications:

| Category            | Application                              |
|---------------------|------------------------------------------|
| Desktop Environment | KDE Plasma                               |
| Browser             | Firefox ESR                              |
| File Manager        | Dolphin                                  |
| Text Editor         | Kate                                     |
| Terminal            | Konsole                                  |
| Calculator          | KCalc                                    |
| Network Manager     | plasma-nm                                |
| Audio               | plasma-pa                                |

Activate:

    astra switch --mode desktopmode

To install additional applications:

    sudo apt update
    sudo apt install <package-name>

---

## LabMode

For: Data scientists, machine learning engineers, researchers, and anyone
working with numerical computing or data pipelines.

LabMode sets up a Python-centric data science stack. The core scientific
Python libraries are installed system-wide. SQLite3 and Gnuplot round out
the environment for database work and quick visualization.

Included Tools:

| Category            | Tools                                    |
|---------------------|------------------------------------------|
| Array Computing     | NumPy                                    |
| Data Manipulation   | Pandas                                   |
| Visualization       | Matplotlib, Seaborn, Gnuplot             |
| Machine Learning    | Scikit-learn                             |
| Scientific Computing| SciPy                                    |
| Database            | SQLite3                                  |

Activate:

    astra switch --mode labmode

Common workflows:

    # Quick data analysis
    python3 << 'PYEOF'
    import pandas as pd
    import matplotlib.pyplot as plt
    df = pd.read_csv("data.csv")
    print(df.describe())
    df.plot()
    plt.savefig("output.png")
    PYEOF

    # SQLite database
    sqlite3 mydata.db
    .tables
    .quit

    # Virtual environment with extra packages
    python3 -m venv lab-env
    source lab-env/bin/activate
    pip install jupyter torch transformers

---

## Switching Between Modes

Your home directory and personal files are never touched during a switch.

    # Check active mode
    cat /etc/astraos/active-mode

    # Switch to any mode
    astra switch --mode devmode
    astra switch --mode shieldmode
    astra switch --mode desktopmode
    astra switch --mode labmode

    # See what a mode will install before switching
    cat /etc/astraos/profiles/devmode/packages.list
    cat /etc/astraos/profiles/shieldmode/packages.list
    cat /etc/astraos/profiles/desktopmode/packages.list
    cat /etc/astraos/profiles/labmode/packages.list
