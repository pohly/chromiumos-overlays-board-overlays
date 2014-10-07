# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Chrome OS BSP virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"

RDEPEND="chromeos-base/chromeos-bsp-mobbase
	chromeos-base/chromeos-bsp-moblab
	chromeos-base/chromeos-bsp-panther-moblab"
