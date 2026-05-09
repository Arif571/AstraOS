#!/bin/bash
# Dipanggil dari build.sh untuk buat ISO
ISO_DIR=$1
OUTPUT=$2

sudo xorriso -as mkisofs \
  -r \
  -V "AstraOS" \
  -J -l \
  -o "$OUTPUT" \
  "$ISO_DIR"
