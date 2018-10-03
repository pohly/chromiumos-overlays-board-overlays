# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	doappid "{E3B85B97-1771-4440-9691-D1983FEF60EB}" "CHROMEBOOK"
}
