#!/bin/sh
#
# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Script to gather necessary FPC related binaries to deploy within
# libfp-gru & libfp-gru-test packages

generate_libfp_gru_test() {
  local version="$1"
  local tball_name="libfp-gru-test-${version}.tbz2"
  local tball_path="/tmp/${tball_name}"
  tar cjf "${tball_path}" \
    usr/bin/ict \
    usr/bin/stt \
    usr/sbin/fptest

  #gsutil.py cp -a public-read "${tball_path}" \
  # "gs://chromeos-localmirror/distfiles/${tball_name}"
  echo "${tball_name}"
}

generate_libfp_gru() {
  local version="$1"
  local tball_name="libfp-gru-${version}.tbz2"
  local tball_path="/tmp/${tball_name}"
  mv usr/lib/libfpalgorithm.pic.a usr/lib/libfpalgorithm.a
  tar cjf "${tball_path}" \
    usr/lib/libfpalgorithm.a \
    usr/lib/libfpsensor.so.0

  #gsutil.py cp -a public-read "${tball_path}" \
  #  "gs://chromeos-localmirror/distfiles/${tball_name}"
  echo "${tball_name}"
}

generate_libfp_gru_test "$1"
generate_libfp_gru "$1"
