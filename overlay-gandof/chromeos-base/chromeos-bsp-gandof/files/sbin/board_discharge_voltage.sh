#!/bin/bash
#
# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script checks the voltage level is high enough for shipping. If not,
# it asks for AC power and waits for the battery to charge.
#

MAX_LEVEL=11400
DISPLAY_MESSAGE="/usr/sbin/display_wipe_message.sh"

get_voltage() {
    ectool battery 2>/dev/null \
    | awk '/Present voltage/ {print int($3)}'
}

# Needed by 'ectool battery'.
mkdir -p /var/lib/power_manager

if [[ $(get_voltage) -gt $MAX_LEVEL ]]; then
  if (ectool battery | grep -q AC_PRESENT); then
    # If WP enabled, unplugging AC is the only way to discharge.
    if (crossystem sw_wpsw_boot?1 wpsw_boot?1); then
      "${DISPLAY_MESSAGE}" "remove_ac"
      while (ectool battery | grep -q AC_PRESENT) ; do
        sleep 0.5;
      done
    else
      ectool chargecontrol discharge
    fi
  fi

  # Wait for voltage to discharge to MAX_LEVEL.
  while [[ $(get_voltage) -gt $MAX_LEVEL ]]; do
    "${DISPLAY_MESSAGE}" "discharging_voltage" "$(get_voltage)" "${MAX_LEVEL}"
    sleep 1
  done

  # Set chargecontrol from discharge to idle if AC
  # is still connected (when WP is disabled).
  if (ectool battery | grep -q AC_PRESENT); then
    ectool chargecontrol idle
  fi
fi