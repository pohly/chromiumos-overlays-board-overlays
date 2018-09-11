#!/bin/bash
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Waits until 'user-data' metadata key is accessible or $TIMEOUT_SECS seconds
# have elapsed. Does nothing if cloud-init is configured for nocloud mode.
TIMEOUT_SECS=3600


if grep -E " ds=nocloud( |;)" /proc/cmdline; then
  echo "cloud-init is configured for nocloud; not waiting for instance metadata"
  exit 0
fi

i=0
while  [ $i -lt $TIMEOUT_SECS ]
do
  if /usr/share/google/get_metadata_value attributes/user-data > /dev/null
  then
    exit 0
  fi
  i=$(( i+1 ))
  sleep 1
done
echo "Timed out waiting for attributes/user-data" 1>&2
