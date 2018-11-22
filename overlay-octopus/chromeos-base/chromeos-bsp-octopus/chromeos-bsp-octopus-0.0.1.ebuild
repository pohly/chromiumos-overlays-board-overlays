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

	# Projects might support multiple panels with the same Wacom digitizer
	# chip but have different firmwares for fine-tuned performance.
	# As a result, we need a way to identify the correct firmware to update.
	# The solution is to probe VID_PID from eDP panel's EDID as a identifier
	# to search files names of firmware blobs.
	exeinto "/opt/google/touch/scripts"
	doexe "${FILESDIR}"/get_board_specific_wacom_hwid.sh

	unibuild_install_audio_files
	unibuild_install_thermal_files
}
