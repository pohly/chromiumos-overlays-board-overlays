#!/bin/bash
# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Runs all audit setup scripts.

AUDIT_DIR=/usr/share/cloud/audit

set -e

. "${AUDIT_DIR}/exclude.sh"

for script in $(ls -v "${AUDIT_DIR}"/[0-9][0-9]-*.sh) ; do
  . ${script}
done
