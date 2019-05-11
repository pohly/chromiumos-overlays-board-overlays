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

get_toolchain_path() {
  local -r cros_overlay="/mnt/host/source/src/third_party/chromiumos-overlay"
  local -r sdk_ver_file="${cros_overlay}/chromeos/binhost/host/sdk_version.conf"
  local -r ctarget="$(portageq-"${BOARD}" envvar CHOST)"
  . "${sdk_ver_file}"
  local -r toolchain_path="${TC_PATH/\%\(target\)s/${ctarget}}"
  echo "${toolchain_path}"
}

write_toolchain_path() {
  local toolchain_path
  toolchain_path=$(get_toolchain_path)
  # Write toolchain path to image.
  echo "${toolchain_path}" | \
      sudo tee "${root_fs_dir}/etc/toolchain-path" > /dev/null
  # Write toolchain path to build dir so it can be exported as an artifact.
  echo "${toolchain_path}" | \
      sudo tee "${BUILD_DIR}/toolchain_path" > /dev/null
}

move_kernel_source() {
  # Move kernel source tarball to build dir so it can be exported as an
  # artifact.
  cp "${root_fs_dir}/opt/google/src/kernel-src.tar.gz" \
      "${BUILD_DIR}/kernel-src.tar.gz"
  sudo rm -rf "${root_fs_dir}/opt/google/src"
}

write_toolchain_info() {
  # Create toolchain_info file in BUILD_DIR so that it can be exported
  # as an artifact.
  local artifact="${BUILD_DIR}/toolchain_info"

  # File from which kernel compiler information will be copied
  # This file is deleted after copying content to artifact
  local toolchain_info_file="${root_fs_dir}/etc/toolchain_info"

  # Append toolchain_path to toolchain_info
  # Example for toolchain_path:
  # toolchain_path=2019/04/x86_64-cros-linux-gnu-2019.04.30.115636.tar.xz
  # Adding toolchain_path to toolchain_info in BUILD artifact
  echo "toolchain_path=$(get_toolchain_path)" > "${artifact}"

  # Copy kernel compiler info to BUILD artifact
  cat "${toolchain_info_file}" >> "${artifact}"

  # Remove toolchain_info from image
  sudo rm "${toolchain_info_file}"
}

# board_finalize_base_image() gets invoked by the build scripts at the
# end of building base image.
board_finalize_base_image() {
  local -r script_root="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
  write_toolchain_path
  move_kernel_source
  write_toolchain_info

  # /etc/machine-id gets installed by sys-apps/dbus and is a symlink.
  # This conflicts with systemd's machine-id generation mechanism,
  # so we remove the symlink and recreate it as an empty file.
  sudo rm "${root_fs_dir}"/etc/machine-id
  sudo touch "${root_fs_dir}"/etc/machine-id

  info "Deleting legacy EFI bootloaders"
  sudo rm -f "${root_fs_dir}"/boot/efi/boot/boot{x64,ia32}.efi
  info "Successfully deleted legacy EFI bootloaders"

  info "Populating dbx"
  sudo mkdir -p "${esp_fs_dir}"/efi/Google/GSetup/dbx
  sudo cp "${script_root}"/dbx/* "${esp_fs_dir}"/efi/Google/GSetup/dbx
  sudo chmod -R 755 "${esp_fs_dir}"/efi/Google/GSetup/dbx
  info "Successfully populated dbx"
}
