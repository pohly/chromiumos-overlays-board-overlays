# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid cros-audio-configs udev

DESCRIPTION="Meowth board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
DEPEND=""

RDEPEND="${DEPEND}"

src_install() {
	doappid "{BA7F2ABA-8567-476F-B1CC-BC1C60404FEC}" "CHROMEBOOK"
	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs meowth "${audio_config_dir}"

	# Install platform specific config files for power_manager.
	insinto "/usr/share/power_manager/board_specific"
	doins "${FILESDIR}"/powerd_prefs/*

	# Install updated hammer keyboard keymap.
	# It should probbaly go into /lib/udev/hwdb.d but
	# unfortunately udevadm on 64 bit boxes does not check
	# that directory (it wants to look in /lib64/udev).
	insinto "${EPREFIX}/etc/udev/hwdb.d"
	doins "${FILESDIR}/61-hammer-keyboard.hwdb"

	# Install a rule tagging keyboard as internal and having updated layout
	udev_dorules "${FILESDIR}/91-hammer-keyboard.rules"

	# Install hammerd udev rules and override for chromeos-base/hammerd.
	udev_dorules "${FILESDIR}/99-hammerd.rules"
	insinto /etc/init
	doins "${FILESDIR}/hammerd.override"
}