# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Although this package is not a dependency of virtual/target-os, it is
# requried for signer test to create a recovery image so the the test will
# pass. See crrev/c/439390 for more details.

EAPI=5

DESCRIPTION=""
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/chromeos-init-systemd"
