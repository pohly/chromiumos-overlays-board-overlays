# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Notes:
# (1) Usage: This script gets used as a "library" from other parts of the
#     build scripts.  Specifically, the board_specific_setup.sh script sources
#     this script as part of the board_make_image_bootable() function.  The
#     "cros_make_image_bootable" script calls the board_make_image_bootable()
#     function.
# (2) In order to install GRUB2 on GPT-partitioned disks, there must be a
#     designated "BIOS boot partition".
#
#     On MBR-only disks, the disk sectors immediately following the MBR are
#     used for storing "stage 2" of GRUB2.  On GPT disks, the sectors
#     immediately after MBR are used up to hold the actual partition table.
#     In such case, a well-known GUID can be used to mark a partition as the
#     BIOS boot partition, which the grub-install command uses to store the
#     second stage of the bootloader.  For more details on BIOS boot partition,
#     see https://en.wikipedia.org/wiki/BIOS_boot_partition.
#
#     The disk layout of Lakitu is inherited from the ChromeOS disk layout,
#     which has a partition 11 for firmware and a partition 12 for legacy
#     bootloader configurations.  Since Lakitu doesn't use a custom firmware,
#     we can reuse partition 11 as the BIOS boot partition without having to
#     change the disk layout.  We continue to use partition 12 for storing
#     bootloader configurations.

IMAGE=
GRUB_DIR="boot/grub"
GRUB_TARGET="i386-pc"
GRUB_MODULES="part_gpt gptpriority test fat ext2 normal boot chain configfile
linux search search_fs_uuid search_label terminal memdisk echo biosdisk serial"

# Use partition #11 (originally meant for firmware RW) as BIOS Boot Partition.
BIOS_PART_NUM="11"
# See https://www.gnu.org/software/grub/manual/html_node/BIOS-installation.html
# for the UUID.
BIOS_PART_UUID="21686148-6449-6E6F-744E-656564454649"

ESP_DIR=""
LOOP_DEV=

cleanup() {
  if [[ -d "${ESP_DIR}" ]]; then
    if mountpoint -q "${ESP_DIR}"; then
      sudo umount "${ESP_DIR}"
    fi
    # ESP_DIR should be empty after the umount, so rmdir should work.
    rmdir "${ESP_DIR}"
  fi

  if [[ -b "${LOOP_DEV}" ]]; then
    sudo losetup --detach "${LOOP_DEV}"
  fi
}

# Installs bootloaderes on the given disk image.
#
# Args:
#   $1: absolute path to the disk image.
bootloader_install() {
  trap cleanup EXIT
  IMAGE="$1"

  info "Installing bootloaders on ${IMAGE}"

  LOOP_DEV="$(sudo losetup --find --show --partscan "${IMAGE}")"

  if ! sudo udevadm settle --timeout=10; then
    warn "Error running 'udevadm settle'"
  fi

  local -r esp_node=${LOOP_DEV}p12
  # Wait till udevd finishes the work.
  for i in {1..10}; do
    info "Probing ${esp_node}"
    if [[ -b "${esp_node}" ]]; then
      break
    fi
    sleep 1
    sudo blockdev --rereadpt "${LOOP_DEV}"
  done
  if [[ ! -b "${esp_node}" ]]; then
    error "EFI partition ${esp_node} not available"
    return 1
  fi

  ESP_DIR="$(mktemp --directory)"
  if ! sudo mount -t vfat "${esp_node}" "${ESP_DIR}"; then
    error "Could not mount EFI partition"
    return 1
  fi

  info "Installing GRUB2 ${GRUB_TARGET} on ${IMAGE}"

  if ! sudo mkdir -p "${ESP_DIR}/${GRUB_DIR}"; then
    error "Could not create dir for grub config"
    return 1
  fi

  if [[ ! -f ${ESP_DIR}/efi/boot/grub.cfg ]]; then
    error "Could not find grub.cfg from EFI installation."
    return 1
  fi

  if ! sudo sed -i -e 's|/sbin/init|/usr/lib/systemd/systemd|' \
                -e '/^set timeout=/s|=.*|=0|' \
                "${ESP_DIR}/efi/boot/grub.cfg"; then
    error "Failed to update grub configuration file."
    return 1
  fi

  # Create a minimal grub.cfg that sets up environment variables and loads the
  # configuration from EFI installation.
  cat <<EOF | sudo dd of="${ESP_DIR}/${GRUB_DIR}/grub.cfg" 2>/dev/null
# The configuration relies on |grubdisk| environment variable to find the GPT
# disk.  When booting with EFI, the efidisk module exports the env var.  In case
# of BIOS, we need to hard-code it and export.
set grubdisk=hd0
export grubdisk
configfile /efi/boot/grub.cfg
EOF

  # Mark the firmware partition as the BIOS boot partition.
  # Note that this must be done prior to running grub-install, or else the
  # grub-install command will fail.
  info "Setting BIOS boot partition ..."
  if ! sudo cgpt add -i "${BIOS_PART_NUM}" \
                     -t "${BIOS_PART_UUID}" "${LOOP_DEV}"; then
    error "Error running cgpt"
    return 1
  fi

  info "Running grub-install ..."
  if ! sudo grub-install --target="${GRUB_TARGET}" \
          --boot-directory="${ESP_DIR}/boot" \
          --modules="${GRUB_MODULES}" \
          "${LOOP_DEV}"; then
    error "Error running grub-install"
    return 1
  fi

  info "Successfully installed GRUB2 ${GRUB_TARGET} on ${IMAGE}"

  trap - EXIT
  cleanup
  info "Successfully installed bootloaders on ${IMAGE}"
}
