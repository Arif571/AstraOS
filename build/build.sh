#!/bin/bash
set -e

echo "⭐ AstraOS Build Starting — v1.0.0 Nova..."

mkdir -p output
WORK=$(mktemp -d)
ROOTFS="$WORK/rootfs"

echo "📦 Installing build tools..."
sudo apt-get install -y \
  debootstrap \
  squashfs-tools \
  xorriso \
  grub-pc-bin \
  grub-efi-amd64-bin \
  mtools

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
  apt-get update -qq
  apt-get install -y --no-install-recommends \
    linux-image-amd64 \
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
    network-manager \
    parted \
    firmware-linux-free
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
  apt-get install -y locales
  locale-gen
"

echo "🖥️ Installing KDE Plasma..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --no-install-recommends \
    kde-plasma-desktop \
    sddm \
    konsole \
    dolphin \
    firefox-esr \
    kate \
    kcalc \
    plasma-nm \
    plasma-pa \
    apt-transport-https
"

echo "🧑‍💻 Installing DevMode tools..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --no-install-recommends \
    build-essential \
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
    gdb
"

echo "🛡️ Installing ShieldMode tools..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --no-install-recommends \
    nmap \
    tcpdump \
    netcat-openbsd \
    tor \
    ufw \
    fail2ban \
    clamav \
    proxychains4 \
    openvpn \
    net-tools \
    whois \
    dnsutils
"

echo "🔬 Installing LabMode tools..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get install -y --no-install-recommends \
    python3-numpy \
    python3-pandas \
    python3-matplotlib \
    python3-sklearn \
    python3-scipy \
    python3-seaborn \
    sqlite3 \
    gnuplot
"

echo "🎨 Applying AstraOS branding..."

# MOTD
sudo cp branding/motd/motd "$ROOTFS/etc/motd"

# astra CLI tools
sudo cp scripts/astra "$ROOTFS/usr/local/bin/astra"
sudo chmod +x "$ROOTFS/usr/local/bin/astra"
sudo cp scripts/astra-install "$ROOTFS/usr/local/bin/astra-install"
sudo chmod +x "$ROOTFS/usr/local/bin/astra-install"

# Profile configs
sudo mkdir -p "$ROOTFS/etc/astraos/profiles"
sudo cp -r profiles/* "$ROOTFS/etc/astraos/profiles/"

# Logo
sudo mkdir -p "$ROOTFS/usr/share/pixmaps"
sudo cp branding/logo/astraos-logo.svg "$ROOTFS/usr/share/pixmaps/astraos-logo.svg"

# Wallpaper
sudo mkdir -p "$ROOTFS/usr/share/wallpapers/AstraOS/contents/images"
sudo cp branding/wallpaper/astraos-wallpaper.svg \
  "$ROOTFS/usr/share/wallpapers/AstraOS/contents/images/wallpaper.svg"

# SDDM theme
sudo mkdir -p "$ROOTFS/usr/share/sddm/themes/astraos"
sudo cp branding/sddm-theme/Main.qml "$ROOTFS/usr/share/sddm/themes/astraos/"
sudo cp branding/sddm-theme/theme.conf "$ROOTFS/usr/share/sddm/themes/astraos/"
sudo cp branding/wallpaper/astraos-wallpaper.svg \
  "$ROOTFS/usr/share/sddm/themes/astraos/background.svg"

# Set SDDM to use AstraOS theme
sudo mkdir -p "$ROOTFS/etc/sddm.conf.d"
sudo tee "$ROOTFS/etc/sddm.conf.d/astraos.conf" << 'SDDM'
[Theme]
Current=astraos
SDDM

# Set KDE default wallpaper
sudo mkdir -p "$ROOTFS/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc"
sudo tee "$ROOTFS/etc/skel/.config/kscreenlockerrc" << 'KDE'
[Greeter][Wallpaper][org.kde.image][General]
Image=/usr/share/wallpapers/AstraOS/contents/images/wallpaper.svg
KDE

# Hostname & OS info
echo "astraos" | sudo tee "$ROOTFS/etc/hostname"
sudo tee "$ROOTFS/etc/os-release" << 'OSREL'
NAME="AstraOS"
VERSION="1.0.0 (Nova)"
ID=astraos
ID_LIKE=debian
PRETTY_NAME="AstraOS 1.0.0 (Nova)"
VERSION_ID="1.0"
HOME_URL="https://github.com/Arif571/AstraOS"
SUPPORT_URL="https://github.com/Arif571/AstraOS/issues"
BUG_REPORT_URL="https://github.com/Arif571/AstraOS/issues"
OSREL

# Default user
sudo chroot "$ROOTFS" /bin/bash -c "
  useradd -m -s /bin/bash -G sudo,audio,video astra 2>/dev/null || true
  echo 'astra:astra' | chpasswd
  echo 'root:root' | chpasswd
  systemctl enable NetworkManager 2>/dev/null || true
  systemctl enable sddm 2>/dev/null || true
"

echo "🧹 Cleaning up to reduce size..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get clean
  apt-get autoremove -y
  rm -rf /var/cache/apt/*
  rm -rf /var/lib/apt/lists/*
  rm -rf /tmp/*
  rm -rf /usr/share/doc/*
  rm -rf /usr/share/man/*
  find /var/log -type f -delete
"

echo "🗜️ Creating squashfs..."
mkdir -p "$WORK/iso/live"
mkdir -p "$WORK/iso/boot/grub"

sudo mksquashfs "$ROOTFS" "$WORK/iso/live/filesystem.squashfs" \
  -comp xz \
  -Xbcj x86 \
  -b 1048576 \
  -e boot

echo "📊 Squashfs size: $(du -sh $WORK/iso/live/filesystem.squashfs | cut -f1)"

echo "🥾 Setting up kernel & initrd..."
KERNEL=$(ls "$ROOTFS/boot/vmlinuz-"* 2>/dev/null | head -1)
INITRD=$(ls "$ROOTFS/boot/initrd.img-"* 2>/dev/null | head -1)
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
sudo xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "ASTRAOS" \
  -o output/astraos.iso \
  "$WORK/iso"

echo "✅ AstraOS v1.0.0 Nova — Build Complete!"
ls -lh output/
sudo rm -rf "$WORK"
