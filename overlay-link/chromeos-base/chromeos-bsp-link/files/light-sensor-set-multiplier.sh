#!/bin/sh

# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

VPD_CALIBRATION_NAME=als_cal_data

#
# main
#

# Load cached calibration data.
CACHE_DIR=/var/spool/als
CACHE_FILE=${CACHE_DIR}/cal.data
if [ -e "${CACHE_FILE}" ]; then
  ALS_CAL=$(cat "${CACHE_FILE}")
else
  ALS_CAL="$(vpd_get_value "${VPD_CALIBRATION_NAME}")"
  mkdir -p "${CACHE_DIR}"
  echo "${ALS_CAL}" > "${CACHE_FILE}"
fi

# the default value
: ${ALS_CAL:=10}

# In iio/devices, find device0 on 3.0.x kernels and iio:device0 on 3.2 kernels.
# Find the first "calib" file that works.
for FILE in /sys/bus/iio/devices/*/*calib*; do
  # Set the light sensor calibration value.
  echo "${ALS_CAL}" > $FILE && break
done
