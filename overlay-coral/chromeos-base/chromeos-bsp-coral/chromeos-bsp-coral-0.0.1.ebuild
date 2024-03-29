# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid
inherit cros-unibuild

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="chromeos-base/chromeos-bsp-baseboard-coral"
DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config
"

src_install() {
	doappid "{5A3AB642-2A67-470A-8F37-37E737A53CFC}" "CHROMEBOOK"

	unibuild_install_audio_files
	unibuild_install_bluetooth_files
	unibuild_install_thermal_files

	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/common/powerd/*
}
