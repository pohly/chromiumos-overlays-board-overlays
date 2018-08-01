#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Perform first-time container setup if necessary, and start the container
# if it isn't already running.

. /usr/share/misc/shflags

DEFINE_boolean dummy "${FLAGS_FALSE}" \
  "Dummy run. Exit successfully immediately."

DEFINE_string container_name "" \
  "The name of the container"

DEFINE_string container_token "" \
  "The garcon access token for the container"

DEFINE_string lxd_image "debian/stretch" \
  "The image to create a container from"

DEFINE_string lxd_remote "https://storage.googleapis.com/cros-containers" \
  "The LXD remote URL"

DEFINE_boolean shell "${FLAGS_FALSE}" \
  "Launch a login shell in the container when the script is complete."

DEFINE_string user "" \
  "The main user for the container"

DEFINE_string guest_private_key "" \
  "The private SSH key for the guest container"

DEFINE_string host_public_key "" \
  "The SSH public key for the CrOS host"

FLAGS "$@" || exit 1

set -e

info() {
  if [ -t 2 ]; then
    echo "run_container: info: $*" >&2
  else
    logger -p syslog.info -t "run_container" "$*"
  fi
}

warning() {
  if [ -t 2 ]; then
    echo "run_container: warning: $*" >&2
  else
    logger -p syslog.warning -t "run_container" "$*"
  fi
}

error() {
  if [ -t 2 ]; then
    echo "run_container: error: $*" >&2
  else
    logger -p syslog.err -t "run_container" "$*"
  fi
}

die() {
  error "$*"
  exit 1
}

container_exists() {
  local container_name="$1"

  lxc info "${container_name}" >/dev/null 2>&1
}

container_running() {
  local container_name="$1"

  lxc info "${container_name}" 2>&1 | grep -q "Status: Running"
}

# Add or remove a bind mount, depending on if the source is available.
container_bind_mount() {
  local container_name="$1"
  local device_name="$2"
  local source="$3"
  local dest="$4"

  # Remove an existing bind mount if the source doesn't exist.
  if lxc config device get "${container_name}" \
                           "${device_name}" \
                           source >/dev/null 2>&1; then
    if [ ! -e "${source}" ]; then
      lxc config device remove "${container_name}" \
                               "${device_name}" || \
                               die "Failed to remove ${device_name}"
    fi
  else
    if [ -e "${source}" ]; then
      lxc config device add "${container_name}" \
                            "${device_name}" \
                            disk \
                            source="${source}" \
                            path="${dest}" || \
                            die "Failed to add ${device_name}"
    fi
  fi
}

main() {
  # TODO(smbarber): Remove once setup flow is finalized. Use this option
  # to test usage of run_container.sh.
  if [ "${FLAGS_dummy}" -eq "${FLAGS_TRUE}" ]; then
    exit 0
  fi

  if [ -z "${FLAGS_container_name}" ]; then
    die "--container_name is required"
  fi

  local token_path="/run/tokens/${FLAGS_container_name}_token"
  local ssh_key_dir="/run/sshd/${FLAGS_container_name}"
  local ssh_host_key="${ssh_key_dir}/ssh_host_key"
  local ssh_authorized_keys="${ssh_key_dir}/authorized_keys"
  mkdir -p "${ssh_key_dir}"

  # If specified, put the keys into the SSH key directory, and garcon container
  # token in place.
  if [ -n "${FLAGS_guest_private_key}" ]; then
    printf "%s" "${FLAGS_guest_private_key}" > "${ssh_host_key}"
  fi
  if [ -n "${FLAGS_host_public_key}" ]; then
    printf "%s" "${FLAGS_host_public_key}" > "${ssh_authorized_keys}"
  fi

  if [ -n "${FLAGS_container_token}" ]; then
    printf "%s" "${FLAGS_container_token}" > "${token_path}"
  elif [ ! -f "${token_path}" ]; then
    warning "container token not supplied; garcon may not function"
  fi

  # Wait for tremplin to set the owner of the lxd_conf directory.
  # This will only happen on the first boot of a VM.
  local attempts=0
  while [ "$(stat -c %U "${LXD_CONF}")" != "chronos" ]; do
    if [ ${attempts} -ge 300 ]; then
      die "Timed out waiting for tremplin to set LXD_CONF owner"
    fi

    : $(( attempts += 1 ))
    sleep 0.1
  done

  if ! container_exists "${FLAGS_container_name}"; then
    if [ -z "${FLAGS_lxd_remote}" ]; then
      die "Container does not already exist; you must specify --lxd_remote"
    elif [ -z "${FLAGS_lxd_image}" ]; then
      die "Container does not already exist; you must specify --lxd_image"
    fi

    info "Container '${FLAGS_container_name}'  does not exist; creating from '${FLAGS_lxd_image}' on ${FLAGS_lxd_remote}"

    lxc remote remove "google" >/dev/null 2>&1 || true

    lxc remote add "google" "${FLAGS_lxd_remote}" --protocol=simplestreams || \
      die "Failed to add lxd remote '${FLAGS_lxd_remote}'"

    lxc init "google:${FLAGS_lxd_image}" "${FLAGS_container_name}" || \
      die "Unable to create container from image '${FLAGS_lxd_image}'"

    # Set up container token for garcon.
    lxc config device add "${FLAGS_container_name}" \
                          container_token \
                          disk \
                          source="${token_path}" \
                          path="/dev/.container_token" || \
      die "Failed to add container token"
    info "Created container '${FLAGS_container_name}'"
  fi

  # Start the container if it's not running.
  if ! container_running "${FLAGS_container_name}"; then
    # Set up or remove bind mounts as necessary.
    container_bind_mount "${FLAGS_container_name}" \
                          "container_token" \
                          "${token_path}" \
                          "/dev/.container_token"

    container_bind_mount "${FLAGS_container_name}" \
                          "sshd_config" \
                          "/usr/share/container_sshd_config" \
                          "/dev/.ssh/sshd_config"

    container_bind_mount "${FLAGS_container_name}" \
                          "ssh_host_key" \
                          "${ssh_host_key}" \
                          "/dev/.ssh/ssh_host_key"

    container_bind_mount "${FLAGS_container_name}" \
                          "ssh_authorized_keys" \
                          "${ssh_authorized_keys}" \
                          "/dev/.ssh/ssh_authorized_keys"

    lxc start "${FLAGS_container_name}" || \
      die "Failed to start container '"${FLAGS_container_name}"'"
    info "Started container '${FLAGS_container_name}'"
  fi

  lxc_exec() { lxc exec "${FLAGS_container_name}" -- "$@"; }

  # Check if user exists. If not, create the user.
  if [ -n "${FLAGS_user}" ] && \
    ! lxc_exec id -u "${FLAGS_user}" >/dev/null 2>&1; then
    lxc_exec useradd -u 1000 \
                     -s "/bin/bash" \
                     -m "${FLAGS_user}" || die "Failed to add user"

    local groups="audio cdrom dialout floppy plugdev sudo users video"
    local group
    for group in ${groups}; do
      lxc_exec usermod -aG "${group}" "${FLAGS_user}" >/dev/null 2>&1 || \
        warning "Failed to add ${FLAGS_user} to group ${group}"
    done

    lxc_exec loginctl enable-linger "${FLAGS_user}" || \
      die "Failed to enable linger"
  fi

  if [ "${FLAGS_shell}" -eq "${FLAGS_TRUE}" ]; then
    if [ -z "${FLAGS_user}" ]; then
      die "--user is required when using --shell"
    fi
    exec lxc exec "${FLAGS_container_name}" -- /bin/login -f "${FLAGS_user}"
  fi
}

main "$@"
