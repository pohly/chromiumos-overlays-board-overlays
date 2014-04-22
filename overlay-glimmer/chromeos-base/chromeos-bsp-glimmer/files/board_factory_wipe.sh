#!/bin/sh -e
#
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#

/usr/sbin/activate_date --clean
# make sure the cached vpd log file has been removed so that the the next reboot
# will re-generate it in /etc/init/vpd-log.conf.
VPD_2_0="/var/log/vpd_2.0.txt"
rm -f $VPD_2_0
sync
sleep 3

#clear Battery first use date
ectool i2cwrite 16 0 0x16 0x3f 0x0000

# this script is called by clobber-state
/usr/sbin/battery_cut_off.sh

# Battery cut-off is failed if it returns with 1.
if [ $? -eq 1 ]; then
    echo "Battery cut-off is failed."
fi
exit 1

# reboot after return to clobber-state(default)
