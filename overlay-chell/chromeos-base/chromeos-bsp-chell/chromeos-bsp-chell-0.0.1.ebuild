# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="chell-cheets"

RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-glados
	chromeos-base/ec-utils
	sys-kernel/linux-firmware
	media-gfx/ply-image
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	if use chell-cheets; then
		doappid "{9F3771C2-2720-3094-3671-C1FB1CA0AE43}" "CHROMEBOOK"
	else
		doappid "{114DBB0F-4507-F7FC-99B6-4BCAB6A39725}" "CHROMEBOOK"
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Battery cut-off
	dosbin "${FILESDIR}/board_factory_reset.sh"

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs chell "${audio_config_dir}"
}
