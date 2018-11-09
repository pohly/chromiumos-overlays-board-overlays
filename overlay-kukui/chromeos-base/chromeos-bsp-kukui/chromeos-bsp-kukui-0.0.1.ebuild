# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid cros-audio-configs

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="chromeos-base/chromeos-bsp-baseboard-kukui"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{50F3C95B-CA5B-4AF8-87A2-8CD19588BD12}" "CHROMEBOOK"

	# Install audio config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs kukui "${audio_config_dir}"
}
