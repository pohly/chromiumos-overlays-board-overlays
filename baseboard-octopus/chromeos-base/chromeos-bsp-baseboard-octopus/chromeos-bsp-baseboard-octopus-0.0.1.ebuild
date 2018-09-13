# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid
inherit cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="sof"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	sof? (
		chromeos-base/sof-binary
		chromeos-base/sof-topology
	)
"
DEPEND="${RDEPEND}"

src_install() {
	if  use sof ; then
		# Install audio config files
		local audio_config_dir="${FILESDIR}/audio-config"
		install_audio_configs octopus "${audio_config_dir}"
	fi
}
