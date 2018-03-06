#!/bin/sh

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Workaround for b:35648315 where Cyan devices lose touch with the wifi NIC
# in the field. The workaround is to unbind the driver, rescan the PCI bus
# and bind the driver again. Logs from the field show that the device is
# possibly disappearing off the bus for a short while, and when it comes
# back, the pci config space is intact, but memory-mapped registers are
# not OK (reading all Fs).
# Rescanning the bus implies a memory window is allocated again.

TAG="pci-rescan"

###### Helpers

# $1: function that evaluates a condition to check for.
wait_for_true_or_time_out() {
  local count
  for count in $(seq 0 1 60); do
    if "$@"; then
      RESULT=true
      return 0
    fi
    sleep 1
  done
  return 1
}

wifi_nic_in_lspci() { [ -n "$(lspci -n -d 8086:095a)" ]; }
wlan0_present() { [ -e "/sys/class/net/wlan0" ]; }

shill_has_wlan0() {
  local count
  count=$(dbus-send --system --print-reply --dest=org.chromium.flimflam \
          /device/wlan0 \
          org.chromium.flimflam.Device.GetProperties | grep -c wlan0)
  if [ ${count} -ge 0 ]; then
    return 0
  else
    return 1
  fi
}

###### main

main() {
  # Add an UMA metric that shows the state of wifi after the rescan
  # with the following enum:
  # 0 : NIC not detected in lspci
  # 1 : NIC shows in lspci but wlan0 doesnt exist / shill doesn't know.
  # 2 : NIC shows in lspci, /sys/class/net/wlan0 exists, shill doesn't know.
  # 3 : all of (2) and shill knows about wlan0 interface.
  # Note that what the users see in the UI is based on the UI asking shill
  # for wlan0 over dbus, so 3 is the only "happy" case for users here.
  local wifi_status=0
  local buf

  # Get rid of wifi module to restart cleanly.
  modprobe -r iwlmvm iwlwifi
  logger -t ${TAG} "Starting pci bus rescan"
  echo 1 > /sys/bus/pci/rescan
  # Delay b/w rescanning pci bus and wlan0 appearining is 100-300 ms. Hence
  # sleep here to make the checks below easier.
  sleep 1

  logger -t ${TAG} "Done rescanning pci bus"

  ###### Check, log and record metric.
  if wait_for_true_or_time_out wifi_nic_in_lspci; then
    wifi_status=1
    if wait_for_true_or_time_out wlan0_present; then
      wifi_status=2
      # wlan0 has reappeared, now restart wpasupplicant
      # and shill so that they know about the new interface.
      restart wpasupplicant
      restart shill
      if wait_for_true_or_time_out shill_has_wlan0; then
        wifi_status=3
      fi
    fi
  fi

  case ${wifi_status} in
    "0")
      logger -t ${TAG} "wifi NIC did not show up in lspci:"
      logger -t ${TAG} "ROOTPORT:"
      buf="$(lspci -vvv -s 0:1c.2)"
      echo "${buf}" | logger -t ${TAG}
      logger -t ${TAG} "WIFIDEVICE (if any):"
      buf="$(lspci -vvv -s 2:0.0)"
      echo "${buf}" | logger -t ${TAG}
      ;;
    "1")
      logger -t ${TAG} "NIC seen in lspci, timed out waiting for /sys/class/net/wlan0"
      ;;
    "2")
      logger -t ${TAG} "NIC seen in lspci, wlan0 exists, timed out waiting for shill to find wlan0"
      ;;
    "3")
      logger -t ${TAG} "wlan0 functional, shill can use it"
      ;;
  esac

  logger -t ${TAG} "Sending metric: Platform.WiFiStatusAfterForcedPCIRescan: ${wifi_status}"
  metrics_client -e Platform.WiFiStatusAfterForcedPCIRescan ${wifi_status} 3
}

main
