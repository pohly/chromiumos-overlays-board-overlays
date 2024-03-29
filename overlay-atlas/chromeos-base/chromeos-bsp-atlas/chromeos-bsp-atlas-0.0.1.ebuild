# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid
inherit cros-audio-configs
inherit udev

DESCRIPTION="Atlas board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND="
	chromeos-base/chromeos-bsp-baseboard-krabbylake
"

RDEPEND="${DEPEND}"

src_install() {
	doappid "{DB5199C7-358B-4E1F-B4F6-AF6D2DD01A38}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs atlas "${audio_config_dir}"

	# Install platform-specific internal keyboard keymap.
	# It should probably go into /lib/udev/hwdb.d but
	# unfortunately udevadm on 64 bit boxes does not check
	# that directory (it wants to look in /lib64/udev).
	insinto "${EPREFIX}/etc/udev/hwdb.d"
	doins "${FILESDIR}/61-atlas-keyboard.hwdb"

	# Intall a rule tagging keyboard as having updated layout
	udev_dorules "${FILESDIR}/61-atlas-keyboard.rules"

	# Install /etc/init/generate_rdc_update.conf, which reads DSM calibration
	# data from VPD and writes to /run/cras/rdc_update.bin
	insinto /etc/init
	doins "${FILESDIR}"/init/generate_rdc_update.conf

	# Install device-specific automatic brightness model parameters.
	insinto "/usr/share/chromeos-assets/autobrightness"
	doins "${FILESDIR}/autobrightness/model_params.json"

	# Install device-specific custom dptf profile.
	insinto "/etc/dptf"
	doins "${FILESDIR}"/dptf/*
}
