# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE=""
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-gru
	chromeos-base/ec-utils
	media-gfx/ply-image
"
DEPEND="${RDEPEND}"

src_install() {
	doappid "{1135E05E-D537-4CC7-BAB1-865C53175AB1}" "REFERENCE"
}
