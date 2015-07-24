#!/bin/bash

# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  echo "i915.enable_execlists=1 i915.preliminary_hw_support=1" >> "$1"
}
