#!/bin/bash
#
# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script uses ectool to send command to EC to cut off the battery power.
#

DISPLAY_MESSAGE="/usr/sbin/display_wipe_message.sh"

modprobe i2c_dev

# Discharge battery to ensure battery capacity in desired range
/usr/sbin/board_discharge_voltage.sh
/usr/sbin/board_charge_battery.sh

# AC power is required for battery cutoff.
if [ -z "$(ectool battery | grep AC_PRESENT)" ]; then
  "${DISPLAY_MESSAGE}" "connect_ac"
  while [ -z "$(ectool battery | grep AC_PRESENT)" ]; do
    sleep 0.5;
  done
fi

"${DISPLAY_MESSAGE}" "cutting_off"

# Set chargecontrol to idle to prevent battery overcharged.
# chargecontrol discharge/idle only works when WP is disabled (before PVT).
# This is only a double check in early stages (better than nothing).
if !(crossystem sw_wpsw_boot?1 wpsw_boot?1); then
  ectool chargecontrol idle
  sleep 5
fi

ectool batterycutoff at-shutdown
shutdown -h now

exit 1