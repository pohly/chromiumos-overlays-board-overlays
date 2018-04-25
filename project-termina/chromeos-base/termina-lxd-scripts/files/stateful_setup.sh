#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Sets up the stateful filesystem, if necessary.

set -eu

error() {
  if [ -t 2 ]; then
    echo "stateful_setup: error: $*" >&2
  else
    logger -p syslog.err -t "stateful_setup" "$*"
  fi
}

die() {
  error "$*"
  exit 1
}

main() {
  # If stateful is already mounted, do nothing.
  if mountpoint -q /mnt/stateful; then
    exit 0
  fi

  # Create a btrfs filesystem.
  mkfs.btrfs /dev/vdb || true # The disk may already be formatted.
  mount -o user_subvol_rm_allowed /dev/vdb /mnt/stateful \
    || die "Failed to mount stateful disk"

  exit 0
}

main "$@"
