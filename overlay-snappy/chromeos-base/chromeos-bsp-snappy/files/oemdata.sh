#!/bin/sh
# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# mosys may use 'i2c-dev', which may not be loaded yet.
modprobe i2c-dev 2>/dev/null || true
platform_vendor="$(mosys platform vendor)"
if [ "${platform_vendor}" = "HP" ]; then
  # Displays battery CT number.
  ectool i2cxfer 4 0x0b 16 0x70
fi
