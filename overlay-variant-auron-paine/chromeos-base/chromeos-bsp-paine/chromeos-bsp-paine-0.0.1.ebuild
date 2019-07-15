# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="kernelnext"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	!<chromeos-base/chromeos-bsp-auron-0.0.1-r3
	!<media-sound/adhd-0.0.2
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{0AA3F9E1-A088-9252-50B8-5A1345D09AEB}" "CHROMEBOOK"

	# Install Bluetooth ID override.
	insinto "/etc/bluetooth"
	doins "${FILESDIR}/main.conf"

	# Install audio config files
	if use kernelnext; then
		local audio_config_dir="${FILESDIR}/kernelnext-audio-config"
	else
		local audio_config_dir="${FILESDIR}/audio-config"
	fi
	install_audio_configs auron_paine "${audio_config_dir}"
}
