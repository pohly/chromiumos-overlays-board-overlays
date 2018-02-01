# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit appid cros-audio-configs

DESCRIPTION="Butterfly public bsp (meta package to pull in driver/tool dependencies)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="kernel-3_8"

RDEPEND="
	!<chromeos-base/chromeos-bsp-butterfly-private-0.0.2
"

S=${WORKDIR}

src_install() {
	doappid "{6372E332-9A26-4CE3-9C39-93D8A4E383AF}" "CHROMEBOOK"

	# Install platform specific config file for power_manager
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Determine kernel version.
	local audio_config_dir="${FILESDIR}/audio-config-$(usex kernel-3_8 3_8 3_4)"
	install_audio_configs butterfly "${audio_config_dir}"
}
