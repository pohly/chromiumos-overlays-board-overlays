#!/bin/bash

# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

modify_kernel_command_line() {
  # Remove the device from the PCI bus when it becomes inaccessible.
  echo "iwlwifi.remove_when_gone=1" >> "$1"
}
