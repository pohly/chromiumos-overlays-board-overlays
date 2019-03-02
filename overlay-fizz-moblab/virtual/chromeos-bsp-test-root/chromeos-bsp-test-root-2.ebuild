# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Chrome OS BSP virtual test package"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="chromeos-base/chromeos-test-testauthkeys"
RDEPEND="${DEPEND}
	chromeos-base/install-base-container
"
