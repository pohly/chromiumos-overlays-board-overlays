# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-kunimitsu
	chromeos-base/ec-utils
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{7B2FC5AC-894A-5702-D00E-62E999F0AE22}" "CHROMEBOOK"
}
