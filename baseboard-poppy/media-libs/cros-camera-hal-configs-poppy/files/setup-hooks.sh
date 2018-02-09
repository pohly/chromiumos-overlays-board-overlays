# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

OV13858_EEPROM="/sys/bus/i2c/devices/i2c-INT3499:00/eeprom"

chgrp arc-camera "${OV13858_EEPROM}"
chmod 440 "${OV13858_EEPROM}"
