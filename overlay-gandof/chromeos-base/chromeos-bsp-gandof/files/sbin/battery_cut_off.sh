#!/bin/bash
#
# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This script uses ectool to send command to EC to cut off the battery power.
#

IMG_PATH="/usr/share/factory/images"
TTY="/dev/tty1"

modprobe i2c_dev

# Discharge battery to ensure battery capacity in desired range
/usr/sbin/board_discharge_voltage.sh
/usr/sbin/board_charge_battery.sh

# AC power is required for battery cutoff.
if ! (ectool battery | grep -q AC_PRESENT); then
  if [ -e "${IMG_PATH}/connect_ac_batterycutoff.png" ]; then
    ply-image --clear 0x000000 "${IMG_PATH}/connect_ac_batterycutoff.png"
  else
    echo "============================================" >"$TTY"
    echo "========== Connect AC adapter now. =========" >"$TTY"
    echo "============================================" >"$TTY"
    echo "" >"$TTY"
  fi
  while [ -z "$(ectool battery | grep AC_PRESENT)" ]; do
    sleep 0.5;
  done
fi

if [ -e "${IMG_PATH}/cutting_off.png" ]; then
  ply-image --clear 0x000000 "${IMG_PATH}/cutting_off.png"
else
  echo "===============================================" >"$TTY"
  echo "==== Cutting off battery. Wait 10 seconds. ====" >"$TTY"
  echo "===============================================" >"$TTY"
fi

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
