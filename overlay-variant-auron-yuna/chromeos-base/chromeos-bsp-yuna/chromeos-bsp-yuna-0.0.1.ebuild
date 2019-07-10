# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	!<chromeos-base/chromeos-bsp-auron-0.0.1-r3
	!<media-sound/adhd-0.0.2
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{FF7E5403-68B3-9E57-EE1C-A53D8AF2BAC3}" "CHROMEBOOK"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_config auron_yuna "${audio_config_dir}"
}
