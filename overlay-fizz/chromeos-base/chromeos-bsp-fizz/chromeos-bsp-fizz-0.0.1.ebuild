# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="fizz-cfm"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-fizz
	chromeos-base/jabra-vold
"
DEPEND="${RDEPEND}"

src_install() {
	if use fizz-cfm; then
		doappid "{83703798-86A9-3073-D590-0D0937639CB0}" "CHROMEBOX"
	else
		doappid "{0C1E39B7-DAE6-4972-8004-E96F60D9342C}" "CHROMEBOX"
	fi

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs fizz "${audio_config_dir}"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
