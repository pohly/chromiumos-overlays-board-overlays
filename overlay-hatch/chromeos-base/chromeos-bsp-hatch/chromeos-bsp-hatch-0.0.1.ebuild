# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/sof-binary
	chromeos-base/sof-topology
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{95EE134E-B47F-43FB-9835-32C276865F9A}" "CHROMEBOOK"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs hatch "${audio_config_dir}"
}
