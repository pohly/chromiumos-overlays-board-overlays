# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit appid

DESCRIPTION="Ebuild which pulls in any necessary ebuilds as dependencies
or portage actions."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="rikku-cfm"
S="${WORKDIR}"

# Add dependencies on other ebuilds from within this board overlay
RDEPEND="
	chromeos-base/chromeos-bsp-baseboard-jecht
	chromeos-base/jabra-vold
	media-libs/go2001-fw
	media-libs/go2001-rules
"
DEPEND="${RDEPEND}"

src_install() {
	if use rikku-cfm; then
		doappid "{4D4EA25E-B34A-4722-8665-7B7E257BD3E9}" "CHROMEBOX"
	else
		doappid "{8F55A657-819A-4F70-B178-C7E2D54D7C0C}" "CHROMEBOX"
	fi
}
