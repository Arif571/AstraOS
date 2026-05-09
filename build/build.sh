#!/bin/bash
set -e

echo "⭐ AstraOS Build Starting..."

mkdir -p output
WORK=$(mktemp -d)
ROOTFS="$WORK/rootfs"

echo "📦 Installing tools..."
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

echo "⚙️ Configuring system..."
sudo chroot "$ROOTFS" /bin/bash -c "
  apt-get update
  apt-get install -y --no-install-recommends \
    linux-image-amd64 \
    live-boot \
    systemd-sysv \
    network-manager \
    bash \
    vim \
    curl
  apt-get clean
"

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
set timeout=5
set default=0

menuentry "AstraOS Live" {
  linux /boot/vmlinuz boot=live quiet splash
  initrd /boot/initrd.img
}
GRUB

echo "💿 Creating ISO..."
sudo grub-mkrescue -o output/astraos.iso "$WORK/iso" \
  --compress=xz

echo "✅ Done!"
ls -lh output/
sudo rm -rf "$WORK"
