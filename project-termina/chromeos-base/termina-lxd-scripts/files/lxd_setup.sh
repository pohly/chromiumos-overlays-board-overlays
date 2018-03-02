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
    host-ip:
      path: /dev/.host_ip
      source: /run/host_ip
      type: disk
    wayland-sock:
      path: /dev/.wayland-0
      source: /run/wayland-0
      type: disk
    wl0:
      source: /dev/wl0
      type: unix-char
      mode: 0666
EOF
}

main() {
  if ! lxc network show lxdbr0 >/dev/null 2>&1; then
    echo "Setting up LXD..."
    do_preseed
  fi

  # Migration: add 0666 mode to default profile for /dev/wl0.
  lxc profile device set default wl0 mode 0666

  # Migration: add host-ip device to default profile.
  if ! lxc profile device get default host-ip source; then
    lxc profile device add default host-ip disk \
        source=/run/host_ip path=/dev/.host_ip
  fi

  # Now that the lxc command has been run, fix up permission for the config.
  chmod 755 "${LXD_CONF}"
}

main "$@"
