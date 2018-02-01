# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="!<chromeos-base/chromeos-bsp-peppy-private-0.0.2"
RDEPEND="${DEPEND}
	chromeos-base/chromeos-touch-config-peppy
"

S="${WORKDIR}"

src_install() {
	doappid "{E6710DFC-3EC0-42AE-8095-733FDEA6AF18}" "CHROMEBOOK"

	# Install platform-specific ambient light sensor configuration.
	udev_dorules "${FILESDIR}/99-light-sensor.rules"
	exeinto $(get_udevdir)
	doexe "${FILESDIR}/light-sensor-set-multiplier.sh"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*
}
