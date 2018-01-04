# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
S="${WORKDIR}"

src_install() {
	doappid "{237EA087-1476-DF1E-CF8A-2A6B572380FE}" "CHROMEBOX"
}
