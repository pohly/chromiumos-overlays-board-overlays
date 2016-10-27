# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
S="${WORKDIR}"

RDEPEND="
	x11-drivers/mali-rules
	media-libs/media-rules
"
DEPEND="${RDEPEND}"

src_install() {
    # Install audio config files
    local audio_config_dir="${FILESDIR}/audio-config"
    install_audio_configs gru "${audio_config_dir}"
}
