# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Chrome OS BSP virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/chromeos-bsp-tatl
	chromeos-base/chromeos-bsp-termina
"
