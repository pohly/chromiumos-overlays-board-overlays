# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid udev cros-audio-configs

DESCRIPTION="Nocturne board-specific ebuild that pulls in necessary ebuilds as
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
	doappid "{BD7F7139-CC18-49C1-A847-33F155CCBCA8}" "CHROMEBOOK"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install updated hammer keyboard keymap.
	# It should probbaly go into /lib/udev/hwdb.d but
	# unfortunately udevadm on 64 bit boxes does not check
	# that directory (it wants to look in /lib64/udev).
	insinto "${EPREFIX}/etc/udev/hwdb.d"
	doins "${FILESDIR}/61-hammer-keyboard.hwdb"

	# Override for chromeos-base/hammerd.
	insinto /etc/init
	doins "${FILESDIR}/hammerd.override"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs nocturne "${audio_config_dir}"

	# Install device specific udev rules.
	udev_dorules "${FILESDIR}"/udev/*.rules
}
