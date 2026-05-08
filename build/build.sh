#!/bin/bash
set -e

echo "⭐ AstraOS Build Starting..."

mkdir -p output
mkdir -p work
cd work

echo "🔧 Configuring..."
lb config \
  --distribution bookworm \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --mirror-bootstrap "http://deb.debian.org/debian/" \
  --mirror-chroot "http://deb.debian.org/debian/" \
  --mirror-chroot-security "http://security.debian.org/debian-security/" \
  --mirror-binary "http://deb.debian.org/debian/" \
  --mirror-binary-security "http://security.debian.org/debian-security/" \
  --bootappend-live "boot=live components quiet splash" \
  --iso-volume "AstraOS"

echo "🏗️ Building ISO..."
lb build

echo "📦 Collecting ISO..."
find . -name "*.iso" | while read f; do
  echo "Found: $f"
  cp "$f" ../output/
done

echo "✅ Done!"
ls -lh ../output/
