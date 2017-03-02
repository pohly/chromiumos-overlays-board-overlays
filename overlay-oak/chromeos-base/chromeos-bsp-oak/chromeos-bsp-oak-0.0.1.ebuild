# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE="oak-cheets"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND=""
RDEPEND="${DEPEND}
	chromeos-base/chromeos-accelerometer-init
	chromeos-base/chromeos-bsp-baseboard-oak
	sys-apps/ethtool
"

src_install() {
	if use oak-cheets; then
		doappid "{CEAE875E-929A-9522-8C07-013C13A20456}" "CHROMEBOOK"
	else
		doappid "{8D0990C8-904D-45FD-ACEB-DCCAD82EC66E}" "CHROMEBOOK"
	fi

	# install ucm config files
	insinto /usr/share/alsa/ucm
	local ucm_config="${FILESDIR}/ucm-config"
	if [[ -d "${ucm_config}" ]] ; then
		doins -r "${ucm_config}"/*
	fi

	# install cras config files
	insinto /etc/cras
	local cras_config="${FILESDIR}/cras-config"
	if [[ -d "${cras_config}" ]] ; then
			doins -r "${cras_config}"/*
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install rules to enable WoWLAN on startup.
	udev_dorules "${FILESDIR}/99-mwifiex-wowlan.rules"
}
