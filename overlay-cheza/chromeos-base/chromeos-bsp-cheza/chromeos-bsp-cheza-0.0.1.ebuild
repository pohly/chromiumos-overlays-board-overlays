# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
EAPI=5

inherit appid cros-audio-configs udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-cheza
	net-libs/libqrtr
	net-misc/rmtfs
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{752826D9-391D-44BE-A5DD-D783F58A6577}" "REFERENCE"

	# Install a rule tagging keyboard as internal and having updated layout
	udev_dorules "${FILESDIR}/91-hammer-keyboard.rules"

	# TODO: Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs cheza "${audio_config_dir}"
}
