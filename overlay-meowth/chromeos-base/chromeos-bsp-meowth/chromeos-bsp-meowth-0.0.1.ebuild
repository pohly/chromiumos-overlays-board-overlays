# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid cros-audio-configs

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
	install_audio_configs nautilus "${audio_config_dir}"

	# Install a rule tagging keyboard as internal and having updated layout
	udev_dorules "${FILESDIR}/91-hammer-keyboard.rules"
}
