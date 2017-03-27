# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid

DESCRIPTION="Tiger bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"

RDEPEND=""
DEPEND=""

S=${WORKDIR}

src_install() {
	doappid "{549D848C-2674-F41D-AE75-E163F8612099}" "CHROMEBASE" # veyron-tiger

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth/"
	doins "${FILESDIR}/main.conf"
}
