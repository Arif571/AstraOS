#!/bin/bash
set -e

echo "⭐ AstraOS Build Starting..."

mkdir -p output
mkdir -p work
cd work

echo "🔧 Configuring live-build..."
lb config \
  --distribution bookworm \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --bootappend-live "boot=live components quiet splash" \
  --iso-volume "AstraOS"

echo "🏗️ Building..."
lb build 2>&1 | tee ../output/build.log

echo "📦 Collecting ISO..."
find . -name "*.iso" -exec cp {} ../output/ \;

echo "✅ Build complete!"
ls -lh ../output/
