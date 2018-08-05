#!/bin/bash

# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Downloads and installs the MLO and copies u-boot to the ESP.
# This is used combined with a hybrid MBR to allow booting
# a Beaglebone from microSD only.
install_sama5d3_bootloader() {
  local efi_offset_sectors=$(partoffset "$1" 12)
  local efi_size_sectors=$(partsize "$1" 12)
  local efi_offset=$(( efi_offset_sectors * 512 ))
  local efi_size=$(( efi_size_sectors * 512 ))
  local mount_opts=loop,offset=${efi_offset},sizelimit=${efi_size}
  local efi_dir=$(mktemp -d)

  sudo mount -o "${mount_opts}"  "$1" "${efi_dir}"

  sudo cp "${BOARD_ROOT}/firmware/u-boot.img" "${efi_dir}/"
  sudo cp "${BOARD_ROOT}/firmware/boot.bin" "${efi_dir}/BOOT.BIN"
  sudo cp "${BOARD_ROOT}/boot/dts/at91-sama5d3_xplained.dtb" "${efi_dir}/"

  sudo umount "${efi_dir}"
  rmdir "${efi_dir}"
}

board_setup() {
  install_sama5d3_bootloader "$1"
}

skip_blacklist_check=1
