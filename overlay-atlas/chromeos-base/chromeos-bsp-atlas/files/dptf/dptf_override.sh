#!/bin/sh
#
# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Select dptf configuration based on the following criteria.
# - CPU model name
# - dram part number prefix
#
# Documentation: go/atlas-dptf-override
#

dptf_get_override() {
  local dram_part
  local cpu_model
  local dptf_file

  cpu_model="$(uname -p | grep -o "[im][357]")"
  dram_part="$(mosys memory spd print id -s part_number | grep -om1 ^..)"

  cpu_dram="$(echo "${cpu_model}"-"${dram_part}")"

  dptf_file=""
  case "${cpu_dram}" in
    m3-K4) dptf_file="50_57_53_50.dv" ;;
    m3-MT) dptf_file="50_57_53_50.dv" ;;
    i5-K4) dptf_file="50_57_53_50.dv" ;;
    i5-MT) dptf_file="50_57_53_50.dv" ;;
    i7-K4) dptf_file="50_57_54_53.dv" ;;
    i7-MT) dptf_file="50_57_55_52.dv" ;;
  esac

  if [ ! -f "/etc/dptf/${dptf_file}" ]; then
    dptf_file=""
  fi

  echo "${dptf_file}"
}
