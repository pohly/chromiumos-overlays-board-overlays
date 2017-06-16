# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Enables serial login in dev mode"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /etc/init
	doins "${FILESDIR}"/console-ttyS0.conf
}
