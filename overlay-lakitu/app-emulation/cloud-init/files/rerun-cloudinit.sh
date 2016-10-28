#!/bin/sh

# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script is for rerunning cloud-init without rebooting the VM instance.
# Only the modules with "always" run frequency will be executed.
#
# Note: Run the script as root.

rm -f /var/lib/cloud/instance/obj.pkl
rm -f /var/lib/cloud/data/no-net
/usr/bin/cloud-init init
/usr/bin/cloud-init modules --mode=config
/usr/bin/cloud-init modules --mode=final
