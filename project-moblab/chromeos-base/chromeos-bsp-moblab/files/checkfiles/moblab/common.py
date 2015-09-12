# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Common lib for moblab checkfiles."""

from __future__ import print_function


#
# Boto file constants.
#
BOTO_PATH = '/home/moblab/.boto'

#
# disk_check constants.
#
DISK_SIZE_BYTES = 32000000000

MOBLAB_LABEL = 'MOBLAB-STORAGE'

STATEFUL_MOUNTPOINT = '/mnt/stateful_partition'
MOBLAB_MOUNTPOINT = '/mnt/moblab'
MOBLAB_FILESYSTEM = 'ext4'

DISK_FREE_THRESHOLD_PERCENT = 0.1

#
# Networking constants.
#
MOBLAB_SUBNET_ADDR = '192.168.231.1'
