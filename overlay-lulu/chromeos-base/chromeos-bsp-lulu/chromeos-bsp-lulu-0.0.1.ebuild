# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="cheets"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-auron
	chromeos-base/ec-utils
	sys-kernel/linux-firmware
"
DEPEND="${RDEPEND}"

src_install() {
	if use cheets; then
		doappid "{55C5C498-838E-E1DE-7A14-21352C635C72}" "CHROMEBOOK"
	else
		doappid "{40C6BCAB-B8D4-466F-9C3C-069B8CAC36D7}" "CHROMEBOOK"
	fi

	# Install platform specific config files for power_manager.
	udev_dorules "${FILESDIR}/92-powerd-overrides.rules"
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Wiping scripts.
	dosbin "${FILESDIR}"/sbin/*.sh

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
