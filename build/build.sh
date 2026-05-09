#!/bin/bash
set -e

echo "⭐ AstraOS Build Starting..."

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

echo "⚙️ Configuring base system..."
sudo chroot "$ROOTFS" /bin/bash -c "
  # Setup apt sources
  cat > /etc/apt/sources.list << 'SOURCES'
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
SOURCES

  apt-get update
  
  # Install base packages
  apt-get install -y --no-install-recommends \
    linux-image-amd64 \
    live-boot \
    systemd \
    systemd-sysv \
    network-manager \
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
    console-setup

  # Install KDE Plasma
  apt-get install -y \
    kde-plasma-desktop \
    sddm \
    firefox-esr \
    konsole \
    dolphin

  apt-get clean
"

echo "🎨 Applying AstraOS branding..."

# Copy MOTD
sudo cp branding/motd/motd "$ROOTFS/etc/motd"

# Copy astra switcher script
sudo cp scripts/astra "$ROOTFS/usr/local/bin/astra"
sudo chmod +x "$ROOTFS/usr/local/bin/astra"

# Copy profile configs
sudo mkdir -p "$ROOTFS/etc/astraos/profiles"
sudo cp -r profiles/* "$ROOTFS/etc/astraos/profiles/"

# Set hostname
echo "astraos" | sudo tee "$ROOTFS/etc/hostname"

# Create default user 'astra'
sudo chroot "$ROOTFS" /bin/bash -c "
  useradd -m -s /bin/bash -G sudo astra
  echo 'astra:astra' | chpasswd
  echo 'root:root' | chpasswd
"

# Set OS info
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

menuentry "⭐ AstraOS Live — Try without installing" {
  linux /boot/vmlinuz boot=live quiet splash
  initrd /boot/initrd.img
}

menuentry "⭐ AstraOS Live — DevMode" {
  linux /boot/vmlinuz boot=live quiet splash astra.mode=devmode
  initrd /boot/initrd.img
}

menuentry "⭐ AstraOS Live — ShieldMode" {
  linux /boot/vmlinuz boot=live quiet splash astra.mode=shieldmode
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

echo "✅ AstraOS ISO Build Complete!"
ls -lh output/
sudo rm -rf "$WORK"
