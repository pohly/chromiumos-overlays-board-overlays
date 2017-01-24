#!/bin/sh

# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This file implements a watchdog, triggered by the udev rules specified in
# '99-modem-watchdog.rules', to monitor if the built-in modem (Huawei ME936) on
# Kip is successfully picked up ModemManager within a specified amount of time
# after the modem appears on USB under USB configuration 3 (i.e.  MBIM mode).
# The watchdog will power cycle the modem upon timeout. This is a temporary
# workaround of an out-of-sync issue between the modem and the host
# (chromium:653979). The current implementation assumes only one Huawei ME936
# modem is connected to Kip over the internal M.2 slot, and thus doesn't work
# properly if multiple Huawei ME936 modems are found, which is considered a
# rare and unsupported scenario.

if [ "$1" = '--daemonize' ]; then
  shift
  setsid nohup "$0" "$@" >/dev/null 2>&1 &
  exit
fi

readonly LOG_TAG='modem-watchdog'
readonly MODEM_USB_VID_PID='12d1:15bb'
readonly LOCK_FILE=/run/lock/chromeos-kip-modem-watchdog.lock

# Empirically, it takes about ~10s on average for the modem object to show up
# in ModemManager after the modeam appears on USB. The watchdog timeout is set
# for 30s to accomodate some unexpected delay.
readonly TIMEOUT_SECONDS=30

log_info() {
  logger -t "${LOG_TAG}" --id="$$" -p info "$*"
  echo "   INFO: $*"
}

log_warning() {
  logger -t "${LOG_TAG}" --id="$$" -p warn "$*"
  echo "WARNING: $*"
}

log_error() {
  logger -t "${LOG_TAG}" --id="$$" -p err "$*"
  echo "  ERROR: $*"
}

# Powers "on" or "off" the built-in modem via EC.
#
# Copied from the powerd_suspend script provided by
# chromeos-base/power_manager. As this script is only a temporary workaroud, we
# don't bother to refactor the code for sharing.
ec_power_modem() {
  local op="$1"

  case "${op}" in
    on)
      ectool wireless 0x4 0x4
      ;;
    off)
      ectool wireless 0x0 0x4
      ;;
    *)
      log_msg "Invalid operation 'ec_power_modem ${op}'"
      return 1
      ;;
  esac

  if [ $? -eq 0 ]; then
    log_info "Powered ${op} modem"
    return 0
  else
    log_error "Failed to power ${op} modem"
    return 1
  fi
}

modem_watchdog() {
  local seconds=0
  local modem_objects

  log_info "Start waiting for modem to be ready"

  while [ "${seconds}" -lt "${TIMEOUT_SECONDS}" ]; do
    if ! lsusb -d "${MODEM_USB_VID_PID}" >/dev/null; then
      log_warning "Modem is no longer on USB; exiting watchdog"
      return 2
    fi

    modem_objects="$(mmcli --list-modems)"
    if [ $? -ne 0 ]; then
      log_warning "ModemManager isn't running? exiting watchdog"
      return 2
    fi

    if echo "${modem_objects}" | grep -iq "${MODEM_USB_VID_PID}"; then
      log_info "Found modem object for ${MODEM_USB_VID_PID}; exiting watchdog"
      return
    fi
    sleep 1
    : $((seconds += 1))
  done

  log_warning "Timed out waiting for modem to be ready; power-cycling modem"
  ec_power_modem off
  sleep .5
  ec_power_modem on
  log_info "Exiting watchdog"
  return 1
}

(
  # Ensure only one instance of modem watchdog is running at a time.
  flock -n 9 || exit 0
  modem_watchdog
) 9>"${LOCK_FILE}" || exit 0
