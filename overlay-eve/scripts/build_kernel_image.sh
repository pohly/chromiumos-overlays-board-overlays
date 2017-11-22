#!/bin/bash

# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  echo "i915.enable_dpcd_backlight=1" >> "$1"
  echo "i915.enable_psr=0" >> "$1"
}
