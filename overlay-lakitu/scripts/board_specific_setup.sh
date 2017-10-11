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

# Don't install Red Hat Shim in root filesystem.
INSTALL_MASK+=" /usr/lib/shim/shimx64.efi"

# build_image script calls board_setup on the pristine base image.
board_make_image_bootable() {
  local -r image="$1"
  local -r script_root="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
  . "${script_root}/grub_install.sh" || exit 1
  if ! grub_install "${image}"; then
    error "Could not install GRUB2 on ${image}"
    return 1
  fi
}

write_toolchain_path() {
  local -r cros_overlay="/mnt/host/source/src/third_party/chromiumos-overlay"
  local -r sdk_ver_file="${cros_overlay}/chromeos/binhost/host/sdk_version.conf"
  local -r ctarget="$(get_ctarget_from_board "${BOARD}")"
  . "${sdk_ver_file}"
  echo "${TC_PATH/\%\(target\)s/${ctarget}}" | \
      sudo tee "${root_fs_dir}/etc/toolchain-path" > /dev/null
}

# board_finalize_base_image() gets invoked by the build scripts at the
# end of building base image.
board_finalize_base_image() {
  write_toolchain_path
  # /etc/machine-id gets installed by sys-apps/dbus and is a symlink.
  # This conflicts with systemd's machine-id generation mechanism,
  # so we remove the symlink and recreate it as an empty file.
  sudo rm "${root_fs_dir}"/etc/machine-id
  sudo touch "${root_fs_dir}"/etc/machine-id
}
