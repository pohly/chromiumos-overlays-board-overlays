# Copyright 2015 The Chromium OS Authors. All rights reserved.
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
	chromeos-base/chromeos-bsp-baseboard-auron
	chromeos-base/ec-utils
	sys-kernel/linux-firmware
	media-gfx/ply-image
	media-libs/go2001-fw
	media-libs/media-rules
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{B801E98B-4AB6-4D82-B3B3-E1517DC53266}"
	dosbin "${FILESDIR}/board_factory_wipe.sh"
	dosbin "${FILESDIR}/board_factory_reset.sh"

	# Install audio_config files
	local audio_config_dir="${FILESDIR}/audio-config"
	install_audio_configs buddy "${audio_config_dir}"
}
