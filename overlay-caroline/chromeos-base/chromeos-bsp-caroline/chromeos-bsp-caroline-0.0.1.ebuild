# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="caroline-userdebug caroline-arc64"
REQUIRED_USE="caroline-userdebug? ( !caroline-arc64 )"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-glados
	sys-kernel/linux-firmware
	chromeos-base/chromeos-touch-config-caroline
"
DEPEND="${RDEPEND}"

src_install() {
	if use caroline-userdebug; then
		doappid "{D5CF3BCD-7093-49E6-8E31-0990E21730F8}" "CHROMEBOOK"
	elif use caroline-arc64; then
		doappid "{AAB07052-010F-1A82-D471-6159D122A397}" "CHROMEBOOK"
	else
		doappid "{C166AF52-7EE9-4F08-AAA7-B4B895A9F336}" "CHROMEBOOK"
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install audio configs.
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs caroline "${audio_config_dir}"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"
}
