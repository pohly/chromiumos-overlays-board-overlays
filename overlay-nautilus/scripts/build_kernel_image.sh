#!/bin/bash

# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  echo "i915.preliminary_hw_support=1" >> "$1"

  # Enable S0ix validation check in kernel
  echo "intel_idle.slp_s0_check=Y" >> "$1"
}
