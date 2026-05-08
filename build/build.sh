#!/bin/bash
# AstraOS ISO Build Script
set -e

echo "⭐ Building AstraOS ISO..."
echo "📋 System info:"
uname -a
lsb_release -a 2>/dev/null || true

mkdir -p output
mkdir -p work/lb
cd work/lb

echo "🔧 Configuring live-build..."
lb config \
  --distribution bookworm \
  --archive-areas "main contrib non-free non-free-firmware" \
  --bootappend-live "boot=live components quiet splash" \
  --iso-volume "AstraOS" \
  --image-name "astraos" \
  --apt-indices false \
  --apt-recommends false

echo "🏗️ Starting build..."
sudo lb build 2>&1 | tee ../../output/build.log

echo "📦 Copying ISO..."
find . -name "*.iso" -exec cp {} ../../output/ \;

echo "✅ Build complete!"
ls -lh ../../output/
