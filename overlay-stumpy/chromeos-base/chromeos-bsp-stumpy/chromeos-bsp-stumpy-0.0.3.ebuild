# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	!<chromeos-base/chromeos-bsp-stumpy-private-0.0.2
	chromeos-base/oem-customization
	chromeos-base/jabra-vold
"
DEPEND=""

S=${WORKDIR}

src_install() {
	doappid "{2EE05B2F-3769-43B9-B78C-792F4A027971}" "CHROMEBOX"

	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs stumpy "${audio_config_dir}"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
