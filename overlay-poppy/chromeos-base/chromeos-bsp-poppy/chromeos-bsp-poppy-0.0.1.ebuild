# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-poppy
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{C2A20B44-A80D-4028-84AB-24FAC3E38B28}" "REFERENCE"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs poppy "${audio_config_dir}"

	# Install updated hammer keyboard keymap.
	# It should probbaly go into /lib/udev/hwdb.d but
	# unfortunately udevadm on 64 bit boxes does not check
	# that directory (it wants to look in /lib64/udev).
	insinto "${EPREFIX}/etc/udev/hwdb.d"
	doins "${FILESDIR}/61-hammer-keyboard.hwdb"
}
