# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Heli bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

RDEPEND="
	chromeos-base/ec-utils
	sys-kernel/linux-firmware
"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
	doappid "{3E8F25F2-3438-46CE-85AC-4A0329A79E09}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Wiping scripts
	dosbin "${FILESDIR}"/sbin/*.sh
}
