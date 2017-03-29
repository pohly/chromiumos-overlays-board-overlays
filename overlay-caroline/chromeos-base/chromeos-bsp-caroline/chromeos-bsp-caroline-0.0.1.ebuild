# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

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
	chromeos-base/chromeos-bsp-baseboard-glados
	sys-kernel/linux-firmware
	chromeos-base/chromeos-touch-config-caroline
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{C166AF52-7EE9-4F08-AAA7-B4B895A9F336}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install udev rules telling powerd not to inhibit the internal keyboard in
	# tablet mode.
	udev_dorules "${FILESDIR}/92-powerd-overrides.rules"

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs caroline "${audio_config_dir}"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
