# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE="kevin-tpm2"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	>=chromeos-base/chromeos-bsp-baseboard-gru-0.0.3
	chromeos-base/chromeos-touch-config-kevin
"
DEPEND="${RDEPEND}"

src_install() {
	if use kevin-tpm2; then
		doappid "{A00D6A7E-0E93-AA5A-13D1-A0E70DB80ED0}" "CHROMEBOOK"
	else
		doappid "{92A7272A-834A-47A3-9112-E8FD55831660}" "CHROMEBOOK" # kevin
	fi

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs kevin "${audio_config_dir}"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Disable touchpad wakeup source completely
	udev_dorules "${FILESDIR}/92-powerd-overrides.rules"
}
