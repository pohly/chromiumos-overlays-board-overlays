# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies or portage actions"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /etc
	doins "${FILESDIR}"/resolv.conf

	insinto /etc/init
	doins "${FILESDIR}"/init/*.conf
}
