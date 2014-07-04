# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Winky bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-pcserial"
S="${WORKDIR}"

RDEPEND="
	chromeos-base/ec-utils
	pcserial? ( chromeos-base/serial-tty )
	sys-kernel/linux-firmware
	media-gfx/ply-image
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{4B8B5979-526A-48D6-B6EB-D72680471AAD}"

	# Battery cut-off
	dosbin "${FILESDIR}/battery_cut_off.sh"
	dosbin "${FILESDIR}/board_factory_wipe.sh"
	dosbin "${FILESDIR}/board_factory_reset.sh"
	dosbin "${FILESDIR}/board_charge_battery.sh"

	insinto "/usr/share/factory/images"
	doins "${FILESDIR}/remove_ac.png"
	doins "${FILESDIR}/cutting_off.png"
	doins "${FILESDIR}/cutoff_failed.png"
	doins "${FILESDIR}/charging.png"
	doins "${FILESDIR}/connect_ac.png"
}
