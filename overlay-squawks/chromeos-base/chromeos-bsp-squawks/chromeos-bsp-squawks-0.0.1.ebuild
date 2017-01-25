# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Squawks private bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	doappid "{777CE760-E315-FF86-2837-D51D10BA7C52}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install audio config files.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs swanky "${audio_config_dir}"
}
