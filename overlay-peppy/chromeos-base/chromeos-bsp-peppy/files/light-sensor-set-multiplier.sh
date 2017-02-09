#!/bin/sh

# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Sets a pre-determined calibration value for the ambient light sensor (ALS).
# The calibration value is either fetched from the VPD, determined by the
# ALS lens color set in the VPD, or set to a default value.
#

DEFAULT_VALUE=7.65
DEFAULT_VALUE_GRAY=7.65
DEFAULT_VALUE_WHITE=2.15
DEVICE_CALIBRATION_PATH=\
/sys/bus/iio/devices/iio\:device0/in_illuminance0_calibscale
VPD_CALIBRATION_NAME=als_cal_data
VPD_LENS_COLOR_NAME=light_sensor_lens_color

#
# main
#

# Look for per-device calibration data in the VPD
CALIBRATION_VALUE="$(vpd_get_value "${VPD_CALIBRATION_NAME}")"
if [ -z "${CALIBRATION_VALUE}" ]; then
  # Fall back to a default value if per-device data not available
  LENS_COLOR="$(vpd_get_value "${VPD_LENS_COLOR_NAME}")"
  case "${LENS_COLOR}" in
    "GRAY")
      CALIBRATION_VALUE=${DEFAULT_VALUE_GRAY}
      ;;
    "WHITE")
      CALIBRATION_VALUE=${DEFAULT_VALUE_WHITE}
      ;;
    *)
      CALIBRATION_VALUE=${DEFAULT_VALUE}
      ;;
  esac
fi

# Set calibration multiplier
echo "${CALIBRATION_VALUE}" > "${DEVICE_CALIBRATION_PATH}"
