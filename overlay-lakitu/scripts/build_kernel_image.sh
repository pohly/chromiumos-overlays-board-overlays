#!/bin/bash

# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Arguments:
#   $1 - Configuration file containing boot args.
modify_kernel_command_line() {
  local config_file="$1"
  # Lakitu boards currently use GRUB2 with BIOS.  In ChromeOS tree, GRUB2 is
  # almost always associated with EFI, so we trick everyone into believing that
  # Lakitu uses EFI.  Specifically, the image signers (at image build time) and
  # the post-installer (during auto-updates) rely on presence of 'cros_efi' in
  # the kernel commandline to infer the bootloader type.
  # See
  # https://www.chromium.org/chromium-os/chromiumos-design-docs/disk-format#TOC-Which-kernel-
  sed -i -e 's/cros_secure/cros_efi/g' "${config_file}"

  # Add vsyscall=emulate to command-line. Chromeos kernel defaults to
  # vsyscall=none, but Lakitu users can run containers with old glibc which has
  # dependency on vsyscall.
  echo "vsyscall=emulate" >> "${config_file}"

  # Enable AppArmor by default.
  echo "security=apparmor" >> "${config_file}"
}
