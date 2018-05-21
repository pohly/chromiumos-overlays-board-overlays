# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid
inherit cros-model cros-unibuild

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-nami
	chromeos-base/rmi4utils
"
DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-config
"

src_install() {
	doappid "{495DCB07-E19A-4D7D-99B9-4710011A65B1}" "CHROMEBOOK"

	unibuild_install_audio_files

	insinto "/etc/bluetooth"
	doins "${FILESDIR}/common/bluetooth/main.conf"
}
