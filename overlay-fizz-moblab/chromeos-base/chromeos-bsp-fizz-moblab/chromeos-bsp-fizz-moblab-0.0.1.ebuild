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
	doappid "{BCC6E30A-D921-18E8-73D3-60177AD4AF86}" "CHROMEBOX"
}
