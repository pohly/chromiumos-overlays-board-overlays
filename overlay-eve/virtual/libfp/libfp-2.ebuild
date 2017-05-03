# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for fingerprint support libraries"
SRC_URI=""

SLOT="0"
KEYWORDS="-* amd64 x86"

RDEPEND="chromeos-base/libfp-eve"
DEPEND="${RDEPEND}"
