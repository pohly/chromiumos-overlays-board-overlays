# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit appid cros-unibuild udev

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND=""
DEPEND="
        ${RDEPEND}
        chromeos-base/chromeos-config
"

src_install() {
	doappid "{E3B85B97-1771-4440-9691-D1983FEF60EB}" "CHROMEBOOK"

	# Intall a rule tagging keyboard as having updated layout
	udev_dorules "${FILESDIR}/81-sarien-keyboard.rules"

	unibuild_install_audio_files
	unibuild_install_bluetooth_files

	# Install per-board hardware features for Arc++.
	insinto /etc
	doins "${FILESDIR}/hardware_features.xml"
	dosbin "${FILESDIR}/board_hardware_features"
}
