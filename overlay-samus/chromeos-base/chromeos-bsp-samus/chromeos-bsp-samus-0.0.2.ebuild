# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="samus-cheets samus-kernelnext"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-accelerometer-init
	chromeos-base/chromeos-touch-config-samus
	chromeos-base/ec-utils
	chromeos-base/genius-app-data-samus
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	if use samus-cheets; then
		doappid "{FFF4E98C-0E01-EBE0-7D68-20E395E36AC5}" "CHROMEBOOK"
	elif use samus-kernelnext; then
		doappid "{A0835D9A-14EE-11E9-A27A-E38AF0F07D14}" "CHROMEBOOK"
	else
		doappid "{F67500C1-C6D8-5287-E4EC-F9BBB4AEE5C5}" "CHROMEBOOK"
	fi

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*
	insinto "/etc/init"
	doins "${FILESDIR}"/ec-report-panic-data.conf

	# Install rt5677 codec DSP firmware.
	insinto "/lib/firmware"
	doins "${FILESDIR}"/rt5677_elf_vad

	# Install Bluetooth ID Override
	insinto "/etc/bluetooth"
	doins "${FILESDIR}"/main.conf

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs samus "${audio_config_dir}"
}
