#!/bin/bash

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  # Don't disable the ability to run VMs.
  echo "disablevmx=off" >> "$1"
  echo "snd_soc_dmic.modeswitch_delay_ms=35" >> "$1"
}
