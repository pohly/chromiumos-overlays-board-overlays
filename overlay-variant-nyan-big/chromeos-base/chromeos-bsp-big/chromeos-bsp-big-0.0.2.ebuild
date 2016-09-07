# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Big bsp (meta package to pull in driver/tool deps)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm"

DEPEND=""
RDEPEND="
	chromeos-base/chromeos-touch-config-big
	chromeos-base/ec-utils
"

S=${WORKDIR}

src_install() {
	doappid "{2FC0F0CF-1A55-DF3F-73E6-517389444085}" "CHROMEBOOK" # nyan-big

	# Install platform-specific config files for power manager
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install audio config files.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs nyan_big "${audio_config_dir}"
}
