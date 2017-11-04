# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid
inherit cros-unibuild

DESCRIPTION="Pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-kahlee
	chromeos-base/chromeos-config
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{84B4D9E0-E317-45B0-91DF-FAF3CD8244FC}" "CHROMEBOOK"

	unibuild_install_audio_files
}
