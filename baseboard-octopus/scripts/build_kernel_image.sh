#!/bin/bash

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
    # Enable S0ix logging using GSMI
    echo "gsmi.s0ix_logging_enable=1" >> "$1"
}
