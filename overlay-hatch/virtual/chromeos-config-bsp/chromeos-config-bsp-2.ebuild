# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Chrome OS BSP config virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"

#TODO: enable chromeos-config-bsp
#DEPEND="chromeos-base/chromeos-config-bsp-hatch"
DEPEND=""
RDEPEND="${DEPEND}"
