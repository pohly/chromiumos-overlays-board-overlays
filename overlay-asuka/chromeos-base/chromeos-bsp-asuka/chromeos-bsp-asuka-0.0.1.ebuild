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
	chromeos-base/chromeos-bsp-baseboard-kunimitsu
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{7B2FC5AC-894A-5702-D00E-62E999F0AE22}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Battery cut off and Wiping scripts.
	dosbin "${FILESDIR}"/sbin/*.sh

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs asuka "${audio_config_dir}"

	# Set the powerd udev tagging rules to allow the power manager to manage the touchscreen's wake and explicitly disable it.
	udev_dorules "${FILESDIR}/92-powerd-overrides.rules"
	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
