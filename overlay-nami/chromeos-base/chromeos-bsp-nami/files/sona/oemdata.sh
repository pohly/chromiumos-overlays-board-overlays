#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Parameters for Sona.
i2c_bus="2"
slave_addr="0x0b"
ct_cmd="0x70"
data_len="15"

# mosys may use 'i2c-dev', which may not be loaded yet.
modprobe i2c-dev 2>/dev/null || true
platform_vendor="$(mosys platform vendor)"
if [ "${platform_vendor}" = "HP" ]; then
  # Get battery CT number in raw ascii form.
  # The output format is "\xHH<char_1><char_2>..<char_n>.
  oem_raw_string=$(ectool --ascii i2cxfer "${i2c_bus}" "${slave_addr}" "${data_len}" "${ct_cmd}")
  # Get the number of valid characters.
  num_chars=$(/usr/bin/printf "%d" "0$(echo "${oem_raw_string}" | cut -b 2-4)")
  # Cut off the trailing/invalid characters (if any) and output the OEM data.
  echo "${oem_raw_string}" | cut -b 5-$((4+num_chars))
fi
