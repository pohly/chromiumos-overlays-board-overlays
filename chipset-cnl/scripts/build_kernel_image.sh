#!/bin/bash

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  echo "i915.alpha_support=1" >> "$1"
  echo "i915.fastboot=1" >> "$1"
}
