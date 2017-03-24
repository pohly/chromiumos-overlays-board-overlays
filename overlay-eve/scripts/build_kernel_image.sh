#!/bin/bash

# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  # Limit to C1E due to b/35587084
  echo "intel_idle.max_cstate=2" >> "$1"
}
