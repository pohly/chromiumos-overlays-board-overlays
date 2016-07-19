# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# Add dependencies on other ebuilds from within this board overlay
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
	# Give developers full sudo access.
	insinto /etc/sudoers.d
	echo "moblab ALL=NOPASSWD: ALL" > moblab-all
	insopts -m600
	doins moblab-all
}
