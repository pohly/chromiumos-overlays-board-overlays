#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Performs first-time lxd setup if necessary.

set -eu

info() {
  if [ -t 2 ]; then
    echo "lxd_setup: info: $*" >&2
  else
    logger -p syslog.info -t "lxd_setup" "$*"
  fi
}

error() {
  if [ -t 2 ]; then
    echo "lxd_setup: error: $*" >&2
  else
    logger -p syslog.err -t "lxd_setup" "$*"
  fi
}

die() {
  error "$*"
  exit 1
}

do_preseed() {
  local preseed_config="
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
    cros_containers:
      path: /opt/google/cros-containers
      source: /opt/google/cros-containers
      type: disk
    garcon:
      path: /opt/google/garcon
      source: /opt/google/cros-containers
      type: disk
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
"

  echo "${preseed_config}" | lxd init --preseed >/dev/null 2>&1 || \
    die "Failed to configure LXD"
}

main() {
  if ! lxc network show lxdbr0 >/dev/null 2>&1; then
    info "Performing initial LXD setup"
    do_preseed
  fi

  # Migration: add 0666 mode to default profile for /dev/wl0.
  lxc profile device set default wl0 mode 0666 || die "Failed to add /dev/wl0"

  # Migration: add host-ip device to default profile.
  if ! lxc profile device get default host-ip source; then
    lxc profile device add default host-ip disk \
        source=/run/host_ip path=/dev/.host_ip || die "Failed to add host_ip"
  fi

  # Migrations: add cros_containers and garcon bind mounts.
  # TODO(smbarber): remove garcon once LXD is uprevved.
  if ! lxc profile device get default garcon source; then
    lxc profile device add default garcon disk \
        source=/opt/google/cros-containers path=/opt/google/garcon || \
      die "Failed to add garcon bind mount"
  fi

  if ! lxc profile device get default cros_containers source; then
    lxc profile device add default cros_containers disk \
        source=/opt/google/cros-containers path=/opt/google/cros-containers || \
      die "Failed to add cros_containers bind mount"
  fi

  # Migration: remove wayland`sock
  if lxc profile device get default wayland-sock source; then
    lxc profile device remove default wayland-sock
  fi

  # Now that the lxc command has been run, fix up permission for the config.
  chmod 755 "${LXD_CONF}"
  chown -R chronos:chronos "${LXD_CONF}"
}

main "$@"
