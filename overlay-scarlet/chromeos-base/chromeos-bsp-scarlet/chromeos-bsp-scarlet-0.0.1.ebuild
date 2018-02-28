# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
EAPI=4

inherit appid cros-audio-configs udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-gru
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{F1C30EB2-8429-4A18-9321-93E224753A98}" "CHROMEBOOK"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs scarlet "${audio_config_dir}"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install udev rules.
	udev_dorules "${FILESDIR}"/udev-rules/*.rules
}
