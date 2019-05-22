# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Chrome OS BSP config virtual package"
HOMEPAGE="http://dev.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"

DEPEND="chromeos-base/chromeos-config-bsp-soraka"
RDEPEND="${DEPEND}"
