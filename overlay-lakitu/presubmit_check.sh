#!/bin/bash
#
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

readonly lakitu_files=$(echo "${PRESUBMIT_FILES}" | grep overlay-lakitu/)

if [[ -z "${lakitu_files}" ]]; then
  exit 0
fi

readonly commit_desc="$(git log --format=%s%n%n%b "${PRESUBMIT_COMMIT}^!")"

# Checks for a non empty RELEASE_NOTE= filed.
RELEASE_NOTE_RE='RELEASE_NOTE=[^[:blank:]]+'
if [[ ! "${commit_desc}" =~ ${RELEASE_NOTE_RE} ]]; then
  echo "Changelist description needs a RELEASE_NOTE= field (No space after =):"
  echo "RELEASE_NOTE=New feature"
  echo "RELEASE_NOTE=Bugfix"
  echo "RELEASE_NOTE=None"
  exit 1
fi
