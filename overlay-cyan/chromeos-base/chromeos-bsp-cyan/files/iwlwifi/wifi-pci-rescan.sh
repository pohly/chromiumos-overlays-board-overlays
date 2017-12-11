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

# Get rid of wifi module to restart cleanly
modprobe -r iwlmvm iwlwifi
echo 1 > /sys/bus/pci/rescan
# Delay b/w rescanning pci bus and wlan0 appearining
# is 100-300 ms. Hence sleep so that wpasupplicant
# finds wlan0 when it comes up.
sleep 1
restart wpasupplicant
restart shill

# TODO: Add a call to the metrics daemon here
logger -t "pci-rescan" "Done rescanning pci bus"
