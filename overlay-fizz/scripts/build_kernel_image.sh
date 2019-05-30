#!/bin/bash

# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  # Disable USB 3.0 LPM for Huddly Go
  echo "usbcore.quirks=2bd9:0011:k" >> "$1"
}
