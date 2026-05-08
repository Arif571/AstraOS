#!/bin/bash
# AstraOS ISO Build Script
set -e

echo "⭐ Building AstraOS ISO..."

mkdir -p output
mkdir -p work/lb

cd work/lb

lb config \
  --distribution bookworm \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer live \
  --bootappend-live "boot=live components quiet splash" \
  --iso-volume "AstraOS" \
  --image-name "astraos"

lb build 2>&1 | tee ../../output/build.log

cp *.iso ../../output/ 2>/dev/null || true

echo "✅ Build complete! Check output/ folder"
