#!/bin/bash

# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

install_raspberrypi_bootloader() {
  local efi_offset_sectors=$(partoffset "$1" 12)
  local efi_size_sectors=$(partsize "$1" 12)
  local efi_offset=$(( efi_offset_sectors * 512 ))
  local efi_size=$(( efi_size_sectors * 512 ))
  local efi_dir=$(mktemp -d)

  sudo mount -o loop,offset=${efi_offset},sizelimit=${efi_size} "$1" \
    "${efi_dir}"

  info "Installing firmware"
  sudo cp "${ROOT}/firmware/rpi/"* "${efi_dir}/"

  info "Creating boot configuration files"
  sudo cp "${ROOT}/boot/cmdline.txt" "${efi_dir}/"
  sudo cp "${ROOT}/boot/config.txt" "${efi_dir}/"

  info "Copying kernel.img"
  sudo cp "${ROOT}/boot/kernel.img" "${efi_dir}/"

  sudo umount "${efi_dir}"
  rmdir "${efi_dir}"
}

board_setup() {
  install_raspberrypi_bootloader "$1"
}
