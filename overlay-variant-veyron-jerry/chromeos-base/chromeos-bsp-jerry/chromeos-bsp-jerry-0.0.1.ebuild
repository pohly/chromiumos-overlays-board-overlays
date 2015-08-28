# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Jerry bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"

DEPEND="!<chromeos-base/chromeos-bsp-jerry-private-0.0.1"
RDEPEND=""

S=${WORKDIR}

src_install() {
	doappid "{87C6D674-9385-6143-BE67-8B5E3064E89D}" "CHROMEBOOK" # veyron-jerry

	dosbin "${FILESDIR}/battery_cut_off.sh"
	dosbin "${FILESDIR}/board_charge_battery.sh"
	dosbin "${FILESDIR}/board_factory_reset.sh"
	dosbin "${FILESDIR}/board_factory_wipe.sh"
	dosbin "${FILESDIR}/display_wipe_message.sh"
}
