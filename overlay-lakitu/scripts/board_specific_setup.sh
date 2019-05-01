# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This will add console=ttyS0 kernel cmdline flag, thus rerouting
# dmesg output to ttyS0 (serial port).
FLAGS_enable_serial=ttyS0

# Don't install upstart files.
INSTALL_MASK+=" /etc/init"

# Don't install symbol table for kdump kernel.
INSTALL_MASK+=" /boot/kdump/System.map-*"

# build_image script calls board_setup on the pristine base image.
board_make_image_bootable() {
  local -r image="$1"
  local -r script_root="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
  . "${script_root}/bootloader_install.sh" || exit 1
  if ! bootloader_install "${image}"; then
    error "Could not install bootloaders on ${image}"
    return 1
  fi
}

write_toolchain_path() {
  local -r cros_overlay="/mnt/host/source/src/third_party/chromiumos-overlay"
  local -r sdk_ver_file="${cros_overlay}/chromeos/binhost/host/sdk_version.conf"
  local -r ctarget="$(portageq-"${BOARD}" envvar CHOST)"
  . "${sdk_ver_file}"
  local -r toolchain_path="${TC_PATH/\%\(target\)s/${ctarget}}"
  # Write toolchain path to image.
  echo "${toolchain_path}" | \
      sudo tee "${root_fs_dir}/etc/toolchain-path" > /dev/null
  # Write toolchain path to build dir so it can be exported as an artifact.
  echo "${toolchain_path}" | \
      sudo tee "${BUILD_DIR}/toolchain_path" > /dev/null
}

move_kernel_source() {
  # Move kernel source tarball to build dir so it can be exported as an
  # artifact. If it doesn't exist, create a fake tarball to be exported.
  local tarball="${root_fs_dir}/opt/google/src/kernel-src.tar.gz"
  local artifact="${BUILD_DIR}/kernel-src.tar.gz"
  if [[ -f "$tarball" ]]; then
    cp "$tarball" "$artifact"
  else
    touch "$artifact"
  fi
  sudo rm -rf "${root_fs_dir}/opt/google/src"
}

# board_finalize_base_image() gets invoked by the build scripts at the
# end of building base image.
board_finalize_base_image() {
  write_toolchain_path
  move_kernel_source

  # /etc/machine-id gets installed by sys-apps/dbus and is a symlink.
  # This conflicts with systemd's machine-id generation mechanism,
  # so we remove the symlink and recreate it as an empty file.
  sudo rm "${root_fs_dir}"/etc/machine-id
  sudo touch "${root_fs_dir}"/etc/machine-id

  info "Deleting legacy EFI bootloaders"
  sudo rm -f "${root_fs_dir}"/boot/efi/boot/boot{x64,ia32}.efi
  info "Successfully deleted legacy EFI bootloaders"
}
