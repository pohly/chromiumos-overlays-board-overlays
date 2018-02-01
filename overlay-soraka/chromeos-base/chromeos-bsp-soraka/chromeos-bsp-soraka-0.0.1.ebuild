# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid cros-audio-configs udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-poppy
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{55DA7A1B-DCE6-47E6-95EC-0CCB7AC432F5}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs soraka "${audio_config_dir}"

	# Install a rule tagging keyboard as internal
	udev_dorules "${FILESDIR}/91-hammer-keyboard.rules"

	# Install hammerd udev rules and override for chromeos-base/hammerd.
	udev_dorules "${FILESDIR}/99-hammerd.rules"
	insinto /etc/init
	doins "${FILESDIR}/hammerd.override"

	# Install Bluetooth ID override.
	insinto /etc/bluetooth
	doins "${FILESDIR}/main.conf"
}
