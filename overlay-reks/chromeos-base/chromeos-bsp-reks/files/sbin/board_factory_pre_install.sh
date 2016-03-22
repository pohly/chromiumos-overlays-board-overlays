#!/bin/bash
#
# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
. "/opt/google/memento_updater/find_omaha.sh"

shim_version="$(findLSBValue CHROMEOS_RELEASE_DESCRIPTION)"
bios_version="$(crossystem ro_fwid 2>/dev/null)"

# Get BOARD name from bios version
tmp="${bios_version%%.*}"
board_name="${tmp#Google_}"
board_name="${board_name,,}"

# Check if board_name is in shim_version
if ! [[ $shim_version == *$board_name* ]]
then
  echo ""
  echo "!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!!!Wrong factory shim!!!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!"
  echo ""
  echo "$board_name not in \"$shim_version\""
  read -p "press [enter] to power-off..."
  shutdown -h now
  sleep 15
fi

