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

  # Enable AppArmor by default.
  echo "security=apparmor" >> "${config_file}"

  # Turn on tx napi for the virtio_net driver.
  echo "virtio_net.napi_tx=1" >> "${config_file}"

  # Enable cgroup-v2 hybrid mode
  echo "systemd.unified_cgroup_hierarchy=false" >> "${config_file}"
  echo "systemd.legacy_systemd_cgroup_controller=false" >> "${config_file}"

  # Disable Container Security Monitor by default.
  echo "csm.disabled=1" >> "${config_file}"

  # Exclude pinning kernel modules.
  echo "loadpin.exclude=kernel-module" >> "${config_file}"

  # Load loadpin-trigger kernel module automatically on boot.
  echo "modules-load=loadpin_trigger" >> "${config_file}"

  # Enforce kernel module signature verification.
  echo "module.sig_enforce=1" >> "${config_file}"
}
