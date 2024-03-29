# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid
inherit cros-audio-configs
inherit cros-unibuild

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="chromeos-base/chromeos-bsp-baseboard-kukui"
DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config
"

src_install() {
	doappid "{B02960B4-54E0-42B7-92DC-F430A3DBDEFB}" "CHROMEBOOK"

	# Install Bluetooth ID override.
	unibuild_install_bluetooth_files

	# Install audio config files
	# unibuild_install_audio_files (TODO: add this to config later).
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs flapjack "${audio_config_dir}"
}
