#!/bin/sh -e
#
# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#

# remove the cached vpd log file so that the next reboot will re-generate it
# in /etc/init/vpd-log.conf.
VPD_2_0="/var/log/vpd_2.0.txt"
rm -f $VPD_2_0
sync
sleep 3

/usr/sbin/board_charge_battery.sh

/usr/sbin/board_poweroff.sh

# Board power-off is failed if it returns with 1.
if [ $? -eq 1 ]; then
    echo "Board power-off is failed."
fi
exit 1
