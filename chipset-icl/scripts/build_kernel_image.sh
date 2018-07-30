#!/bin/bash

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  # Kernel support for ICL graphics hw is "Alpha quality"
  echo "i915.alpha_support=1" >> "$1"

  # Might be helpful to preserve ramoops in extreme circumstances
  echo "ramoops.ecc=1" >> "$1"

  # Enable console for debug
  echo "earlyprintk=uart8250,mmio32,0xfe032000,115200n8 console=uart8250,mmio32,0xfe032000,115200n8" >> "$1"
}
