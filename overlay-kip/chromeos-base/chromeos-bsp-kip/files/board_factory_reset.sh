#!/bin/sh -e
#
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This is for findLSBValue definition, which parses options in
# lsb-factory or lsb-release.
. "/opt/google/memento_updater/find_omaha.sh"

/usr/sbin/activate_date --clean
# remove the cached vpd log file so that the next reboot will re-generate it
# in /etc/init/vpd-log.conf.
VPD_2_0="/var/log/vpd_2.0.txt"
rm -f $VPD_2_0
sync
sleep 3

/usr/sbin/board_charge_battery.sh

if [ "$(findLSBValue FACTORY_COMPLETE)" = "true" ]; then
    /usr/sbin/board_factory_complete.sh
fi
/usr/sbin/battery_cut_off.sh

# Battery cut-off is failed if it returns with 1.
if [ $? -eq 1 ]; then
    echo "Battery cut-off is failed."
fi
exit 1
