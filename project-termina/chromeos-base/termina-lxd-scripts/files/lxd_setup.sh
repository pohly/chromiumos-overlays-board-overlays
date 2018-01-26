#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Performs first-time lxd setup if necessary.

set -eu

do_preseed() {
  cat <<EOF | lxd init --preseed >/dev/null 2>&1
# Storage pools
storage_pools:
- name: default
  driver: btrfs
  config:
    source: /mnt/stateful/lxd/storage-pools/default

# Network
# IPv4 address is configured by the host.
networks:
- name: lxdbr0
  type: bridge
  config:
    ipv4.address: none
    ipv6.address: none

# Profiles
profiles:
- name: default
  config:
    boot.autostart: false
  devices:
    root:
      path: /
      pool: default
      type: disk
    eth0:
      nictype: bridged
      parent: lxdbr0
      type: nic
    wayland-sock:
      path: /run/wayland-0
      source: /run/wayland-0
      type: disk
    wl0:
      source: /dev/wl0
      type: unix-char
EOF
}

main() {
  if ! lxc network show lxdbr0 >/dev/null 2>&1; then
    echo "Setting up LXD..."
    do_preseed
  fi

  # Now that the lxc command has been run, fix up permission for the config.
  chmod 755 "${LXD_CONF}"
}

main "$@"
