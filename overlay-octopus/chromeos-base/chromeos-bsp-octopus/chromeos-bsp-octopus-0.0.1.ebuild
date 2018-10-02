# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

inherit appid
inherit cros-model cros-unibuild

DESCRIPTION="Octopus board-specific ebuild that pulls in necessary ebuilds as
dependencies or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-octopus
"
DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config
"

src_install() {
	doappid "{9A3BE5D2-C3DC-4AE6-9943-E2C113895DC5}" "CHROMEBOOK"

	# Install Bluetooth ID override.
	insinto /etc/bluetooth
	doins "${FILESDIR}"/main.conf

	unibuild_install_audio_files
	unibuild_install_thermal_files
}
