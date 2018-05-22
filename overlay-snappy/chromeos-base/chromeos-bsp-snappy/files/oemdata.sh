#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Parameters for Alan/Bigdaddy/Chell/Snappy.
i2c_bus="4"
slave_addr="0x0b"
ct_cmd="0x70"
data_len="16"

# mosys may use 'i2c-dev', which may not be loaded yet.
modprobe i2c-dev 2>/dev/null || true
platform_vendor="$(mosys platform vendor)"
if [ "${platform_vendor}" = "HP" ]; then
  # Get battery CT number in raw form.
  # The output format is "Read bytes: <#_bytes> <byte_0> <byte_1> ... <byte_n>".
  oem_raw_string=$(ectool i2cxfer "${i2c_bus}" "${slave_addr}" "${data_len}" "${ct_cmd}")
  # Get the number of valid characters -- need to be less than ${data_len}.
  num_chars=$(/usr/bin/printf "%d" "$(echo "${oem_raw_string}" | cut -d: -f2 | cut -b -4)")
  # Get the raw CT number.
  oem_data_string=$(echo "${oem_raw_string}" | cut -d: -f2 | cut -b 5-)
  # Format the raw CT number in the form of ASCII string.
  oem_data=$(/usr/bin/printf "%b" "$(echo "${oem_data_string}" | sed -e 's/ *0x/\\\x/g')")
  # Cut off the trailing/invalid characters and output the OEM data.
  echo "${oem_data}" | cut -b 1-"${num_chars}"
fi
