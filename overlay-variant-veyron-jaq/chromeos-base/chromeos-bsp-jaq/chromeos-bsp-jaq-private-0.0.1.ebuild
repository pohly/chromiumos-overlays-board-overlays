# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Jaq bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"

DEPEND="!<chromeos-base/chromeos-bsp-jaq-private-0.0.1"
RDEPEND=""

S=${WORKDIR}

src_install() {
	doappid "{6D2E4D56-A22C-2F8F-7127-DA90A65F85E1}" "CHROMEBOOK" # veyron-jaq

	dosbin "${FILESDIR}/battery_cut_off.sh"
	dosbin "${FILESDIR}/board_charge_battery.sh"
	dosbin "${FILESDIR}/board_factory_reset.sh"
	dosbin "${FILESDIR}/board_factory_wipe.sh"

	insinto "/usr/share/factory/images"
	doins "${FILESDIR}/charging.png"
	doins "${FILESDIR}/connect_ac.png"
	doins "${FILESDIR}/cutoff_failed.png"
	doins "${FILESDIR}/cutting_off.png"
	doins "${FILESDIR}/remove_ac.png"
}
