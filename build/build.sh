#!/bin/bash
set -e

echo "⭐ AstraOS Build Starting — v1.1.0..."

mkdir -p output
WORK=$(mktemp -d)
ROOTFS="$WORK/rootfs"

echo "📦 Installing build tools..."
sudo apt-get install -y --ignore-missing \
  debootstrap \
  squashfs-tools \
  xorriso \
  grub-pc-bin \
  grub-efi-amd64-bin \
  mtools \
  isolinux \
  syslinux-common

echo "🌍 Bootstrapping Debian bookworm..."
sudo debootstrap \
  --arch=amd64 \
  --variant=minbase \
  bookworm \
  "$ROOTFS" \
  http://deb.debian.org/debian/

echo "⚙️ Configuring apt sources..."
sudo tee "$ROOTFS/etc/apt/sources.list" << 'SOURCES'
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
SOURCES

echo "🔧 Installing base system..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get update

  # Base system (tanpa grub-efi & grub-pc — konflik!)
  apt-get install -y --no-install-recommends --ignore-missing \
    linux-image-amd64 \
    linux-headers-amd64 \
    live-boot \
    systemd \
    systemd-sysv \
    sudo \
    bash \
    curl \
    wget \
    git \
    vim \
    neofetch \
    htop \
    ca-certificates \
    locales \
    keyboard-configuration \
    console-setup \
    network-manager \
    firmware-linux \
    firmware-linux-nonfree \
    parted

  # Fix locale
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
  apt-get install -y locales
  locale-gen
"

echo "🖥️ Installing KDE Plasma Desktop..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --ignore-missing \
    kde-plasma-desktop \
    sddm \
    konsole \
    dolphin \
    firefox-esr \
    ark \
    kate \
    gwenview \
    kde-spectacle \
    okular \
    kcalc \
    plasma-nm \
    plasma-pa \
    powerdevil \
    bluedevil \
    packagekit \
    apt-transport-https
"

echo "🧑‍💻 Installing DevMode tools..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --ignore-missing \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    golang \
    rustc \
    cargo \
    neovim \
    tmux \
    zsh \
    docker.io \
    gdb \
    valgrind \
    strace
"

echo "🛡️ Installing ShieldMode tools..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --ignore-missing \
    nmap \
    wireshark \
    tcpdump \
    netcat-openbsd \
    tor \
    ufw \
    fail2ban \
    clamav \
    rkhunter \
    aircrack-ng \
    john \
    hashcat \
    sqlmap \
    proxychains4 \
    openvpn \
    wireguard \
    macchanger \
    net-tools \
    whois \
    dnsutils \
    hydra \
    nikto
"

echo "🔬 Installing LabMode tools..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --ignore-missing \
    python3-numpy \
    python3-pandas \
    python3-matplotlib \
    python3-sklearn \
    python3-scipy \
    python3-seaborn \
    jupyter-notebook \
    r-base \
    octave \
    gnuplot \
    sqlite3 \
    postgresql \
    python3-sqlalchemy \
    python3-requests \
    python3-bs4
"

echo "🎨 Installing Calamares GUI Installer..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y calamares 2>/dev/null || echo 'Calamares skipped'
"

echo "🎨 Applying AstraOS branding..."
sudo cp branding/motd/motd "$ROOTFS/etc/motd"
sudo cp scripts/astra "$ROOTFS/usr/local/bin/astra"
sudo chmod +x "$ROOTFS/usr/local/bin/astra"
sudo cp scripts/astra-install "$ROOTFS/usr/local/bin/astra-install"
sudo chmod +x "$ROOTFS/usr/local/bin/astra-install"
sudo mkdir -p "$ROOTFS/etc/astraos/profiles"
sudo cp -r profiles/* "$ROOTFS/etc/astraos/profiles/"
echo "astraos" | sudo tee "$ROOTFS/etc/hostname"

sudo chroot "$ROOTFS" /bin/bash -c "
  useradd -m -s /bin/bash -G sudo,audio,video,plugdev astra 2>/dev/null || true
  echo 'astra:astra' | chpasswd
  echo 'root:root' | chpasswd
  systemctl enable NetworkManager 2>/dev/null || true
  systemctl enable sddm 2>/dev/null || true
  systemctl enable ufw 2>/dev/null || true
"

sudo tee "$ROOTFS/etc/os-release" << 'OSREL'
NAME="AstraOS"
VERSION="1.1.0 (Nova)"
ID=astraos
ID_LIKE=debian
PRETTY_NAME="AstraOS 1.1.0 (Nova)"
VERSION_ID="1.1"
HOME_URL="https://github.com/Arif571/AstraOS"
SUPPORT_URL="https://github.com/Arif571/AstraOS/issues"
BUG_REPORT_URL="https://github.com/Arif571/AstraOS/issues"
OSREL

echo "🗜️ Creating squashfs..."
mkdir -p "$WORK/iso/live"
mkdir -p "$WORK/iso/boot/grub"

sudo mksquashfs "$ROOTFS" "$WORK/iso/live/filesystem.squashfs" \
  -comp xz -e boot

echo "🥾 Setting up kernel & initrd..."
KERNEL=$(ls "$ROOTFS/boot/vmlinuz-"* | head -1)
INITRD=$(ls "$ROOTFS/boot/initrd.img-"* | head -1)
sudo cp "$KERNEL" "$WORK/iso/boot/vmlinuz"
sudo cp "$INITRD" "$WORK/iso/boot/initrd.img"

echo "📝 Creating GRUB config..."
cat | sudo tee "$WORK/iso/boot/grub/grub.cfg" << 'GRUB'
set timeout=10
set default=0

insmod all_video
insmod gfxterm
terminal_output gfxterm

set color_normal=light-cyan/black
set color_highlight=black/light-cyan

menuentry "⭐ AstraOS Live — DesktopMode" {
  linux /boot/vmlinuz boot=live quiet splash
  initrd /boot/initrd.img
}

menuentry "🧑‍💻 AstraOS Live — DevMode" {
  linux /boot/vmlinuz boot=live quiet splash astra.mode=devmode
  initrd /boot/initrd.img
}

menuentry "🛡️ AstraOS Live — ShieldMode" {
  linux /boot/vmlinuz boot=live quiet splash astra.mode=shieldmode
  initrd /boot/initrd.img
}

menuentry "🔬 AstraOS Live — LabMode" {
  linux /boot/vmlinuz boot=live quiet splash astra.mode=labmode
  initrd /boot/initrd.img
}

menuentry "🔧 AstraOS — Safe Mode" {
  linux /boot/vmlinuz boot=live
  initrd /boot/initrd.img
}
GRUB

echo "💿 Creating ISO..."
sudo grub-mkrescue -o output/astraos.iso "$WORK/iso" \
  --compress=xz

echo "✅ AstraOS v1.1.0 Build Complete!"
ls -lh output/
sudo rm -rf "$WORK"
