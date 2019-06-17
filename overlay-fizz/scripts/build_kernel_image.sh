#!/bin/bash

# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  # disablevmx=off is set by baseboard-fizz, but since build_kernel_image.sh
  # does not support inheritance, this board-specific file overrides its
  # definition of modify_kernel_command_line (https://crbug.com/868003),
  # so include its contents here.
  echo "disablevmx=off" >> "$1"

  # Disable USB 3.0 LPM for Huddly Go
  echo "usbcore.quirks=2bd9:0011:k" >> "$1"
}
