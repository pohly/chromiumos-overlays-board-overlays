# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# dev-lang/python is blacklisted by the build scripts. The following
# flag makes them ignore the blacklist.
skip_blacklist_check=1

# This will add console=ttyS0 kernel cmdline flag, thus rerouting
# dmesg output to ttyS0 (serial port).
FLAGS_enable_serial=ttyS0

# Remove systemd paths from all INSTALL_MASKs
for var in $(compgen -v |grep INSTALL_MASK); do
  local mask=${!var}
  mask=$(echo $mask | sed -re 's| (/usr)?/lib/systemd | |g')
  eval "$var='${mask}'"
done

# Don't install upstart files.
INSTALL_MASK+=" /etc/init"

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
  local -r ctarget="$(get_ctarget_from_board "${BOARD}")"
  . "${sdk_ver_file}"
  local -r toolchain_path="${TC_PATH/\%\(target\)s/${ctarget}}"
  # Write toolchain path to image.
  echo "${toolchain_path}" | \
      sudo tee "${root_fs_dir}/etc/toolchain-path" > /dev/null
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

write_toolchain_env() {
  # Create toolchain_env file in BUILD_DIR so that it can be exported
  # as an artifact.
  local artifact="${BUILD_DIR}/toolchain_env"

  # File from which kernel compiler information will be copied
  # This file is deleted after copying content to artifact
  local toolchain_env_file="${root_fs_dir}/etc/toolchain_env"

  # Copy kernel compiler info to BUILD artifact
  cp "${toolchain_env_file}" "${artifact}"

  # Remove toolchain_env from image
  sudo rm "${toolchain_env_file}"
}

# board_finalize_base_image() gets invoked by the build scripts at the
# end of building base image.
board_finalize_base_image() {
  local -r script_root="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
  write_toolchain_path
  move_kernel_source
  write_toolchain_env

  # /etc/machine-id gets installed by sys-apps/dbus and is a symlink.
  # This conflicts with systemd's machine-id generation mechanism,
  # so we remove the symlink and recreate it as an empty file.
  sudo rm "${root_fs_dir}"/etc/machine-id
  sudo touch "${root_fs_dir}"/etc/machine-id

  info "Copying shim to bootx64.efi"
  sudo cp \
    "${root_fs_dir}"/boot/efi/boot/shimx64.efi \
    "${root_fs_dir}"/boot/efi/boot/bootx64.efi
  info "Successfully copied shim to bootx64.efi"

  info "Deleting legacy EFI bootloaders"
  # Don't delete bootx64.efi here, since the shim is now there
  sudo rm -f "${root_fs_dir}"/boot/efi/boot/bootia32.efi
  info "Successfully deleted legacy EFI bootloaders"

  info "Populating dbx"
  sudo mkdir -p "${esp_fs_dir}"/efi/Google/GSetup/dbx
  sudo cp "${script_root}"/dbx/* "${esp_fs_dir}"/efi/Google/GSetup/dbx
  sudo chmod -R 755 "${esp_fs_dir}"/efi/Google/GSetup/dbx
  info "Successfully populated dbx"
}
